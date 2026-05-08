<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 5:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="/css/exam/style.css" />
    <link rel="stylesheet" href="/css/admin/aDashboard/dashboard.css" />


    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

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
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>대시보드</span>

                            </p>
                            <div class="container">

<%--   /////////////////////////////////////////////////////////////////--%>
                                <div class="dashboard-container">
                                    <!-- 오늘 시험 과목 -->
                                    <section class="dashboard-section" id="today-exams">
                                        <h2>이번 달 시험 과목</h2>
                                        <div class="card-container" id="examCards">
                                            <!-- 카드 영역에 JS에서 데이터 삽입 -->
                                        </div>
                                    </section>

                                    <!-- 오늘 강의실 -->
                                    <section class="dashboard-section" id="today-classes">
                                        <h2>수업 중인 강의실</h2>
                                        <div class="card-container" id="classCards">
                                            <!-- 카드 영역에 JS에서 데이터 삽입 -->
                                        </div>
                                    </section>

                                    <!-- 사용자 통계 -->
                                    <section class="dashboard-section" id="user-stats">
                                        <h2>이번 달 사용자 인원 통계</h2>
                                        <canvas id="userStatsChart"></canvas>
                                    </section>

                                    <!-- 커뮤니티 최근 글 -->
                                    <section class="dashboard-section" id="community-posts">
                                        <h2>커뮤니티 최근 글</h2>

                                        <div class="community-row">

                                            <div class="community-box">
                                                <h3>공지 사항</h3>
                                                <ul id="recentNotice"></ul>
                                            </div>

                                            <div class="community-box">
                                                <h3>Q&A</h3>
                                                <ul id="recentQnA"></ul>
                                            </div>

                                            <div class="community-box">
                                                <h3>설문 조사</h3>
                                                <ul id="recentSurvey"></ul>
                                            </div>

                                        </div>
                                    </section>

                                </div>




                <%--   /////////////////////////////////////////////////////////////////--%>
                            </div>
                        </div>

                    </div>


                </li>
            </ul>
        </div>

    </div>


    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>
    <script type="text/javascript" src="${CTX_PATH}/js/admin/aDashboard.js"></script>



</form>
</body>
</html>
