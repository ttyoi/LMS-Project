import { useEffect, useMemo, useRef, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import api from "../../../api/axios";
import styles from "./AdminUsersPage.module.css";

const PAGE_SIZE_OPTIONS = [5, 10, 20];
const PAGE_BLOCK_SIZE = 5;

const TAB_CONFIG = {
  student: {
    key: "student",
    label: "학생",
    route: "/admin/stu",
    listPath: "/admin/stu",
    detailPath: "/admin/stu/stuDetail",
    coursesPath: "/admin/stu/courses",
    statusSavePath: "/admin/stu/updateStudentStatus",
    resumeDownloadPath: "/admin/stu/resumeDownload",
  },
  instructor: {
    key: "instructor",
    label: "강사",
    route: "/admin/inst",
    listPath: "/admin/inst",
    detailPath: "/admin/inst/instDetail",
    coursesPath: "/admin/inst/courses",
    evalPath: "/admin/inst/eval",
    evalSavePath: "/admin/inst/eval/save",
    statusSavePath: "/admin/inst/updateInstructorStatus",
    registerIdPath: "/api/inst/registerid",
    registerPath: "/api/inst/registerInstructor",
  },
};

const SEARCH_OPTIONS = [
  { value: "name", label: "이름" },
  { value: "phone", label: "전화번호" },
  { value: "id", label: "아이디" },
];

const STATUS_LABELS = {
  W: "가입중",
  R: "활성",
  D: "일시정지",
  Q: "탈퇴",
};

const DEFAULT_SEARCH = {
  statusFilter: "",
  searchType: "name",
  keyword: "",
};

const DEFAULT_CONFIRM_STATE = {
  open: false,
  message: "",
  actionType: "",
};

const DEFAULT_NOTICE_STATE = {
  open: false,
  message: "",
  type: "success",
};

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function getBasePath() {
  const rawBaseUrl = String(api.defaults.baseURL ?? "").trim();

  if (!rawBaseUrl || rawBaseUrl === "/") {
    return "";
  }

  if (/^https?:\/\//i.test(rawBaseUrl)) {
    return new URL(rawBaseUrl).pathname.replace(/\/+$/, "");
  }

  return rawBaseUrl.replace(/\/+$/, "");
}

const BASE_PATH = getBasePath();
const HAS_API_IN_BASE = /\/api$/i.test(BASE_PATH);

function resolveRequestPath(path, { apiPrefix = false } = {}) {
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;

  if (!apiPrefix) {
    return normalizedPath;
  }

  if (normalizedPath.startsWith("/api/")) {
    return HAS_API_IN_BASE
      ? normalizedPath.replace(/^\/api/i, "")
      : normalizedPath;
  }

  return HAS_API_IN_BASE ? normalizedPath : `/api${normalizedPath}`;
}

function resolveBrowserPath(path, { apiPrefix = false } = {}) {
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;

  if (!apiPrefix) {
    return normalizedPath;
  }

  if (normalizedPath.startsWith("/api/")) {
    return normalizedPath;
  }

  if (HAS_API_IN_BASE) {
    return `${BASE_PATH}${normalizedPath}`;
  }

  return `/api${normalizedPath}`;
}

function createFormBody(payload) {
  const searchParams = new URLSearchParams();

  Object.entries(payload).forEach(([key, value]) => {
    if (value !== undefined && value !== null) {
      searchParams.append(key, String(value));
    }
  });

  return searchParams;
}

function textOrDash(value) {
  const normalized = typeof value === "string" ? value.trim() : value;
  return normalized ? normalized : "-";
}

function formatListDate(value) {
  if (value === undefined || value === null || value === "") {
    return "-";
  }

  const raw = String(value).trim();

  if (/^\d{13}$/.test(raw)) {
    const date = new Date(Number(raw));
    if (Number.isNaN(date.getTime())) return raw;

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");

    return `${year}-${month}-${day}`;
  }

  return raw.length >= 10 ? raw.slice(0, 10) : raw;
}

function buildAddress(detail) {
  return [detail?.addr1, detail?.addr2].filter(Boolean).join(" ").trim() || "-";
}

function getTabFromPath(pathname) {
  return pathname.includes("/admin/inst") ? "instructor" : "student";
}

function isHtmlResponseText(value) {
  const normalized = String(value ?? "")
    .trim()
    .toLowerCase();
  return normalized.startsWith("<!doctype") || normalized.startsWith("<html");
}

function extractPatternValue(text, patterns) {
  for (const pattern of patterns) {
    const match = text.match(pattern);
    if (match?.[1]) {
      return match[1].trim();
    }
  }
  return "";
}

function parseRegisterResult(text, fallbackId = "") {
  const normalized = String(text ?? "").trim();

  const loginID =
    extractPatternValue(normalized, [
      /(?:아이디|id)\s*[:=]\s*([^\s,/]+)/i,
      /(?:아이디|id)\s+([^\s,/]+)/i,
    ]) || fallbackId;

  const tempPassword = extractPatternValue(normalized, [
    /(?:임시\s*비밀번호|임시비밀번호|비밀번호|password|pw)\s*[:=]\s*([^\s,/]+)/i,
    /(?:임시\s*비밀번호|임시비밀번호|비밀번호|password|pw)\s+([^\s,/]+)/i,
  ]);

  return {
    loginID,
    tempPassword,
  };
}

function AdminUsersPage() {
  const location = useLocation();
  const navigate = useNavigate();

  const activeTab = getTabFromPath(location.pathname);
  const tabConfig = TAB_CONFIG[activeTab];

  const [searchForm, setSearchForm] = useState(DEFAULT_SEARCH);
  const [appliedSearch, setAppliedSearch] = useState(DEFAULT_SEARCH);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(5);
  const [reloadTick, setReloadTick] = useState(0);

  const [listState, setListState] = useState({
    items: [],
    totalCount: 0,
    loading: false,
    error: "",
  });

  const [selectedLoginId, setSelectedLoginId] = useState("");
  const [detailOriginal, setDetailOriginal] = useState(null);
  const [detailDraft, setDetailDraft] = useState(null);
  const [courses, setCourses] = useState([]);
  const [detailLoading, setDetailLoading] = useState(false);
  const [detailError, setDetailError] = useState("");

  const [registerMode, setRegisterMode] = useState(false);
  const [registerForm, setRegisterForm] = useState({
    loginID: "",
    email: "",
  });
  const [registerOriginal, setRegisterOriginal] = useState({
    loginID: "",
    email: "",
  });
  const [registerLoading, setRegisterLoading] = useState(false);
  const [registerError, setRegisterError] = useState("");

  const [saveLoading, setSaveLoading] = useState(false);
  const [confirmState, setConfirmState] = useState(DEFAULT_CONFIRM_STATE);
  const [noticeState, setNoticeState] = useState(DEFAULT_NOTICE_STATE);
  const confirmAcceptButtonRef = useRef(null);
  const confirmActionTypeRef = useRef("");
  const executeRegisterSaveRef = useRef(null);
  const executeDetailSaveRef = useRef(null);

  confirmActionTypeRef.current = confirmState.actionType;

  useEffect(() => {
    setSelectedLoginId("");
    setDetailOriginal(null);
    setDetailDraft(null);
    setCourses([]);
    setDetailError("");
    setRegisterMode(false);
    setRegisterForm({ loginID: "", email: "" });
    setRegisterOriginal({ loginID: "", email: "" });
    setRegisterError("");
    setCurrentPage(1);
    setSearchForm((prev) => ({ ...prev, statusFilter: "" }));
    setAppliedSearch((prev) => ({ ...prev, statusFilter: "" }));
    setConfirmState(DEFAULT_CONFIRM_STATE);
    setNoticeState(DEFAULT_NOTICE_STATE);
  }, [activeTab]);

  useEffect(() => {
    if (!confirmState.open) {
      return undefined;
    }

    confirmAcceptButtonRef.current?.focus();

    function handleConfirmKeyDown(event) {
      if (event.key === "Enter") {
        event.preventDefault();
        setConfirmState(DEFAULT_CONFIRM_STATE);

        if (confirmActionTypeRef.current === "register") {
          executeRegisterSaveRef.current?.();
          return;
        }

        if (confirmActionTypeRef.current === "detail") {
          executeDetailSaveRef.current?.();
        }
      }

      if (event.key === "Escape") {
        event.preventDefault();
        setConfirmState(DEFAULT_CONFIRM_STATE);
      }
    }

    window.addEventListener("keydown", handleConfirmKeyDown);

    return () => {
      window.removeEventListener("keydown", handleConfirmKeyDown);
    };
  }, [confirmState.open]);

  useEffect(() => {
    let isMounted = true;

    async function loadList() {
      setListState((prev) => ({
        ...prev,
        loading: true,
        error: "",
      }));

      try {
        const response = await api.get(
          resolveRequestPath(tabConfig.listPath, { apiPrefix: true }),
          {
            params: {
              currentPage,
              pageSize,
              statusFilter: appliedSearch.statusFilter,
              searchType: appliedSearch.searchType,
              sname: appliedSearch.keyword.trim(),
            },
          },
        );

        const data = response.data ?? {};
        const items =
          activeTab === "student"
            ? (data.studentList ?? [])
            : (data.instructorList ?? []);
        const totalCount = Number(
          activeTab === "student"
            ? (data.studentCnt ?? 0)
            : (data.instructorCnt ?? 0),
        );

        if (!isMounted) {
          return;
        }

        setListState({
          items,
          totalCount,
          loading: false,
          error: "",
        });
      } catch (error) {
        if (!isMounted) {
          return;
        }

        setListState((prev) => ({
          ...prev,
          loading: false,
          error:
            error?.response?.data?.message || "목록을 불러오지 못했습니다.",
        }));
      }
    }

    loadList();

    return () => {
      isMounted = false;
    };
  }, [
    activeTab,
    appliedSearch,
    currentPage,
    pageSize,
    reloadTick,
    tabConfig.listPath,
  ]);

  const totalPages = Math.ceil(listState.totalCount / pageSize);
  const hasListData = listState.items.length > 0;
  const hasDetailData = Boolean(detailDraft);
  const showListInitialLoading = listState.loading && !hasListData;
  const showListErrorState =
    !listState.loading && !hasListData && Boolean(listState.error);
  const showListEmpty =
    !listState.loading && !listState.error && !hasListData;
  const showListOverlay = listState.loading && hasListData;
  const showDetailInitialLoading = detailLoading && !hasDetailData;
  const showDetailEmpty = !detailLoading && !detailError && !hasDetailData;
  const showDetailOverlay = detailLoading && hasDetailData;

  const statusOptions = useMemo(() => {
    const baseOptions = [
      { value: "", label: "전체" },
      { value: "R", label: STATUS_LABELS.R },
      { value: "D", label: STATUS_LABELS.D },
      { value: "Q", label: STATUS_LABELS.Q },
    ];

    if (activeTab === "instructor") {
      baseOptions.push({ value: "W", label: STATUS_LABELS.W });
    }

    return baseOptions;
  }, [activeTab]);

  const isStatusChanged =
    !registerMode &&
    Boolean(detailOriginal && detailDraft) &&
    detailOriginal.status !== detailDraft.status;

  const isEvalChanged =
    activeTab === "instructor" &&
    !registerMode &&
    Boolean(detailOriginal && detailDraft) &&
    (detailOriginal.evalContent ?? "") !== (detailDraft.evalContent ?? "");

  const isRegisterEmailValid = EMAIL_REGEX.test(registerForm.email.trim());
  const isRegisterChanged =
    registerMode && registerForm.email.trim() !== registerOriginal.email.trim();

  const isSaveEnabled = registerMode
    ? isRegisterEmailValid &&
      isRegisterChanged &&
      !registerLoading &&
      !saveLoading &&
      !registerError &&
      Boolean(registerForm.loginID.trim())
    : activeTab === "student"
      ? isStatusChanged && !saveLoading
      : (isStatusChanged || isEvalChanged) && !saveLoading;

  async function loadUserDetail(loginID) {
    const hasPreviousDetail = Boolean(detailOriginal || detailDraft);

    setSelectedLoginId(loginID);
    setRegisterMode(false);
    setRegisterError("");
    setDetailLoading(true);
    setDetailError("");

    try {
      if (activeTab === "student") {
        const [detailResponse, coursesResponse] = await Promise.all([
          api.post(
            resolveRequestPath(TAB_CONFIG.student.detailPath, {
              apiPrefix: true,
            }),
            createFormBody({ loginID }),
          ),
          api.post(
            resolveRequestPath(TAB_CONFIG.student.coursesPath, {
              apiPrefix: true,
            }),
            createFormBody({ loginID }),
          ),
        ]);

        const detailData = detailResponse.data ?? {};
        const nextDetail = {
          ...detailData,
          evalContent: "",
        };

        setDetailOriginal(nextDetail);
        setDetailDraft(nextDetail);
        setCourses(coursesResponse.data?.list ?? []);
      } else {
        const [detailResponse, coursesResponse, evalResponse] =
          await Promise.all([
            api.post(
              resolveRequestPath(TAB_CONFIG.instructor.detailPath, {
                apiPrefix: true,
              }),
              createFormBody({ loginID }),
            ),
            api.post(
              resolveRequestPath(TAB_CONFIG.instructor.coursesPath, {
                apiPrefix: true,
              }),
              createFormBody({ loginID }),
            ),
            api.post(
              resolveRequestPath(TAB_CONFIG.instructor.evalPath, {
                apiPrefix: true,
              }),
              createFormBody({ loginID }),
            ),
          ]);

        const detailData = detailResponse.data ?? {};
        const nextDetail = {
          ...detailData,
          evalContent: evalResponse.data?.content ?? "",
        };

        setDetailOriginal(nextDetail);
        setDetailDraft(nextDetail);
        setCourses(coursesResponse.data?.list ?? []);
      }
    } catch (error) {
      if (!hasPreviousDetail) {
        setDetailOriginal(null);
        setDetailDraft(null);
        setCourses([]);
      }
      setDetailError(
        error?.response?.data?.message || "상세 정보를 불러오지 못했습니다.",
      );
    } finally {
      setDetailLoading(false);
    }
  }

  function handleSearchChange(event) {
    const { name, value } = event.target;
    setSearchForm((prev) => ({
      ...prev,
      [name]: value,
    }));
  }

  function handleSearchSubmit() {
    setCurrentPage(1);
    setAppliedSearch({
      statusFilter: searchForm.statusFilter,
      searchType: searchForm.searchType,
      keyword: searchForm.keyword,
    });
  }

  function handleSearchKeyDown(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      handleSearchSubmit();
    }
  }

  function handleTabChange(nextTab) {
    if (nextTab === activeTab) {
      return;
    }

    navigate(TAB_CONFIG[nextTab].route);
  }

  function handleStatusChange(event) {
    const { value } = event.target;
    setDetailDraft((prev) => (prev ? { ...prev, status: value } : prev));
  }

  function handleEvalChange(event) {
    const { value } = event.target;
    setDetailDraft((prev) => (prev ? { ...prev, evalContent: value } : prev));
  }

  function handlePageSizeChange(event) {
    setPageSize(Number(event.target.value));
    setCurrentPage(1);
  }

  function handleCancel() {
    if (registerMode) {
      setRegisterForm(registerOriginal);
      setRegisterError("");
      return;
    }

    setDetailDraft(detailOriginal);
  }

  function openConfirm(message, actionType) {
    setConfirmState({
      open: true,
      message,
      actionType,
    });
  }

  function closeConfirm() {
    setConfirmState(DEFAULT_CONFIRM_STATE);
  }

  function showNotice(message, type = "success") {
    setNoticeState({
      open: true,
      message,
      type,
    });
  }

  function hideNotice() {
    setNoticeState(DEFAULT_NOTICE_STATE);
  }

  async function executeRegisterSave() {
    setRegisterLoading(true);
    setRegisterError("");

    try {
      const response = await api.post(
        resolveRequestPath(TAB_CONFIG.instructor.registerPath),
        createFormBody({
          id: registerForm.loginID,
          email: registerForm.email.trim(),
        }),
        {
          responseType: "text",
        },
      );

      const resultText = String(response.data ?? "").trim();

      if (!resultText || isHtmlResponseText(resultText)) {
        throw new Error(
          "강사 등록 처리 응답이 올바르지 않습니다. API 경로 설정을 확인해 주세요.",
        );
      }

      const parsed = parseRegisterResult(resultText, registerForm.loginID);
      const successMessage =
        parsed.loginID && parsed.tempPassword
          ? `강사 등록 되었습니다. 아이디: ${parsed.loginID} / 임시비밀번호: ${parsed.tempPassword}`
          : "강사 등록 되었습니다.";

      showNotice(successMessage);
      setRegisterOriginal({
        ...registerForm,
        email: registerForm.email.trim(),
      });
      setRegisterForm((prev) => ({
        ...prev,
        email: registerForm.email.trim(),
      }));
      setReloadTick((prev) => prev + 1);
    } catch (error) {
      const message =
        error?.message ||
        error?.response?.data?.message ||
        "강사 등록에 실패했습니다.";
      setRegisterError(message);
      showNotice("강사 등록에 실패했습니다.", "error");
    } finally {
      setRegisterLoading(false);
    }
  }

  executeRegisterSaveRef.current = executeRegisterSave;

  async function executeDetailSave() {
    if (!detailOriginal || !detailDraft) {
      return;
    }

    setSaveLoading(true);

    try {
      const requests = [];

      if (isStatusChanged) {
        requests.push(
          api.post(
            resolveRequestPath(tabConfig.statusSavePath, { apiPrefix: true }),
            createFormBody({
              loginID: detailDraft.loginID,
              status: detailDraft.status,
            }),
          ),
        );
      }

      if (activeTab === "instructor" && isEvalChanged) {
        requests.push(
          api.post(
            resolveRequestPath(TAB_CONFIG.instructor.evalSavePath, {
              apiPrefix: true,
            }),
            createFormBody({
              loginID: detailDraft.loginID,
              content: detailDraft.evalContent ?? "",
            }),
          ),
        );
      }

      await Promise.all(requests);

      const syncedDetail = {
        ...detailDraft,
        evalContent: detailDraft.evalContent ?? "",
      };

      setDetailOriginal(syncedDetail);
      setDetailDraft(syncedDetail);
      setReloadTick((prev) => prev + 1);

      if (detailDraft.loginID) {
        await loadUserDetail(detailDraft.loginID);
      }

      showNotice("수정되었습니다.");
    } catch {
      showNotice("수정에 실패했습니다.", "error");
    } finally {
      setSaveLoading(false);
    }
  }

  executeDetailSaveRef.current = executeDetailSave;

  function handleSave() {
    if (!isSaveEnabled) {
      return;
    }

    if (registerMode) {
      openConfirm("강사 등록을 하시겠습니까?", "register");
      return;
    }

    openConfirm("수정하시겠습니까?", "detail");
  }

  async function handleConfirmAccept() {
    const { actionType } = confirmState;
    closeConfirm();

    if (actionType === "register") {
      await executeRegisterSave();
      return;
    }

    if (actionType === "detail") {
      await executeDetailSave();
    }
  }

  async function handleRegisterMode() {
    setSelectedLoginId("");
    setDetailOriginal(null);
    setDetailDraft(null);
    setCourses([]);
    setDetailError("");
    setRegisterMode(true);
    setRegisterLoading(true);
    setRegisterError("");

    try {
      const response = await api.get(
        resolveRequestPath(TAB_CONFIG.instructor.registerIdPath),
        { responseType: "text" },
      );

      const issuedId = String(response.data ?? "").trim();

      if (!issuedId || isHtmlResponseText(issuedId)) {
        throw new Error(
          "신규 강사 ID 응답이 HTML 문서로 반환되었습니다. /api/inst/registerid 경로를 확인해 주세요.",
        );
      }

      setRegisterOriginal({
        loginID: issuedId,
        email: "",
      });
      setRegisterForm({
        loginID: issuedId,
        email: "",
      });
    } catch (error) {
      const message =
        error?.message ||
        error?.response?.data?.message ||
        "신규 강사 ID 발급에 실패했습니다.";
      setRegisterError(message);
      setRegisterOriginal({
        loginID: "",
        email: "",
      });
      setRegisterForm({
        loginID: "",
        email: "",
      });
    } finally {
      setRegisterLoading(false);
    }
  }

  function handleRegisterEmailChange(event) {
    const { value } = event.target;
    setRegisterForm((prev) => ({
      ...prev,
      email: value,
    }));
  }

  function handleResumeDownload() {
    if (!detailDraft?.loginID || !detailDraft?.hasResume) {
      return;
    }

    const query = new URLSearchParams({
      loginID: detailDraft.loginID,
    }).toString();
    const downloadUrl = `${resolveBrowserPath(TAB_CONFIG.student.resumeDownloadPath, { apiPrefix: true })}?${query}`;

    window.open(downloadUrl, "_blank", "noopener,noreferrer");
  }

  function renderPagination() {
    if (totalPages <= 1) {
      return null;
    }

    const blockStartPage =
      Math.floor((currentPage - 1) / PAGE_BLOCK_SIZE) * PAGE_BLOCK_SIZE + 1;

    const blockEndPage = Math.min(
      blockStartPage + PAGE_BLOCK_SIZE - 1,
      totalPages,
    );

    const pages = Array.from(
      { length: blockEndPage - blockStartPage + 1 },
      (_, index) => blockStartPage + index,
    );

    const goToPage = (page) => {
      const nextPage = Math.min(Math.max(page, 1), totalPages);
      setCurrentPage(nextPage);
    };

    return (
      <div className={styles.pagination}>
        <button
          type="button"
          className={styles.pageButton}
          disabled={currentPage === 1}
          onClick={() => goToPage(currentPage - 1)}
        >
          ‹
        </button>

        {blockStartPage > 1 && (
          <button
            type="button"
            className={styles.pageButton}
            onClick={() => goToPage(blockStartPage - 1)}
          >
            ...
          </button>
        )}

        {pages.map((page) => (
          <button
            key={page}
            type="button"
            className={`${styles.pageButton} ${
              page === currentPage ? styles.pageButtonActive : ""
            }`}
            onClick={() => goToPage(page)}
          >
            {page}
          </button>
        ))}

        {blockEndPage < totalPages && (
          <button
            type="button"
            className={styles.pageButton}
            onClick={() => goToPage(blockEndPage + 1)}
          >
            ...
          </button>
        )}

        <button
          type="button"
          className={styles.pageButton}
          disabled={currentPage === totalPages}
          onClick={() => goToPage(currentPage + 1)}
        >
          ›
        </button>
      </div>
    );
  }

  function renderCommonInfoCard() {
    if (!detailDraft) {
      return null;
    }

    return (
      <div className={styles.detailCard}>
        <h3 className={styles.cardTitle}>인적 사항</h3>
        <div className={styles.infoTable}>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>아이디</div>
            <div className={styles.infoValue}>
              {textOrDash(detailDraft.loginID)}
            </div>
            <div className={styles.infoLabel}>이름</div>
            <div className={styles.infoValue}>
              {textOrDash(detailDraft.name)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>전화번호</div>
            <div className={styles.infoValue}>
              {textOrDash(detailDraft.phone)}
            </div>
            <div className={styles.infoLabel}>생년월일</div>
            <div className={styles.infoValue}>
              {textOrDash(detailDraft.birthday)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>성별</div>
            <div className={styles.infoValue}>
              {textOrDash(detailDraft.gender)}
            </div>
            <div className={styles.infoLabel}>가입일</div>
            <div className={styles.infoValue}>
              {textOrDash(detailDraft.reg_date)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>이메일</div>
            <div className={`${styles.infoValue} ${styles.fullWidth}`}>
              {textOrDash(detailDraft.email)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>주소</div>
            <div className={`${styles.infoValue} ${styles.fullWidth}`}>
              {buildAddress(detailDraft)}
            </div>
          </div>

          {activeTab === "student" ? (
            <div className={styles.infoRow}>
              <div className={styles.infoLabel}>이력서</div>
              <div className={`${styles.infoValue} ${styles.fullWidth}`}>
                <div className={styles.inlineRow}>
                  <span>
                    {detailDraft.hasResume
                      ? textOrDash(detailDraft.resumeName)
                      : "이력서가 존재하지 않습니다."}
                  </span>
                  {detailDraft.hasResume && (
                    <button
                      type="button"
                      className={styles.linkButton}
                      onClick={handleResumeDownload}
                    >
                      다운로드
                    </button>
                  )}
                </div>
              </div>
            </div>
          ) : (
            <div className={styles.infoRow}>
              <div className={styles.infoLabel}>학력 / 경력</div>
              <div className={`${styles.infoValue} ${styles.fullWidth}`}>
                {[detailDraft.edu_level, detailDraft.career]
                  .filter(Boolean)
                  .join(" / ") || "-"}
              </div>
            </div>
          )}

          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>계정 상태 변경</div>
            <div className={`${styles.infoValue} ${styles.fullWidth}`}>
              <select
                className={styles.control}
                value={detailDraft.status ?? ""}
                onChange={handleStatusChange}
              >
                {activeTab === "instructor" && (
                  <option value="W">{STATUS_LABELS.W}</option>
                )}
                <option value="R">{STATUS_LABELS.R}</option>
                <option value="D">{STATUS_LABELS.D}</option>
                <option value="Q">{STATUS_LABELS.Q}</option>
              </select>
            </div>
          </div>
        </div>

        {/* TODO: img_logi_path/img_name의 실제 접근 URL 규칙이 확정되면 상세 카드에 프로필 이미지 미리보기 추가 */}
      </div>
    );
  }

  function renderCourseCard() {
    return (
      <div className={styles.detailCard}>
        <h3 className={styles.cardTitle}>
          {activeTab === "student" ? "수강 내역" : "강의 목록"}
        </h3>
        <div className={styles.tableWrap}>
          <table className={styles.table}>
            <thead>
              <tr>
                <th>강의명</th>
                <th>기간</th>
                <th>강의실</th>
                <th>강의 상태</th>
              </tr>
            </thead>
            <tbody>
              {courses.length === 0 ? (
                <tr>
                  <td colSpan="4" className={styles.tableMessage}>
                    {activeTab === "student"
                      ? "수강 내역이 없습니다."
                      : "강의 목록이 없습니다."}
                  </td>
                </tr>
              ) : (
                courses.map((course, index) => (
                  <tr key={`${course.title}-${course.start_date}-${index}`}>
                    <td>{textOrDash(course.title)}</td>
                    <td>{`${textOrDash(course.start_date)} ~ ${textOrDash(course.end_date)}`}</td>
                    <td>{textOrDash(course.class_name)}</td>
                    <td>{textOrDash(course.scs_name)}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  return (
    <>
      <div className={styles.page}>        
        <div className={styles.tabRow}>
          {Object.values(TAB_CONFIG).map((tab) => (
            <button
              key={tab.key}
              type="button"
              className={`${styles.tabButton} ${activeTab === tab.key ? styles.tabButtonActive : ""}`}
              onClick={() => handleTabChange(tab.key)}
            >
              {tab.label}
            </button>
          ))}
        </div>

        <section className={styles.searchCard}>
          <div className={styles.searchGrid}>
            <label className={styles.field}>
              <span className={styles.fieldLabel}>상태 필터</span>
              <select
                name="statusFilter"
                className={styles.control}
                value={searchForm.statusFilter}
                onChange={handleSearchChange}
              >
                {statusOptions.map((option) => (
                  <option key={option.value || "all"} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </label>

            <label className={styles.field}>
              <span className={styles.fieldLabel}>검색 조건</span>
              <select
                name="searchType"
                className={styles.control}
                value={searchForm.searchType}
                onChange={handleSearchChange}
              >
                {SEARCH_OPTIONS.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </label>

            <label className={`${styles.field} ${styles.keywordField}`}>
              <span className={styles.fieldLabel}>검색어</span>
              <input
                type="text"
                name="keyword"
                className={styles.control}
                value={searchForm.keyword}
                onChange={handleSearchChange}
                onKeyDown={handleSearchKeyDown}
                placeholder="검색어를 입력하세요"
              />
            </label>

            <div className={styles.searchActions}>
              <label className={styles.pageSizeField}>
                <span className={styles.fieldLabel}>페이지당 보기</span>
                <select
                  className={styles.pageSizeSelect}
                  value={pageSize}
                  onChange={handlePageSizeChange}
                >
                  {PAGE_SIZE_OPTIONS.map((size) => (
                    <option key={size} value={size}>
                      {size}
                    </option>
                  ))}
                </select>
              </label>
              <button
                type="button"
                className={styles.primaryButton}
                onClick={handleSearchSubmit}
              >
                검색
              </button>
              {activeTab === "instructor" && (
                <button
                  type="button"
                  className={styles.secondaryButton}
                  onClick={handleRegisterMode}
                >
                  강사 등록
                </button>
              )}
            </div>
          </div>
        </section>

        <section className={styles.listPanel}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>
              {activeTab === "student" ? "학생 목록" : "강사 목록"}
            </h2>
            <span className={styles.sectionMeta}>
              총 {listState.totalCount}건
            </span>
          </div>

          <div className={styles.tableWrap}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>아이디</th>
                  <th>이름</th>
                  <th>전화번호</th>
                  <th>가입일</th>
                  <th>계정상태</th>
                </tr>
              </thead>
              <tbody>
                {showListInitialLoading && (
                  <tr>
                    <td colSpan="5" className={styles.tableMessage}>
                      목록을 불러오는 중입니다.
                    </td>
                  </tr>
                )}

                {showListErrorState && (
                  <tr>
                    <td colSpan="5" className={styles.tableMessage}>
                      {listState.error}
                    </td>
                  </tr>
                )}

                {showListEmpty && (
                    <tr>
                      <td colSpan="5" className={styles.tableMessage}>
                        조회된 사용자가 없습니다.
                      </td>
                    </tr>
                )}

                {hasListData &&
                  listState.items.map((item) => (
                    <tr
                      key={item.loginID}
                      className={`${styles.tableRow} ${selectedLoginId === item.loginID ? styles.tableRowActive : ""}`}
                      onClick={() => loadUserDetail(item.loginID)}
                    >
                      <td>{textOrDash(item.loginID)}</td>
                      <td>{textOrDash(item.name)}</td>
                      <td>{textOrDash(item.phone)}</td>
                      <td>{formatListDate(item.reg_date)}</td>
                      <td>
                        <span
                          className={`${styles.statusBadge} ${styles[`status${item.status}`] || ""}`}
                        >
                          {STATUS_LABELS[item.status] ??
                            textOrDash(item.status)}
                        </span>
                      </td>
                    </tr>
                  ))}
              </tbody>
            </table>
            {showListOverlay && (
              <div className={styles.loadingOverlay} aria-hidden="true">
                <div className={styles.loadingIndicator}>
                  <span className={styles.loadingSpinner} />
                  <span className={styles.loadingText}>불러오는 중...</span>
                </div>
              </div>
            )}
          </div>

          {renderPagination()}
        </section>

        <section className={styles.detailPanel}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>
              {registerMode
                ? "신규 강사 등록"
                : activeTab === "student"
                  ? "학생 상세 정보"
                  : "강사 상세 정보"}
            </h2>
            <div className={styles.detailActions}>
              <button
                type="button"
                className={styles.primaryButton}
                disabled={!isSaveEnabled}
                onClick={handleSave}
              >
                {saveLoading || registerLoading ? "처리 중..." : "저장"}
              </button>
              <button
                type="button"
                className={styles.ghostButton}
                onClick={handleCancel}
              >
                취소
              </button>
            </div>
          </div>

          <div className={styles.detailBody}>
            {registerMode ? (
              <div className={styles.detailCard}>
                {registerLoading && !registerForm.loginID ? (
                  <div className={styles.emptyState}>
                    신규 강사 아이디를 발급하는 중입니다.
                  </div>
                ) : (
                  <div className={styles.registerWrap}>
                    <div className={styles.infoTable}>
                      <div className={styles.infoRow}>
                        <div className={styles.infoLabel}>아이디</div>
                        <div className={styles.infoValue}>
                          {textOrDash(registerForm.loginID)}
                        </div>
                      </div>
                      <div className={styles.infoRow}>
                        <div className={styles.infoLabel}>이메일</div>
                        <div className={styles.infoValue}>
                          <input
                            type="email"
                            className={styles.control}
                            value={registerForm.email}
                            onChange={handleRegisterEmailChange}
                            placeholder="example@domain.com"
                          />
                          <p className={styles.helperText}>
                            이메일 형식이 올바를 때만 저장 버튼이 활성화됩니다.
                          </p>
                          {registerError && (
                            <p className={styles.errorText}>{registerError}</p>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* TODO: 백엔드가 등록 완료 후 반환하는 상세 정보 스펙을 확정하면 성공 직후 상세 화면으로 자연스럽게 전환 */}
                  </div>
                )}
              </div>
            ) : showDetailInitialLoading ? (
              <div className={styles.emptyState}>
                상세 정보를 불러오는 중입니다.
              </div>
            ) : detailError && !hasDetailData ? (
              <div className={styles.emptyState}>{detailError}</div>
            ) : showDetailEmpty ? (
              <div className={styles.emptyState}>
                상단 목록에서 사용자를 선택하면 하단에 상세 정보가 표시됩니다.
              </div>
            ) : activeTab === "student" ? (
              <div className={styles.studentDetailGrid}>
                {renderCommonInfoCard()}
                {renderCourseCard()}
              </div>
            ) : (
              <div className={styles.instructorDetailGrid}>
                <div className={styles.leftColumn}>{renderCommonInfoCard()}</div>
                <div className={styles.rightColumn}>
                  {renderCourseCard()}
                  <div className={styles.detailCard}>
                    <h3 className={styles.cardTitle}>강사 평가 및 특이사항</h3>
                    <textarea
                      className={styles.textarea}
                      value={detailDraft.evalContent ?? ""}
                      onChange={handleEvalChange}
                      placeholder="강사 평가 및 특이사항을 입력하세요."
                    />
                  </div>
                </div>
              </div>
            )}

            {showDetailOverlay && (
              <div className={styles.loadingOverlay} aria-hidden="true">
                <div className={styles.loadingIndicator}>
                  <span className={styles.loadingSpinner} />
                  <span className={styles.loadingText}>불러오는 중...</span>
                </div>
              </div>
            )}
          </div>
        </section>

        {confirmState.open && (
          <div className={styles.confirmOverlay}>
            <div
              className={styles.confirmBox}
              role="dialog"
              aria-modal="true"
              aria-labelledby="admin-users-confirm-title"
            >
              <p id="admin-users-confirm-title" className={styles.confirmText}>
                {confirmState.message}
              </p>
              <div className={styles.confirmActions}>
                <button
                  ref={confirmAcceptButtonRef}
                  type="button"
                  className={styles.primaryButton}
                  onClick={handleConfirmAccept}
                >
                  확인
                </button>
                <button
                  type="button"
                  className={styles.ghostButton}
                  onClick={closeConfirm}
                >
                  취소
                </button>
              </div>
            </div>
          </div>
        )}

        {noticeState.open && !confirmState.open && (
          <div
            className={`${styles.noticeBox} ${noticeState.type === "error" ? styles.noticeError : styles.noticeSuccess}`}
          >
            <span className={styles.noticeText}>{noticeState.message}</span>
            <button
              type="button"
              className={styles.noticeButton}
              onClick={hideNotice}
            >
              확인
            </button>
          </div>
        )}
      </div>
    </>
  );
}

export default AdminUsersPage;
