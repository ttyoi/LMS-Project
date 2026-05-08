import axios from "axios";
import { injectMockAdapter, isMockMode } from "./mockAdapter";

/**
 * axios 공통 인스턴스
 *
 * - baseURL: Vite 프록시를 통해 백엔드(Spring MVC)로 요청이 전달됩니다.
 * - withCredentials: 세션 쿠키를 자동으로 포함시킵니다 (서버 세션 인증 방식).
 */
const api = axios.create({
  baseURL: "/",
  withCredentials: true, // 세션 쿠키 자동 포함
  timeout: 5000, // 5초 내 응답 없으면 요청 실패 처리
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    "AJAX": "true",
  },
});

// 로그아웃 시 진행 중인 모든 요청을 취소하기 위한 컨트롤러
let sessionController = new AbortController();

export const cancelPendingRequests = () => {
  sessionController.abort();
  sessionController = new AbortController();
};

/**
 * 요청 인터셉터
 * - mock 모드일 때 실제 서버 요청 없이 가짜 응답 반환
 * - 현재 세션의 AbortSignal을 요청에 주입 (로그아웃 시 일괄 취소 가능)
 */
api.interceptors.request.use((config) => {
  if (isMockMode()) return injectMockAdapter(config);
  // /loginOut.do는 로그아웃 처리 자체이므로 취소 대상에서 제외
  if (!config.url?.includes("loginOut") && !config.url?.includes("loginProc")) {
    config.signal = sessionController.signal;
  }
  return config;
});

let isRedirecting = false;
let ignoreAuthErrors = false;

export const setIgnoreAuthErrors = (val) => { ignoreAuthErrors = val; };

const redirectToLogin = (message) => {
  if (isRedirecting || ignoreAuthErrors || window.location.pathname === "/login") return;
  isRedirecting = true;
  alert(message);
  window.location.href = "/login";
};

/**
 * 응답 인터셉터
 * - 세션 만료(901), 인증 실패(401) 시 로그인 이동
 * - 서버 재시작 후 302 리다이렉트 → axios가 자동으로 따라가 로그인 HTML을 200으로 받는 경우 감지
 * - 타임아웃(ECONNABORTED) 시 로그인 이동
 * - 로그아웃으로 취소된 요청(ERR_CANCELED)은 무시
 */
api.interceptors.response.use(
  (response) => {
    isRedirecting = false; // 정상 응답이 오면 리다이렉트 플래그 초기화
    const finalURL = response.request?.responseURL;
    const isLogout = response.config?.url?.includes("loginOut");
    // 302 → 로그인 HTML(200)로 떨어진 경우: 응답을 컴포넌트에 넘기지 않고 차단
    // /loginProc.do 등 "/login"을 포함하는 다른 URL과 구분하기 위해 정규식 사용
    if (!isLogout && finalURL && /\/login($|\?)/.test(finalURL)) {
      redirectToLogin("세션이 만료되었습니다. 다시 로그인해 주세요.");
      return Promise.reject(new Error("SESSION_EXPIRED"));
    }
    return response;
  },
  (error) => {
    // 로그아웃 시 AbortController로 취소된 요청은 무시
    if (axios.isCancel(error) || error.code === "ERR_CANCELED") {
      return Promise.reject(error);
    }

    // 로그아웃 API 자체의 에러는 세션 만료 처리 대상에서 제외
    const isLogout = error.config?.url?.includes("loginOut");
    if (isLogout) return Promise.reject(error);

    const status = error.response?.status;
    if (status === 901 || status === 401) {
      redirectToLogin("세션이 만료되었습니다. 다시 로그인해 주세요.");
    } else if (status === 403) {
      redirectToLogin("접근 권한이 없습니다. 다시 로그인해 주세요.");
    } else if (error.code === "ECONNABORTED") {
      redirectToLogin("서버 응답이 없습니다. 다시 로그인해 주세요.");
    } else if (!error.response) {
      // 백엔드 재시작 등으로 연결 자체가 안 될 때 (ERR_CONNECTION_REFUSED 등)
      redirectToLogin("서버에 연결할 수 없습니다. 다시 로그인해 주세요.");
    }
    return Promise.reject(error);
  },
);

export default api;
