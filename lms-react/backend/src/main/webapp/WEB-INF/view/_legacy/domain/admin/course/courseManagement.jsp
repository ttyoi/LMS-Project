<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>강의 관리</title>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <link rel="stylesheet" type="text/css" href="${CTX_PATH}/css/admin/courseManagement/courseManagement.css" />

    <link rel="stylesheet" type="text/css" href="${CTX_PATH}/css/admin/courseManagement/courseManagementModal.css" />

    <script type="text/javascript" src="${CTX_PATH}/js/admin/courseManagement/courseManagement.js"></script>

    <script type="text/javascript" src="${CTX_PATH}/js/admin/courseManagement/courseManagementModal.js"></script>

</head>
<body>
<form id="myForm" action="javascript:void(0);"  method="get">

    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">
    <!-- 모달 배경 -->
    <div id="mask"></div>

    <div id="wrap_area">

        <h2 class="hidden">컨텐츠 영역</h2>
        <div id="container">
            <ul>
                <li class="lnb">
                    <!-- lnb 영역 --> <jsp:include
                        page="/WEB-INF/view/common/lnbMenu.jsp"/> <!--// lnb 영역 -->
                </li>
                <li class="contents">
                    <!-- contents -->
                    <h3 class="hidden">contents 영역</h3> <!-- content -->

                    <div class="content" style="margin-bottom:20px;">

                        <p class="Location">
                            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">메인</span> <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>

                        <%--                                                                                    --%>

                        <!-- 👇 강의 목록 헤더 -->
                        <div class="table-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-size: 1.2em; font-weight: bold;">강의 목록</span>

                            <!-- 우측: 셀렉트 박스 - 검색창 - 검색버튼 -->
                            <div style="display: flex; gap: 15px; align-items: center;">
                                <select id="searchType">
                                    <option value="">전체</option>
                                    <option value="instructor">강사명</option>
                                    <option value="course">강의명</option>
                                </select>

                                <div style="display: flex; gap: 5px;">
                                    <input type="text" id="searchKeyword" placeholder="검색" />
                                    <button id="btnSearch">검색</button>
                                </div>
                            </div>
                        </div>

                        <!-- 👇 테이블 행 헤더 -->
                        <div class="table-row-header">
                            <span class="col course-id">과정 번호</span>
                            <span class="col title">강의명</span>
                            <span class="col professor">강사</span>
                            <span class="col class-id">강의실</span>
                            <span class="col period">기간</span>
                            <span class="col req-status">요청상태</span>
                            <span class="col status">상태</span>
                        </div>

                        <!-- 👇 강의 목록이 여기에 표시됨 -->
                        <div id="courseList"></div>

                        <%--                                                    --%>

                        <!-- 페이징 영역 -->
                        <div id="coursePagination" class="pagination"></div>

                    </div>
                </li>
            </ul>
        </div>

    </div>

    <%@ include file="/WEB-INF/view/domain/admin/course/courseManagementModal.jsp" %>


</form>
</body>
</html>