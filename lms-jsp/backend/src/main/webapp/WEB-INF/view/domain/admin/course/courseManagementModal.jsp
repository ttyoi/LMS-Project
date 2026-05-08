<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 5.
  Time: 오후 1:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Title</title>
</head>
<body>


<!-- 모달 배경 -->
<div id="courseModal" class="modal-overlay" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h2>강의 상세</h2>
            <button class="modal-close" onclick="closeCourseModal()">&times;</button>
        </div>

        <div class="modal-body">
            <!-- 강의명 -->
            <div class="form-row">
                <div class="form-group">
                    <label>강의명</label>
                    <input type="text" id="modal_title" readonly />
                </div>
                <div class="form-group">
                    <label>시험상태</label>
                    <input type="text" id="modal_test_status" readonly />
                </div>
            </div>

            <!-- 강사명 -->
            <div class="form-row">
                <div class="form-group">
                    <label>강사명</label>
                    <input type="text" id="modal_professor" readonly />
                </div>
                <div class="form-group">
                    <label>보조 강사명</label>
                    <input type="text" id="modal_sub_prof" readonly />
                </div>
            </div>

            <!-- 수강인원 -->
            <div class="form-row">
                <div class="form-group">
                    <label>수강인원</label>
                    <input type="text" id="modal_people_limit" value="40" readonly />
                </div>
                <div class="form-group">
                    <label>강의실 명</label>
                    <input type="text" id="modal_class_id" readonly />
                </div>
            </div>

            <!-- 시작일자 -->
            <div class="form-row">
                <div class="form-group">
                    <label>시작일자</label>
                    <input type="text" id="modal_start_date" readonly />
                </div>
                <div class="form-group">
                    <label>시간</label>
                    <input type="text" id="modal_time" readonly />
                </div>
            </div>

            <!-- 강의단계 -->
            <div class="form-row">
                <div class="form-group" style="flex: 1;">
                    <label>승인 상태</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="text" id="modal_req_status" readonly style="flex: 1;" />
                    </div>
                </div>
            </div>

            <!-- 강의공지사항 -->
            <div class="form-row">
                <div class="form-group" style="width: 100%;">
                    <label>강의공지사항</label>
                    <textarea id="modal_operations_note" readonly></textarea>
                </div>
            </div>


            <!-- 강의설명 -->
            <div class="form-row">
                <div class="form-group" style="width: 100%;">
                    <label>수업내용</label>
                    <textarea id="modal_description" readonly></textarea>
                </div>
            </div>

            <!-- 강의계획서 -->
            <div class="form-row">
                <div class="form-group" style="width: 100%;">
                    <label>강의계획서</label>
                    <textarea id="modal_syllabus" readonly></textarea>
                </div>
            </div>

        <div class="modal-footer">
            <button class="btn-secondary" onclick="closeCourseModal()">닫기</button>
        </div>
    </div>
</div>

</body>
</html>
