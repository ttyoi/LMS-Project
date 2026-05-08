<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Job Korea</title>

    <style>
        /* 전체 박스 */
        .write-container {
            border: 1px solid #ccc;
            padding: 30px;
            width: 900px;
            margin: 0 auto;
            border-radius: 4px;
        }

        /* 제목 */
        .write-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 25px;
        }

        .write-info {
            float: right;
            font-size: 12px;
            color: #666;
            margin-top: -25px;
        }

        /* 카테고리 */
        .category-group {
            margin-bottom: 10px;
        }

        .category-btn {
            padding: 6px 15px;
            margin-right: 5px;
            border: 1px solid #bbb;
            background-color: #f5f5f5;
            cursor: pointer;
            border-radius: 4px;
            font-size: 13px;
        }

        .category-btn:hover {
            background-color: #e8e8e8;
        }

        .category-btn.active {
            background-color: #dcdcdc;
            font-weight: bold;
        }

        /* 입력 row */
        .input-title {
            width: 700px;
            height: 34px;
            padding: 6px 8px;
        }

        .textarea-content {
            width: 700px;
            height: 300px;
            padding: 10px;
            resize: none;
        }

        .form-row {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .form-row label {
            width: 80px;
            font-weight: bold;
            margin-right: 10px;
            margin-top: 5px;
        }

        .form-row input[type="text"] {
            width: 700px;
            height: 28px;
            padding: 4px;
        }

        .form-row textarea {
            width: 700px;
            /*height: 200px;*/
            padding: 8px;
            resize: none;
        }

        /* 첨부파일 */
        .file-input {
            width: 600px;
            height: 34px;
            padding: 8px;
            border: 1px solid #d5d5d5;
            box-sizing: border-box;
        }

        .btn-search-file {
            padding: 6px 15px;
            margin-left: 5px;
            border: 1px solid #aaa;
            background-color: #eee;
            cursor: pointer;
        }

        /* 등록/취소 버튼 */
        .btn-area {
            text-align: center;
            margin-top: 25px;
        }

        .btn {
            padding: 7px 20px;
            border: 1px solid #999;
            background-color: #f5f5f5;
            cursor: pointer;
            margin: 0 5px;
        }

        .btn:hover {
            background-color: #e8e8e8;
        }

        /* 모든 input/textarea 공통 스타일 */
        .form-row input[type="text"],
        .form-row textarea {
            width: 700px;
            padding: 8px;
            border: 1px solid #d5d5d5;   /* 통일된 회색 테두리 */
            box-sizing: border-box;
            border-radius: 2px;
        }

        /* textarea 스타일 우선 적용 */
        .form-row textarea.textarea-content {
            width: 700px !important;
            height: 200px;
            padding: 10px;
        }
    </style>

    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
</head>
<body>
<form id="writeForm" method="post" enctype="multipart/form-data"
      action="<c:choose>
                <c:when test='${mode eq "edit"}'>${rolePath}/update</c:when>
                <c:otherwise>${rolePath}/save</c:otherwise>
              </c:choose>">

    <!-- 수정 모드일 때 postId 전달 -->
    <c:if test="${mode eq 'edit'}">
        <input type="hidden" name="postId" value="${detail.postId}">
    </c:if>

    <!-- 선택된 카테고리 저장 -->
    <input type="hidden" id="categoryCode" name="categoryCode"
           value="${mode eq 'edit' ? detail.categoryCode : ''}"/>


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
                            <span class="btn_nav bold">메인</span> <a href="${rolePath}/write" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>Q&A 게시판</span>
                            </p>
                        </div>

                        <%-- 글쓰기 영역 전체 박스 --%>
                        <div class="write-container">
                            <div class="write-title">
                                <c:choose>
                                    <c:when test="${mode eq 'edit'}">게시글 수정</c:when>
                                    <c:otherwise>게시글 작성</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="write-info">※ 답변 전인 게시글만 수정 가능합니다.</div>

                            <%-- 카테고리 선택 --%>
                            <div class="form-row">
                                <label>카테고리</label>

                                <div class="category-group">
                                    <c:forEach var="cat" items="${categories}">
                                        <button type="button"
                                                class="category-btn
                                                <c:if test='${mode eq "edit" and detail.categoryCode == cat.categoryCode}'>active</c:if>"
                                                data-code="${cat.categoryCode}">
                                                ${cat.categoryName}
                                        </button>
                                    </c:forEach>
<%--                                    <button type="button" class="category-btn">강의내용</button>--%>
<%--                                    <button type="button" class="category-btn">광광광련</button>--%>
<%--                                    <button type="button" class="category-btn">시스템오류</button>--%>
<%--                                    <button type="button" class="category-btn">계정/로그인</button>--%>
<%--                                    <button type="button" class="category-btn">기타</button>--%>
                                </div>
                            </div>

                            <%-- 제목 --%>
                            <div class="form-row">
                                <label>제목</label>
                                <input type="text" class="input-title" name="title" value="${mode eq 'edit' ? detail.title : ''}"/>
                            </div>

                            <%-- 내용 --%>
                            <div class="form-row">
                                <label>내용</label>
                                <textarea class="textarea-content" name="content">${mode eq 'edit' ? detail.content : ''}</textarea>
                            </div>

                            <%-- 첨부파일 --%>
                            <div class="form-row">
                                <label>첨부파일</label>
                                <!-- 실제 파일 업로드 input -->
                                <input type="file" id="uploadFile" name="uploadFile" style="display:none"/>

                                <!-- 화면 표시용 -->
                                <input type="text" class="file-input" id="fileName"
                                       value="${mode eq 'edit' ? detail.filOriName : ''}" readonly/>

                                <button type="button" class="btn-search-file"
                                        onclick="document.getElementById('uploadFile').click();">
                                    찾기
                                </button>
                            </div>

                            <%-- 등록/취소 --%>
                            <div class="btn-area">
                                <c:choose>
                                    <c:when test="${mode eq 'edit'}">
                                        <button type="submit" class="btn">수정 저장</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn">등록</button>
                                    </c:otherwise>
                                </c:choose>

                                <button type="button" class="btn" onclick="history.back();">취소</button>
                            </div>
                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>

</form>

<script>
    $(document).on("click", ".category-btn", function () {
        $(".category-btn").removeClass("active");
        $(this).addClass("active");

        $("#categoryCode").val($(this).data("code"));
    });

    // 파일 선택시, 파일명 표시
    document.getElementById("uploadFile").addEventListener("change", function () {
        if (this.files.length > 0) {
            document.getElementById("fileName").value = this.files[0].name;
        }
    });
</script>

</body>
</html>