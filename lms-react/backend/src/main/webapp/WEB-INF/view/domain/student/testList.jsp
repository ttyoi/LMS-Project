<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <meta charset="utf-8" />
    <title>시험 목록 및 결과 (수강생)</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        /* 🔹 레이아웃 및 여백 설정 (기존 관리 페이지와 통일) */
        .content { padding: 20px; margin-bottom: 20px; }
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1.2; border: 1px solid #ddd; padding: 15px; background: #fff; border-radius: 8px; min-width: 650px; }
        .right-area {
            flex: 0.8; border: 1px solid #ddd; padding: 25px; background: #fff;
            border-radius: 8px; display: none; position: sticky; top: 10px;
            min-width: 450px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-height: 85vh; overflow-y: auto;
        }

        /* 🔹 컨트롤 영역 (셀렉트 박스 높이 보정) */
        .search-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }

        #courseFilter {
            height: 38px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
            padding: 0 10px;
            line-height: 36px;
            vertical-align: middle;
            min-width: 200px;
        }

        /* 🔹 테이블 및 행 스타일 */
        #testTable { width: 100%; border-collapse: collapse; table-layout: fixed; }
        #testTable th, #testTable td { border: 1px solid #bcbcbc; padding: 12px 8px; text-align: center; font-size: 14px; }
        #testTable th { background: #f4f4f4; color: #333; }

        .hw-row { cursor: pointer; transition: background 0.2s; }
        .hw-row:hover { background: #f8f9fa; }
        /* 액티브 상태 디자인 통일 */
        .hw-row.active { background-color: #e7f1ff !important; border-left: 4px solid #007bff; font-weight: bold; }

        /* 🔹 버튼 스타일 */
        .action-btn {
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-radius: 15px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: all 0.2s;
        }
        .btn-primary { background: #007bff; color: white; border: none; }
        .btn-primary:hover { background: #0056b3; }
        .btn-ghost { background: #f0f0f0; color: #333; }

        /* 🔹 우측 결과창 상세 스타일 */
        .result-question { border: 1px solid #eee; padding: 15px; margin-bottom: 15px; border-radius: 6px; text-align: left; }
        .opt { padding: 10px; border-radius: 5px; border: 1px solid #f0f0f0; margin-bottom: 8px; font-size: 13px; color: #555; }
        .opt.selected { background: #e6f0ff; border-color: #007bff; color: #333; }
        .opt.correct { color: #d63031; font-weight: bold; border-color: #ff7675; }

        .explain {
            margin-top: 10px; padding: 12px; border-top: 1px dashed #ddd;
            color: #333; background: #fdf2f2; font-size: 12px;
            border-left: 3px solid #d63031; line-height: 1.6;
        }

        .result-meta {
            background: #f9f9f9; padding: 15px; border-radius: 5px;
            margin-bottom: 20px; display: flex; flex-direction: column;
            gap: 8px; font-size: 14px; border: 1px solid #ddd; text-align: left;
        }

        /* 🔹 페이지네이션 디자인 통일 */
        .pagination { margin-top: 20px; text-align: center; }
        .pagination .btn {
            display: inline-block; padding: 5px 10px; margin: 0 2px;
            border: 1px solid #ddd; border-radius: 3px; background: #fff;
            cursor: pointer; font-size: 13px; color: #333;
        }
        .pagination .btn.btn-primary { background: #007bff; color: white; border-color: #007bff; font-weight: bold; }
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
                        <span class="btn_nav bold">시험 목록</span>
                        <a href="javascript:location.reload();" class="btn_set refresh">새로고침</a>
                    </p>
                    <p class="conTitle"><span>나의 시험 현황</span></p>

                    <div class="split-container">
                        <div class="list-area">
                            <div class="search-area">
                                <select id="courseFilter">
                                    <option value="all">과정명 전체</option>
                                </select>
                                <span id="pageInfo" style="font-size: 13px; color: #666;"></span>
                            </div>

                            <table id="testTable">
                                <thead>
                                <tr>
                                    <th style="width:50px;">번호</th>
                                    <th>시험명</th>
                                    <th style="width:60px;">차시</th>
                                    <th style="width:110px;">평가일</th>
                                    <th style="width:80px;">점수</th>
                                    <th style="width:100px;">상태</th>
                                </tr>
                                </thead>
                                <tbody id="testListBody"></tbody>
                            </table>
                            <div class="pagination" id="pagination"></div>
                        </div>

                        <div id="rightArea" class="right-area">
                            <h3 id="detailTitle" style="margin-bottom:20px; border-bottom:2px solid #333; padding-bottom:10px; font-size:18px;">📝 시험 결과 상세보기</h3>
                            <div id="resultMeta"></div>
                            <div id="resultContainer">
                                <p style="color:#999; text-align:center; padding: 50px 0;">목록에서 '결과확인' 버튼을 클릭하세요.</p>
                            </div>
                            <div style="text-align: right; margin-top: 25px; border-top: 1px solid #eee; padding-top: 15px;">
                                <button type="button" class="action-btn" onclick="$('#rightArea').hide(); $('.hw-row').removeClass('active');" style="background:#6c757d; color:#fff; border:none;">닫기</button>
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
    /* ❗ 아래 스크립트 로직은 기존 코드를 그대로 유지합니다. ❗ */
    let currentPage = 1;
    const pageSize = 5;
    let totalCount = 0;

    $(document).ready(function () {
        loadCourseOptions();
        loadTestList();

        $("#courseFilter").on("change", function () {
            currentPage = 1;
            loadTestList();
            $("#rightArea").hide();
        });
    });

    function loadCourseOptions() {
        $.ajax({
            url: "/stu/exams/courses",
            type: "GET",
            success: function (data) {
                const $filter = $("#courseFilter");
                $filter.empty().append('<option value="all">과정명 전체</option>');
                data.forEach(c => {
                    $filter.append(`<option value="\${c.course_id}">\${c.title}</option>`);
                });
            }
        });
    }

    function loadTestList() {
        const course = $("#courseFilter").val();
        $.ajax({
            url: "/stu/exams/list",
            type: "GET",
            data: { page: currentPage, pageSize: pageSize, course: course === "all" ? "" : course },
            success: function(res) {
                renderList(res.list);
                renderPagination(res.totalCount);
            }
        });
    }

    function renderList(list) {
        const $tbody = $("#testListBody");
        $tbody.empty();

        if (!list || list.length === 0) {
            $tbody.append('<tr><td colspan="6">조회된 시험이 없습니다.</td></tr>');
            return;
        }

        list.forEach((t, idx) => {
            const no = (currentPage - 1) * pageSize + idx + 1;
            let evalHtml = "";

            if (t.score === null) {
                if (t.status === 1) {
                    evalHtml = `<button class="action-btn btn-primary" onclick="onStartExam(\${t.courseId}, \${t.period})">응시하기</button>`;
                } else {
                    evalHtml = `<button class="action-btn btn-ghost" disabled>미응시</button>`;
                }
            } else {
                evalHtml = `<button class="action-btn btn-primary" onclick="viewResult(this, \${t.courseId}, \${t.period})">결과확인</button>`;
            }

            const tr = `
                <tr class="hw-row">
                    <td>\${no}</td>
                    <td style="text-align:left; padding-left:10px;">\${t.title}</td>
                    <td>\${t.period}차</td>
                    <td>\${t.date || '--'}</td>
                    <td>\${t.score === null ? '--' : t.score + '점'}</td>
                    <td>\${evalHtml}</td>
                </tr>`;
            $tbody.append(tr);
        });
    }

    function viewResult(btn, courseId, period) {
        $(".hw-row").removeClass("active");
        $(btn).closest("tr").addClass("active");

        fetch(`/stu/exams/result/\${courseId}/\${period}/data`)
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById("resultContainer");
                const metaContainer = document.getElementById("resultMeta");

                if (!data.questions || data.questions.length === 0) {
                    container.innerHTML = "<p>문제 데이터가 없습니다.</p>";
                    return;
                }

                metaContainer.innerHTML = `
                    <div class="result-meta">
                        <div><b>📌 시험명:</b> \${data.title}</div>
                        <div><b>🕒 차시정보:</b> \${period}차시</div>
                        <div><b>💯 취득점수:</b> <span style="color:#d63031; font-weight:bold;">\${data.totalScore}점</span></div>
                    </div>`;

                container.innerHTML = "";
                data.questions.forEach(q => {
                    const div = document.createElement("div");
                    div.className = "result-question";
                    div.innerHTML = `<div><strong>Q\${q.questionNo}.</strong> \${q.content}</div>`;

                    for (let i = 1; i <= 4; i++) {
                        const opt = document.createElement("div");
                        opt.className = "opt";
                        const isSelected = q.studentAnswer === i;
                        const isCorrect = q.correctAnswer === i;

                        if (isSelected) opt.classList.add("selected");
                        if (isCorrect) opt.classList.add("correct");

                        opt.innerHTML = `
                            <span style="display:inline-block;width:22px;">
                                \${isSelected ? "✔" : String.fromCharCode(64 + i)}
                            </span>
                            \${q["option" + i]}
                        `;
                        div.appendChild(opt);
                    }

                    if (q.studentAnswer !== q.correctAnswer) {
                        const ex = document.createElement("div");
                        ex.className = "explain";
                        ex.innerHTML = `<strong>💡 정답 해설:</strong> \${q.comment || "등록된 해설이 없습니다."}`;
                        div.appendChild(ex);
                    }
                    container.appendChild(div);
                });
                $("#rightArea").fadeIn(200);
            })
            .catch(err => alert("결과를 불러오는 중 오류가 발생했습니다."));
    }

    function onStartExam(courseId, period) {
        $.get("/stu/exams/check", { courseId, period }, function (res) {
            if (res.available) window.location.href = `/stu/exams/detail/\${courseId}/\${period}`;
            else alert(res.message || "응시 가능한 시간이 아닙니다.");
        });
    }

    function renderPagination(total) {
        const totalPage = Math.max(1, Math.ceil(total / pageSize));
        const $cont = $("#pagination").empty();
        for (let i = 1; i <= totalPage; i++) {
            $cont.append(`<button class="btn \${i === currentPage ? 'btn-primary' : ''}" onclick="movePage(\${i})" style="margin:0 2px;">\${i}</button>`);
        }
    }
    function movePage(p) { currentPage = p; loadTestList(); }
</script>
</body>
</html>