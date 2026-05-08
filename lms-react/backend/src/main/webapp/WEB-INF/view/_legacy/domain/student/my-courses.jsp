<!-- 아래는 요청하신 JSP에 유니크한 className을 부여하고 CSS가 정상적으로 적용되도록 재정리한 전체 코드입니다. -->
<!-- myCourseList.jsp (클래스명 정리 + CSS 적용 버전) -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${sessionScope.userType ne 'S'}">
  <c:redirect url="/dashboard/dashboard.do"/>
</c:if>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <title>나의 강의목록</title>

  <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

  <!-- ===================== 페이지 전용 CSS ===================== -->
  <style>

      /* ===================== 공통 ===================== */
      .mycourse-page * {
          box-sizing: border-box;
      }

      /* ===================== 검색영역 ===================== */
      .mycourse-search-box {
          margin: 20px 0;
      }

      .mycourse-search-row {
          display: flex;
          gap: 10px;
          align-items: center;
      }

      #selectform select, input, button {
          margin-right: 5px;
      }

      .mycourse-select {
          height: 40px;
          padding: 5px;
          border-radius: 10px;
          text-indent: 5px;
      }

      .mycourse-search-btn {
          height: 30px;
          padding: 0 20px;
          cursor: pointer;
          border-radius: 10px;
          border: 1px silver solid;
      }

      /* ===================== 테이블 ===================== */
      .mycourse-table-wrap {
          border-radius: 12px;
          overflow: hidden;
          border: 1px solid #ccc;
      }

      .mycourse-table {
          width: 100%;
          border-collapse: collapse;
          text-align: center;
      }

      .mycourse-table th {
          background: #e7e7e7;
          padding: 10px;
          font-weight: bold;
          border-bottom: 1px solid #ccc;
      }

      .mycourse-table td {
          padding: 10px;
          border-bottom: 1px solid #ccc;
      }

      .mycourse-empty-msg {
          padding: 20px;
          color: #888;
          text-align: center;
      }

      /* ===================== 상세 모달 ===================== */
      .mycourse-detail-table {
          width: 100%;
          border-collapse: collapse;
          /*margin-top: 10px;*/
      }

      .mycourse-detail-table th {
          background: #f0f0f0;
          padding: 10px;
          border: 1px solid #ccc;
          width: 120px;
      }

      .mycourse-detail-table td {
          padding: 10px;
          border: 1px solid #ccc;
      }

      .mycourse-detail-btn-wrap {
          text-align: center;
          margin-top: 20px;
      }

      .mycourse-detail-btn-wrap button {
          padding: 8px 20px;
          border-radius: 8px;
          border: 1px solid #888;
          /*background: #f7f7f7;*/
          cursor: pointer;
          margin: 10px;
          font-size: 15px;
          font-weight: bold;
      }



      /* ===================== changebtn 버튼 공통 스타일 ===================== */
      /*#changebtn {*/
      /*    width: 120px;*/
      /*    height: 40px;*/
      /*    border-radius: 10px;*/
      /*    font-size: 15px;*/
      /*    font-weight: bold;*/
      /*    cursor: pointer;*/
      /*    border: none;*/
      /*}*/

      /* 신청 가능(파란 버튼) */
      .blue-btn {
          background-color: #1976d2;
          color: white;
      }
      .blue-btn:hover {
          background-color: #0d47a1;
      }

      /* 수강 취소(빨간 버튼) */
      .red-btn {
          background: red;
          color: white;
      }
      .red-btn:hover {
          background-color: #9a0007;
      }

      /* 신청 불가(회색 버튼) */
      .disable-btn {
          background-color: #bdbdbd;
          color: #555;
          cursor: not-allowed !important;
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
  </style>

  <script src="${CTX_PATH}/js/course/myCourseList.js"></script>
  <script type="text/javascript">
      $(loadSearchKeys(), loadMyCourse());

      $(document).ready(() => {
          $("#btnSearch").click((e) => {
              e.preventDefault();
              const searchKey = $("#searchKey").val();
              loadMyCourse(searchKey);
          });

          $('#closePop').click(function (e) {
              e.preventDefault();
              $('#mask').hide();
              $('.layerPop').hide();
          });
      });
  </script>

</head>
<body>

<input type="hidden" id="currentPage" value="1">
<input type="hidden" id="selectedInfNo" value="">
<div id="mask"></div>

<div id="wrap_area">
  <div id="container">
    <ul>
      <li class="lnb">
        <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
      </li>
      <li class="contents">

        <div class="content">

          <p class="Location">
            <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
            <span class="btn_nav bold">수강관리 / 나의 강의</span>
          </p>

          <!-- 전체 영역 -->
          <div class="mycourse-page">

            <!-- 검색 -->
            <div class="mycourse-search-box">
              <div class="mycourse-search-row">
                <form id="selectform">
                  <select id="searchKey" name="searchKey" class="mycourse-select"></select>
                  <button type="button" id="btnSearch" class="mycourse-search-btn">검색</button>
                </form>
              </div>
            </div>

            <!-- 테이블 -->
            <div class="mycourse-table-wrap">
              <table class="mycourse-table">
                <thead>
                <tr style="font-weight: bold">

                  <th>강의번호</th>
                  <th>강의명</th>
                  <th>담당교수</th>
                  <th>강의실</th>
                  <th>시작시간</th>
                  <th>종료시간</th>
                  <th>수강상태</th>
<%--                  <th>출결상태</th>--%>
                </tr>
                </thead>
                <tbody id="course-table-body"></tbody>
              </table>
              <div class="paging_area" id="Pagination"></div>

            </div>

          </div>
        </div>
      </li>
    </ul>
  </div>
</div>

<!-- 상세 모달 -->
<div id="layer1" class="layerPop layerType1" style="width: 1000px">
  <dl>
    <dt><strong>강의 상세정보</strong></dt>
    <dd class="content">

<%--      <textarea id="dataspan"></textarea>--%>

      <div class="mycourse-table-wrap">
        <table class="mycourse-detail-table">

          <tr>
            <th>강의 ID</th><td id="course_id"></td>
            <th>강의명</th><td id="title"></td>
          </tr>

          <tr>
            <th>주교수</th><td id="professor"></td>
            <th>부교수</th><td id="sub_prof"></td>
          </tr>

          <tr>
            <th>강의 시간</th><td id="time_range"></td>
            <th>강의실</th><td id="class_name"></td>
          </tr>

          <tr>
            <th>정원</th><td id="people_limit"></td>
            <th>기간</th><td id="date_range"></td>
          </tr>

          <tr>
            <th>출석</th>
            <td id="attendance"></td>
            <th>지각 및 조퇴</th>
            <td id="tard_levEarly"></td>
          </tr>
          <tr>
            <th>결석 및 병가</th>
            <td id="absen_sick"></td>
            <th>출석율</th>
            <td id="att_percent"></td>
          </tr>


          <tr>
            <th>강의 소개</th>
            <td colspan="3" id="content"></td>
          </tr>

          <tr>
            <th>공지사항</th>
            <td colspan="3" id="notice"></td>
          </tr>

          <tr>
            <th>강의 계획</th>
            <td colspan="3" id="plan"></td>
          </tr>

        </table>
      </div>

      <div class="mycourse-detail-btn-wrap">
        <button id="changebtn"></button>
        <button id="closePop">닫기</button>
      </div>

    </dd>
  </dl>
</div>
</body>
</html>
