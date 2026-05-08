/**
 * 개발용 Mock Adapter
 *
 * isMock 유저로 로그인했을 때 실제 서버 통신 없이
 * 가짜 응답을 반환합니다.
 *
 * axios 요청 인터셉터에서 config.adapter를 교체하는 방식으로 동작합니다.
 */

// ── Mock 응답 데이터 ──────────────────────────────────────

const MOCK_STUDENT_LIST = [
  {
    loginID: "stu01",
    name: "이학생",
    phone: "010-1111-2222",
    status: "R",
    email: "stu01@test.com",
  },
  {
    loginID: "stu02",
    name: "김수강",
    phone: "010-3333-4444",
    status: "W",
    email: "stu02@test.com",
  },
  {
    loginID: "stu03",
    name: "박공부",
    phone: "010-5555-6666",
    status: "D",
    email: "stu03@test.com",
  },
  {
    loginID: "stu04",
    name: "최열공",
    phone: "010-7777-1234",
    status: "R",
    email: "stu04@test.com",
  },
  {
    loginID: "stu05",
    name: "정성실",
    phone: "010-9999-5678",
    status: "R",
    email: "stu05@test.com",
  },
];

const MOCK_INSTRUCTOR_LIST = [
  {
    loginID: "inst01",
    name: "김강사",
    phone: "010-7777-8888",
    status: "R",
    email: "inst01@test.com",
  },
  {
    loginID: "inst02",
    name: "이선생",
    phone: "010-9999-0000",
    status: "R",
    email: "inst02@test.com",
  },
  {
    loginID: "inst03",
    name: "박선생",
    phone: "010-2222-3333",
    status: "R",
    email: "inst03@test.com",
  },
  {
    loginID: "inst04",
    name: "최강사",
    phone: "010-4444-5555",
    status: "R",
    email: "inst04@test.com",
  },
  {
    loginID: "inst05",
    name: "정선생",
    phone: "010-6666-7777",
    status: "W",
    email: "inst05@test.com",
  },
];

const MOCK_USER_DETAIL = {
  loginID: "mock_user",
  name: "(Mock) 사용자",
  phone: "010-0000-0000",
  email: "mock@test.com",
  status: "R",
  addr1: "서울시 강남구",
  addr2: "테스트로 123",
  birth: "1990-01-01",
  gender: "M",
};

const MOCK_COURSE_LIST = [
  {
    courseId: "C001",
    courseNm: "(Mock) React 기초 과정",
    startDt: "2025-01-01",
    endDt: "2025-06-30",
  },
  {
    courseId: "C002",
    courseNm: "(Mock) Spring Boot 심화",
    startDt: "2025-03-01",
    endDt: "2025-08-31",
  },
  {
    courseId: "C003",
    courseNm: "(Mock) Vue.js 입문 과정",
    startDt: "2025-06-01",
    endDt: "2025-11-30",
  },
  {
    courseId: "C004",
    courseNm: "(Mock) Node.js 기초 과정",
    startDt: "2025-07-01",
    endDt: "2025-12-31",
  },
  {
    courseId: "C005",
    courseNm: "(Mock) Python 데이터 분석",
    startDt: "2025-09-01",
    endDt: "2026-02-28",
  },
];

// 시험 목록 (학생 시험 페이지용)
const MOCK_EXAM_COURSES = [
  { course_id: "C001", title: "(Mock) React 기초 과정" },
  { course_id: "C002", title: "(Mock) Spring Boot 심화" },
  { course_id: "C003", title: "(Mock) Vue.js 입문 과정" },
  { course_id: "C004", title: "(Mock) Node.js 기초 과정" },
  { course_id: "C005", title: "(Mock) Python 데이터 분석" },
];

const MOCK_EXAM_LIST = [
  { courseId: "C001", period: 1, title: "(Mock) React 기초 1차 시험", score: 85 },
  { courseId: "C001", period: 2, title: "(Mock) React 기초 2차 시험", score: null },
  { courseId: "C002", period: 1, title: "(Mock) Spring Boot 중간고사", score: 92 },
  { courseId: "C002", period: 2, title: "(Mock) Spring Boot 기말고사", score: null },
  { courseId: "C003", period: 1, title: "(Mock) Vue.js 1차 평가", score: 78 },
];

const MOCK_EXAM_QUESTIONS = [
  {
    questionNo: 1,
    content: "(Mock) React에서 상태(state)를 관리하는 훅은?",
    option1: "useEffect",
    option2: "useState",
    option3: "useRef",
    option4: "useContext",
  },
  {
    questionNo: 2,
    content: "(Mock) Virtual DOM의 주요 장점은?",
    option1: "메모리 절약",
    option2: "보안 강화",
    option3: "렌더링 성능 최적화",
    option4: "서버 부하 감소",
  },
  {
    questionNo: 3,
    content: "(Mock) JSX란 무엇인가?",
    option1: "JavaScript 라이브러리",
    option2: "CSS 전처리기",
    option3: "JavaScript XML 문법 확장",
    option4: "HTTP 통신 방식",
  },
  {
    questionNo: 4,
    content: "(Mock) React에서 부모-자식 간 데이터 전달 방식은?",
    option1: "state",
    option2: "props",
    option3: "context",
    option4: "ref",
  },
  {
    questionNo: 5,
    content: "(Mock) useEffect의 두 번째 인자(의존성 배열)가 빈 배열일 때 실행 시점은?",
    option1: "매 렌더링마다",
    option2: "컴포넌트 마운트 시 1회",
    option3: "언마운트 시",
    option4: "상태 변경 시마다",
  },
];

const MOCK_EXAM_RESULT = {
  title: "(Mock) React 기초 1차 시험",
  totalScore: 85,
  questions: [
    {
      questionNo: 1,
      content: "(Mock) React에서 상태(state)를 관리하는 훅은?",
      studentAnswer: 2,
      correctAnswer: 2,
      comment: null,
    },
    {
      questionNo: 2,
      content: "(Mock) Virtual DOM의 주요 장점은?",
      studentAnswer: 1,
      correctAnswer: 3,
      comment: "Virtual DOM은 실제 DOM 조작 최소화로 렌더링 성능을 높입니다.",
    },
    {
      questionNo: 3,
      content: "(Mock) JSX란 무엇인가?",
      studentAnswer: 3,
      correctAnswer: 3,
      comment: null,
    },
  ],
};

// 학습자료 목록 (학생 학습자료 페이지용)
const MOCK_MATERIAL_LIST = [
  { materialId: "M001", title: "(Mock) React Hooks 정리", courseName: "React 기초 과정", regDate: "2025-03-10" },
  { materialId: "M002", title: "(Mock) 컴포넌트 설계 가이드", courseName: "React 기초 과정", regDate: "2025-03-15" },
  { materialId: "M003", title: "(Mock) Spring MVC 구조 설명", courseName: "Spring Boot 심화", regDate: "2025-04-01" },
  { materialId: "M004", title: "(Mock) REST API 설계 원칙", courseName: "Spring Boot 심화", regDate: "2025-04-05" },
  { materialId: "M005", title: "(Mock) Vue.js 컴포넌트 기초", courseName: "Vue.js 입문 과정", regDate: "2025-06-10" },
];

