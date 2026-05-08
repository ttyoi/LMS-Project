<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 5:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>시험 수정하기 (관리자)</title>
    <link rel="stylesheet" href="/css/exam/style.css" />
    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <style>
        /* 번호 */
        .table-fixed td:nth-child(1) input {
            width: 30px;
            text-align: center;
        }

        /* 정답 */
        .table-fixed td:nth-child(7) input {
            width: 30px;
            text-align: center;
        }

        /* 배점 */
        .table-fixed td:nth-child(8) input {
            width: 40px;
            text-align: center;
        }

        .table-fixed td:nth-child(9) textarea {
            min-width: 80px;
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
                            <span class="btn_nav bold">시험 관리</span>
                            <span class="btn_nav bold">시험 문제</span>
                            <span class="btn_nav bold">시험 수정</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 문제 수정</span>

                            </p>
                            <div class="container">

                                <div class="detail-header">
                                    <div>강의 명 : JAVA</div>
                                    <div>시험 명 : Java 기본</div>
                                    <div>차시 : 1</div>
                                </div>

                                <div class="table-wrapper">
                                    <table class="table-fixed">
                                        <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>지문</th>
                                            <th>보기1</th>
                                            <th>보기2</th>
                                            <th>보기3</th>
                                            <th>보기4</th>
                                            <th>정답</th>
                                            <th>배점</th>
                                            <th>해설</th>
                                        </tr>
                                        </thead>
                                        <tbody id="editBody"></tbody>
                                    </table>
                                </div>

                                <div class="nav-btn-box">
                                    <button
                                            class="back-btn"
                                            onclick="location.href=`/admin/test-exam/detail/${courseId}/${period}`"
                                    >
                                        이전으로
                                    </button>
                                    <button type="button" class="save-btn" id="saveBtn">저장하기</button>
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

    // 현재 URL 예: /admin/test-exams/edit/1/1
    const path = window.location.pathname.split("/");

    // path = ["", "admin", "test-exams", "edit", "1", "1"]
    const courseId = path[4];
    const period = path[5];

    // textarea 자동 높이 조절
    function autoResize(el) {
        el.style.height = "auto";
        el.style.height = el.scrollHeight + "px";
    }

    document.addEventListener("DOMContentLoaded", () => {
        const tbody = document.getElementById("editBody");
        const saveBtn = document.getElementById("saveBtn");

        // 데이터 로드
        fetch(`/admin/test-exam/detail/${courseId}/${period}/data`)
            .then(res => res.json())
            .then(details => {
                details.forEach(q => {
                    const tr = document.createElement("tr");
                    tr.innerHTML = `
                        <td><input type="text" value="${q.questionNo}" disabled></td>

                        <td>
                            <textarea rows="3" oninput="autoResizeTextarea(this)">${q.content}</textarea>
                        </td>

                        <td><textarea rows="2" oninput="autoResizeTextarea(this)">${q.option1}</textarea></td>
                        <td><textarea rows="2" oninput="autoResizeTextarea(this)">${q.option2}</textarea></td>
                        <td><textarea rows="2" oninput="autoResizeTextarea(this)">${q.option3}</textarea></td>
                        <td><textarea rows="2" oninput="autoResizeTextarea(this)">${q.option4}</textarea></td>

                        <td><input type="number" value="${q.answer}"></td>
                        <td><input type="number" value="${q.score}"></td>

                        <td>
                            <textarea rows="4" oninput="autoResizeTextarea(this)">${q.comment || ""}</textarea>
                        </td>
                `;
                    tbody.appendChild(tr);
                });

                // textarea 초기 높이 세팅
                document.querySelectorAll(".auto-textarea").forEach(t => {
                    autoResize(t);
                    t.addEventListener("input", () => autoResize(t));
                });
            });

        // 저장
        saveBtn.addEventListener("click", () => {
            const confirmSave = confirm("정말 저장하시겠습니까?");
            if (!confirmSave) return;

            const updatedList = [];
            tbody.querySelectorAll("tr").forEach(tr => {
                const tds = tr.querySelectorAll("td");
                updatedList.push({
                    courseId: Number(courseId),
                    period: Number(period),
                    questionNo: Number(tds[0].querySelector("input").value),
                    content: tds[1].querySelector("textarea").value,
                    option1: tds[2].querySelector("textarea").value,
                    option2: tds[3].querySelector("textarea").value,
                    option3: tds[4].querySelector("textarea").value,
                    option4: tds[5].querySelector("textarea").value,
                    answer: Number(tds[6].querySelector("input").value),
                    score: Number(tds[7].querySelector("input").value),
                    comment: tds[8].querySelector("textarea").value
                });
            });

            fetch("/admin/test-exam/edit", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(updatedList)
            })
                .then(res => res.json())
                .then(res => {
                    if (res.status === "success") {
                        alert("변경사항이 저장되었습니다.");
                        location.href = `/admin/test-exam/detail/${courseId}/${period}`;
                    } else {
                        alert("❌ 오류: " + res.message);
                    }
                })
                .catch(err => console.error(err));
        });
    });

    //
    textarea.addEventListener("change", () => {
        textarea.style.background = "#fffbe6";
    });
</script>
</body>
</html>
