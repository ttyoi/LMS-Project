<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>제출 결과</title>

    <link rel="stylesheet" href="/css/homework/homeworklist.css" />
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        .btn-view {
            padding: 5px 12px;
            border: 1px solid #ccc;
            background: #f7f7f7;
            border-radius: 15px;
            font-size: 12px;
            cursor: pointer;
        }
        .btn-view:hover {
            background: #e6e6e6;
        }

        .pagination a, .pagination span {
            padding: 4px 8px;
            margin: 2px;
            cursor: pointer;
        }

        .pagination .current {
            font-weight: bold;
            color: #0074D9;
        }

        /* 🔹 검색 / 정렬 UI */
        .search-area {
            display:flex;
            justify-content:space-between;
            margin-bottom:10px;
        }
        .search-left select { padding:5px; }
        .search-right input { padding:5px; width:200px; }
        .search-right button { padding:5px 10px; }
        .sort-area { text-align:right; margin-bottom:10px; }

        /* 정렬 셀렉트 통일 */
        .sort-area select {
            min-width: 140px;
            height: 34px;
            padding: 5px 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: #fff;
            cursor: pointer;
        }

    </style>
</head>

<body>

<div id="wrap_area">
    <div id="container">
        <ul>

            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>

            <li class="contents">

                <p class="Location">
                    <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                    <span class="btn_nav bold">제출 결과</span>
                    <a href="../dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                </p>

                <p class="conTitle"><span>과제 제출 결과</span></p>

                <!-- 🔍 검색 (추가) -->
                <div class="search-area">
                    <div class="search-left">
                        <select id="searchType">
                            <option value="course">과정명</option>
                            <option value="homework">과제명</option>
                            <option value="teacher">강사명</option>
                        </select>
                    </div>
                    <div class="search-right">
                        <input type="text" id="searchWord" placeholder="검색어 입력">
                        <button type="button" id="btnSearch">찾기</button>
                    </div>
                </div>

                <!-- 🔃 정렬 (추가) -->
                <div class="sort-area">
                    <select id="sortSelect">
                        <option value="">정렬기준선택</option>
                        <option value="start">시작일</option>
                        <option value="end">마감일</option>
                        <option value="status">진행상태</option>
                    </select>
                </div>

                <table class="assignment-table">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>과정명</th>
                        <th>과제명</th>
                        <th>진행상태</th>
                        <th>담당강사</th>
                        <th>점수</th>
                        <th>피드백</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <div class="pagination"></div>
            </li>
        </ul>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

    /* ===================== 진행상태 계산 (기존) ===================== */
    function getProgress(startDate, endDate) {
        const today = new Date().setHours(0,0,0,0);
        const s = new Date(startDate).setHours(0,0,0,0);
        const e = new Date(endDate).setHours(0,0,0,0);

        if (s > today) return "진행 예정";
        if (e < today) return "마감";
        return "진행 중";
    }

    function escapeHtml(t) {
        if (!t) return "";
        return t.replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    let resultList = [];
    let filteredList = null;
    let itemsPerPage = 5;

    $(document).ready(() => {
        $.ajax({
            url: "/stu/submittedList",
            method: "GET",
            success: data => {
                resultList = data ?? [];
                renderTable(1);
                renderPagination(resultList.length, 1);
            }
        });
    });

    /* ===================== 테이블 렌더링 (기존 그대로) ===================== */
    function renderTable(page){
        const data = filteredList ?? resultList;
        const start = (page - 1) * itemsPerPage;
        const list = data.slice(start, start + itemsPerPage);

        if (list.length === 0) {
            $(".assignment-table tbody").html(
                `<tr><td colspan="7">제출된 과제가 없습니다.</td></tr>`
            );
            return;
        }

        let html = "";

        list.forEach((row, i) => {
            const scoreText = row.score != null ? row.score : "-";
            const feedbackText = row.feedback != null ? escapeHtml(row.feedback) : "-";

            html += `
                <tr>
                    <td>\${start + i + 1}</td>
                    <td>\${row.course_name || '-'}</td>
                    <td>\${row.homework_title || '-'}</td>
                    <td>\${getProgress(row.start_date, row.end_date)}</td>
                    <td>\${row.teacher_name || '-'}</td>
                    <td><button class="btn-view" onclick="alert('점수: \${scoreText}')">보기</button></td>
                    <td><button class="btn-view" onclick="alert('\${feedbackText}')">보기</button></td>
                </tr>
            `;
        });

        $(".assignment-table tbody").html(html);
    }

    /* ===================== 페이지네이션 (기존 그대로) ===================== */
    function renderPagination(total, currentPage){
        const totalPages = Math.ceil(total / itemsPerPage);
        let html = "";

        html += `<a onclick="setPage(\${Math.max(1, currentPage-1)})">&lt;</a>`;

        for(let i=1; i<=totalPages; i++){
            html += i === currentPage
                ? `<span class="current">\${i}</span>`
                : `<a onclick="setPage(\${i})">\${i}</a>`;
        }

        html += `<a onclick="setPage(\${Math.min(totalPages, currentPage+1)})">&gt;</a>`;

        $(".pagination").html(html);
    }

    function setPage(page){
        renderTable(page);
        renderPagination((filteredList ?? resultList).length, page);
    }

    /* ===================== 🔍 검색 (추가) ===================== */
    $("#btnSearch").click(function(){
        const type = $("#searchType").val();
        const word = $("#searchWord").val().trim();

        if(!word){
            filteredList = null;
            renderTable(1);
            renderPagination(resultList.length, 1);
            return;
        }

        filteredList = resultList.filter(row => {
            if(type === "course")   return row.course_name?.includes(word);
            if(type === "homework") return row.homework_title?.includes(word);
            if(type === "teacher")  return row.teacher_name?.includes(word);
            return true;
        });

        renderTable(1);
        renderPagination(filteredList.length, 1);
    });

    /* ===================== 🔃 정렬 (추가) ===================== */
    $("#sortSelect").change(function(){
        const type = $(this).val();
        const data = filteredList ?? resultList;

        if(type === "start") {
            data.sort((a,b)=>a.start_date.localeCompare(b.start_date));
        }
        if(type === "end") {
            data.sort((a,b)=>a.end_date.localeCompare(b.end_date));
        }
        if(type === "status"){
            const order = {"진행 예정":1,"진행 중":2,"마감":3};
            data.sort((a,b)=>order[getProgress(a.start_date,a.end_date)] - order[getProgress(b.start_date,b.end_date)]);
        }

        renderTable(1);
        renderPagination(data.length, 1);
    });

</script>

</body>
</html>
