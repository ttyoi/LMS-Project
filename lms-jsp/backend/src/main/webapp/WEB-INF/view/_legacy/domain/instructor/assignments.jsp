<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>과제목록</title>

    <link rel="stylesheet" href="/css/homework/homeworklist.css">
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
</head>

<body>
<form id="myForm" action="javascript:void(0);" method="get">

    <div id="wrap_area">
        <div id="container">
            <ul>

                <!-- LEFT MENU -->
                <li class="lnb">
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
                </li>

                <!-- CONTENT -->
                <li class="contents">

                    <div class="content" style="margin-bottom:20px;">

                        <p class="Location">
                            <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">과제 목록</span>
                            <a href="../dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>

                        <p class="conTitle"><span>과제 목록</span></p>

                        <div class="assignment-wrapper">

                            <!-- 검색 영역 -->
                            <div class="search-area">
                                <div class="search-left">
                                    <select name="searchType">
                                        <option value="courseName">과정명</option>
                                        <option value="title">과제명</option>
                                    </select>
                                </div>

                                <div class="search-right">
                                    <input type="text" name="searchWord" placeholder="검색어 입력">
                                    <button type="button" class="btn-search">찾기</button>
                                </div>
                            </div>

                            <!-- 정렬 -->
                            <div class="sort-area">
                                <select class="sort-select">
                                    <option value="default">정렬기준선택</option>
                                    <option value="startDate">시작일 순</option>
                                    <option value="endDate">마감일 순</option>
                                    <option value="status">진행상태 순</option>
                                </select>
                            </div>

                            <!-- 테이블 -->
                            <table class="assignment-table">
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>과정명</th>
                                    <th>과제명</th>
                                    <th>시작일</th>
                                    <th>마감일</th>
                                    <th>진행상태</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                            <!-- 페이지네이션 -->
                            <div class="pagination"></div>

                            <!-- 신규등록 -->
                            <div class="search-right2">
                                <button type="button" class="btn-search2"
                                        onclick="location.href='/inst/homeworkWriteForm'">
                                    신규등록
                                </button>
                            </div>

                        </div> <!-- wrapper 끝 -->

                    </div>
                </li>
            </ul>
        </div>
    </div>

</form>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

    /* 상태 계산 함수 */
    function getStatus(startDate, endDate) {
        const today = new Date().toISOString().slice(0, 10);
        if (startDate > today) return "진행 예정";
        if (endDate < today) return "마감";
        return "진행 중";
    }

    let homeworkData = [];
    let filteredData = null;
    let itemsPerPage = 5;

    /* 초기 데이터 로딩 */
    $(document).ready(function () {

        $.ajax({
            url: "/inst/homeworklist",
            method: "GET",
            success: function (data) {
                homeworkData = data;
                renderTable(1);
                renderPagination(homeworkData.length, 1);
            }
        });

        /* 검색 */
        $(".btn-search").click(function () {
            const type = $("select[name='searchType']").val();
            const word = $("input[name='searchWord']").val().trim();

            if (word === "") {
                filteredData = null;
            } else {
                filteredData = homeworkData.filter(hw => {
                    if (type === "courseName") return (hw.course_name || "").includes(word);
                    if (type === "title") return (hw.title || "").includes(word);
                });
            }

            renderTable(1);
            renderPagination((filteredData ?? homeworkData).length, 1);
        });

        /* 엔터 검색 */
        $("input[name='searchWord']").keypress(function (e) {
            if (e.key === "Enter") {
                e.preventDefault();
                $(".btn-search").click();
            }
        });

        /* 정렬 */
        $(".sort-select").change(function () {
            const sortType = $(this).val();
            const data = filteredData ?? homeworkData;

            if (sortType === "startDate") data.sort((a, b) => a.start_date.localeCompare(b.start_date));
            if (sortType === "endDate") data.sort((a, b) => a.end_date.localeCompare(b.end_date));

            if (sortType === "status") {
                const order = { "진행 예정": 1, "진행 중": 2, "마감": 3 };
                data.sort((a, b) => order[getStatus(a.start_date, a.end_date)] - order[getStatus(b.start_date, b.end_date)]);
            }

            renderTable(1);
            renderPagination(data.length, 1);
        });
    });

    /* 테이블 렌더링 */
    function renderTable(page) {
        const data = filteredData ?? homeworkData;
        const start = (page - 1) * itemsPerPage;
        const list = data.slice(start, start + itemsPerPage);

        let html = "";

        $.each(list, function (i, hw) {

            html += "<tr>";
            html += `<td><a href='/inst/homeworkDetail?homework_code=${hw.homework_code}'>${start + i + 1}</a></td>`;
            html += `<td><a href='/inst/homeworkDetail?homework_code=${hw.homework_code}'>${hw.course_name || "-"}</a></td>`;
            html += `<td><a href='/inst/homeworkDetail?homework_code=${hw.homework_code}'>${hw.title || "-"}</a></td>`;
            html += `<td>${hw.start_date}</td>`;
            html += `<td>${hw.end_date}</td>`;
            html += `<td>${getStatus(hw.start_date, hw.end_date)}</td>`;
            html += "</tr>";

        });

        $(".assignment-table tbody").html(html);
    }

    /* 페이지네이션 */
    function renderPagination(total, currentPage) {
        const totalPages = Math.ceil(total / itemsPerPage);
        let html = "";

        html += `<a onclick="setPage(${Math.max(1, currentPage - 1)})">&lt;</a>`;

        for (let i = 1; i <= totalPages; i++) {
            if (i === currentPage)
                html += `<span class='current'>${i}</span>`;
            else
                html += `<a onclick="setPage(${i})">${i}</a>`;
        }

        html += `<a onclick="setPage(${Math.min(totalPages, currentPage + 1)})">&gt;</a>`;

        $(".pagination").html(html);
    }

    function setPage(page) {
        const data = filteredData ?? homeworkData;
        renderTable(page);
        renderPagination(data.length, page);
    }

</script>

</body>
</html>
