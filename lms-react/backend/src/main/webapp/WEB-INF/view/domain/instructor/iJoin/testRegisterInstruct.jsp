<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<html>
<head>
    <title>강사등록 테스트</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/join_instructor/registerModal.css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/join_instruc/joinInstructor.js"></script>
</head>
<body>
<button id="regInstructor" class="blue-btn" onclick="registerInstructor()">강사 등록</button>
<jsp:include page="registerIntrucModal.jsp"/>
</body>
</html>
