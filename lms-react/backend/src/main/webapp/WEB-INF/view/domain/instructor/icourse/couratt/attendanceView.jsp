<%@page import="java.util.Calendar"%> <%@ page language="java"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions"%> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>출석 관리</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp" />
    <link rel="stylesheet" href="/css/course/ckj-course.css" type="text/css" />
    <link
      rel="stylesheet"
      href="/css/course/ckj-inst-course.css"
      type="text/css"
    />
    <script src="/js/course/courseDropdown.js"></script>
    <script src="/js/course/instCourse.js"></script>
  </head>
  <body>
    <div id="wrap_area">
      <div id="container">
        <ul>
          <li class="lnb">
            <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp" />
          </li>
          <li class="contents">
            <div class="content">
              <jsp:include page="/WEB-INF/view/common/header.jsp">
                <jsp:param name="menu1" value="나의 강의 관리" />
                <jsp:param name="menu2" value="출석 관리" />
                <jsp:param
                  name="refreshUrl"
                  value="${CTX_PATH}/inst/attendance"
                />
              </jsp:include>

              <p class="conTitle">
                <span>출석 관리</span>
              </p>

              <div class="container ckj-container">
                <!-- 본문 영역 -->
                <div class="ckj-top">
                  <div class="ckj-list-table">
                    <table>
                      <colgroup>
                        <col class="ckj-col-no">
                        <col class="ckj-col-title">
                        <col class="ckj-col-date">
                        <col class="ckj-col-room">
                        <col class="ckj-col-time">
                        <col class="ckj-col-subprof">
                        <col class="ckj-col-stu">
                      </colgroup>
                      <thead>
                        <tr>
                          <!-- ① 번호: 정렬만 -->
                          <th class="ckj-col-th" data-col="no">
                            <div class="col-header">
                              <span>번호</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬 옵션"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div class="ckj-col-dropdown">
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                              </div>
                            </div>
                          </th>

                          <!-- ② 강의명: 텍스트 검색 -->
                          <th class="ckj-col-th" data-col="title">
                            <div class="col-header">
                              <span>강의명</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬/검색"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div class="ckj-col-dropdown">
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-filter-divider"></div>
                              <div class="ckj-filter-section">
                                <input
                                  type="text"
                                  class="ckj-col-filter"
                                  data-param="title"
                                  placeholder="강의명 검색..."
                                />
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                                <button class="ckj-apply-btn" type="button">
                                  적용
                                </button>
                              </div>
                            </div>
                          </th>

                          <!-- ③ 강의기간: 날짜 범위 -->
                          <th class="ckj-col-th" data-col="date">
                            <div class="col-header">
                              <span>강의기간</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬/필터"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div
                              class="ckj-col-dropdown ckj-col-dropdown--wide"
                            >
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-filter-divider"></div>
                              <div class="ckj-filter-section">
                                <div class="ckj-date-range">
                                  <input
                                    type="date"
                                    class="ckj-col-filter"
                                    data-param="search_sdate"
                                  />
                                  <span class="ckj-date-sep">~</span>
                                  <input
                                    type="date"
                                    class="ckj-col-filter"
                                    data-param="search_edate"
                                  />
                                </div>
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                                <button class="ckj-apply-btn" type="button">
                                  적용
                                </button>
                              </div>
                            </div>
                          </th>

                          <!-- ④ 강의실: 체크박스 (현재 목록의 강의실만 동적 로드) -->
                          <th class="ckj-col-th" data-col="room">
                            <div class="col-header">
                              <span>강의실</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬/필터"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div class="ckj-col-dropdown">
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-filter-divider"></div>
                              <div class="ckj-filter-section">
                                <div class="ckj-checkbox-list"></div>
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                                <button class="ckj-apply-btn" type="button">
                                  적용
                                </button>
                              </div>
                            </div>
                          </th>

                          <!-- ⑤ 차시: 셀렉트박스 (/common/coursetimelist 동적 로드) -->
                          <th class="ckj-col-th" data-col="time">
                            <div class="col-header">
                              <span>차시</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬/필터"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div class="ckj-col-dropdown">
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-filter-divider"></div>
                              <div class="ckj-filter-section">
                                <select
                                  class="ckj-col-filter"
                                  data-param="time_code"
                                >
                                  <option value="">전체</option>
                                </select>
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                                <button class="ckj-apply-btn" type="button">
                                  적용
                                </button>
                              </div>
                            </div>
                          </th>

                          <!-- ⑥ 보조강사: 셀렉트박스 (현재 목록의 보조강사만 동적 로드) -->
                          <th class="ckj-col-th" data-col="subprof">
                            <div class="col-header">
                              <span>보조강사</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬/필터"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div class="ckj-col-dropdown">
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-filter-divider"></div>
                              <div class="ckj-filter-section">
                                <select
                                  class="ckj-col-filter"
                                  data-param="sub_prof"
                                >
                                  <option value="">전체</option>
                                </select>
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                                <button class="ckj-apply-btn" type="button">
                                  적용
                                </button>
                              </div>
                            </div>
                          </th>

                          <!-- ⑦ 수강인원: 정렬만 -->
                          <th class="ckj-col-th" data-col="stu">
                            <div class="col-header">
                              <span>수강인원</span>
                              <button
                                class="ckj-col-menu-btn"
                                type="button"
                                title="정렬"
                              >
                                <span class="ckj-sort-icon">↕</span>
                              </button>
                            </div>
                            <div class="ckj-col-dropdown">
                              <div class="ckj-sort-section">
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="asc"
                                >
                                  ↑ 오름차순
                                </button>
                                <button
                                  class="ckj-sort-btn"
                                  type="button"
                                  data-dir="desc"
                                >
                                  ↓ 내림차순
                                </button>
                              </div>
                              <div class="ckj-dropdown-footer">
                                <button class="ckj-reset-btn" type="button">
                                  초기화
                                </button>
                              </div>
                            </div>
                          </th>
                        </tr>
                      </thead>
                      <tbody id="inst-course"></tbody>
                    </table>
                  </div>
                  <!-- .ckj-list-table -->
                  <div class="ckj-pagination">
                    <button class="ckj-btn ckj-nav-btn first">
                      처음 페이지로
                    </button>
                    <button class="ckj-btn ckj-nav-btn prev">
                      이전 페이지로
                    </button>
                    <button class="ckj-btn ckj-nav-btn">1</button>
                    <button class="ckj-btn ckj-nav-btn next">
                      다음 페이지로
                    </button>
                    <button class="ckj-btn ckj-nav-btn last">
                      마지막 페이지로
                    </button>
                  </div>
                  <!-- .ckj-pagination -->
                </div>
                <div class="ckj-left">
                  <div class="ckj-action-section">
                    <div class="ckj-inst-tab">
                      <button class="ckj-btn ckj-tab-btn">신규 등록</button>
                      <button class="ckj-btn ckj-tab-btn">강의 상세</button>
                      <button class="ckj-btn ckj-tab-btn active">
                        출석 관리
                      </button>
                    </div>
                    </div>
                    <div class="ckj-left-content">
                    <!-- 검색+수업일수: action-section 내 2행으로 통합 → 테이블 시작 위치 표준화 -->
                    <div class="ckj-att-search-row">
                      <div class="ckj-section-left">
                        <input
                          type="text"
                          id="stu-search-input"
                          placeholder="학생명을 입력하세요"
                          aria-label="학생명 검색"
                        />
                        <button id="stu-search-btn" class="ckj-btn">검색</button>
                      </div>
                      <div class="ckj-section-right">
                        <table>
                          <tbody>
                            <tr>
                              <th>전체수업일수</th>
                              <td id="total-class-days">-</td>
                              <th>현재수업일수</th>
                              <td id="current-class-days">-</td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div><!-- .ckj-att-search-row -->
                    <!-- ckj-action-section -->
                    <div class="ckj-content">
                      <table class="ckj-stu-list">
                        <thead>
                          <tr>
                            <th>번호</th>
                            <th>학생명</th>
                            <th>미확인</th>
                            <th>출석</th>
                            <th>지각</th>
                            <th>조퇴</th>
                            <th>외출</th>
                            <th>결석</th>
                          </tr>
                        </thead>
                        <tbody id="stu-list-body"></tbody>
                      </table>
                    </div>
                    </div>
                  </div>
                  <!-- .ckj-content -->
                  <div class="ckj-right">
                    <div class="ckj-action-section ckj-att-action-row">
                      <div class="ckj-action">
                        <span class="ckj-warning ckj-hidden" id="att-save-warning">출석 확인이 되지 않은 학생이 있습니다.</span>
                        <button class="ckj-btn primary disabled" id="att-save-all-btn" disabled aria-label="출석 저장">저장</button>
                        <button class="ckj-btn" id="att-cancel-btn" aria-label="출석 취소">취소</button>
                      </div>
                    </div>
                    <div class="ckj-att-date-group">
                      <button class="ckj-btn ckj-nav-btn last-week" id="att-prev-btn" aria-label="이전 날짜">이전</button>
                      <input type="date" id="att-date-input" aria-label="출석 날짜 선택" />
                      <button class="ckj-btn ckj-nav-btn next-week" id="att-next-btn" aria-label="다음 날짜">다음</button>
                    </div>
                    <input type="hidden" id="att-selected-course-id" />
                    <!-- .ckj-action-section -->
                    <div class="ckj-content">
                      <div class="ckj-attendance-container">
                        <table class="ckj-content-attendance">
                          <thead>
                            <tr>
                              <th>번호</th>
                              <th>학생명</th>
                              <th>미확인</th>
                              <th>출석</th>
                              <th>지각</th>
                              <th>조퇴</th>
                              <th>외출</th>
                              <th>결석</th>
                              <th>저장</th>
                            </tr>
                          </thead>
                          <tbody id="att-detail-body"></tbody>
                        </table>
                      </div>
                    </div>
                    <!-- .ckj-content -->
                </div>
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </body>
</html>
