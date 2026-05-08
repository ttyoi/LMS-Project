<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<div id="termsModal" class="modal-overlay" style="display:none;">
    <div class="modal-content">
        <h2>약관 동의</h2>

        <div class="terms-box">
            <!-- 약관 텍스트 -->
            <h3 id="terms-title"></h3>
            <pre id="user-terms-text" class="terms-text">

            </pre>
        </div>

        <div class="modal-buttons">
            <button type="button" class="btn-agree" onclick="agreeTerms()">동의</button>
            <button type="button" class="btn-close" onclick="closeTermsModal()">닫기</button>
        </div>
    </div>
</div>
