var tempSelectedRecords;
var list;
$( document ).ready(function() {

//Onload do a ajax call and retrieve the records
$.ajax({
	type : "POST",
	url : "/SpringMVC/configuration",	
	success : function(response) {
		// we have the response
		
		list = response.records;
		
		//Call the function to populate the dropdowns
		populateDropdowns();		
	},
	error : function(e) {
		alert('Error: ' + e);
	}
});
});

Array.prototype.unique = function() {
    var seen = {};
    return this.filter(function(item) {
        return seen.hasOwnProperty(item) ? false : (seen[item] = true);
    });
};

function iif(value, def) {
    return value ? value : def;
}

function populateSelect(select, options) {
    select
        .empty()
        .append(
            options.map(function(item) {
                return '<option value="' + item + '">' + item + '</option>';
            })
        );
    select.multiselect('rebuild');
}

function newExtraUser(scores) {
    var r = '<tr>';
    if (typeof scores === 'undefined') {
        for (var i = 0; i <= colCount; i++) {
            r += '<td><input type="text" /></td>';
        }
    }
    else {
        for (var i = 0; i <= colCount; i++) {
            r += '<td><input type="text" value="'+ scores[i] +'" /></td>';
        }
    }
    r += "</tr>";
    return r;
}

//For Loading and Merging the UPID from from File and the filter
function loadScoresFile(files) {
    var file = files[0];
    if (file) {
        if (window.FileReader) {
            var reader = new window.FileReader();
            reader.onload = function(e) {
                var content = e.target.result,
                    students = content.split('\r\n'), // String Split by CR LF
                    rows = '',
                    rowsDiscarded = false;
                var $usersRows =
                    $('#filteredStudents')
                        .add('#extraStudents')
                        .children();
                var usernames = $.map($usersRows.children(':first-child'),
                    function(item) {
                        var $item = $(item);
                        var text = $item.text();
                        return (text ? text : $item.children().val()).toLowerCase();
                    });
                var $extraStudents = $('#extraStudents');
                
                for (var i = 0, len = students.length; i < len; i++) {
                    var student = students[i];
                    if (student) {
                        var scores = student.split(',');
                        if (scores.length - 1 === colCount) {
                            var index = usernames.indexOf(scores[0].toLowerCase());
                            if (index !== -1) {
                                var $scoreInputs = $usersRows.eq(index).children(':not(:first-child)').children();
                                for (var j = 0, lenj = $scoreInputs.length; j < lenj; j++) {
                                    $scoreInputs.eq(j).val(scores[j + 1]);
                                }
                            }
                            else {
                                var row = $(newExtraUser(scores));
                                $extraStudents.append(row);
                                $usersRows.add(row);
                                usernames.push(scores[0].toLowerCase());
                            }
                        }
                        else {
                            rowsDiscarded = true;
                        }
                    }
                }
                if (rowsDiscarded) {
                    alert('Some records do not match the existing format and have been discarded. ' +
                        'Please correct and reupload the file');
                }
            };
            reader.readAsText(file);
        }
        else {
            alert('File Reader not supported in your browser.');
        }
    }
    else {
        alert('Failed to load file');
    }
    //files[0]
}


function getScoresFile(files) {
    var file = files[0];
    if (file) {
        if (window.FileReader) {
            var reader = new window.FileReader();
            reader.onload = function(e) {
                var content = e.target.result;
                var students = content.split('\r\n'); // String Split by CR LF
                console.log(students);
                var rows = '';
                for (var i = 1, len = students.length; i < len; i++) {
                    var student = students[i];
                    if (student) {
                        var scores = student.split(',');
                        if (scores.length - 1 !== colCount) {
                            alert('Uploaded data does not match the existing format.');
                            return;
                        }
                        rows += newExtraUser(scores);
                    }
                }
                $('#extraStudents').append(rows);
            };
            reader.readAsText(file);
        }
        else {
            alert('File Reader not supported in your browser.');
        }
    }
    else {
        alert('Failed to load file');
    }
    //files[0]
}

var colCount = 0;

$(function() {
    $('#universitySelect').multiselect({
        includeSelectAllOption: true,
        onChange: function() {
            var selectedUniversities = iif($('#universitySelect').val(),[]);
            var selectedUsernames = list
                .filter(function(item) {
                    return selectedUniversities.indexOf(item.univ) > -1;
                })
                .map(function(item) {
                    return item.user;
                })
                .unique();
            populateSelect($('#usernameSelect'), selectedUsernames);
        }
    });

    $('#usernameSelect').multiselect({
        includeSelectAllOption: true,
        onChange: function () {
            var selectedUniversities = iif($('#universitySelect').val(), []);
            var selectedUsernames = iif($('#usernameSelect').val(), []);
            var selectedProjects = list
                .filter(function(item) {
                    return selectedUniversities.indexOf(item.univ) > -1
                        && selectedUsernames.indexOf(item.user) > -1;
                })
                .map(function(item) {
                    return item.projectName;
                })
                .unique();
            populateSelect($('#projectSelect'), selectedProjects);
        }
    });

    $('#projectSelect').multiselect({
        includeSelectAllOption: true,
        onChange: function() {
            var selectedUniversities = iif($('#universitySelect').val(), []);
            var selectedUsernames = iif($('#usernameSelect').val(), []);
            var selectedProjects = iif($('#projectSelect').val(), []);
            
            tempSelectedRecords = list
            .filter(function(item) {
                return selectedUniversities.indexOf(item.univ) > -1
                    && selectedUsernames.indexOf(item.user) > -1
                    && selectedProjects.indexOf(item.projectName) > -1;
            });
            var selectedRecords = tempSelectedRecords
                .map(function(item) {
                    return item.user;
                })
                .unique();
            $('#filteredStudents')
                .empty()
                .append(
                    selectedRecords.map(function(item) {
                        var r = $('<tr><td>' + item + '</td></tr>');
                        for (var i = 0; i < colCount; i++) {
                            r.append('<td><input type="text" /></td>');
                        }
                        return r;
                    })
                );
        }
    });

    $('#addUser').click(function() {
        $('#extraStudents').append(newExtraUser());
    });

    $('#addColumn')
        .click(function() {
            colCount++;
            var $studentTable = $('#studentTable');
            $studentTable
                .children('thead,tbody')
                .children()
                .append('<td><input type="text" /></td>');
            $studentTable
                .children('tfoot')
                .children()
                .append('<td/>');
        })
        .click();    
});

