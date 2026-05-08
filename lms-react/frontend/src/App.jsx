import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "./context/AuthContext";

// 레이아웃
import Layout from "./components/layout/Layout";
import ProtectedRoute from "./components/common/ProtectedRoute";

// 공개 페이지
import LoginPage from "./pages/login/LoginPage";

// 라우트 미등록 안내
import NotFoundPage from "./pages/NotFoundPage";

// 페이지 컴포넌트
import DashboardPage from "./pages/dashboard/DashboardPage";
import UserInfoPage from "./pages/mypage/UserInfoPage";
import CourseStatusPage from "./pages/mypage/CourseStatusPage";
import RegisterPage from "./pages/register/RegisterPage";
import LecturePage from "./pages/lecture/LecturePage";
import AttendancePage from "./pages/attendance/AttendancePage";
import HomeworkPage from "./pages/homework/HomeworkPage";
import ExamPage from "./pages/exam/ExamPage";
import InstructorExamPage from "./pages/exam/InsExamPage";
import MaterialPage from "./pages/material/MaterialPage";
import InsMaterialPage from "./pages/material/InsMaterialPage";
import QnaPage from "./pages/qna/QnaPage";
import SurveyPage from "./pages/survey/SurveyPage";
import NoticePage from "./pages/notice/NoticePage";
import AdminUsersPage from "./pages/admin/users/AdminUsersPage";
import AdminLecturePage from "./pages/admin/lecture/AdminLecturePage";
import AdminClassroomPage from "./pages/admin/classroom/AdminClassroomPage";
import AdminExamPage from "./pages/admin/exam/AdminExamPage";
import RegTest from "./pages/exam/RegTest";
import FindIdPage from "./pages/find/FindIdPage";
import FindPwPage from "./pages/find/FindPwPage";

/**
 * App.jsx - 라우팅 설정
 *
 * DB(tm_mnu_mst.mnu_url) 실제 경로 기준으로 매핑합니다.
 *
 * 새 페이지 추가 방법:
 *   1. src/pages/폴더/Page.jsx 생성
 *   2. 위에 import 추가
 *   3. 아래 <Route path="..." element={<Page />} /> 추가
 */
/** 루트(/) 접근 시 userType에 맞는 첫 페이지로 리다이렉트 */
function RootRedirect() {
  const { user } = useAuth();
  const landing = {
    A: "/admin/dashboard",
    I: "/inst/user-info",
    S: "/stu/user-info",
  };
  return (
    <Navigate to={landing[user?.userType] ?? "/admin/dashboard"} replace />
  );
}

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          {/* 공개 라우트 */}
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route path="/find-id" element={<FindIdPage />} />
          <Route path="/find-pw" element={<FindPwPage />} />

          {/* 루트(/) → 로그인 여부 + 권한에 따라 첫 페이지 분기 */}
          <Route
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<RootRedirect />} />
            <Route path="/survey/survey.do" element={<SurveyPage />} />
            <Route path="*" element={<NotFoundPage />} />
          </Route>

          {/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              관리자 (A) 메뉴
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */}
          <Route
            element={
              <ProtectedRoute allowedRoles={["A"]}>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route path="/admin/dashboard" element={<DashboardPage />} />

            {/* 시험 관리 */}
            <Route path="/admin/exam/schedule" element={<AdminExamPage />} />
            <Route path="/admin/test-exam" element={<AdminExamPage />} />

            {/* 강의 운영 */}
            <Route
              path="/admin/courseManagement"
              element={<AdminLecturePage />}
            />
            <Route path="/admin/classrooms" element={<AdminClassroomPage />} />

            {/* 사용자 관리 */}
            <Route path="/admin/stu" element={<AdminUsersPage />} />
            <Route path="/admin/inst" element={<AdminUsersPage />} />

            {/* 커뮤니티 관리 */}
            <Route path="/admin/qna" element={<QnaPage />} />
            <Route path="/admin/notices" element={<NoticePage />} />
          </Route>

          {/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              학생 (S) 메뉴
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */}

          {/* 수강 관리 */}
          <Route
            element={
              <ProtectedRoute allowedRoles={["S"]}>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route path="/stu/courses" element={<LecturePage />} />
            <Route path="/stu/my-courses" element={<LecturePage />} />

            {/* 학습 관리 */}
            <Route path="/stu/materials" element={<MaterialPage />} />
            <Route path="/stu/assignments" element={<HomeworkPage />} />
            <Route path="/stu/assignments-result" element={<HomeworkPage />} />
            <Route path="/stu/exams" element={<ExamPage />} />

            {/* 커뮤니티 */}
            <Route path="/stu/qna" element={<QnaPage />} />
            <Route path="/stu/notices" element={<NoticePage />} />

            {/* 마이페이지 */}
            <Route path="/stu/user-info" element={<UserInfoPage />} />
            <Route path="/stu/course-status" element={<CourseStatusPage />} />
          </Route>

          {/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              강사 (I) 메뉴
          ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */}

          {/* 나의 강의 관리 */}
          <Route
            element={
              <ProtectedRoute allowedRoles={["I"]}>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route path="/inst/course-list" element={<LecturePage />} />
            <Route path="/inst/attendance" element={<AttendancePage />} />
            <Route path="/inst/materials" element={<InsMaterialPage />} />
            <Route path="/inst/exams" element={<InstructorExamPage />} />
            <Route path="/inst/exam-register" element={<RegTest />} />
            <Route path="/inst/assignments" element={<HomeworkPage />} />
            <Route path="/inst/submissions" element={<HomeworkPage />} />

            {/* 커뮤니티 */}
            <Route path="/inst/qna" element={<QnaPage />} />
            <Route path="/inst/notices" element={<NoticePage />} />

            {/* 마이페이지 */}
            <Route path="/inst/user-info" element={<UserInfoPage />} />
            <Route path="/inst/course-status" element={<CourseStatusPage />} />
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
