<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login/findIDaPW.css"/>
    <script src="${pageContext.request.contextPath}/js/login/util.js"></script>
    <script src="${pageContext.request.contextPath}/js/login/login.js"></script>
    <title>아이디/비밀번호 찾기</title>
</head>
<body>
<div class="find-wrapper">

    <!-- 아이디 찾기 -->
    <div class="find-box">
        <h3>아이디 찾기</h3>

        <div class="form-row">
            <label>이메일</label>
            <input type="text" id="findEmail" />
        </div>

        <button class="blue-btn" onclick="findID('findEmail')">아이디 찾기</button>
    </div>

    <!-- 비밀번호 찾기 -->
    <div class="find-box">
        <h3>비밀번호 찾기</h3>

        <div class="form-row">
            <label>아이디</label>
            <input type="text" id="id" oninput="checkFindIDAPW(this)"/>
        </div>

        <div class="form-row">
            <label>이메일</label>
            <input type="text" id="email"/>
        </div>

        <button class="blue-btn" onclick="findPassword('id','email')">비밀번호 찾기</button>
    </div>

</div>
<div id="loading" class="loading-overlay" style="display:none;" >
    잠시만 기다려주세요.
    <div class="spinner"></div>
</div>
</body>
</html>
