<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>과제 통합 관리 (학생)</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        /* 🔹 레이아웃 및 여백 설정 (통일) */
        .content { padding: 20px; margin-bottom: 20px; }
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1.3; border: 1px solid #ddd; padding: 15px; background: #fff; border-radius: 8px; min-width: 600px; }
        .right-area {
            flex: 0.7; border: 1px solid #ddd; padding: 25px; background: #fff;
            border-radius: 8px; display: none; position: sticky; top: 10px;
            min-width: 450px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* 🔹 검색 바 스타일 - 세로 중앙 정렬 및 높이 보정 */
        .search-bar { margin-bottom: 15px; display: flex; gap: 5px; justify-content: flex-start; align-items: center; }

        /* 글자 짤림 방지 및 수직 중앙 정렬 스타일 통일 */
        .form-control {
            /* 1. 높이를 명시적으로 고정 */
            height: 38px !important;

            /* 2. 테두리와 패딩을 높이에 포함시켜 계산 (매우 중요) */
            box-sizing: border-box;

            /* 3. 위아래 패딩을 0으로 설정하여 수직 중앙 정렬 보정 */
            padding: 0 10px;

            /* 4. 텍스트가 중앙에 오도록 줄 높이 조절 */
            line-height: 36px;

            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            vertical-align: middle;
        }

        /* 셀렉트 박스 특유의 위아래 여백 초기화 */
        select.form-control {
            padding-top: 0;
            padding-bottom: 0;
        }

        select.form-control { padding-top: 0; padding-bottom: 0; display: inline-block; cursor: pointer; }
        .search-select { width: 110px !important; }
        .search-input { width: 220px !important; }

        /* 🔹 테이블 스타일 및 컬럼 설정 */
        .hw-table { width: 100%; border-collapse: collapse; margin-bottom: 15px; table-layout: fixed; }
        .hw-table th, .hw-table td { border: 1px solid #bcbcbc; padding: 12px 8px; font-size: 14px; text-align: center; }
        .hw-table th { background: #f4f4f4; color: #333; }

        /* 컬럼 너비 지정 */
        .col-num { width: 50px; }
        .col-course { width: 150px; }
        .col-title { width: auto; }
        .col-date { width: 110px; }
        .col-status { width: 80px; }

        /* 말줄임표 처리 */
        .ellipsis { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; width: 100%; }

        .hw-row { cursor: pointer; transition: background 0.2s; }
        .hw-row:hover { background: #f8f9fa; }
        /* 액티브 상태 디자인 통일 */
        .hw-row.active { background-color: #e7f1ff !important; border-left: 4px solid #007bff; font-weight: bold; }
        .hw-row.row-closed { background-color: #f2f2f2; color: #888; pointer-events: none; }

        /* 🔹 정렬 헤더 스타일 */
        .sortable { cursor: pointer; position: relative; user-select: none; transition: background 0.2s; }
        .sortable:hover { background-color: #e9ecef !important; }
        .sort-icon { font-size: 11px; margin-left: 3px; color: #bbb; }
        .sortable.active .sort-icon { color: #007bff; font-weight: bold; }

        /* 🔹 상세 페이지 요소 */
        .hw-textarea {
            width: 100%; height: 180px; resize: none; background: #fcfcfc;
            padding: 15px; border: 1px solid #ddd; border-radius: 4px;
            line-height: 1.6; font-size: 14px; color: #333;
        }

        /* 파일 섹션 스타일 보정 */
        .file-section { margin-top: 15px; padding: 15px; border-radius: 6px; border: 1px solid #eee; }
        .teacher-box { background-color: #f8f9fa; border-left: 4px solid #6c757d; }
        .student-box { background-color: #eff6ff; border-left: 4px solid #3b82f6; margin-top: 12px; }

        .file-item { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px; }
        .text-link { color: #007bff; text-decoration: none; cursor: pointer; font-weight: bold; }
        .text-link:hover { text-decoration: underline; }

        /* 🔹 버튼 영역 */
        .btn-group { margin-top: 25px; text-align: right; border-top: 1px solid #eee; padding-top: 20px; }
        .btn { padding: 10px 22px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; transition: all 0.2s; }
        .btn-primary { background: #007bff; color: white; }
        .btn-primary:hover { background: #0056b3; }
        .btn-submit { background: #28a745; color: white; }
        .btn-submit:hover { background: #218838; }
        .btn-close { background: #6c757d; color: white; }
        .btn-close:hover { background: #5a6268; }
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
                        <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                        <span class="btn_nav bold">학습 관리</span>
                        <span class="btn_nav bold">과제 통합 관리</span>
                        <a href="javascript:location.reload();" class="btn_set refresh">새로고침</a>
                    </p>
                    <p class="conTitle"><span>과제 통합 관리 (학생)</span></p>

                    <div class="split-container">
                        <div class="list-area">
                            <div class="search-bar">
                                <select id="searchType" class="form-control search-select">
                                    <option value="course_name">과정명</option>
                                    <option value="homework_title">과제명</option>
                                </select>
                                <input type="text" id="searchText" class="form-control search-input" placeholder="검색어를 입력하세요" onkeyup="if(window.event.keyCode==13){fn_search()}">
                                <button type="button" class="btn btn-primary" onclick="fn_search()">검색</button>
                            </div>

                            <table class="hw-table">
                                <thead>
                                <tr>
                                    <th class="col-num">번호</th>
                                    <th class="col-course">과정명</th>
                                    <th class="col-title">과제명</th>
                                    <th class="col-date sortable" onclick="toggleSort('end_date')">
                                        마감일 <span id="sortIcon" class="sort-icon">▲▼</span>
                                    </th>
                                    <th class="col-status">상태</th>
                                </tr>
                                </thead>
                                <tbody id="homeworkListBody"></tbody>
                            </table>
                        </div>

                        <div id="rightArea" class="right-area">
                            <form id="submitForm" onsubmit="return false;" enctype="multipart/form-data">
                                <input type="hidden" id="homework_code" name="homework_code">
                                <input type="hidden" id="submission_code" name="submission_code">

                                <h3 id="formTitle" style="margin-bottom:20px; border-bottom:2px solid #333; padding-bottom:10px; font-size:18px;">📝 과제 제출 및 확인</h3>

                                <table class="hw-table">
                                    <tr>
                                        <th style="width:100px;">과제명</th>
                                        <td colspan="3" style="text-align:left; font-weight:bold; color:#007bff;" id="val_title"></td>
                                    </tr>
                                    <tr>
                                        <th>마감일</th>
                                        <td id="val_end_date" style="color:#d63031; font-weight:bold;"></td>
                                        <th style="width:100px;">과정명</th>
                                        <td id="val_course"></td>
                                    </tr>
                                </table>

                                <div class="hw-textarea" id="val_content" style="white-space: pre-wrap; overflow-y:auto;"></div>

                                <div class="file-section teacher-box">
                                    <div style="font-weight:bold; font-size:13px; margin-bottom:10px; color:#555;">💾 강사 첨부 양식</div>
                                    <div id="teacherFileList"></div>
                                </div>

                                <div class="file-section student-box">
                                    <div style="font-weight:bold; font-size:13px; margin-bottom:10px; color:#0056b3;">📝 내 제출물</div>
                                    <div id="mySubmissionArea"></div>
                                    <div style="margin-top:12px; border-top:1px solid #dbeafe; padding-top:12px;">
                                        <input type="file" id="uploadFile" name="file" class="form-control">
                                        <div id="selectedFileName" style="font-size:12px; color:#166534; margin-top:8px; font-weight:bold;"></div>
                                    </div>
                                </div>

                                <div class="btn-group">
                                    <button type="button" id="btnSubmit" class="btn btn-submit" onclick="fn_submit()">과제 제출하기</button>
                                    <button type="button" class="btn btn-close" onclick="$('#rightArea').hide(); $('.hw-row').removeClass('active');">닫기</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>

<script>
    /* ❗ 로직 파트는 기존 코드를 100% 유지합니다 ❗ */
    let originData = [];
    let currentData = [];
    let currentSortOrder = 'none';

    $(document).ready(function() {
        loadList();
        $("#uploadFile").on("change", function() {
            if(this.files && this.files[0]) {
                $("#selectedFileName").text("📌 선택 파일: " + this.files[0].name);
            }
        });
    });

    function loadList() {
        $.ajax({
            url: "/stu/homeworklist",
            type: "GET",
            success: function(data) {
                originData = JSON.parse(JSON.stringify(data || []));
                currentData = data || [];
                renderTable(currentData);
            }
        });
    }

    function renderTable(data) {
        let html = "";
        const today = new Date().toISOString().slice(0, 10);

        if(!data || data.length === 0) {
            html = "<tr><td colspan='5' style='padding:40px; color:#999; font-size:14px;'>검색 결과가 없습니다.</td></tr>";
        } else {
            data.forEach((hw, i) => {
                const isClosed = hw.end_date < today;
                let status = isClosed ? "<span style='color:#d63031; font-weight:bold;'>마감</span>" : "<span style='color:#28a745; font-weight:bold;'>진행 중</span>";
                const hwTitle = hw.homework_title || hw.title || "제목 없음";
                const courseName = hw.course_name || "-";
                const subCode = hw.submission_code || 0;

                html += `<tr class="hw-row \${isClosed ? 'row-closed' : ''}" onclick="fetchDetail(this, \${hw.homework_code}, \${subCode})">
                        <td>\${i + 1}</td>
                        <td title="\${courseName}"><span class="ellipsis">\${courseName}</span></td>
                        <td title="\${hwTitle}" style="text-align:left;"><span class="ellipsis">\${hwTitle}</span></td>
                        <td>\${hw.end_date}</td>
                        <td>\${status}</td>
                    </tr>`;
            });
        }
        $("#homeworkListBody").html(html);
    }

    function fn_search() {
        const type = $("#searchType").val();
        const word = $("#searchText").val().trim().toLowerCase();
        currentData = originData.filter(item => (item[type] || "").toLowerCase().includes(word));
        currentSortOrder = 'none';
        $("#sortIcon").text("▲▼");
        $(".sortable").removeClass("active");
        renderTable(currentData);
    }

    function toggleSort(key) {
        if (currentData.length === 0) return;
        const sortIcon = $("#sortIcon");
        const sortHeader = $(".sortable");

        if (currentSortOrder === 'none') {
            currentData.sort((a, b) => (a[key] > b[key] ? 1 : a[key] < b[key] ? -1 : 0));
            currentSortOrder = 'asc';
            sortIcon.text("▲");
            sortHeader.addClass("active");
        } else if (currentSortOrder === 'asc') {
            currentData.sort((a, b) => (a[key] < b[key] ? 1 : a[key] > b[key] ? -1 : 0));
            currentSortOrder = 'desc';
            sortIcon.text("▼");
            sortHeader.addClass("active");
        } else {
            fn_search();
            return;
        }
        renderTable(currentData);
    }

    function fetchDetail(obj, hwCode, subId) {
        $(".hw-row").removeClass("active");
        if(obj) $(obj).addClass("active");

        $.ajax({
            url: '/stu/assignmentDetail/' + hwCode + '/' + subId,
            type: 'GET',
            success: function(res) {
                $("#rightArea").fadeIn(200);
                $("#homework_code").val(res.homework_code || hwCode);
                $("#submission_code").val(res.submission_code || subId || 0);

                $("#val_title").text(res.homework_title || res.title || "-");
                $("#val_end_date").text(res.end_date || "-");
                $("#val_course").text(res.course_name || "-");
                $("#val_content").text(res.content || "");

                let teacherHtml = '';
                let studentHtml = '';

                if (res.fileList && res.fileList.length > 0) {
                    const f = res.fileList[0];
                    const fId = f.file_id || f.fileId;
                    const fName = f.file_name || f.name || '강사 첨부파일';
                    if ((f.submission_code || f.submissionId || 0) == 0) {
                        teacherHtml = `<div class="file-item">📄 <a href="javascript:void(0)" onclick="downloadFile(\${fId})" class="text-link">\${fName}</a></div>`;
                    }
                }

                if (subId != 0) {
                    const studentFileId = res.file_id || res.fileId;
                    if (studentFileId && studentFileId != 0) {
                        const studentFileName = res.file_name || res.name || '내 제출물';
                        studentHtml = `<div class="file-item">📄 <a href="javascript:void(0)" onclick="downloadFile(\${studentFileId})" class="text-link">\${studentFileName}</a></div>`;
                    }
                }

                $("#teacherFileList").html(teacherHtml || '<span style="color:#999; font-size:12px;">첨부된 양식이 없습니다.</span>');
                $("#mySubmissionArea").html(studentHtml || (subId != 0 ? '제출된 파일 정보를 불러올 수 없습니다.' : '파일을 선택하여 제출해 주세요.'));
                $("#btnSubmit").text(studentHtml !== '' ? "수정하여 제출" : "과제 최종 제출");
                $("#selectedFileName").text("");
                $("#uploadFile").val("");

                const today = new Date().toISOString().slice(0, 10);
                if(res.end_date < today) $("#btnSubmit").hide(); else $("#btnSubmit").show();
            }
        });
    }

    function downloadFile(fileId) {
        if(!fileId || fileId == 0) return alert("파일 정보를 찾을 수 없습니다.");
        window.open(`/inst/downloadFile?file_id=\${fileId}`, '_blank');
    }

    function fn_submit() {
        const hwCode = $("#homework_code").val();
        const subCode = $("#submission_code").val();
        const fileInput = $("#uploadFile")[0];
        if(!fileInput.files[0] && (subCode == 0 || subCode == "")) return alert("제출할 파일을 선택해주세요.");
        if(!confirm(subCode != 0 ? "기존 과제를 수정하시겠습니까?" : "과제를 제출하시겠습니까?")) return;

        let formData = new FormData();
        if(fileInput.files[0]) formData.append("uploadFile", fileInput.files[0]);
        const voData = { homework_code: parseInt(hwCode), submission_code: (subCode == 0 || subCode == "") ? null : parseInt(subCode) };
        formData.append("vo", new Blob([JSON.stringify(voData)], { type: "application/json" }));

        $.ajax({
            url: "/stu/submitSubmission",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function(res) {
                if(res === "success") { alert("성공적으로 처리되었습니다."); location.reload(); }
                else alert("처리 중 오류가 발생했습니다.");
            },
            error: function() { alert("서버 통신 오류가 발생했습니다."); }
        });
    }
</script>
</body>
</html>