function populateDropdowns(){
	var universities = list.map(function(item) {
        return item.univ;
    }).unique();

    populateSelect($('#universitySelect'), universities);
}

function submitFilteredData() {
	
	var recordWrapper = new Object();
	recordWrapper.item = "hello";
	recordWrapper.filteredList = tempSelectedRecords;	
	//Submit the filtered list to server		
	$.ajax({
		type : "POST",
		url : "/SpringMVC/configuration/filteredRecords",
	      contentType : 'application/json; charset=utf-8',
	      dataType : 'json',
	      data : JSON.stringify(recordWrapper),
		success : function(response) {
			// we have the response		
			var resp = response;
			//Disabling the select dropdowns and Submit button
			//Not working!!
			 $('#universitySelect').find('select').attr('disabled', 'disabled');
			 $('#usernameSelect').find('select').attr('disabled', 'disabled');
			 $('#projectSelect').find('select').attr('disabled', 'disabled');
			 $('#submitFilteredData :input').prop('disabled', 'disabled');			 
			 $('#studTable').show();
		},
		error : function(e) {
			alert('Error: ' + e);
		}
	});
}

function getScores() {
    return $('#studentTable')
        .children('thead,tbody')
        .children('tr')
        .get()
        .map(function(tr) {
            return $(tr)
                .children('th,td')
                .get()
                .map(function(value, index) {
                    if (!index) {
                        var username = $(value).text();
                        if (username) {
                            return username;
                        }
                    }
                    return $(value).children().val();
                });
        });
}
function showTime() {
	$('.datetimepicker').appendDtpicker({
        'dateFormat' : 'YYYY/MM/DD hh:mm'
		});
	}
function addTime(divName){
	var newdiv = document.createElement('div');
	var timeCount = $("#"+divName).find("div").length;
	
	newdiv.id = divName+"time_"+timeCount;
	newdiv.innerHTML = "<li id='li_"+newdiv.id+"'>"+
							"<label class='description' for='element_"+newdiv.id+"_start'>Start Time "+timeCount+" </label> "+ 
							"<span> <input id='element_"+newdiv.id+"_start' class='datetimepicker'"+
								"name='element_"+newdiv.id+"_start' class='element text' value='' type='text'>"+
							"</span> "+
							"<label class='description' for='element_"+newdiv.id+"_end'>End Time "+timeCount+" </label>"+ 
							"<span> <input id='element_"+newdiv.id+"_end' class='datetimepicker'"+
								"name='element_"+newdiv.id+"_end' class='element text' value='' type='text'>"+
							"</span>"+
						"</li>";						
						document.getElementById(divName).appendChild(newdiv);
						showTime();		
}

function submitMarksLectureTime(){

	// Logic to get the scores
	var user_scores = getScores();
	var users = {};	
	// The first row contains the titles of the tests/Assignments
	var titles = user_scores[0];	
	for (var i=1; i<user_scores.length; i++){
		var user = new Object();
		user.marks=[];
		var row = user_scores[i];
		// First element in the row is User Id
		user.userId=row[0];
		//Corresponds to Mark object in server side
		
		for (var j=1; j<row.length;j++){
			var mark = new Object();
			mark.name = titles[j];
			mark.marks = parseFloat(row[j]);
			user.marks.push(mark);
		}		
		
		//Of the form Map<String, User> users
		users[user.userId] = user;
	}
	
	
	//Logic to get the Lecture times
	var lectureStartTimes = [];
	var lectureEndTimes = [];	    
    $('#lectureTimes').find('li').each(function(){	    	
        var current = $(this).find('input');
        if(current != null) {
        	var lectureStart = $(current).eq(0).val();
	    	var lectureEnd = $(current).eq(1).val();
	    	lectureStartTimes.push(lectureStart);
	    	lectureEndTimes.push(lectureEnd);
        }	        
    });
    
    //Setting the values to wrapper
	var lectureTimesMarkWrapper = new Object();
	lectureTimesMarkWrapper.users = users;
	lectureTimesMarkWrapper.lectureStartTimes = lectureStartTimes;
	lectureTimesMarkWrapper.lectureEndTimes = lectureEndTimes;


	//$.post( "/SpringMVC/configuration/marksLectureTimes" , JSON.stringify(lectureTimesMarkWrapper), null, "json");
    $.ajax({
        type: "post",
        url: "/SpringMVC/configuration/marksLectureTimes", //your valid url
        contentType: "application/json", //this is required for spring 3 - ajax to work (at least for me)
        data: JSON.stringify(lectureTimesMarkWrapper), //json object or array of json objects
        success: function(result) {
        	window.location.href = '/SpringMVC/dailyUsage';
        },
        error: function(){
            alert('failure');
        }
    });
}
