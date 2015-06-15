<!doctype html>
<html lang=''>
<head>
   <meta charset='utf-8'>
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" type="text/css" media="screen,projection" href="css/view_form1.css" />
   <link rel="stylesheet" href="css/styles.css"/>
   <link rel="stylesheet" href="css/colpick.css">
	<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="script/jquery.simple-dtpicker.js"></script>
	<link type="text/css" href="css/jquery.simple-dtpicker.css" rel="stylesheet" />
	<script src="script/colpick.js"></script>
   	<script src="script/script.js"></script>
 
   <script src="http://code.highcharts.com/highcharts.js"></script>
   <script src="http://code.highcharts.com/highcharts-more.js"></script>
   <script src="http://code.highcharts.com/modules/exporting.js"></script>
   <title>Usage vs Marks Analysis</title>

</head>
<body>
	<script type="text/javascript">
	var chartValues;
	var resp;	
	var counter = 1;
	var categoryCounter = 0;
	var limit = 10;	
	var numberOfMarks;	
	var improvementSeriesList;
	var userByCategory;
	 var selected;
	
	//Colour Picker
		
		function doAjaxPost() {
			// get the form values
			var title = $('#element_1').val();
			var xAxisText = $('#element_2').val();
			var yAxisText = $('#element_3').val();
			var durationBand = $('#element_4').val();
			
			var wrapperObj = new Object();
			wrapperObj.title = title;
			wrapperObj.xAxisText = xAxisText;
			wrapperObj.yAxisText = yAxisText;
			wrapperObj.categories = [];
			
			//Retreive the category details and set it in wrapperObj
			var categoryHtml = $("#category");			
			for (var i=1; i<=categoryCounter; i++){
				var temp4 = $(categoryHtml).find('#category_'+i);
				
				var catg = $(categoryHtml).find('#category_'+i).find('li').find('input');
				var catgTimeDom = $(categoryHtml).find('#category_'+i);
				var elements = $(categoryHtml).find('#category_'+i).find('li')
				
				var GroupingCategory = new Object();
				GroupingCategory.categoryName =$(catg[0]).val() ;
				GroupingCategory.threshold =$(catg[1]).val() ;
				GroupingCategory.percentageValue =$(catg[2]).val() ;
				GroupingCategory.startTimes = [];
				GroupingCategory.endTimes = [];
				
				var timeCount = $(catgTimeDom).find("div").length;				
				//Hard coded value: Logic Needs to be changed!!
				timeCount = timeCount -4;
				for (var j=1; j<=timeCount ; j++){
					var startTime = $(catgTimeDom).find('#element_category_'+i+'time_'+j+'_start').val();
					GroupingCategory.startTimes.push(startTime);
					var endTime = $(catgTimeDom).find('#element_category_'+i+'time_'+j+'_end').val();
					GroupingCategory.endTimes.push(endTime);
				}
				wrapperObj.categories.push(GroupingCategory);
			}
			
			//If Default category is enabled fetch its values and add it to wrapperObj.categories			 
			  $('input[name=element_4]').click(function() {
				  selected = $(this).val();
				});
			  if(selected == '1'){
			      var inputs = $('#defaultcategory :input');
			      var GroupingCategory = new Object();
					GroupingCategory.categoryName =$(inputs[0]).val() ;
					GroupingCategory.threshold =$(inputs[1]).val() ;
					GroupingCategory.percentageValue =$(inputs[2]).val() ;
					wrapperObj.categories.push(GroupingCategory);
			  } 
								
			//Retreive the various grouping category combinations and set them in wrapperObj
			var categoryColorCodes = getCategoryCombinations();
			wrapperObj.categoryColorCodes = categoryColorCodes;
				
			$.ajax({
				type : "POST",
				url : "/SpringMVC/markAnalysis",
			      contentType : 'application/json; charset=utf-8',
			      dataType : 'json',
			      data: JSON.stringify(wrapperObj), 
				success : function(response) {
					// we have the response
					 resp = response;
					chartValues = resp.wrapp; 
					numberOfMarks = resp.listOfSeriesList;
					improvementSeriesList = resp.improvementSeriesList;
					userByCategory = resp.userByCategory;
					for ( var count=0; count<numberOfMarks.length;count++) {
						addContainer(count);
					}				
					
					$('.chart').show();
					for (var count=0; count<numberOfMarks.length;count++) {
						drawChart(count, numberOfMarks[count]);
					}
					drawChartComparision(improvementSeriesList);
					generateUserCategoryTable(userByCategory);
				
				},
				error : function(e) {
					alert('Error: ' + e);
				}
			});
		}
				
		function getCategoryCombinations() {
		   var allRows = $('#generatedComb');
		   var catgCombiMap = new Object();
		   var allRowsTr = $(allRows).children('tr');
		   for (var i=0; i<allRowsTr.length;i++ ){
			   var inputFields = $(allRowsTr[i]).find('input');
			   var valueArray=[];
			   valueArray[0] = $(inputFields[1]).val() ;
			   valueArray[1] = $(inputFields[2]).val() ;
			   var key = $(inputFields[0]).val();
			   catgCombiMap[key] = valueArray;			   
		   }
		   return catgCombiMap;
		}
		
		function getCategoryCombinationsTemp() {
		    return $('#combiTable')
		        .children('tbody')
		        .children('tr')
		        .get()
		        .map(function(tr) {
		            return $(tr)
		                .children('td')
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
		
		function addContainer(chartCount) {
			var newdiv = document.createElement('div');
	          newdiv.innerHTML = "<div id='container"+chartCount+"' style='width:100%; height:600px;'></div>";
	          document.getElementById("chartContainer").appendChild(newdiv);
		}

		function generateUserCategoryTable(userByCategory){
			var tableCode = "<table>";
			for (var m in userByCategory){
				tableCode += "<tr>" +"<th>" + "Category :"+m + "</th>" +"</tr>";				
			    for (var i=0;i<userByCategory[m].length;i++){
			    	var x = userByCategory[m][i]; 
			    	tableCode += "<tr>";
			    	tableCode += "<td>"+x.userId+"</td>";
			    	for (var j in userByCategory[m][i].categoryWiseUsage) {
			    		var col = "<td>"+j +" : "+userByCategory[m][i].categoryWiseUsage[j]+"</td>";			    		
			    		tableCode +=col;
			    	}	
			    	tableCode += "</tr>";
			    }
			    
			} 
			tableCode += "</table>";
			$('#generatedTable').empty();
		    $("#generatedTable").append(tableCode);
		}

		
		function drawChart(count, seriesData) {
			$(function() {
				Highcharts.setOptions({
					global: {
						useUTC: false
					}
				});		
				
				$('#container'+count).highcharts(

				{
			        credits: {
			            enabled: false
			        },
					"chart" : {
						"type" : "scatter",
						zoomType : 'xy'
					},
					"title" : {
						"text" : "CHange it Marks stuff!!"
					},
					"xAxis" : {
						title: {
			                enabled: true,
			                text: 'Usage '
			            },
			            startOnTick: true,
			            endOnTick: true,
			            showLastLabel: true
					},
					"yAxis" : {
						"min" : 0,
						 "title": {
				                "text": "change it!!"//resp.plotValues.yAxisText
				                //align: 'center'
				            }/* , 
		            lineWidth: 1,
		            minorGridLineWidth: 0,
		            minorTickInterval: 'auto',
		            minorTickPosition: 'inside',
		            minorTickWidth: 1,
		            minorTickLength: 4 */
					},
					legend: {
			            layout: 'vertical',
			            align: 'left',
			            verticalAlign: 'top',
			            x: 100,
			            y: 70,
			            floating: true,
			            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
			            borderWidth: 1
			        },
			        plotOptions: {
			            scatter: {
			                marker: {
			                    radius: 5,
			                    states: {
			                        hover: {
			                            enabled: true,
			                            lineColor: 'rgb(100,100,100)'
			                        }
			                    }
			                },
			                states: {
			                    hover: {
			                        marker: {
			                            enabled: false
			                        }
			                    }
			                },
			                tooltip: {
			                    headerFormat: '<b>{series.name}</b><br>',
			                    pointFormat: '{point.x} , {point.y} '
			                }
			            }
			        },
					"series" : seriesData
				});
			});
		};
		
		function drawChartComparision(improvementSeriesList) {
			$(function() {
				Highcharts.setOptions({
					global: {
						useUTC: false
					}
				});		
				
				$('#chartComparisionContainer').highcharts(

				{
			        credits: {
			            enabled: false
			        },
					"chart" : {
						"type" : "scatter",
						zoomType : 'xy'
					},
					"title" : {
						"text" : "CHange it!! COmparision Stuff"
					},
					"xAxis" : {
						title: {
			                enabled: true,
			                text: 'Usage '
			            },
			            startOnTick: true,
			            endOnTick: true,
			            showLastLabel: true
					},
					"yAxis" : {
						"min" : 0,
						 "title": {
				                "text": "change it!!"//resp.plotValues.yAxisText
				                //align: 'center'
				            }/* , 
		            lineWidth: 1,
		            minorGridLineWidth: 0,
		            minorTickInterval: 'auto',
		            minorTickPosition: 'inside',
		            minorTickWidth: 1,
		            minorTickLength: 4 */
					},
					legend: {
			            layout: 'vertical',
			            align: 'left',
			            verticalAlign: 'top',
			            x: 100,
			            y: 70,
			            floating: true,
			            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
			            borderWidth: 1
			        },
			        plotOptions: {
			            scatter: {
			                marker: {
			                    radius: 5,
			                    states: {
			                        hover: {
			                            enabled: true,
			                            lineColor: 'rgb(100,100,100)'
			                        }
			                    }
			                },
			                states: {
			                    hover: {
			                        marker: {
			                            enabled: false
			                        }
			                    }
			                },
			                tooltip: {
			                    headerFormat: '<b>{series.name}</b><br>',
			                    pointFormat: '{point.x} , {point.y} '
			                }
			            }
			        },
					"series" : improvementSeriesList
				});
			});
		};
			
		function addTime(divName){
			var newdiv = document.createElement('div');
			var timeCount = $("#"+divName).find("div").length;
			
			//Hard coded value: Logic Needs to be changed!!
			timeCount = timeCount -3;
			
			if (timeCount > 10)  {
		          alert("You have reached the limit of adding " + timeCount + " inputs");
		     }
			newdiv.id = divName+"time_"+timeCount;
			newdiv.innerHTML = "<li id='li_"+newdiv.id+"'>"+
									"<table>"+
									"<tr>"+
									"<td style='border:0px'>"+
									"<label class='description' for='element_"+newdiv.id+"_start'>Start Time "+timeCount+" </label> "+ 
									"</td>"+
									"<td style='border:0px'>"+
									"<label class='description' for='element_"+newdiv.id+"_end'>End Time "+timeCount+" </label>"+
									"</td></tr>"+
									"<tr>"+
									"<td style='border:0px'>"+
									"<span> <input id='element_"+newdiv.id+"_start' class='datetimepicker'"+
										"name='element_"+newdiv.id+"_start' class='element text' value='' type='text'>"+
									"</span> "+
									"</td>"+
									"<td style='border:0px'>"+
									"<span> <input id='element_"+newdiv.id+"_end' class='datetimepicker'"+
										"name='element_"+newdiv.id+"_end' class='element text' value='' type='text'>"+
									"</span>"+
									"</td></tr>"+
									"<tr>"+
									"</table>"+
								"</li>";
								
								document.getElementById(divName).appendChild(newdiv);
								showTime();		
		}
		
		function addCategory(divName){
			categoryCounter = categoryCounter+1;
			var newdiv = document.createElement('div');
			newdiv.id="category_"+categoryCounter;
			var newid = newdiv.id;
			newdiv.innerHTML ="<legend style=' padding: 0.2em 0.5em; border:1px solid green; color:white; font-size:90%;'><b>Category "+categoryCounter+" </b></legend>"+
// 			"<label class='description'>Category "+categoryCounter+" </label>"+
							"<li id='li_catg"+categoryCounter+"_1'><label class='description' for='element_catg"+categoryCounter+"_1'>Category Name</label>"+
								"<div>"+
									"<input id='element_catg"+categoryCounter+"_1' name='element_catg"+categoryCounter+"_1' class='element text medium' type='text' maxlength='255' value='' />"+
								"</div>"+
							 "</li>"+
							 "<li id='li_catg"+categoryCounter+"_2'><label class='description' for='element_catg"+categoryCounter+"_2'>Minimum Threshold</label>"+
								"<div>"+
									"<input id='element_catg"+categoryCounter+"_2' name='element_catg"+categoryCounter+"_2' class='element text medium' type='text' maxlength='255' value='' />"+
								"</div>"+
							 "</li>"+
							 "<li id='li_catg"+categoryCounter+"_3'><label class='description' for='element_catg"+categoryCounter+"_3'>Threshold %(of Total usage)</label>"+
								"<div>"+
									"<input id='element_catg"+categoryCounter+"_3' name='element_catg"+categoryCounter+"_3' class='element text medium' type='text' maxlength='255' value='' />"+
								"</div>"+
							 "</li>"+
							 // Plus sign on click on which new time input fields will be displayed
// 							"<div class='ui-icon ui-icon-plus addRow' onClick='addTime(\""+newid+"\");' >Time+</div>";
							"<div class='ui-icon ui-icon-plus addRow' >"+
							"<table >"+
							"<tr>"+
								"<td style='border:0px'>"+
								"<button style='width:120px; height:30px; border:0px; background-size:cover; background-image:url(\"images/add_time.png\");' onClick='addTime(\""+newid+"\");'></button>"+
// 									"<input type='image' src='images/add.png' alt='Add' onClick='addTime(\""+newid+"\");' style='height: 20px; width: 60px;'>"+
								"</td>"+
							"</tr>"+
							"</table>"+
							"</div>";
					
							document.getElementById(divName).appendChild(newdiv);
							var temp = $("#"+newdiv.id).wrap( "<fieldset style=' border:1px solid #1F497D '></fieldset>" );
							

		}
		
		//Method to find the various combinations
		function getCombinations(chars) {
			  var result = [];
			  var f = function(prefix, chars) {
			    for (var i = 0; i < chars.length; i++) {
			      result.push(prefix +' '+ chars[i]);
			      f(prefix +' '+ chars[i], chars.slice(i + 1));
			    }
			  }
			  f('', chars);
			  return result;
			}		
		
		function generateCombinations(){
			var categoryNames = [];
			var categoryHtml = $("#category");
			//Find the categories and store their names in an array
			for (var i=1; i<=categoryCounter; i++){				
				var catg = $(categoryHtml).find('#category_'+i).find('li').find('input');
				var name= $(catg[0]).val() ;
				categoryNames[i-1] = $.trim(name);
			}
			
			var combinations = getCombinations(categoryNames);
			
			/////
			var tbodycatg="";
			for (var i =0; i<combinations.length;i++ ){
				tbodycatg = tbodycatg +"'<tr> "+ 
									"<td><input type='text' value ='"+combinations[i] +"' /></td> "+
									"<td><input class='picker' type='text' value='e2f71e'/></td> "+
									"<td><input type='text' /></td> "+
									"</tr> '";
			}	
			
			// Append the generated combinations to the tbody
			$('#generatedComb')
            .empty()
            .append(tbodycatg);
			showColorPick();
		}
	</script>
<img alt="header" src="images/header.png" style="margin-left: 10%; background-size:cover; width:80%;height: 90px;border: 0px;">

	<div id='topnav'>
		<ul>
		   <li class='active'><a href='#'><span>Home</span></a></li>
		   <li><a href='#'><span>File Upload</span></a></li>
		   <li><a href='#'><span>Plot Configuration</span></a></li>
		   <li class='last'><a href='#'><span>Contact</span></a></li>
		</ul>
	</div>

<div id='leftandcontent' style="margin-left: 10%" >
<div id='leftnav'>
<ul>
   <li class='active'><a href='#'><span>Home</span></a></li>
   <li class='has-sub'><a href='#'><span>Usage Analysis Charts</span></a>
      <ul>
         <li><a href='/firstplot'><span>Chart A</span></a></li>
         <li><a href='#'><span>Chart B</span></a></li>
         <li class='last'><a href='#'><span>Product 3</span></a></li>
      </ul>
   </li>
   <li class='has-sub'><a href='#'><span>Usage vs Marks Analysis Charts</span></a>
      <ul>
         <li><a href='#'><span>Company</span></a></li>
         <li class='last'><a href='#'><span>Contact</span></a></li>
      </ul>
   </li>
   <li class='has-sub'><a href='#'><span>Other Charts</span></a>
   <ul>
         <li><a href='#'><span>Chart A</span></a></li>
         <li class='last'><a href='#'><span>Chart b</span></a></li>
      </ul>
   </li>
   <li class='last'><a href='#'><span>xyz Chart</span></a></li>
</ul>
</div>

<div id="formchart" >
<div id='content'>
	<!-- Form section -->

	    <!-- Text container -->
	    <img id="top" src="images/top.png" alt="">
			<div id="form_container">

				<h1><a>Untitled Form</a></h1>
				<div id="form" class ="appnitro">
				<div class="form_description">
					<h2>Usage vs Marks Analysis Plots</h2>
					<p>Enter the necessary fields to reflect in the plots</p>
				</div>
					<ul >

					<li id="li_1"><label class="description" for="element_1">Title
					</label>
						<div>
							<input id="element_1" name="element_1"
								class="element text medium" type="text" maxlength="255" value="" />
						</div></li>
					<li id="li_2"><label class="description" for="element_2">x
							Axis text </label>
						<div>
							<input id="element_2" name="element_2"
								class="element text medium" type="text" maxlength="255" value="" />
						</div></li>
					<li id="li_3"><label class="description" for="element_3">y
							Axis text </label>
						<div>
							<input id="element_3" name="element_3"
								class="element text medium" type="text" maxlength="255" value="" />
						</div></li>
									
					<script type="text/javascript">
					function showColorPick() {
						$('.picker').colpick({
									layout:'hex',
									submit:0,
									colorScheme:'dark',
									onChange:function(hsb,hex,rgb,el,bySetColor) {
										$(el).css('border-color','#'+hex);
										// Fill the text box just if the color was set using the picker, and not the colpickSetColor function.
										if(!bySetColor) $(el).val(hex);
									}
								}).keyup(function(){
									$(this).colpickSetColor(this.value);
							});
							}
					</script>
					<script>					
					function showTime() {
						$('.datetimepicker').appendDtpicker({
				            'dateFormat' : 'YYYY/MM/DD hh:mm'
		        			});
						}					
					</script>
					
					
					<br><br>
					<div class="legend">
					<label class="description">Grouping Category Definition</label>
					</div>
					
					<fieldset>
					<div id = 'category'>	
						<li id="li_4" >
						<label class="description" for="element_8">Default Category : Lecture Hours</label>
						<span>Select Yes if you want all lecture hours combined as one category </span>
							<span>
								<input id="element_4_1" name="element_4" class="element radio" type="radio" value="1" />
								<label class="choice" for="element_4_1">Yes</label>
								<div id ="defaultcategoryDiv">	
									<ul id = "defaultcategory">							  	
										<li id='li_catgdefault_1'><label class='description' for='element_catgdefault_1'>Category Name</label>
											<div>
												<input id='element_catgdefault_1' name='element_catgdefault_1' class='element text medium' type='text' maxlength='255' value='Lecture Time'  disabled/>
											</div>
										 </li>
										 <li id='li_catgdefault_2'><label class='description' for='element_catgdefault_2'>Minimum Threshold</label>
											<div>
												<input id='element_catgdefault_2' name='element_catgdefault_2' class='element text medium' type='text' maxlength='255' value='15' />
											</div>
										 </li>
										 <li id='li_catgdefault_3'><label class='description' for='element_catgdefault_3'>Threshold %(of Total usage)</label>
											<div>
												<input id='element_catgdefault_3' name='element_catgdefault_3' class='element text medium' type='text' maxlength='255' value='20' />
											</div>
										 </li>
										 </ul>
								</div>
								<input id="element_4_2" name="element_4" class="element radio" type="radio" value="2" checked="checked" />
								<label class="choice" for="element_4_2">No</label>
							</span> 
						</li>				
					</div>
						
					<script>
					$( document ).ready(function() {
					$('input[name=element_4]').change(function() {
						  var selected = $(this).val();console.log(selected);
						  if(selected == '1'){
						      $('#defaultcategory').show();
						  } else {
						      $('#defaultcategory').hide();
						  }
						});
					//Setting the default checked value for radio button
					var radioObj = $('input[name=element_4]');
					radioObj.filter('[value=2]').prop('checked', true);
					
					 var selected = $('input[name=element_4]:checked').val();
					  if(selected == '1'){
					      $('#defaultcategory').show();
					  } else {
					      $('#defaultcategory').hide();
					  }	
					});
								
					</script>
								
					<div id="categoryAdd" class="ui-icon ui-icon-plus addRow"  >
						<table >
						<tr>
							<td style="border:0px">
								<button style="width:120px;height:30px;border:0px;background-size: cover;background-image: url('images/add_category.png');" onClick="addCategory('category');">
								</button>
<!-- 								<input type="image" src="images/add.png" alt="Add" onClick="addCategory('category');" style="height: 20px; width: 60px;"> -->
							</td>
						</tr>
						</table>						
					</div>
					</fieldset>
					<div id ="combinationTable">
						<table id="combiTable" class="table">
					        <thead style="background-color: #eee">
					            <tr>
					                <td style="font-weight: bold">Category</td>
					                <td style="font-weight: bold">Color</td>
					                <td style="font-weight: bold">Symbol</td>
					            </tr>
					        </thead>
					        <tbody id="generatedComb"></tbody>					        
					    </table>
					</div>
										
					<li class="buttons"><input type="hidden" name="form_id"
						value="1002989" /> <input id="generateComb" class="button_text"
						type="submit" name="submit" value="Generate Combinations" onclick="generateCombinations()" />
					</li>	
					
					
					<li id="li_4"><label class="description" for="element_4">Enter names of two Tests/Assignments for comparision with Usage
					</label>
					<li id="li_41"><label class="description" for="element_4_1">Test 1 Name
					</label>
						<div>
							<input id="element_4_1" name="element_4_1"
								class="element text medium" type="text" maxlength="255" value="" />
						</div></li>
					<li id="li_42"><label class="description" for="element_4_2">Test 2 Name
					</label>
						<div>
							<input id="element_4_2" name="element_4_2"
								class="element text medium" type="text" maxlength="255" value="" />
						</div></li>

					<li class="buttons"><input type="hidden" name="form_id"
						value="1002984" /> <input id="saveForm" class="button_text"
						type="submit" name="submit" value="Submit" onclick="doAjaxPost()" /></li>
				</ul>
				</div>
				<div id="footer">

				</div>
			</div>
		<img id="bottom" src="images/bottom.png" alt="">
</div>
<div id ="generatedTable" > </div>
<div id="chartContainer" class="chart"></div>
<div id="chartComparisionContainer" class="chart">
	
</div>
</div>
</div>

<br><br><br><br>

</body>
</html>
