<!doctype html>
<html lang=''>
<head>
   <meta charset='utf-8'>
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="css/styles.css">
   <link rel="stylesheet" type="text/css" media="screen,projection" href="css/view_form1.css" />
   <script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
   <script src="script/script.js"></script>
   <script src="script/calendar.js"></script>
   <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
   <script src="http://code.highcharts.com/highcharts.js"></script>
   <script src="http://code.highcharts.com/highcharts-more.js"></script>
   <script src="http://code.highcharts.com/modules/exporting.js"></script>
   <title>Daily Usage Analysis</title>
</head>
<body>
	<script type="text/javascript">
	var dailyUsageLecture=null;
	var dailyUsage= null;
	var tempVal = [];
	var tempVal1 = [];
	function doDataCalculation() {
		
		var row = dailyUsage.split(";");
	    for (var i = 0; i < row.length; i++) {       
	        var xVal = Date.UTC(parseInt(row[i].substring(0, 4)), parseInt(row[i].substring(5, 7)-1), parseInt(row[i].substring(8, 10)));
	        var yVal = parseInt(row[i].substring(11, row[i].length));
	        var x = [xVal, yVal];
	        tempVal.push(x);
	    }
	    
	    var row = dailyUsageLecture.split(";");
	    for (var i = 0; i < row.length; i++) {       
	        var xVal = Date.UTC(parseInt(row[i].substring(0, 4)), parseInt(row[i].substring(5, 7)-1), parseInt(row[i].substring(8, 10)));
	        var yVal = parseInt(row[i].substring(11, row[i].length));
	        var x = [xVal, yVal];
	        tempVal1.push(x);
	    }
	    // Temporary calculation - Need to change
	      for (var i = 0; i < tempVal1.length; i++) {       
	    	 for (var j = 0; j < tempVal.length; j++) { 
	    		 var lecture = tempVal1[i];
	    		 var nonlecture = tempVal[j];
	    	       if(lecture[0]==nonlecture[0]){
	    	    	   nonlecture[1] = Math.abs(lecture[1]-nonlecture[1]);
	    	    	   tempVal[j] = [nonlecture[0], nonlecture[1]];
	    	       }
	    	    }
	    } 
	    
	}
	////
	var chartValues;
	var resp;
		function doAjaxPost() {
			// get the form values
			var title = $('#element_1').val();
			var xAxisText = $('#element_2').val();
			var yAxisText = $('#element_3').val();
			var durationBand = $('#element_4').val();
			
			var name5_1 = $('#element_5_1').val();
			var name5_2 = $('#element_5_2').val();
			var name5_3 = $('#element_5_3').val();
			
			var name6_1 = $('#element_6_1').val();
			var name6_2 = $('#element_6_2').val();
			var name6_3 = $('#element_6_3').val();
			
			var name7_1 = $('#element_7_1').val();
			var name7_2 = $('#element_7_2').val();
			var name7_3 = $('#element_7_3').val();
			
			var chartType = $("input[name='element_8']:checked").val();
			
			
			var assg1Timeline = new Date(name5_3, name5_1 - 1, name5_2, "0", "0", "0", "0");
			var assg1InMillis = assg1Timeline.getTime();
			
			var assg2Timeline = new Date(name6_3, name6_1 - 1, name6_2, "0", "0", "0", "0");
			var assg2InMillis = assg2Timeline.getTime();
			
			var exam1Timeline = new Date(name7_3, name7_1 - 1, name7_2, "0", "0", "0", "0");
			var examInMillis = exam1Timeline.getTime();
			
			var plotBandFrom = [];
			var plotBandTo = [];
			var plotBandLabel = [];
			var plotBF = $("#dynamicInputPlotBand :input");
			var count;
			for (i = 0; i < plotBF.length; i++) {
			var rem = i%3;
			if(rem==0){
				count = i/3;
			    plotBandFrom[count] = $(plotBF[i]).val();
			} else if(rem==1) {
				plotBandTo[count] = $(plotBF[i]).val();
			}else if(rem==2) {
				plotBandLabel[count] = $(plotBF[i]).val();
			}
			}
			
			$.ajax({
				type : "POST",
				url : "/ACPAnalysis/dailyUsage",
				data : "title=" + title + 
					   "&xAxisText=" + xAxisText+ 
					   "&yAxisText=" + yAxisText+
					   "&assg1Time=" + assg1InMillis+
					   "&assg2Time=" + assg2InMillis+
					   "&examTime=" + examInMillis+
					   "&timeBand=" + durationBand+
					   "&plotBandFrom=" + plotBandFrom+
					   "&plotBandTo=" + plotBandTo+
					   "&plotBandLabel=" + plotBandLabel+
					   "&chartType=" + chartType,
				success : function(response) {
					// we have the response
					
					//Resetting the values before receiving succesive responses
					dailyUsageLecture=null;
					dailyUsage= null;
					tempVal = [];
					tempVal1 = [];
	
					resp = response;
					chartValues = resp.wrapp;
					dailyUsage =resp.dailyUsage;
					dailyUsageLecture = resp.dailyUsageLecture;
					doDataCalculation();
					$('.chart').show();	
					drawChart();
				},
				error : function(e) {
					alert('Error: ' + e);
				}
			});
		}
		
		
	
		function drawChart() {
			$(function() {
				Highcharts.setOptions({
					global: {
						useUTC: false
					}
				});		
				
				$('#container').highcharts(

				{

			        credits: {
			            enabled: false
			        },
					"chart" : {
						"type" : "column",
						zoomType : 'x'
					},
					"title" : {
						"text" : resp.plotValues.title
					},
					"xAxis" : {
						plotBands : chartValues.plotBands.plotBands ,
						plotLines: [{ // mark the weekend
		                color: 'red',
		                width: 2,
		                value: resp.plotValues.assg1Time,
		                label: {
							text: 'Assignment 1',
							 style: {
								color: 'green',
								fontWeight: 'bold'
		                    }
							},
		                dashStyle: 'ShortDash'
		            }, { // mark the weekend
		                color: 'red',
		                width: 2,
		                value: resp.plotValues.assg2Time,
		                label: {
							text: 'Assignment 2',
							 style: {
								color: 'green',
								fontWeight: 'bold'
		                    }
							},
		                dashStyle: 'ShortDash'
		            }, { // mark the weekend
		                color: 'red',
		                width: 2,
		                value: resp.plotValues.examTime,
		                label: {
							text: 'Test',
							 style: {
								color: 'green',
								fontWeight: 'bold'
		                    }
							},
		                dashStyle: 'ShortDash'
		            }],
						"crosshair" : "true",
						"type" : "datetime",
						"tickmarkPlacement" : "between"
					},
					"yAxis" : {
						"min" : 0,
						 "title": {
				                "text": resp.plotValues.yAxisText
				                //align: 'center'
				            },
		            lineWidth: 1,
		            minorGridLineWidth: 0,
		            minorTickInterval: 'auto',
		            minorTickPosition: 'inside',
		            minorTickWidth: 1,
		            minorTickLength: 4
					},
				    tooltip: {
				        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
				        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
				            '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
				        footerFormat: '</table>',
				        shared: true,
				        useHTML: true
				    },plotOptions: {
				        column: {
				            stacking: 'normal',
				            //Currently COmmented out. To be made optional
				            /* dataLabels: {
				                enabled: true,
				                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
				                style: {
				                    textShadow: '0 0 3px black'
				                }
				            } */
				        }
				    },
				    series: [{
				        name: 'Non Class hours',
				        data: tempVal

				    }, {
				        name: 'Class hours',
				        data: tempVal1
				    }]
				});
			});
		};
				
		var counter = 1;
		var limit = 10;
		function addInput(divName){
		     if (counter == limit)  {
		          alert("You have reached the limit of adding " + counter + " inputs");
		     }
		     else {
		          var newdiv = document.createElement('div');
		          newdiv.innerHTML = "<li><label class='description'>Plot Band From Time "+counter+
					"</label><div><input name='plotbandFrom[]' class='element text medium' type='text' maxlength='255' value='' /></div></li>"+
					
					"<li><label class='description'>Plot Band To Time "+counter+
					"</label><div><input name='plotbandTo[]' class='element text medium' type='text' maxlength='255' value='' /></div></li>"+
					
					"<li><label class='description'>Plot Band Label "+counter+
					"</label><div><input name='plotbandLabel[]' class='element text medium' type='text' maxlength='255' value='' /></div></li>";
		          document.getElementById(divName).appendChild(newdiv);
		          counter++;
		     }
		}
	</script>
 <jsp:include page="leftandtopnav.jsp" />


