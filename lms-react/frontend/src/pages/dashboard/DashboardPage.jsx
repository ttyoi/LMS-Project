import PlaceholderPage from "../../components/common/PlaceholderPage";
import axios from "../../api/axios.js";
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import style from "./Dashboard.module.css";

/**
 * 대시보드 페이지
 * TODO: 이 파일을 수정하여 대시보드를 구현하세요.
 */

// 통계
function CountCard({ title, icon, count, label }) {
  return (
    <div className={style.cntCard}>
      <div className={style.cntCardItem}>
        <div className={style.cntCardTitle}>{title}</div>

        <div className={style.cntCardItemRow}>
          <span className={style.cntCardIcon}>{icon}</span>

          <div className={style.cntCardTextWrap}>
            <span className={style.cntCardCount}>{count}</span>
            <span className={style.cntCardLabel}>{label}</span>
          </div>
        </div>
      </div>
    </div>
  );
}

// 빠른메뉴
function QuickMenu({ to, icon, title, subTitle }) {
  return (
    <Link to={to}>
      <div className={style.menuCard}>
        <span className={style.menuIcon}>{icon}</span>
        <div className={style.menuTextWrap}>
          <span className={style.menuTitle}>{title}</span>
          <span className={style.menuSubTitle}>{subTitle}</span>
        </div>
      </div>
    </Link>
  );
}

