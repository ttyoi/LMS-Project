<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>과제제출</title>

    <link rel="stylesheet" href="/css/homework/homeworkForm.css" />
    <%--    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>--%>

</head>
<body>

<form id="myForm" action="/inst/homeworkInsert" method="post" enctype="multipart/form-data">

    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">

    <div id="wrap_area">

        <div id="container">
            <ul>
                <%--                <li class="lnb">--%>
                <%--                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>--%>
                <%--                </li>--%>
                <li class="contents">
                    <div class="content" style="margin-bottom:20px;">

                        <p class="conTitle"><span>과제등록페이지</span></p>

                        <!-- 상단 정보 -->
                        <table class="hw-table">

                            <!-- 여기 추가 -->
                            <tr>
                                <th>과정 선택</th>
                                <td colspan="5">
                                    <select name="course_id" class="hw-input">
                                        <c:forEach var="c" items="${courseList}">
                                            <option value="${c.course_id}">${c.title}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <th>과정(과제)명</th>
                                <td colspan="5">
                                    <input type="text" class="hw-input" name="title" placeholder="과정명을 입력하세요">
                                </td>
                            </tr>

                            <tr>

                            <tr>
                                <th>시작일자</th>
                                <td><input type="date" class="hw-date" name="start_date"></td>

                                <th>마감일자</th>
                                <td><input type="date" class="hw-date" name="end_date"></td>

                                <th>강사명</th>
                                <td><input type="text" class="hw-input" name="teacher" value="${sessionScope.userNm}" readonly></td>
                            </tr>

                        </table>

                        <!-- 안내문 -->
                        <div class="hw-guide-box">
                            <p>※ 첨부파일 다운로드 후 작성하여 pdf로 제출하시기 바랍니다.</p>
                            <p>※ 제출 기간 종료 후 수정 불가.</p>
                            <p>※ 미제출 시 0점 처리됩니다.</p>
                        </div>

                        <!-- 과제 내용 -->
                        <textarea class="hw-textarea" name="content"></textarea>

                        <!-- 파일업로드 영역 -->
                        <div class="hw-file-box">
                            <div id="filePreview"></div>


                            <!-- label → input 분리 -->
                            <input type="file" id="homeworkFile" name="files" multiple>

                        </div>

                        <!-- 버튼 -->
                        <div class="hw-btn-box">
                            <button type="button" id="btnSubmit" class="btn-submit">등록</button>
                            <button type="button" class="btn-cancel" onclick="location.href='/inst/assignments'">취소</button>
                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>

</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    let allowSubmit = false;

    $(document).ready(function () {

        $("#btnSubmit").click(function () {

            if (!$("select[name='course_id']").val()) {
                alert("과정을 선택하세요");
                return;
            }

            if (!$("input[name='title']").val().trim()) {
                alert("과제명을 입력하세요");
                return;
            }

            if (!$("input[name='start_date']").val()) {
                alert("시작일을 입력하세요");
                return;
            }

            if (!$("input[name='end_date']").val()) {
                alert("마감일을 입력하세요");
                return;
            }

            if (!$("textarea[name='content']").val().trim()) {
                alert("과제 내용을 입력하세요");
                return;
            }

            // ✅ 검증 통과 → 정상 submit
            $("#myForm").submit();
        });


        // 파일 선택 시 미리보기 출력
        $("#homeworkFile").on("change", function () {
            renderFileList();
        });
    });

    // 파일 미리보기 표시
    function renderFileList() {

        const fileInput = document.getElementById("homeworkFile");
        const files = fileInput.files;

        const preview = $("#filePreview");
        preview.empty();

        [...files].forEach((file, idx) => {

            // 🔥 JSP EL 충돌 방지 → \${} 로 Escape 처리
            preview.append(`
                <div class="file-item">
                    <span class="file-name">\${file.name}</span>
                    <button type="button" class="file-remove-btn" onclick="removeSelectedFile(${idx})">X</button>
                </div>
            `);
        });
    }

    // 선택한 파일 삭제
    function removeSelectedFile(index) {

        const fileInput = document.getElementById("homeworkFile");
        const dt = new DataTransfer();

        [...fileInput.files]
            .filter((file, i) => i !== index)
            .forEach(f => dt.items.add(f));

        fileInput.files = dt.files;

        renderFileList();
    }

</script>

</body>
</html>
