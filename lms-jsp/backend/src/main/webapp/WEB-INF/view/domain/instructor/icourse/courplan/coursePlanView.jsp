<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>강의 계획서</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp" />
<link rel="stylesheet" href="/css/course/ckj-course.css" type="text/css" />
<link rel="stylesheet" href="/css/course/ckj-inst-course.css"
	type="text/css" />
<script src="/js/course/courseDropdown.js"></script>
<script src="/js/course/instCourse.js"></script>
</head>
<body>
	<%
	String userNm = (String) session.getAttribute("userNm");
	%>
	<div id="wrap_area">
		<div id="container">
			<ul>
				<li class="lnb"><jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp" /></li>
				<li class="contents">
					<div class="content">
						<jsp:include page="/WEB-INF/view/common/header.jsp">
							<jsp:param name="menu1" value="나의 강의 관리" />
							<jsp:param name="menu2" value="강의 계획서" />
							<jsp:param name="refreshUrl" value="${CTX_PATH}/inst/course-plan" />
						</jsp:include>

						<p class="conTitle">
							<span>강의 계획서</span>
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
														<button class="ckj-col-menu-btn" type="button"
															title="정렬 옵션"></button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
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
														<button class="ckj-col-menu-btn" type="button"
															title="정렬/검색"></button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<input type="text" class="ckj-col-filter"
																data-param="title" placeholder="강의명 검색...">
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
														<button class="ckj-col-menu-btn" type="button"
															title="정렬/필터"></button>
													</div>
													<div class="ckj-col-dropdown ckj-col-dropdown--wide">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<div class="ckj-date-range">
																<input type="date" class="ckj-col-filter"
																	data-param="search_sdate"> <span
																	class="ckj-date-sep">~</span> <input type="date"
																	class="ckj-col-filter" data-param="search_edate">
															</div>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>

												<!-- ④ 강의실: 체크박스 (현재 목록의 강의실만 동적 로드) -->
												<th class="ckj-col-th" data-col="room">
													<div class="col-header">
														<span>강의실</span>
														<button class="ckj-col-menu-btn" type="button"
															title="정렬/필터"></button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<div class="ckj-checkbox-list"></div>
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
														<button class="ckj-col-menu-btn" type="button"
															title="정렬/필터"></button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
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

												<!-- ⑥ 보조강사: 셀렉트박스 (/common/registeredinstlist 동적 로드) -->
												<th class="ckj-col-th" data-col="subprof">
													<div class="col-header">
														<span>보조강사</span>
														<button class="ckj-col-menu-btn" type="button"
															title="정렬/필터"></button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-filter-divider"></div>
														<div class="ckj-filter-section">
															<select class="ckj-col-filter" data-param="sub_prof">
																<option value="">전체</option>
															</select>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
															<button class="ckj-apply-btn" type="button">적용</button>
														</div>
													</div>
												</th>

												<!-- ⑦ 수강인원: 정렬만 -->
												<th class="ckj-col-th" data-col="stu">
													<div class="col-header">
														<span>수강인원</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬">
														</button>
													</div>
													<div class="ckj-col-dropdown">
														<div class="ckj-sort-section">
															<button class="ckj-sort-btn" type="button" data-dir="asc">↑
																오름차순</button>
															<button class="ckj-sort-btn" type="button"
																data-dir="desc">↓ 내림차순</button>
														</div>
														<div class="ckj-dropdown-footer">
															<button class="ckj-reset-btn" type="button">초기화</button>
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
									<div class="ckj-inst-tab">
										<button class="ckj-btn ckj-tab-btn active">신규 등록</button>
										<button class="ckj-btn ckj-tab-btn">강의 상세</button>
										<button class="ckj-btn ckj-tab-btn">출석 관리</button>
									</div>
								</div>
								<!-- ckj-action-section -->
								 <div class="ckj-left-content">
								<div class="ckj-content">
									<table class="ckj-content-table">
										<colgroup>
											<col class="col-label">
											<col>
											<col class="col-label">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th class="required">강의명</th>
												<td colspan="3"><input type="text" id="course-title"
													placeholder="강의명을 입력해주세요" required /></td>
											</tr>
											<tr>
												<th class="required">시작일자</th>
												<td><input type="date" required id="start_date" /></td>
												<th class="required">종료일자</th>
												<td><input type="date" required id="end_date" /></td>

											</tr>
											<tr>
												<th class="required">강의실</th>
												<td><select id="class-id" required>
														<option value="">-- 강의실 선택 --</option>
												</select></td>
												<th class="required">차시</th>
												<td><select id="time-code-form" required>
														<option value="">-- 차시 선택 --</option>
												</select></td>
											</tr>
											<tr>
												<th>강사</th>
												<td><input type="text" value="<%=userNm%>" readonly />
												</td>
												<th>보조강사</th>
												<td><select name="" id="sub-prof">
														<option value="">-- 보조강사 선택 --</option>
												</select></td>
											</tr>

											<tr class="ckj-row-textarea">
												<th>수업 내용</th>
												<td colspan="3"><textarea name="" id="content"
														cols="30" rows="3" placeholder="수업내용을 입력해주세요"></textarea>
												</td>
											</tr>
											<tr class="ckj-row-textarea">
												<th>강의 계획</th>
												<td colspan="3"><textarea name="" id="plan" cols="30"
														rows="3" placeholder="강의계획을 입력해주세요"></textarea></td>
											</tr>
											<tr class="ckj-row-textarea">
												<th>공지 사항</th>
												<td colspan="3"><textarea name="" id="notice" cols="30"
														rows="3" placeholder="공지사항을 입력해주세요"></textarea></td>
											</tr>
										</tbody>
									</table>
								</div>
								</div>
								<!-- .ckj-content -->
							</div>
							<div class="ckj-right">
								<div class="ckj-action-section">
									<div class="ckj-action">
										<button class="ckj-btn primary" id="reg-btn">등록</button>
										<button class="ckj-btn" id="reset-plan-btn">초기화</button>
									</div>
								</div>
								<!-- .ckj-action-section -->
								<%
								Calendar cal = Calendar.getInstance();
								int yyyy = cal.get(Calendar.YEAR);
								int mm = cal.get(Calendar.MONTH) + 1;
								int week = cal.get(Calendar.WEEK_OF_MONTH);
								// 이번 주 일요일부터 토요일 날짜 계산
						int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 1=일, 2=월 ...
						int sundayOffset = -(dayOfWeek - 1);
						cal.add(Calendar.DAY_OF_MONTH, sundayOffset);
						String[] dayNames = {"일", "월", "화", "수", "목", "금", "토"};
						java.util.Calendar todayCal = java.util.Calendar.getInstance();
						int[] weekDays = new int[7];
						boolean[] todayFlags = new boolean[7];
						for (int i = 0; i < 7; i++) {
							weekDays[i] = cal.get(Calendar.DAY_OF_MONTH);
							todayFlags[i] = (cal.get(Calendar.YEAR) == todayCal.get(Calendar.YEAR)
								&& cal.get(Calendar.DAY_OF_YEAR) == todayCal.get(Calendar.DAY_OF_YEAR));
							cal.add(Calendar.DAY_OF_MONTH, 1);
						}
						String[] todayClass = new String[7];
						for (int i = 0; i < 7; i++) {
							todayClass[i] = todayFlags[i] ? " is-today" : "";
						}
								%>
								<div class="ckj-content">
									<div class="ckj-timeline-container">
										<div class="ckj-timeline-nav">
											<p class="ckj-info"><%=yyyy%>년
												<%=mm%>월
												<%=week%>주차
											</p>
											<div class="ckj-action">
												<button class="ckj-btn ckj-nav-btn last-week"
													aria-label="이전 주">이전주</button>
												<button class="ckj-btn" id="timeline-today-btn">오늘</button>
												<button class="ckj-btn ckj-nav-btn next-week"
													aria-label="다음 주">다음주</button>
												<button class="ckj-btn ckj-img-btn calendar"
													aria-label="날짜 선택">날짜선택</button>
												<input type="date" id="timeline-date-input"
													class="ckj-hidden" aria-label="날짜 직접 선택">
											</div>
										</div>
																				<!-- 헤더: scrollbar-gutter로 바디 스크롤바 폭 확보 (컬럼 폭 동기화) -->
										<div class="ckj-timeline-head-wrap">
											<table class="ckj-content-timeline">
												<colgroup>
													<col class="ckj-col-room">
													<col><col><col><col><col><col><col>
												</colgroup>
												<thead>
																								<tr class="ckj-timeline-dates">
												<th></th>
												<th class="is-sunday<%=todayClass[0]%>">
													<span class="date-num"><%=weekDays[0]%></span>
													<span class="date-day"><%=dayNames[0]%></span>
												</th>
												<th class="<%=todayClass[1]%>">
													<span class="date-num"><%=weekDays[1]%></span>
													<span class="date-day"><%=dayNames[1]%></span>
												</th>
												<th class="<%=todayClass[2]%>">
													<span class="date-num"><%=weekDays[2]%></span>
													<span class="date-day"><%=dayNames[2]%></span>
												</th>
												<th class="<%=todayClass[3]%>">
													<span class="date-num"><%=weekDays[3]%></span>
													<span class="date-day"><%=dayNames[3]%></span>
												</th>
												<th class="<%=todayClass[4]%>">
													<span class="date-num"><%=weekDays[4]%></span>
													<span class="date-day"><%=dayNames[4]%></span>
												</th>
												<th class="is-saturday<%=todayClass[5]%>">
													<span class="date-num"><%=weekDays[5]%></span>
													<span class="date-day"><%=dayNames[5]%></span>
												</th>
												<th class="<%=todayClass[6]%>">
													<span class="date-num"><%=weekDays[6]%></span>
													<span class="date-day"><%=dayNames[6]%></span>
												</th>
											</tr>
												</thead>
											</table>
										</div>
										<!-- 바디: scrollbar-gutter로 헤더와 컬럼 폭 일치 -->
										<div class="ckj-timeline-scroll">
											<table class="ckj-content-timeline">
												<colgroup>
													<col class="ckj-col-room">
													<col><col><col><col><col><col><col>
												</colgroup>
												<tbody id="timeline-body"></tbody>
											</table>
										</div>
									</div>
								</div>
								<!-- .ckj-content -->
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>
