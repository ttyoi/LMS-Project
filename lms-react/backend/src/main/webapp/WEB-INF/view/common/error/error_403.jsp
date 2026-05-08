<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>403 Forbidden</title>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
</head>
<body>
	<h1>403 Forbidden</h1>
	<p>접근 권한이 없습니다.</p>
	<button onclick="location.href='${ctx}/'">홈으로</button>
</body>
</html>