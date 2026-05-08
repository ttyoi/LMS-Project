<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="${CTX_PATH}/css/admin/aDashboard/newdashboard.css"/>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
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
                        <jsp:param name="menu1" value="관리자"/>
                        <jsp:param name="menu2" value="대시보드"/>
                        <jsp:param name="refreshUrl" value="${CTX_PATH}/admin/dashboard"/>
                    </jsp:include>

                    <p class="conTitle"><span>관리자 대시보드</span></p>

                    <div class="dashboard-container">
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-icon instructor">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-number" id="instructorCount">-</div>
                                    <div class="stat-label">강사</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon student">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="8.5" cy="7" r="4"></circle>
                                        <polyline points="17 11 19 13 23 9"></polyline>
                                    </svg>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-number" id="studentCount">-</div>
                                    <div class="stat-label">학생</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon course">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                                    </svg>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-number" id="courseCount">-</div>
                                    <div class="stat-label">강의</div>
                                </div>
                            </div>
                        </div>

                        <div class="main-content-grid">
                            <div class="quick-links-section">
                                <h3 class="section-title">빠른 바로가기</h3>
                                <div class="link-grid">
                                    <a href="${CTX_PATH}/admin/notices" class="link-card">
                                        <div class="link-icon">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                <polyline points="14 2 14 8 20 8"></polyline>
                                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                            </svg>
                                        </div>
                                        <div class="link-text">
                                            <div class="link-title">공지사항</div>
                                            <div class="link-desc">공지사항 관리</div>
                                        </div>
                                    </a>
                                    <a href="${CTX_PATH}/admin/exam/schedule" class="link-card">
                                        <div class="link-icon">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                        </div>
                                        <div class="link-text">
                                            <div class="link-title">시험 일정</div>
                                            <div class="link-desc">시험 일정 관리</div>
                                        </div>
                                    </a>
                                    <a href="${CTX_PATH}/admin/courseManagement" class="link-card">
                                        <div class="link-icon">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                                <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                                            </svg>
                                        </div>
                                        <div class="link-text">
                                            <div class="link-title">강의 관리</div>
                                            <div class="link-desc">강의 목록 및 관리</div>
                                        </div>
                                    </a>
                                    <a href="${CTX_PATH}/admin/stu" class="link-card">
                                        <div class="link-icon">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="9" cy="7" r="4"></circle>
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                            </svg>
                                        </div>
                                        <div class="link-text">
                                            <div class="link-title">사용자 관리</div>
                                            <div class="link-desc">강사 및 학생 관리</div>
                                        </div>
                                    </a>
                                </div>
                            </div>

                            <div class="notice-section">
                                <h3 class="section-title">최근 공지사항</h3>
                                <div class="notice-list" id="noticeList"></div>
                                <a href="${CTX_PATH}/admin/notices" class="view-more-link">전체보기 →</a>
                            </div>
                        </div>

                        <div class="bottom-grid">
                            <div class="exam-month-section">
                                <h3 class="section-title">이번 달 시험 과목</h3>
                                <div class="exam-month-card" id="examMonthCard"></div>
                            </div>
                        </div>

                        <div class="classroom-section">
                            <h3 class="section-title">수업 중인 강의실</h3>
                            <div class="classroom-grid" id="classroomGrid"></div>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
    </div>

    <script>
        $(document).ready(function () {
            loadDashboardStats();
            loadRecentNotices();
            loadExamMonth();
            loadClassrooms();
        });

        function loadDashboardStats() {
            $.ajax({
                url: "/dashboard/goChart.do",
                type: "POST",
                dataType: "json",
                success: function (data) {
                    animateNumber("instructorCount", data.cntInstructor || 0);
                    animateNumber("studentCount", data.cntStudent || 0);
                    animateNumber("courseCount", data.cntCourse || 0);
                }
            });
        }

        function loadRecentNotices() {
            $.ajax({
                url: "/admin/notices/recent",
                type: "GET",
                data: {limit: 3},
                dataType: "json",
                success: function (response) {
                    if (response.success && response.list) renderNotices(response.list);
                    else renderNotices([]);
                }
            });
        }

        function renderNotices(notices) {
            var html = "";
            if (notices.length > 0) {
                notices.forEach(function (notice) {
                    html += '<div class="notice-item" style="cursor:pointer;" onclick="goNoticeDetail(' + notice.noticeNo + ')">';
                    html += '  <div class="notice-title">' + notice.noticeTitle + '</div>';
                    html += '  <div class="notice-date">' + notice.noticeRegdate + '</div>';
                    html += '</div>';
                });
            } else {
                html = '<div class="notice-item"><div class="notice-title">공지사항이 없습니다.</div></div>';
            }
            $("#noticeList").html(html);
        }

        function loadExamMonth() {
            $.ajax({
                url: "/admin/exam/month/current",
                type: "GET",
                dataType: "json",
                success: function (response) {
                    var dataList = response.list;

                    if (dataList && dataList.length > 0) {
                        renderExamMonth(dataList);
                    } else {
                        $("#examMonthCard").html('<div class="exam-month-title">이번 달 예정된 시험이 없습니다.</div>');
                    }
                }
            });
        }

        function renderExamMonth(list) {
            var html = "";

            list.forEach(function(exam) {
                html += '<div class="exam-item" style="margin-bottom: 10px; padding: 10px; border-bottom: 1px solid #eee;">';
                html += '  <div class="exam-title" style="font-weight: bold;">' + (exam.title || '제목 없음') + '</div>';
                html += '  <div class="exam-info" style="font-size: 0.9em; color: #666;">';
                html += '    과정: ' + (exam.subject || '-') + ' | 날짜: ' + (exam.examDate || '-') + '';
                html += '  </div>';
                html += '</div>';
            });

            $("#examMonthCard").html(html);
        }

        function loadClassrooms() {
            $.ajax({
                url: "/admin/classrooms/active",
                type: "GET",
                dataType: "json",
                success: function (response) {
                    if (response.success && response.list && response.list.length > 0) renderClassrooms(response.list);
                    else $("#classroomGrid").html('<div class="classroom-card">진행 중인 강의가 없습니다.</div>');
                }
            });
        }

        function renderClassrooms(classrooms) {
            var html = "";
            classrooms.forEach(function (room) {
                html += '<div class="classroom-card">';
                html += '  <div class="classroom-header">';
                html += '    <div class="classroom-number">' + (room.roomNumber || '미정') + ' 호</div>';
                html += '    <div class="classroom-time">시간대: ' + (room.timeSlot || '-') + '</div>';
                html += '  </div>';
                html += '  <div class="classroom-subject">' + (room.subject || '강의명 없음') + '</div>';
                html += '  <div class="classroom-period">' + (room.startDate || '-') + ' ~ ' + (room.endDate || '-') + '</div>';
                html += '</div>';
            });
            $("#classroomGrid").html(html);
        }

        // 수치 애니메이션
        function animateNumber(elementId, targetNumber) {
            var element = $("#" + elementId);
            var current = 0;
            var increment = targetNumber / 30;
            var timer = setInterval(function () {
                current += increment;
                if (current >= targetNumber) {
                    current = targetNumber;
                    clearInterval(timer);
                }
                element.text(Math.floor(current));
            }, 20);
        }

        // 대시보드 내의 이동 함수
        function goNoticeDetail(noticeId) {
            localStorage.setItem("pendingNoticeId", noticeId);

            location.href = "${CTX_PATH}/admin/notices";
        }
    </script>
</div>
</body>
</html>