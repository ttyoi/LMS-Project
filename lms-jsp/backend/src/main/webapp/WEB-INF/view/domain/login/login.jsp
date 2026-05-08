<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>LMS :: Login</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="${CTX_PATH}/css/admin/login.css"/>
    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <!-- <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script> -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script type="text/javascript" src="${CTX_PATH}/js/login_pub.js"></script>

<style>
    .btn:disabled { padding: 8px 18px; border: none; border-radius: 999px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; }
    .btn { height: 40px; padding: 8px 18px; border: none; border-radius: 999px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; }
    .btn-primary, .btn.preview-btn { background: #007bff; color: white; }
    .btn-yellow { background-color: #ffd000; color: white; }
    .btn-green { background-color: #60d575; color: white; }
    .btn-gray { background-color: #F4F4F4; color: black; }
    .btn-blue { background-color: #007BFF; color: white; }
    .btn:hover { opacity: 0.9; }
    .inputError {
        color: red;
    }
    .inputBorder {
        border: 10px solid red;
        border-color: red;
    }
    .back { 
        width: 100vw; 
        height: 100vh; 
        background: #eff0f2; 
        display: flex; 
        justify-content: center; 
        align-items: center; 
    }
    input { 
        width: 235px;
        height: 40px;
        line-height:39px;    
        border:0px;
        background: #f2f2f2;
        border-radius: 999px;
        appearance: textfield;
        padding: 0px 15px;
        margin: 5px;
     }
    label {
        width: 110px;
        height: 40px;
        line-height:39px;    
        border:0px;
        background: white;
        border-radius: 999px;
        appearance: textfield;
        padding: 0px 15px;
        margin: 5px;
        text-align: center;
    }
     select {
        width: 150px;
        height: 40px;
        border-radius: 999px;
        background: #f2f2f2;
        padding: 0px 15px;
        margin: 5px;
        border: 0px;
        line-height:39px; 
    }
     .loginBtnClass {
        width: 235px;
        height: 40px;
        background: linear-gradient(90deg, #ffd000, #60d575);
        animation: simple 2s infinite alternate;
     }
     @keyframes simple {
        0% { filter: hue-rotate(0deg); }
        100% { filter: hue-rotate(60deg); }
     }
     .wrapper {
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        background: #f5f6fa;
    }
    .container {
        width: 800px;
        height: 850px;
        padding: 30px;
        background: white;
        border-radius: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .red {
        color: rgb(224, 76, 76);
    }
    .green {
        color: #60d575;
    }
    .sweetPopUp{
        height: 300px !important;
        border-radius: 5px !important;
        padding: 30px;
        align-items: center !important;
    }
    .sweetPopUpBtn{
        color: white !important;
        background-color: #60d575 !important;
    }
    .sweetPopUpBtn:hover{
        background-color: #ffd000 !important;
    }
    /* 토글 스위치 */
    /* .switch {
    position: relative;
    display: inline-block;
    width: 60px;
    height: 34px;
    }

    .switch input {
    opacity: 0;  
    width: 0;
    height: 0;
    }

    .slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    transition: 0.3s;
    border-radius: 999px; 
    } */

    /* 동그라미 */
    /* .slider:before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    transition: 0.3s;
    border-radius: 50%;
    } */

    /* 체크됐을 때 */
    /* input:checked + .slider {
    background-color: #4CAF50;
    } */

    /* 동그라미 이동 */
    /* input:checked + .slider:before {
    transform: translateX(26px);
    } */
</style>
</head>

<body>
<c:if test="${not empty successMsg}">
    <script>alert("${successMsg}");</script>
</c:if>
    <div class="wrapper">
        <div class="container shadow">
            <div>
                <div style="margin-bottom: 50px; text-align: center;">
                        <img src="${CTX_PATH}/images/admin/login/logo_img.png">
                </div>
                <div id="loginZone" style="display: flex; flex-direction: column; align-items: center;">
                    <div>
                        <input type="text" id="EMP_ID" name="lgn_Id" placeholder="아이디"
                                    onkeypress="if(event.keyCode==13) {loginTest(); return false;}" style="margin-bottom: 2px; ime-mode: inactive;"/>
                    </div>
                    <div>
                        <input style="margin-top: 2px;" type="password" id="EMP_PWD" name="pwd" placeholder="비밀번호" onkeypress="if(event.keyCode==13) {loginTest(); return false;}"/>
                    </div>
                    <div>
                        <p id="loginError" class="inputError" style="display: none;">로그인 정보가 일치하지 않습니다.</p>
                    </div>
                    <div>
                        <a style="margin-top: 4px;" class="btn btn-green loginBtnClass" href="javascript:loginTest();" id="loginBBtn"><strong>로그인</strong></a>             
                    </div>
                    <div style="margin-top: 10px;">
                        <!-- <label class="switch">
                            <input type="checkbox" id="cb_saveId">
                            <span class="slider"></span>
                        </label> -->
                        <input style="width: 15px; height: 15px; margin: 0;" type="checkbox" id="cb_saveId">
                        <span><b>ID저장</b></span>
                        <a href="javascript:void(0);" id="RegisterBtn"><b>회원가입</b></a>                        
                        <a href="javascript:void(0);" id="findIdAPw"><b>아이디/비밀번호 찾기</b></a>
                    </div>
                </div>
                <div id="joinZone" style="display: none;">
                    <h1 style="font-size: 25px; margin-bottom: 10px;">회원가입</h1>
                    <div>
                        <label for=""><b>아이디</b><span class="red">*</span></label>
                        <input type="text" id="loginID"/>
                        <a href="javascript:void(0);" class="btn btn-gray" id="idExistCheck">중복확인</a>
                        <p id="loginIDWarn" class="inputError" style="display: none;">아이디를 입력해주세요</p><br>

                        <label for=""><b>이메일</b><span class="red">*</span></label>
                        <input type="text" id="email"/>
                        <span>@</span>
                        <select style="width: 200px;" name="selectEmail" id="selectEmail">
                            <option value="">선택해주세요</option>
                            <option value="gmail.com">gmail.com</option>
                            <option value="naver.com">naver.com</option>
                            <option value="daum.com">daum.net</option>
                            <option value="nate.com">nate.com</option>
                            <option value="custom">직접입력</option>
                        </select>
                        </label><input type="text" name="insertEmail" id="insertEmail" style="display: none;"/>
                        <a href="javascript:void(0);" class="btn btn-gray" id="emailExistCheck">중복확인</a>
                        <p id="emailWarn" class="inputError" style="display: none;">이메일을 입력해주세요</p>
                        <p id="emailDomainWarn" class="inputError" style="display: none;">도메인을 입력해주세요</p><br>

                        <label for=""><b>이름</b><span class="red">*</span></label>
                        <input type="text" id="userName"/>
                        <p id="userNameWarn" class="inputError" style="display: none;">이름을 입력해주세요</p><br>

                        <label for=""><b>주민번호</b><span class="red">*</span></label>
                        <input type="text" id="birthday" placeholder="ex. 20001010" maxlength="8"/><span>-</span>
                        <input type="text" id="birthday2" style="width: 40px;" maxlength="1"/>
                        <span style="font-size: 20px;" for="">******</span>
                        <p id="birthdayWarn" class="inputError" style="display: none;">주민번호를 입력해주세요</p><br>

                        <label for=""><b>비밀번호</b><span class="red">*</span></label>
                        <input type="password" id="pwpw"/>
                        <p id="pwpwWarn" class="inputError" style="display: none;">비밀번호를 입력해주세요</p><br>

                        <label for=""><b>비밀번호 확인</b><span class="red">*</span></label>
                        <input type="password" id="password"/>
                        <p id="passwordNotEqual" class="inputError" style="display: none;">비밀번호가 확인과 일치하지 않습니다.</p>
                        <p id="passwordWarn" class="inputError" style="display: none;">비밀번호를 입력해주세요</p><br>

                        <label for=""><b>전화번호</b></label>
                        <input type="text" id="tel"/>
                        <p id="telWarn" class="inputError" style="display: none;">전화번호를 입력해주세요</p><br>

                        <label for=""><b>주소</b><span class="red">*</span></label>
                        <input style="width: 80px;" type="text" id="zipCode" placeholder="우편번호"/>
                        <input type="text" id="address" placeholder="주소"/><br>
                        <label for=""></label>
                        <input type="text" id="detailAddress" placeholder="상세주소"/>
                        <a href="javascript:void(0);" class="btn btn-gray" id="findAddress">주소검색</a>
                        <p id="addressWarn" class="inputError" style="display: none;">주소를 입력해주세요</p><br>
                        <p id="zipCodeWarn" class="inputError" style="display: none;">주소를 입력해주세요</p><br>
                        <p id="detailAddressWarn" class="inputError" style="display: none;">주소를 입력해주세요</p><br>


                    </div>
                    <div style="display: flex; justify-content: center; align-items: center;">
                        <a href="javascript:void(0);" class="btn btn-gray" id="cancelJoin">취소</a>
                        <a href="javascript:void(0);" class="btn btn-green" id="JoinBtn">가입</a>
                    </div>
                </div>
                <div id="findZone" style="display: none; justify-content: center; flex-direction: row;">
                    <div style="display: flex; justify-content: center; flex-direction: column; align-items: center;">
                        <div>
                            <label for="">이메일</label>
                            <input type="text" id="findIdEmail" placeholder="이메일을 입력해주세요">
                        </div>
                        <div>
                            <a style="margin-top: 20px;" href="javascript:void(0);" class="btn btn-yellow" id="findIdBtn">아이디 찾기</a>
                        </div>    
                    </div>
                    <div style="margin-top: 50px; display: flex; justify-content: center; flex-direction: column; align-items: center;">
                        <div>
                            <label for="">아이디</label>
                            <input id="findPwId" type="text" placeholder="아이디를 입력해주세요"/><br>
                        </div>
                        <div>
                            <label for="">이메일</label>
                            <input id="findPwEmail" type="text" placeholder="이메일을 입력해주세요"/><br>
                        </div>
                        <a style="margin-top: 20px;" href="javascript:void(0);" id="findPwBtn" class="btn btn-yellow">비밀번호 찾기</a><br><br>

                        <a href="javascript:void(0);" id="cancelFind" class="btn btn-green">로그인화면으로 돌아가기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
    $(function(){
        readyToLogin();
    });

    function readyToLogin(){
        const cookieId = getCookie('EMP_ID');
        if(cookieId != ""){
            $("#EMP_ID").val(cookieId);
            $("#cb_saveId").attr("checked", true);
            $("#EMP_EMP").focus();
        }else{
            $("#EMP_ID").focus();
        }
    }
    
    const now = new Date().toISOString().split('T')[0];
    let idAnotherCheck = "unchecked";
    let emailAnotherCheck = "unchecked";
    
    $("#birthday").attr("max", now);

    $("#RegisterBtn").on("click", function(e){
        e.preventDefault();
        $("#wordZone").slideUp();
        $("#loginZone").slideUp();
        $("#joinZone").slideDown();
    });

    $("#loginBBtn").on("click", function(e){
        e.preventDefault();
        loginTest();
    });

    $("#findIdAPw").on("click", function(e){
        e.preventDefault();
        $("#wordZone").slideUp();
        $("#loginZone").slideUp();
        $("#findZone").slideDown();
    });

    $("#cancelJoin").on("click", function(e){
        e.preventDefault();
        $("#wordZone").slideDown();
        $("#loginZone").slideDown();
        $("#joinZone").slideUp();
    });

    $("#cancelFind").on("click", function(e){
        e.preventDefault();
        $("#wordZone").slideDown();
        $("#loginZone").slideDown();
        $("#findZone").slideUp();
    });

    $("#findPwBtn").on("click", function(e){
        e.preventDefault();
        findPwLogic();
    });

    $("#selectEmail").on("change", function () {
        const selected = $(this).val();

        if (selected === "custom") {
            $("#insertEmail").show().focus();
        } else {
            $("#insertEmail").hide().val("");
        }
    });
    
    // 아이디 중복확인
    $("#idExistCheck").on("click", function(e){
        e.preventDefault();
        if($("#loginID").val().trim() === ""){
            $("#loginIDWarn").show();
            return;
        }

        const data = {
            loginID : $("#loginID").val().trim()
        }

        $.ajax({
            url: "${CTX_PATH}/check_loginID",
            type: "POST",
            data: data,
            dataType: "TEXT",
            success: (res) => {
                console.log(res);
                if(res === "1"){
                    Swal.fire({
                        icon: "warning",
                        text: "이미 존재하는 아이디 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                    idAnotherCheck = "duplicate";
                }else if(res === "0"){
                    Swal.fire({
                        icon: "success",
                        text: "사용가능한 아이디 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'green',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                    idAnotherCheck = "ok";
                }
            },
            error: (e) => {
                console.error("idcheck error : ",e);
            }
        })
    });

    // 이메일 중복확인
    $("#emailExistCheck").on("click", function(e){
        e.preventDefault();
        if($("#email").val().trim() === ""){
            $("#emailWarn").show();
            return;
        }
        const emailId = $("#email").val().trim();
        let emailDomain = "";

        if($("#selectEmail").val() === "custom"){
            emailDomain = $("#insertEmail").val().trim();
        }else{
            emailDomain = $("#selectEmail").val();
        }

        const fullEmail = emailId + "@" + emailDomain;
        const data = {
            user_email : fullEmail
        }
        
        $.ajax({
            url: "${CTX_PATH}/check_email",
            type: "POST",
            data: data,
            dataType: "TEXT",
            success: (res) => {
                console.log(data.user_email);
                console.log(data);
                console.log(res);
                if(res === "1"){
                    Swal.fire({
                        icon: "warning",
                        text: "이미 존재하는 이메일 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                    emailAnotherCheck = "duplicate";
                }else if(res === "0"){
                    Swal.fire({
                        icon: "success",
                        text: "사용가능한 이메일 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'green',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                    emailAnotherCheck = "ok";
                }
            },
            error: (e) => {
                console.error("emailcheck error ",e);
            }
        })
    });

    // 주소검색
    $("#findAddress").on("click", function(e){
        e.preventDefault();
        new kakao.Postcode({
                oncomplete: function(data) {
                    $("#zipCode").val(data.zonecode);
                    $("#address").val(data.address);
                }
            }).open();
    });

    // 가입확인
    $("#JoinBtn").on("click", function(e){
        e.preventDefault();
        const emailId = $("#email").val().trim();
        let emailDomain = "";
        if($("#selectEmail").val() === "custom"){
            emailDomain = $("#insertEmail").val().trim();
        }else{
            emailDomain = $("#selectEmail").val();
        }
        const fullEmail = emailId+"@"+emailDomain;
        if(!$("#loginID").val().trim()){
            $("#loginID").focus();
            $("#loginIDWarn").show();
            return;
        };
        if(!$("#email").val().trim()){
            $("#email").focus();
            $("#emailWarn").show();
            return;
        };
        if(!$("#selectEmail").val().trim()){
            $("#selectEmail").focus();
            $("#emailDomainWarn").show();
            return;
        };
        if(!$("#userName").val().trim()){
            $("#userName").focus();
            $("#userNameWarn").show();
            return;
        };
        if(!$("#birthday").val().trim()){
            $("#birthday").focus();
            $("#birthdayWarn").show();
            return;
        };
        if(!$("#birthday2").val().trim()){
            $("#birthday2").focus();
            $("#birthdayWarn2").show();
            return;
        };
        if(!$("#pwpw").val().trim()){
            $("#pwpw").focus();
            $("#pwpwWarn").show();
            return;
        };
        if(!$("#password").val().trim()){
            $("#password").focus();
            $("#passwordWarn").show();
            return;
        };
        if($("#pwpw").val().trim() !== $("#password").val().trim()){
            $("#passwordNotEqual").show();
            return;
        }
        if(!$("#tel").val().trim()){
            $("#tel").focus();
            $("#telWarn").show();
            return;
        };
        if(!$("#zipCode").val().trim()){
            $("#zipCode").focus();
            $("#zipCodeWarn").show();
            return;
        };
        if(!$("#address").val().trim()){
            $("#address").focus();
            $("#addressWarn").show();
            return;
        };
        if(!$("#detailAddress").val().trim()){
            $("#detailAddress").focus();
            $("#detailAddressWarn").show();
            return;
        };
        if(idAnotherCheck === "unchecked"){
            Swal.fire({
                        icon: "warning",
                        text: "아이디 중복확인을 진행해주세요.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
            return;
        };
        if(emailAnotherCheck === "unchecked"){
            Swal.fire({
                        icon: "warning",
                        text: "이메일 중복확인을 진행해주세요.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
            return;
        };
        if(idAnotherCheck === "duplicate"){
            Swal.fire({
                        icon: "warning",
                        text: "이미 존재하는 아이디 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
            return;
        };
        if(emailAnotherCheck === "duplicate"){
            Swal.fire({
                        icon: "warning",
                        text: "이미 존재하는 아이디 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
            return;
        };

        const data = {
            action: "I",
            loginID: $("#loginID").val().trim(),
            userName: $("#userName").val().trim(),
            password: $("#password").val().trim(),
            zipCode: $("#zipCode").val().trim(),
            address: $("#address").val().trim(),
            detailAddress: $("#detailAddress").val().trim(),
            birthday: ($("#birthday").val().trim()) + ($("#birthday2").val().trim()),
            tel: $("#tel").val().trim(),
            email: fullEmail
        }
        $.ajax({
            url: "${CTX_PATH}/register.do",
            type: "POST",
            dataType: "JSON",
            data: data,
            success: (res) => {
                console.log(res);
                Swal.fire({
                        icon: "success",
                        text: "가입이 완료 되었습니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'green',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                emptyJoin();
                $("#wordZone").slideDown();
                $("#loginZone").slideDown();
                $("#joinZone").slideUp();
                $("#EMP_ID").val($("#loginID").val().trim());
            },
            error: (e) => {
                console.error(e);
            }
        })
    });

    $("#loginID").on("input", function(){
        $("#loginIDWarn").hide();
    });
    $("#email").on("input", function(){
        $("#emailWarn").hide();
    });
    $("#selectEmail").on("input", function(){
        $("#emailDomainWarn").hide();
    })
    $("#userName").on("input", function(){
        $("#userNameWarn").hide();
    });
    $("#birthday").on("input", function(){
        $("#birthdayWarn").hide();
    });
    $("#birthday2").on("input", function(){
        $("#birthdayWarn2").hide();
    });
    $("#pwpw").on("input", function(){
        $("#pwpwWarn").hide();
        $("#passwordNotEqual").hide();
    });
    $("#password").on("input", function(){
        $("#passwordWarn").hide();
        $("#passwordNotEqual").hide();
    });
    $("#tel").on("input", function(){
        $("#telWarn").hide();
    });
    $("#zipCode").on("input", function(){
        $("#zipCodeWarn").hide();
    });
    $("#address").on("input", function(){
        $("#addressWarn").hide();
    });
    $("#detailAddress").on("input", function(){
        $("#detailAddressWarn").hide();
    });
    
    $("EMP_ID").on("input", function(){
        $("EMP_ID").removeClass("inputBorder");
    });
    $("EMP_PWD").on("input", function(){
        $("EMP_PWD").removeClass("inputBorder");
    });

    // 로그인
    function loginTest(){
        if ($("#cb_saveId").is(":checked")) {
                saveCookie('EMP_ID', $("#EMP_ID").val(), 7);
            } else {
                saveCookie('EMP_ID', "", 7);
            }
        if(!$("#EMP_ID").val()){
            $("EMP_ID").addClass("inputBorder");
            $("#EMP_ID").focus();
            
            return;
        }
        if(!$("#EMP_PWD").val()){
            $("EMP_PWD").addClass("inputBorder");
            $("#EMP_PWD").focus();
            return;
        }
        
        const paramMap = {
            lgn_Id: $("#EMP_ID").val(),
            pwd: $("#EMP_PWD").val()
        }

        $.ajax({
            url: "${CTX_PATH}/loginProc.do",
            type: "POST",
            dataType: "JSON",
            data: paramMap,
            success: (res) => {
                loginResult(res);
            },
            error: (e) => {
                console.error(e);
            }
        })
    }

    // 로그인 결과 이동
    function loginResult(res){
        if(res.result === "SUCCESS"){
            let url = "";
            if(res.userType == "A"){
                url = "${CTX_PATH}/admin/dashboard";
            }else if(res.userType == "S"){
                url = "${CTX_PATH}/stu/my-page";
            }else if(res.userType == "I"){
                url = "${CTX_PATH}/inst/my-page";
            }else{
                url = "${CTX_PATH}/dashboard/dashboard.do";
            }
            
            if(res.chk_tem_password === "Y"){
            Swal.fire({
                        icon: "warning",
                        text: "임시 비밀번호 입니다. 비밀번호를 변경해주세요.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
            }
            location.href = url;
        }else{
            $("#loginError").show();
        }
    }

    $("#EMP_ID, #EMP_PWD").on("input", function(){
        $("#loginError").hide();
    });

    $("#findIdBtn").on("click", function(e){
        e.preventDefault();
        findIdEmail();
    });

    $("#findIdEmail").on("keydown", function(e) {
        if (e.key === "Enter") {
            e.preventDefault();
            $("#findIdBtn").click();
        }
    });

    $("#findPwEmail").on("keydown", function(e) {
        if (e.key === "Enter") {
            e.preventDefault();
            $("#findPwBtn").click();
        }
    });

    // 아이디 찾기 - 이메일 존재 확인
    function findIdEmail(){
        const data = {
            user_email: $("#findIdEmail").val().trim()
        };

        $.ajax({
            url: "${CTX_PATH}/selectFindInfo.do",
            type: "POST",
            dataType: "JSON",
            data : data,
            success: (res) => {
                if(res.result === "FALSE"){
                    Swal.fire({
                        icon: "warning",
                        text: "존재하지 않는 이메일 입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'red',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                    return;
                }else if(res.result === "SUCCESS"){
                    Swal.fire({
                        icon: "success",
                        text: "회원님의 아이디는  " + res.resultModel.loginID + "  입니다.",
                        confirmButtonText: "확인",
                        customClass: {
                            title: 'green',
                            popup: 'sweetPopUp',
                            confirmButton: 'btn sweetPopUpBtn'
                        }
                    });
                    $("#findIdEmail").val("");
                    $("#findPwId").val(res.resultModel.loginID);
                    $("#findPwEmail").val(res.resultModel.user_email);
                }
            },
            error: function(xhr, status, error) {
                console.log("status:", status);
                console.log("error:", error);
                console.log("http status code:", xhr.status);
                console.log("responseURL:", xhr.responseURL);
                console.log("responseText:", xhr.responseText);
            }
        })
    };

    // 비밀번호 찾기 버튼
    function findPwLogic(){
        const data = {
            id: $("#findPwId").val().trim(),
            email: $("#findPwEmail").val().trim()
        };
        $.ajax({
            url: "${CTX_PATH}/searchPassword",
            type: "POST",
            dataType: "TEXT",
            data: data,
            success: (res) => {
                console.log(res);
            },
            error: (err) => {
                console.error(err);
            }
        })
    };

    // 값 비우기
    function emptyJoin(){
        $("#loginID").val("");
        $("#email").val("");  
        $("#userName").val("");
        $("#birthday").val("");
        $("#birthday2").val("");
        $("#pwpw").val("");
        $("#password").val("");
        $("#tel").val("");
        $("#zipCode").val("");
        $("#address").val("");
        $("#detailAddress").val("");
    };
</script>

</body>
</html>