<div id="formchart">
<div id='content' style='margin-left:20%;'>
	<!-- Form section -->

	    <!-- Text container -->
	    <img id="top" src="images/top.png" alt="">
			<div id="form_container">

				<h1><a>Untitled Form</a></h1>
				<div id="form" class ="appnitro">
				<div class="form_description">
					<h2>All project downloads along timeline</h2>
					<p>Edit the necessary fields to reflect in the plots</p>
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
					<li id="li_4"><label class="description" for="element_4">Duration Band
					</label>
						<div>
							<input id="element_4" name="element_4"
								class="element text medium" type="text" maxlength="255" value="" />
						</div></li>
						
					<li id="li_8" >
						<label class="description" for="element_8">Select type of daily usage plot</label>
						<span>
							<input id="element_8_1" name="element_8" class="element radio" type="radio" value="1" checked="checked" />
							<label class="choice" for="element_8_1">Daily Student Hits</label>
							<input id="element_8_2" name="element_8" class="element radio" type="radio" value="2" />
							<label class="choice" for="element_8_2">Unique Student usage</label>
						</span> 
					</li>
					
					<div id="dynamicInputPlotBand">
				        						
				     </div>
				     <input type="button" value="Add Plotband values" onClick="addInput('dynamicInputPlotBand');"/>	
						
					<li id="li_5"><label class="description" for="element_5">Assignment 1
							Timeline </label> <span> <input id="element_5_1"
							name="element_5_1" class="element text" size="2" maxlength="2"
							value="" type="text"> / <label for="element_5_1">MM</label>
					</span> <span> <input id="element_5_2" name="element_5_2"
							class="element text" size="2" maxlength="2" value="" type="text">
							/ <label for="element_5_2">DD</label>
					</span> <span> <input id="element_5_3" name="element_5_3"
							class="element text" size="4" maxlength="4" value="" type="text">
							<label for="element_5_3">YYYY</label>
					</span> <span id="calendar_5"> <img id="cal_img_5"
							class="datepicker" src="images/calendar.gif" alt="Pick a date.">
					</span> <script type="text/javascript">
						Calendar.setup({
							inputField : "element_5_3",
							baseField : "element_5",
							displayArea : "calendar_5",
							button : "cal_img_5",
							ifFormat : "%B %e, %Y",
							onSelect : selectDate
						});
					</script></li>
					
					<li id="li_6"><label class="description" for="element_6">Assignment 2 
							Timeline </label> <span> <input id="element_6_1"
							name="element_6_1" class="element text" size="2" maxlength="2"
							value="" type="text"> / <label for="element_6_1">MM</label>
					</span> <span> <input id="element_6_2" name="element_6_2"
							class="element text" size="2" maxlength="2" value="" type="text">
							/ <label for="element_6_2">DD</label>
					</span> <span> <input id="element_6_3" name="element_6_3"
							class="element text" size="4" maxlength="4" value="" type="text">
							<label for="element_6_3">YYYY</label>
					</span> <span id="calendar_6"> <img id="cal_img_6"
							class="datepicker" src="images/calendar.gif" alt="Pick a date.">
					</span> <script type="text/javascript">
						Calendar.setup({
							inputField : "element_6_3",
							baseField : "element_6",
							displayArea : "calendar_6",
							button : "cal_img_6",
							ifFormat : "%B %e, %Y",
							onSelect : selectDate
						});
					</script></li>
					
					<li id="li_7"><label class="description" for="element_7">Exam 
							Timeline </label> <span> <input id="element_7_1"
							name="element_7_1" class="element text" size="2" maxlength="2"
							value="" type="text"> / <label for="element_7_1">MM</label>
					</span> <span> <input id="element_7_2" name="element_7_2"
							class="element text" size="2" maxlength="2" value="" type="text">
							/ <label for="element_7_2">DD</label>
					</span> <span> <input id="element_7_3" name="element_7_3"
							class="element text" size="4" maxlength="4" value="" type="text">
							<label for="element_7_3">YYYY</label>
					</span> <span id="calendar_7"> <img id="cal_img_7"
							class="datepicker" src="images/calendar.gif" alt="Pick a date.">
					</span> <script type="text/javascript">
						Calendar.setup({
							inputField : "element_7_3",
							baseField : "element_7",
							displayArea : "calendar_7",
							button : "cal_img_7",
							ifFormat : "%B %e, %Y",
							onSelect : selectDate
						});
					</script></li>

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

<div class="chart">
	<div id="container" style="width:100%; height:500px;"></div>
</div>
</div>
</div>
</body>
</html>
