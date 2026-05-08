<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login/login.css"/>
    <title>회원가입</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
        const ctx = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/js/login/zipcode.js"></script>
    <script src="${pageContext.request.contextPath}/js/login/util.js"></script>
    <script src="${pageContext.request.contextPath}/js/login/login.js"></script>

    <%-- 우편번호 API --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

</head>
<body>
<c:if test="${not empty sessionScope.joined}">
    <script>
        alert("올바른 접근 경로가 아닙니다.");
        location.href="/login.do";
    </script>
</c:if>
<div class="form-container">
    <h2>회원가입</h2>
    <form id="joinForm" action="/join/registerStudent" method="post">
        <div class="form-row">
            <label for="id">아이디 <span class="red-star">*</span></label>
            <input id="id" name="loginID" type="text" value="" oninput="checkID(this, 'resultIDStr')"/>
            <button id="chkidBtn" class="btnSty" type="button" onclick="checkDuplicateID(ctx,$('#id').val())">중복 확인</button>
            <p id="resultIDStr" class="resultStr"></p>
        </div>

        <div class="form-row">
            <label for="name">이름 <span class="red-star">*</span></label>
            <input id="name" name="name" type="text" oninput="checkNameForm(this, 'resultNameStr')"/>
            <p id="resultNameStr" class="resultStr"></p>
        </div>

        <div class="form-row">
            <label for="password">비밀번호 <span class="red-star">*</span></label>
            <input id="password" type="password"/>
        </div>

        <div class="form-row">
            <label for="chkpassword">비밀번호 확인 <span class="red-star">*</span></label>
            <input id="chkpassword" name="password" type="password" oninput="checkPassword('password', this,'resultPassStr')"/>
            <p id="resultPassStr" class="resultStr"></p>
        </div>

        <div class="form-row">
            <label for="zipcode">우편번호</label>
            <input id="zipcode" name="zipcode" type="text"/>
            <button type="button" id="btnZip" class="btnSty" onclick="daumPostcode()">우편번호 검색</button>
        </div>

        <div class="form-row">
            <label for="addr1">주소</label>
            <input id="addr1" name="addr1" type="text" class="addr-long"/>
        </div>

        <div class="form-row">
            <label for="addr2">상세주소</label>
            <input id="addr2" name="addr2" type="text" class="addr-long" oninput="checkAddr2(this)"/>
        </div>

        <div class="form-row birth-row">
            <label for="birth1">생년월일 <span class="red-star">*</span></label>
            <div class="birth-input-wrap">
                <input id="birth1" name="birth1" type="text" maxlength="8" class="birth-input" placeholder="예)19990213" oninput="onlyNumber(this,'birthError')" onblur="checkBirthDay(this)">
                <span class="hyphen">-</span>
                <input id="birth2" name="birth2" type="text" maxlength="1" class="birth-input-small" oninput="onlyNumber(this, 'birthError')">

                <span class="dots">●●●●●●</span>
            </div>
        </div>
        <p class="red-star resultStr" id="birthError" style="display:none;">숫자만 입력 가능합니다.</p>

        <div class="form-row phone-row">
            <label for="phone">연락처</label>
            <input id="phone1" name="phone1" type="text" maxlength="3" class="phone-input phone-small" oninput="onlyNumber(this, 'phoneError')"/>
            &nbsp;-&nbsp;
            <input id="phone2" name="phone2" type="text" maxlength="4" class="phone-input phone-small" oninput="onlyNumber(this,'phoneError')"/>
            &nbsp;-&nbsp;
            <input id="phone3" name="phone3" type="text" maxlength="4" class="phone-input phone-small" oninput="onlyNumber(this,'phoneError')"/>
        </div>
        <p class="red-star resultStr" id="phoneError" style="display:none;">숫자만 입력 가능합니다.</p>

        <div class="form-row">
            <label for="email">이메일 <span class="red-star">*</span></label>
            <input id="emailFront" name="emailFront" class="email-front" type="text" oninput="checkEmail(this)"/>&nbsp;@&nbsp;
            <input id="emailDomain" name="emailDomain" class="email-front" type="text" onblur="checkEmailDomain(this)"/>
            <select id="emailSelect" onchange="changeEmailDomain()">
                <option class="emailSelected" value="" selected>직접입력</option>
                <option class="emailSelected" value="naver.com">naver.com</option>
                <option class="emailSelected" value="gmail.com">gmail.com</option>
                <option class="emailSelected" value="daum.net">daum.net</option>
            </select>
        </div>
        <p id="emailStr"></p>

        <div>
            <div class="terms-row">
                <input type="checkbox" id="termsChk"/>
                <label for="termsChk"><span class="blue-color">[필수]</span> 이용약관 및 개인정보 처리방침 동의</label>
            </div>
            <div class="terms-row">
                <input type="checkbox" id="termsChk2"/>
                <label for="termsChk2"><span class="blue-color">[필수]</span> 개인정보 수집 및 이용 동의 (HappyJob LMS)</label>
            </div>
        </div>
        <br/><br/><br/>
        <button id="register" type="submit">가입하기</button>
    </form>
</div>
<c:if test="${not empty errorMsg}">
    <script>alert("${errorMsg}");</script>
</c:if>
<jsp:include page="termModal.jsp"/>
<script>
    //뒤로가기 처리
    window.onpageshow = function(event) {
        if (event.persisted) {
            window.location.reload();
            alert("올바른 접근 경로가 아닙니다.");
            location.href = "/login.do";
        }//end if
    };
</script>

</body>
</html>
