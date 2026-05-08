<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

    <style>
        .mypage-area { padding: 30px; }

        .profile-wrap {
            display: flex;
            gap: 30px;
            padding: 25px;
        }

        .profile-img-box {
            width: 180px;
            height: 200px;
            border-radius: 20px;
            background: #ddd;
        }

        .profile-card {
            background: #e3e3e3;
            padding: 20px 30px;
            border-radius: 20px;
            width: 750px;
            line-height: 1.7;
            font-size: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .mypage-btn-box {
            display: flex;
            gap: 30px;
            margin-top: 15px;
            width: 900px;
            justify-content: flex-end;
        }

        .mypage-btn {
            padding: 20px 30px;
            background: #ddd;
            border-radius: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
            cursor: pointer;
        }

        .course-title {
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 22px;
            font-weight: bold;
        }

        .course-table th, .course-table td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .modal-box {
            background: #fff;
            width: 480px;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.2);
        }

        .modal-title {
            font-size: 22px;
            margin-bottom: 20px;
        }

        .modal-content label {
            margin-top: 15px;
            display: block;
            font-weight: bold;
        }

        .modal-input {
            width: 50%;
            padding: 8px;
            border: 1px solid #aaa;
            border-radius: 5px;
            margin-top: 5px;
        }

        .modal-btn-wrap {
            margin-top: 25px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-blue {
            background: #4a6cf7;
            padding: 8px 20px;
            color: #fff;
            border-radius: 6px;
            border:none;
        }

        .btn-gray {
            background: #ddd;
            padding: 8px 20px;
            border-radius: 6px;
            border: none;
        }

        .edit-modal-box {
            width: 650px;
        }

        .edit-modal-body {
            display: flex;
            gap: 25px;
            margin-bottom: 20px;
        }

        .edit-left {
            width: 180px;
            text-align: center;
        }

        .edit-profile-img {
            width: 160px;
            height: 160px;
            background: #f4caca;
            border-radius: 10px;
            margin: 0 auto 10px auto;
        }

        .img-btn {
            width: 100%;
        }

        .edit-right {
            flex: 1;
        }

        /* 한 줄 */
        .edit-row {
            margin-bottom: 15px;
        }

        .edit-row label {
            display: inline-block;
            width: 90px;
            font-weight: bold;
        }

        .readonly-text {
            padding: 6px 10px;
            background: #fafafa;
            border-radius: 5px;
            display: inline-block;
        }

        .addr-flex {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .small {
            padding: 5px 20px;
            font-size: 13px;
        }

    </style>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
        function findAddr() {
            new daum.Postcode({
                oncomplete: function(data) {
                    $("#editAddr").val(data.address);
                    $("#editZipcode").text(data.zonecode);
                }
            }).open();
        }
    </script>

    <script type="text/javascript">
        $(function () {
            loadUserInfo();
            loadCourseStatus();

            $("#profileFile").on("change", function(event) {
                let file = event.target.files[0];
                if (!file) return;

                let reader = new FileReader();
                reader.onload = function(e) {
                    $("#editProfileImg").attr("src", e.target.result);
                };
                reader.readAsDataURL(file);

            });

            $(".img-btn").click(function() {
                openPhotoModal();
            });

            $("#photoFile").on("change", function(event) {
                const file = event.target.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = function(e) {
                    $("#previewImg").attr("src", e.target.result);
                };
                reader.readAsDataURL(file);
            });
        });


        function loadUserInfo() {
            $.ajax({
                url: "/stu/userInfoAjax",
                type: "POST",
                dataType: "json",
                success: function (res) {
                    $("#loginId").text(res.loginID);
                    $("#name").text(res.name);
                    $("#phone").text(res.phone);
                    $("#email").text(res.email);

                    const defaultImgName = "default_profile.jpg";

                    const finalImgName = res.imgName ? res.imgName : defaultImgName;
                    const imgLogiPath = res.imgLogiPath ? res.imgLogiPath : "";

                    const imageUrl = imgLogiPath + finalImgName;
                    console.log("Image URL to load:", imageUrl);

                    $("#profileImg").attr("src", imageUrl);

                    let type = "";
                    if (res.userType == "S") type = "교육생";
                    else if (res.userType == "I") type = "강사";
                    else if (res.userType == "A") type = "관리자";
                    $("#userType").text(type);

                    if (!res.resumeName) {
                        $("#resumeArea").html("등록된 이력서 없음");
                    } else {
                        $("#resumeArea").html(
                            "<a href='/stu/resume/download?resumeId=" + res.resumeId + "'>" +
                            res.resumeName +
                            "</a>"
                        );
                    }
                },
                error: function () {
                    alert("마이페이지 정보를 불러오지 못했습니다.");
                }
            });
        }

        function loadCourseStatus() {
            $.ajax({
                url: "/stu/getCourseStatus",
                method: "POST",
                dataType: "json",
                success: function(res) {

                    let html = "";

                    res.list.forEach(function(item, index) {

                        let myAvg = item.myAvgScore != null ? item.myAvgScore.toFixed(1) : "-";
                        let grade = (item.grade == null ? "-" : item.grade);

                        html += "<tr>"
                            + "<td>" + (index + 1) + "</td>"
                            + "<td>"
                            +   "<a href='#' class='course-detail' data-course-id='" + item.courseId + "'>"
                            +       item.courseName
                            +   "</a>"
                            + "</td>"
                            + "<td>" + myAvg + "</td>"
                            + "<td>" + grade + "</td>"
                            + "</tr>";
                    });

                    $("#courseStatusBody").html(html);

                    $(".course-detail").on("click", function(e) {
                        e.preventDefault();
                        let courseId = $(this).data("course-id");
                        openPeriodModal(courseId);
                    });
                }
            });
        }


        function openPhotoModal() {
            $("#photoFile").val("");

            $.ajax({
                url: "/stu/userInfoAjax",
                type: "POST",
                dataType: "json",
                success: function(res) {

                    const defaultImgName = "default_profile.png";

                    const finalImgName = res.imgName ? res.imgName : defaultImgName;
                    const imgLogiPath = res.imgLogiPath ? res.imgLogiPath : "";

                    const imageUrl = imgLogiPath + finalImgName;

                    $("#previewImg").attr("src", imageUrl);

            gfModalPop("#photoModal");
        },
                error: function() {
                    alert("프로필 정보를 불러오는 데 실패했습니다.");

                    $("#previewImg").attr("src", "/profile/default_profile.png");
                    gfModalPop("#photoModal");
                }
            });
        }

        function closePhotoModal() {
            $("#photoModal").fadeOut(180);
        }

        function selectPhoto() {
            $("#photoFile").click();
        }

        function uploadPhoto() {
            let file = $("#photoFile")[0].files[0];
            if (!file) {
                alert("사진을 선택하세요.");
                return;
            }

            let formData = new FormData();
            formData.append("file", file);

            $.ajax({
                url: "/stu/uploadProfileImage",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(res) {
                    if (res.result === "SUCCESS") {
                        alert("프로필 사진이 변경되었습니다.");

                        $("#profileImg").attr("src", res.imgLogiPath + res.imgName + "?v=" + Date.now());
                        $("#editProfileImg").attr("src", res.imgLogiPath + res.imgName + "?v=" + Date.now());

                        closePhotoModal();
                    } else {
                        alert("업로드 실패");
                    }
                }
            });
        }

        function openCustomModal() {

            $.ajax({
                url: "/stu/userInfoAjax",
                type: "POST",
                dataType: "json",
                success: function(res) {

                    const defaultImgName = "default_profile.png";
                    const finalImgName = res.imgName ? res.imgName : defaultImgName;
                    const imgLogiPath = res.imgLogiPath ? res.imgLogiPath : "";

                    const imageUrl = imgLogiPath + finalImgName;
                    $("#editProfileImg").attr("src", imageUrl);


                    $("#editLoginId").text(res.loginID);
                    $("#userName").text(res.name);
                    $("#editEmail").val(res.email);
                    $("#editZipcode").text(res.zipcode);
                    $("#editAddr").val(res.addr1);
                    $("#editAddrDetail").val(res.addr2);


                    gfModalPop("#customModal");
                }
            });
        }


        function closeCustomModal() {
            $("#customModal").fadeOut(180);
        }

        function saveUserInfo() {

            let data = {
                loginID: $("#editLoginId").text(),
                email: $("#editEmail").val(),
                zipcode: $("#editZipcode").text(),
                addr1: $("#editAddr").val(),
                addr2: $("#editAddrDetail").val(),
            };

            if(!confirm("저장하시겠습니까?")) return;

            $.ajax({
                url: "/stu/updateUserInfo",
                type: "POST",
                data: data,
                success: function(res) {
                    if (res.result === "SUCCESS") {
                        alert("저장 완료되었습니다.");
                        loadUserInfo();
                        closeCustomModal();
                    } else {
                        alert("저장 중 오류 발생");
                    }
                }
            });
        }
        function closeEditModal() {
            $("#userName, #editEmail, #editAddr, #editAddrDetail").val("");
            gfCloseModal();
        }

        function openPwModal() {

            $("#oldPw").val("");
            $("#newPw").val("");
            $("#newPwCheck").val("");

            gfModalPop("#pwModal");
        }

        function closePwModal() {

            $("#oldPw").val("");
            $("#newPw").val("");
            $("#newPwCheck").val("");

            $("#pwModal").fadeOut(200);
        }

        function savePassword() {

            let oldPw = $("#oldPw").val();
            let newPw = $("#newPw").val();
            let newPwCheck = $("#newPwCheck").val();

            if (!oldPw) {
                alert("현재 비밀번호를 입력하세요.");
                return;
            }
            if (!newPw) {
                alert("새 비밀번호를 입력하세요.");
                return;
            }
            if (newPw !== newPwCheck) {
                alert("새 비밀번호가 일치하지 않습니다.");
                return;
            }
            if (oldPw === newPw) {
                alert("현재 비밀번호와 새 비밀번호가 같습니다. 다른 비밀번호를 입력하세요.");
                return;
            }


            if (!confirm("비밀번호를 변경하시겠습니까?")) return;

            $.ajax({
                url: "/stu/changePassword",
                type: "POST",
                data: {
                    oldPassword: oldPw,
                    newPassword: newPw
                },
                success: function(res) {
                    if (res.result === "SUCCESS") {
                        alert("비밀번호가 변경되었습니다.");
                        closePwModal();
                    }
                    else if (res.result === "WRONG_OLD_PASSWORD") {
                        alert("현재 비밀번호가 올바르지 않습니다.");
                    }
                    else if (res.result === "SAME_PASSWORD") {
                        alert("새 비밀번호가 현재 비밀번호와 동일합니다. 다른 비밀번호를 입력하세요");
                    }
                    else {
                        alert("비밀번호 변경 실패");
                    }
                }

            });
        }

        function resumeInsertModal() {
            $("#resumeFile").val('');
            $("#uploadResumeArea").text('');
            gfModalPop("#resumeModal");
        }

        function selectResume() {
            $("#resumeFile").click();
        }

        $(document).ready(function() {
            $("#resumeFile").on("change", function() {
                const file = this.files[0];
                if(file) {
                    $("#uploadResumeArea").text(file.name);
                } else {
                    $("#uploadResumeArea").text("");
                }
            });
        });


        function uploadResume() {
            const fileInput = $("#resumeFile")[0];
            const file = fileInput.files[0];

            if (!file) {
                alert("이력서 파일을 먼저 선택해주세요.");
                return;
            }

            if(!confirm("[" + file.name + "] 파일을 이력서로 등록하시겠습니까?")) {
                return;
            }

            const formData = new FormData();
            formData.append("uploadFile", file);

            $.ajax({
                url: "/stu/resume",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                dataType: "json",
                success: function(res) {
                    if (res.result === "SUCCESS") {
                        alert("이력서 등록이 완료되었습니다.");
                        loadUserInfo();
                        closeResumeModal();
                    } else if (res.result === "SESSION_EXPIRED") {
                        alert("세션이 만료되었습니다. 다시 로그인해주세요.");
                    } else {
                        alert("이력서 등록 중 오류 발생: " + (res.message || "서버 오류"));
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error:", error);
                    alert("서버 통신 오류가 발생했습니다.");
                }
            });
        }
        function closeResumeModal() {
            $("#resumeModal").hide();
            $("#resumeFile").val('');
            $("#uploadResumeArea").text('');
        }

        function openPeriodModal(courseId) {

            $.ajax({
                url: "/stu/getPeriodScores",
                method: "POST",
                data: { courseId: courseId },
                success: function(res) {

                    let html = "";

                    res.periodScores.forEach(function(p) {

                        let student = (p.studentScore == null ? 0 : p.studentScore);
                        let total   = (p.totalScore == null ? 0 : p.totalScore);

                        html += "<tr>"
                            + "<td>" + p.period + "차시</td>"
                            + "<td>" + student + "</td>"
                            + "<td>" + total + "</td>"
                            + "</tr>";
                    });

                    $("#periodScoreBody").html(html);
                    $("#periodModal").show();
                }
            });
        }

        function closePeriodModal() {
            $("#periodModal").fadeOut(150);
        }





    </script>

</head>

<body>

<c:if test="${isTempPw eq 'Y'}">
    <script>
        alert("임시 비밀번호입니다.\n정보 수정에서 반드시 비밀번호를 변경해주세요.");
    </script>
</c:if>

<div id="wrap_area">

    <!-- HEADER -->
    <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

    <div id="container">
        <ul>
            <!-- LNB -->
            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
            </li>

            <!-- CONTENT -->
            <li class="contents">
                <div class="content mypage-area">

                    <p class="Location">
                        <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                        <span class="btn_nav bold">마이 페이지</span>
                    </p>

                    <p class="conTitle">
                        <span>마이 페이지</span>
                    </p>

                    <!-- 프로필 영역 -->
                    <div class="profile-wrap">
                        <div class="profile-img-box">
                            <img id="profileImg" style="width:100%; height:100%; border-radius:4px;">
                        </div>

                        <div class="profile-card">
                            아이디: <span id="loginId"></span><br>
                            이름: <span id="name"></span><br>
                            전화번호: <span id="phone"></span><br>
                            이메일: <span id="email"></span><br>
                            구분: <span id="userType"></span><br>
                            이력서: <span id="resumeArea"></span>
                        </div>
                    </div>

                    <div class="mypage-btn-box">
                        <a class="mypage-btn"  href="javascript:void(0)" onclick="openCustomModal()">정보수정</a>
                        <a class="mypage-btn" href="javascript:void(0)" onclick="resumeInsertModal(); return false">이력서 등록</a>
                    </div>

                    <!-- 수강 현황 -->
                    <div class="course-title">수강 현황</div>

                    <table class="col">

                        <thead>
                        <tr>
                            <th>NO</th>
                            <th>수강과목</th>
                            <th>평균점수</th>
                            <th>성적</th>
                        </tr>
                        </thead>
                        <tbody id="courseStatusBody"></tbody>
                    </table>

                </div>

                <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
            </li>
        </ul>
    </div>
</div>

<!-- 개인정보 수정 모달 -->
<div id="customModal" class="modal-overlay" style="display:none;">
    <div class="modal-box edit-modal-box">

        <h2 class="modal-title">개인정보 수정 (교육생)</h2>

        <div class="edit-modal-body">

            <div class="edit-left">
                <div class="edit-profile-img">
                    <img id="editProfileImg" style="width:100%; height:100%; border-radius:4px;">
                </div>
                <button class="btn-gray img-btn">사진첨부</button>
                <input type="file" id="profileFile" style="display:none;" accept="image/*">
            </div>

            <div class="edit-right">

                <div class="edit-row">
                    <label>아이디</label>
                    <div id="editLoginId" class="readonly-text"></div>
                </div>

                <div class="edit-row">
                    <label>비밀번호</label>
                    <button class="btn-gray small" onclick="openPwModal()">수정</button>

                </div>

                <div class="edit-row">
                    <label>이름</label>
                    <div id="userName" class="readonly-text"></div>
                </div>

                <div class="edit-row">
                    <label>이메일</label>
                    <input type="text" id="editEmail" class="modal-input">
                </div>

                <label>우편번호</label>
                <div class="addr-flex">
                    <div id="editZipcode" class="readonly-text"></div>
                </div>

                <div class="edit-row">
                    <label>주소</label><br/>
                    <div class="addr-flex">
                        <input type="text" id="editAddr" class="modal-input" readonly>
                        <button class="btn-gray small" onclick="findAddr()">검색</button>
                    </div>
                </div>

                <div class="edit-row">
                    <label>상세주소</label><br/>
                    <input type="text" id="editAddrDetail" class="modal-input">
                </div>

            </div>

        </div>

        <div class="modal-btn-wrap">
            <button class="btn-blue" onclick="saveUserInfo()">저장</button>
            <button class="btn-gray" onclick="closeCustomModal()">취소</button>
        </div>

    </div>
</div>

<!-- 비밀번호 수정 모달 -->
<div id="pwModal" class="modal-overlay" style="display:none;">
    <div class="modal-box" style="width:420px;">

        <h2 class="modal-title">비밀번호 변경</h2>

        <div class="modal-content">

            <label>현재 비밀번호</label>
            <input type="password" id="oldPw" class="modal-input">

            <label>새 비밀번호</label>
            <input type="password" id="newPw" class="modal-input">

            <label>새 비밀번호 확인</label>
            <input type="password" id="newPwCheck" class="modal-input">

        </div>

        <div class="modal-btn-wrap">
            <button class="btn-blue" onclick="savePassword()">저장</button>
            <button class="btn-gray" onclick="closePwModal()">취소</button>
        </div>

    </div>
</div>

<!--사진 업로드 모달-->
<div id="photoModal" class="modal-overlay" style="display:none;">
    <div class="modal-box" style="width:420px;">
        <h2 class="modal-title">프로필 사진 업로드</h2>

        <div style="text-align:center; margin-bottom:15px;">
            <img id="previewImg" src=""
                 style="width:150px; height:150px; border-radius:8px; background:#eee;">
        </div>

        <input type="file" id="photoFile" accept="image/*" style="display:none;">

        <div style="display:flex; justify-content:center; gap:10px;">
            <button class="btn-gray" onclick="selectPhoto()">사진 선택</button>
            <button class="btn-blue" onclick="uploadPhoto()">업로드</button>
        </div>

        <div class="modal-btn-wrap" style="margin-top:20px;">
            <button class="btn-gray" onclick="closePhotoModal()">닫기</button>
        </div>
    </div>
</div>

<!--이력서 업로드 모달-->
<div id="resumeModal" class="modal-overlay" style="display:none;">
    <div class="modal-box" style="width:420px;">
        <h2 class="modal-title">이력서 업로드</h2>

        <div style="text-align:center; margin-bottom:15px;">
            <span id="uploadResumeArea" src=""></span>
        </div>

        <input type="file" id="resumeFile" accept=".pdf,.doc,.docx" style="display:none;">

        <div style="display:flex; justify-content:center; gap:10px;">
            <button class="btn-gray" onclick="selectResume()">첨부파일 선택</button>
            <button class="btn-blue" onclick="uploadResume()">업로드</button>
        </div>

        <div class="modal-btn-wrap" style="margin-top:20px;">
            <button class="btn-gray" onclick="closeResumeModal()">닫기</button>
        </div>
    </div>
</div>
<!--차시별 점수 모달-->
<div id="periodModal" class="modal-overlay" style="display:none;">
    <div class="modal-box" style="width:480px;">

        <h2 class="modal-title">차시별 점수</h2>

        <table class="col">
            <thead>
            <tr>
                <th>차시</th>
                <th>점수</th>
                <th>총점</th>
            </tr>
            </thead>
            <tbody id="periodScoreBody"></tbody>
        </table>

        <div class="modal-btn-wrap" style="margin-top:20px;">
        <button class="btn-gray" onclick="closePeriodModal()">닫기</button>
    </div>
</div>
</div>



</body>
</html>