const MOCK_MATERIAL_DETAIL = {
  materialId: "M001",
  title: "(Mock) React Hooks 정리",
  courseName: "React 기초 과정",
  content: "(Mock) useState, useEffect, useRef, useContext 등 주요 훅의 사용법을 정리한 자료입니다.\n\n각 훅의 목적과 예제 코드가 포함되어 있습니다.",
  fileName: "react_hooks_guide.pdf",
  regDate: "2025-03-10",
};

// 공지사항 목록
const MOCK_NOTICE_LIST = [
  { notice_id: 1, title: "(Mock) 2025년 1학기 개강 안내", user: "관리자", reg_date: "1743033600000", view_count: 42 },
  { notice_id: 2, title: "(Mock) 학습 시스템 점검 안내 (4/20 새벽 2시~4시)", user: "관리자", reg_date: "1742688000000", view_count: 31 },
  { notice_id: 3, title: "(Mock) 과제 제출 기한 연장 안내", user: "김강사", reg_date: "1742256000000", view_count: 18 },
  { notice_id: 4, title: "(Mock) 중간고사 일정 공지", user: "관리자", reg_date: "1741651200000", view_count: 55 },
  { notice_id: 5, title: "(Mock) 강의실 변경 안내 (B동 → A동 301호)", user: "김강사", reg_date: "1741305600000", view_count: 27 },
];

const MOCK_NOTICE_DETAIL = {
  notice_id: 1,
  title: "(Mock) 2025년 1학기 개강 안내",
  content: "(Mock) 2025년 1학기 개강일은 3월 3일(월)입니다.\n\n수강 신청은 2월 17일(월)부터 2월 28일(금)까지 진행됩니다.\n문의사항은 학사지원팀으로 연락 바랍니다.",
  user: "관리자",
  loginID: "admin",
  reg_date: "1743033600000",
  view_count: 43,
};

// 과제 목록 (강사/학생 공통)
const MOCK_HOMEWORK_LIST = [
  {
    homework_code: 1,
    homework_title: "(Mock) React 컴포넌트 구현 과제",
    course_name: "React 기초 과정",
    teacher_name: "김강사",
    start_date: "2025-03-10",
    end_date: "2025-03-20",
    file_id: null,
    submission_code: null,
    score: null,
    feedback: null,
    submit_date: null,
    status: "진행중",
  },
  {
    homework_code: 2,
    homework_title: "(Mock) Spring REST API 설계 과제",
    course_name: "Spring Boot 심화",
    teacher_name: "이선생",
    start_date: "2025-03-01",
    end_date: "2025-03-15",
    file_id: 10,
    submission_code: 5,
    score: 90,
    feedback: "잘 작성되었습니다.",
    submit_date: "2025-03-14",
    status: "마감",
  },
  {
    homework_code: 3,
    homework_title: "(Mock) MyBatis Mapper 작성 과제",
    course_name: "Spring Boot 심화",
    teacher_name: "이선생",
    start_date: "2025-04-01",
    end_date: "2025-04-14",
    file_id: null,
    submission_code: null,
    score: null,
    feedback: null,
    submit_date: null,
    status: "진행중",
  },
  {
    homework_code: 4,
    homework_title: "(Mock) Vue.js Todo 앱 구현 과제",
    course_name: "Vue.js 입문 과정",
    teacher_name: "박선생",
    start_date: "2025-06-15",
    end_date: "2025-06-25",
    file_id: 15,
    submission_code: 8,
    score: 95,
    feedback: "완성도가 높습니다.",
    submit_date: "2025-06-24",
    status: "마감",
  },
  {
    homework_code: 5,
    homework_title: "(Mock) Node.js Express 서버 구축 과제",
    course_name: "Node.js 기초 과정",
    teacher_name: "최강사",
    start_date: "2025-07-10",
    end_date: "2025-07-20",
    file_id: null,
    submission_code: null,
    score: null,
    feedback: null,
    submit_date: null,
    status: "진행중",
  },
];

const MOCK_SUBMISSION_LIST = [
  {
    submission_code: 1,
    student_name: "이학생",
    student_id: "stu01",
    course_name: "React 기초 과정",
    homework_title: "(Mock) React 컴포넌트 구현 과제",
    submit_date: "2025-03-18",
    end_date: "2025-03-20",
    score: null,
    feedback: null,
  },
  {
    submission_code: 2,
    student_name: "김수강",
    student_id: "stu02",
    course_name: "React 기초 과정",
    homework_title: "(Mock) React 컴포넌트 구현 과제",
    submit_date: "2025-03-19",
    end_date: "2025-03-20",
    score: 85,
    feedback: "전반적으로 잘 구현했습니다.",
  },
  {
    submission_code: 3,
    student_name: "박공부",
    student_id: "stu03",
    course_name: "React 기초 과정",
    homework_title: "(Mock) React 컴포넌트 구현 과제",
    submit_date: "2025-03-20",
    end_date: "2025-03-20",
    score: 70,
    feedback: "기능은 구현됐으나 코드 정리가 필요합니다.",
  },
  {
    submission_code: 4,
    student_name: "최열공",
    student_id: "stu04",
    course_name: "Spring Boot 심화",
    homework_title: "(Mock) Spring REST API 설계 과제",
    submit_date: "2025-03-13",
    end_date: "2025-03-15",
    score: null,
    feedback: null,
  },
  {
    submission_code: 5,
    student_name: "정성실",
    student_id: "stu05",
    course_name: "Spring Boot 심화",
    homework_title: "(Mock) Spring REST API 설계 과제",
    submit_date: "2025-03-14",
    end_date: "2025-03-15",
    score: 88,
    feedback: "API 명세가 명확합니다.",
  },
];

const MOCK_SUBMITTED_LIST = [
  {
    submission_code: 5,
    course_name: "Spring Boot 심화",
    homework_title: "(Mock) Spring REST API 설계 과제",
    submit_date: "2025-03-14",
    status: 1,
    score: 90,
    feedback: "잘 작성되었습니다.",
  },
  {
    submission_code: 8,
    course_name: "Vue.js 입문 과정",
    homework_title: "(Mock) Vue.js Todo 앱 구현 과제",
    submit_date: "2025-06-24",
    status: 1,
    score: 95,
    feedback: "완성도가 높습니다.",
  },
  {
    submission_code: 9,
    course_name: "React 기초 과정",
    homework_title: "(Mock) React 컴포넌트 구현 과제",
    submit_date: "2025-03-19",
    status: 0,
    score: null,
    feedback: null,
  },
  {
    submission_code: 10,
    course_name: "Node.js 기초 과정",
    homework_title: "(Mock) Node.js Express 서버 구축 과제",
    submit_date: "2025-07-18",
    status: 0,
    score: null,
    feedback: null,
  },
  {
    submission_code: 11,
    course_name: "Spring Boot 심화",
    homework_title: "(Mock) MyBatis Mapper 작성 과제",
    submit_date: "2025-04-12",
    status: 1,
    score: 82,
    feedback: "동적 쿼리 처리가 잘 되어 있습니다.",
  },
];

