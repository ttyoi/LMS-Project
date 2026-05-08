<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>500error</title>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<style>

.mainDiv{
	width:1900px;
	height:800px;
	background: url("${ctx}/images/error/500error.jpg") no-repeat center;
}

.btnHomeDiv{
	width:100px;
	height:50px;
	position: relative;
	left: 850px;
	top:650px;
	
}
.btnHome{
	width:200px;
	height: 70px;
	font-size: 25px;
	border-radius: 12px;
}
</style>
</head>
<body>
	<div class ="mainDiv">
		<div class="btnHomeDiv">
			<button class="btnHome" onclick="location.href='${ctx}/'">Go Back Home</button>
		</div>
	</div>
</body>
</html>