
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="newNoticeModal" class="noticeModalType" style="width: 800px; height: auto; display:none;">
    <dl>
        <dt style="height: 50px;">
            <h1 style="font-size: 25px;">공지사항 작성</h1>
        </dt>
        <dd class="content">
            <table class="row">
                <tbody>
                <tr >
                    <th scope="row">제목</th>
                    <td><input type="text" id="new_title" style="width: 100%; height: 25px;"></td>
                </tr>
                <tr>
                    <th scope="row">내용</th>
                    <td><textarea id="new_content" style="width:100%; height:150px;"></textarea></td>
                </tr>
                </tbody>
            </table>

            <%-- 버튼 --%>
            <div class="notice-btn-area">
                <div class="left"></div>
                <div class="right">
                    <a href="" class="btnType blue" id="btnSaveNotice"><span>등록</span></a>
                    <a href="" class="btnType gray" id="btnCloseNewNotice"><span>취소</span></a>
                </div>
            </div>
        </dd>
    </dl>
    <a href="" class="closePop"><span class="hidden">닫기</span></a>
</div>