# LMS-Project

LMS Project with Spring MVC

Team Project  
JSP 2026.3.11 ~ 2026.3.25  
React 2026.4.13 ~ 2026.4.27

**Java Spring MVC 기반 학습 관리 시스템 (Learning Management System)**

관리자 · 강사 · 학생 3개 역할을 지원하는 LMS입니다.  
동일한 백엔드를 공유하는 두 가지 버전이 존재합니다.

| 버전          | 프론트엔드       | 경로         |
| ------------- | ---------------- | ------------ |
| **lms-react** | React SPA (Vite) | `lms-react/` |
| **lms-jsp**   | JSP + jQuery     | `lms-jsp/`   |

---

## 기술 스택

### Backend (공통)

| 항목       | 버전 / 내용                                                   |
| ---------- | ------------------------------------------------------------- |
| Java       | 17                                                            |
| Spring MVC | 4.3.0.RELEASE                                                 |
| MyBatis    | XML Mapper 방식                                               |
| DB         | MySQL 8.0                                                     |
| 빌드       | Maven (WAR 패키징)                                            |
| 서버       | Tomcat                                                        |
| 기타       | Lombok, Apache POI (Excel), Gmail SMTP |

### Frontend

| 버전      | 기술                            |
| --------- | ------------------------------- |
| lms-react | React, Vite, Axios, CSS Modules |
| lms-jsp   | JSP, JSTL, jQuery, AJAX         |

---

## 시스템 아키텍처

```
[ 브라우저 ]
     │  HTTP / AJAX
     ▼
[ Spring DispatcherServlet ]
     │
     ├─ AuthCheckInterceptor (인증 체크)
     │
     ▼
[ Controller ]  (A- 관리자 / I- 강사 / S- 학생)
     │
     ▼
[ Service ]  ── @Transactional
     │
     ▼
[ DAO / MyBatis Mapper ]
     │  XML Mapper (sql/mapper/*/)
     ▼
[ MySQL DB : happyjob ]
```

**lms-react** 추가 구성:

```
[ React SPA (Vite, :3000) ]
     │  /api/** 또는 *.do → Proxy
     ▼
[ Spring Backend (:80) ]
```

---

## 프로젝트 구조

```
LMS-Project/
├── lms-react/
│   ├── backend/                   # Spring MVC 백엔드
│   │   └── src/main/
│   │       ├── java/kr/happyjob/study/
│   │       │   ├── common/        # 공통 (인터셉터, 필터, 스케줄러, WebSocket, 파일, 암호화)
│   │       │   ├── config/        # Spring 설정 (CORS, WebMVC, Scheduler)
│   │       │   ├── domain/
│   │       │   │   ├── admin/     # 관리자 도메인
│   │       │   │   ├── instructor/# 강사 도메인
│   │       │   │   ├── student/   # 학생 도메인
│   │       │   │   ├── dashboard/ # 대시보드
│   │       │   │   ├── homework/  # 과제
│   │       │   │   ├── login/     # 로그인/회원가입
│   │       │   │   ├── notice/    # 공지사항
│   │       │   │   └── survey/    # 설문
│   │       │   └── system/        # 시스템 관리 (공통코드, 메뉴)
│   │       ├── resources/
│   │       │   ├── sql/mapper/    # MyBatis XML Mapper (admin/ instructor/ student/)
│   │       │   └── happyjob*.properties
│   │       └── webapp/WEB-INF/
│   │           ├── applicationContext.xml
│   │           ├── mybatis-mysql-config.xml
│   │           └── web.xml
│   └── frontend/                  # React SPA
│       └── src/
│           ├── api/axios.js       # Axios 인스턴스 (수정 금지)
│           ├── context/AuthContext.jsx  # 전역 인증 상태 (수정 금지)
│           ├── components/
│           │   ├── layout/        # Header, Sidebar, Layout (수정 금지)
│           │   └── common/        # ProtectedRoute, PlaceholderPage
│           └── pages/             # 기능 구현 영역
│               ├── admin/         # 관리자 페이지
│               ├── attendance/    # 출결 관리
│               ├── dashboard/     # 대시보드
│               ├── exam/          # 시험
│               ├── homework/      # 과제
│               ├── lecture/       # 강의 목록
│               ├── material/      # 학습 자료
│               ├── mypage/        # 마이페이지
│               ├── notice/        # 공지사항
│               ├── qna/           # Q&A
│               └── survey/        # 설문
├── lms-jsp/
│   └── backend/                   # Spring MVC + JSP (백엔드 구조 동일)
└── LMS.sql                        # 전체 DB 스키마 + 초기 데이터
```

---

## 주요 기능

### 관리자 (A 계정)

| 기능           | URL                         | Controller                   |
| -------------- | --------------------------- | ---------------------------- |
| 대시보드       | `/admin/dashboard`          | `ADashboardController`       |
| 강의 목록 관리 | `/admin/courseManagement`   | `CourseManagementController` |
| 강의실 관리    | `/admin/classrooms`         | `CourseClassController`      |
| 시험 문제 관리 | `/admin/test-exam`          | `ATestController`            |
| 시험 일정 관리 | `/admin/exam/schedule`      | `ATestScheduleController`    |
| 학생/강사 관리 | `/admin/stu`, `/admin/inst` | `AUserController`            |
| Q&A 관리       | `/admin/qna`                | `AQnaController`             |
| 공지사항 관리  | `/admin/notices`            | `NoticeNewController`        |
| 설문 관리      | `/survey/survey.do`         | `SurveyController`           |

