
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 모달팝업 -->
<div id="noticeModal" class="noticeModalType" style="width: 800px; display:none;">
    <dl>
        <dt style="height: 50px;">
            <h1 style="font-size: 25px;">공지사항 상세</h1>
        </dt>
        <dd class="content">
            <table class="row">
                <tbody>
                <tr>
                    <th scope="row" width="25%">글번호</th>
                    <td id="nt_id" width="25%"></td>
                    <th scope="row" width="25%">등록일</th>
                    <td id="nt_regdate" width="25%"></td>
                </tr>
                <tr>
                    <th scope="row" width="25%">작성자</th>
                    <td id="nt_user" width="25%"></td>
                    <th scope="row" width="25%">조회수</th>
                    <td id="nt_view_count" width="25%"></td>
                </tr>
                <tr >
                    <th scope="row">제목</th>
                    <td id="nt_title" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="row">내용</th>
                    <td colspan="3">
                        <div id="nt_content_view" style="min-height: 150px;"></div>
                        <%-- 수정 --%>
                        <textarea id="nt_content_edit" style="min-height: 150px; display:none; width:100%;"></textarea>
                    </td>
                </tr>
                </tbody>
            </table>

            <%-- 버튼 --%>
            <div class="notice-btn-area">
                <div class="left">
                    <c:if test="${sessionScope.userType eq 'A'}">
                        <a class="btnType blue" href="" id="btnEditNotice"><span>수정</span></a>
                        <a class="btnRed" href="" id="btnDeleteNotice"><span>삭제</span></a>
                    </c:if>
                </div>
                <div class="right">
                    <a href="" class="btnType gray" id="btnCloseNotice" name="btn"><span>닫기</span></a>
                </div>
            </div>
        </dd>
    </dl>
    <a href="" class="closePop"><span class="hidden">닫기</span></a>
</div>
<style>
    .btnRed {
        display:inline-block;
        padding-right:10px;
        min-width:80px;
        height:31px;
        line-height:31px;
        font-family: '나눔바른고딕',NanumBarunGothic;
        font-size:15px;
        border: #8B0913;
        background-color:#FF0000;
        color:#fff;
        text-align: center !important;
        font-weight:400;
    }
</style>