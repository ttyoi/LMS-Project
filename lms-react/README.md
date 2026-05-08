# React 코드 작성 가이드

---

## 1. 화면 ↔ React 파일 ↔ 백엔드 API 매핑표

**프론트 기준 경로:** `frontend/src/pages/`

---

### 1.1 공개 페이지 (로그인 없이 접근 가능)

| 화면          | React 파일                              | URL 경로    | 백엔드 API                  |
| ------------- | --------------------------------------- | ----------- | --------------------------- |
| 로그인        | `pages/login/`<br>`LoginPage.jsx`       | `/login`    | `POST /loginProc.do`        |
| 회원가입      | `pages/register/`<br>`RegisterPage.jsx` | `/register` | `POST /register.do`         |
| 아이디 찾기   | `pages/find/`<br>`FindIdPage.jsx`       | `/find-id`  | `POST /selectFindInfo.do`   |
| 비밀번호 찾기 | `pages/find/`<br>`FindPwPage.jsx`       | `/find-pw`  | `POST /selectFindInfoPw.do` |

---

### 1.2 관리자 (A 계정)

| 메뉴                         | React 파일                                           | URL 경로                  | 백엔드 Controller                 |
| ---------------------------- | ---------------------------------------------------- | ------------------------- | --------------------------------- |
| 대시보드                     | `pages/dashboard/`<br>`DashboardPage.jsx`            | `/admin/dashboard`        | `ADashboardController.java`       |
| 시험 관리 <br> 시험 일정     | `pages/admin/exam/`<br>`AdminExamPage.jsx`           | `/admin/exam/schedule`    | `ATestScheduleController.java`    |
| 시험 관리 <br> 시험 문제     | `pages/admin/exam/`<br>`AdminExamPage.jsx`           | `/admin/test-exam`        | `ATestController.java`            |
| 강의 운영 <br> 강의 목록     | `pages/admin/lecture/`<br>`AdminLecturePage.jsx`     | `/admin/courseManagement` | `CourseManagementController.java` |
| 강의 운영 <br> 강의실 목록   | `pages/admin/classroom/`<br>`AdminClassroomPage.jsx` | `/admin/classrooms`       | `CourseClassController.java`      |
| 사용자 관리 <br> 학생 목록   | `pages/admin/users/`<br>`AdminUsersPage.jsx`         | `/admin/stu`              | `AUserController.java`            |
| 사용자 관리 <br> 강사 목록   | `pages/admin/users/`<br>`AdminUsersPage.jsx`         | `/admin/inst`             | `AUserController.java`            |
| 커뮤니티 관리 <br> Q&A       | `pages/qna/`<br>`QnaPage.jsx`                        | `/admin/qna`              | `AQnaController.java`             |
| 커뮤니티 관리 <br> 설문 조사 | `pages/survey/`<br>`SurveyPage.jsx`                  | `/survey/survey.do`       | `SurveyController.java`           |
| 커뮤니티 관리 <br> 공지 사항 | `pages/notice/`<br>`NoticePage.jsx`                  | `/admin/notices`          | `NoticeNewController.java`        |

---

### 1.3 학생 (S 계정)

| 메뉴                          | React 파일                              | URL 경로                  | 백엔드 Controller          |
| ----------------------------- | --------------------------------------- | ------------------------- | -------------------------- |
| 수강 관리 <br> 전체 강의 목록 | `pages/lecture/`<br>`LecturePage.jsx`   | `/stu/courses`            | `SCourseController.java`   |
| 수강 관리 <br> 나의 강의      | `pages/lecture/`<br>`LecturePage.jsx`   | `/stu/my-courses`         | `SCourseController.java`   |
| 학습 관리 <br> 학습 자료      | `pages/material/`<br>`MaterialPage.jsx` | `/stu/materials`          | `SMaterialController.java` |
| 학습 관리 <br> 과제 목록      | `pages/homework/`<br>`HomeworkPage.jsx` | `/stu/assignments`        | `SHomeworkController.java` |
| 학습 관리 <br> 과제 결과      | `pages/homework/`<br>`HomeworkPage.jsx` | `/stu/assignments-result` | `SHomeworkController.java` |
| 학습 관리 <br> 시험 목록      | `pages/exam/`<br>`ExamPage.jsx`         | `/stu/exams`              | `STestController.java`     |
| 커뮤니티 <br> Q&A             | `pages/qna/`<br>`QnaPage.jsx`           | `/stu/qna`                | `SQnaController.java`      |
| 커뮤니티 <br> 설문 조사       | `pages/survey/`<br>`SurveyPage.jsx`     | `/survey/survey.do`       | `SurveyController.java`    |
| 커뮤니티 <br> 공지 사항       | `pages/notice/`<br>`NoticePage.jsx`     | `/stu/notices`            | `NoticeNewController.java` |
| 마이페이지                    | `pages/mypage/`<br>`MyPage.jsx`         | `/stu/my-page`            | `SMypageController.java`   |