### 강사 (I 계정)

| 기능                | URL                                      | Controller              |
| ------------------- | ---------------------------------------- | ----------------------- |
| 강의 계획서         | `/inst/course-plan`                      | `ICoursePlanController` |
| 강의 목록           | `/inst/course-list`                      | `ICourseController`     |
| 출결 관리           | `/inst/attendance`                       | `IAttendanceController` |
| 학습 자료 등록      | `/inst/materials`                        | `IMaterialController`   |
| 시험 등록/목록      | `/inst/exams`, `/inst/exam-register`     | `ITestController`       |
| 과제 목록/제출 현황 | `/inst/assignments`, `/inst/submissions` | `IHomeworkController`   |
| Q&A 답변            | `/inst/qna`                              | `IQnaController`        |
| 마이페이지          | `/inst/my-page`                          | `IMypageController`     |

### 학생 (S 계정)

| 기능           | URL                                           | Controller            |
| -------------- | --------------------------------------------- | --------------------- |
| 전체/나의 강의 | `/stu/courses`, `/stu/my-courses`             | `SCourseController`   |
| 학습 자료      | `/stu/materials`                              | `SMaterialController` |
| 과제 목록/결과 | `/stu/assignments`, `/stu/assignments-result` | `SHomeworkController` |
| 시험 응시      | `/stu/exams`                                  | `STestController`     |
| Q&A            | `/stu/qna`                                    | `SQnaController`      |
| 마이페이지     | `/stu/my-page`                                | `SMypageController`   |

### 공개 페이지

| 기능          | URL         | API                         |
| ------------- | ----------- | --------------------------- |
| 로그인        | `/login`    | `POST /loginProc.do`        |
| 회원가입      | `/register` | `POST /register.do`         |
| 아이디 찾기   | `/find-id`  | `POST /selectFindInfo.do`   |
| 비밀번호 찾기 | `/find-pw`  | `POST /selectFindInfoPw.do` |

---

## DB 스키마

DB명: `happyjob` | 30개 테이블

| 분류     | 테이블                                                                         |
| -------- | ------------------------------------------------------------------------------ |
| 사용자   | `tb_userinfo`, `resume`                                                        |
| 강의     | `course`, `course_class`, `course_status`, `course_time`                       |
| 수강     | `student_course`, `student_course_status`                                      |
| 출결     | `course_attendance`, `attendance_status`                                       |
| 자료     | `course_materials`, `file`                                                     |
| 과제     | `homework`, `homework_file`, `submission`                                      |
| 시험     | `test_schedule`, `test_detail`, `student_test_schedule`, `student_test_answer` |
| 설문     | `survey`, `survey_question`, `survey_response`                                 |
| 커뮤니티 | `qna_post`, `qna_comment`, `qna_category`, `notice`, `tb_notice`               |
| 평가     | `instructor_evaluation`, `review`                                              |
| 시스템   | `tb_group_code`, `tb_detail_code`, `tm_mnu_mst`, `tn_usr_mnu_atrt`             |

---

## 로컬 실행 방법

### 사전 준비

- JDK 17
- MySQL 8.0
- Tomcat (버전 무관)
- Node.js (lms-react 프론트엔드 실행 시)

### 1. DB 설정

```sql
CREATE DATABASE happyjob CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

`LMS.sql` 파일을 MySQL Workbench 또는 CLI로 실행합니다.

```bash
mysql -u root -p happyjob < LMS.sql
```

### 2. 백엔드 설정

`lms-react/backend/src/main/webapp/WEB-INF/applicationContext.xml` 에서 DB 접속 정보 확인:

```xml
<property name="url" value="jdbc:mysql://localhost:3306/happyjob?..."/>
<property name="username" value="root"/>
<property name="password" value="admin"/>
```

필요 시 `happyjob-win.properties` 의 파일 업로드 경로도 확인합니다.

### 3. 백엔드 실행

IntelliJ 또는 Eclipse에서 Maven 프로젝트로 import 후 Tomcat에 배포합니다.  
기본 포트: **`:80`**

### 4. 프론트엔드 실행 (lms-react만 해당)

```bash
cd lms-react/frontend
npm install
npm run dev
```

브라우저에서 `http://localhost:3000` 접속

---

## 테스트 계정

| 역할       | 아이디            | 비밀번호 |
| ---------- | ----------------- | -------- |
| 관리자 (A) | `admin`           | `admin`  |
| 학생 (S)   | `ham`             | `123`    |
| 강사 (I)   | `happyjob_165576` | `1234`   |

---

## API 경로 규칙 (lms-react)

Vite 프록시 설정상 API 요청 경로는 `/api`로 시작하거나 `.do`로 끝나야 백엔드로 전달됩니다.

```
권장: /api/stu/courses
레거시: /loginProc.do
```

---

## 공통 인프라

| 항목          | 설명                                                                        |
| ------------- | --------------------------------------------------------------------------- |
| 인증          | `AuthCheckInterceptor` — 전체 경로 세션 체크, 로그인/회원가입/정적자원 제외 |
| 시험 상태     | `ExamStatusScheduler` — 시험 시작/종료 시각 기준 자동 상태 전환             |
| 파일 업로드   | `MultipartFile` — 최대 200MB, 세션 타임아웃 720분                          |
| 메일 발송     | Gmail SMTP (port 465, SSL) — 회원가입 인증·비밀번호 찾기                    |
| Excel         | Apache POI 기반 다운로드                                                    |
