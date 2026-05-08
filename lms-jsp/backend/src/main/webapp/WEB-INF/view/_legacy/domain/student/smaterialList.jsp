<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>학습자료</title>

  <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
  <script src='${CTX_PATH}/js/materials/smaterials.js'></script>

  <!-- 기존 CSS 그대로 유지 -->
  <style>
      /* ========================
     학습자료 페이지 전용 스타일 (추가)
     기존 CSS는 수정하지 않고, 필요한 부분만 신규 className으로 구성
     ======================== */

      /* 전체 테이블 영역 */
      .materials-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 14px;
      }

      .materials-table thead tr {
          background: #f2f2f2;
          border-bottom: 2px solid #ddd;
      }

      .materials-table th,
      .materials-table td {
          padding: 10px;
          text-align: center;
          border-bottom: 1px solid #e0e0e0;
      }

      /* 조회 결과 없을 때 */
      .no-material-msg {
          padding: 20px;
          font-size: 15px;
          color: #777;
      }

      /* 등록 버튼 우측 정렬 */
      .materials-btn-wrap {
          text-align: right;
          margin: 20px 0;
      }

      /* 모달 내부 기본 스타일 */
      .material-modal table.row th {
          font-weight: bold;
          padding: 8px;
          background: #fafafa;
          border-right: 1px solid #ddd;
          text-align: left;
      }

      .material-modal table.row td {
          padding: 8px;
      }

      /* 입력창 스타일 */
      .material-input,
      .material-textarea {
          width: 95%;
          padding: 6px;
          border: 1px solid #ccc;
          border-radius: 4px;
          box-sizing: border-box;
          font-size: 14px;
      }

      .material-textarea {
          height: 120px;
          resize: vertical;
      }

      /* 파일 업로드 영역 */
      .material-file-input {
          padding: 5px 0;
          font-size: 14px;
      }

      /* 모달 버튼 영역 */
      .material-modal-btns {
          text-align: center;
          padding-top: 15px;
      }

      /* 파일 수정 불가 문구 */
      .cant-file-update-msg {
          color: #d9534f;
          font-size: 13px;
          font-weight: bold;
      }

      /* 상세보기 파일명 */
      .material-file-name {
          font-weight: bold;
          margin-right: 10px;
      }




      /* 페이징 전체 영역 */
      .paging_area {
          text-align: center;
          user-select: none;


          display: flex;
          justify-content: center;   /* 가로 가운데 */
          align-items: center;       /* 세로 가운데 */
          padding: 10px;
      }

      /* 기본 버튼 스타일 */
      .paging_area a {
          display: inline-block;
          padding: 0px 12px;
          margin: 0 4px;
          border: 1px solid #ccc;
          border-radius: 4px;
          background: #f8f8f8;
          color: #333;
          text-decoration: none;
          font-size: 14px;
          transition: 0.2s;
      }

      /* 호버 시 */
      .paging_area a:hover {
          background: #e9e9e9;
          border-color: #bbb;
      }

      /* 현재 페이지 스타일 */
      .paging_area a.current {
          background: #007bff;
          border-color: #007bff;
          color: white !important;
          font-weight: bold;
      }

      /* 화살표(◀, ▶) 버튼 */
      .paging_area a.prev,
      .paging_area a.next {
          font-weight: bold;
      }

      #table-header-bold > th{
          font-weight: bold;
      }
  </style>

</head>

<body>
<div id="wrap_area">
  <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

  <div id="container">
    <ul>
      <li class="lnb">
        <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
      </li>

      <li class="contents">
        <div class="content">

          <p class="Location">
            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
            <span class="btn_nav bold">학습관리 / 학습자료</span>
          </p>

          <!-- 목록 -->
          <div class="divCourseList">
            <select id="mycourse" style="display: inline-block" onchange="fLoadMaterials()"></select>


            <table class="materials-table">
              <thead>
              <tr id="table-header-bold" >
                <th>순번</th>
                <th>제목</th>
                <th>강의명</th>
                <th>작성일</th>
                <th>파일명</th>
              </tr>
              </thead>
              <tbody id="listMaterial"></tbody>
            </table>
          </div>

          <!-- 페이징 -->
          <div class="paging_area" id="Pagination"></div>
        </div>
      </li>
    </ul>
  </div>
</div>

<!-- 상세보기 모달 (읽기 전용) -->
<div id="layer1" class="layerPop layerType1 material-modal" style="width: 600px;">
  <dl>
    <dt><strong>학습자료 상세</strong></dt>
    <dd class="content">
      <table class="row">
        <tbody>
        <tr>
          <th>강의명</th>
          <td id="td-course"></td>
        </tr>
        <tr>
          <th>제목</th>
          <td id="td-title"></td>
        </tr>
        <tr>
          <th>내용</th>
          <td id="td-content"></td>
        </tr>
        <tr>
          <th>파일</th>
          <td id="td-file"></td>
        </tr>
        <tr>
          <td colspan="2" class="material-modal-btns">
            <a href="#" class="btnType white" id="closePop"><span>닫 기</span></a>
          </td>
        </tr>
        </tbody>
      </table>
    </dd>
  </dl>
</div>

</body>
</html>
