<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>과제목록</title>

    <link rel="stylesheet" href="/css/homework/homeworklist.css"/>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
</head>

<body>

<form id="myForm" action="javascript:void(0);" method="get">

    <div id="wrap_area">
        <div id="container">
            <ul>

                <li class="lnb">
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
                </li>

                <li class="contents">

                    <div class="content" style="margin-bottom:20px;">

                        <p class="Location">
                            <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">과제 목록</span>
                            <a href="../dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>

                        <p class="conTitle"><span>과제 목록</span></p>

                        <div class="assignment-wrapper">

                            <!-- 검색 -->
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
                            <div class="sort-area" style="text-align:right; margin-bottom:10px;">
                                <select id="sortSelect">
                                    <option value="">정렬기준선택</option>
                                    <option value="startDate">시작일순</option>
                                    <option value="endDate">마감일순</option>
                                    <option value="status">진행상태순</option>
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
                                    <th>다운로드</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                            <div class="pagination"></div>

                        </div>
                    </div>

                </li>
            </ul>
        </div>
    </div>

</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

    let homeworkData = [];
    let filteredData = null;
    let itemsPerPage = 5;

    function getStatus(startDate, endDate) {
        const today = new Date().toISOString().slice(0,10);
        if (startDate > today) return "진행 예정";
        if (endDate < today) return "마감";
        return "진행 중";
    }

    $(document).ready(function () {

        $.get("/stu/homeworklist", function (data) {
            homeworkData = data || [];
            renderTable(1);
            renderPagination(homeworkData.length, 1);
        });

        $(".btn-search").click(function () {
            const type = $("select[name='searchType']").val();
            const word = $("input[name='searchWord']").val().trim();

            if (!word) {
                filteredData = null;
            } else {
                filteredData = homeworkData.filter(hw => {
                    if (type === "courseName") return hw.course_name && hw.course_name.includes(word);
                    if (type === "title") return hw.homework_title && hw.homework_title.includes(word);
                });
            }

            renderTable(1);
            renderPagination((filteredData ?? homeworkData).length, 1);
        });

        $("#sortSelect").change(function () {
            const sortType = $(this).val();
            const data = filteredData ?? homeworkData;

            if (sortType === "startDate") {
                data.sort((a, b) => a.start_date.localeCompare(b.start_date));
            }
            if (sortType === "endDate") {
                data.sort((a, b) => a.end_date.localeCompare(b.end_date));
            }
            if (sortType === "status") {
                const order = { "진행 예정": 1, "진행 중": 2, "마감": 3 };
                data.sort((a, b) =>
                    order[getStatus(a.start_date, a.end_date)] -
                    order[getStatus(b.start_date, b.end_date)]
                );
            }

            renderTable(1);
            renderPagination(data.length, 1);
        });

    });

    function renderTable(page) {

        const data = filteredData ?? homeworkData;
        const start = (page - 1) * itemsPerPage;
        const list = data.slice(start, start + itemsPerPage);

        let html = "";

        $.each(list, function (i, hw) {

            const status = getStatus(hw.start_date, hw.end_date);
                const isDisabled = (status !== "진행 중");

            const link = hw.submission_code
                ? "/stu/assignmentSubmit?submission_code=" + hw.submission_code
                : "/stu/assignmentSubmit?homework_code=" + hw.homework_code;

            let trClass = isDisabled ? "row-closed" : "";

            let courseHtml = isDisabled
                ? (hw.course_name ?? "-")
                : "<a href='" + link + "'>" + (hw.course_name ?? "-") + "</a>";

            let titleHtml = isDisabled
                ? hw.homework_title
                : "<a href='" + link + "'>" + hw.homework_title + "</a>";


            let downloadHtml = "-";
            if (hw.file_id && !isDisabled) {
                downloadHtml = '<a href="/file/download?fileId=' + hw.file_id + '">다운로드</a>';
            }


            html +=
                "<tr class='" + trClass + "'>" +
                "<td>" + (start + i + 1) + "</td>" +
                "<td>" + courseHtml + "</td>" +
                "<td>" + titleHtml + "</td>" +
                "<td>" + hw.start_date + "</td>" +
                "<td>" + hw.end_date + "</td>" +
                "<td>" + status + "</td>" +
                "<td>" + downloadHtml + "</td>" +
                "</tr>";
        });

        $(".assignment-table tbody").html(html);
    }



    function renderPagination(total, currentPage) {

        const totalPages = Math.ceil(total / itemsPerPage);
        let html = "";

        html += '<a onclick="setPage(' + Math.max(1, currentPage - 1) + ')">&lt;</a>';

        for (let i = 1; i <= totalPages; i++) {
            if (i === currentPage)
                html += '<span class="current">' + i + '</span>';
            else
                html += '<a onclick="setPage(' + i + ')">' + i + '</a>';
        }

        html += '<a onclick="setPage(' + Math.min(totalPages, currentPage + 1) + ')">&gt;</a>';

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
