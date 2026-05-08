<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>제출 현황</title>

    <link rel="stylesheet" href="/css/homework/homeworklist.css">
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        /* 2분할 레이아웃 적용 */
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1.2; border: 1px solid #ddd; padding: 15px; background: #fff; border-radius: 8px; min-width: 600px; }
        .right-area { flex: 0.8; border: 1px solid #ddd; padding: 20px; background: #fff; border-radius: 8px; display: none; position: sticky; top: 10px; min-width: 400px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        .submission-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .submission-table th { background: #f2f2f2; padding: 10px; text-align: center; border-bottom: 2px solid #ddd; font-size: 13px;}
        .submission-table td { padding: 10px; border-bottom: 1px solid #eee; text-align: center; font-size: 13px;}
        .submission-table tr.active { background: #e7f1ff; font-weight: bold; }
        .submission-table tr { cursor: pointer; }
        .submission-table tr:hover { background: #fafafa; }

        /* 입력 폼 스타일 */
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; font-weight: bold; margin-bottom: 5px; font-size: 14px; }
        .form-control { width: 100%; border: 1px solid #ccc; padding: 10px; border-radius: 4px; box-sizing: border-box; }
        .hw-textarea { height: 150px; resize: none; }

        /* 버튼 영역 */
        .btn-group { margin-top: 20px; text-align: right; }
        .btn { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-left: 5px; font-weight: bold; }
        .btn-primary { background: #4f5d73; color: white; }
        .btn-close { background: #6c757d; color: white; }

        .tag-disabled { color:#bbb; font-size:12px; }
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
                        <span class="btn_nav bold">제출된 과제 목록</span>
                        <a href="javascript:location.reload();" class="btn_set refresh">새로고침</a>
                    </p>
                    <p class="conTitle"><span>제출된 과제 현황</span></p>

                    <div class="split-container">
                        <div class="list-area">
                            <table class="submission-table">
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>학생명</th>
                                    <th>과정/과제명</th>
                                    <th>제출일</th>
                                    <th>상태</th>
                                    <th>점수</th>
                                </tr>
                                </thead>
                                <tbody id="submissionBody"></tbody>
                            </table>
                        </div>

                        <div id="rightArea" class="right-area">
                            <h3 id="formTitle" style="margin-bottom:20px; border-bottom:2px solid #333; padding-bottom:10px;">채점 및 피드백</h3>

                            <input type="hidden" id="sub_code">

                            <div class="form-group">
                                <label class="form-label">학생 성명</label>
                                <input type="text" id="std_name" class="form-control" readonly style="background:#f9f9f9;">
                            </div>

                            <div class="form-group">
                                <label class="form-label">첨부 파일</label>
                                <div id="fileDownloadArea" style="padding: 10px; border: 1px solid #eee; border-radius: 4px;"></div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">점수 부여</label>
                                <input type="number" id="sub_score" class="form-control" placeholder="점수를 입력하세요 (0~100)">
                            </div>

                            <div class="form-group">
                                <label class="form-label">피드백 내용</label>
                                <textarea id="sub_feedback" class="form-control hw-textarea" placeholder="학생에게 전달할 피드백을 입력하세요"></textarea>
                            </div>

                            <div class="btn-group">
                                <button type="button" class="btn btn-primary" onclick="updateSub()">저장하기</button>
                                <button type="button" class="btn btn-close" onclick="$('#rightArea').hide()">닫기</button>
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
    function safe(v) { return v ? String(v).replace(/</g, "&lt;").replace(/>/g, "&gt;") : ""; }

    function getStatus(startDate, endDate) {
        const today = new Date().toISOString().slice(0,10);
        if (startDate > today) return "진행 예정";
        if (endDate < today) return "마감";
        return "진행 중";
    }

    // 목록 렌더링
    function renderList(list) {
        let html = "";
        if (!list || list.length === 0) {
            html = '<tr><td colspan="6">제출된 내역이 없습니다.</td></tr>';
        } else {
            $.each(list, function(i, row) {
                const status = getStatus(row.start_date, row.end_date);
                const scoreDisplay = row.score !== null ? row.score + "점" : "<span style='color:#bbb;'>미입력</span>";

                html += `
                    <tr class="sub-row" onclick="openEditArea(this, \${JSON.stringify(row).replace(/"/g, '&quot;')})">
                        <td>\${i + 1}</td>
                        <td>\${safe(row.student_name)}</td>
                        <td style="text-align:left;">[\${safe(row.course_name)}]<br>\${safe(row.homework_title)}</td>
                        <td>\${row.submit_date || '-'}</td>
                        <td>\${status}</td>
                        <td>\${scoreDisplay}</td>
                    </tr>`;
            });
        }
        $("#submissionBody").html(html);
    }

    $(document).ready(function () {
        const homeworkCode = new URLSearchParams(location.search).get("homeworkCode");
        const url = homeworkCode ? "/inst/submissions/list?homeworkCode=" + homeworkCode : "/inst/submissions/listAll";
        $.get(url, renderList);
    });

    // 오른쪽 편집 영역 열기
    function openEditArea(obj, row) {
        $(".sub-row").removeClass("active");
        $(obj).addClass("active");

        const status = getStatus(row.start_date, row.end_date);

        // 데이터 바인딩
        $("#sub_code").val(row.submission_code);
        $("#std_name").val(row.student_name);
        $("#sub_score").val(row.score);
        $("#sub_feedback").val(row.feedback);

        // 파일 다운로드 로직
        let fileHtml = "";
        if (row.file_id) {
            if (status === "마감") {
                fileHtml = `<a href="/inst/downloadFile?file_id=\${row.file_id}" class="btn btn-primary" style="text-decoration:none; display:inline-block; font-size:12px;">📄 파일 다운로드</a>`;
            } else {
                fileHtml = `<span class="tag-disabled">마감 후 다운로드 가능</span>`;
            }
        } else {
            fileHtml = `<span class="tag-disabled">제출된 파일 없음</span>`;
        }
        $("#fileDownloadArea").html(fileHtml);

        $("#rightArea").fadeIn(200);

        // 마감 전이면 점수 입력 막기 (정책에 따라 조절 가능)
        const isClosed = (status === "마감");
        $("#sub_score, #sub_feedback").prop("disabled", !isClosed);
        if(!isClosed) {
            $("#formTitle").text("조회 모드 (마감 후 채점 가능)");
            $(".btn-primary").hide();
        } else {
            $("#formTitle").text("채점 및 피드백");
            $(".btn-primary").show();
        }
    }

    // 점수 및 피드백 업데이트
    function updateSub() {
        const score = $("#sub_score").val();
        if (score < 0 || score > 100) {
            alert("점수는 0점에서 100점 사이로 입력하세요.");
            return;
        }

        const data = {
            submissionCode: $("#sub_code").val(),
            score: score,
            feedback: $("#sub_feedback").val()
        };

        $.ajax({
            url: "/inst/submissions/update",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function () {
                alert("저장되었습니다.");
                location.reload();
            },
            error: function() {
                alert("저장 중 오류가 발생했습니다.");
            }
        });
    }
</script>

</body>
</html>