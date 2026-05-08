<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta charset="UTF-8"/>
    <title>시험 문제 관리</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <link rel="stylesheet" href="${CTX_PATH}/css/exam/testExamList.css"/>
    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>
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
                        <jsp:param name="menu2" value="시험 문제"/>
                    </jsp:include>

                    <p class="conTitle"><span>시험 문제 관리</span></p>

                    <div class="container">
                        <!-- 검색 영역 -->
                        <div class="search-box">
                            <div class="search-row">
                                <select class="form-select" id="searchKey" style="width: 120px;">
                                    <option value="all">-- 전체 --</option>
                                    <option value="teacher">강사명</option>
                                    <option value="title">강의명</option>
                                </select>

                                <input type="text" class="form-input" id="searchKeyword"
                                       style="flex: 1; padding-left: 10px;" placeholder="검색어를 입력하세요">

                                <div class="search-buttons">
                                    <button class="btn btn-primary" id="btnSearch">🔍 검색</button>
                                </div>
                            </div>
                        </div>

                        <!-- 2단 분할 레이아웃 -->
                        <div class="two-column-layout">
                            <!-- 좌측: 강의 리스트 -->
                            <div class="course-list-section">
                                <div class="table-container">
                                    <table class="table-fixed">
                                        <thead>
                                        <tr>
                                            <th style="width: 15%;">강의번호</th>
                                            <th>강의명</th>
                                            <th style="width: 12%;">차시</th>
                                            <th style="width: 20%;">강사명</th>
                                            <th style="width: 15%;">상태</th>
                                        </tr>
                                        </thead>
                                        <tbody id="testListBody"></tbody>
                                    </table>
                                </div>

                                <div class="bottom-container">
                                    <div class="paging_area" id="pagination"></div>
                                </div>
                            </div>

                            <!-- 우측: 문제 목록 패널 -->
                            <div class="question-panel-wrapper">
                                <div class="question-panel" id="questionPanel">
                                    <!-- 헤더 -->
                                    <div class="panel-header">
                                        <div class="course-info">
                                            <h3 id="selectedCourseTitle">강의를 선택하세요</h3>
                                            <span id="selectedCourseInfo"></span>
                                        </div>
                                        <div class="panel-actions">
                                            <button class="btn-edit" id="btnEdit" onclick="enterEditMode()">수정</button>
                                            <button class="btn-save" id="btnSave" onclick="saveQuestions()"
                                                    style="display: none;">저장
                                            </button>
                                            <button type="button" class="btn-cancel" id="btnCancel" onclick="exitEditMode()" style="display: none;">취소</button>
                                            <button class="btn-close-panel" onclick="closeQuestionPanel()">✕</button>
                                        </div>
                                    </div>

                                    <!-- 문제 목록 (스크롤 영역) -->
                                    <div class="panel-body" id="panelBody">
                                        <div class="empty-state">
                                            <p>👈 좌측에서 강의를 선택하면<br>시험 문제가 표시됩니다</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        let currentPage = 1;
                        const pageSize = 10;
                        let totalCount = 0;
                        let fullData = [];
                        let currentCourse = null;
                        let questionsData = [];
                        let isEditMode = false;

                        // 데이터 로드
                        function loadTestList() {
                            const searchKey = document.getElementById("searchKey").value;
                            const searchKeyword = document.getElementById("searchKeyword").value.trim();

                            $.ajax({
                                url: "/admin/test-exam/list",
                                type: "GET",
                                data: {
                                    currentPage: currentPage,
                                    pageSize: pageSize,
                                    filteredType: searchKey === "all" ? null : searchKey,
                                    keyword: searchKeyword || null
                                },
                                success: function (res) {
                                    fullData = res.list || [];
                                    totalCount = res.totalCount || 0;
                                    renderTable();
                                    renderPagination();
                                },
                                error: function () {
                                    alert("데이터를 불러오는 중 오류가 발생했습니다.");
                                }
                            });
                        }

                        // 테이블 렌더링
                        function renderTable() {
                            const tbody = document.getElementById("testListBody");
                            tbody.innerHTML = "";

                            if (fullData.length === 0) {
                                tbody.innerHTML = `<tr><td colspan="5" style="text-align:center; padding:30px;">조회된 시험이 없습니다.</td></tr>`;
                                return;
                            }

                            fullData.forEach((item) => {
                                const statusText = (item.status == 1 || item.status == '1') ?
                                    '<span style="color:#28a745; font-weight:bold;">열림</span>' :
                                    '<span style="color:#dc3545; font-weight:bold;">닫힘</span>';

                                const tr = document.createElement("tr");
                                tr.style.cursor = "pointer";
                                tr.innerHTML = `
                                    <td>\${item.courseId}</td>
                                    <td>\${item.title}</td>
                                    <td>\${item.period}차</td>
                                    <td>\${item.professorName}</td>
                                    <td>\${statusText}</td>
                                `;
                                tr.addEventListener("click", () => loadQuestions(item));
                                tbody.appendChild(tr);
                            });
                        }

                        // 강의 클릭 → 문제 목록 로드
                        function loadQuestions(course) {
                            currentCourse = course;

                            exitEditMode();

                            document.getElementById('btnEdit').style.display = 'inline-block';
                            document.getElementById('btnSave').style.display = 'none';
                            document.getElementById('btnCancel').style.display = 'none';

                            // 레이아웃 활성화
                            document.querySelector('.two-column-layout').classList.add('split-view');
                            document.querySelector('.question-panel').classList.add('active');

                            // 헤더 정보 업데이트
                            document.getElementById('selectedCourseTitle').textContent = course.title;
                            document.getElementById('selectedCourseInfo').textContent =
                                `\${course.period}차시 | 강사: \${course.professorName}`;

                            // 문제 데이터 로드
                            $.ajax({
                                url: `/admin/test-exam/detail/\${course.courseId}/\${course.period}/data`,
                                type: "GET",
                                success: function (questions) {
                                    questionsData = questions || [];
                                    renderQuestions();
                                },
                                error: function () {
                                    alert("문제를 불러오는 중 오류가 발생했습니다.");
                                }
                            });
                        }

                        // 문제 목록 렌더링 (읽기 모드)
                        function renderQuestions() {
                            const panelBody = document.getElementById('panelBody');

                            if (questionsData.length === 0) {
                                panelBody.innerHTML = `
                                    <div class="empty-state">
                                        <p>등록된 문제가 없습니다.</p>
                                    </div>
                                `;
                                return;
                            }

                            let html = '<div class="questions-container">';

                            questionsData.forEach((q, index) => {
                                html += `
                                    <div class="question-item" data-question-id="\${q.questionNo}">
                                        <div class="question-header">
                                            <span class="question-number">\${index + 1}번 문제</span>
                                            <span class="question-score">\${q.score || 10}점</span>
                                        </div>
                                        <div class="question-content">\${q.content || '문제 내용 없음'}</div>
                                        <div class="question-choices">\${renderChoices(q, index, false)}</div>
                                    </div>
                                `;
                            });

                            html += '</div>';
                            panelBody.innerHTML = html;
                        }

                        // 선택지 렌더링 함수 수정
                        function renderChoices(question, questionIndex, editMode) {
                            // 서버 필드명 매칭 및 null 처리
                            const choices = [
                                question.option1,
                                question.option2,
                                question.option3,
                                question.option4
                            ];

                            let html = '<div class="choices-list">';
                            const choiceLabels = ['①', '②', '③', '④'];

                            choices.forEach((choice, idx) => {
                                const choiceNum = idx + 1;

                                // 1. 실제 내용이 있는지 확인 (공백 제외)
                                const hasContent = choice && choice.trim().length > 0;

                                // 2. 내용이 있고 + 정답 번호와 일치할 때만 정답으로 인정
                                const isCorrect = hasContent && (choiceNum == (question.answer || 1));
                                const correctClass = isCorrect ? 'correct-answer' : '';

                                if (editMode) {
                                    html += `
                                        <div class="choice-item edit-mode">
                                            <input type="radio" name="correctAnswer_\${questionIndex}" value="\${choiceNum}" \${isCorrect ? 'checked' : ''}>
                                            <span class="choice-label">\${choiceLabels[idx]}</span>
                                            <input type="text" class="choice-input" value="\${choice || ''}" placeholder="내용 없음">
                                        </div>
                                    `;
                                                        } else {
                                    html += `
                                        <div class="choice-item \${correctClass}">
                                            <span class="choice-label">\${choiceLabels[idx]}</span>
                                            <span class="choice-text \${!hasContent ? 'empty-text' : ''}">
                                                \${hasContent ? choice : '내용 없음'}
                                            </span>
                                                \${isCorrect ? '<span class="correct-badge">✓ 정답</span>' : ''}
                                        </div>
                                    `;
                                }
                            });

                            html += '</div>';
                            return html;
                        }

                        // 수정 모드 진입
                        function enterEditMode() {
                            if (questionsData.length === 0) {
                                alert("수정할 문제가 없습니다.");
                                return;
                            }

                            isEditMode = true;

                            // 버튼 전환
                            document.getElementById('btnEdit').style.display = 'none';
                            document.getElementById('btnCancel').style.display = 'inline-block';
                            document.getElementById('btnSave').style.display = 'inline-block';

                            // 수정 가능한 UI로 전환
                            const panelBody = document.getElementById('panelBody');
                            let html = '<div class="questions-container edit-mode">';

                            questionsData.forEach((q, index) => {
                                // 공백 문제를 방지하기 위해 trim 처리
                                const safeContent = (q.content || '').trim();

                                html += `
                                    <div class="question-item" data-question-id="\${q.questionNo}">
                                        <div class="question-header">
                                            <span class="question-number">\${index + 1}번 문제</span>

                                            <div class="score-group">
                                                <input type="number" class="score-input" data-question-index="\${index}"
                                                value="\${q.score || 10}" min="1" max="100">
                                                <span class="score-unit">점</span>
                                            </div>
                                        </div>
                                        <div class="question-content-edit">
                                            <textarea class="content-textarea" data-question-index="\${index}"
                                                rows="3">\${safeContent}</textarea>
                                        </div>
                                        <div class="question-choices">
                                            \${renderChoices(q, index, true)}
                                        </div>
                                    </div>
                                    `;
                            });

                            html += '</div>';
                            panelBody.innerHTML = html;
                        }

                        // 저장
                        // 저장
                        function saveQuestions() {
                            if (!confirm("문제를 저장하시겠습니까?")) return;

                            // 수정된 데이터 수집
                            const updatedQuestions = [];
                            const questionItems = document.querySelectorAll('.question-item');

                            try {
                                questionItems.forEach((item, index) => {
                                    // data-question-id 속성에서 번호를 가져옵니다.
                                    const questionNo = item.getAttribute('data-question-id');
                                    const content = item.querySelector('.content-textarea').value.trim();
                                    const score = parseInt(item.querySelector('.score-input').value) || 10;

                                    // 선택지(Input)들을 가져옵니다.
                                    const choiceInputs = item.querySelectorAll('.choice-input');

                                    // 정답(Radio) 값을 가져옵니다.
                                    const correctRadio = item.querySelector('input[name="correctAnswer_' + index + '"]:checked');
                                    const answerVal = correctRadio ? correctRadio.value : "1";

                                    // 로그에서 확인된 필드명(option1~4, answer)으로 정확히 매핑
                                    updatedQuestions.push({
                                        courseId: currentCourse.courseId,
                                        period: currentCourse.period,
                                        questionNo: parseInt(questionNo),
                                        content: content,
                                        option1: choiceInputs[0] ? choiceInputs[0].value : '',
                                        option2: choiceInputs[1] ? choiceInputs[1].value : '',
                                        option3: choiceInputs[2] ? choiceInputs[2].value : '',
                                        option4: choiceInputs[3] ? choiceInputs[3].value : '',
                                        answer: answerVal,
                                        score: score
                                    });
                                });

                                console.log("전송 데이터 확인:", updatedQuestions);

                                // 서버 전송
                                $.ajax({
                                    url: '/admin/test-exam/edit',
                                    type: "POST",
                                    contentType: "application/json",
                                    data: JSON.stringify(updatedQuestions),
                                    success: function (res) {
                                        if (res.status === "success") {
                                            alert("저장되었습니다.");
                                            // 수정 모드 종료 및 새로고침
                                            exitEditMode();
                                            loadQuestions(currentCourse);
                                        } else {
                                            alert("저장에 실패했습니다: " + (res.message || "알 수 없는 오류"));
                                        }
                                    },
                                    error: function (xhr) {
                                        alert("서버 오류가 발생했습니다.");
                                        console.error(xhr);
                                    }
                                });
                            } catch (e) {
                                console.error("데이터 수집 중 에러 발생:", e);
                                alert("데이터를 처리하는 중 오류가 발생했습니다. 콘솔을 확인하세요.");
                            }
                        }

                        // 수정 모드 종료
                        function exitEditMode() {
                            isEditMode = false;
                            document.getElementById('btnEdit').style.display = 'inline-block';
                            document.getElementById('btnCancel').style.display = 'none';
                            document.getElementById('btnSave').style.display = 'none';
                            renderQuestions();
                        }

                        // 패널 닫기
                        function closeQuestionPanel() {
                            document.querySelector('.two-column-layout').classList.remove('split-view');
                            document.querySelector('.question-panel').classList.remove('active');

                            // 수정 모드였다면 종료
                            if (isEditMode) {
                                exitEditMode();
                            }

                            currentCourse = null;
                            questionsData = [];
                        }

                        // 페이지 이동
                        function movePage(page) {
                            currentPage = page;
                            loadTestList();
                        }

                        // 페이징 렌더링
                        function renderPagination() {
                            const container = document.getElementById("pagination");
                            if (!container) return;

                            if (totalCount === 0) {
                                container.innerHTML = "";
                                return;
                            }

                            const totalPage = Math.ceil(totalCount / pageSize);
                            const pageBlock = 5;
                            const startPage = Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
                            let endPage = startPage + pageBlock - 1;

                            if (endPage > totalPage) endPage = totalPage;

                            let html = "";

                            if (startPage > 1) {
                                html += `<a onclick="movePage(\${startPage - 1})">&#9664; 이전</a>`;
                            }

                            for (let i = startPage; i <= endPage; i++) {
                                if (i === currentPage) {
                                    html += `<span class="active">\${i}</span>`;
                                } else {
                                    html += `<a onclick="movePage(\${i})">\${i}</a>`;
                                }
                            }

                            if (endPage < totalPage) {
                                html += `<a onclick="movePage(\${endPage + 1})">다음 &#9654;</a>`;
                            }

                            container.innerHTML = html;
                        }

                        // 이벤트 리스너
                        document.getElementById("btnSearch").addEventListener("click", () => {
                            currentPage = 1;
                            loadTestList();
                        });

                        document.getElementById("searchKeyword").addEventListener("keypress", (e) => {
                            if (e.key === "Enter") document.getElementById("btnSearch").click();
                        });

                        window.onload = loadTestList;
                    </script>
                </div>
            </li>
        </ul>
    </div>
</div>
</body>
</html>
