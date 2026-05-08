<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<div id="teacherModal" class="modal-regIns">
    <div class="modal-content-regIns">
        <!-- X 버튼 -->
        <span class="close-btn-regIns" onclick="closeTeacherModal()">×</span>
        <h3>강사등록</h3>

        <table class="reg-table-regIns">
            <tr>
                <th>아이디</th>
                <td><input type="text" id="t_id" readonly></td>
            </tr>
            <tr>
                <th>이메일</th>
                <td><input type="text" id="t_email" placeholder="이메일을 입력해주세요." onblur="checkFullInstructorEmail()"></td>
            </tr>
        </table>

        <button class="modal-btn-regIns" onclick="clickRegisterInstructor()">강사등록 메일 보내기</button>
        <div id="loading" class="loading-overlay" style="display:none;" >
            <div class="spinner"></div>
        </div>
    </div>
</div>
