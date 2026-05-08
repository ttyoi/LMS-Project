<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>과제 상세</title>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        * { box-sizing: border-box; font-family: "Noto Sans KR", sans-serif; }

        .hw-container {
            width: 100%;
            background: #fff;
            border: 1px solid #ccc;
            padding: 20px 25px;
        }

        .hw-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        .hw-table th, .hw-table td {
            border: 1px solid #bcbcbc;
            padding: 10px;
            font-size: 14px;
        }
        .hw-table th {
            width: 120px;
            background: #f4f4f4;
            text-align: center;
        }

        .hw-input {
            width: 100%;
            border: none;
            background: transparent;
            font-size: 14px;
        }
        .hw-input.editable {
            border: 1px solid #ccc;
            background: #fff;
        }

        .hw-textarea {
            width: 100%;
            height: 160px;
            border: 1px solid #ccc;
            padding: 12px;
            resize: none;
            font-size: 14px;
            background: #fafafa;
        }
        .hw-textarea.editable {
            background: #fff;
        }

        .hw-guide {
            border: 1px solid #ccc;
            background: #f5f5f5;
            padding: 12px 15px;
            margin-bottom: 15px;
            line-height: 1.6;
        }

        /* 🔥 파일 영역 */
        .hw-file-box {
            border: 1px solid #ccc;
            padding: 10px 12px;
            margin-top: 10px;
            display: flex;
        }
        .file-area {
            width: 100%;
            display: flex;
            justify-content: space-between; /* 좌우 분리 */
            align-items: center;
        }
        .file-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .file-del {
            cursor: pointer;
            color: #666;
            font-weight: bold;
            display: none;
        }

        .hw-btn-area {
            margin-top: 25px;
            text-align: right;
        }
        .hw-btn {
            padding: 8px 22px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 5px;
            font-size: 14px;
        }
        .btn-edit { background: #4b7bec; color: white; }
        .btn-save { background: #20bf6b; color: white; }
        .btn-cancel { background: #aaa; color: white; }
        .btn-delete { background: #eb3b5a; color: white; }

        input[type="file"] {
            display: none;
        }
        .file-btn {
            padding: 6px 14px;
            border: 1px solid #bbb;
            background: #f7f7f7;
            cursor: pointer;
            font-size: 13px;
        }
    </style>
</head>

<body>

<div id="wrap_area">
    <div id="container">
        <ul>
            <li class="contents">
                <div class="content">

                    <p class="Location">
                        <span class="btn_nav bold">과제 상세</span>
                    </p>

                    <div class="hw-container">

                        <form id="hwForm"
                              action="/inst/homeworkUpdate"
                              method="post"
                              enctype="multipart/form-data">

                            <input type="hidden" name="homework_code" value="${detail.homework_code}"/>

                            <!-- 기본 정보 -->
                            <table class="hw-table">
                                <tr>
                                    <th>과제명</th>
                                    <td colspan="5">
                                        <input type="text" class="hw-input"
                                               name="title"
                                               value="${detail.title}" disabled>
                                    </td>
                                </tr>
                                <tr>
                                    <th>시작일</th>
                                    <td><input type="date" class="hw-input" name="start_date"
                                               value="${detail.start_date}" disabled></td>
                                    <th>마감일</th>
                                    <td><input type="date" class="hw-input" name="end_date"
                                               value="${detail.end_date}" disabled></td>
                                    <th>강사명</th>
                                    <td><input type="text" class="hw-input"
                                               value="${sessionScope.userNm}" readonly></td>
                                </tr>
                            </table>

                            <!-- 안내 -->
                            <div class="hw-guide">
                                ※ 제출 기간 종료 후 수정 불가<br>
                                ※ 미제출 시 0점 처리됩니다.
                            </div>

                            <!-- 내용 -->
                            <textarea class="hw-textarea"
                                      name="content" disabled>${detail.content}</textarea>

                            <!-- 🔥 파일 영역 (단일) -->
                            <div class="hw-file-box">
                                <div class="file-area">

                                    <!-- 왼쪽 : 기존 파일 -->
                                    <div class="file-left">
                                        <c:if test="${not empty detail.fileList}">
                                            <c:forEach var="file" items="${detail.fileList}">
                                                📄 ${file.name}
                                                <span class="file-del"
                                                      onclick="deleteFile(${file.file_id}, ${detail.homework_code})">X</span>
                                            </c:forEach>
                                        </c:if>

                                        <c:if test="${empty detail.fileList}">
                                            등록된 파일이 없습니다.
                                        </c:if>
                                    </div>

                                    <!-- 오른쪽 : 파일 선택 -->
                                    <div>
                                        <label for="homeworkFile" class="file-btn">파일 선택</label>
                                        <input type="file" name="files" id="homeworkFile">
                                    </div>
                                </div>
                            </div>

                            <!-- 버튼 -->
                            <div class="hw-btn-area" id="viewMode">
                                <button type="button" class="hw-btn btn-edit" onclick="enableEdit()">수정</button>
                                <button type="button" class="hw-btn btn-cancel" onclick="history.back()">취소</button>
                            </div>

                            <div class="hw-btn-area" id="editMode" style="display:none;">
                                <button type="submit" class="hw-btn btn-save">수정하기</button>
                                <button type="button" class="hw-btn btn-delete"
                                        onclick="deleteHomework(${detail.homework_code})">삭제</button>
                            </div>

                        </form>

                    </div>

                </div>
            </li>
        </ul>
    </div>
</div>

<script>
    function enableEdit() {
        document.querySelectorAll(".hw-input, .hw-textarea").forEach(el => {
            el.disabled = false;
            el.classList.add("editable");
        });

        document.querySelectorAll(".file-del").forEach(el => el.style.display = "inline");

        document.getElementById("viewMode").style.display = "none";
        document.getElementById("editMode").style.display = "block";
    }

    function deleteHomework(code) {
        if (!confirm("정말 삭제하시겠습니까?")) return;
        location.href = "/inst/homeworkDelete?homework_code=" + code;
    }

    function deleteFile(fileId, homeworkCode) {
        if (!confirm("파일을 삭제하시겠습니까?")) return;

        $.post("/inst/deleteFile",
            { fileId: fileId, homeworkCode: homeworkCode },
            function (res) {
                if (res > 0) {
                    alert("파일 삭제 완료");
                    location.reload();
                } else {
                    alert("파일 삭제 실패");
                }
            }
        );
    }
</script>

</body>
</html>
