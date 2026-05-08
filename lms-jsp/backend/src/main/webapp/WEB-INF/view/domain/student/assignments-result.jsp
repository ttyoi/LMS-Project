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
        /* 🔹 레이아웃 및 여백 설정 (통일) */
        .content { padding: 20px; margin-bottom: 20px; }
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1.3; border: 1px solid #ddd; padding: 15px; background: #fff; border-radius: 8px; min-width: 650px; }
        .right-area {
            flex: 0.7; border: 1px solid #ddd; padding: 25px; background: #fff;
            border-radius: 8px; display: none; position: sticky; top: 10px;
            min-width: 450px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* 🔹 검색 및 정렬 UI (한 줄 배치 및 수직 중앙 정렬) */
        .search-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; gap: 10px; }
        .search-left { display: flex; align-items: center; gap: 5px; }

        /* 입력창 높이 보정 스타일 */
        #searchType, #searchWord, #sortSelect {
            height: 38px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
            padding: 0 10px;
            line-height: 36px;
            vertical-align: middle;
        }

        #searchType { width: 100px; }
        #searchWord { width: 200px; }
        #sortSelect { width: 140px; cursor: pointer; background-color: #f9f9f9; }

        .btn-search {
            height: 38px;
            padding: 0 15px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
        }

        /* 🔹 테이블 스타일 (통일) */
        .assignment-table { width: 100%; border-collapse: collapse; table-layout: fixed; margin-top: 5px; }
        .assignment-table th, .assignment-table td {
            padding: 12px 8px;
            border: 1px solid #bcbcbc;
            text-align: center;
            font-size: 14px;
        }
        .assignment-table th { background: #f4f4f4; color: #333; }

        .hw-row { cursor: pointer; transition: background 0.2s; }
        .hw-row:hover { background: #f8f9fa; }
        .row-active { background-color: #e7f1ff !important; border-left: 4px solid #007bff; font-weight: bold; }

        /* 🔹 버튼 및 피드백 스타일 */
        .btn-view {
            padding: 6px 12px;
            border: 1px solid #ccc;
            background: #f7f7f7;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }
        .score-text { color: #d63031; font-weight: bold; }
        .feedback-box {
            line-height: 1.6;
            white-space: pre-wrap;
            background: #fcfcfc;
            padding: 20px;
            border-radius: 6px;
            border: 1px solid #ddd;
            margin-top: 15px;
            font-size: 14px;
            color: #333;
        }

        /* 페이지네이션 */
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 5px 10px;
            margin: 0 2px;
            border: 1px solid #ddd;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            font-size: 13px;
        }
        .pagination .current { background: #007bff; color: white; border-color: #007bff; font-weight: bold; }
    </style>
</head>

<body>

<div id="wrap_area">
    <div id="container">
        <ul>
            <li class="lnb"><jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/></li>
            <li class="contents">
                <div class="content">
                    <p class="Location">
                        <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                        <span class="btn_nav bold">학습 관리</span>
                        <span class="btn_nav bold">제출 결과</span>
                        <a href="javascript:location.reload();" class="btn_set refresh">새로고침</a>
                    </p>
                    <p class="conTitle"><span>과제 제출 결과</span></p>

                    <div class="split-container">
                        <div class="list-area">
                            <div class="search-area">
                                <div class="search-left">
                                    <select id="searchType">
                                        <option value="course">과정명</option>
                                        <option value="homework">과제명</option>
                                        <option value="teacher">강사명</option>
                                    </select>
                                    <input type="text" id="searchWord" placeholder="검색어 입력">
                                    <button type="button" class="btn-search" id="btnSearch">찾기</button>
                                </div>
                                <div class="search-right">
                                    <select id="sortSelect">
                                        <option value="">정렬 기준 선택</option>
                                        <option value="start">시작일 순</option>
                                        <option value="end">마감일 순</option>
                                        <option value="status">진행 상태 순</option>
                                    </select>
                                </div>
                            </div>

                            <table class="assignment-table">
                                <thead>
                                <tr>
                                    <th style="width:50px;">번호</th>
                                    <th>과정명</th>
                                    <th>과제명</th>
                                    <th style="width:90px;">진행상태</th>
                                    <th style="width:90px;">담당강사</th>
                                    <th style="width:80px;">점수</th>
                                    <th style="width:100px;">피드백</th>
                                </tr>
                                </thead>
                                <tbody id="resultTbody"></tbody>
                            </table>
                            <div class="pagination"></div>
                        </div>

                        <div id="rightArea" class="right-area">
                            <h3 style="margin-bottom:20px; border-bottom:2px solid #333; padding-bottom:10px; font-size:18px;">📝 강사 피드백</h3>
                            <div id="feedbackDetail">
                                <p style="font-weight: bold; font-size: 16px; color: #007bff; margin-bottom: 10px;" id="targetTitle"></p>
                                <div class="feedback-box" id="feedbackContent"></div>
                            </div>
                            <div style="text-align: right; margin-top: 25px; border-top: 1px solid #eee; padding-top: 15px;">
                                <button type="button" class="btn-view" style="background:#6c757d; color:white; border:none;" onclick="$('#rightArea').hide(); $('.hw-row').removeClass('row-active');">닫기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function getProgress(startDate, endDate) {
        const today = new Date().setHours(0,0,0,0);
        const s = new Date(startDate).setHours(0,0,0,0);
        const e = new Date(endDate).setHours(0,0,0,0);
        if (s > today) return "진행 예정";
        if (e < today) return "마감";
        return "진행 중";
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

        $("#btnSearch").click(() => {
            const type = $("#searchType").val();
            const word = $("#searchWord").val().trim();
            filteredList = !word ? null : resultList.filter(row => {
                const target = type === "course" ? row.course_name : type === "homework" ? row.homework_title : row.teacher_name;
                return target?.includes(word);
            });
            // 검색 후 정렬 기준이 있다면 정렬 적용
            applySort();
            renderTable(1);
            renderPagination((filteredList ?? resultList).length, 1);
        });

        // 🔹 정렬 셀렉트 변경 시 즉시 적용 (토글식)
        $("#sortSelect").change(function(){
            applySort();
            renderTable(1);
            renderPagination((filteredList ?? resultList).length, 1);
        });
    });

    // 🔹 정렬 로직 분리
    function applySort() {
        const type = $("#sortSelect").val();
        if(!type) return;

        const data = filteredList ?? resultList;
        if(type === "start") data.sort((a,b)=>a.start_date.localeCompare(b.start_date));
        if(type === "end") data.sort((a,b)=>a.end_date.localeCompare(b.end_date));
        if(type === "status"){
            const order = {"진행 예정":1,"진행 중":2,"마감":3};
            data.sort((a,b)=>order[getProgress(a.start_date,a.end_date)] - order[getProgress(b.start_date,b.end_date)]);
        }
    }

    function renderTable(page){
        const data = filteredList ?? resultList;
        const start = (page - 1) * itemsPerPage;
        const list = data.slice(start, start + itemsPerPage);
        let html = list.length === 0 ? `<tr><td colspan="7">제출된 과제가 없습니다.</td></tr>` : "";

        list.forEach((row, i) => {
            const scoreHtml = row.score != null ? `<span class="score-text">\${row.score}점</span>` : "-";
            const feedbackVal = row.feedback ? row.feedback.replace(/'/g, "\\'") : "";

            html += `
                <tr class="hw-row" id="row_\${row.submission_code}">
                    <td>\${start + i + 1}</td>
                    <td>\${row.course_name || '-'}</td>
                    <td>\${row.homework_title || '-'}</td>
                    <td>\${getProgress(row.start_date, row.end_date)}</td>
                    <td>\${row.teacher_name || '-'}</td>
                    <td>\${scoreHtml}</td>
                    <td><button class="btn-view" onclick="showFeedback('\${row.submission_code}', '\${row.homework_title}', '\${feedbackVal}')">피드백 보기</button></td>
                </tr>
            `;
        });
        $("#resultTbody").html(html);
    }

    function showFeedback(code, title, feedback) {
        $(".hw-row").removeClass("row-active");
        $("#row_" + code).addClass("row-active");

        $("#targetTitle").text(title);
        $("#feedbackContent").text(feedback || "등록된 피드백이 없습니다.");
        $("#rightArea").fadeIn(200);
    }

    function renderPagination(total, currentPage){
        const totalPages = Math.ceil(total / itemsPerPage);
        let html = `<a onclick="setPage(\${Math.max(1, currentPage-1)})">&lt;</a>`;
        for(let i=1; i<=totalPages; i++){
            html += i === currentPage ? `<span class="current">\${i}</span>` : `<a onclick="setPage(\${i})">\${i}</a>`;
        }
        html += `<a onclick="setPage(\${Math.min(totalPages, currentPage+1)})">&gt;</a>`;
        $(".pagination").html(html);
    }

    function setPage(page){
        renderTable(page);
        renderPagination((filteredList ?? resultList).length, page);
    }
</script>

</body>
</html>