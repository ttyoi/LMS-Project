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
<!-- 컨텍스트 루트 변수 선언 -->
<c:set var="CTX_PATH" value="${pageContext.request.contextPath}" />
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>시험 문제 목록 (관리자)</title>
    <link rel="stylesheet" href="/css/exam/style.css" />

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
                                <span>시험 관리</span>

                            </p>
                            <div class="container">

                                <table class="table-fixed">
                                    <thead>
                                    <tr>
                                        <th>강의번호</th>
                                        <th>강의명</th>
                                        <th>차시</th>
                                        <th>강사명</th>
                                        <th>상태</th>
                                        <th></th>
                                    </tr>
                                    </thead>
                                    <tbody id="testListBody">

                                    </tbody>

                                </table>

                                <!-- 검색 영역 -->
                                <div class="search-bar">
                                    <select id="filterType">
                                        <option value="all">전체</option>
                                        <option value="teacher">강사명</option>
                                        <option value="title">강의명</option>
                                    </select>

                                    <input type="text" id="searchInput" placeholder="검색어를 입력하세요" />

                                    <button id="searchBtn">검색</button>
                                </div>
                                <!-- 페이징 영역 -->
                                <div class="pagination" id="pagination">


                                </div>
                            </div>
                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>

    <!-- 서버 모델 데이터를 JS 배열로 전달 -->
    <script type="text/javascript">
        window.sampleTests = [
            <c:forEach var="test" items="${testScheduleList}" varStatus="status">
            {
                no: ${test.course_courseId},
                title: "${fn:escapeXml(test.course_title)}",
                period: ${test.testSchedule_period},
                teacher: "${fn:escapeXml(test.course_professor)}",
                status: "${test.testSchedule_status == 1 ? '열림' : '닫힘'}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
    </script>

    <script type="text/javascript" src="${CTX_PATH}/js/admin/aTest/testList.js"></script>

</form>
</body>
</html>