---

### 1.4 강사 (I 계정)

| 메뉴                                 | React 파일                                  | URL 경로              | 백엔드 Controller            |
| ------------------------------------ | ------------------------------------------- | --------------------- | ---------------------------- |
| 나의 강의 관리 <br> 강의 계획서      | `pages/attendance/`<br>`AttendancePage.jsx` | `/inst/course-plan`   | `ICoursePlanController.java` |
| 나의 강의 관리 <br> 강의 목록        | `pages/lecture/`<br>`LecturePage.jsx`       | `/inst/course-list`   | `ICourseController.java`     |
| 나의 강의 관리 <br> 출석 관리        | `pages/attendance/`<br>`AttendancePage.jsx` | `/inst/attendance`    | `IAttendanceController.java` |
| 나의 강의 관리 <br> 학습 자료        | `pages/material/`<br>`MaterialPage.jsx`     | `/inst/materials`     | `IMaterialController.java`   |
| 나의 강의 관리 <br> 시험 목록        | `pages/exam/`<br>`ExamPage.jsx`             | `/inst/exams`         | `ITestController.java`       |
| 나의 강의 관리 <br> 시험 등록        | `pages/exam/`<br>`ExamPage.jsx`             | `/inst/exam-register` | `ITestController.java`       |
| 나의 강의 관리 <br> 과제 목록        | `pages/homework/`<br>`HomeworkPage.jsx`     | `/inst/assignments`   | `IHomeworkController.java`   |
| 나의 강의 관리 <br> 제출된 과제 목록 | `pages/homework/`<br>`HomeworkPage.jsx`     | `/inst/submissions`   | `IHomeworkController.java`   |
| 커뮤니티 <br> Q&A                    | `pages/qna/`<br>`QnaPage.jsx`               | `/inst/qna`           | `IQnaController.java`        |
| 커뮤니티 <br> 설문 조사              | `pages/survey/`<br>`SurveyPage.jsx`         | `/survey/survey.do`   | `SurveyController.java`      |
| 커뮤니티 <br> 공지 사항              | `pages/notice/`<br>`NoticePage.jsx`         | `/inst/notices`       | `NoticeNewController.java`   |
| 마이페이지                           | `pages/mypage/`<br>`MyPage.jsx`             | `/inst/my-page`       | `IMypageController.java`     |

---

## 2. 프로젝트 구조

```
frontend/src/
├── api/
│   └── axios.js                  # API 요청 공통 설정 (건드리지 말 것)
├── context/
│   └── AuthContext.jsx            # 로그인 상태 관리 (건드리지 말 것)
├── components/
│   ├── layout/
│   │   ├── Layout.jsx             # 전체 레이아웃 틀 (건드리지 말 것)
│   │   ├── Sidebar.jsx            # 왼쪽 메뉴 (건드리지 말 것)
│   │   └── Header.jsx             # 상단 헤더 (건드리지 말 것)
│   └── common/
│       ├── ProtectedRoute.jsx     # 로그인 보호 라우트 (건드리지 말 것)
│       └── PlaceholderPage.jsx    # 임시 페이지 컴포넌트
└── pages/                         # ✅ 팀원이 작업하는 영역
    ├── login/LoginPage.jsx
    ├── register/RegisterPage.jsx
    ├── find/FindIdPage.jsx
    ├── find/FindPwPage.jsx
    ├── dashboard/DashboardPage.jsx
    ├── mypage/MyPage.jsx
    ├── lecture/LecturePage.jsx
    ├── attendance/AttendancePage.jsx
    ├── homework/HomeworkPage.jsx
    ├── exam/ExamPage.jsx
    ├── material/MaterialPage.jsx
    ├── qna/QnaPage.jsx
    ├── survey/SurveyPage.jsx
    ├── notice/NoticePage.jsx
    └── admin/
        ├── users/AdminUsersPage.jsx
        ├── lecture/AdminLecturePage.jsx
        ├── classroom/AdminClassroomPage.jsx
        └── exam/AdminExamPage.jsx
```

---

## 3. 어디를 수정하나요?

매핑표에서 담당 메뉴의 **React 파일**을 열면 아래와 같은 구조입니다.

```jsx
function 담당페이지() {
  return (
    <PlaceholderPage
      title="페이지 제목"
      description="설명"
      assignee="담당자를 입력하세요"
    />
  );
}
```

**`PlaceholderPage`를 지우고 실제 내용을 작성하면 됩니다.**

```jsx
function 담당페이지() {
  // ← 여기에 상태(useState), API 호출(useEffect) 등 작성

  return <div>{/* ← 여기에 화면 HTML(JSX) 작성 */}</div>;
}
```

