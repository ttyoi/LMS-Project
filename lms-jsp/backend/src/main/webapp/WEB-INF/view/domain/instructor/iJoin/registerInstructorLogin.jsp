<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>LMS :: InstructorLogin</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <c:set var="CTX_PATH" value="${pageContext.request.contextPath}" />
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/join_instructor/instructorLogin.css"/>
    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <link rel="stylesheet" type="text/css" href="${CTX_PATH}/css/admin/login.css"/>
    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <!-- <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script> -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script type="text/javascript" src="${CTX_PATH}/js/login_pub.js"></script>
    <!-- <script src="${pageContext.request.contextPath}/js/join_instruc/joinInstructor.js"></script> -->

<style>
    .btn:disabled { padding: 8px 18px; border: none; border-radius: 999px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; }
    .btn { height: 40px; padding: 8px 18px; border: none; border-radius: 999px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; }
    .btn-primary, .btn.preview-btn { background: #007bff; color: white; }
    .btn-gray { background-color: #F4F4F4; color: black; }
    .btn-blue { background-color: #007BFF; color: white; }
    .btn-yellow { background-color: #ffd000; color: white; }
    .btn-green { background-color: #60d575; color: white; }
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
    .inputChange {
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
    textarea {
        border: 0px;
        border-radius: 999px;
        padding: 15px 20px 20px 20px;
        background: #f2f2f2; 
    }
    .profileBtnInput{
        height: 40px; padding: 8px 18px; border: none; border-radius: 999px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; background-color: white;
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
     }
     .wrapper {
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        background: #f5f6fa;
    }
    .container {
        width: 1500px;
        height: 800px;
        padding: 30px;
        background: white;
        border-radius: 10px;
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

</style>
</head>
<body>
<c:if test="${not empty msg}">
    <script>alert("${msg}");</script>
</c:if>
<c:if test="${not empty errorMsg}">
    <script>alert("${errorMsg}");</script>
</c:if>
<div class="wrapper">
        <div class="container shadow">
            <div>
                <div style="margin-bottom: 50px; text-align: center;">
                    <img src="${CTX_PATH}/images/admin/login/logo_img.png">
                    <div>
                        <h2>강사등록</h2>
                    </div>
                </div>
                <div id="loginZone" style="display: flex; flex-direction: column; align-items: center;">
                    <div>
                        <input type="text" id="EMP_ID" name="lgn_Id" placeholder="아이디" style="margin-bottom: 2px;"
                        onkeypress="if(event.keyCode==13) {loginTest(); return false;}"
                        style="ime-mode: inactive;"/>
                    </div>
                    <div>
                        <input type="password"
                        id="EMP_PWD" name="pwd" placeholder="비밀번호" style="margin-top: 2px;"
                        onkeypress="if(event.keyCode==13) {loginTest(); return false;}"/>
                        <p id="loginError" class="inputError" style="display: none;">아이디 / 비밀번호가 일치하지 않습니다.</p>
                    </div>
                    <div>
                        <a style="margin-top: 12px;" class="btn btn-green loginBtnClass" href="javascript:loginTest();" id="loginBBtn"><strong>로그인</strong></a>
                    </div>  
                    <!-- <div>
                        <a class="btn btn-blue loginBtnClass" id="modeChn">전환</a>
                    </div> -->
                </div>
                <div id="joinZone" style="display: none;">
                    <div style="display: flex;">
                        <div style="display: flex; justify-content: space-evenly; margin-right: 100px;">
                            <div>
                                <label for=""><b>아이디</b></label>
                                <span class="inputChange" id="loginID"></span><br>
                                
                                <label for=""><b>이메일</b></label>
                                <span class="inputChange" id="email"></span><br>
                                
                                <label for=""><b>비밀번호</b><span class="red">*</span></label>
                                <input type="password" id="pwpw"/><br>
                                <p id="pwpwWarn" class="inputError" style="display: none;">비밀번호를 입력해주세요</p>
                                
                                <label for=""><b>비밀번호 확인</b><span class="red">*</span></label>
                                <input type="password" id="password"/><br>
                                <p id="passwordWarn" class="inputError" style="display: none;">비밀번호를 입력해주세요</p>
                                <p id="passwordNotEqualWarn" class="inputError" style="display: none;">비밀번호가 확인과 일치하지 않습니다.</p>
                                
                                <label for=""><b>이름</b><span class="red">*</span></label>
                                <input type="text" id="userName"/><br>
                                <p id="userNameWarn" class="inputError" style="display: none;">이름을 입력해주세요</p>
                                
                                <label for=""><b>주민번호</b><span class="red">*</span></label>
                                <input type="text" id="birthday" placeholder="ex. 20001010" maxlength="8"/><span> - </span>
                                <input style="width: 40px;" type="text" id="birthday2" maxlength="1"/>
                                <span style="font-size: 20px;" for="">******</span><br>
                                <p id="birthdayWarn" class="inputError" style="display: none;">주민번호를 입력해주세요</p>
                                
                                <label for=""><b>전화번호</b></label>
                                <input type="text" id="tel" placeholder="ex. 010-1234-5678"/><br>
                                <p id="telWarn" class="inputError" style="display: none;">전화번호를 입력해주세요</p>
                                
                                <label for=""><b>주소</b><span class="red">*</span></label>
                                <input style="width: 80px;" type="text" id="zipCode" placeholder="우편번호"/>
                                <input type="text" id="address" placeholder="주소"/><br>
                                <label for=""></label>
                                <input type="text" id="detailAddress" placeholder="상세주소"/>
                                <a class="btn btn-gray" href="javascript:void(0);" id="findAddress">주소검색</a><br>
                                <p id="zipCodeWarn" class="inputError" style="display: none;">주소를 입력해주세요</p>
                                <p id="addressWarn" class="inputError" style="display: none;">주소를 입력해주세요</p>
                                <p id="detailAddressWarn" class="inputError" style="display: none;">주소를 입력해주세요</p>
                            </div>
                            <div style="margin-left: 100px;">
                                <label><b>프로필 등록</b></label>
                                <a id="profileClickBtn" class="btn btn-gray">사진선택</a>
                                <img style="width: 100px; height: 100px; border: 1px solid white;" id="profile" alt=""><br>
                                <input class="profileBtnInput" type="file" id="profileSelect" accept="image/*" style="display: none;">
                                <label><b>학력 정보</b></label><br>
                                <textarea style="resize: none; height: 100px; width: 500px;" id="edu_level"></textarea><br>
                                <label><b>경력 정보</b></label><br>
                                <textarea style="resize: none; height: 100px; width: 500px;" id="career"></textarea><br>

                                <div style="margin-top: 25px; display: flex; justify-content: center; align-items: center;">
                                    <a class="btn btn-gray" href="javascript:void(0);" id="cancelJoin">취소</a>
                                    <a class="btn btn-green" href="javascript:void(0);" id="JoinBtn">가입</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
    // 기본
    $(function(){
        $("#EMP_ID").focus();
    });

    $("#profileClickBtn").on("click", function(e){
        e.preventDefault();
        $("#profileSelect").click();
    })

    // $("#modeChn").on("click", function(e){
    //     e.preventDefault();
    //     $("#loginZone").hide();
    //     $("#joinZone").show();
    // });

    // 프로필 등록 미리보기
    $("#profileSelect").on("change", function(e){
        e.preventDefault();
        let file = e.target.files[0];
        if(!file) return;

        let reader = new FileReader();
        reader.onload = function(e){
            $("#profile").attr("src", e.target.result);
        };
        reader.readAsDataURL(file);
    });

    const now = new Date().toISOString().split('T')[0];

    // 로그인 성공
    $("#loginBBtn").on("click", function(e){
        e.preventDefault();
        loginTest();
    });

    // 가입 취소
    $("#cancelJoin").on("click", function(e){
        e.preventDefault();
        $("#wordZone").slideDown();
        $("#loginZone").slideDown();
        $("#joinZone").slideUp();
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

    // 가입하기
    $("#JoinBtn").on("click", function(e){
        e.preventDefault();
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
            $("#passwordNotEqualWarn").show();
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
            $("#birthdayWarn").show();
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
        const birthday = ($("#birthday").val().trim()) + ($("#birthday2").val().trim());
        const formData = new FormData();
        formData.append("name", $("#userName").val().trim());
        formData.append("password", $("#password").val().trim());
        formData.append("zipcode", $("#zipCode").val().trim());
        formData.append("addr1", $("#address").val().trim());
        formData.append("addr2", $("#detailAddress").val().trim());
        formData.append("birthday", birthday);
        formData.append("phone", $("#tel").val().trim());
        formData.append("edu_level", $("#edu_level").val().trim());
        formData.append("career", $("#career").val().trim());
        formData.append("profileImg", $("#profileSelect")[0].files[0]);
        formData.append("loginID", $("#loginID").text());
        formData.append("email", $("#email").text());

        $.ajax({
            url: "${CTX_PATH}/api/inst/join/registerInstructor",
            type: "POST",
            data: formData,
            dataType: "JSON",
            processData: false,
            contentType: false,
            success: (res) => {
                Swal.fire({
                    title: "강사등록이 완료되었습니다",
                    text: "로그인 페이지로 이동합니다.",
                    confirmButtonText: "확인",
                    customClass: {
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                }).then(() => {
                    location.href = "${CTX_PATH}/login.do";
                });
            },
            error: (e) => {
                console.error(e);
            }
        })
    });

    $("#pwpw").on("input", function(){
        $("#pwpwWarn").hide();
        $("#passwordNotEqualWarn").hide();
    });
    $("#password").on("input", function(){
        $("#passwordWarn").hide();
        $("#passwordNotEqualWarn").hide();
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
    });
    $("#password").on("input", function(){
        $("#passwordWarn").hide();
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
            id: $("#EMP_ID").val(),
            password: $("#EMP_PWD").val()
        }

        $.ajax({
            url: "${CTX_PATH}/inst/chkRegisterInstructorLogin",
            type: "POST",
            dataType: "JSON",
            data: paramMap,
            success: (res) => {
                if(res.result === "SUCCESS"){
                    $("#loginID").text($("#EMP_ID").val().trim());
                    $("#email").text(res.email);
                    $("#wordZone").slideUp();
                    $("#loginZone").slideUp();
                    $("#joinZone").slideDown();
                }else if(res.result === "FAIL"){
                    $("#loginError").show();
                    $("#EMP_ID").focus();
                }
            },
            error: (e) => {
                console.error("instructor first login Error : ",e);
            }
        });
    };

    $("#EMP_ID, #EMP_PWD").on("input", function(){
        $("#loginError").hide();
    });
</script>

</body>
</html>