// 강의 목록 (강사/학생)
const MOCK_STU_COURSE_LIST = [
  {
    course_id: "1",
    title: "(Mock) React 기초 과정",
    inst_name: "김강사",
    class_name: "A강의실",
    start_date: "2026-03-02",
    end_date: "2026-08-28",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "1",
  },
  {
    course_id: "2",
    title: "(Mock) Spring Boot 심화",
    inst_name: "이선생",
    class_name: "B강의실",
    start_date: "2026-03-02",
    end_date: "2026-08-28",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "1",
  },
  {
    course_id: "3",
    title: "(Mock) Vue.js 입문 과정",
    inst_name: "박선생",
    class_name: "C강의실",
    start_date: "2026-06-01",
    end_date: "2026-11-27",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "0",
  },
  {
    course_id: "4",
    title: "(Mock) Node.js 기초 과정",
    inst_name: "최강사",
    class_name: "D강의실",
    start_date: "2026-07-06",
    end_date: "2026-12-25",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "0",
  },
  {
    course_id: "5",
    title: "(Mock) Python 데이터 분석",
    inst_name: "정선생",
    class_name: "E강의실",
    start_date: "2026-09-01",
    end_date: "2027-02-26",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "0",
  },
];

const MOCK_INST_COURSE_LIST = [
  {
    course_id: "1",
    title: "(Mock) React 기초 과정",
    class_name: "A강의실",
    start_date: "2026-03-02",
    end_date: "2026-08-28",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "1",
    content: "(Mock) React의 기초부터 실무까지 다루는 과정입니다.",
    plan: "(Mock) 1주차: JSX / 2주차: 컴포넌트 / 3주차: 상태관리",
    notice: "(Mock) 노트북 지참 필수",
  },
  {
    course_id: "2",
    title: "(Mock) Spring Boot 심화",
    class_name: "B강의실",
    start_date: "2026-03-02",
    end_date: "2026-08-28",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "1",
    content: "(Mock) Spring Boot와 MyBatis를 활용한 백엔드 개발 과정입니다.",
    plan: "(Mock) 1주차: Spring MVC / 2주차: MyBatis / 3주차: Security",
    notice: "(Mock) Java 기초 지식 필수",
  },
  {
    course_id: "3",
    title: "(Mock) Vue.js 입문 과정",
    class_name: "C강의실",
    start_date: "2026-06-01",
    end_date: "2026-11-27",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "0",
    content: "(Mock) Vue.js 3 Composition API 기반 프론트엔드 개발 과정입니다.",
    plan: "(Mock) 1주차: Vue 기초 / 2주차: Pinia / 3주차: Vue Router",
    notice: "(Mock) HTML/CSS/JS 기초 필수",
  },
  {
    course_id: "4",
    title: "(Mock) Node.js 기초 과정",
    class_name: "D강의실",
    start_date: "2026-07-06",
    end_date: "2026-12-25",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "0",
    content: "(Mock) Node.js와 Express를 활용한 서버 개발 과정입니다.",
    plan: "(Mock) 1주차: Node 기초 / 2주차: Express / 3주차: MongoDB",
    notice: "(Mock) JavaScript 기초 필수",
  },
  {
    course_id: "5",
    title: "(Mock) Python 데이터 분석",
    class_name: "E강의실",
    start_date: "2026-09-01",
    end_date: "2027-02-26",
    start_time: "09:00",
    end_time: "18:00",
    cos_sta_code: "0",
    content: "(Mock) Python을 활용한 데이터 분석 및 시각화 과정입니다.",
    plan: "(Mock) 1주차: Pandas / 2주차: NumPy / 3주차: Matplotlib",
    notice: "(Mock) Python 기초 권장",
  },
];

const MOCK_CLASS_LIST = [
  { class_id: "R001", class_name: "A강의실", people_limit: 30 },
  { class_id: "R002", class_name: "B강의실", people_limit: 25 },
  { class_id: "R003", class_name: "C강의실", people_limit: 20 },
  { class_id: "R004", class_name: "D강의실", people_limit: 28 },
  { class_id: "R005", class_name: "E강의실", people_limit: 22 },
];

const MOCK_TIME_LIST = [
  { time_code: "T01", start_time: "09:00", end_time: "18:00" },
  { time_code: "T02", start_time: "13:00", end_time: "22:00" },
  { time_code: "T03", start_time: "09:00", end_time: "13:00" },
  { time_code: "T04", start_time: "14:00", end_time: "18:00" },
  { time_code: "T05", start_time: "18:00", end_time: "22:00" },
];

// Q&A 목록
const MOCK_QNA_LIST = [
  {
    postId: 1,
    title: "(Mock) React useState 사용법이 궁금합니다",
    content: "(Mock) useState를 여러 개 사용할 때 성능 이슈가 있나요?",
    categoryCode: "CAT01",
    writerName: "이학생",
    reg_date: "2025-04-10",
    commentCount: 1,
  },
  {
    postId: 2,
    title: "(Mock) Spring Boot 의존성 주입 오류",
    content: "(Mock) @Autowired 사용 시 NullPointerException이 발생합니다.",
    categoryCode: "CAT02",
    writerName: "김수강",
    reg_date: "2025-04-09",
    commentCount: 2,
  },
  {
    postId: 3,
    title: "(Mock) MyBatis resultMap 매핑 오류",
    content: "(Mock) snake_case 컬럼이 camelCase 필드로 매핑이 안 됩니다.",
    categoryCode: "CAT02",
    writerName: "박공부",
    reg_date: "2025-04-08",
    commentCount: 0,
  },
  {
    postId: 4,
    title: "(Mock) Vue.js props 전달 방식 질문",
    content: "(Mock) 부모에서 자식 컴포넌트로 객체를 전달할 때 반응성이 유지되나요?",
    categoryCode: "CAT01",
    writerName: "최열공",
    reg_date: "2025-04-07",
    commentCount: 1,
  },
  {
    postId: 5,
    title: "(Mock) Node.js 비동기 처리 질문",
    content: "(Mock) async/await와 Promise.all의 차이가 무엇인가요?",
    categoryCode: "CAT03",
    writerName: "정성실",
    reg_date: "2025-04-06",
    commentCount: 0,
  },
];

const MOCK_QNA_CATEGORIES = [
  { categoryCode: "CAT01", categoryName: "프론트엔드" },
  { categoryCode: "CAT02", categoryName: "백엔드" },
  { categoryCode: "CAT03", categoryName: "기타" },
  { categoryCode: "CAT04", categoryName: "데이터베이스" },
  { categoryCode: "CAT05", categoryName: "네트워크/인프라" },
];

const MOCK_QNA_COMMENTS = [
  {
    postId: 1, commentId: 1, writerName: "김강사", loginID: "inst01",
    content: "(Mock) useState는 여러 개 사용해도 성능 이슈가 없습니다. useReducer 사용을 고려해보세요.",
    isTeacher: "Y",
  },
  {
    postId: 2, commentId: 2, writerName: "이선생", loginID: "inst02",
    content: "(Mock) @Autowired 대신 생성자 주입 방식을 권장합니다. final 필드와 함께 사용해보세요.",
    isTeacher: "Y",
  },
  {
    postId: 2, commentId: 3, writerName: "김강사", loginID: "inst01",
    content: "(Mock) 컴포넌트가 Spring 컨텍스트에 등록되었는지 확인해보세요.",
    isTeacher: "Y",
  },
  {
    postId: 4, commentId: 4, writerName: "박선생", loginID: "inst03",
    content: "(Mock) Vue.js에서 객체를 props로 전달하면 반응성이 유지됩니다.",
    isTeacher: "Y",
  },
  {
    postId: 1, commentId: 5, writerName: "이학생", loginID: "stu01",
    content: "(Mock) 감사합니다! useReducer도 공부해보겠습니다.",
    isTeacher: "N",
  },
];

