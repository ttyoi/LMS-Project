<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>전체 강의 목록</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <link rel="stylesheet" href="/css/course/ckj-course.css" type="text/css" />
    <link rel="stylesheet" href="/css/course/ckj-stu-course.css" type="text/css" />
    <script src="/js/course/courseDropdown.js"></script>
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
					    <jsp:param name="menu2" value="전체 강의 목록"/>
					    <jsp:param name="refreshUrl" value="${CTX_PATH}/stu/courses"/>
					</jsp:include>
				
	                <p class="conTitle">
	                    <span>전체 강의 목록</span>
	                </p>
	                    
	                <div class="container ckj-container">
							<!-- 본문 영역 -->
							<div class="ckj-top">
								<div class="ckj-list-table">
                                    <!-- 현재 start_date가 지나지 않았고 cos_sta_code가 1인 강의들을 출력하는 정보 테이블 -->
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

												<!-- ⑥ 신청상태: 체크박스 -->
												<th class="ckj-col-th" data-col="stu">
													<div class="col-header">
														<span>신청상태</span>
														<button class="ckj-col-menu-btn" type="button" title="정렬">
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
								<div class="ckj-content">
									<input type="hidden" id="login-id" value="${sessionScope.loginID}">
									<table class="ckj-content-table">
										<tbody>
											<tr>
												<th>강의명</th>
												<td colspan="3"><input type="text" id="course-title"
													placeholder="강의명을 입력해주세요" required />
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
												<th>강의기간</th>
												<td><input type="text" id="period" value="" readonly />
												<th>수강신청인원</th>
												<td><input type="text" id="stu-count" value="" readonly /></td>
											</tr>
											<tr>
												<th>강의실</th>
												<td><input type="text" id="class-name" value="" readonly />
												<th>차시</th>
												<td><input type="text" id="time-info" value="" readonly /></td>
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
									<div class="ckj-action">
										<button class="ckj-btn primary disabled" id="enroll-btn">수강신청</button>
										<button class="ckj-btn warning ckj-hidden" id="cancel-enroll-btn" >신청취소</button>
									</div>
									<span class="ckj-warning ckj-hidden" id="enroll-warning" >수강신청 정정은 강의 시작 1개월 전부터 1일 전까지 가능합니다.</span>
								</div>
								<!-- .ckj-action-section -->
								<div class="ckj-content">
                                    <div class="ckj-stu-my-course">
                                        <div id="courses-cal-label">수강중인 강의 일정</div>
                                        <div>
                                            <button class="ckj-btn ckj-img-btn cal-prev" id="courses-cal-prev" title="이전"></button>
                                            <button class="ckj-btn" id="courses-cal-today">오늘</button>
                                            <button class="ckj-btn ckj-img-btn cal-next" id="courses-cal-next" title="다음"></button>
                                        </div>
                                    </div>
									<div class="ckj-calendar-table">
										<table>
											<!-- 일요일 red, 토요일 blue로 th color와 td 날짜 color -->
											<thead><tr><th>일</th>
											<th>월</th>
											<th>화</th>
											<th>수</th>
											<th>목</th>
											<th>금</th>
											<th>토</th></tr></thead>
											<tbody id="courses-cal-body"></tbody>
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
