<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 4:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>

<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>시험 목록 조회 (수강생)</title>
    <link rel="stylesheet" href="/css/exam/style.css" />
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        /* 추가 스타일 (student 전용) */

        #wrap_area #container .contents .content .container .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }
        #wrap_area #container .contents .content .container .top-bar select {
            padding: 6px;
            border-radius: 4px;
            border: 1px solid #aaa;
        }
        #wrap_area #container .contents .content .container #testTable {
            width: 100%; !important;
            border-collapse: collapse; !important;
            margin-top: 10px; !important;
        }
        #wrap_area #container .contents .content .container #testTable th,
        #wrap_area #container .contents .content .container #testTable td {
            border: 1px solid #ddd; !important;
            padding: 8px; !important;
            text-align: center; !important;
        }
        #wrap_area #container .contents .content .container .action-btn {
            padding: 6px 8px;
            margin: 0 4px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }
        #wrap_area #container .contents .content .container .btn-primary {
            background: #3a7df5;
            color: white;
        }
        #wrap_area #container .contents .content .container .btn-ghost {
            background: #f0f0f0;
            color: #333;
        }
        #wrap_area #container .contents .content .container .small {
            padding: 4px 6px;
            font-size: 13px;
        }

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
                            <%-- 상대경로/절대경로는 url 길이/배포환경 변동에 취약, 일반적으로 contextPath 를 얻어와 사용함 --%>
                            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">학습 관리</span>
                            <span class="btn_nav bold">시험 목록</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 목록</span>

                            </p>

                        </div>
                        <div class="container">

                            <div class="top-bar">
                                <div>
                                    <label for="courseFilter"> </label>
                                    <select id="courseFilter">
                                        <option value="all">과정명</option>
                                    </select>
                                </div>

                                <div>
                                    <!-- 페이징 정보 요약 -->
                                    <span id="pageInfo"></span>
                                </div>
                            </div>

                            <table id="testTable">
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>시험명</th>
                                    <th>차시</th>
                                    <th>평가일</th>
                                    <th>점수</th>
                                    <th>평가</th>
                                </tr>
                                </thead>
                                <tbody id="testListBody"></tbody>
                            </table>

                            <div class="pagination" id="pagination" style="margin-top: 12px"></div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>

    </div>