// 설문조사 데이터
const MOCK_SURVEY_LIST = [
  { surveyId: 1, title: "(Mock) React 과정 만족도 설문", loginName: "김강사", createdAt: "2025-04-10", useYn: "Y", courseId: "C001" },
  { surveyId: 2, title: "(Mock) Spring Boot 강의 만족도", loginName: "이선생", createdAt: "2025-04-08", useYn: "Y", courseId: "C002" },
  { surveyId: 3, title: "(Mock) 교육 환경 개선 설문", loginName: "관리자", createdAt: "2025-04-05", useYn: "N", courseId: "C001" },
];

const MOCK_SURVEY_QUESTIONS = {
  1: [
    { questionId: 101, content: "매우 만족", type: "TEXT" },
    { questionId: 102, content: "만족", type: "TEXT" },
    { questionId: 103, content: "보통", type: "TEXT" },
    { questionId: 104, content: "불만족", type: "TEXT" },
  ],
  2: [
    { questionId: 201, content: "매우 좋음", type: "TEXT" },
    { questionId: 202, content: "좋음", type: "TEXT" },
    { questionId: 203, content: "나쁨", type: "TEXT" },
  ],
  3: [
    { questionId: 301, content: "시설 개선 필요", type: "TEXT" },
    { questionId: 302, content: "현재 수준 적절", type: "TEXT" },
    { questionId: 303, content: "더 좋아졌으면 함", type: "TEXT" },
  ],
};

const MOCK_SURVEY_CHART = {
  1: [
    { questionId: 101, content: "매우 만족", count: 8 },
    { questionId: 102, content: "만족", count: 12 },
    { questionId: 103, content: "보통", count: 5 },
    { questionId: 104, content: "불만족", count: 2 },
  ],
  2: [
    { questionId: 201, content: "매우 좋음", count: 10 },
    { questionId: 202, content: "좋음", count: 7 },
    { questionId: 203, content: "나쁨", count: 1 },
  ],
  3: [
    { questionId: 301, content: "시설 개선 필요", count: 6 },
    { questionId: 302, content: "현재 수준 적절", count: 9 },
    { questionId: 303, content: "더 좋아졌으면 함", count: 4 },
  ],
};

const MOCK_SURVEY_COURSE_LIST = [
  { courseId: "C001", className: "A강의실", title: "React 기초 과정" },
  { courseId: "C002", className: "B강의실", title: "Spring Boot 심화" },
  { courseId: "C003", className: "C강의실", title: "Vue.js 입문" },
];

// 대시보드 데이터
const MOCK_DASHBOARD_CHART = {
  cntInstructor: 12,
  cntStudent: 148,
  cntCourse: 6,
};

const MOCK_ACTIVE_CLASSROOMS = [
  { roomNumber: "A강의실", subject: "(Mock) React 기초 과정", timeSlot: "09:00 ~ 18:00" },
  { roomNumber: "B강의실", subject: "(Mock) Spring Boot 심화", timeSlot: "09:00 ~ 18:00" },
  { roomNumber: "C강의실", subject: "(Mock) Vue.js 입문 과정", timeSlot: "09:00 ~ 18:00" },
  { roomNumber: "D강의실", subject: "(Mock) Node.js 기초 과정", timeSlot: "13:00 ~ 22:00" },
  { roomNumber: "E강의실", subject: "(Mock) Python 데이터 분석", timeSlot: "09:00 ~ 13:00" },
];

const MOCK_EXAM_SCHEDULE = [
  {
    testSchedule_date: "2025-04-25",
    testSchedule_title: "(Mock) React 기초 1차 시험",
    course_courseId: "C001",
    tbUserinfo_name: "이학생",
  },
  {
    testSchedule_date: "2025-05-10",
    testSchedule_title: "(Mock) Spring Boot 중간고사",
    course_courseId: "C002",
    tbUserinfo_name: "김수강",
  },
  {
    testSchedule_date: "2025-06-20",
    testSchedule_title: "(Mock) Vue.js 1차 평가",
    course_courseId: "C003",
    tbUserinfo_name: "박공부",
  },
  {
    testSchedule_date: "2025-07-15",
    testSchedule_title: "(Mock) React 기초 2차 시험",
    course_courseId: "C001",
    tbUserinfo_name: "최열공",
  },
  {
    testSchedule_date: "2025-08-05",
    testSchedule_title: "(Mock) Spring Boot 기말고사",
    course_courseId: "C002",
    tbUserinfo_name: "정성실",
  },
];

// 출석 관리 - 강의 목록
const MOCK_ATT_COURSE_LIST = {
  list: [
    {
      course_id: "C001",
      title: "(Mock) React 기초 과정",
      inst_name: "임시 강사",
      class_name: "A강의실",
      start_date: "2026-01-05",
      end_date: "2026-07-31",
      stu_cnt: 18,
      people_limit: 30,
    },
    {
      course_id: "C002",
      title: "(Mock) Spring Boot 심화",
      inst_name: "임시 강사",
      class_name: "B강의실",
      start_date: "2026-03-02",
      end_date: "2026-08-28",
      stu_cnt: 22,
      people_limit: 25,
    },
    {
      course_id: "C003",
      title: "(Mock) Vue.js 입문 과정",
      inst_name: "임시 강사",
      class_name: "C강의실",
      start_date: "2026-06-01",
      end_date: "2026-11-27",
      stu_cnt: 10,
      people_limit: 20,
    },
    {
      course_id: "C004",
      title: "(Mock) Node.js 기초 과정",
      inst_name: "임시 강사",
      class_name: "D강의실",
      start_date: "2026-07-06",
      end_date: "2026-12-25",
      stu_cnt: 5,
      people_limit: 28,
    },
    {
      course_id: "C005",
      title: "(Mock) Python 데이터 분석",
      inst_name: "임시 강사",
      class_name: "E강의실",
      start_date: "2026-09-01",
      end_date: "2027-02-26",
      stu_cnt: 0,
      people_limit: 22,
    },
  ],
  totalCount: 5,
};

