<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>나의 강의</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <link rel="stylesheet" href="/css/course/ckj-course.css" type="text/css" />
    <link rel="stylesheet" href="/css/course/ckj-stu-course.css" type="text/css" />
    <script src="/js/course/courseDropdown.js"></script>
    <script>
      // stuCourse.js 로드 전에 나의 강의 전용 설정 주입
      window.CKJ_STU_CONFIG = {
        listUrl: '/stu/my-courses/loadMyCourse',
        colSpan: 7,
        renderRow: function(course, index, params) { return renderMyCourseRow(course, index, params); },
        detailUrl: '/stu/my-courses/myCourseDetail',
        fillDetail: function(d) { fillMyCourseDetail(d); }
      };
    </script>
    <script src="/js/course/stuCourse.js"></script>
</head>
<body>
<div id="wrap_area">
	<div id="container">
		<ul>
            <li class="lnb"> 
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>
            <li class="contents">
            	<div class="content">
                    <jsp:include page="/WEB-INF/view/common/header.jsp">
					    <jsp:param name="menu1" value="수강 관리"/>
					    <jsp:param name="menu2" value="나의 강의"/>
					    <jsp:param name="refreshUrl" value="${CTX_PATH}/stu/my-courses"/>
					</jsp:include>
				
	                <p class="conTitle">
	                    <span>나의 강의</span>
	                </p>
	                    
	                <div class="container ckj-container">
							<!-- 본문 영역 -->
							<div class="ckj-top">
								<div class="ckj-list-table">
                                    <!-- 사용자가 듣고 있는/들을예정인/들었던 강의를 전부 보여주는 정보 테이블 -->
									<table>
										<thead>
											<tr>
												<!-- ① 번호: 정렬만 -->
												<th class="ckj-col-th" data-col="no">
													<div class="col-header">
														<span>번호</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬 옵션">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
														</div>
													</div>
												</th>

												<!-- ② 강의명: 텍스트 검색 -->
												<th class="ckj-col-th" data-col="title">
													<div class="col-header">
														<span>강의명</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬/검색">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<input type="text" class="ckj-col-filter" data-param="title" placeholder="강의명 검색...">
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>
												<!-- ② 강사명: select 선택 -->
												<th class="ckj-col-th" data-col="inst">
													<div class="col-header">
														<span>강사명</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬/검색">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<select class="ckj-col-filter" data-param="time_code">
																<option value="">전체</option>
															</select>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>

												<!-- ③ 강의기간: 날짜 범위 -->
												<th class="ckj-col-th" data-col="date">
													<div class="col-header">
														<span>강의기간</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬/필터">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown ckj-col-dropdown--wide">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<div class="ckj-date-range">
																<input type="date" class="ckj-col-filter" data-param="search_sdate">
																<span class="ckj-date-sep">~</span>
																<input type="date" class="ckj-col-filter" data-param="search_edate">
															</div>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>

												<!-- ④ 강의실: 체크박스 (불러온 데이터 내에서 강의실 리스트를 동적 로드) -->
												<th class="ckj-col-th" data-col="room">
													<div class="col-header">
														<span>강의실</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬/필터">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<div class="ckj-checkbox-list">
															</div>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>

												<!-- ⑤ 차시: 셀렉트박스 (/common/coursetimelist 동적 로드) -->
												<th class="ckj-col-th" data-col="time">
													<div class="col-header">
														<span>차시</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬/필터">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<select class="ckj-col-filter" data-param="time_code">
																<option value="">전체</option>
															</select>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>

												<!-- ⑥ 수강상태: 체크박스 -->
												 <!-- 수강대기/수강중/수강완료/낙제 -->
												<th class="ckj-col-th" data-col="stu">
													<div class="col-header">
														<span>수강상태</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬">
															<span class="ckj-sort-icon">↕</span>
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑ 오름차순</button>
															<button class="ckj-sort-btn" type="button" data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<div class="ckj-checkbox-list">
															</div>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
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
									<button class="ckj-btn ckj-nav-btn first">처음 페이지로</button>
									<button class="ckj-btn ckj-nav-btn prev">이전 페이지로</button>
									<button class="ckj-btn ckj-nav-btn">1</button>
									<button class="ckj-btn ckj-nav-btn next">다음 페이지로</button>
									<button class="ckj-btn ckj-nav-btn last">마지막 페이지로</button>
								</div>
								<!-- .ckj-pagination -->
							</div>
							<div class="ckj-left">
								<div class="ckj-action-section">
									<div class="ckj-action">
										<button class="ckj-btn" id="assignment-btn">과제확인</button>
										<button class="ckj-btn" id="exam-btn">시험확인</button>
									</div>
								</div>
								<div class="ckj-content">
									<input type="hidden" id="login-id" value="${sessionScope.loginID}">
									<table class="ckj-content-table">
										<tbody>
											<tr>
												<th>강의명</th>
												<td colspan="3">
                                                    <div><input type="text" id="course-title"
													placeholder="강의명을 입력해주세요" required /></div>
                                                    <div><span>수업일수</span><span id="study-days">-</span></div>
												</td>
											</tr>
											<tr>
												<th>강사명</th>
												<td><input type="text" id="inst-name" value="" readonly />
												<th>보조강사명</th>
												<td><input type="text" id="sub-prof-name" value="" readonly />
												</td>
											</tr>
											<tr>
												<th>강사이메일</th>
												<td><input type="text" id="inst-email" value="" readonly />
												<th>강사연락처</th>
												<td><input type="text" id="inst-phone" value="" readonly /></td>
											</tr>
											<tr>
												<th>수업 내용</th>
												<td colspan="3"><textarea name="" id="content"
														cols="30" rows="10" readonly></textarea>
												</td>
											</tr>
											<tr>
												<th>강의 계획</th>
												<td colspan="3"><textarea name="" id="plan" cols="30"
														rows="10" readonly></textarea>
												</td>
											</tr>
											<tr>
												<th>공지 사항</th>
												<td colspan="3"><textarea name="" id="notice" cols="30"
														rows="10" readonly></textarea>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<!-- .ckj-content -->
							</div>
							<div class="ckj-right">
								<div class="ckj-action-section">
									<input type="hidden" id="selected-course-id">
									<div class="ckj-stu-my-course">
										<div id="my-cal-label">나의 출결 현황</div>
										<div class="ckj-action">
											<button class="ckj-btn ckj-img-btn cal-prev" id="my-cal-prev" title="이전 달" aria-label="이전 달"></button>
											<button class="ckj-btn" id="my-cal-today">오늘</button>
											<button class="ckj-btn ckj-img-btn cal-next" id="my-cal-next" title="다음 달" aria-label="다음 달"></button>
										</div>
									</div>
								</div>
								<div class="ckj-content">
                                    <div class="ckj-stu-attendance">
                                        <div><span>출석일수</span><span id="att-count">-</span></div>
                                        <div><span>지각/조퇴/외출</span><span id="tard-count">-</span></div>
                                        <div><span>결석</span><span id="abs-count">-</span></div>
                                    </div>
									<div class="ckj-calendar-table">
										<table>
											<thead><tr><th>일</th>
											<th>월</th>
											<th>화</th>
											<th>수</th>
											<th>목</th>
											<th>금</th>
											<th>토</th></tr></thead>
											<tbody id="my-cal-body"></tbody>
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
