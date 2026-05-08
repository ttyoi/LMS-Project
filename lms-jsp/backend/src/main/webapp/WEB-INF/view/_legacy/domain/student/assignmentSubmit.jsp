<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>과제 제출</title>

    <link rel="stylesheet" href="/css/homework/homeworkForm.css" />
</head>
<body>

<form id="submitForm"
      action="/stu/submitHomework"
      method="post"
      enctype="multipart/form-data">

    <!-- 과제 PK -->
    <input type="hidden" name="homework_code" value="${detail.homework_code}">

    <!-- 수정 모드 -->
    <c:if test="${mode eq 'edit'}">
        <input type="hidden" name="submission_code" value="${detail.submission_code}">
    </c:if>

    <div id="wrap_area">
        <div id="container">
            <ul>
                <li class="contents">
                    <div class="content">

                        <p class="conTitle"><span>과제 제출</span></p>

                        <!-- 상단 정보 -->
                        <table class="hw-table">
                            <tr>
                                <th>과목명</th>
                                <td colspan="5">
                                    <input type="text" value="${detail.course_name}" readonly>
                                </td>
                            </tr>

                            <tr>
                                <th>과제명</th>
                                <td colspan="5">
                                    <input type="text" value="${detail.homework_title}" readonly>
                                </td>
                            </tr>

                            <tr>
                                <th>시작일</th>
                                <td><input type="date" value="${detail.start_date}" readonly></td>

                                <th>마감일</th>
                                <td><input type="date" value="${detail.end_date}" readonly></td>

                                <th>강사명</th>
                                <td><input type="text" value="${detail.teacher_name}" readonly></td>
                            </tr>
                        </table>

                        <!-- 안내 -->
                        <div class="hw-guide-box">
                            <p>※ 첨부파일 다운로드 후 작성하여 pdf로 제출하세요.</p>
                            <p>※ 마감일 이후 제출 불가</p>
                        </div>

                        <!-- 과제 내용 -->
                        <textarea readonly rows="8" style="width:100%;">${detail.content}</textarea>

                        <!-- ================= 파일 영역 ================= -->
                        <div class="hw-file-box">

                            <!-- 기존 제출 파일 -->
                            <c:if test="${mode eq 'edit' && detail.file_name != null}">
                                <div class="file-item">
                                    현재 제출 파일 : ${detail.file_name}
                                </div>
                            </c:if>

                            <!-- 파일 미리보기 -->
                            <div id="filePreview" style="margin-top:10px;"></div>

                            <!-- 🔥 핵심: label + input 연결 -->
                            <label for="uploadFile" class="btn-file-add">파일 선택</label>
                            <input type="file"
                                   id="uploadFile"
                                   name="file"
                                   style="display:none;">
                        </div>

                        <!-- 버튼 -->
                        <div class="hw-btn-box">
                            <button type="button" id="btnSubmit" class="btn-submit">
                                <c:choose>
                                    <c:when test="${mode eq 'edit'}">수정하기</c:when>
                                    <c:otherwise>제출하기</c:otherwise>
                                </c:choose>
                            </button>

                            <button type="button"
                                    class="btn-cancel"
                                    onclick="location.href='/stu/assignments'">
                                취소
                            </button>
                        </div>

                    </div>
                </li>
            </ul>
        </div>
    </div>

</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(function () {

        $("#btnSubmit").on("click", function () {
            $("#submitForm").submit();
        });

        $("#uploadFile").on("change", function () {
            const preview = $("#filePreview");
            preview.empty();

            const files = this.files;
            if (files && files.length > 0) {
                const fileName = files[0].name;

                preview.append(
                    '<div class="file-item">' +
                    '선택한 파일 : ' + fileName +
                    '</div>'
                );
            }
        });
    });
</script>


</body>
</html>