// 출석 관리 - 강의별 학생 목록
const MOCK_ATT_STUDENT_LIST = {
  list: [
    { stu_loginID: "stu01", stu_name: "이학생", prof_name: "임시 강사", course_id: "C001", today_att_code: null, att_cnt: 18, att_per_cnt: 1, att_leav_cnt: 0, att_out_cnt: 1, att_abs_cnt: 0 },
    { stu_loginID: "stu02", stu_name: "김수강", prof_name: "임시 강사", course_id: "C001", today_att_code: null, att_cnt: 15, att_per_cnt: 2, att_leav_cnt: 1, att_out_cnt: 0, att_abs_cnt: 2 },
    { stu_loginID: "stu03", stu_name: "박공부", prof_name: "임시 강사", course_id: "C001", today_att_code: null, att_cnt: 20, att_per_cnt: 0, att_leav_cnt: 0, att_out_cnt: 0, att_abs_cnt: 0 },
    { stu_loginID: "stu04", stu_name: "최열공", prof_name: "임시 강사", course_id: "C001", today_att_code: null, att_cnt: 17, att_per_cnt: 1, att_leav_cnt: 1, att_out_cnt: 0, att_abs_cnt: 1 },
    { stu_loginID: "stu05", stu_name: "정성실", prof_name: "임시 강사", course_id: "C001", today_att_code: null, att_cnt: 19, att_per_cnt: 1, att_leav_cnt: 0, att_out_cnt: 0, att_abs_cnt: 0 },
  ],
  totalCount: 5,
};

// 출석 관리 - 학생별 출석 상세 목록
const MOCK_ATT_DETAIL_LIST = {
  list: [
    { att_code: 1, att_date: "2026-01-06", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 2, att_date: "2026-01-07", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 3, att_date: "2026-01-08", att_sta_code: "2", stu_loginID: "stu01" },
    { att_code: 4, att_date: "2026-01-09", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 5, att_date: "2026-01-10", att_sta_code: "3", stu_loginID: "stu01" },
    { att_code: 6, att_date: "2026-01-13", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 7, att_date: "2026-01-14", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 8, att_date: "2026-01-15", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 9, att_date: "2026-01-16", att_sta_code: "1", stu_loginID: "stu01" },
    { att_code: 10, att_date: "2026-01-17", att_sta_code: "4", stu_loginID: "stu01" },
  ],
  totalCount: 10,
};

// 출석 관리 - 날짜별 출석 등록 목록
const MOCK_ATT_REGISTER_LIST = {
  list: [
    { today_att_code: 101, course_id: "C001", stu_loginID: "stu01", stu_name: "이학생", att_sta_code: "1" },
    { today_att_code: 102, course_id: "C001", stu_loginID: "stu02", stu_name: "김수강", att_sta_code: "1" },
    { today_att_code: 103, course_id: "C001", stu_loginID: "stu03", stu_name: "박공부", att_sta_code: "1" },
    { today_att_code: 104, course_id: "C001", stu_loginID: "stu04", stu_name: "최열공", att_sta_code: "2" },
    { today_att_code: 105, course_id: "C001", stu_loginID: "stu05", stu_name: "정성실", att_sta_code: "1" },
  ],
  att_date: "2026-01-20",
};

// 강사 시험 목록
const MOCK_INST_EXAM_LIST = [
  { courseId: 1, courseName: "(Mock) React 기초 과정", period: 1, title: "(Mock) React 1차 시험", status: 1 },
  { courseId: 1, courseName: "(Mock) React 기초 과정", period: 2, title: "(Mock) React 2차 시험", status: 0 },
  { courseId: 2, courseName: "(Mock) Spring Boot 심화", period: 1, title: "(Mock) Spring 중간고사", status: 1 },
  { courseId: 2, courseName: "(Mock) Spring Boot 심화", period: 2, title: "(Mock) Spring 기말고사", status: 0 },
  { courseId: 3, courseName: "(Mock) Vue.js 입문 과정", period: 1, title: "(Mock) Vue.js 1차 평가", status: 0 },
];

// 관리자 시험 목록
const MOCK_ADMIN_EXAM_LIST = [
  { courseId: "C001", title: "(Mock) React 기초 과정", professorName: "김강사", period: 1, status: 1 },
  { courseId: "C001", title: "(Mock) React 기초 과정", professorName: "김강사", period: 2, status: 0 },
  { courseId: "C002", title: "(Mock) Spring Boot 심화", professorName: "이선생", period: 1, status: 1 },
  { courseId: "C002", title: "(Mock) Spring Boot 심화", professorName: "이선생", period: 2, status: 0 },
  { courseId: "C003", title: "(Mock) Vue.js 입문 과정", professorName: "박선생", period: 1, status: 1 },
  { courseId: "C004", title: "(Mock) Node.js 기초 과정", professorName: "최강사", period: 1, status: 0 },
  { courseId: "C005", title: "(Mock) Python 데이터 분석", professorName: "정선생", period: 1, status: 0 },
];

// 관리자 강의실 목록 (상세 데이터 포함)
const MOCK_ADMIN_CLASSROOM_LIST = [
  { class_id: "R001", class_name: "A강의실", people_limit: 30, start_time: "09:00", end_time: "18:00", start_date: "2025-01-06", end_date: "2025-06-27", course_id: "C001", title: "(Mock) React 기초 과정", professor_name: "김강사", status: 1 },
  { class_id: "R002", class_name: "B강의실", people_limit: 25, start_time: "09:00", end_time: "18:00", start_date: "2025-03-03", end_date: "2025-08-29", course_id: "C002", title: "(Mock) Spring Boot 심화", professor_name: "이선생", status: 1 },
  { class_id: "R003", class_name: "C강의실", people_limit: 20, start_time: "14:00", end_time: "18:00", start_date: "2025-06-02", end_date: "2025-11-28", course_id: "C003", title: "(Mock) Vue.js 입문 과정", professor_name: "박선생", status: 1 },
  { class_id: "R004", class_name: "D강의실", people_limit: 28, start_time: "13:00", end_time: "22:00", start_date: "2025-07-07", end_date: "2025-12-26", course_id: "C004", title: "(Mock) Node.js 기초 과정", professor_name: "최강사", status: 1 },
  { class_id: "R005", class_name: "E강의실", people_limit: 22, start_time: "09:00", end_time: "13:00", start_date: "2025-09-01", end_date: "2026-02-27", course_id: "C005", title: "(Mock) Python 데이터 분석", professor_name: "정선생", status: 1 },
];

// 관리자 강의 목록
const MOCK_ADMIN_COURSE_LIST = [
  {
    course_id: "C001",
    title: "(Mock) React 기초 과정",
    name: "김강사",
    start_date: "2025-01-06",
    end_date: "2025-06-27",
    cos_sta_code: "1",
  },
  {
    course_id: "C002",
    title: "(Mock) Spring Boot 심화",
    name: "이선생",
    start_date: "2025-03-03",
    end_date: "2025-08-29",
    cos_sta_code: "1",
  },
  {
    course_id: "C003",
    title: "(Mock) Vue.js 입문 과정",
    name: "박선생",
    start_date: "2025-06-02",
    end_date: "2025-11-28",
    cos_sta_code: "0",
  },
  {
    course_id: "C004",
    title: "(Mock) Node.js 기초 과정",
    name: "최강사",
    start_date: "2025-07-07",
    end_date: "2025-12-26",
    cos_sta_code: "0",
  },
  {
    course_id: "C005",
    title: "(Mock) Python 데이터 분석",
    name: "정선생",
    start_date: "2025-09-01",
    end_date: "2026-02-27",
    cos_sta_code: "0",
  },
];

