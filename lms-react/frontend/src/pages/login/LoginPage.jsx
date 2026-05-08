import { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import api from "../../api/axios";
import styles from "./LoginPage.module.css";

// ──────────────────────────────────────────────────────────
// 빠른 로그인 실서버 계정
// ──────────────────────────────────────────────────────────
const QUICK_CREDENTIALS = {
  admin: { lgn_Id: "admin", pwd: "admin" },
  inst: { lgn_Id: "happyjob_165576", pwd: "1234" },
  stu: { lgn_Id: "ham", pwd: "123" },
};

// ──────────────────────────────────────────────────────────
// 개발용 Mock 계정 (서버 없이 바로 로그인)
// ──────────────────────────────────────────────────────────
const MOCK_USERS = {
  admin: {
    loginId: "admin",
    userNm: "관리자",
    userType: "A",
    serverName: "mock",
    isMock: true,
    usrMnuAtrt: [
      {
        mnu_id: "T1001",
        mnu_nm: "대시보드",
        mnu_ico_cod: "dashboard",
        mnu_url: "/admin/dashboard",
        nodeList: [],
      },
      {
        mnu_id: "U1001",
        mnu_nm: "시험 관리",
        mnu_ico_cod: "exam",
        nodeList: [
          {
            mnu_id: "U1002",
            mnu_nm: "시험 일정",
            mnu_url: "/admin/exam/schedule",
          },
          { mnu_id: "U1003", mnu_nm: "시험 문제", mnu_url: "/admin/test-exam" },
        ],
      },
      {
        mnu_id: "V1001",
        mnu_nm: "강의 운영",
        mnu_ico_cod: "lecture",
        nodeList: [
          {
            mnu_id: "V1002",
            mnu_nm: "강의 목록",
            mnu_url: "/admin/courseManagement",
          },
          {
            mnu_id: "V1003",
            mnu_nm: "강의실 목록",
            mnu_url: "/admin/classrooms",
          },
        ],
      },
      {
        mnu_id: "X1001",
        mnu_nm: "사용자 관리",
        mnu_ico_cod: "users",
        mnu_url: "/admin/stu",
        mnu_related: ["/admin/stu", "/admin/inst"],
        nodeList: [],
      },
      {
        mnu_id: "Y1001",
        mnu_nm: "커뮤니티 관리",
        mnu_ico_cod: "qna",
        nodeList: [
          { mnu_id: "Y1002", mnu_nm: "Q&A", mnu_url: "/admin/qna" },
          {
            mnu_id: "Y1003",
            mnu_nm: "설문 조사",
            mnu_url: "/survey/survey.do",
          },
          { mnu_id: "Y1004", mnu_nm: "공지 사항", mnu_url: "/admin/notices" },
        ],
      },
    ],
  },
  inst: {
    loginId: "inst01",
    userNm: "강사",
    userType: "I",
    serverName: "mock",
    isMock: true,
    usrMnuAtrt: [
      {
        mnu_id: "i-course",
        mnu_nm: "나의 강의",
        mnu_ico_cod: "lecture",
        nodeList: [
          {
            mnu_id: "i-course-list",
            mnu_nm: "강의 목록",
            mnu_url: "/inst/course-list",
          },
          {
            mnu_id: "i-attendance",
            mnu_nm: "출결 관리",
            mnu_url: "/inst/attendance",
          },
          {
            mnu_id: "i-materials",
            mnu_nm: "강의 자료",
            mnu_url: "/inst/materials",
          },
        ],
      },
      {
        mnu_id: "i-exam",
        mnu_nm: "시험/과제",
        mnu_ico_cod: "exam",
        nodeList: [
          { mnu_id: "i-exams", mnu_nm: "시험 목록", mnu_url: "/inst/exams" },
          {
            mnu_id: "i-exam-register",
            mnu_nm: "시험 등록",
            mnu_url: "/inst/exam-register",
          },
          {
            mnu_id: "i-assignments",
            mnu_nm: "과제 관리",
            mnu_url: "/inst/assignments",
          },
          {
            mnu_id: "i-submissions",
            mnu_nm: "제출 현황",
            mnu_url: "/inst/submissions",
          },
        ],
      },
      {
        mnu_id: "i-community",
        mnu_nm: "커뮤니티",
        mnu_ico_cod: "qna",
        nodeList: [
          { mnu_id: "i-qna", mnu_nm: "Q&A", mnu_url: "/inst/qna" },
          { mnu_id: "i-notice", mnu_nm: "공지사항", mnu_url: "/inst/notices" },
        ],
      },
      {
        mnu_id: "i-mypage",
        mnu_nm: "마이페이지",
        mnu_ico_cod: "mypage",
        nodeList: [
          {
            mnu_id: "i-mypage-user-info",
            mnu_nm: "사용자 정보 관리",
            mnu_url: "/inst/user-info",
          },
          {
            mnu_id: "i-mypage-course-status",
            mnu_nm: "수강 현황",
            mnu_url: "/inst/course-status",
          },
        ],
      },
    ],
  },
  stu: {
    loginId: "stu01",
    userNm: "학생",
    userType: "S",
    serverName: "mock",
    isMock: true,
    usrMnuAtrt: [
      {
        mnu_id: "s-course",
        mnu_nm: "수강 관리",
        mnu_ico_cod: "lecture",
        mnu_url: "/stu/courses",
        mnu_related: ["/stu/courses", "/stu/my-courses"],
        nodeList: [],
      },
      {
        mnu_id: "s-study",
        mnu_nm: "학습 관리",
        mnu_ico_cod: "homework",
        nodeList: [
          {
            mnu_id: "s-materials",
            mnu_nm: "강의 자료",
            mnu_url: "/stu/materials",
          },
          {
            mnu_id: "s-assignments",
            mnu_nm: "과제",
            mnu_url: "/stu/assignments",
          },
          { mnu_id: "s-exams", mnu_nm: "시험", mnu_url: "/stu/exams" },
        ],
      },
      {
        mnu_id: "s-community",
        mnu_nm: "커뮤니티",
        mnu_ico_cod: "qna",
        nodeList: [
          { mnu_id: "s-qna", mnu_nm: "Q&A", mnu_url: "/stu/qna" },
          { mnu_id: "s-notice", mnu_nm: "공지사항", mnu_url: "/stu/notices" },
        ],
      },
      {
        mnu_id: "s-mypage",
        mnu_nm: "마이페이지",
        mnu_ico_cod: "mypage",
        nodeList: [
          {
            mnu_id: "s-mypage-user-info",
            mnu_nm: "사용자 정보 관리",
            mnu_url: "/stu/user-info",
          },
          {
            mnu_id: "s-mypage-course-status",
            mnu_nm: "수강 현황",
            mnu_url: "/stu/course-status",
          },
        ],
      },
    ],
  },
};

/**
 * 로그인 페이지
 *
 * 백엔드 API: POST /loginProc.do
 * 요청 파라미터: lgn_Id, pwd
 * 응답: { result: 'SUCCESS'|'FALSE', userNm, userType, usrMnuAtrt, ... }
 */
function LoginPage() {
  const navigate = useNavigate();
  const { login } = useAuth();

  const [form, setForm] = useState({ lgn_Id: "", pwd: "" });
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [saveId, setSaveId] = useState(false);

  // 페이지 로드 시 localStorage에 저장된 아이디가 있으면 불러오기
  useEffect(() => {
    const savedId = localStorage.getItem("savedId");
    if (savedId) {
      setSaveId(true);
      setForm((prev) => ({ ...prev, lgn_Id: savedId }));
    }
  }, []);

  // 빠른 로그인: 백서버 연결 시 실계정, 실패 시 mock(임시) fallback
  const handleMockLogin = async (role) => {
    const landing = {
      A: "/admin/dashboard",
      I: "/inst/user-info",
      S: "/stu/user-info",
    };

    try {
      const params = new URLSearchParams(QUICK_CREDENTIALS[role]);
      const response = await api.post("/loginProc.do", params);
      const data = response.data;

      if (data.result === "SUCCESS") {
        login({
          loginId: data.loginId,
          userNm: data.userNm,
          userType: data.userType,
          usrMnuAtrt: data.usrMnuAtrt,
          serverName: data.serverName,
        });
        navigate(landing[data.userType] ?? "/admin/dashboard");
        return;
      }
    } catch {
      // 백서버 미연결 → mock fallback
    }

    const mockData = MOCK_USERS[role];
    login({ ...mockData, userNm: `임시 ${mockData.userNm}` });
    navigate(landing[mockData.userType]);
  };

  // 입력값 변경 처리
  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  // 로그인 제출
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    if (!form.lgn_Id || !form.pwd) {
      setError("아이디와 비밀번호를 입력해 주세요.");
      return;
    }

    setLoading(true);
    try {
      // URLSearchParams: Spring MVC가 기본으로 받는 form 형식
      const params = new URLSearchParams();
      params.append("lgn_Id", form.lgn_Id);
      params.append("pwd", form.pwd);

      const response = await api.post("/loginProc.do", params);
      const data = response.data;

      if (data.result === "SUCCESS") {
        // 아이디 저장 체크 시 localStorage에 아이디 저장
        if (saveId) {
          localStorage.setItem("savedId", form.lgn_Id);
        } else {
          localStorage.removeItem("savedId");
        }

        // 임시 비밀번호인 경우 안내
        if (data.chk_tem_password === "Y") {
          alert(data.resultMsg);
        }

        // 사용자 정보를 Context에 저장
        login({
          loginId: data.loginId,
          userNm: data.userNm,
          userType: data.userType, // S: 학생 / I: 강사 / A: 관리자
          usrMnuAtrt: data.usrMnuAtrt, // 메뉴 권한 목록
          serverName: data.serverName,
        });

        // userType에 따라 첫 진입 경로 분기
        const landing = {
          A: "/admin/dashboard",
          I: "/inst/user-info",
          S: "/stu/user-info",
        };
        navigate(landing[data.userType] ?? "/dashboard");
      } else {
        setError(data.resultMsg || "로그인에 실패했습니다.");
      }
    } catch (err) {
      setError("서버와 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.");
      console.error("로그인 오류:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        {/* 로고 / 타이틀 */}
        <div className={styles.header}>
          <h1 className={styles.title}>HappyJob LMS</h1>
          <p className={styles.subtitle}>학습 관리 시스템</p>
        </div>

        {/* 로그인 폼 */}
        <form onSubmit={handleSubmit} className={styles.form}>
          <div className={styles.field}>
            <label htmlFor="lgn_Id" className={styles.label}>
              아이디
            </label>
            <input
              id="lgn_Id"
              type="text"
              name="lgn_Id"
              value={form.lgn_Id}
              onChange={handleChange}
              placeholder="아이디를 입력하세요"
              className={styles.input}
              autoComplete="username"
              autoFocus
            />
          </div>

          <div className={styles.field}>
            <label htmlFor="pwd" className={styles.label}>
              비밀번호
            </label>
            <input
              id="pwd"
              type="password"
              name="pwd"
              value={form.pwd}
              onChange={handleChange}
              placeholder="비밀번호를 입력하세요"
              className={styles.input}
              autoComplete="current-password"
            />
          </div>

          <div className={styles.options}>
            <label className={styles.checkboxLabel}>
              아이디 저장
              <input
                type="checkbox"
                checked={saveId}
                onChange={(e) => setSaveId(e.target.checked)}
              />
            </label>
          </div>

          {/* 에러 메시지 */}
          {error && <p className={styles.error}>{error}</p>}

          <button type="submit" className={styles.button} disabled={loading}>
            {loading ? "로그인 중..." : "로그인"}
          </button>
        </form>

        {/* 하단 링크 */}
        <div className={styles.links}>
          <Link to="/register" className={styles.link}>
            회원가입
          </Link>
          <span className={styles.divider}>|</span>
          <Link to="/find-id" className={styles.link}>
            아이디/비밀번호 찾기
          </Link>
        </div>

        {/* 개발용 빠른 로그인 */}
        <div className={styles.mockSection}>
          <p className={styles.mockLabel}>개발용 빠른 로그인</p>
          <div className={styles.mockButtons}>
            <button
              type="button"
              className={`${styles.mockBtn} ${styles.mockBtnAdmin}`}
              onClick={() => handleMockLogin("admin")}
            >
              관리자
            </button>
            <button
              type="button"
              className={`${styles.mockBtn} ${styles.mockBtnInst}`}
              onClick={() => handleMockLogin("inst")}
            >
              강사
            </button>
            <button
              type="button"
              className={`${styles.mockBtn} ${styles.mockBtnStu}`}
              onClick={() => handleMockLogin("stu")}
            >
              학생
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default LoginPage;
