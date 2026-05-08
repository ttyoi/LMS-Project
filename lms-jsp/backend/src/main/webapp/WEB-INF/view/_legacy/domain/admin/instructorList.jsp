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
    <title>강사 목록</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/join_instructor/registerModal.css"/>
    <script src="${pageContext.request.contextPath}/js/join_instruc/joinInstructor.js"></script>

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
        var pageSizeInstructor = ${empty pageSize ? 10 : pageSize};   // 한 페이지당 개수
        var pageBlockSizeInstructor = 5;                                   // 페이징 블록 크기

        var currentPage = ${currentPage};
        var totalCount  = ${instructorCnt};

        $(function () {

            // 공통 페이징 HTML 생성
            var paginationHtml = getPaginationHtml(
                currentPage,
                totalCount,
                pageSizeInstructor,
                pageBlockSizeInstructor,
                'goInstructorPage' // 페이지 이동에 사용할 함수 이름
            );

            $("#instructorPagination").html(paginationHtml);

            // 검색 버튼 클릭 시 무조건 1페이지부터 검색
            $("#btnSearchInstructor").on("click", function(e){
                e.preventDefault();
                goInstructorPage(1);
            });
        });

        // 강사 목록 페이지 이동
        function goInstructorPage(page) {

            var pageSize     = pageSizeInstructor;
            var sname        = $("#sname").val() || "";
            var searchType   = $("#searchType").val() || "";
            var statusFilter = $("input[name='statusFilter']:checked").val() || "";

            var url = "${CTX_PATH}/admin/inst"
                + "?currentPage=" + page
                + "&pageSize=" + pageSize
                + "&sname=" + encodeURIComponent(sname)
                + "&searchType=" + encodeURIComponent(searchType)
                + "&statusFilter=" + encodeURIComponent(statusFilter);

            location.href = url;
        }

        // 모달 열기
        function openInstDetailModal (loginID){
            $.ajax({
                url:"${CTX_PATH}/admin/inst/instDetail",
                type:"POST",
                dataType:"json",
                data:{
                    loginID: loginID
                },
                success: function(res) {
                    $("#detailProfileImg").attr("src", "${CTX_PATH}"+res.img_logi_path + res.img_name);

                    $("#instLoginId").text(res.loginID);
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
                    $("#edu_level").text(res.edu_level); // 학력
                    $("#career").text(res.career);// 경력
                    /* 상태 넣기 */
                    $("#instStatus").val(res.status);
                    /* 모달 열기 */
                    $("#instDetailModal").fadeIn(200);

                    loadInstEval(loginID);

                    loadInstructorCourses(loginID);
                },
                error:function(){
                    alert("상세모달 열기 실패");
                }
            });
        }

        function loadInstEval(loginID){
            $.ajax({
                url:"${CTX_PATH}/admin/inst/eval",
                type: "POST",
                dataType: "json",
                data:{loginID : loginID},
                success: function(res) {
                    if(res.result === "SUCCESS"){
                        $("#instEvalContent").val(res.content);
                    }
                }
            })
        }

        function saveInstAll() {
            var loginID = $("#instLoginId").text();
            var status = $("#instStatus").val();
            var content = $("#instEvalContent").val();

            // 1) 상태 먼저 저장
            $.ajax({
                url: "${CTX_PATH}/admin/inst/updateInstructorStatus",
                type: "POST",
                dataType:"json",
                data:{
                    loginID: loginID,
                    status:  status
                },
                success: function(res1) {
                    if(res1.result !== "SUCCESS"){
                        alert("상태 저장에 실패했습니다.");
                        return;
                    }

                    // 2) 상태 저장 성공하면 평가 저장
                    $.ajax({
                        url: "${CTX_PATH}/admin/inst/eval/save",
                        type: "POST",
                        dataType: "json",
                        data: {
                            loginID: loginID,
                            content: content
                        },
                        success: function(res2) {
                            if(res2.result === "SUCCESS") {
                                alert("상태/평가가 모두 저장되었습니다.");
                                location.reload();
                            } else {
                                alert("평가 저장에 실패했습니다.");
                            }
                        },
                        error: function() {
                            alert("평가 저장 중 오류가 발생했습니다.");
                        }
                    });
                },
                error: function(){
                    alert("상태 저장 중 오류가 발생했습니다.");
                }
            });
        }

        function loadInstCourses(loginID){
            $.ajax({
                url: "${CTX_PATH}/admin/inst/courses",
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
                            + "<td>" + item.class_name + "</td>"
                            + "<td>" + item.student_cnt + "</td>"   // 수강생 수
                            + "<td>" + item.scs_name + "</td>"     // 상태
                            +"</tr>";
                    });
                    if(rows ==="") {
                        rows="<tr><td colspan='7'>수강내역이 없습니다.</td></tr>"
                    }

                    $("#instCourseTbody").html(rows);
                },
                error: function() {
                    console.log("수강내역이 없습니다.");
                }
            });
        }

        function loadInstructorCourses(loginID){
            $.ajax({
                url: "${CTX_PATH}/admin/inst/courses",
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
                            +"<td>" + item.start_time+ " ~ "+ item.end_time+"</td>"
                            +"<td>" + item.class_name+"</td>" // 강의실
                            +"<td>" + item.student_cnt+"</td>" // 수강생 수
                            +"<td>" + item.scs_name+"</td>" // 상태명
                            +"</tr>";
                    });
                    if(rows ==="") {
                        rows="<tr><td colspan='7'>강의내역이 없습니다.</td></tr>"
                    }

                    $("#instCourseTbody").html(rows);
                },
                error: function() {
                    console.log("수강내역이 없습니다.");
                }
            });
        }


        // 모달 닫기
        function closeModal(){
            $("#instDetailModal").fadeOut(200);
        }
    </script>
    <style>
        .instructor-row {
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

        .inst-detail-wrap {
            display: flex;
            gap: 25px;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .inst-detail-left {
            width: 160px;
            height: 160px;
        }

        .inst-detail-right {
            flex: 1;
        }

        .inst-detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .inst-detail-table th,
        .inst-detail-table td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            font-size: 14px;
        }

        .inst-detail-table th {
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
            height: 85vh;

            display: flex;
            flex-direction: column;
            box-sizing: border-box;

        }

        /* 이미지 왼쪽 / 정보 오른쪽 */
        .inst-detail-wrap {
            display: flex;
            gap: 25px;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .inst-detail-left {
            width: 160px;
            height: 160px;
        }

        .inst-detail-right {
            flex: 1;
        }

        .inst-detail-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        .inst-detail-table th,
        .inst-detail-table td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            font-size: 14px;
        }

        .inst-detail-table th {
            width: 110px;
            background: #f5f5f5;
            text-align: left;
        }

        .memo {
            width: 100%;
            min-height: 80px;
            max-height: 160px;
            padding: 8px 10px;
            margin-bottom: 15px;

            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #fafafa;

            font-size: 13px;
            line-height: 1.5;
            color: #333;

            overflow-y: auto;
            box-sizing: border-box;
        }

        .memo span {
            white-space: pre-wrap;
            word-break: break-all;
        }
        .instTextArea {
            width: 100%;
            min-height: 80px;
            max-height: 180px;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #d0d0d0;
            font-size: 13px;
            line-height: 1.5;
            resize: vertical;
            box-sizing: border-box;
            box-sizing: border-box;
        }
    </style>

</head>
<body>
<form id="myForm" action="${CTX_PATH}/admin/inst" method="get">

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
                            <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">사용자 관리</span>
                            <span class="btn_nav bold">강사 목록</span>
                            <a href="${CTX_PATH}/admin/inst" class="btn_set refresh">새로고침</a>
                        </p>

                        <p class="conTitle">
                            <span>강사 목록</span>
                            <span class="fr">
                                <select id="searchType" name="searchType" style="width: 120px;">
                                    <option value="all"
                                            <c:if test="${empty searchType or searchType eq 'all'}">selected</c:if>>전체</option>
                                    <option value="name"
                                            <c:if test="${searchType eq 'name'}">selected</c:if>>이름</option>
                                    <option value="regdate"
                                            <c:if test="${searchType eq 'regdate'}">selected</c:if>>가입일자</option>
                                </select>
                                <input type="text"
                                       style="width: 200px; height: 25px;"
                                       id="sname" name="sname"
                                       placeholder="이름 또는 가입일(YYYY-MM-DD)"
                                       value="${sname}"/>

                                <a href="javascript:void(0);" class="btnType blue" id="btnSearchInstructor" name="btn">
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
                                <input type="radio" name="statusFilter" value="W"
                                       <c:if test="${statusFilter eq 'W'}">checked="checked"</c:if> /> 등록중
                            </label>
                            <label>
                                <input type="radio" name="statusFilter" value="R"
                                       <c:if test="${statusFilter eq 'R'}">checked="checked"</c:if> /> 재직중
                            </label>
                            <label>
                                <input type="radio" name="statusFilter" value="D"
                                       <c:if test="${statusFilter eq 'D'}">checked="checked"</c:if> /> 휴가
                            </label>
                            <label>
                                <input type="radio" name="statusFilter" value="Q"
                                       <c:if test="${statusFilter eq 'Q'}">checked="checked"</c:if> /> 탈퇴
                            </label>
                        </p>
                        <button id="regInstructor" type="button" class="blue-btn" onclick="registerInstructor()">강사 등록</button>

                        <div class="divComGrpCodList">
                            <table class="col">
                                <caption>강사 목록</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="20%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">강사명</th>
                                    <th scope="col">아이디</th>
                                    <th scope="col">휴대전화</th>
                                    <th scope="col">가입일자</th>
                                    <th scope="col">상태</th>
                                </tr>
                                </thead>
                                <tbody>
                                <!-- 데이터가 0개인 경우 -->
                                <c:if test="${instructorCnt == 0}">
                                    <tr>
                                        <td colspan="5">등록된 강사가 없습니다.</td>
                                    </tr>
                                </c:if>

                                <!-- 데이터가 있는 경우 -->
                                <c:if test="${instructorCnt > 0}">
                                    <c:forEach items="${instructorList}" var="row">
                                        <tr class="instructor-row" onclick="openInstDetailModal('${row.loginID}')">
                                            <td>${row.name}</td>
                                            <td>${row.loginID}</td>
                                            <td>${row.phone}</td>
                                            <td><fmt:formatDate value="${row.reg_date}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row.status eq 'R'}">재직중</c:when>
                                                    <c:when test="${row.status eq 'W'}">등록중</c:when>
                                                    <c:when test="${row.status eq 'D'}">휴가</c:when>
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
                        <div class="paging_area" id="instructorPagination"></div>

                    </div> <!--// content -->

                    <h3 class="hidden">풋터 영역</h3>
                    <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
                </li>
            </ul>
        </div>
    </div>
        <%-- 상세 모달 --%>
        <div id = "instDetailModal" class="modal-overlay" style="display:none">
            <div class="modal-box edit-modal-box">
                <div class="modal-title">강사 상세 정보</div>
                <div class="modal-scroll-area">
                    <div class="inst-detail-wrap">
                        <%-- 왼쪽 사진--%>
                        <div class="inst-detail-left">
                            <img id="detailProfileImg" style="width:100%; height: 100%; border-radius: 4px; background: #eee;">
                        </div>
                            <%-- 오른쪽  학생 정보 --%>
                        <div class="inst-detail-right">
                            <div class="inst-detail-right">
                                <table class="inst-detail-table">
                                    <tr>
                                        <th width="20%">아이디</th>
                                        <td id="instLoginId"  width="30%"></td>
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
                                            <select id="instStatus" class="modal-input">
                                                <option value="R">재직중</option>
                                                <option value="D">휴가</option>
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
                        <div class="modal-subtitle">학력사항</div>
                        <div class="memo">
                            <span id="edu_level"></span><br>
                        </div>
                    </div>
                    <div>
                        <div class="modal-subtitle">경력사항</div>
                        <div class="memo">
                            <span id="career"></span><br>
                        </div>
                    </div>
                    <div>
                        <div class="modal-subtitle">수강내역</div>
                        <div class="inst-detail-right">
                            <table class="inst-detail-table">
                                <thead>
                                <tr>
                                    <th width="10%">강의번호</th>
                                    <th width="20%">강의명</th>
                                    <th width="20%">강의 기간</th>
                                    <th width="15%">강의 시간</th>
                                    <th width="15%">강의실</th>
                                    <th width="10%">수강생 수</th>
                                    <th width="10%">상태</th>
                                </tr>
                                </thead>
                                <tbody id="instCourseTbody">
                                <tr>

                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div>
                        <div class="modal-subtitle">강의 평가 / 특이사항</div>
                        <textarea id="instEvalContent" class="instTextArea">

                        </textarea>
                    </div>

                </div>
                <div class = "modal-btn-wrap">
                    <button type="button" class="btn-blue" onclick="saveInstAll()">저장</button>
                    <button type="button" class="btn-red" onclick="closeModal()">닫기</button>
                </div>
                <input type="hidden" id="detailInstModal">
            </div>
        </div>
</form>
<jsp:include page="../instructor/iJoin/registerIntrucModal.jsp"/>
</body>
</html>
