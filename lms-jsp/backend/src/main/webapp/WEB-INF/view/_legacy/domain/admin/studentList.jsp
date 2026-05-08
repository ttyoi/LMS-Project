<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/view/domain/admin/userListCSS.jsp"></jsp:include>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>학생 목록</title>

    <script type="text/javascript">
        (function() {
            // 전체 URL
            var href = window.location.href;

            // hash(#) 기준 분리
            var hashIndex = href.indexOf('#');
            var urlNoHash = (hashIndex > -1) ? href.substring(0, hashIndex) : href;
            var hashPart  = (hashIndex > -1) ? href.substring(hashIndex)     : "";

            // 기준 분리
            var qIndex = urlNoHash.indexOf('?');
            if (qIndex > -1) {
                var base = urlNoHash.substring(0, qIndex);

                history.replaceState(null, "", base + hashPart);
            }
        })();
    </script>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

    <script type="text/javascript">
        // 페이징 관련 변수 (서버에서 내려준 값)
        var pageSizeStudent = ${empty pageSize ? 10 : pageSize};   // 한 페이지당 개수
        var pageBlockSizeStudent = 5;                                   // 페이징 블록 크기

        var currentPage = ${currentPage};
        var totalCount  = ${studentCnt};

        $(function () {

            // 공통 페이징 HTML 생성
            var paginationHtml = getPaginationHtml(
                currentPage,
                totalCount,
                pageSizeStudent,
                pageBlockSizeStudent,
                'goStudentPage' // 페이지 이동에 사용할 함수 이름
            );

            $("#studentPagination").html(paginationHtml);

            // 검색 버튼 클릭 시 무조건 1페이지부터 검색
            $("#btnSearchStudent").on("click", function(e){
                e.preventDefault();
                goStudentPage(1);
            });
        });

        // 학생 목록 페이지 이동
        function goStudentPage(page) {

            var pageSize     = pageSizeStudent;
            var sname        = $("#sname").val() || "";
            var searchType   = $("#searchType").val() || "";
            var statusFilter = $("input[name='statusFilter']:checked").val() || "";

            var url = "${CTX_PATH}/admin/stu"
                + "?currentPage=" + page
                + "&pageSize=" + pageSize
                + "&sname=" + encodeURIComponent(sname)
                + "&searchType=" + encodeURIComponent(searchType)
                + "&statusFilter=" + encodeURIComponent(statusFilter);

            location.href = url;
        }

        // 모달 열기 (데이터)
        function openStuDetailModal (loginID) {
                $.ajax({
                    url: "${CTX_PATH}/admin/stu/stuDetail",
                    type: "POST",
                    dataType: "json",
                    data:{
                        loginID: loginID
                    },
                    success: function(res) {
                        $("#detailProfileImg").attr("src", "${CTX_PATH}"+res.img_logi_path + res.img_name);

                        $("#stLoginId").text(res.loginID);
                        $("#userName").text(res.name);
                        $("#stEmail").text(res.email);
                        $("#stZipcode").text(res.zipcode);
                        $("#stAddr").text(res.addr1);
                        $("#stAddrDetail").text(res.addr2);
                        $("#phone").text(res.phone)
                        $("#birthday").text(res.birthday);
                        $("#gender").text(res.gender);
                        $("#reg_date").text(res.reg_date);
                        $("#ret_date").text(res.ret_date);
                        
                        if(res.hasResume && res.resumeName && res.resumeName.trim() !== ""){
                            $("#resumeNameLabel").text(res.resumeName);
                        }else{
                            $("#resumeNameLabel").text("등록된 이력서가 없습니다.");
                        }
                        /* 상태 넣기 */
                        $("#stStatus").val(res.status);
                        /* 모달 열기 */
                        $("#stuDetailModal").fadeIn(200);


                        loadStudentCourses(loginID);
                    },
                    error:function(){
                        alert("상세모달 열기 실패");
                    }
                });
        }

        function loadStudentCourses(loginID){
            $.ajax({
                url: "${CTX_PATH}/admin/stu/courses",
                type: "POST",
                dataType:"json",
                data:{loginID : loginID},
                success: function(res) {
                    if(res.result !== "SUCCESS") {
                        return;
                    }
                    var rows="";
                    $.each(res.list,function(i, item){
                        rows +="<tr>"
                            +"<td>" + item.course_id+"</td>"
                            +"<td>" + item.title+"</td>"
                            +"<td>" + item.start_date+ " ~ "+ item.end_date+"</td>"
                            +"<td>" + item.name+"</td>" // 강사
                            +"<td>" + item.scs_name+"</td>" //
                            +"</tr>";
                    });
                    if(rows ==="") {
                        rows="<tr><td colspan='5'>수강내역이 없습니다.</td></tr>"
                    }

                    $("#stuCourseTbody").html(rows);
                },
                error: function() {
                    console.log("수강내역이 없습니다.");
                }
            });
        }

        function saveStudentStatus() {
            var loginID=$("#stLoginId").text();
            var status = $("#stStatus").val();

            $.ajax({
                url: "${CTX_PATH}/admin/stu/updateStudentStatus",
                type: "POST",
                dataType:"json",
                data:{
                    loginID:loginID,
                    status:status
                },
                success: function(res) {
                    if(res.result ==="SUCCESS"){
                        alert("상태가 저장 되었습니다.");
                        location.reload();
                }else{
                        alert("상태 - 저장에 실패했습니다.");
                    }
                },
                error: function(){
                    alert("상태 - 저장되지 않앗습니다.");
                }

            });
        }

        // 모달 닫기
        function closeModal(){
            $("#stuDetailModal").fadeOut(2000);
        }
        // 이력서 다운로드
        function downloadResume(){
            var loginID = $("#stLoginId").text();
            location.href = "${CTX_PATH}/admin/stu/resumeDownload?loginID=" + encodeURIComponent(loginID);
        }

    </script>

    <style>
        .student-row {
            cursor: pointer;
        }
        .col {
            width: 100%;
            border-collapse: collapse;
        }
        .col th, .col td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .col th {
            background: #f5f5f5;
        }

        .stu-detail-wrap {
            display: flex;
            gap: 25px;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .stu-detail-left {
            width: 160px;
            height: 160px;
        }

        .stu-detail-right {
            flex: 1;
        }

        .stu-detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .stu-detail-table th,
        .stu-detail-table td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            font-size: 14px;
        }

        .stu-detail-table th {
            width: 110px;
            background: #f5f5f5;
            text-align: left;
        }

        .modal-box {
            background: #fff;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.2);

            width: 900px;
            height: 62vh;

            display: flex;
            flex-direction: column;
            box-sizing: border-box;

        }

        /* 이미지 왼쪽 / 정보 오른쪽 */
        .stu-detail-wrap {
            display: flex;
            gap: 25px;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .stu-detail-left {
            width: 160px;
            height: 160px;
        }

        .stu-detail-right {
            flex: 1;
        }

        .stu-detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .stu-detail-table th,
        .stu-detail-table td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            font-size: 14px;
        }

        .stu-detail-table th {
            width: 110px;
            background: #f5f5f5;
            text-align: left;
        }
        .resume-label {
            font-size: medium;
            color: #0d47a1;
        }

    </style>

