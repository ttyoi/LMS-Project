<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <meta charset="utf-8" />
    <title>시험 문항 관리 (강사)</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        /* 레이아웃 설정 */
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1; border: 1px solid #ddd; padding: 15px; background: #fff; border-radius: 8px; min-width: 500px; }
        .right-area { flex: 1; border: 1px solid #ddd; padding: 20px; background: #fff; border-radius: 8px; display: none; position: sticky; top: 10px; min-width: 500px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); max-height: 85vh; overflow-y: auto; }

        /* 테이블 스타일 */
        #testTable { width: 100%; border-collapse: collapse; }
        #testTable th, #testTable td { border: 1px solid #ddd; padding: 12px; text-align: center; font-size: 14px; }
        #testTable th { background: #f8f9fa; font-weight: bold; }

        .hw-row { cursor: pointer; transition: background 0.2s; }
        .hw-row:hover { background: #f1f3f5; }
        .hw-row.active { background: #e7f1ff; font-weight: bold; border-left: 4px solid #3a7df5; }

        .action-btn { padding: 6px 12px; border-radius: 4px; border: none; cursor: pointer; font-size: 13px; font-weight: bold; }
        .btn-primary { background: #3a7df5; color: white; }

        /* 문항 박스 스타일 */
        .ques-box { margin-bottom: 25px; padding: 15px; border: 1px solid #e9ecef; border-radius: 8px; background: #fff; border-left: 5px solid #3a7df5; position: relative; }
        .ques-title { font-size: 15px; font-weight: bold; margin-bottom: 12px; color: #333; padding-right: 50px; }
        .opt-list { display: flex; flex-direction: column; gap: 8px; }
        .opt-item { padding: 10px; border-radius: 5px; font-size: 14px; border: 1px solid #dee2e6; background: #f8f9fa; }

        /* 정답 하이라이트 */
        .opt-item.is-answer { border-color: #2ecc71; color: #157347; font-weight: bold; background: #d1e7dd; }
        .score-badge { font-size: 12px; background: #6c757d; color: white; padding: 2px 8px; border-radius: 10px; position: absolute; right: 15px; top: 15px; }
        .comment-box { margin-top: 12px; padding: 10px; background: #fff3cd; border-radius: 5px; font-size: 13px; color: #856404; }
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
                        <span class="btn_nav bold">출제 시험 관리</span>
                    </p>
                    <p class="conTitle"><span>출제 시험 문항 조회</span></p>

                    <div class="split-container">
                        <div class="list-area">
                            <div style="margin-bottom: 15px;">
                                <select id="courseFilter" class="form-control" style="width: 250px; display: inline-block;">
                                    <option value="all">과정 선택 (전체)</option>
                                </select>
                            </div>

                            <table id="testTable">
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>시험 명칭</th>
                                    <th>차시</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="testListBody"></tbody>
                            </table>
                        </div>

                        <div id="rightArea" class="right-area">
                            <h3 id="detailTitle" style="margin-bottom:10px; border-bottom:2px solid #333; padding-bottom:10px;">문항 상세 정보</h3>
                            <div id="summaryInfo" style="margin-bottom: 20px; font-size: 14px; color: #555;"></div>
                            <div id="questionListBody"></div>
                            <div style="text-align: center; margin-top: 30px;">
                                <button type="button" class="action-btn" onclick="$('#rightArea').hide()" style="background:#adb5bd; color:#fff; width: 100px;">닫기</button>
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
    /**
     * 1. 과정 목록 로드 (강사 담당 강의)
     */
    function loadCourseOptions() {
        $.get("/inst/exams/courses", function (data) {
            const $filter = $("#courseFilter");
            if (data && data.length > 0) {
                data.forEach(c => {
                    $filter.append(`<option value="\${c.course_id}">\${c.title}</option>`);
                });
            }
        }).fail(function() {
            console.error("강의 목록을 불러오지 못했습니다.");
        });
    }

    /**
     * 2. 시험 목록 로드 및 중복 제거
     */
    function loadTestList() {
        const courseId = $("#courseFilter").val();
        $.ajax({
            url: "/inst/exams/list",
            type: "GET",
            data: {
                course: courseId === "all" ? "" : courseId,
                pageSize: 9999
            },
            success: function (res) {
                const uniqueExams = [];
                const seen = new Set();

                if (res.list && res.list.length > 0) {
                    res.list.forEach(item => {
                        const key = `\${item.courseId}-\${item.period}`;
                        if (!seen.has(key)) {
                            seen.add(key);
                            uniqueExams.push(item);
                        }
                    });
                }
                renderList(uniqueExams);
            },
            error: function() {
                alert("시험 목록 로드 중 오류가 발생했습니다.");
            }
        });
    }

    /**
     * 3. 시험 목록 테이블 렌더링
     */
    function renderList(list) {
        const $tbody = $("#testListBody");
        $tbody.empty();

        if (!list || list.length === 0) {
            $tbody.append('<tr><td colspan="4">등록된 시험이 없습니다.</td></tr>');
            return;
        }

        list.forEach((t, idx) => {
            const tr = `<tr class="hw-row" onclick="viewExamDetail(this, \${t.courseId}, \${t.period})">
                <td>\${idx + 1}</td>
                <td style="text-align:left;">\${t.title}</td>
                <td>\${t.period}차시</td>
                <td><button class="action-btn btn-primary">문항보기</button></td>
            </tr>`;
            $tbody.append(tr);
        });
    }

    /**
     * 4. 문항 상세 조회 (강사 전용 detail-info API)
     */
    function viewExamDetail(row, courseId, period) {
        // UI 선택 표시
        $(".hw-row").removeClass("active");
        $(row).addClass("active");

        $.ajax({
            url: `/inst/exams/detail-info/\${courseId}/\${period}`,
            type: "GET",
            success: function (data) {
                // 데이터 유효성 검사
                if (!data || !data.questions || data.questions.length === 0) {
                    alert("해당 시험의 문항 정보가 없거나 불러올 수 없습니다.\n(서버에서 빈 데이터를 반환함)");
                    $("#rightArea").hide();
                    return;
                }

                $("#detailTitle").text(`[문항 확인] \${data.title || '시험 정보'}`);
                $("#summaryInfo").html(`<b>차시:</b> \${period}차시 | <b>문항 수:</b> \${data.questions.length}개`);

                let qHtml = "";
                data.questions.forEach((q, i) => {
                    // 정답 강조 로직 및 문항 생성
                    qHtml += `
                    <div class="ques-box">
                        <span class="score-badge">\${q.score || 0}점</span>
                        <div class="ques-title">\${i + 1}. \${q.content}</div>
                        <div class="opt-list">
                            <div class="opt-item \${q.correctAnswer == 1 ? 'is-answer' : ''}">1. \${q.option1}</div>
                            <div class="opt-item \${q.correctAnswer == 2 ? 'is-answer' : ''}">2. \${q.option2}</div>
                            <div class="opt-item \${q.correctAnswer == 3 ? 'is-answer' : ''}">3. \${q.option3}</div>
                            <div class="opt-item \${q.correctAnswer == 4 ? 'is-answer' : ''}">4. \${q.option4}</div>
                        </div>
                        \${q.comment ? `<div class="comment-box"><b>📝 해설:</b> \${q.comment}</div>` : ''}
                    </div>`;
                });

                $("#questionListBody").html(qHtml);
                $("#rightArea").fadeIn(200);
            },
            error: function(xhr) {
                console.error("상세 조회 에러:", xhr);
                if(xhr.status === 500) {
                    alert("서버 오류(500)가 발생했습니다. 강사 전용 조회 API를 확인하세요.");
                } else {
                    alert("문항 정보를 가져오는 중 오류가 발생했습니다.");
                }
            }
        });
    }

    /**
     * 페이지 로드 시 초기화
     */
    $(document).ready(function () {
        loadCourseOptions();
        loadTestList();

        // 필터 변경 이벤트
        $("#courseFilter").on("change", function () {
            loadTestList();
            $("#rightArea").hide();
        });
    });
</script>
</body>
</html>