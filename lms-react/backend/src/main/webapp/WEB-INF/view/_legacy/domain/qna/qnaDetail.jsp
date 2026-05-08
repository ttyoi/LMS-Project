<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Job Korea</title>

    <!-- URL에서 파라미터 제거 : 공통코드로 인한 에러 해결 -->
    <script type="text/javascript">
        (function() {
            var href = window.location.href;

            // hash(#) 분리
            var hashIndex = href.indexOf('#');
            var urlNoHash = (hashIndex > -1) ? href.substring(0, hashIndex) : href;
            var hashPart  = (hashIndex > -1) ? href.substring(hashIndex)     : "";

            // ? 기준 URL 분리
            var qIndex = urlNoHash.indexOf('?');
            if (qIndex > -1) {
                var base = urlNoHash.substring(0, qIndex);

                // ⭐ 파라미터 제거된 URL로 즉시 변경
                history.replaceState(null, "", base + hashPart);
            }
        })();
    </script>

    <!-- 공통 include (global_pub.js 포함) -->
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        .qna-box { border:1px solid #ddd; padding:20px; border-radius:5px; }
        .qna-header { background:#f2f2f2; padding:15px; border-radius:4px; margin-bottom:0px; }
        .qna-title { font-size:20px; font-weight:bold; }
        .qna-info { background: #fafafa; padding: 10px; border-radius: 4px; margin-bottom: 10px; color: #3c3b3b; font-size: 13px; }
        .qna-content { padding: 10px;  margin-bottom:10px; }
        .badge-wait { background:#ffb3b3; color:#000; margin-left: 10px; padding:3px 8px; border-radius:5px; font-size:12px; }
        .badge-done { background:#b3cffc; color:#000; margin-left: 10px; padding:3px 8px; border-radius:5px; font-size:12px; }
        .qna-category {font-size: 16px; font-weight: bold; color: #666; margin-right: 8px; }
        .qna-file { text-align: right; margin-bottom: 20px; font-size: 14px; }
        .comment-box { border:1px solid #ddd; padding:15px; border-radius:5px; margin-bottom:10px; }
        .comment-write { background:#f8f8f8; padding:15px; border-radius:5px; box-sizing:border-box; }
        .comment-write textarea { width:100%; height:90px; border:1px solid #ccc; border-radius:4px; padding:10px; box-sizing:border-box; }
        .comment-meta { font-size:12px; color:#666; margin-bottom:5px; }
        .comment-content { margin-bottom:10px; }
        .comment-btns { text-align:right; }
        .scroll-area { height:550px; overflow-y:scroll; padding-right:10px; }
    </style>
</head>

<body>

<input type="hidden" id="loginId" value="${loginId}">
<input type="hidden" id="userType" value="${userType}">
<input type="hidden" id="postId" value="${detail.postId}">

<div id="wrap_area">
    <div id="container">
        <ul>
            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>

            <li class="contents">
                <div class="content" style="margin-bottom:20px;">

                    <p class="Location">
                        <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                        <span class="btn_nav bold">메인</span>
                        <a href="${rolePath}/detail?postId=${detail.postId}" class="btn_set refresh">새로고침</a>
                    </p>

                    <div class="scroll-area">

                        <div class="qna-box">
                            <div class="qna-header">
                                <span class="qna-category">[${detail.categoryName}]</span>
                                <span class="qna-title">${detail.title}</span>

                                <c:choose>
                                    <c:when test="${detail.answerStatus == 'N'}">
                                        <span class="badge-wait">미답변</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-done">답변완료</span>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${loginId == detail.loginID or userType == 'A'}">
                                    <span style="float: right">
                                        <button type="button" onclick="location.href='${rolePath}/edit?postId=${detail.postId}'">수정</button>
                                        <button type="button" onclick="deletePost(${detail.postId})">삭제</button>
                                    </span>
                                </c:if>
                            </div>

                            <div class="qna-info">
                                작성자 : ${detail.writerName} &nbsp; | &nbsp;
                                작성일 : <fmt:formatDate value="${detail.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </div>

                            <div class="qna-content">${detail.content}</div>

                            <div class="qna-file">
                                📎 첨부파일 :
                                <c:choose>
                                    <c:when test="${not empty detail.filOriName}">
                                        <a href="${rolePath}/download?postId=${detail.postId}">${detail.filOriName}</a>
                                    </c:when>
                                    <c:otherwise>없음</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <br><br>

                        <h4>&nbsp;댓글</h4>
                        <div id="commentListArea">
                            <%-- 댓글 HTML이 AJAX로 여기 붙을 예정--%>
                        </div>

                        <div class="comment-write">
                            <textarea id="commentText" placeholder="댓글을 입력하세요."></textarea>
                            <div style="text-align:right; margin-top:10px;">
                                <button type="button" id="btnSaveComment">등록</button>
                            </div>
                        </div>
                    </div>

                </div>
            </li>
        </ul>
    </div>
</div>

<!-- 댓글 AJAX -->
<script>
    $(document).ready(function () {
        loadCommentList();

        /**댓글 등록 버튼*/
        $("#btnSaveComment").on("click",function () {
            let postId = $("#postId").val();
            let content = $("#commentText").val().trim();

            if(content ===""){ alert("댓글 내용을 입력하세요"); return;}

            $.ajax({
                url:"${rolePath}/comment/save",
                type: "POST",
                data: {
                    postId: postId,
                    content: content
                },
                success : function (res) {
                    if(res.result==="SUCCESS"){
                        $("#commentText").val(""); // 입력창 비우기
                        loadCommentList(); // 목록 다시 불러오기
                    } else { alert("댓글 등록에 실패하였습니다");}
                }
            });
        });
    });

    /**댓글 목록 불러오기*/
    function loadCommentList() {
        let postId = $("#postId").val();
        let loginId = $("#loginId").val();
        let userType = $("#userType").val();

        $.ajax({
            url: "${rolePath}/comment/list",
            type: "GET",
            data: { postId: postId },
            success: function (res) {

                if (res.result !== "SUCCESS") {
                    alert("댓글 조회 중 오류 발생");
                    return;
                }

                let html = "";

                res.data.forEach(function (c) {
                    let teacher = (c.isTeacher === "Y") ? "(강사)" : "";
                    html +=
                        '<div class="comment-box">' +
                            '<div class="comment-meta">작성자 : ' + c.writerName + ' ' + teacher +
                            '&nbsp; | &nbsp; 작성일 : ' + formatDate(c.createdAt) + '</div>' +
                            '<div class="comment-content" id="content_' + c.commentId + '">' + c.content + '</div>';
                    if (loginId === c.loginID || userType === 'A') {

                        html +=
                            '<div class="comment-btns" id="btns_' + c.commentId + '">' +
                            '<button onclick="editComment(' + c.commentId + ')">수정</button>' +
                            '<button onclick="deleteComment(' + c.commentId + ')">삭제</button>' +
                            '</div>';
                    }

                    html += '</div>';
                });

                $("#commentListArea").html(html);
            }
        });
    }

    /**날짜 포맷*/
    function formatDate(dateStr) {
        if (!dateStr) return "";
        const d = new Date(dateStr);
        return d.getFullYear() + "-" + ("0" + (d.getMonth()+1)).slice(-2) + "-" +
            ("0" + d.getDate()).slice(-2) + " " + ("0" + d.getHours()).slice(-2) + ":" +
            ("0" + d.getMinutes()).slice(-2);
    }

    /** 댓글 삭제 */
    function deleteComment(commentId) {

        if (!confirm("댓글을 삭제하시겠습니까?")) return;

        $.ajax({
            url: "${rolePath}/comment/delete",
            type: "POST",
            data: { commentId: commentId },
            success: function (res) {
                if (res.result === "SUCCESS") {
                    alert("댓글이 삭제되었습니다.");
                    loadCommentList(); // 목록 새로고침
                } else {
                    alert("댓글 삭제에 실패했습니다.");
                }
            },
            error: function () {
                alert("서버 오류가 발생했습니다.");
            }
        });
    }

    /** 댓글 수정모드*/
    function editComment(commentId) {
        // 기존 버튼 숨기기
        $("#btns_" + commentId).hide();

        let contentDiv = $("#content_" + commentId);
        let originalText = contentDiv.text().trim();

        // textarea + 저장 버튼으로 변경
        let editHtml =
            '<textarea id="editContent_' + commentId + '" style="width:100%; height:70px;">' + originalText + '</textarea>' +
            '<div style="text-align:right; margin-top:5px;">' +
            '   <button onclick="updateComment(' + commentId + ')">수정 완료</button>' +
            '   <button onclick="cancelEdit(' + commentId + ')">취소</button>' +
            '</div>';

        contentDiv.html(editHtml);
    }

    /** 수정 취소시, 원래 화면 복원 */
    function cancelEdit(commentId) {
        loadCommentList(); // 다시 목록 로드
    }

    /**댓글 수정 완료*/
    function updateComment(commentId) {
        let newContent = $("#editContent_" + commentId).val().trim();

        if (newContent === "") {
            alert("내용을 입력하세요.");
            return;
        }

        $.ajax({
            url: "${rolePath}/comment/update",
            type: "POST",
            data: {
                commentId: commentId,
                content: newContent
            },
            success: function (res) {
                if (res.result === "SUCCESS") {
                    alert("댓글이 수정되었습니다.");
                    loadCommentList();
                } else {
                    alert("댓글 수정에 실패했습니다.");
                }
            }
        });
    }
</script>

<%--게시글 삭제--%>
<script>
    function deletePost(postId) {
        if (confirm("정말 삭제하시겠습니까?"))
            location.href = "${rolePath}/delete?postId=" + postId;
    }
</script>

</body>
</html>
