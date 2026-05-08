<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 4:36
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
    <title>시험 결과 (수강생)</title>
    <link rel="stylesheet" href="/css/exam/style.css" />
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        .result-question {
            border: 1px solid #eee;
            padding: 10px;
            margin-bottom: 12px;
            border-radius: 6px;
        }
        .opt {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #f0f0f0;
            margin-bottom: 6px;
        }
        .opt.selected {
            background: #e6f0ff;
            border-color: #3a7df5;
        }
        .opt.correct {
            color: #ff0000;
            font-weight: 700;
        } /* 정답 빨간색 */
        .explain {
            margin-top: 8px;
            padding: 8px;
            border-top: 1px dashed #ddd;
            color: #333;
            background: #fafafa;
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
                            <span class="btn_nav bold">시험 결과</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 결과 상세보기</span>

                            </p>
                            <div class="container">

                                <div id="resultMeta"></div>

                                <div id="resultContainer"></div>

                                <div style="text-align: center; margin-top: 14px">
                                    <button class="btn" onclick="location.href='/stu/exams'">
                                        목록으로
                                    </button>
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

    // 시험문제 및 학생답안 불러오기
    document.addEventListener("DOMContentLoaded", function() {

        const container = document.getElementById("resultContainer");
        const metaContainer = document.getElementById("resultMeta");

        // 현재 URL 예: /stu/exams/detail/1/1
        const path = window.location.pathname.split("/");

        // 현재 요청 URL localhost/stu/exams/result/1/1
        const courseId = path[4];
        const period = path[5];


        // 백엔드 요청
        fetch(`/stu/exams/result/${courseId}/${period}/data`)
            .then(res => res.json())
            .then(data => {

                const questions = data.questions;
                const totalScore = data.totalScore;
                const title = data.title;
                if (!questions || questions.length === 0) {
                    container.innerHTML = "<p>문제 데이터가 없습니다.</p>";
                    return;
                }

                // 메타 정보
                metaContainer.innerHTML = `
                <div class="result-meta">
                    <div class="result-meta-item">
                        <strong>시험:</strong> ${title}
                    </div>
                    <div class="result-meta-item">
                        <strong>차시:</strong> ${period}
                    </div>
                    <div class="result-meta-item">
                        <strong>점수:</strong> ${totalScore}
                    </div>
                </div>
            `;

                questions.forEach(q => {
                    const div = document.createElement("div");
                    div.className = "result-question";

                    // 문제 텍스트
                    div.innerHTML = `
                    <div><strong>문제 ${q.questionNo}.</strong> ${q.content}</div>
                `;

                    // 선택지 표시
                    for (let i = 1; i <= 4; i++) {
                        const opt = document.createElement("div");
                        opt.className = "opt";

                        const isSelected = q.studentAnswer === i;
                        const isCorrect = q.correctAnswer === i;

                        if (isSelected) opt.classList.add("selected");
                        if (isCorrect) opt.classList.add("correct");

                        opt.innerHTML = `
                        <span style="display:inline-block;width:22px;">
                            ${isSelected ? "✔" : String.fromCharCode(64 + i)}
                        </span>
                        ${q["option" + i]}
                    `;

                        div.appendChild(opt);
                    }

                    // 해설 표시 (오답일 경우만)
                    if (q.studentAnswer !== q.correctAnswer) {
                        const ex = document.createElement("div");
                        ex.className = "explain";
                        ex.textContent = q.comment || "해설이 없습니다.";
                        div.appendChild(ex);
                    }

                    container.appendChild(div);
                });

            })
            .catch(err => {
                console.error(err);
                alert("시험 결과를 불러오는 중 오류가 발생했습니다.");
                location.href = "/stu/exams";
            });
    });
</script>

</body>
</html>
