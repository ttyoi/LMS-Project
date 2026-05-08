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
<%@ page isELIgnored="true" %>
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
                            <span class="btn_nav bold">시험 관리</span>
                            <span class="btn_nav bold">시험 문제</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 문제 목록</span>

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
                                    <tbody id="testListBody"></tbody>
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
                                <div class="pagination" id="pagination"></div>
                            </div>
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
    let fullData = [];


    // ===============================
    // 시험 리스트 불러오기
    // ===============================
    function loadTestList() {
        const type = document.getElementById("filterType").value;
        const keyword = document.getElementById("searchInput").value.trim();

        $.ajax({
            url: "/admin/test-exam/list",
            type: "GET",
            data: {
                page: currentPage,
                pageSize: pageSize,
                filteredType: type === "all" ? null : type,
                keyword:keyword || null
            },
            success: function(res) {
                fullData = res.list;
                totalCount = res.totalCount;
                renderTable();
                renderPagination();
            },
            error: function() {
                alert("시험 목록 조회 중 오류가 발생했습니다.");
            }
        });
    }




    // 테이블 렌더링
    function renderTable() {
        const tbody = document.querySelector("#wrap_area #container .contents .content .container #testListBody");
        tbody.innerHTML = "";


        if (fullData.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;padding:16px;">조회된 데이터가 없습니다.</td></tr>`;
            return;
        }

        fullData.forEach((item,idx) => {

            const no = (currentPage - 1) * pageSize + idx + 1; //페이지 번호 관련
            let examStatus = `${item.status}` ==0 ? "닫힘":"열림";
            const tr = document.createElement("tr");
            tr.innerHTML = `
        <td>${item.courseId}</td>
        <td>${item.title}</td>
        <td>${item.period}</td>
        <td>${item.professorName}</td>
        <td>`
            + examStatus +
                    `</td>
        <td class="action-col"><button class="btn-red" type="button" onclick="location.href='/admin/test-exam/detail/${item.courseId}/${item.period}'">열람</button></td>
      `;
            tbody.appendChild(tr);
        });
    }

    // 페이징 렌더링 (최대 5개 숫자 페이징)
    function renderPagination() {
        const totalPage = Math.max(
            1,
            Math.ceil(totalCount / pageSize)
        );
        const container = document.getElementById("pagination");
        container.innerHTML = "";

        // start / end 계산 (현재 페이지 중심으로 최대 5개)
        let start = Math.max(1, currentPage - 2);
        let end = Math.min(totalPage, start + 4);
        if (end - start < 4) {
            start = Math.max(1, end - 4);
        }

        // << 첫 페이지
        container.appendChild(
            createNavButton("<<", () => movePage(1), currentPage === 1)
        );

        // < 이전 페이지
        container.appendChild(
            createNavButton(
                "<",
                () => movePage(Math.max(1, currentPage - 1)),
                currentPage === 1
            )
        );

        // 페이지 숫자들
        for (let i = start; i <= end; i++) {
            const btn = document.createElement("button");
            btn.className = "page-btn" + (i === currentPage ? " active" : "");
            btn.textContent = i;
            btn.addEventListener("click", () => movePage(i));
            container.appendChild(btn);
        }

        // > 다음 페이지
        container.appendChild(
            createNavButton(
                ">",
                () => movePage(Math.min(totalPage, currentPage + 1)),
                currentPage === totalPage
            )
        );

        // >> 마지막 페이지
        container.appendChild(
            createNavButton(
                ">>",
                () => movePage(totalPage),
                currentPage === totalPage
            )
        );
    }

    function createNavButton(label, onClick, disabled) {
        const btn = document.createElement("button");
        btn.className = "page-btn";
        btn.textContent = label;
        if (disabled) {
            btn.disabled = true;
            btn.style.opacity = "0.5";
            btn.style.cursor = "not-allowed";
        } else {
            btn.addEventListener("click", onClick);
        }
        return btn;
    }

    // 페이지 이동
    function movePage(page) {
        const totalPage = Math.max(
            1,
            Math.ceil(totalCount / pageSize)
        );
        if (page < 1) page = 1;
        if (page > totalPage) page = totalPage;
        currentPage = page;
        loadTestList();
    }

    // 검색 실행 (필터링 + 페이징 리셋)
    document.getElementById("searchBtn").addEventListener("click", () => {

        // 검색하면 1페이지로 이동
        currentPage = 1;
        loadTestList(); // 서버에서 필터링 + 페이징 처리
    });


    // 초기 로드
    window.addEventListener("DOMContentLoaded", () => {
        loadTestList();
    });

    // 외부에서 호출 가능한 함수(디버깅용)
    window.movePage = movePage;
</script>
</body>
</html>
