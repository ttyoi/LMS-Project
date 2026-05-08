<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 12. 1.
  Time: 오후 5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <meta charset="UTF-8" />
    <title>시험문제 등록</title>
    <link rel="stylesheet" href="/css/exam/style.css" />
    <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
</head>
<body>
<form id="myForm" action="javascript:void(0);"  method="get">

    <input type="hidden" id="currentPage" value="1">
    <input type="hidden" id="selectedInfNo" value="">
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
                            <span class="btn_nav bold">나의 강의 관리</span>
                            <span class="btn_nav bold">시험 등록</span>
                            <a href="/dashboard/dashboard.do" class="btn_set refresh">새로고침</a>
                        </p>
                        <div>
                            <p class="conTitle" style="margin-bottom: 1%;">
                                <span>시험 문제 등록</span>

                            </p>
                            <div class="container">

                                <!-- 파일 업로드 영역 -->
                                <div class="file-section">
                                    <label for="excelFile" class="btn">파일 첨부하기</label>
                                    <input type="file" id="excelFile" accept=".xls,xlsx,xlsm" hidden />
                                    <span id="fileName">선택된 파일 없음</span>

                                    <button type="button" id="downloadSample" class="btn">샘플양식 다운로드</button>
                                </div>

                                <!-- 버튼 + 시험정보를 한 줄로 정렬 -->
                                <div class="exam-top-bar">
                                    <!-- 미리보기 버튼 -->
                                    <button type="button" id="previewBtn" class="btn preview-btn">미리보기</button>

                                    <!-- 시험 정보 표시 영역 (추가) -->
                                    <div class="exam-info-box">
                                        <h4>시험 정보</h4>
                                        <p><b>강의코드 :</b> <span id="infoCourseId">-</span></p>
                                        <p><b>차시 :</b> <span id="infoPeriod">-</span></p>
                                        <p><b>시험명 :</b> <span id="infoTitle">-</span></p>
                                    </div>
                                </div>
                                <!-- 미리보기 테이블 -->
                                <div id="previewWrapper">
                                    <table id="previewTable">
                                        <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>지문</th>
                                            <th>보기1</th>
                                            <th>보기2</th>
                                            <th>보기3</th>
                                            <th>보기4</th>
                                            <th>정답</th>
                                            <th>배점</th>
                                            <th>해설</th>
                                        </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>


                                <!-- 하단 버튼 -->
                                <div class="button-section">
                                    <button type="button" id="submitBtn" class="btn submit">등록하기</button>
                                    <button type="reset" id="cancelBtn" class="btn cancel">취소</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>

</form>



<!-- CDN 방식에서 엑셀파일 업로드시 인식하게 해주는 XLSX 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
<%-- 스크립트 src 주소 변경 필요 --%>
<!-- 샘플은 현재 프론트에서 생성되는 방식, 추후 백엔드에서 생성하는 방식으로 변경할 것 -->
<script src="/js/exam/sample.js"></script>
<script src="/js/exam/script.js"></script>


</body>
</html>
