<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 4:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>시험 응시 (수강생)</title>
    <link rel="stylesheet" href="/css/exam/style.css" />
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        .notice-area {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        .notice-area textarea {
            width: 68%;
            height: 90px;
            resize: none;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .timer-box {
            width: 28%;
            text-align: center;
        }
        .timer-box .timer {
            color: #1166ff;
            font-weight: 700;
            font-size: 20px;
            margin-top: 14px;
        }
        .question-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-top: 10px;
        }
        .question {
            border: 1px solid #ddd;
            border-radius: 6px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .q-top {
            padding: 14px;
            background: #fafafa;
            flex: 3;
        } /* 지문 */
        .q-bottom {
            padding: 12px;
            flex: 7;
            display: flex;
            flex-direction: column;
            gap: 8px;
        } /* 보기 */
        .option {
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #eee;
            cursor: pointer;
        }
        .option.selected {
            background: #e6f0ff;
            border-color: #3a7df5;
        }
        .submit-box {
            margin-top: 16px;
            text-align: center;
        }
    </style>
</head>
<body>
<form id="myForm" action="javascript:void(0);"  method="get">

    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">
    <!-- 모달 배경 -->
    <div id="mask"></div>

    <div id="wrap_area">

        <h2 class="hidden">컨텐츠 영역</h2>
        <div id="container">
            <ul>
                <li class="lnb">
                    <!-- lnb 영역 --> <jsp:include
                        page="/WEB-INF/view/common/lnbMenu.jsp"/> <!--// lnb 영역 -->
                </li>
                <li class="contents">
                    <!-- contents -->
                    <h3 class="hidden">contents 영역</h3> <!-- content -->

                    <div class="content" style="margin-bottom:20px;">

                        <p class="Location">
                            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">학습 관리</span>
                            <span class="btn_nav bold">시험 목록</span>
                            <span class="btn_nav bold">시험 응시</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 응시</span>

                            </p>
                            <h2 id="testTitle" style="margin-bottom: 20px;"></h2>

                            <div class="container">

                                <div class="notice-area">
                                        <textarea readonly>
 * 시험 유의사항

 1. 부정행위 적발 시 퇴실 및 성적 무효
 2. 시험 시간은 45분입니다.
 3. 창을 닫으면 자동 제출되지 않습니다.
                                      </textarea>
                                    <div class="timer-box">
                                        <div>남은시간</div>
                                        <div id="timer" class="timer">45:00:00</div>
                                    </div>
                                </div>

                                <div id="questionContainer" class="question-list"></div>

                                <div class="submit-box">
                                    <button id="submitBtn" type="button" class="btn submit">제출하기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>

    </div>




</form>
<script>

    // 현재 페이지에 history 스택을 하나 더 쌓아서 popstate 상태로 미리 진입시키는 것
    history.replaceState({ exam: true }, "", location.href);
    history.pushState(null, "", location.href);

    // 공통 플래그 (페이지 이탈 여부 체크용 상태값, 정상 제출은 제외)
    let submitting = false;   // 정상 제출 여부
    let ignorePop = false;    // popstate 처리 중 여부 (beforeunload 와 구분하기 위한 플래그)


    // 현재 URL 예: /stu/exams/detail/1/1
    const path = window.location.pathname.split("/");

    // path = ["", "stu", "exams", "detail", "1", "1"]
    const courseId = path[4];
    const period = path[5];

    console.log("courseId:", courseId, "period:", period);
    if (!courseId || !period) {
        alert("시험 정보를 불러올 수 없습니다.");
        location.href = "/stu/exams";
    }

    let questions =  [];
    let answers = {};

    // 새로고침 및 뒤로가기로 인한 초기화 방지, 로컬에 시험정보 임시저장
    const STORAGE_KEY_ANS = `exam_${courseId}_${period}_answers`;
    const STORAGE_KEY_TIMER = `exam_${courseId}_${period}_timer`;


    //------------------------------------
    // ⏱ 타이머 설정 (기본 45분 → 2700초)
    //------------------------------------
    let remaining = 10 * 60; // 초
    const savedTimer = localStorage.getItem(STORAGE_KEY_TIMER); // 로컬스토리지에 시간정보 임시저장

    if (savedTimer !== null) {
        remaining = Number(savedTimer);
    }
    const timerEl = document.getElementById("timer");

    function formatTime(sec) {
        if (sec < 0) sec = 0;
        const hh = String(Math.floor(sec / 3600)).padStart(2, "0");
        const mm = String(Math.floor((sec % 3600) / 60)).padStart(2, "0");
        const ss = String(sec % 60).padStart(2, "0");
        return `${hh}:${mm}:${ss}`;
    }

    function tick() {
        timerEl.textContent = formatTime(remaining);

        localStorage.setItem(STORAGE_KEY_TIMER, remaining);

        if (remaining <= 0) {
            clearInterval(timerId);

            // 시간종료로 인한 자동 제출: submitting 모드 ON
            submitting = true;

            // 학생의 답안을 배열 형태로 정리
            questions.forEach(q => {
                answers[q.question_no] = answers[q.question_no] || null;
            });

            const answerList = questions.map((q) => ({
                questionNo: q.question_no,
                studentAnswer: answers[q.question_no] || null,
            }));

            const payload = {
                loginId: "",
                courseId: courseId,
                period: period,
                answers: answerList,
            };

            // 자동 제출
            $.ajax({
                url: "/stu/exams/submit",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(payload),
                success: function (res) {
                    // 시간만료 & 제출성공 시 로컬정보 삭제
                    localStorage.removeItem(STORAGE_KEY_TIMER);
                    localStorage.removeItem(STORAGE_KEY_ANS);
                    alert("시험 시간이 종료되어 자동 제출되었습니다. \n이전화면으로 이동합니다.");
                    window.location.href = "/stu/exams";
                },
                error: function () {
                    alert("시간 종료 자동 제출 중 오류가 발생했습니다. \n이전화면으로 이동합니다.");
                    window.location.href = "/stu/exams";
                }
            });

            return;
        }
        remaining--;
    }

    const timerId = setInterval(tick, 1000);
    tick();

    //------------------------------------
    //  기존 답안 복구
    //------------------------------------
    const savedAnswers = localStorage.getItem(STORAGE_KEY_ANS);
    if (savedAnswers) {
        answers = JSON.parse(savedAnswers);
    }


    // ====== 시험 문제 불러오기 AJAX ======
    $.ajax({
        url: `/stu/exams/test/${courseId}/${period}`,
        type: "GET", //보안 정책에 따라 POST 방식으로 바꿔도 무방

        success: function (res) {

            questions = res.list.map(q => ({
                testTitle: q.testTitle,       // 시험명
                question_no: q.questionNo,        // 문항 번호
                content: q.content,          // 문제 텍스트
                option1: q.option1,            // 보기
                option2: q.option2,
                option3: q.option3,
                option4: q.option4
            }));

            if (!questions || questions.length === 0) {
                alert("시험문제를 찾을 수 없습니다.");
                console.log(courseId,period);
                return;
            }

            document.getElementById("testTitle").innerHTML = `
            <div style="margin-bottom:8px;">
                <strong>시험:</strong> ${questions[0].testTitle}
                &nbsp;&nbsp;
            </div>
        `;

            // 문제 표시
            renderQuestions(questions);
        },
        error: function () {
            alert("시험문제 조회 중 오류가 발생했습니다.");
        }
    });


    // ========== 문제 렌더링 함수 ==========
    function renderQuestions(questions) {

        const container = document.getElementById("questionContainer");
        container.innerHTML = "";   // 초기화

        questions.forEach((q) => {

            const box = document.createElement("div");
            box.className = "question";

            // 문제 영역
            const top = document.createElement("div");
            top.className = "q-top";
            top.innerHTML = `<strong>문제 ${q.question_no}. </strong> ${q.content}`;
            console.log(`${q.question_no}`);
            // 보기 영역
            const bottom = document.createElement("div");
            bottom.className = "q-bottom";

            // 보기는 option1~4 를 동적으로 생성
            for (let i = 1; i <= 4; i++) {
                const opt = document.createElement("label");
                opt.className = "option";

                const radio = document.createElement("input");
                radio.type = "radio";
                radio.name = `q${q.question_no}`;
                radio.value = i;
                radio.style.display = "none"; // 라디오 숨김


                // ✔ 로컬 답안 복구
                if (answers[q.question_no] == i) {
                    radio.checked = true;
                    opt.classList.add("selected");
                    const mark = document.createElement("span");
                    mark.className = "checkmark";
                    mark.style.marginRight = "8px";
                    mark.textContent = "✔";
                    opt.prepend(mark);
                }

                // 선택 이벤트
                radio.addEventListener("change", () => {

                    answers[q.question_no] = i;

                    bottom.querySelectorAll(".option").forEach((s) => {
                        s.classList.remove("selected");
                        s.querySelector(".checkmark")?.remove();
                    });

                    opt.classList.add("selected");

                    const mark = document.createElement("span");
                    mark.className = "checkmark";
                    mark.style.marginRight = "8px";
                    mark.textContent = "✔";

                    opt.prepend(mark);
                });

                opt.appendChild(radio);

                // 텍스트
                const text = document.createElement("span");
                text.textContent = `${String.fromCharCode(64 + i)}. ${q["option" + i]}`;
                opt.appendChild(text);

                bottom.appendChild(opt);
            }

            box.appendChild(top);
            box.appendChild(bottom);
            container.appendChild(box);
        });
    }


    // 시험제출
    document.getElementById("submitBtn").addEventListener("click", () => {
        if (!confirm("제출하시겠습니까?")) return;


        submitting = true; // 수동 제출 시 beforeunload 방지

        // 학생의 답안을 배열로 정리
        questions.forEach(q => {
            answers[q.question_no] = answers[q.question_no] || null;
        });

        const answerList = questions.map((q) => ({
            questionNo: q.question_no,
            studentAnswer: answers[q.question_no] || null,
        }));

        // build payload
        const payload = {
            loginId: "",
            courseId: courseId,
            period: period,
            answers: answerList,
        };

        // 실제: fetch('/stu/exams/submit', {method:'POST', body: JSON.stringify(payload)})
        $.ajax({
            url: "/stu/exams/submit",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(payload),
            success: function (res) {
                if (res.result === "OK") {
                    alert("시험이 정상적으로 제출되었습니다.");

                    // localStorage 초기화
                    localStorage.removeItem(STORAGE_KEY_ANS);
                    localStorage.removeItem(STORAGE_KEY_TIMER);

                } else {
                    console.log("전송할 데이터:", JSON.stringify(payload));

                    alert("제출 중 오류가 발생했습니다.");
                }
            },
            error: function () {
                alert("서버 통신 오류가 발생했습니다.");
            }
        });

        // 이동
        alert("제출 완료되었습니다. 이전 페이지로 이동합니다.");
        location.href = "/stu/exams";
    });


    // 정상제출 제외 페이지 이탈 감지시 경고 함수
    window.addEventListener("beforeunload", (e) => {
        if (submitting) return; // 정상 제출(true) 중이면 무시
        // 답안 저장
        localStorage.setItem(STORAGE_KEY_ANS, JSON.stringify(answers));

        // 대부분의 최신 브라우저에서는 returnValue 필요 없음.
        e.preventDefault();
        e.returnValue ="";
    });


    // popstate (뒤로가기 감지)
    window.addEventListener("popstate", () => {

        if(submitting) return;

        alert("페이지 이탈이 감지되었습니다. 현재 응시정보는 시험종료시까지 임시 저장됩니다.");
        history.pushState(null, "", location.href); //페이지 이동 방지 효과

    });
</script>
</body>
</html>