---

## 4. 로그인 사용자 정보 가져오기

로그인한 사용자 정보가 필요하면 `useAuth` 훅을 사용합니다.

```jsx
import { useAuth } from "../../context/AuthContext";

function MyPage() {
  const { user } = useAuth();

  // user 객체 구조:
  // user.loginId   → 로그인 아이디
  // user.userNm    → 이름
  // user.userType  → 'S'(학생) / 'I'(강사) / 'A'(관리자)

  return <div>안녕하세요, {user.userNm}님</div>;
}
```

---

## 5. 백엔드 API 호출 방법

`api` 객체를 import해서 사용합니다. (세션 쿠키 자동 포함)

주의사항 (경로 규칙)<br>
프록시 설정 정책상, API 요청 경로는 /api로 시작하거나 .do로 끝나야만 백엔드로 올바르게 전달됩니다.

권장:<br>
백엔드 API 주소를 /api/stu/courses와 같이 /api 접두사를 붙여서 설계하는 것을 권장합니다.<br>
대안: 기존 레거시 주소를 유지해야 한다면 팀장을 통해서 프록시 설정을 추가해 주세요.

참고:<br>
개발 환경에서는 주소가 겹쳐도 동작할 수 있으나, 프론트엔드 라우트와 프록시 경로가 겹치면 배포 시 예기치 않은 오류(페이지 튕김 등)가 발생할 수 있습니다. 따라서 실 프로젝트에서는 반드시 경로를 분리하는 것을 원칙으로 합니다.

### GET 요청

```jsx
import { useState, useEffect } from 'react'
import api from '../../api/axios'

function MyPage() {
  const [data, setData] = useState([])

  useEffect(() => {
    api.get('/stu/courses')
      .then(res => setData(res.data))
      .catch(err => console.error(err))
  }, [])

  return ( ... )
}
```

### POST 요청

```jsx
import api from "../../api/axios";

// 파라미터 전송 (Spring MVC 기본 형식)
const params = new URLSearchParams();
params.append("키", "값");

api.post("/register.do", params).then((res) => {
  if (res.data.result === "SUCCESS") {
    alert("성공!");
  }
});
```

---

## 6. CSS 작성 방법

각 페이지 폴더에 `파일명.module.css`를 만들어서 사용합니다.  
다른 컴포넌트와 클래스명이 겹쳐도 자동으로 분리됩니다.

```
pages/mypage/
├── MyPage.jsx
└── MyPage.module.css   ← 새로 만들기
```

```css
/* MyPage.module.css */
.container {
  padding: 24px;
  background: #fff;
  border-radius: 12px;
}

.title {
  font-size: 20px;
  font-weight: 700;
}
```

```jsx
/* MyPage.jsx */
import styles from "./MyPage.module.css";

function MyPage() {
  return (
    <div className={styles.container}>
      <h2 className={styles.title}>마이페이지</h2>
    </div>
  );
}
```

---

## 7. 작성 순서 (한 페이지 기준)

1. **매핑표**에서 담당 메뉴의 **React 파일** 열기
2. `PlaceholderPage` 코드를 지우고 `function` 본문 작성 시작
3. `useEffect` + `api.get()`으로 데이터 불러오기
4. 불러온 데이터를 화면에 렌더링 (`return` 안에 JSX 작성)
5. 스타일이 필요하면 같은 폴더에 `*.module.css` 생성 후 적용
6. 추가 API가 필요하면 백엔드 담당자와 협의 후 Controller 확인

---

## 8. 주의사항

- `api/`, `context/`, `components/layout/` 폴더는 **수정하지 않기**
- `App.jsx`의 `<Route>`는 팀장 확인 후 수정 (라우트 충돌 방지)
- 파일명은 **PascalCase** 유지 (예: `MyPage.jsx`, `AdminExamPage.jsx`)
- `import` 경로는 `../../api/axios` 처럼 **상대 경로** 사용
- 코드 푸시 시 **main 브랜치에 바로 올리지 말고**, 본인 브랜치에서 작업 후 Pull Request(PR) 생성 → 단톡방에 공유 후 Merge

---

## 9. 실행

```bash
# frontend 폴더에서 실행
cd frontend
npm i (vite 등 라이브러리 설치)
npm run dev
```

브라우저에서 `http://localhost:3000` 접속  
(백엔드 서버 `http://localhost:80` 가 먼저 실행 중이어야 합니다)

---

## 10. 테스트 계정

| 구분       | 아이디            | 비밀번호 |
| ---------- | ----------------- | -------- |
| 관리자 (A) | `admin`           | `admin`  |
| 학생 (S)   | `ham`             | `123`    |
| 강사 (I)   | `happyjob_165576` | `1234`   |
