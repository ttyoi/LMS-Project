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
    <title>시험 문제 목록 (관리자)</title>
    <link rel="stylesheet" href="/css/exam/style.css" />

    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        .status-btn {padding: 6px 12px; border: none; border-radius: 4px; color: #fff; cursor: pointer;}
        .status-btn.open {background-color: #1E90FF; /* 하늘색 */}
        .status-btn.closed {background-color: #FF4500; /* 빨간색 */}
    </style>

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
                            <span class="btn_nav bold">시험 관리</span>
                            <span class="btn_nav bold">시험 일정</span>
                            <span class="btn_nav bold">시험 일정 상세</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 관리</span>

                            </p>
                            <div class="container">

                                <div id="detailModal">
                                    <div class="modal-content" style="background:#fff; padding:20px; border-radius:8px; max-width:700px; width:90%; position:relative;">
                                        <span id="closeModal" style="position:absolute; top:10px; right:10px; cursor:pointer; font-size:24px; font-weight:bold;">&times;</span>

                                        <!-- 상단: 시험 일정 제목 -->
                                        <h2 style="margin-bottom:20px;">시험 일정 상세</h2>

                                        <!-- ★ 추가된 영역 -->
                                        <div id="modalContent" style="margin-bottom:20px;"></div>

                                        <!-- 강의 정보 -->
                                        <div id="courseInfo" style="margin-bottom:20px; display:flex; justify-content:space-between;">
                                            <div>
                                                <strong>강의명:</strong> <span id="courseTitle">-</span>
                                            </div>
                                            <div>
                                                <div><strong>강의실:</strong> <span id="courseClass">-</span></div>
                                                <div><strong>강사:</strong> <span id="courseProfessor">-</span></div>
                                            </div>
                                        </div>

                                        <!-- 시험 일정 테이블 -->
                                        <table id="modalTable" style="width:100%; border-collapse:collapse; text-align:center;">
                                            <thead>
                                            <tr>
                                                <th style="padding:8px; border-bottom:1px solid #ddd;">No</th>
                                                <th style="padding:8px; border-bottom:1px solid #ddd;">시험명</th>
                                                <th style="padding:8px; border-bottom:1px solid #ddd;">시험 날짜</th>
                                                <th style="padding:8px; border-bottom:1px solid #ddd;">상태</th>
                                                <th style="padding:8px; border-bottom:1px solid #ddd;">동작</th>
                                            </tr>
                                            </thead>
                                            <tbody id="examInfoBody"></tbody>
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

    <script type="text/javascript" src="${CTX_PATH}/js/admin/aTest/testScheduleDetail.js"></script>


</form>
</body>
</html>
