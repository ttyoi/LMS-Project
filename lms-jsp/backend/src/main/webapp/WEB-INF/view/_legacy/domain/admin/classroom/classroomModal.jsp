<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title></title>

</head>
<body>




<!-- 수정 모달: 상세보기와 동일 구조 -->
<div id="modalEdit" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>

        <h3>강의실 수정</h3>

        <!-- 강의실 명, 인원수 (고정) -->
        <div class="detail-row">
            <div class="detail-label">강의실 명</div>
            <div class="detail-value" id="editName">-</div>
            <div class="detail-label">인원수</div>
            <div class="detail-value" id="editCount">-</div>
        </div>

        <hr style="margin: 20px 0; border: none; border-top: 1px solid #e0e0e0;">

        <!-- 시간대 섹션 -->
        <div style="margin-bottom: 30px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">

            <!-- 1번째 시간대 -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 10px;">
                <div class="detail-label">09:00 ~ 11:50</div>

                <div class="detail-label">강의명</div>
                <input type="text" class="detail-input-gray" id="editCourseTitle1" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">기간</div>
                <input type="text" class="detail-input-gray" id="editDate1" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">강사명</div>
                <input type="text" class="detail-input-gray" id="editProfessor1" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">보조강사명</div>
                <input type="text" class="detail-input-gray" id="editSubProfessor1" style="width: 100%; box-sizing: border-box;">
            </div>

            <!-- 2번째 시간대 -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 10px;">
                <div class="detail-label">13:00 ~ 15:50</div>

                <div class="detail-label">강의명</div>
                <input type="text" class="detail-input-gray" id="editCourseTitle2" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">기간</div>
                <input type="text" class="detail-input-gray" id="editDate2" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">강사명</div>
                <input type="text" class="detail-input-gray" id="editProfessor2" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">보조강사명</div>
                <input type="text" class="detail-input-gray" id="editSubProfessor2" style="width: 100%; box-sizing: border-box;">
            </div>

            <!-- 3번째 시간대 -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 10px;">
                <div class="detail-label">18:00 ~ 21:00</div>

                <div class="detail-label">강의명</div>
                <input type="text" class="detail-input-gray" id="editCourseTitle3" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">기간</div>
                <input type="text" class="detail-input-gray" id="editDate3" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">강사명</div>
                <input type="text" class="detail-input-gray" id="editProfessor3" style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">보조강사명</div>
                <input type="text" class="detail-input-gray" id="editSubProfessor3" style="width: 100%; box-sizing: border-box;">
            </div>

        </div>

        <!-- 버튼 -->
        <div style="display: flex; gap: 10px; justify-content: center;">
            <button type="button" id="btnEditSave" class="btn-edit-save">저장</button>
            <button type="button" class="btn-edit-cancel" onclick="document.getElementById('modalEdit').style.display='none'">취소</button>
        </div>
    </div>
</div>



    <!-- 모달: 삭제 -->
    <div id="modalDelete" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <input type="hidden" id="deleteName">
            <p>정말 삭제하시겠습니까?</p>
            <button type="button" id="btnDeleteConfirm" class="btn-delete">삭제</button>
        </div>
    </div>

    <!-- 모달: 추가 -->
    <div id="modalAdd" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>강의실 추가</h3>

            <div class="modal-input-group">
                <label>강의실명</label>
                <input type="text" id="addName" placeholder="예: 501">
            </div>

            <div class="modal-input-group">
                <label>인원수</label>
                <input type="number" id="addCount" value="40" readonly>
            </div>

            <div class="modal-buttons">
                <button type="button" class="btn-add-save" id="btnAddSave" >등록</button>
                <button type="button" class="btn-add-cancel" onclick="document.getElementById('modalAdd').style.display='none'">취소</button>
            </div>
        </div>
    </div>


<!-- 모달: 상세보기 -->
<div id="modalDetail" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>

        <h3>강의실 상세정보</h3>

        <!-- 강의실 명, 인원수 (고정) -->
        <div class="detail-row">
            <div class="detail-label">강의실 명</div>
            <div class="detail-value" id="detailName">-</div>
            <div class="detail-label">인원수</div>
            <div class="detail-value" id="detailCount">-</div>
        </div>

        <hr style="margin: 20px 0; border: none; border-top: 1px solid #e0e0e0;">

        <!-- 09:00 ~ 11:50 섹션 -->
        <div style="margin-bottom: 30px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">

            <!-- 1번째 시간대 -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 10px;">
                <div class="detail-label">09:00 ~ 11:50</div>

                <div class="detail-label">강의명</div>
                <input type="text" class="detail-input-gray" id="detailCourseTitle1" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">기간</div>
                <input type="text" class="detail-input-gray" id="detailDate1" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">강사명</div>
                <input type="text" class="detail-input-gray" id="detailProfessor1" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">보조강사명</div>
                <input type="text" class="detail-input-gray" id="detailSubProfessor1" disabled style="width: 100%; box-sizing: border-box;">
            </div>

            <!-- 2번째 시간대 -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 10px;">
                <div class="detail-label">13:00 ~ 15:50</div>

                <div class="detail-label">강의명</div>
                <input type="text" class="detail-input-gray" id="detailCourseTitle2" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">기간</div>
                <input type="text" class="detail-input-gray" id="detailDate2" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">강사명</div>
                <input type="text" class="detail-input-gray" id="detailProfessor2" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">보조강사명</div>
                <input type="text" class="detail-input-gray" id="detailSubProfessor2" disabled style="width: 100%; box-sizing: border-box;">
            </div>

            <!-- 3번째 시간대 -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 10px;">
                <div class="detail-label">18:00 ~ 21:00</div>

                <div class="detail-label">강의명</div>
                <input type="text" class="detail-input-gray" id="detailCourseTitle3" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">기간</div>
                <input type="text" class="detail-input-gray" id="detailDate3" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">강사명</div>
                <input type="text" class="detail-input-gray" id="detailProfessor3" disabled style="width: 100%; box-sizing: border-box;">

                <div class="detail-label">보조강사명</div>
                <input type="text" class="detail-input-gray" id="detailSubProfessor3" disabled style="width: 100%; box-sizing: border-box;">
            </div>
        </div>
    </div>
</div>



</body>
</html>
