<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>강사 로그인</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/join_instructor/instructorLogin.css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/join_instruc/joinInstructor.js"></script>
</head>
<body>
<c:if test="${not empty msg}">
    <script>alert("${msg}");</script>
</c:if>
<c:if test="${not empty errorMsg}}">
    <script>alert("${errorMsg}");</script>
</c:if>
<form type="POST" action="/inst/chkRegisterInstructorLogin">
<div class="login-box">
    <label for="id">아이디</label>
    <input type="text" id="id" name="id" placeholder="아이디를 입력하세요">

    <label for="password">비밀번호</label>
    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요">

    <button type="submit" class="login-btn">로그인</button>
</div>
</form>
</body>
</html>