function DashboardPage() {
  // 수업 중인 강의실
  const [classRoom, setClassRoom] = useState([]);
  useEffect(() => {
    axios
      .get("api/admin/classrooms/active")
      .then((response) => {
        console.log("!!!!!!!!!!!강의실!", response.data);
        setClassRoom(response.data.list ?? []);
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

  // 이번 달 시험 과목
  const [test, setTest] = useState([]);
  const today = new Date();
  const currentYear = today.getFullYear();
  const currentMonth = today.getMonth() + 1;
  useEffect(() => {
    axios
      .get("api/admin/exam/schedule/list")
      .then((response) => {
        console.log("--------------시험 정보>>>>>>>>>>>>", response.data);

        const filterTest = response.data.filter((item) => {
          const testDate = new Date(item.testSchedule_date);

          return (
            testDate.getFullYear() === currentYear &&
            testDate.getMonth() + 1 === currentMonth
          );
        });
        if (filterTest.length > 0) {
          const sortedTest = filterTest.sort((a, b) => {
            return (
              new Date(a.testSchedule_date) - new Date(b.testSchedule_date)
            );
          });
          setTest(sortedTest);
        } else {
          setTest([]);
        }
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

  // 공지사항
  const [notice, setNotice] = useState([]);
  useEffect(() => {
    axios
      .get("api/admin/notices/list")
      .then((response) => {
        console.log("----------DATA:", response.data);
        const noticeList = response.data.notice || [];
        let latestNotice = noticeList.slice();
        console.log(latestNotice);

        latestNotice = latestNotice.sort(
          (a, b) => new Date(b.reg_date) - new Date(a.reg_date),
        );

        latestNotice = latestNotice.slice(0, 4);
        latestNotice = latestNotice.map((item) => ({
          ...item,
          reg_date: new Date(item.reg_date).toLocaleDateString("sv-SE"),
        }));
        console.log("~~~~~~최신 공지 5개", latestNotice);

        setNotice(latestNotice);
      })
      .catch((err) => console.log(err));
  }, []);

  // 통계
  const [data, setData] = useState({
    cntInstructor: 0,
    cntStudent: 0,
    cntCourse: 0,
  });

  // count 효과용
  const [count, setCount] = useState({
    cntInstructor: 0,
    cntStudent: 0,
    cntCourse: 0,
  });

  // 학생, 강사, 과목 수 가져오기
  useEffect(() => {
    axios
      .get("/dashboard/goChart.do")
      .then((response) => {
        setData(response.data);
        console.log(response.data);
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

  // count 효과
  const duration = 2500;
  const frameRate = 1000 / 60;
  const totalFrame = Math.round(duration / frameRate);
  const easeOutExpo = (number) => {
    return number === 1 ? 1 : 1 - Math.pow(2, -10 * number);
  };

  useEffect(() => {
    let currentFrame = 0;
    const counter = setInterval(() => {
      currentFrame++;
      const progress = easeOutExpo(currentFrame / totalFrame);

      setCount({
        cntInstructor: Math.round(data.cntInstructor * progress),
        cntStudent: Math.round(data.cntStudent * progress),
        cntCourse: Math.round(data.cntCourse * progress),
      });

      if (progress === 1) {
        clearInterval(counter);
      }
    }, frameRate);
    return () => clearInterval(counter);
  }, [data]);

  return (
    <div className={style.dashboardContainer}>
      {/* 통계  */}
      <div className={style.cntCardContainer}>
        <CountCard
          title="전체 강사"
          icon="👩‍🏫"
          count={count.cntInstructor}
          label="명"
        ></CountCard>
        <CountCard
          title="전체 학생"
          icon="👨‍👩‍👧‍👧"
          count={count.cntStudent}
          label="명"
        ></CountCard>
        <CountCard
          title="전체 강좌"
          icon="&#128218;"
          count={count.cntCourse}
          label="강좌"
        ></CountCard>
      </div>
      <div className={style.dashboardWrap}>
        {/* 빠른 메뉴 */}
        <div className={style.quickMenu}>
          <span className={style.quickMenuTitle}>빠른메뉴</span>
          <div className={style.menuGrid}>
            <QuickMenu
              to="/admin/notices"
              icon="📢"
              title="공지사항"
              subTitle="공지사항관리"
            ></QuickMenu>
            <QuickMenu
              to="/admin/exam/schedule"
              icon="📆"
              title="시험일정"
              subTitle="시험일정관리"
            ></QuickMenu>
            <QuickMenu
              to="/admin/courseManagement"
              icon="&#128218;"
              title="강의관리"
              subTitle="강의목록관리"
            ></QuickMenu>
            <QuickMenu
              to="/admin/stu"
              icon="👨🏾‍🤝‍👨🏼"
              title="사용자관리"
              subTitle="강사 및 학생 관리"
            ></QuickMenu>
          </div>
        </div>
        {/* 최근 공지사항 */}
        <div className={style.shortNotice}>
          <span className={style.shortNoticeTitle}>최신 공지 사항</span>
          <div className={style.noticeList}>
            {notice.map((item) => (
              <Link
                to={`/admin/notices`}
                key={item.notice_id}
                className={style.noticeItem}
              >
                <span className={style.noticeTitle}>{item.title}</span>
                <span className={style.noticeDate}>{item.reg_date}</span>
              </Link>
            ))}
          </div>

          <Link to={"/admin/notices"} className={style.allNotice}>
            전체보기 →
          </Link>
        </div>
      </div>

      <div className={style.dashboardWrap}>
        {/* 이번 달 시험 과목 */}
        <div className={style.examSchedule}>
          <span className={style.shortNoticeTitle}>
            {currentMonth}월 시험 과목
          </span>
          <div className={style.examCard}>
            {test.length === 0 ? (
              <div className={style.emptyExam}>
                {currentMonth}월 시험 예정인 과목이 없습니다.
              </div>
            ) : (
              test.map((item) => (
                <div
                  className={style.examItem}
                  key={`${item.course_courseId}-${item.testSchedule_title}`}
                >
                  <span className={style.examData}>
                    {item.testSchedule_date.slice(8, 10)}일
                  </span>
                  <div className={style.examSubInfo}>
                    <div className={style.examTitle}>
                      {item.testSchedule_title}
                    </div>
                    <span className={style.examInstructor}>
                      {item.tbUserinfo_name} 강사
                    </span>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
        {/* 수업중인 강의실 */}
        <div className={style.classRoom}>
          <span className={style.shortNoticeTitle}>오늘 수업 중 강의실</span>
          <div className={style.classRoomList}>
            {classRoom.map((item) => (
              <div className={style.classRoomCard} key={item.roomNumber}>
                <div className={style.roomNumber}>{item.roomNumber}호</div>
                <div className={style.infoRow}>
                  <div className={style.subject}>{item.subject}</div>
                  <div className={style.timeSlot}>{item.timeSlot}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

export default DashboardPage;
