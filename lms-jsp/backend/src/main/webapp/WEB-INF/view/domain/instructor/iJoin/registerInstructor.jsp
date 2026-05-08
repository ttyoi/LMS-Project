
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login/login.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/join_instructor/registerInstructor.css"/>
    <title>강사 회원가입</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
        const ctx = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/js/login/zipcode.js"></script>
    <script src="${pageContext.request.contextPath}/js/login/util.js"></script>
    <script src="${pageContext.request.contextPath}/js/join_instruc/joinInstructor.js"></script>

    <%-- 우편번호 API --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script type="text/javascript">
        $(function(){
            const defaultImgUrl="${photoUrl}";

            $("#profileImgInput").on("change",function(event){
                const file = event.target.files[0];

                if(!file) return;

                if(!file.type.startsWith("image/")){
                    alert("이미지 파일만 등록할 수 있습니다.");
                    return;
                }//end if

                //미리보기용 URL 생성
                const imgURL = URL.createObjectURL(file);
                $("#profileImgPreview").attr("src",imgURL);
            });//end onChange

            $("#cancelImgBtn").on("click",function(){
                $("#profileImgPreview").attr("src",defaultImgUrl);
                $("#profileImgInput").val("");
            });//onClick #cancelImgBtn


            //제출
            $("#joinForm").on("submit",function(event){
                if(!isPasswordSamechecked){
                    event.preventDefault();
                    alert("비밀번호가 일치하지 않습니다.");
                    return false;
                } else if(!instructorValidateRequiredField()){
                    event.preventDefault();
                    alert("필수값이 입력되었는지 확인해주세요.");
                    return false;
                }else{
                    return true;
                }//end if ~ else
            });//end submit
        });//onLoad
    </script>

</head>
<body>
<c:if test="${empty id}">
    <script>
        alert("올바른 접근 방식이 아닙니다.");
        location.href="/inst/registerInstructorLogin";
    </script>
</c:if>
<div class="form-container">
    <h2>강사 정보 등록</h2>

    <form id="joinForm" action="/inst/join/registerInstructor" method="post" enctype="multipart/form-data">
        <div class="profile-box">
            <img id="profileImgPreview" class="profile-img" src="${photoUrl}" alt="프로필 이미지">
            <br/>
            <label for="profileImgInput" class="profile-upload-btn">이미지 등록</label>
            <input type="file" id="profileImgInput" name="profileImg" accept="image/png, image/jpeg" style="display: none;">
            <button type="button" id="cancelImgBtn" class="profile-cancel-btn">취소</button>
            <p class="profile-guide">※ 프로필 사진은 JPG, PNG 형식만 가능합니다.</p>
        </div>
        <div class="form-row">
            <label for="id">아이디 <span class="red-star">*</span></label>
            <input id="id" name="loginID" type="text" value="${id}" readonly/>
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
            <input id="email" name="email" type="text" readonly value="${email}"/>
        </div>
        <p id="emailStr"></p>

        <div class="form-row textarea-row">
            <label for="edu">학력</label>
            <textarea id="edu" name="edu_level" placeholder=
                    "예)
                    2014.03 ~ 2018.02  서울대학교  컴퓨터공학과  학사 졸업
                    2018.03 ~ 2020.02  KAIST 소프트웨어대학원  석사 졸업"
            ></textarea>
        </div>
        <div class="form-row textarea-row">
            <label for="career">경력사항</label>
            <textarea id="career" name="career" placeholder="예)
                2018.01 ~ 2022.03   네이버(주)  백엔드 개발자
                - Java / Spring 기반 대규모 웹 서비스 개발 및 운영
                - MySQL 성능 튜닝 및 배치 시스템 구축

                2022.04 ~ 2024.02   카카오엔터프라이즈  플랫폼 개발팀
                - Spring Boot 마이크로서비스 개발
                - 클라우드 기반 인프라 구축 (AWS)

                2023.03 ~ 2024.01  패스트캠퍼스 백엔드 부트캠프
                - Java/Spring Boot 기반 백엔드 양성과정 강의
                - 실무 프로젝트 지도 (팀 단위)

                2024.04 ~ 2025.01  KDT(고용노동부) 데이터 분석 과정
                - Python/SQL을 활용한 데이터 분석 교육
                - 포트폴리오 프로젝트 멘토링
                "></textarea>
        </div>


        <button id="registerInstructor" type="submit">등록하기</button>
    </form>
</div>
<script>
    window.addEventListener("unload", function(){});
</script>
</body>
</html>