const MOCK_ADMIN_COURSE_DETAIL = {
  course_id: "C001",
  title: "(Mock) React 기초 과정",
  name: "김강사",
  start_date: "2025-01-06",
  end_date: "2025-06-27",
  start_time: "09:00",
  end_time: "18:00",
  class_name: "A강의실",
  content: "(Mock) React의 기초부터 실무까지 다루는 과정입니다.",
  plan: "(Mock) 1주차: JSX / 2주차: 컴포넌트 / 3주차: 상태관리 / 4주차: API 연동",
  notice: "(Mock) 노트북 지참 필수, 사전 JavaScript 기초 지식 권장",
  cos_sta_code: "1",
};

// ── URL 패턴별 응답 매핑 ──────────────────────────────────

function getMockResponse(url = "", method = "get", params = {}) {
  const path = url.split("?")[0].replace(/^\/api/, "");
  const m = method.toLowerCase();

  // 학생 목록
  if (path === "/admin/stu" && m === "get") {
    return {
      studentList: MOCK_STUDENT_LIST,
      studentCnt: MOCK_STUDENT_LIST.length,
    };
  }

  // 강사 목록
  if (path === "/admin/inst" && m === "get") {
    return {
      instructorList: MOCK_INSTRUCTOR_LIST,
      instructorCnt: MOCK_INSTRUCTOR_LIST.length,
    };
  }

  // 학생 상세
  if (path === "/admin/stu/stuDetail") {
    const found = MOCK_STUDENT_LIST.find((s) => s.loginID === params.loginID);
    return { ...MOCK_USER_DETAIL, ...found };
  }

  // 강사 상세
  if (path === "/admin/inst/instDetail") {
    const found = MOCK_INSTRUCTOR_LIST.find((i) => i.loginID === params.loginID);
    return { ...MOCK_USER_DETAIL, ...found };
  }

  // 수강/강의 목록
  if (path === "/admin/stu/courses" || path === "/admin/inst/courses") {
    return { list: MOCK_COURSE_LIST };
  }

  // 시험 과정 목록 (select box용)
  if (path === "/stu/exams/courses.do") {
    return MOCK_EXAM_COURSES;
  }

  // 시험 목록
  if (path === "/stu/exams/list.do") {
    return { list: MOCK_EXAM_LIST, totalCount: MOCK_EXAM_LIST.length };
  }

  // 시험 응시 가능 여부 확인
  if (path === "/stu/exams/check.do") {
    return { available: true, message: "" };
  }

  // 시험 문제 조회 (/stu/exams/test/{courseId}/{period}.do)
  if (path.startsWith("/stu/exams/test/")) {
    return { list: MOCK_EXAM_QUESTIONS };
  }

  // 시험 제출
  if (path === "/stu/exams/submit.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 제출 완료" };
  }

  // 시험 결과 조회 (/stu/exams/result/{courseId}/{period}/data.do)
  if (path.startsWith("/stu/exams/result/")) {
    return MOCK_EXAM_RESULT;
  }

  // 학습자료 목록
  if (path === "/materials/list.do") {
    return { list: MOCK_MATERIAL_LIST, totalCount: MOCK_MATERIAL_LIST.length };
  }

  // 학습자료 상세
  if (path === "/materials/detail.do") {
    const found = MOCK_MATERIAL_LIST.find((m) => m.materialId === params.materialId);
    return found ? { ...MOCK_MATERIAL_DETAIL, ...found } : MOCK_MATERIAL_DETAIL;
  }

  // 공지사항 목록 (관리자/강사/학생 공통)
  if (
    path === "/admin/notices/list.do" ||
    path === "/inst/notices/list.do" ||
    path === "/stu/notices/list.do"
  ) {
    return { notice: MOCK_NOTICE_LIST, noticeCnt: MOCK_NOTICE_LIST.length };
  }

  // 공지사항 상세
  if (path === "/admin/notices/detail.do") {
    const id = Number(params.noticeId);
    const found = MOCK_NOTICE_LIST.find((n) => n.notice_id === id);
    return { notice: found ?? MOCK_NOTICE_DETAIL };
  }

  // 공지사항 조회수 증가
  if (path === "/admin/notices/viewCount/list.do" && m === "post") {
    return { result: "success" };
  }

  // 공지사항 등록
  if (path === "/admin/notices/insertNotice/list.do" && m === "post") {
    return { result: "success", resultMsg: "(Mock) 공지사항이 등록되었습니다." };
  }

  // 공지사항 수정
  if (path === "/admin/notices/updateContent/list.do" && m === "post") {
    return { result: "success", resultMsg: "(Mock) 공지사항이 수정되었습니다." };
  }

  // 공지사항 삭제
  if (path === "/admin/notices/deleteNotice/list.do" && m === "post") {
    return { result: "success", resultMsg: "(Mock) 공지사항이 삭제되었습니다." };
  }

  // 강사 시험 목록
  if (path === "/inst/exams/courses" && m === "get") {
    return MOCK_INST_COURSE_LIST.map((c) => ({ course_id: c.course_id, title: c.title }));
  }

  if (path === "/inst/exams/list" && m === "get") {
    return { list: MOCK_INST_EXAM_LIST, totalCount: MOCK_INST_EXAM_LIST.length };
  }

  // 강사 시험 등록 (RegTest)
  if (path === "/inst/exam-register.do" && m === "post") {
    return { success: true, message: "(Mock) 시험 문제가 등록되었습니다." };
  }

  // 시험 등록 (RegTest - 구 경로)
  if (path === "/stu/exams/register.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 시험 문제가 등록되었습니다." };
  }

  // 강사 평가 조회
  if (path === "/admin/inst/eval" && m === "post") {
    return { content: "(Mock) 평가 내용입니다." };
  }

  // 강사 평가 저장 / 상태 변경
  if (
    path === "/admin/inst/eval/save" ||
    path === "/admin/stu/updateStudentStatus" ||
    path === "/admin/inst/updateInstructorStatus"
  ) {
    return { result: "SUCCESS", resultMsg: "(Mock) 처리 완료" };
  }

  // 강사 등록 ID 발급
  if (path === "/inst/registerid" && m === "get") {
    return "MOCK_INST_" + Date.now();
  }

  // 강사 등록
  if (path === "/inst/registerInstructor") {
    return "loginID: MOCK_INST_001\ntempPassword: mock1234";
  }

  if (path === "/inst/registerInstructorInfo" && m === "post") {
    return {
      result: "SUCCESS",
      email: "inst01@test.com",
      photoUrl: "/inst/join/getDefaultImg",
    };
  }

  if (path === "/inst/join/registerInstructor" && m === "post") {
    return {
      result: "SUCCESS",
      msg: "(Mock) 강사 정보 등록에 성공하였습니다. 로그인해주세요.",
    };
  }

  // 이력서 다운로드 (blob 불필요 — 빈 blob 반환)
  if (path === "/admin/stu/resumeDownload") {
    return new Blob(["(Mock) 이력서 없음"], { type: "application/pdf" });
  }

  // ── 과제 ────────────────────────────────────────────────

  // 강사/학생 과제 목록
  if (path === "/inst/homeworklist.do" || path === "/stu/homeworklist.do") {
    return MOCK_HOMEWORK_LIST;
  }

  // 강사 강의 목록 (과제 등록용 select box)
  if (path === "/inst/getcourselist.do") {
    return MOCK_STU_COURSE_LIST.map((c) => ({ course_id: c.course_id, title: c.title }));
  }

  // 강사 제출 현황 목록
  if (path === "/inst/submissions/listAll.do") {
    return MOCK_SUBMISSION_LIST;
  }

  // 과제 등록
  if (path === "/inst/homeworkInsert.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 과제가 등록되었습니다." };
  }

  // 과제 평가 저장
  if (path === "/inst/submissions/update.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 평가가 저장되었습니다." };
  }

  // 학생 과제 상세 (/stu/assignmentDetail/{id}/{submissionId}.do)
  if (path.startsWith("/stu/assignmentDetail/")) {
    return {
      course_name: "React 기초 과정",
      homework_title: "(Mock) React 컴포넌트 구현 과제",
      teacher_name: "김강사",
      file_name: "homework_guide.pdf",
    };
  }

  // 학생 과제 제출
  if (path === "/stu/submitSubmission.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 과제가 제출되었습니다." };
  }

  // 학생 제출 결과 목록
  if (path === "/stu/submittedList.do") {
    return MOCK_SUBMITTED_LIST;
  }

  // ── 강의 ────────────────────────────────────────────────

  // 학생 전체 강의 목록
  if (path === "/stu/courses" || path === "/api/stu/courses") {
    return MOCK_STU_COURSE_LIST;
  }

  // 학생 나의 강의 목록
  if (path === "/stu/my-courses/loadMyCourse" || path === "/api/stu/my-courses/loadMyCourse") {
    return MOCK_STU_COURSE_LIST.slice(0, 2);
  }

  // 학생 강의 상세 (/api/stu/courses/{courseId})
  if (path.startsWith("/stu/courses/") && !path.includes("/action")) {
    const courseId = path.split("/").pop();
    const found = MOCK_STU_COURSE_LIST.find((c) => c.course_id === courseId);
    return found ?? MOCK_STU_COURSE_LIST[0];
  }

  // 학생 나의 강의 상세
  if (path === "/stu/my-courses/myCourseDetail" || path === "/api/stu/my-courses/myCourseDetail") {
    const id = params.course_id ?? params.courseId;
    const found = MOCK_STU_COURSE_LIST.find((c) => c.course_id === id);
    return found ?? MOCK_STU_COURSE_LIST[0];
  }

  // 학생 강의 신청/취소
  if (path.includes("/stu/courses/") && path.includes("/action")) {
    return { status: "SUCCESS", msg: "(Mock) 처리되었습니다." };
  }

  // 강사 전체 강의 목록
  if (path === "/inst/getAllCourseList.json" || path === "/api/inst/getAllCourseList.json") {
    return { result: "SUCCESS", list: MOCK_INST_COURSE_LIST };
  }

  // 강사 나의 강의 목록
  if (path === "/inst/getCourseList.json" || path === "/api/inst/getCourseList.json") {
    return { result: "SUCCESS", list: MOCK_INST_COURSE_LIST };
  }

  // 강사 전체 강의 상세
  if (path === "/inst/getAllCourseDetail" || path === "/api/inst/getAllCourseDetail") {
    const found = MOCK_INST_COURSE_LIST.find((c) => c.course_id === params.courseId);
    return { result: "SUCCESS", course: found ?? MOCK_INST_COURSE_LIST[0] };
  }

  // 강사 나의 강의 상세
  if (path === "/inst/getCourseDetail" || path === "/api/inst/getCourseDetail") {
    const found = MOCK_INST_COURSE_LIST.find((c) => c.course_id === params.courseId);
    return { result: "SUCCESS", course: found ?? MOCK_INST_COURSE_LIST[0] };
  }

  // 강의실 목록
  if (path === "/inst/classList" || path === "/api/inst/classList") {
    return { result: "SUCCESS", list: MOCK_CLASS_LIST };
  }

  // 강의 시간 목록
  if (path === "/inst/timeList" || path === "/api/inst/timeList") {
    return { result: "SUCCESS", list: MOCK_TIME_LIST };
  }

  // 보조강사 목록
  if (path === "/inst/subInstructorList" || path === "/api/inst/subInstructorList") {
    return { result: "SUCCESS", list: MOCK_INSTRUCTOR_LIST.map((i) => ({ loginID: i.loginID, name: i.name })) };
  }

  // 강의 등록/수정/삭제
  if (
    path === "/inst/courseSave" ||
    path === "/api/inst/courseSave" ||
    path === "/inst/courseUpdate" ||
    path === "/api/inst/courseUpdate" ||
    path === "/inst/courseDelete" ||
    path === "/api/inst/courseDelete"
  ) {
    return { result: "SUCCESS", resultMsg: "(Mock) 처리되었습니다." };
  }

  // ── Q&A ─────────────────────────────────────────────────

  // Q&A 목록 (관리자/강사/학생 공통)
  if (
    path === "/admin/qna/list" || path === "/api/admin/qna/list" ||
    path === "/inst/qna/list" || path === "/stu/qna/list"
  ) {
    return {
      qnaList: MOCK_QNA_LIST,
      totalCnt: MOCK_QNA_LIST.length,
      categories: MOCK_QNA_CATEGORIES,
    };
  }

  // Q&A 댓글 목록 – 관리자: /api/admin/qna/comments/{postId}
  if (path.startsWith("/admin/qna/comments/") || path.startsWith("/api/admin/qna/comments/")) {
    const postId = parseInt(path.split("/").pop(), 10);
    const filtered = isNaN(postId) ? MOCK_QNA_COMMENTS : MOCK_QNA_COMMENTS.filter((c) => c.postId === postId);
    return { comments: filtered };
  }

  // Q&A 댓글 목록 – 강사/학생: /inst|stu/qna/comment/list?postId=xxx
  if (path === "/inst/qna/comment/list" || path === "/stu/qna/comment/list") {
    const postId = parseInt(params.postId, 10);
    const filtered = isNaN(postId) ? MOCK_QNA_COMMENTS : MOCK_QNA_COMMENTS.filter((c) => c.postId === postId);
    return { result: "SUCCESS", data: filtered };
  }

  // Q&A CRUD (관리자/강사/학생 공통)
  if (
    path === "/admin/qna/save"           || path === "/api/admin/qna/save" ||
    path === "/admin/qna/update"         || path === "/api/admin/qna/update" ||
    path === "/admin/qna/delete"         || path === "/api/admin/qna/delete" ||
    path === "/admin/qna/comment/save"   || path === "/api/admin/qna/comment/save" ||
    path === "/admin/qna/comment/update" || path === "/api/admin/qna/comment/update" ||
    path === "/admin/qna/comment/delete" || path === "/api/admin/qna/comment/delete" ||
    path === "/inst/qna/save"   || path === "/inst/qna/update"   || path === "/inst/qna/delete" ||
    path === "/inst/qna/comment/save" || path === "/inst/qna/comment/update" || path === "/inst/qna/comment/delete" ||
    path === "/stu/qna/save"    || path === "/stu/qna/update"    || path === "/stu/qna/delete" ||
    path === "/stu/qna/comment/save"  || path === "/stu/qna/comment/update"  || path === "/stu/qna/comment/delete"
  ) {
    return { result: "SUCCESS", resultMsg: "(Mock) 처리되었습니다." };
  }

  // ── 설문조사 ─────────────────────────────────────────────

  if (path === "/survey/surveyListAjax.do") {
    return { list: MOCK_SURVEY_LIST, totalCnt: MOCK_SURVEY_LIST.length };
  }

  if (path === "/survey/detailSurvey.do") {
    const surveyId = parseInt(params.surveyId, 10);
    const survey = MOCK_SURVEY_LIST.find((s) => s.surveyId === surveyId) || MOCK_SURVEY_LIST[0];
    const questions = MOCK_SURVEY_QUESTIONS[surveyId] || [];
    return {
      result: { title: survey.title, courseId: survey.courseId, loginName: survey.loginName, createdAt: survey.createdAt },
      questions,
    };
  }

  if (path === "/survey/getSurveyStatistics.do") {
    const surveyId = parseInt(params.surveyId, 10);
    const raw = MOCK_SURVEY_CHART[surveyId] || [];
    const questionStats = raw.map((item) => ({
      questionId: item.questionId,
      questionContent: item.content,
      responseCount: item.count,
    }));
    return { resultMsg: "SUCCESS", questionStats };
  }

  if (
    path === "/survey/surveyResponseSave.do" ||
    path === "/survey/surveySave.do" ||
    path === "/survey/surveyDelete.do"
  ) {
    return { result: "SUCCESS", resultMsg: "(Mock) 처리되었습니다." };
  }

  if (path === "/survey/getActiveCourseList.do") {
    return { courseList: MOCK_SURVEY_COURSE_LIST };
  }

  // ── 대시보드 ─────────────────────────────────────────────

  // 통계 차트 데이터
  if (path === "/dashboard/goChart.do") {
    return MOCK_DASHBOARD_CHART;
  }

  // 현재 수업 중인 강의실
  if (path === "/admin/classrooms/active" || path === "/api/admin/classrooms/active") {
    return { list: MOCK_ACTIVE_CLASSROOMS };
  }

  // 시험 일정
  if (path === "/admin/exam/schedule/list" || path === "/api/admin/exam/schedule/list") {
    return MOCK_EXAM_SCHEDULE;
  }

  // 공지사항 (대시보드용 — 관리자 경로 재사용)
  if (path === "/admin/notices/list" || path === "/api/admin/notices/list") {
    return { notice: MOCK_NOTICE_LIST, noticeCnt: MOCK_NOTICE_LIST.length };
  }

  // ── 출석 관리 ────────────────────────────────────────────

  // 강의 목록 (출석 페이지용)
  if (path === "/inst/allCourseList.do" && m === "post") {
    return MOCK_ATT_COURSE_LIST;
  }

  // 강의별 학생 목록
  if (path === "/inst/courseStudentList.do" && m === "post") {
    return MOCK_ATT_STUDENT_LIST;
  }

  // 학생별 출석 상세 목록
  if (path === "/inst/stuAttDtlList.do" && m === "post") {
    return MOCK_ATT_DETAIL_LIST;
  }

  // 출석 상태 수정
  if (path === "/inst/modifyStuAtt.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 출석 상태가 수정되었습니다." };
  }

  // 출석 일괄 등록
  if (path === "/inst/stuAttDtlReg.do" && m === "post") {
    return { result: "SUCCESS", resultMsg: "(Mock) 출석이 등록되었습니다." };
  }

  // 날짜별 출석 등록 목록
  if (path === "/inst/stuAttDtlRegList.do" && m === "post") {
    return MOCK_ATT_REGISTER_LIST;
  }

  // ── 관리자 시험 관리 ─────────────────────────────────────

  // 시험 목록
  if (path === "/admin/test-exam/list" || path === "/api/admin/test-exam/list") {
    return { list: MOCK_ADMIN_EXAM_LIST, totalCount: MOCK_ADMIN_EXAM_LIST.length };
  }

  // ── 관리자 강의실 관리 ───────────────────────────────────

  // 강의실 목록 (관리자 강의실 관리 페이지용)
  if (path === "/admin/classrooms/list" || path === "/api/admin/classrooms/list") {
    return MOCK_ADMIN_CLASSROOM_LIST;
  }

  // 강의실 상세
  if (path === "/admin/classrooms/detail/" || path === "/api/admin/classrooms/detail/") {
    const name = params.name;
    const filtered = MOCK_ADMIN_CLASSROOM_LIST.filter((c) => c.class_name === name);
    return filtered.length > 0 ? filtered : [MOCK_ADMIN_CLASSROOM_LIST[0]];
  }

  // 강의실 등록
  if (path === "/admin/classrooms/insert" || path === "/api/admin/classrooms/insert") {
    return { result: "SUCCESS", resultMsg: "(Mock) 강의실이 등록되었습니다." };
  }

  // 강의실 삭제
  if (path === "/admin/classrooms/delete" || path === "/api/admin/classrooms/delete") {
    return { result: "SUCCESS", resultMsg: "(Mock) 강의실이 삭제되었습니다." };
  }

  // ── 관리자 강의 관리 ─────────────────────────────────────

  // 강의 목록
  if (path === "/admin/courseManagement/list" || path === "/api/admin/courseManagement/list") {
    return MOCK_ADMIN_COURSE_LIST;
  }

  // 강의 상세 (/api/admin/courseManagement/detail/{courseId})
  if (
    path.startsWith("/admin/courseManagement/detail/") ||
    path.startsWith("/api/admin/courseManagement/detail/")
  ) {
    const courseId = path.split("/").pop();
    const found = MOCK_ADMIN_COURSE_LIST.find((c) => c.course_id === courseId);
    return found ? { ...MOCK_ADMIN_COURSE_DETAIL, ...found } : MOCK_ADMIN_COURSE_DETAIL;
  }

  // 강의 상태 변경
  if (
    path === "/admin/courseManagement/updateStatus" ||
    path === "/api/admin/courseManagement/updateStatus"
  ) {
    return { result: "SUCCESS", resultMsg: "(Mock) 상태가 변경되었습니다." };
  }

  // 기본: 빈 성공 응답
  return { result: "SUCCESS", resultMsg: "(Mock) OK" };
}

// ── Mock Adapter 함수 ─────────────────────────────────────

/**
 * axios config에 mock adapter를 주입합니다.
 * 실제 HTTP 요청 없이 getMockResponse()의 결과를 반환합니다.
 */
export function injectMockAdapter(config) {
  const bodyParams = {};
  if (config.data instanceof URLSearchParams) {
    config.data.forEach((value, key) => {
      bodyParams[key] = value;
    });
  }

  const mergedParams = { ...config.params, ...bodyParams };

  config.adapter = async () => ({
    data: getMockResponse(config.url, config.method, mergedParams),
    status: 200,
    statusText: "OK",
    headers: { "content-type": "application/json" },
    config,
    request: {},
  });
  return config;
}

/**
 * sessionStorage의 user 정보를 기반으로 mock 모드 여부를 반환합니다.
 */
export function isMockMode() {
  try {
    const user = JSON.parse(localStorage.getItem("user") ?? "null");
    return user?.isMock === true;
  } catch {
    return false;
  }
}
