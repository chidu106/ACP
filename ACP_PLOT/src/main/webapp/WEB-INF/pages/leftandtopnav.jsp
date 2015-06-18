<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page session="true"%>
<html>
<body>
<img alt="header" src="images/header.png" style="margin-left: 10%; background-size:cover; width:80%;height: 90px;border: 0px;">

<div id='topnav'>
		<ul>
		   <li class='active'><a href='#'><span>Home</span></a></li>
		   <li><a href='#'><span>File Upload</span></a></li>
		   <li><a href='#'><span>Plot Configuration</span></a></li>
		   <li class='last'><a href='#'><span>Contact</span></a></li>
		   <li class='last'><a href="javascript:formSubmit()"><span>Logout</span></a></li>
	
		   <c:url value="/logout" var="logoutUrl" />
		<form action="${logoutUrl}" method="post" id="logoutForm">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
	</form>
	<script>
		function formSubmit() {
			document.getElementById("logoutForm").submit();
		}
	</script>
		   
		</ul>
	</div>

<br>

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
</div>
</body>
</html>