</head>
<body>
<form id="myForm" action="${CTX_PATH}/admin/stu" method="get">

    <%-- 페이징 값 (컨트롤러에서 다시 읽어감) --%>
    <input type="hidden" id="currentPage" name="currentPage" value="${currentPage}" />
    <input type="hidden" id="pageSize"   name="pageSize"   value="${pageSize}" />

    <div id="wrap_area">

        <h2 class="hidden">header 영역</h2>
        <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

        <h2 class="hidden">컨텐츠 영역</h2>
        <div id="container">
            <ul>
                <li class="lnb">
                    <!-- lnb 영역 -->
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
                    <!--// lnb 영역 -->
                </li>
                <li class="contents">
                    <!-- contents -->
                    <h3 class="hidden">contents 영역</h3>
                    <div class="content">

                        <p class="Location">
                            <a href="../admin/dashboard" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">사용자 관리</span>
                            <span class="btn_nav bold">학생 목록</span>
                            <a href="${CTX_PATH}/admin/stu" class="btn_set refresh">새로고침</a>
                        </p>

                        <p class="conTitle">
                            <span>학생 목록</span>
                            <span class="fr">
                                <select id="searchType" name="searchType" style="width: 120px;">
                                    <option value="all"
                                            <c:if test="${empty searchType or searchType eq ''}">checked="checked"</c:if>>전체</option>
                                    <option value="name"
                                            <c:if test="${searchType eq 'name'}">checked="checked"</c:if>>이름</option>
                                    <option value="regdate"
                                            <c:if test="${searchType eq 'regdate'}">selected</c:if>>가입일자</option>
                                </select>
                                <input type="text"
                                       style="width: 200px; height: 25px;"
                                       id="sname" name="sname"
                                       placeholder="이름 또는 가입일(YYYY-MM-DD)"
                                       value="${sname}"/>

                                <a href="javascript:void(0);" class="btnType blue" id="btnSearchStudent" name="btn">
                                    <span>검  색</span>
                                </a>
                            </span>
                        </p>


                        <p class="subTitle">
                            <label>
                                <input type="radio" name="statusFilter" value=""
                                       <c:if test="${empty statusFilter or statusFilter eq ''}">checked="checked"</c:if> /> 전체
                            </label>
                            <label>
                                <input type="radio" name="statusFilter" value="R"
                                       <c:if test="${statusFilter eq 'R'}">checked="checked"</c:if> /> 등록
                            </label>
                            <label>
                                <input type="radio" name="statusFilter" value="D"
                                       <c:if test="${statusFilter eq 'D'}">checked="checked"</c:if> /> 유예
                            </label>
                            <label>
                                <input type="radio" name="statusFilter" value="Q"
                                       <c:if test="${statusFilter eq 'Q'}">checked="checked"</c:if> /> 탈퇴
                            </label>
                        </p>

                        <div class="divComGrpCodList">
                            <table class="col">
                                <caption>학생 목록</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="20%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">아이디</th>
                                    <th scope="col">이름</th>
                                    <th scope="col">휴대전화</th>
                                    <th scope="col">가입일자</th>
                                    <th scope="col">상태</th>
                                </tr>
                                </thead>
                                <tbody>
                                <!-- 데이터가 0개인 경우 -->
                                <c:if test="${studentCnt == 0}">
                                    <tr>
                                        <td colspan="5">등록된 학생이 없습니다.</td>
                                    </tr>
                                </c:if>

                                <!-- 데이터가 있는 경우 -->
                                <c:if test="${studentCnt > 0}">
                                    <c:forEach items="${studentList}" var="row">
                                        <tr class="student-row" onclick="openStuDetailModal('${row.loginID}')">
                                            <td>${row.loginID}</td>
                                            <td>${row.name}</td>
                                            <td>${row.phone}</td>
                                            <td><fmt:formatDate value="${row.reg_date}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row.status eq 'R'}">등록</c:when>
                                                    <c:when test="${row.status eq 'D'}">유예</c:when>
                                                    <c:when test="${row.status eq 'Q'}">탈퇴</c:when>
                                                    <c:otherwise>${row.status}</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- 페이징 영역 -->
                        <div class="paging_area" id="studentPagination"></div>

                    </div> <!--// content -->

                    <h3 class="hidden">풋터 영역</h3>
                    <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
                </li>
            </ul>
        </div>
    </div>

    <%-- 상세 모달 --%>
    <div id = "stuDetailModal" class="modal-overlay" style="display:none">
        <div class="modal-box edit-modal-box">
            <div class="modal-title"> 학생 상세 정보 </div>
            <div class="modal-scroll-area">
                <div class="stu-detail-wrap">
                    <%-- 왼쪽 사진--%>
                    <div class="stu-detail-left">
                        <img id="detailProfileImg" style="width:100%; height: 100%; border-radius: 4px; background: #eee;">
                    </div>

                    <div class="stu-detail-right">
                        <%-- 오른쪽  학생 정보 --%>
                        <div class="stu-detail-right">
                            <table class="stu-detail-table">
                                <tr>
                                    <th width="20%">아이디</th>
                                    <td id="stLoginId"  width="30%"></td>
                                    <th width="20%">이메일</th>
                                    <td id="stEmail"  width="30%"></td>
                                </tr>
                                <tr>
                                    <th width="20%">이름</th>
                                    <td id="userName" width="30%"></td>
                                    <th width="20%">성별</th>
                                    <td id="gender" width="30%"></td>
                                </tr>
                                <tr>
                                    <th width="20%">전화번호</th>
                                    <td id="phone" width="30%" colspan="3"></td>
                                </tr>
                                <tr>
                                    <th>생일</th>
                                    <td id="birthday"></td>
                                    <th>상태</th>
                                    <td>
                                        <select id="stStatus" class="modal-input">
                                            <option value="R">등록</option>
                                            <option value="D">유예</option>
                                            <option value="Q">탈퇴</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th width="20%">주소</th>
                                    <td id="stAddr" colspan="3"></td>
                                </tr>
                                <tr>
                                    <th width="20%">우편번호</th>
                                    <td id="stZipcode" width="30%"></td>
                                    <th width="20%">상세주소</th>
                                    <td id="stAddrDetail" width="30%"></td>
                                </tr>
                                <tr>
                                    <th>등록날짜</th>
                                    <td id="reg_date"></td>
                                    <th>탈퇴 날짜</th>
                                    <td id="ret_date"></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="modal-subtitle">이력서
                        <a href="javascript:downloadResume();" class="btnType blue"><span>다운로드</span></a>
                        <span id="resumeNameLabel" class="resume-label"></span>
                    </div>
                </div>
                <div>
                    <div class="modal-subtitle">수강내역</div>
                    <div class="stu-detail-right">
                        <table class="stu-detail-table">
                            <thead>
                                <tr>
                                    <th width="15%">강의번호</th>
                                    <th width="25%">강의명</th>
                                    <th width="25%">강의 기간</th>
                                    <th width="20%">강사</th>
                                    <th width="15%">상태</th>
                                </tr>
                            </thead>
                            <tbody id="stuCourseTbody">
                                <tr>

                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class = "modal-btn-wrap">
                <button class="btn-blue" onclick="saveStudentStatus()">저장</button>
                <button class="btn-red" onclick="closeModal()">닫기</button>
            </div>
            <input type="hidden" id="detailStuModal">
        </div>
    </div>
</form>
</body>
</html>
