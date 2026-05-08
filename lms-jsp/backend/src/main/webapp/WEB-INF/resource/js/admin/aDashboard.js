document.addEventListener('DOMContentLoaded', function() {

    // ============================
    // 오늘 시험 과목
    // GET /admin/dashboard/viewExam
    // ============================
    function loadMonthlyExams() {
        $.ajax({
            url: "/admin/dashboard/viewExam",
            type: "GET",
            success: function (data) {
                console.log("받은 데이터:", data);

                const examCards = document.getElementById('examCards');
                if (!examCards) return;

                examCards.innerHTML = '';

                // 이번 달 시험이 하나도 없을 때
                if (!data || data.length === 0) {
                    examCards.innerHTML = '<p class="empty">이번 달 시험이 없습니다.</p>';
                    return;
                }

                data.forEach(exam => {
                    const date = new Date(exam.testSchedule_date);

                    // 날짜 파싱 실패 방어
                    if (isNaN(date)) return;

                    const formattedDate = date.toISOString().slice(0, 10);

                    const card = document.createElement('div');
                    card.className = 'card';
                    card.innerHTML = `
                    <h4>${exam.testSchedule_title}</h4>
                    <p>과정: ${exam.course_title}</p>
                    <p>날짜: ${formattedDate}</p>
                `;

                    examCards.appendChild(card);
                });
            },
            error: function (xhr, status, error) {
                console.error("시험 목록 조회 실패:", error);
            }
        });
    }




    // ============================
    // 오늘 강의실
    // GET /admin/dashboard/viewClassrooms
    // ============================
    function loadTodayClasses() {
        $.ajax({
            url: "/admin/dashboard/viewClassrooms",
            type: "GET",
            success: function(data) {
                const classCards = document.getElementById('classCards');
                if (!classCards) return;

                classCards.innerHTML = '';

                data.forEach(cls => {
                    const card = document.createElement('div');
                    card.className = 'card';
                    card.innerHTML = `
                    <div class="card-header">
                        <h4>${cls.courseClass_className} 호</h4>
                        <span class="card-badge">시간대: ${cls.courseTime_startTime} ~ ${cls.courseTime_endTime}</span>
                    </div>
                    
                    <div class="card-body">
                        <p class="course-title">${cls.course_title}</p>
                        
                        <div class="date-range">
                            <div><span>기간</span>: ${cls.course_startDate.slice(0,10)} ~ ${cls.course_endDate.slice(0,10)}</div>
                        </div>
                    </div>
                `;
                    classCards.appendChild(card);
                });
            }
        });
    }

    // ============================
    // 사용자 통계 차트
    // GET /admin/dashboard/viewUsers
    // ============================
    let userStatsChart = null;  // 차트 인스턴스를 저장할 변수

    function loadUserStats() {
        $.ajax({
            url: "/admin/dashboard/viewUsers",
            type: "GET",
            success: function(stats) {
                const canvas = document.getElementById('userStatsChart');
                if (!canvas) return;

                const ctx = canvas.getContext('2d');

                // 기존 차트가 있으면 파괴
                if (userStatsChart) {
                    userStatsChart.destroy();
                }

                userStatsChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ['총 사용자', '학생', '강사', '이번달 신규'],
                        datasets: [{
                            data: [
                                stats.totalUsers,
                                stats.students,
                                stats.teachers,
                                stats.newUsers
                            ],
                            backgroundColor: [
                                '#4E73DF',
                                '#1CC88A',
                                '#36B9CC',
                                '#F6C23E'
                            ],
                            borderColor: [
                                '#2E59D9',
                                '#17A673',
                                '#2C9FAF',
                                '#E0B325'
                            ],
                            borderWidth: 2,
                            hoverBackgroundColor: [
                                '#224ABE',
                                '#169B6B',
                                '#258F9B',
                                '#D2A318'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: { display: false },
                        tooltips: {
                            callbacks: {
                                label: function(tooltipItem) {
                                    return tooltipItem.yLabel + " 명";
                                }
                            }
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    min: 0,
                                    stepSize: 5,
                                    beginAtZero: true,
                                    callback: function(value) {
                                        return value + " 명";
                                    }
                                }
                            }]
                        }
                    }

                });
            }
        });
    }


    // ============================
    // 공지사항 / 설문조사 / QnA
    // GET /admin/dashboard/viewCommunity
    // ============================
    function loadCommunity() {
        $.ajax({
            url: "/admin/dashboard/viewCommunity",
            type: "GET",
            success: function(data) {

                // 유틸: 리스트 출력
                const renderList = (id, items) => {
                    const ul = document.getElementById(id);
                    if (!ul) return;
                    ul.innerHTML = '';

                    items.forEach(item => {
                        const li = document.createElement('li');

                        // item이 QnA일 경우만 구조화
                        if (id === 'recentSurvey') {
                            li.innerHTML = `
                                <span class="survey-title">${item.title}</span>
                                <span class="survey-date">${item.date}</span>
                            `;
                        } else if (id === 'recentQnA') {
                            li.innerHTML = `
                                <span class="qna-title">${item.qnaPost_title}</span>
                                <span class="qna-status">${item.qnaPost_answerStatus === 'Y' ? '완료' : '미답변'}</span>
                            `;
                        } else if (id === 'recentNotice') {
                            // item이 객체라면 title과 date를 분리
                            li.innerHTML = `
                                <span class="notice-title">${item.title}</span>
                                <span class="notice-date">${item.date}</span>
                            `;
                        }
                        ul.appendChild(li);
                    });
                };

                // 공지사항
                renderList(
                    "recentNotice",
                    data.recentNotices.map(n => {
                        return {
                            title: n.notice_title,
                            date: n.notice_regDate.slice(0, 10)
                        };
                    })
                );

                // 설문조사
                renderList(
                    "recentSurvey",
                    data.recentSurveys.map(s => {
                        const date = s.survey_createAt.slice(0, 10);
                        return {
                            title: s.survey_title,
                            date: date
                        };
                    })
                );



                // QnA
                renderList("recentQnA", data.recentQnaPosts);
            }
        });
    }



    // ============================
    // 페이지 로드 시 실행
    // ============================
    loadMonthlyExams();
    loadTodayClasses();
    loadUserStats();
    loadCommunity();

});