</form>
<script>
    // ===============================
    // 전역 상태
    // ===============================
    let currentPage = 1;
    const pageSize = 5;
    let totalCount = 0;
    let testList = [];

    // ===============================
    // 유틸: 성적 텍스트 변환
    // ===============================
    function getGradeText(score) {
        if (score === null || score === undefined) return "미응시";
        const s = Number(score);
        if (isNaN(s)) return "미응시";
        if (s < 60) return "과락";
        return "합격";
    }

    // ===============================
    // 시험 리스트 불러오기
    // ===============================
    function loadTestList() {
        const course = document.querySelector("#wrap_area #container .contents .content .container #courseFilter").value;
        const sendCourse = course === "all" ? "" : course;
            $.ajax({
            url: "/stu/exams/list",
            type: "GET",
            data: {
                page: currentPage,
                pageSize: pageSize,
                course: sendCourse
            },
            success: function(res) {
                testList = res.list;
                totalCount = res.totalCount;
                renderList();
                renderPagination();
            },
            error: function() {
                alert("시험 목록 조회 중 오류가 발생했습니다.");
            }
        });
    }

    // ===============================
    // 시험 목록 렌더링
    // ===============================
    function renderList() {
        const tbody = document.querySelector("#wrap_area #container .contents .content .container #testListBody");
        tbody.innerHTML = "";

        if (testList.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6">조회된 시험이 없습니다.</td></tr>`;
            return;
        }

        testList.forEach((t, idx) => {
            const no = (currentPage - 1) * pageSize + idx + 1;
            const dateText = t.date ? t.date : "--";
            const scoreText = t.score === null ? "--" : t.score;
            const grade = getGradeText(t.score);

            let evalHtml = "";

            if (t.score === null && t.status === 1) {
                evalHtml = `
                <button class="action-btn btn-primary small" onclick="onStartExam(${t.courseId},${t.period})">응시하기</button>
                <button class="action-btn btn-ghost small" disabled>미응시</button>
            `;
            } else if(t.score === null && t.status === 0){
                evalHtml = `
                <button class="action-btn btn-primary small" disabled>응시하기</button>
                <button class="action-btn btn-ghost small" disabled>미응시</button>
            `;
            }

            else {
                evalHtml = `
                <button class="action-btn btn-ghost small" disabled>평가완료</button>
                <button class="action-btn btn-primary small" onclick="viewResult(${t.courseId},${t.period})">결과확인</button>
                <span style="margin-left:6px;">${grade}</span>
            `;
            }

            const tr = document.createElement("tr");
            tr.innerHTML = `
            <td>${no}</td>
            <td style="text-align:left;padding-left:10px;">${t.title}</td>
            <td>${t.period}</td>
            <td>${dateText}</td>
            <td>${scoreText}</td>
            <td>${evalHtml}</td>
        `;
            tbody.appendChild(tr);
        });

        document.querySelector("#wrap_area #container .contents .content .container #pageInfo").textContent =
            `총 ${totalCount}건 / ${currentPage}페이지`;
    }
    // ===============================
    // 과정 목록 동적로딩
    // ===============================
    $(document).ready(function () {
        loadCourseOptions();
    });

    function loadCourseOptions() {
        $.ajax({
            url: "/stu/exams/courses",
            type: "GET",
            success: function (data) {
                const courseFilter = $("#wrap_area #container .contents .content .container #courseFilter");
                courseFilter.empty();

                courseFilter.append('<option value="all">과정명</option>');

                data.forEach(course => {
                    courseFilter.append(`
                        <option value="${course.course_id}">
                            ${course.title}
                        </option>
                    `);
                });
            },
            error: function () {
                alert("과정 목록을 불러오지 못했습니다.");
            }
        });
    }


    // ===============================
    // 시험 응시 시작
    // ===============================
    function onStartExam(courseId, period) {
        console.log(courseId,period);
        $.ajax({
            url: "/stu/exams/check",
            type: "GET",
            data: { courseId: courseId, period: period },
            success: function (res) {

                if (res.available) {
                    // 응시 가능 → 시험 상세 페이지로 이동
                    window.location.href = `/stu/exams/detail/${courseId}/${period}`;
                } else {
                    alert(res.message || "현재는 시험 응시가 가능한 시간이 아닙니다!");
                }
            },
            error: function () {
                alert("시험 응시 가능 여부 확인 중 오류가 발생했습니다.");
            }
        });
    }


    // 결과 확인
    function viewResult(courseId,period) {
        console.log(courseId,period);
        window.location.href =`/stu/exams/result/${courseId}/${period}`;
    }

    // ===============================
    // 페이징 렌더링
    // ===============================
    function renderPagination() {
        const totalPage = Math.max(1, Math.ceil(totalCount / pageSize));
        const container = document.getElementById("pagination");
        container.innerHTML = "";

        function createPageBtn(label, go, disabled) {
            const b = document.createElement("button");
            b.className = "page-btn";
            b.textContent = label;
            if (!disabled) {
                b.addEventListener("click", () => movePage(go));
            } else {
                b.disabled = true;
                b.style.opacity = 0.5;
            }
            return b;
        }

        container.appendChild(createPageBtn("<<", 1, currentPage === 1));
        container.appendChild(createPageBtn("<", currentPage - 1, currentPage === 1));

        // 중심 5개
        let start = Math.max(1, currentPage - 2);
        let end = Math.min(totalPage, start + 4);
        if (end - start < 4) start = Math.max(1, end - 4);

        for (let i = start; i <= end; i++) {
            const btn = createPageBtn(i, i, false);
            if (i === currentPage) btn.classList.add("active");
            container.appendChild(btn);
        }

        container.appendChild(createPageBtn(">", currentPage + 1, currentPage === totalPage));
        container.appendChild(createPageBtn(">>", totalPage, currentPage === totalPage));
    }

    function movePage(p) {
        const totalPage = Math.max(1, Math.ceil(totalCount / pageSize));
        if (p < 1) p = 1;
        if (p > totalPage) p = totalPage;
        currentPage = p;
        loadTestList();
    }

    // 필터 변경 시 서버 재조회
    document.querySelector("#wrap_area #container .contents .content .container #courseFilter").addEventListener("change", function () {
        currentPage = 1;
        loadTestList();
    });

    // 초기 로드
    window.addEventListener("DOMContentLoaded", () => {
        loadTestList();
    });
</script>



</body>
</html>
