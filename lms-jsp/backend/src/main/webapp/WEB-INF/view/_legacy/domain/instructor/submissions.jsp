<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>제출 현황</title>

    <link rel="stylesheet" href="/css/homework/homeworklist.css">
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        .submission-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .submission-table th { background: #f2f2f2; padding: 10px; text-align: center; border-bottom: 2px solid #ddd;}
        .submission-table td { padding: 10px; border-bottom: 1px solid #eee; text-align: center;}
        .submission-table tr:hover { background: #fafafa; }

        /* 상태 태그 */
        .tag {
            display:inline-block;
            padding:4px 12px;
            border-radius:12px;
            font-size:13px;
            cursor:pointer;
            transition:0.15s;
            border:1px solid #ddd;
        }
        .tag.gray {
            background:#f4f4f4;
            color:#666;
        }
        .tag.dark {
            background:#4f5d73;
            color:#fff;
            border-color:#4f5d73;
        }
        .tag-disabled {
            background:#f5f5f5;
            color:#bbb;
            border:1px solid #eee;
            cursor:not-allowed;
        }

        /* 모달 */
        .modal-bg {
            display:none;
            position:fixed;
            top:0; left:0;
            width:100%; height:100%;
            background:rgba(0,0,0,0.45);
            z-index:900;
        }
        .modal-box {
            width:420px;
            background:#fff;
            padding:22px;
            border-radius:8px;
            position:absolute;
            top:50%; left:50%;
            transform:translate(-50%, -50%);
        }
        .modal-title {
            font-size:18px;
            font-weight:600;
            margin-bottom:15px;
        }
        .modal-btn {
            text-align:right;
            margin-top:18px;
        }

        /* 버튼 */
        .btn {
            padding:6px 14px;
            border-radius:4px;
            border:1px solid #ccc;
            background:#f7f7f7;
            color:#333;
            font-size:13px;
            cursor:pointer;
            transition:0.15s;
        }
        .btn:hover { background:#eee; }

        .btn-primary {
            background:#4f5d73;
            border-color:#4f5d73;
            color:#fff;
        }
        .btn-primary:hover {
            background:#3f4b5d;
        }

        textarea.feedback-input {
            width:100%;
            height:90px;
            margin-top:8px;
        }
        input.score-input {
            width:100px;
            padding:6px;
        }

        .pagination { margin:20px 0; text-align:center; }
        .pagination a, .pagination span {
            display:inline-block; padding:5px 10px; margin:0 3px; border:1px solid #ccc; cursor:pointer;
        }
        .pagination .current { background:#4f5d73; color:white; border-color:#4f5d73; }
    </style>
</head>

<body>

<form id="myForm" action="javascript:void(0);">

    <div id="wrap_area">
        <div id="container">
            <ul>
                <li class="lnb">
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
                </li>

                <li class="contents">
                    <div class="content">

                        <p class="conTitle"><span>제출된 과제 목록</span></p>

                        <table class="submission-table">
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>과정명</th>
                                <th>과제명</th>
                                <th>학생</th>
                                <th>다운로드</th>
                                <th>상태</th>
                                <th>점수</th>
                                <th>피드백</th>
                            </tr>
                            </thead>
                            <tbody id="submissionBody"></tbody>
                        </table>

                        <div class="pagination"></div>

                    </div>
                </li>
            </ul>
        </div>
    </div>

</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    function safe(v) {
        if (!v) return "";
        return String(v).replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    function getStatus(startDate, endDate) {
        const today = new Date().toISOString().slice(0,10);
        if (startDate > today) return "진행 예정";
        if (endDate < today) return "마감";
        return "진행 중";
    }

    function renderList(list) {
        if (!list || list.length === 0) {
            $("#submissionBody").html('<tr><td colspan="8">제출된 과제가 없습니다.</td></tr>');
            return;
        }

        let html = "";

        $.each(list, function(i, row) {
            const status = getStatus(row.start_date, row.end_date);
            const isClosed = (status === "마감");

            /* 다운로드 */
            let fileDownload = "-";
            if (row.file_id && isClosed) {
                fileDownload = `<a href="/file/download?fileId=${row.file_id}">다운로드</a>`;
            } else if (row.file_id) {
                fileDownload = `<span class="tag-disabled">마감 후 가능</span>`;
            }

            /* 점수 */
            let scoreTag = "";
            if (isClosed) {
                if (row.score == null) {
                    scoreTag = `<span class="tag gray"
                        onclick="openScoreModal(${row.submission_code}, '', '${safe(row.student_name)}')">등록</span>`;
                } else {
                    scoreTag = `<span class="tag dark"
                        onclick="openScoreModal(${row.submission_code}, '${row.score}', '${safe(row.student_name)}')">
                        ${row.score}점</span>`;
                }
            } else {
                scoreTag = `<span class="tag-disabled">${row.score == null ? '등록' : row.score + '점'}</span>`;
            }

            /* 피드백 */
            let fbTag = "";
            let fb = row.feedback ? safe(row.feedback) : "-";

            if (isClosed) {
                if (fb === "-") {
                    fbTag = `<span class="tag gray"
                        onclick="openFeedbackModal(${row.submission_code}, '', '${safe(row.student_name)}')">입력</span>`;
                } else {
                    fbTag = `<span class="tag dark"
                        onclick="openFeedbackModal(${row.submission_code}, '${fb.replace(/'/g,"\\'")}', '${safe(row.student_name)}')">
                        보기</span>`;
                }
            } else {
                fbTag = `<span class="tag-disabled">${fb === "-" ? "없음" : "보기"}</span>`;
            }

            html += `
                <tr>
                    <td>${i + 1}</td>
                    <td>${safe(row.course_name)}</td>
                    <td>${safe(row.homework_title)}</td>
                    <td>${safe(row.student_name)}</td>
                    <td>${fileDownload}</td>
                    <td>${status}</td>
                    <td>${scoreTag}</td>
                    <td>${fbTag}</td>
                </tr>
            `;
        });

        $("#submissionBody").html(html);
    }

    $(document).ready(function () {
        const homeworkCode = new URLSearchParams(location.search).get("homeworkCode");
        if (homeworkCode) {
            $.get("/inst/submissions/list", { homeworkCode }, renderList);
        } else {
            $.get("/inst/submissions/listAll", renderList);
        }
    });

    /* ===== 점수 ===== */
    function openScoreModal(submissionCode, score, studentName) {
        $("#modal_submission_code").val(submissionCode);
        $("#modal_score").val(score || "");
        $("#scoreStudentName").text(studentName);
        $("#scoreModal").fadeIn(150);
    }

    function openScoreConfirm() {
        const score = $("#modal_score").val();
        if (!score || score < 0) {
            alert("점수를 입력하세요.");
            return;
        }
        const name = $("#scoreStudentName").text();
        $("#scoreConfirmText").text(`${name} 학생에게 ${score}점을 부여하시겠습니까?`);
        $("#scoreConfirmModal").fadeIn(150);
    }

    function submitScore() {
        const data = {
            submissionCode: $("#modal_submission_code").val(),
            score: $("#modal_score").val()
        };

        $.ajax({
            url: "/inst/submissions/update",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function () {
                alert("점수가 저장되었습니다.");
                closeAll();
                location.reload();
            }
        });
    }

    /* ===== 피드백 ===== */
    function openFeedbackModal(submissionCode, feedback, studentName) {
        $("#modal_submission_code").val(submissionCode);
        $("#modal_feedback").val(feedback || "");
        $("#feedbackStudentName").text(studentName);
        $("#feedbackModal").fadeIn(150);
    }

    function saveFeedback() {
        const data = {
            submissionCode: $("#modal_submission_code").val(),
            feedback: $("#modal_feedback").val()
        };

        $.ajax({
            url: "/inst/submissions/update",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function () {
                alert("피드백이 저장되었습니다.");
                closeAll();
                location.reload();
            }
        });
    }

    function closeAll() {
        $(".modal-bg").fadeOut(150);
    }
</script>

<!-- ================= 모달 ================= -->

<!-- 점수 입력 -->
<div class="modal-bg" id="scoreModal">
    <div class="modal-box">
        <div class="modal-title">
            점수 등록 – <span id="scoreStudentName"></span>
        </div>

        <input type="hidden" id="modal_submission_code">
        <input type="number" id="modal_score" class="score-input" placeholder="점수 입력">

        <div class="modal-btn">
            <button class="btn btn-primary" onclick="openScoreConfirm()">확인</button>
            <button class="btn" onclick="closeAll()">취소</button>
        </div>
    </div>
</div>

<!-- 점수 확인 -->
<div class="modal-bg" id="scoreConfirmModal">
    <div class="modal-box">
        <div class="modal-title">점수 확인</div>
        <p id="scoreConfirmText"></p>

        <div class="modal-btn">
            <button class="btn btn-primary" onclick="submitScore()">등록</button>
            <button class="btn" onclick="closeAll()">취소</button>
        </div>
    </div>
</div>

<!-- 피드백 -->
<div class="modal-bg" id="feedbackModal">
    <div class="modal-box">
        <div class="modal-title">
            피드백 입력 – <span id="feedbackStudentName"></span>
        </div>

        <textarea id="modal_feedback" class="feedback-input" placeholder="내용 입력"></textarea>

        <div class="modal-btn">
            <button class="btn btn-primary" onclick="saveFeedback()">저장</button>
            <button class="btn" onclick="closeAll()">취소</button>
        </div>
    </div>
</div>

</body>
</html>
