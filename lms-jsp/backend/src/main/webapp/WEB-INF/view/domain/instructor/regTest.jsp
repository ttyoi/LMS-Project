<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 5:31
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>시험문제 등록</title>
    <%-- 기존 include 및 라이브러리 유지 --%>
    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>

    <style>
        /* 과제 관리 페이지 스타일 이식 */
        .split-container { display: flex; gap: 20px; padding: 20px; align-items: flex-start; }
        .list-area { flex: 1; border: 1px solid #ddd; padding: 25px; background: #fff; border-radius: 8px; min-width: 500px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }

        /* 상단 파일 업로드 영역 스타일 */
        .file-section {
            display: flex; align-items: center; gap: 10px; margin-bottom: 20px;
            padding: 15px; background: #f8f9fa; border-radius: 6px; border: 1px dashed #ccc;
        }
        #fileName { font-size: 13px; color: #666; margin-right: auto; }

        /* 시험 정보 박스 스타일 */
        .exam-info-box {
            background: #fff; border: 1px solid #e0e0e0; padding: 15px; border-radius: 6px; margin-bottom: 20px;
        }
        .exam-info-box h4 { margin-bottom: 10px; color: #333; border-left: 4px solid #007bff; padding-left: 10px; font-size: 16px; }
        .exam-info-box p { font-size: 14px; margin: 5px 0; color: #555; }
        .exam-info-box b { color: #222; margin-right: 5px; }

        /* 테이블 스타일 통일 (hw-table 스타일 적용) */
        #previewWrapper { width: 100%; overflow-x: auto; margin-top: 15px; }
        #previewTable { width: 100%; border-collapse: collapse; table-layout: fixed; min-width: 800px; }
        #previewTable th, #previewTable td { border: 1px solid #bcbcbc; padding: 10px; font-size: 13px; text-align: center; }
        #previewTable th { background: #f4f4f4; font-weight: bold; }
        #previewTable tbody tr:hover { background: #fcfcfc; }

        /* 버튼 스타일 통일 */
        .btn { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; transition: 0.2s; display: inline-block; text-align: center; }
        .btn-primary, .btn.preview-btn { background: #007bff; color: white; }
        .btn.submit { background: #20bf6b; color: white; }
        .btn.cancel { background: #6c757d; color: white; }
        .btn#downloadSample { background: #4b7bec; color: white; }
        .btn:hover { opacity: 0.9; }

        /* 하단 버튼 영역 */
        .button-section { margin-top: 25px; text-align: center; border-top: 1px solid #eee; padding-top: 20px; }

        /* 기존 레이아웃 보정 */
        .content { padding: 0 20px; }
    </style>
</head>
<body>
<form id="myForm" action="javascript:void(0);" method="get">
    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">

    <div id="mask"></div>

    <div id="wrap_area">
        <div id="container">
            <ul>
                <li class="lnb">
                    <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
                </li>
                <li class="contents">
                    <div class="content">
                        <p class="Location">
                            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
                            <span class="btn_nav bold">나의 강의 관리</span>
                            <span class="btn_nav bold">시험 등록</span>
                            <a href="javascript:location.reload();" class="btn_set refresh">새로고침</a>
                        </p>

                        <div class="list-area">
                            <p class="conTitle" style="margin-bottom: 20px;">
                                <span>시험 문제 등록</span>
                            </p>

                            <div class="file-section">
                                <label for="excelFile" class="btn btn-primary">파일 첨부하기</label>
                                <input type="file" id="excelFile" accept=".xls,xlsx,xlsm" hidden />
                                <span id="fileName">선택된 파일 없음</span>
                                <button type="button" id="downloadSample" class="btn">샘플양식 다운로드</button>
                            </div>

                            <div class="exam-top-bar" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 10px;">
                                <div class="exam-info-box" style="margin-bottom: 0; flex: 1; margin-right: 20px;">
                                    <h4>시험 정보</h4>
                                    <div style="display: flex; gap: 30px;">
                                        <p><b>강의코드 :</b> <span id="infoCourseId">-</span></p>
                                        <p><b>차시 :</b> <span id="infoPeriod">-</span></p>
                                        <p><b>시험명 :</b> <span id="infoTitle">-</span></p>
                                    </div>
                                </div>
                                <button type="button" id="previewBtn" class="btn preview-btn" style="height: 45px; width: 120px;">미리보기</button>
                            </div>

                            <div id="previewWrapper">
                                <table id="previewTable">
                                    <thead>
                                    <tr>
                                        <th style="width:50px;">번호</th>
                                        <th style="width:auto;">지문</th>
                                        <th style="width:80px;">보기1</th>
                                        <th style="width:80px;">보기2</th>
                                        <th style="width:80px;">보기3</th>
                                        <th style="width:80px;">보기4</th>
                                        <th style="width:60px;">정답</th>
                                        <th style="width:60px;">배점</th>
                                        <th style="width:120px;">해설</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%-- 데이터가 없을 때의 초기 상태 --%>
                                    <tr>
                                        <td colspan="9" style="padding:40px; color:#999;">파일을 업로드하고 미리보기를 클릭해주세요.</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="button-section">
                                <button type="button" id="submitBtn" class="btn submit">등록하기</button>
                                <button type="reset" id="cancelBtn" class="btn cancel">취소</button>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</form>

<%-- 기존 스크립트 파일들 유지 --%>
<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
<script src="/js/exam/sample.js"></script>
<script src="/js/exam/script.js"></script>

<%-- 파일명 표시를 위한 간단한 스크립트 (기존 script.js에 없다면 추가) --%>
<script>
    document.getElementById('excelFile').addEventListener('change', function(e) {
        var fileName = e.target.files[0] ? e.target.files[0].name : "선택된 파일 없음";
        document.getElementById('fileName').textContent = fileName;
    });
</script>

</body>
</html>