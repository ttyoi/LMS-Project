<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>시험 일정</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <link rel="stylesheet" href="${CTX_PATH}/css/exam/newTestScheduleList.css"/>
</head>
<body>
<div id="wrap_area">
    <div id="container">
        <ul>
            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>
            <li class="contents">
                <div class="content">
                    <jsp:include page="/WEB-INF/view/common/header.jsp">
                        <jsp:param name="menu1" value="시험 관리"/>
                        <jsp:param name="menu2" value="시험 일정"/>
                        <jsp:param name="refreshUrl" value="${CTX_PATH}/admin/exam/schedule"/>
                    </jsp:include>

                    <p class="conTitle">
                        <span>시험 일정</span>
                    </p>

                    <div class="container">
                        <!-- 검색 영역 -->
                        <div class="search-box">
                            <div class="search-row">
                                <select class="form-select" id="searchKey" style="width: 120px;">
                                    <option value="all">-- 전체 --</option>
                                    <option value="teacher">강사명</option>
                                    <option value="title">시험명</option>
                                </select>

                                <input type="text" class="form-input" id="searchKeyword" placeholder="검색어를 입력하세요"
                                       style="flex: 1; padding-left: 10px;">

                                <div class="search-buttons">
                                    <button class="btn btn-primary" onclick="searchData()">🔍 검색</button>
                                </div>
                            </div>
                        </div>

                        <!-- Master-Detail 레이아웃 -->
                        <div class="master-detail-layout">
                            <!-- 좌측: 리스트 영역 -->
                            <div class="list-section">
                                <div class="table-container">
                                    <table class="table-fixed">
                                        <thead>
                                        <tr>
                                            <th>강의번호</th>
                                            <th>시험명</th>
                                            <th>차시</th>
                                            <th>강사명</th>
                                            <th>상태</th>
                                        </tr>
                                        </thead>
                                        <tbody id="testListBody"></tbody>
                                    </table>
                                </div>

                                <div class="bottom-container">
                                    <div class="paging_area" id="pagination"></div>
                                </div>
                            </div>

                            <!-- 우측: 상세 영역 -->
                            <div class="detail-section" id="detailSection">
                                <div class="detail-header">
                                    <p class="conTitle" style="margin-bottom: 20px;">
                                        <span style="border-left: 4px solid #007bff;">시험 상세</span>
                                    </p>
                                    <button type="button" class="btn-close" onclick="fnCloseDetail()">✕</button>
                                </div>

                                <table class="table-fixed" style="margin-bottom:20px; border: 1px solid #e0e0e0;">
                                    <tbody>
                                    <tr style="background-color: #fcfcfc;">
                                        <th style="width:15%; background:#f4f4f4;">강의명</th>
                                        <td id="courseTitle" style="width:35%; text-align:left; padding-left:15px;">-</td>
                                        <th style="width:15%; background:#f4f4f4;">강의실</th>
                                        <td id="courseClass" style="width:35%;">-</td>
                                    </tr>
                                    <tr style="background-color: #fcfcfc;">
                                        <th style="background:#f4f4f4;">강사</th>
                                        <td id="courseProfessor" colspan="3" style="text-align:left; padding-left:15px;">-</td>
                                    </tr>
                                    </tbody>
                                </table>

                                <div class="table-container">
                                    <table class="table-fixed">
                                        <thead>
                                        <tr>
                                            <th style="width: 10%;">No</th>
                                            <th style="width: 40%;">시험명</th>
                                            <th style="width: 25%;">시험 날짜</th>
                                            <th style="width: 12%;">상태</th>
                                            <th style="width: 13%;">동작</th>
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

    <script>
        const listTbody = document.getElementById("testListBody");
        let scheduleData = [];
        let filteredData = [];
        let currentPage = 1;
        const pageSize = 10;

        // 초기 데이터 로딩
        document.addEventListener("DOMContentLoaded", async () => {
            try {
                const res = await fetch("/admin/exam/schedule/list");
                scheduleData = await res.json();
                filteredData = [...scheduleData];
                renderTable();
            } catch (error) {
                console.error("데이터 로딩 실패:", error);
            }

            // 검색 엔터 이벤트 바인딩
            const searchInput = document.getElementById("searchKeyword");
            if (searchInput) {
                searchInput.addEventListener("keyup", (e) => {
                    if (e.key === "Enter") searchData();
                });
            }
        });

        // 메인 테이블 출력
        function renderTable() {
            if (!listTbody) return;
            listTbody.innerHTML = '';

            const startIdx = (currentPage - 1) * pageSize;
            const pageItems = filteredData.slice(startIdx, startIdx + pageSize);

            if (pageItems.length === 0) {
                listTbody.innerHTML = `<tr><td colspan="5" style="text-align:center; padding:16px;">조회된 데이터가 없습니다.</td></tr>`;
                document.getElementById("pagination").innerHTML = "";
                return;
            }

            pageItems.forEach((item) => {
                const statusText = (item.testSchedule_status == 1 || item.testSchedule_status == '1') ?
                    '<span style="color:#28a745; font-weight:bold;">열림</span>' :
                    '<span style="color:#dc3545; font-weight:bold;">닫힘</span>';

                const tr = document.createElement("tr");
                tr.style.cursor = "pointer";

                tr.innerHTML = `
                    <td>\${item.course_courseId}</td>
                    <td>\${item.testSchedule_title}</td>
                    <td>\${item.testSchedule_period}</td>
                    <td>\${item.tbUserinfo_name}</td>
                    <td>\${statusText}</td>
                `;
                tr.addEventListener("click", () => showDetail(item));
                listTbody.appendChild(tr);
            });

            fnRenderPagination(filteredData.length, currentPage, pageSize);
        }

        // 데이터 검색
        function searchData() {
            const searchKey = document.getElementById("searchKey").value;
            const keyword = document.getElementById("searchKeyword").value.trim().toLowerCase();

            filteredData = scheduleData.filter(item => {
                const teacherName = (item.tbUserinfo_name || "").toLowerCase();
                const testTitle = (item.testSchedule_title || "").toLowerCase();
                return searchKey === "teacher" ? teacherName.includes(keyword) :
                    searchKey === "title" ? testTitle.includes(keyword) :
                        (teacherName.includes(keyword) || testTitle.includes(keyword));
            });

            currentPage = 1;
            renderTable();
        }

        // 페이징 렌더링
        function fnRenderPagination(totalCount, currentPage, pageSize) {
            const paginationDiv = document.getElementById("pagination");
            if (!paginationDiv) return;
            if (totalCount === 0) {
                paginationDiv.innerHTML = "";
                return;
            }

            let totalPage = Math.ceil(totalCount / pageSize);
            let pageBlock = 5;
            let startPage = Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
            let endPage = Math.min(startPage + pageBlock - 1, totalPage);

            let html = "";
            if (startPage > 1) html += `<a onclick="movePage(\${startPage - 1})">&#9664; 이전</a>`;
            for (let i = startPage; i <= endPage; i++) {
                html += (i === currentPage) ? `<span class="active">\${i}</span>` : `<a onclick="movePage(\${i})">\${i}</a>`;
            }
            if (endPage < totalPage) html += `<a onclick="movePage(\${endPage + 1})">다음 &#9654;</a>`;
            paginationDiv.innerHTML = html;
        }

        // 페이지 이동
        function movePage(page) {
            currentPage = page;
            renderTable();
        }

        // 상세 정보 조회 및 영역 표시
        async function showDetail(item) {
            try {
                const res = await fetch(`/admin/exam/schedule/detail/\${item.course_courseId}/\${item.testSchedule_period}`);
                if (!res.ok) throw new Error("상세 정보 요청 실패");
                const data = await res.json();

                // 데이터 채우기
                document.getElementById("courseTitle").textContent = data.course_title ?? "-";
                document.getElementById("courseClass").textContent = data.courseClass_className ?? "-";
                document.getElementById("courseProfessor").textContent = data.tbUserinfo_name ?? "-";

                renderDetailTable(data);

                // Master-Detail 레이아웃 활성화
                const layout = document.querySelector('.master-detail-layout');
                const detailSection = document.getElementById("detailSection");

                if (layout) layout.classList.add('split-view');
                if (detailSection) detailSection.classList.add('active');

            } catch (error) {
                console.error(error);
                alert("상세 정보를 불러올 수 없습니다.");
            }
        }

        // 상세 영역 숨기기
        function fnCloseDetail() {
            const layout = document.querySelector('.master-detail-layout');
            const detailSection = document.getElementById("detailSection");

            if (layout) layout.classList.remove('split-view');
            if (detailSection) detailSection.classList.remove('active');

            // 내부 데이터 비우기
            const tbody = document.getElementById("examInfoBody");
            if (tbody) tbody.innerHTML = "";

            document.getElementById("courseTitle").textContent = "-";
            document.getElementById("courseClass").textContent = "-";
            document.getElementById("courseProfessor").textContent = "-";
        }

        // 상세 테이블 출력
        function renderDetailTable(data) {
            const tbody = document.getElementById("examInfoBody");
            tbody.innerHTML = "";
            const tr = document.createElement("tr");

            tr.innerHTML = `
                <td>1</td>
                <td>\${data.testSchedule_title}</td>
                <td>\${data.testSchedule_date ?? "-"}</td>
                <td class="status-text">\${data.testSchedule_status == 1 ? "열림" : "닫힘"}</td>
                <td>
                    <button class="status-btn \${data.testSchedule_status == 1 ? 'closed' : 'open'}" id="currentStatusBtn">
                        \${data.testSchedule_status == 1 ? "닫기" : "열기"}
                    </button>
                </td>
            `;
            tbody.appendChild(tr);

            const btn = tr.querySelector("#currentStatusBtn");
            btn.onclick = () => toggleStatus(data, btn, tr.querySelector(".status-text"));
        }

        // 시험 상태 변경
        async function toggleStatus(data, btn, statusTd) {
            if (!confirm("시험 상태를 변경하시겠습니까?")) return;

            btn.disabled = true;
            const newStatus = data.testSchedule_status == 1 ? 0 : 1;

            try {
                const res = await fetch(`/admin/exam/updateStatus/\${data.course_courseId}/\${data.testSchedule_period}`, {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({status: newStatus})
                });
                const result = await res.json();

                if (result.success) {
                    data.testSchedule_status = newStatus;
                    statusTd.textContent = newStatus === 1 ? "열림" : "닫힘";
                    btn.textContent = newStatus === 1 ? "닫기" : "열기";
                    btn.className = `status-btn \${newStatus === 1 ? 'closed' : 'open'}`;

                    // 메인 리스트 데이터 동기화
                    const mainItem = scheduleData.find(i =>
                        i.course_courseId === data.course_courseId &&
                        i.testSchedule_period === data.testSchedule_period
                    );
                    if (mainItem) mainItem.testSchedule_status = newStatus;

                    renderTable();
                } else {
                    alert("상태 변경에 실패했습니다.");
                }
            } catch (err) {
                console.error(err);
                alert("서버 오류가 발생했습니다.");
            } finally {
                btn.disabled = false;
            }
        }
    </script>
</div>
</body>
</html>
