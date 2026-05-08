<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>과제 통합 관리 (강사)</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        /* 2분할 레이아웃 및 공통 스타일 */
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1.2; border: 1px solid #ddd; padding: 15px; background: #fff; border-radius: 8px; min-width: 600px; }
        .right-area { flex: 0.8; border: 1px solid #ddd; padding: 25px; background: #fff; border-radius: 8px; display: none; position: sticky; top: 10px; min-width: 450px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }

        /* 검색 바 스타일 - 세로 중앙 정렬 보정 */
        .search-bar { margin-bottom: 15px; display: flex; gap: 5px; justify-content: flex-start; align-items: center; }
        .search-select { width: 110px !important; }
        .search-input { width: 220px !important; }

        /* 테이블 스타일 및 글자 짤림 방지 */
        .hw-table { width: 100%; border-collapse: collapse; margin-bottom: 15px; table-layout: fixed; }
        .hw-table th, .hw-table td { border: 1px solid #bcbcbc; padding: 10px; font-size: 14px; text-align: center; }
        .hw-table th { background: #f4f4f4; }

        /* 컬럼 너비 설정 */
        .col-num { width: 50px; }
        .col-course { width: 150px; }
        .col-title { width: auto; }
        .col-date { width: 120px; }
        .col-status { width: 90px; }

        .ellipsis { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; width: 100%; }

        .hw-row { cursor: pointer; transition: background 0.2s; }
        .hw-row:hover { background: #f8f9fa; }
        .hw-row.active { background: #e7f1ff; border-left: 4px solid #007bff; font-weight: bold; }
        .hw-row.row-closed { background-color: #f2f2f2; color: #888; pointer-events: none; }

        /* 정렬 헤더 스타일 */
        .sortable { cursor: pointer; position: relative; user-select: none; transition: background 0.2s; }
        .sortable:hover { background-color: #e9ecef !important; }
        .sort-icon { font-size: 11px; margin-left: 3px; color: #bbb; }
        .sortable.active .sort-icon { color: #007bff; font-weight: bold; }

        /* 폼 컨트롤 및 짤림 방지 높이 보정 */
        .form-control {
            width: 100%; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px;
            height: 38px; padding: 0 10px; line-height: 36px; vertical-align: middle;
        }
        .form-control:disabled { background: #fafafa; border: 1px solid #eee; color: #333; }
        .hw-textarea { width: 100%; height: 200px; resize: none; background: #fcfcfc; padding: 10px; border: 1px solid #ddd; border-radius: 4px; line-height: 1.5; }

        /* 버튼 영역 */
        .btn-group { margin-top: 20px; text-align: right; border-top: 1px solid #eee; padding-top: 15px; }
        .btn { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; margin-left: 5px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-edit { background: #4b7bec; color: white; }
        .btn-save { background: #20bf6b; color: white; }
        .btn-delete { background: #eb3b5a; color: white; }
        .btn-close { background: #6c757d; color: white; }

        /* 파일 미리보기 */
        #filePreview { margin-top: 10px; }
        .file-item { display: flex; align-items: center; gap: 8px; background: #f8f9fa; padding: 6px 12px; border: 1px solid #ddd; margin-bottom: 5px; font-size: 13px; }
        .text-link { color: #007bff; text-decoration: none; cursor: pointer; font-weight: bold; }
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
                        <span class="btn_nav bold">나의 강의 관리</span>
                        <span class="btn_nav bold">과제 목록</span>
                        <a href="javascript:location.reload();" class="btn_set refresh">새로고침</a>
                    </p>
                    <p class="conTitle"><span>과제 통합 관리 (강사)</span></p>

                    <div class="split-container">
                        <div class="list-area">
                            <div class="search-bar">
                                <select id="searchType" class="form-control search-select">
                                    <option value="course_name">과정명</option>
                                    <option value="homework_title">과제명</option>
                                </select>
                                <input type="text" id="searchText" class="form-control search-input" placeholder="검색어를 입력하세요" onkeyup="if(window.event.keyCode==13){fn_search()}">
                                <button type="button" class="btn btn-primary" style="height:38px;" onclick="fn_search()">검색</button>
                                <button type="button" class="btn btn-primary" style="height:38px; margin-left:auto;" onclick="openInsertForm()">신규 등록</button>
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
                            <form id="myForm" onsubmit="return false;" enctype="multipart/form-data">
                                <input type="hidden" id="homework_code" name="homework_code">
                                <h3 id="formTitle" style="margin-bottom:20px; border-bottom:2px solid #333; padding-bottom:10px;">과제 정보</h3>

                                <table class="hw-table">
                                    <tr id="courseRow">
                                        <th style="width:100px;">과정 선택</th>
                                        <td colspan="3">
                                            <select name="course_id" id="course_id" class="form-control"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>과제명</th>
                                        <td colspan="3"><input type="text" id="title" name="title" class="form-control"></td>
                                    </tr>
                                    <tr>
                                        <th>시작일</th>
                                        <td><input type="date" id="start_date" name="start_date" class="form-control"></td>
                                        <th>마감일</th>
                                        <td><input type="date" id="end_date" name="end_date" class="form-control"></td>
                                    </tr>
                                </table>

                                <textarea id="content" name="content" class="hw-textarea" placeholder="과제 내용을 입력하세요"></textarea>

                                <div style="margin-top:15px;">
                                    <div id="filePreview"></div>
                                    <input type="file" id="homeworkFile" name="files" multiple style="margin-top:10px;">
                                </div>

                                <div class="btn-group">
                                    <div id="viewModeBtns">
                                        <button type="button" class="btn btn-edit" onclick="enableEditMode()">수정 모드</button>
                                        <button type="button" class="btn btn-close" onclick="$('#rightArea').hide()">닫기</button>
                                    </div>
                                    <div id="editModeBtns" style="display:none;">
                                        <button type="button" class="btn btn-save" onclick="submitForm('update')">수정완료</button>
                                        <button type="button" class="btn btn-delete" onclick="deleteHw()">삭제</button>
                                        <button type="button" class="btn btn-close" onclick="cancelEdit()">취소</button>
                                    </div>
                                    <div id="insertModeBtns" style="display:none;">
                                        <button type="button" class="btn btn-save" onclick="submitForm('insert')">등록하기</button>
                                        <button type="button" class="btn btn-close" onclick="$('#rightArea').hide()">취소</button>
                                    </div>
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
    let originData = [];   // 서버 원본 데이터
    let currentData = [];  // 검색/정렬 적용 데이터
    let currentSortOrder = 'none'; // none -> asc -> desc -> none
    let currentDetailData = null;

    $(document).ready(function() {
        loadList();
        loadCourseOptions();
        $("#homeworkFile").on("change", function() { renderFileList(this.files); });
    });

    // 1. 목록 로드
    function loadList() {
        $.ajax({
            url: "/inst/homeworklist",
            type: "GET",
            success: function(data) {
                originData = JSON.parse(JSON.stringify(data || []));
                currentData = data || [];
                renderTable(currentData);
            }
        });
    }

    // 2. 테이블 렌더링
    function renderTable(data) {
        let html = "";
        const today = new Date().toISOString().slice(0, 10);
        data.forEach((hw, i) => {
            const isClosed = hw.end_date < today;
            let status = isClosed ? "<span style='color:red; font-weight:bold;'>마감</span>" :
                (hw.start_date > today) ? "<span style='color:blue; font-weight:bold;'>진행 예정</span>" :
                    "<span style='color:green; font-weight:bold;'>진행 중</span>";

            html += `<tr class="hw-row \${isClosed ? 'row-closed' : ''}" onclick="loadDetail(this, \${hw.homework_code})">
                    <td>\${i + 1}</td>
                    <td title="\${hw.course_name}"><span class="ellipsis">\${hw.course_name || '-'}</span></td>
                    <td title="\${hw.title || hw.homework_title}" style="text-align:left;"><span class="ellipsis">\${hw.title || hw.homework_title}</span></td>
                    <td>\${hw.end_date}</td>
                    <td>\${status}</td>
                </tr>`;
        });
        $("#homeworkListBody").html(html);
    }

    // 3. 검색 필터링
    function fn_search() {
        const type = $("#searchType").val();
        const word = $("#searchText").val().trim().toLowerCase();
        currentData = originData.filter(item => (item[type] || "").toLowerCase().includes(word));
        currentSortOrder = 'none';
        $("#sortIcon").text("▲▼");
        $(".sortable").removeClass("active");
        renderTable(currentData);
    }

    // 4. 3단계 정렬
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
            fn_search(); // 기본순 복구
            return;
        }
        renderTable(currentData);
    }

    // 5. 상세 보기
    function loadDetail(obj, code) {
        $(".hw-row").removeClass("active");
        if(obj) $(obj).addClass("active");

        $.ajax({
            url: "/inst/assignmentdetailreturn/" + code,
            type: "GET",
            success: function(data) {
                currentDetailData = data;
                $("#rightArea").fadeIn(200);
                $("#formTitle").text("과제 상세 정보");
                $("#courseRow").hide();

                $("#homework_code").val(data.homework_code);
                $("#title").val(data.title || data.homework_title);
                $("#start_date").val(data.start_date);
                $("#end_date").val(data.end_date);
                $("#content").val(data.content);
                if(data.course_id) $("#course_id").val(data.course_id);

                let fileHtml = "";
                if(data.fileList && data.fileList.length > 0) {
                    data.fileList.forEach(f => {
                        fileHtml += `<div class="file-item">📄 <a href="javascript:void(0)" onclick="downloadFile(\${f.file_id})" class="text-link">\${f.name}</a></div>`;
                    });
                } else {
                    fileHtml = "<div style='color:#999; font-size:13px;'>첨부된 파일이 없습니다.</div>";
                }
                $("#filePreview").html(fileHtml);

                setReadOnly(true);
                $("#viewModeBtns").show();
                $("#editModeBtns, #insertModeBtns").hide();
            }
        });
    }

    // CRUD 및 기타 유틸 함수들
    function loadCourseOptions() {
        $.get("/inst/getcourselist", res => {
            const $select = $("#course_id").empty().append('<option value="">과정을 선택하세요</option>');
            res.forEach(c => $select.append(`<option value="\${c.course_id}">\${c.title}</option>`));
        });
    }

    function submitForm(mode) {
        if(mode === 'insert' && !$("#course_id").val()) return alert("과정을 선택하세요.");
        if(!$("#title").val().trim()) return alert("과제명을 입력하세요.");

        $("#myForm input, #myForm textarea, #myForm select").prop("disabled", false);
        let formData = new FormData($('#myForm')[0]);
        if ($("#homeworkFile")[0].files.length === 0) formData.delete("files");
        if(mode === 'insert') formData.delete("homework_code");

        $.ajax({
            url: (mode === 'insert') ? "/inst/homeworkInsert" : "/inst/homeworkUpdate",
            type: "POST",
            data: formData,
            processData: false, contentType: false,
            success: function() { alert("저장되었습니다."); location.reload(); },
            error: function() { alert("오류가 발생했습니다."); setReadOnly(false); }
        });
    }

    function openInsertForm() {
        $(".hw-row").removeClass("active");
        $("#rightArea").fadeIn(200);
        $("#formTitle").text("신규 과제 등록");
        $("#courseRow").show();
        $("#myForm")[0].reset();
        $("#filePreview").empty();
        setReadOnly(false);
        $("#insertModeBtns").show();
        $("#viewModeBtns, #editModeBtns").hide();
    }

    function enableEditMode() { setReadOnly(false); $("#viewModeBtns").hide(); $("#editModeBtns").show(); }
    function cancelEdit() { if(currentDetailData) loadDetail(null, currentDetailData.homework_code); }
    function setReadOnly(isRead) { $("#myForm input, #myForm textarea, #myForm select").prop("disabled", isRead); $("#homeworkFile").toggle(!isRead); }
    function deleteHw() { if(confirm("정말 삭제하시겠습니까?")) $.get("/inst/homeworkDelete", {homework_code:$("#homework_code").val()}, () => location.reload()); }
    function downloadFile(fId) { window.open(`/inst/downloadFile?file_id=\${fId}`, '_blank'); }
    function renderFileList(files) {
        const preview = $("#filePreview").empty();
        [...files].forEach(file => preview.append(`<div class="file-item">📄 \${file.name}</div>`));
    }
</script>
</body>
</html>