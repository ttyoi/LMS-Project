<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
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
  <title>전체 강의목록</title>

  <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
  <!-- D3 -->
  <style>

      click-able rows
      .clickable-rows {tbody tr td { cursor:pointer;

      }

          .el-table__expanded-cell {
              cursor: default;
          }
      }

      /* ===================== 강의 페이지 전체 스코프 ===================== */
      .course-page * {
          box-sizing: border-box;
      }


      /* ===================== 검색 박스 ===================== */
      .course-search-box {
          margin: 20px 0;
      }

      .course-search-row {
          display: flex;
          gap: 10px;
          align-items: center;
      }

      #selectform select, input, button {
          margin-right: 5px;
      }

      .course-search-select {
          height: 40px;
          padding: 5px;
          text-indent: 5px;
          border-radius: 10px;
      }

      .course-search-input {
          width: 400px;
          height: 30px;
          padding: 5px;
          border-radius: 10px;
          text-indent: 15px;
      }

      .course-search-btn {
          height: 30px;
          padding: 0 20px;
          cursor: pointer;
          border-radius: 10px;
          border: 1px silver solid;
      }


      /* ===================== 테이블 ===================== */
      .course-table-wrap {
          border-radius: 12px;
          overflow: hidden;    /* 둥글게 보이게 */
          border: 1px solid #ccc;

      }
      .course-table {
          width: 100%;
          text-align: center;
          border-collapse: collapse;
      }

      .course-table th {
          background: #ddd;
          font-weight: bold;
          padding: 10px;
      }

      .course-table td {
          padding: 10px;
          border: 1px solid #ccc;
      }

      /* 조회된 강의 없음 메시지 */
      .course-empty-msg {
          padding: 20px;
          color: #888;
      }

      .course-detail-table {
          width: 100%;
          border-collapse: collapse;
          /*margin-top: 10px;*/
      }

      .course-detail-table th {
          background: #f0f0f0;
          padding: 10px;
          border: 1px solid #ccc;
          width: 120px;
      }

      .course-detail-table td {
          padding: 10px;
          border: 1px solid #ccc;
      }


      .course-detail-btn-wrap {
          text-align: center;
          margin-top: 20px;
      }

      .course-detail-btn-wrap button {
          padding: 8px 20px;
          border-radius: 8px;
          border: 1px solid #888;
          /*background: #f7f7f7;*/
          cursor: pointer;
          margin: 10px;
          font-size: 15px;
          font-weight: bold;
      }


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
  <script src="${CTX_PATH}/js/course/courseList.js"></script>
  <script type="text/javascript">

      $(loadSearchKeys(), loadAllCourse());
      $(document).ready(() => {
          $("#btnSearch").click((e) => {
              e.preventDefault();
              loadAllCourse();
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
  <!-- 모달 배경 -->
  <div id="mask"></div>

  <div id="wrap_area">

    <h2 class="hidden">컨텐츠 영역</h2>
    <div id="container">
      <ul>
        <li class="lnb">
          <!-- lnb 영역 --> <jsp:include
            page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
        </li>
        <li class="contents">

          <!-- contents -->
          <h3 class="hidden">contents 영역</h3>
          <div class="content">

            <p class="Location">
              <a href="/dashboard/dashboard.do" class="btn_set home">메인으로</a>
              <span class="btn_nav bold">수강관리 / 전체 강의 목록</span>
            </p>

            <!-- 전체 강의 페이지 스코프 시작 -->
            <div class="course-page">

              <!-- ===================== 검색 영역 시작 ===================== -->
              <div class="course-search-box">
                <div class="course-search-row">

                  <form id="selectform">
                    <!-- 검색조건 셀렉트 -->
                    <select id="searchKey" name="searchKey" class="course-search-select">
                    </select>

                    <!-- 검색 입력 -->
                    <input type="text" id="searchWord" name="searchWord"
                           placeholder="검색 내용을 입력하세요"
                           class="course-search-input" />

                    <!-- 검색 버튼 -->
                    <button type="button" id="btnSearch" class="course-search-btn">
                      검색
                    </button>

                  </form>
                </div>
              </div>
              <!-- ===================== 검색 영역 끝 ===================== -->



              <!-- ===================== 조회 결과 테이블 시작 ===================== -->
              <div class="course-table-wrap">
                <table class="course-table">

                  <thead>
                  <tr style="font-weight: bold">
                    <th>강의번호</th>
                    <th>강의명</th>
                    <th>담당교수</th>
                    <th>강의실</th>
                    <th>시작시간</th>
                    <th>종료시간</th>
                    <th>수강인원</th>
                    <th>비고</th>
                  </tr>
                  </thead>

                  <tbody id="course-table-body"></tbody>

                </table>

                <div class="paging_area" id="Pagination"></div>
              </div>
              <!-- ===================== 조회 결과 테이블 끝 ===================== -->
              <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
              <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
              <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

            </div>
            <!-- course-page 끝 -->

          </div>
          <!-- content -->
        </li>
      </ul>
    </div>
  </div>
  <div id="layer1" class="layerPop layerType1" style="width: 1000px">
    <dl>
      <dt>
        <strong>강의 상세정보</strong>
      </dt>
      <dd class="content">
<%--        <textarea type="text" id="dataspan"></textarea>--%>

        <div class="course-table-wrap">
          <table class="course-detail-table">


              <!-- 1행 -->
              <tr>
                <th>강의 ID</th>
                <td id="course_id"></td>

                <th>강의명</th>
                <td id="title"></td>
              </tr>

              <!-- 2행 -->
              <tr>
                <th>주교수</th>
                <td id="professor"></td>

                <th>부교수</th>
                <td id="sub_prof"></td>
              </tr>

              <!-- 3행 -->
              <tr>
                <th>강의 시간</th>
                <td id="time_range"></td>

                <th>강의실</th>
                <td id="class_name"></td>
              </tr>

              <!-- 4행 -->
              <tr>
                <th>정원</th>
                <td id="people_limit"></td>

                <th>기간</th>
                <td id="date_range"></td>
              </tr>




              <!-- content -->
              <tr>
                <th>강의 소개</th>
                <td colspan="3" id="content"></td>
              </tr>

              <!-- notice -->
              <tr>
                <th>공지사항</th>
                <td colspan="3" id="notice"></td>
              </tr>

              <!-- plan -->
              <tr>
                <th>강의 계획</th>
                <td colspan="3" id="plan"></td>
              </tr>




          </table>
        </div>
      </dd>
    </dl>
    <div class="course-detail-btn-wrap">
      <button id="changebtn"></button>
      <button id="closePop">닫기</button>
    </div>
  </div>

</body>
</html>