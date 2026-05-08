<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 5:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>시험 상세보기 (관리자)</title>
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
                            <span class="btn_nav bold">시험 관리</span>
                            <span class="btn_nav bold">시험 문제</span>
                            <span class="btn_nav bold">시험 상세</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 문제 상세 보기</span>

                            </p>
                            <div class="container">

                                <!-- 제목 라인 -->
                                <div class="detail-header">
                                    <div>강의 명 : JAVA</div>
                                    <div>시험 명 : Java 기본</div>
                                    <div>차시 : 1</div>
                                </div>

                                <div class="table-wrapper">
                                    <table class="table-fixed">
                                        <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>지문</th>
                                            <th>보기1</th>
                                            <th>보기2</th>
                                            <th>보기3</th>
                                            <th>보기4</th>
                                            <th>정답</th>
                                            <th>배점</th>
                                            <th>해설</th>
                                        </tr>
                                        </thead>
                                        <tbody id="detailBody"></tbody>
                                    </table>
                                </div>

                                <div class="nav-btn-box">
                                    <%--    admin    --%>
                                    <button class="back-btn" onclick="location.href='/admin/test-exam'">
                                        목록으로
                                    </button>
                                    <button id="editBtn" class="edit-btn">수정하기</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>

</form>


<script>

    // 현재 URL 예: /admin/test-exams/detail/1/1
    const path = window.location.pathname.split("/");

    // path = ["", "admin", "test-exams", "detail", "1", "1"]
    const courseId = path[4];
    const period = path[5];


    // 시험문제 불러오기
    document.addEventListener("DOMContentLoaded", () => {

        const editBtn = document.getElementById("editBtn");

            editBtn.addEventListener("click", () => {
                location.href = `/admin/test-exam/edit/${courseId}/${period}`;
            });

        fetch(`/admin/test-exam/detail/${courseId}/${period}/data`)
            .then(res => res.json())
            .then(details => {
                const tbody = document.getElementById("detailBody");
                details.forEach(q => {
                    const tr = document.createElement("tr");
                    tr.innerHTML = `
                    <td>${q.questionNo}</td>
                    <td>${q.content}</td>
                    <td>${q.option1}</td>
                    <td>${q.option2}</td>
                    <td>${q.option3}</td>
                    <td>${q.option4}</td>
                    <td>${q.answer}</td>
                    <td>${q.score}</td>
                    <td>${q.comment || ''}</td>
                `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => console.error(err));
    });
</script>

</body>
</html>
