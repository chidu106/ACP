<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
<title>Configuration Page</title>
    <link rel="stylesheet" href="css/bootstrap.css" />
    <link rel="stylesheet" href="css/bootstrap-theme.css" />
    <link href="css/bootstrap-multiselect.css" rel="stylesheet" />
    
       <!-- <link rel="stylesheet" href="css/styles.css"/>
   <link rel="stylesheet" type="text/css" media="screen,projection" href="css/view_form1.css" />
   <link rel="stylesheet" href="css/colpick.css"> -->
	<script src="script/jquery-2.1.4.js"></script>
	<script type="text/javascript" src="script/jquery.simple-dtpicker.js"></script>
	<link type="text/css" href="css/jquery.simple-dtpicker.css" rel="stylesheet" />
	
</head>
<body>

    <div style="width: 100%">
      <select id="universitySelect" multiple="multiple"></select>
      <select id="usernameSelect" multiple="multiple"></select>
      <select id="projectSelect" multiple="multiple"></select>
    </div>
    <div id ="submitFilteredData">Submit filtered data: <input type="button" value="Submit" onclick="submitFilteredData()" style="display: inline; margin-top:20 px" /></div>
    <div style="width: 100%; padding:10px 0">
        Upload CSV Data: 
        <input id="scoresFile" type="file" style="display: inline" onchange="getScoresFile(this.files)">
    </div>
    <div id = "studTable" >
	    <div style="width: 100%; padding:10px 0">
	        <a id="addColumn" href="javascript:void(0);">Add Column</a>
	    </div>

    <table id="studentTable" class="table">
        <thead style="background-color: #eee">
            <tr>
                <td style="font-weight: bold">User</td>
            </tr>
        </thead>
        <tbody id="filteredStudents"></tbody>
        <tbody id="extraStudents"></tbody>
        <tfoot>
            <tr>
                <td><a id="addUser" href="javascript:void(0);">Add User</a></td>
            </tr>
        </tfoot>
    </table>
    <div  id ="lectureTimes" ></div>;
    <div  id ="lectureTimeAdd" class="ui-icon ui-icon-plus addRow" onClick="addTime('lectureTimes');" >Add Lecture Time +</div>;
    
    
</div>

    <script src="script/bootstrap.js"></script>
    <script src="script/bootstrap-multiselect.js"></script>
    <script src="script/ScoreForm.js"></script>
</body>
</html>