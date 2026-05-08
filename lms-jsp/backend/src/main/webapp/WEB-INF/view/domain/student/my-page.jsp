<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>마이페이지</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
<style>
    .btn:disabled { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; }
    .btn { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; margin: 1px 2px; }
    .btn-primary, .btn.preview-btn { background: #007bff; color: white; }
    .btn-gray { background-color: #F4F4F4; color: black; }
    .btn-blue { background-color: #007BFF; color: white; }
    .btn-green { background-color: #20BF6B; color: white; }
    .btn:hover { opacity: 0.9; }
    .previewWrapper { width: 100%; overflow-x: auto; margin-top: 15px; }
    .previewTable { width: 100%; border-collapse: collapse; table-layout: fixed; min-width: 800px; }
    .previewTable th, #previewTable td { border: 1px solid #e2e2e2; padding: 10px; font-size: 13px; text-align: center; }
    .previewTable th { background: #f4f4f4; font-weight: bold; }
    .previewTable tbody tr:hover { background: #fcfcfc; }
    tbody tr td { border: 1px solid #e2e2e2; padding: 10px; font-size: 13px; text-align: center; }
    .profileBtn { display: flex; justify-content: space-around; flex-direction: row; }
    input { height: 38px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px; padding: 0 10px; line-height: 36px; vertical-align: middle; }
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
    .titleChange {
        font-size: 10px;
    }
</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <c:if test="${isTempPw eq 'Y'}">
        <script>
            
        </script>
    </c:if>
<div id="wrap_area">
	<div id="container">
		<ul>
            <li class="lnb"> 
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>
            <li class="contents">
            	<div class="content">
                    <jsp:include page="/WEB-INF/view/common/header.jsp">
					    <jsp:param name="menu1" value="마이페이지"/>
					    <jsp:param name="refreshUrl" value="${CTX_PATH}/stu/my-page"/>
					</jsp:include>
				
	                <p class="conTitle">
	                    <span>마이페이지</span>
	                </p>
	                    
	                <div class="container">
						<div style="border: 1px solid #dddd; padding: 10px; border-radius: 5px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);">
                            <div style="display: flex; flex-direction: row; justify-content: flex-end;">
                                <div id="baseBtn">
                                    <a href="" class="btn btn-blue" id="basePro">프로필 변경</a>
                                    <a href="" class="btn btn-blue" id="baseInform">정보 수정</a>
                                    <a href="" class="btn btn-blue" id="baseResume">이력서 등록/수정</a>
                                </div>
                                <div id="profileBtn" class="profileBtn" style="display: none;">
                                    <div>
                                        <span id="profileName"></span>
                                        <input type="file" id="profileChange" style="display: none;" accept="image/*">
                                        <a href="" class="btn btn-gray" id="selectFile">사진선택</a>
                                    </div>
                                    
                                    <div>
                                        <a href="" class="btn btn-gray" id="profileCancel">취소</a>
                                        <a href="" class="btn btn-green" id="profileEdit">프로필 변경</a>
                                    </div>
                                </div>
                                <div id="informBtn" style="display: none;">
                                    <a href="" class="btn btn-gray" id="informCancel">취소</a>
                                    <a href="" class="btn btn-green" id="informEdit">정보수정</a>
                                </div>
                                <div id="resumeBtn" style="display: none;" class="profileBtn">
                                    <div>
                                        <span id="selectResumeName"></span>
                                        <input type="file" id="resumeChange" style="display: none;" accept=".pdf,.doc,.docx">
                                        <a href="" class="btn btn-gray" id="selectResume">이력서 선택</a>
                                    </div>
                                    <div>
                                        <a href="" class="btn btn-gray" id="resumeCancel">취소</a>
                                        <a href="" class="btn btn-green" id="resumeEdit">이력서 등록/수정</a>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div style="margin: 20px;">                                
                                    <div>
                                        <table class="previewTable">
                                        <colgroup>
                                            <col style="width: 20%;">
                                            <col style="width: 10%;">
                                            <col style="width: 30%;">
                                            <col style="width: 10%;">
                                            <col style="width: 30%;">
                                        </colgroup>
                                        <tr>
                                            <td rowspan="4"><img style="width: 150px; height: 150px;" id="profile" /></td>
                                        </tr>
                                        <tr>
                                            <th>아이디</th>
                                            <td><span id="loginId"></span></td>
                                            <th>이름</th>
                                            <td><span id="name"></span></td>
                                        </tr>
                                        <tr>
                                            <th>전화번호</th>
                                            <td><span id="phone"></span></td>
                                            <th>이메일</th>
                                            <td><span id="email"></span><input type="text" id="emailInput" value="" style="display: none;"></td>
                                        </tr>
                                        <tr>
                                            <th>주소</th>
                                            <td>
                                                <span id="address"></span> 
                                                <button class="btn btn-gray" id="searchAddress" style="display: none;">주소검색</button>
                                                <input id="zipcodeInput" style="display: none; width: 50px;">
                                                <input type="text" id="addressInput" value="" style="display: none;">
                                                <input type="text" id="address2Input" value="" style="display: none;">
                                            </td>
                                            <th>이력서</th>
                                            <td><span id="resumeName"></span><a href="" id="resumeDwn"></a></td>
                                        </tr>
                                        </table>
                                        <div style="display: flex; justify-content: flex-end; margin-top: 10px;">
                                            <div id="callChnBtn" style="display: none;">
                                                <a class="btn btn-gray" id="chnPw123" href="">비밀번호 변경</a>
                                            </div>
                                            <div style="display: flex; flex-direction: row;">
                                                <div id="pwZone" style="display: none;">
                                                    <label>현재 비밀번호 : </label>
                                                    <input id="oldPw" type="password">
                                                    <label>새 비밀번호 : </label>
                                                    <input id="newPw" type="password">
                                                    <label>새 비밀번호 확인 : </label>
                                                    <input id="newPwConfirm" type="password">
                                                </div>
                                                <div id="callChnBtnDetail" style="display: none;">
                                                    <a class="btn btn-gray" id="chnPwCancel" style="margin-left: 10px;" href="">취소</a>
                                                    <a class="btn btn-green" id="chnPwEdit" href="">확인</a>
                                                </div>
                                            </div>                                                
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div style="margin: 20px;">
                                    <table class="previewTable">
                                        <colgroup>
                                            <col style="width: 10%;">
                                            <col style="width: 10%;">
                                            <col style="width: 50%;">
                                            <col style="width: 10%;">
                                            <col style="width: 10%;">
                                            <col style="width: 10%;">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>번호</th>
                                                <th>과목번호</th>
                                                <th>과목명</th>
                                                <th>평균점수</th>
                                                <th>등급</th>
                                                <th>강의상태</th>
                                            </tr>
                                        </thead>
                                            <tbody id="courseTable">
                                                
                                            </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
	                </div>
                </div>
            </li>
        </ul>
    </div>
</div>
<script>
    let loginID = "";
    let email = "";
    let address = "";
    let address2 = "";
    let zipcode = "";
    let imgName = "";
    let imgLogiPath = "";
    let imgPhyPath = "";
    let resumeName = "";
    let originName = "";

    $(function(){
        // 기본정보
        function userInfo(){
            $.ajax({
                url: "${CTX_PATH}/stu/userInfoAjax",
                type: "POST",
                dataType: "JSON",
                success: (res) => {
                    const defaultImg = "default_profile.png";
                    const imgFileName = res.imgName ? res.imgName : defaultImg;
                    const imgLogiPath = res.imgLogiPath ? res.imgLogiPath : "";

                    const imgUrl = imgLogiPath + imgFileName;
                    console.log(res);
                    $("#profile").attr("src", imgUrl);
                    $("#loginId").text(res?.loginID?? "");
                    $("#name").text(res?.name?? "");
                    $("#phone").text(res?.phone?? "");
                    $("#email").text(res?.email?? "");
                    $("#address").text((res?.zipcode??  "") + " " + (res?.addr1?? "") +  " " + (res?.addr2?? "") );

                    email = (res?.email?? ""); 
                    address = (res?.addr1 ?? ""); 
                    address2 = (res.addr2 ?? ""); 
                    loginID = (res?.loginID?? "");
                    zipcode = (res?.zipcode?? "");
                    resumeName = (res?.resumeName?? "");

                    if (!res.resumeName) {
                        $("#resumeName").text("이력서를 등록해주세요");
                    } else {
                        originName = res.resumeName.split('_').slice(2).join('_');
                        $("#resumeName").text(originName);
                        $("#resumeDwn").text("다운로드");
                        $("#resumeDwn").attr("href", "/stu/resume/download?resumeId=" + res.resumeId);
                    }
                },
                error: (e) => {
                    console.error(e);
                }
            })
        }

        $("#searchAddress").on("click", function () {
            new kakao.Postcode({
                oncomplete: function(data) {
                    $("#addressInput").val(data.address);
                    $("#zipcodeInput").val(data.zonecode);
                }
            }).open();
        });

        // 강의 정보
        function courseTable(){
            $.ajax({
                url: "${CTX_PATH}/stu/getCourseStatus",
                type: "POST",
                dataType: "JSON",
                success: (res) => {
                    let html = "";
                    if(!res.list || res.list.length === 0){
                        html = "<tr>"
                            + "<td colspan='6'>수강중인 강의가 존재하지 않습니다.</td>"
                            + "</tr>"
                    }
                    res.list.forEach((data, index) => {
                        html += "<tr>"
                            + "<td>" + (index + 1) + "</td>"
                            + "<td>" + (data?.courseId?? " - ") + "</td>"
                            + "<td>" + (data?.courseName?? " - ") + "</td>"
                            + "<td>" + (data?.myAvgScore?? " - ") + "</td>"
                            + "<td>" + (data?.grade?? " - ") + "</td>"
                            + "<td>" + (data?.courseStatusName?? " - ") + "</td>"
                            + "</tr>"
                    });
                    $("#courseTable").html(html);
                }
            });
        }

        // 정보수정 버튼
        $("#baseInform").on("click", function(e){
            e.preventDefault();
            $("#baseBtn").hide();
            $("#informBtn").show();

            $("#email").hide();
            $("#address").hide();

            $("#searchAddress").show();
            $("#emailInput").show().val(email);
            $("#addressInput").show().val(address);
            $("#address2Input").show().val(address2);
            $("#zipcodeInput").show().val(zipcode);
            $("#callChnBtn").show();
        })

        // 정보수정 버튼 - 취소
        $("#informCancel").on("click", function(e){
            e.preventDefault();
                Swal.fire({
                    text: "수정 취소 하시겠습니까?",
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "확인",
                    cancelButtonText: "취소",
                    customClass: {
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn',
                        cancelButton: 'btn btn-gray'
                    }
                    }).then((result) => {
                    if (result.isConfirmed) {
                        $("#baseBtn").show();
                        $("#informBtn").hide();

                        $("#email").show();
                        $("#address").show();

                        $("#searchAddress").hide();
                        $("#emailInput").hide();
                        $("#addressInput").hide();
                        $("#address2Input").hide();
                        $("#zipcodeInput").hide();
                        $("#callChnBtn").hide();
                        $("#callChnBtnDetail").hide();
                        $("#pwZone").hide();
                    }
                });
            });

        // 정보수정 버튼 - 확인
         $("#informEdit").on("click", function(e){
                e.preventDefault();
                let data = {
                    loginID: loginID,
                    email: $("#emailInput").val(),
                    zipcode: $("#zipcodeInput").val(),
                    addr1: $("#addressInput").val(),
                    addr2: $("#address2Input").val(),
                };
                
                $.ajax({
                    url: "${CTX_PATH}/stu/updateUserInfo",
                    type: "POST",
                    contentType: "application/json; charset=UTF-8",
                    dataType: "JSON",
                    data: JSON.stringify(data),
                    success: (res) => {
                        if(res.result === "SUCCESS") {
                            Swal.fire({
                                icon: "success",
                                text: "수정되었습니다.",
                                confirmButtonText: "확인",
                                customClass: {
                                    title: 'green',
                                    popup: 'sweetPopUp',
                                    confirmButton: 'btn sweetPopUpBtn'
                                }
                            });
                            $("#baseBtn").show();
                            $("#informBtn").hide();

                            $("#email").show();
                            $("#address").show();

                            $("#searchAddress").hide();
                            $("#emailInput").hide();
                            $("#addressInput").hide();
                            $("#address2Input").hide();
                            $("#zipcodeInput").hide();
                            $("#callChnBtn").hide();
                            $("#callChnBtnDetail").hide();
                            $("#pwZone").hide();
                            userInfo();
                        }else{
                            Swal.fire({
                                icon: "error",
                                text: "오류가 발생했습니다.",
                                confirmButtonText: "확인",
                                customClass: {
                                    title: 'red',
                                    popup: 'sweetPopUp',
                                    confirmButton: 'btn sweetPopUpBtn'
                                }
                            });
                        }
                    },
                    error: (err) => {
                        console.error(err);
                    }
                });
            })

        // 프로필 변경
        $("#basePro").on("click", function(e){
            e.preventDefault();
            $("#baseBtn").hide();
            $("#profileBtn").show();
            $("#profileName").text("");
        });

        // 프로필 변경 취소
        $("#profileCancel").on("click", function(e){
            e.preventDefault();
            Swal.fire({
                    text: "수정 취소 하시겠습니까?",
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "확인",
                    cancelButtonText: "취소",
                    customClass: {
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn',
                        cancelButton: 'btn btn-gray'
                    }
                    }).then((result) => {
                    if (result.isConfirmed) {
                        $("#profileBtn").hide();
                        $("#baseBtn").show();
                        userInfo();
                    }
                });
        });

        // 파일 선택 클릭 이벤트
        $("#selectFile").on("click", function(e){
            e.preventDefault();
            $("#profileChange").click();
        });

        // 프로필 변경 미리보기
        $("#profileChange").on("change", function(e){
            e.preventDefault();
            let file = e.target.files[0];
            $("#profileName").text(file.name);
            if(!file) return;

            let reader = new FileReader();
            reader.onload = function(e){
                $("#profile").attr("src", e.target.result);
            };
            reader.readAsDataURL(file);
        });

        // 프로필 변경 완료
        $("#profileEdit").on("click", function(e){
            e.preventDefault();
            let file = $("#profileChange")[0].files[0];
            if(!file){
                Swal.fire({
                    icon: "warning",
                    text: "사진을 선택해주세요",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }
            let formData = new FormData();
            formData.append("file",file);

            $.ajax({
                url: "${CTX_PATH}/stu/uploadProfileImage",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: (res) => {
                    console.log("xptmxm",res);
                    if(res.result === "SUCCESS"){
                        console.log("test");
                        Swal.fire({
                                icon: "success",
                                text: "수정되었습니다.",
                                confirmButtonText: "확인",
                                customClass: {
                                    popup: 'sweetPopUp',
                                    confirmButton: 'btn sweetPopUpBtn'
                                }
                            }).then(() => {
                                $("#baseBtn").show();
                                $("#profileBtn").hide();
                                location.reload();
                            });
                    }
                },
                error: (e) => {
                    console.error("Change Profile Error",e);
                }
            })
        });

        // 이력서 수정 버튼
        $("#baseResume").on("click", function(e){
            e.preventDefault();
            $("#baseBtn").hide();
            $("#resumeBtn").show();
            $("#resumeDwn").hide();
            $("#selectResumeName").text(originName);
        })

        // 이력서 취소
        $("#resumeCancel").on("click", function(e){
            e.preventDefault();
            Swal.fire({
                    text: "수정 취소 하시겠습니까?",
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "확인",
                    cancelButtonText: "취소",
                    customClass: {
                        title: 'titleChange',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn',
                        cancelButton: 'btn btn-gray'
                    }
                    }).then((result) => {
                    if (result.isConfirmed) {
                        $("#baseBtn").show();
                        $("#resumeBtn").hide();
                        $("#resumeDwn").show();
                    }
            });
        })

        // 파일선택
        $("#selectResume").on("click", function(e){
            e.preventDefault();
            $("#resumeChange").click();
        });

        // 미리보기
        $("#resumeChange").on("change", function(e){
            e.preventDefault();
            let file = e.target.files[0];
            $("#selectResumeName").text(file.name);
            if(!file) return;
        });

        $("#resumeEdit").on("click", function(e){
            e.preventDefault();
            let file = $("#resumeChange")[0].files[0];

            if(!file){
                Swal.fire({
                    icon: "warning",
                    text: "이력서를 선택해주세요.",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }

            const formData = new FormData();
            formData.append("uploadFile", file);

            $.ajax({
                url: "${CTX_PATH}/stu/resume",
                type: "POST",
                data: formData,
                dataType: "JSON",
                processData: false,
                contentType: false,
                success: (res) => {
                    if(res.result === "SUCCESS"){
                        Swal.fire({
                                icon: "success",
                                text: "수정되었습니다.",
                                confirmButtonText: "확인",
                                customClass: {
                                    title: 'green',
                                    popup: 'sweetPopUp',
                                    confirmButton: 'btn sweetPopUpBtn'
                                }
                            });
                        $("#baseBtn").show();
                        $("#resumeBtn").hide();
                        $("#resumeDwn").show();
                        userInfo();
                    }
                }
            })
        });

        // 비밀번호 변경 버튼
        $("#chnPw123").on("click", function(e){
            e.preventDefault();
            $("#callChnBtn").hide();
            $("#callChnBtnDetail").show();
            $("#pwZone").show();
        });

        // 비밀번호 변경 버튼 - 취소
        $("#chnPwCancel").on("click", function(e){
            e.preventDefault();
            $("#callChnBtn").show();
            $("#callChnBtnDetail").hide();
            $("#pwZone").hide();
        });

        // 비밀번호 변경 - 확인
        $("#chnPwEdit").on("click", function(e){
            e.preventDefault();
            let oldPw = $("#oldPw").val();
            let newPw = $("#newPw").val();
            let newPwConfirm = $("#newPwConfirm").val();
            
            if(!oldPw){
                Swal.fire({
                    icon: "warning",
                    text: "현재 비밀번호를 입력해주세요",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }
            if(!newPw){
                Swal.fire({
                    icon: "warning",
                    text: "새 비밀번호를 입력해주세요",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }
            if(!newPwConfirm){
                Swal.fire({
                    icon: "warning",
                    text: "새 비밀번호를 입력해주세요",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }
            if(newPw !== newPwConfirm){
                Swal.fire({
                    icon: "warning",
                    text: "새 비밀번호가 일치하지 않습니다",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }
            if(oldPw === newPw){
                Swal.fire({
                    icon: "warning",
                    text: "새 비밀번호가 이전 비밀번호와 동일합니다",
                    confirmButtonText: "확인",
                    customClass: {
                        title: 'red',
                        popup: 'sweetPopUp',
                        confirmButton: 'btn sweetPopUpBtn'
                    }
                });
                return;
            }
            
            $.ajax({
                url: "${CTX_PATH}/stu/changePassword",
                type: "POST",
                data: {
                    oldPassword: oldPw,
                    newPassword: newPw
                },
                success: (res) => {
                    if(res.result === "SUCCESS"){
                        Swal.fire({
                                icon: "success",
                                text: "비밀번호가 변경되었습니다",
                                confirmButtonText: "확인",
                                customClass: {
                                    title: 'green',
                                    popup: 'sweetPopUp',
                                    confirmButton: 'btn sweetPopUpBtn'
                                }
                            });
                        $("#oldPw").val("");
                        $("#newPw").val("");
                        $("#newPwConfirm").val("");

                        $("#callChnBtn").show();
                        $("#callChnBtnDetail").hide();
                        $("#pwZone").hide();
                    }else if(res.result === "WRONG_OLD_PASSWORD"){
                            Swal.fire({
                            icon: "warning",
                            text: "현재 비밀번호가 올바르지 않습니다.",
                            confirmButtonText: "확인",
                            customClass: {
                                title: 'red',
                                popup: 'sweetPopUp',
                                confirmButton: 'btn sweetPopUpBtn'
                            }
                        });
                    }
                }
            })
        });


        userInfo();
        courseTable();
    })
</script>
</body>
</html>
