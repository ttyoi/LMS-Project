<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>강의실 관리</title>
    <!-- 페이지 전용 CSS -->
    <link rel="stylesheet" type="text/css" href="${CTX_PATH}/css/admin/classroom/classroom.css" />

    <link rel="stylesheet" type="text/css" href="${CTX_PATH}/css/admin/classroom/classroomModal.css" />

    <!-- 페이지 전용 JS -->

    <!-- 공통 include -->
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <script type="text/javascript" src="${CTX_PATH}/js/admin/classroom/classroomModal.js"></script>
</head>
<body>
<form id="myForm" action="javascript:void(0);" method="get">
    <!-- 페이지 상태용 hidden -->
    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">

    <!-- 모달 배경 -->
    <div id="mask"></div>

    <div id="wrap_area">
        <h2 class="hidden">컨텐츠 영역</h2>
        <div id="container">
            <ul>
                <!-- LNB 메뉴 -->
                <li class="lnb">
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
                </li>

                <!-- 페이지 본문 -->
                <li class="contents">
                    <h3 class="hidden">contents 영역</h3>

                    <div class="content" style="margin-bottom:20px;">

                    <p class="Location">
                        <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                        <span class="btn_nav bold">메인</span> <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                    </p>

                        <!-- 상단 강의실 관리 박스 -->
                        <div class="content-header-box">
                            <span class="conTitle">강의실 관리</span>

                            <div class="header-right">
                                <label for="searchKeyword" class="search-label">강의실 명</label>
                                <input type="text" id="searchKeyword" placeholder="검색"/>
                                <div class="button-group">
                                    <button type="button" id="btnSearch">검색</button>
                                    <button type="button" id="btnAdd">등록</button>
                                </div>
                            </div>
                        </div>

                        <!-- 강의실 목록 박스 -->
                        <div class="content-box classroom-list-box">
                            <span class="small-label">강의실 목록</span>
                        </div>

                        <!-- 테이블 헤더 -->
                        <div class="content-box table-header">
                            <span class="classroom-name">강의실 명</span>
                            <span class="student-count">인원수</span>
                            <span class="actions"></span>
                        </div>

                        <!-- 강의실 리스트 컨테이너 -->
                        <div id="classroomList" class="content-box-container">
                            <!-- JS가 여기 안에 동적으로 <div class="content-box table-row">를 추가합니다 -->
                        </div>

                        <div id="classroomPagination" class="pagination"></div>

                    </div>
                </li>
            </ul>
        </div>
    </div>

    <%@ include file="/WEB-INF/view/domain/admin/classroom/classroomModal.jsp" %>


</form>
</body>
</html>
