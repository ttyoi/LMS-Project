import { useEffect, useMemo, useRef, useState } from "react";
import { useLocation } from "react-router-dom";
import api from "../../api/axios";
import { useAuth } from "../../context/AuthContext";
import styles from "./NoticePage.module.css";

const PAGE_SIZE_OPTIONS = [5, 10, 20];
const PAGE_BLOCK_SIZE = 5;

const SEARCH_OPTIONS = [
  { value: "all", label: "전체" },
  { value: "title", label: "제목" },
  { value: "content", label: "내용" },
];

const DEFAULT_NOTICE = {
  open: false,
  message: "",
  type: "success",
};

const DEFAULT_CONFIRM = {
  open: false,
  message: "",
  actionType: "",
};

const DEFAULT_SEARCH_FORM = {
  searchType: "all",
  keyword: "",
};

function createFormBody(payload) {
  const searchParams = new URLSearchParams();

  Object.entries(payload).forEach(([key, value]) => {
    if (value !== undefined && value !== null) {
      searchParams.append(key, String(value));
    }
  });

  return searchParams;
}

function getRoleConfig(userType, pathname) {
  const normalizedUserType = String(userType ?? "").toUpperCase();

  if (normalizedUserType === "A" || pathname.startsWith("/admin/")) {
    return {
      userType: "A",
      listPath: "/admin/notices/list.do",
      canManage: true,
    };
  }

  if (normalizedUserType === "I" || pathname.startsWith("/inst/")) {
    return {
      userType: "I",
      listPath: "/inst/notices/list.do",
      canManage: false,
    };
  }

  return {
    userType: "S",
    listPath: "/stu/notices/list.do",
    canManage: false,
  };
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
    if (Number.isNaN(date.getTime())) {
      return raw;
    }

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");

    return `${year}-${month}-${day}`;
  }

  return raw.length >= 10 ? raw.slice(0, 10) : raw;
}

function normalizeDetail(notice) {
  if (!notice) {
    return null;
  }

  return {
    notice_id: notice.notice_id,
    title: notice.title ?? "",
    content: notice.content ?? "",
    reg_date: notice.reg_date ?? "",
    user: notice.user ?? notice.loginID ?? "관리자",
    loginID: notice.loginID ?? "",
    view_count: Number(notice.view_count ?? 0),
  };
}

function NoticePage() {
  const location = useLocation();
  const { user } = useAuth();

  const roleConfig = useMemo(
    () => getRoleConfig(user?.userType, location.pathname),
    [location.pathname, user?.userType],
  );

  const [searchForm, setSearchForm] = useState(DEFAULT_SEARCH_FORM);
  const [appliedSearch, setAppliedSearch] = useState(DEFAULT_SEARCH_FORM);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(5);
  const [orderType, setOrderType] = useState("DESC");
  const [reloadTick, setReloadTick] = useState(0);

  const [listState, setListState] = useState({
    items: [],
    totalCount: 0,
    loading: false,
    error: "",
  });

  const [selectedNoticeId, setSelectedNoticeId] = useState(null);
  const [selectedNotice, setSelectedNotice] = useState(null);
  const [detailMode, setDetailMode] = useState("view");
  const [detailLoading, setDetailLoading] = useState(false);
  const [detailError, setDetailError] = useState("");

  const [draftTitle, setDraftTitle] = useState("");
  const [draftContent, setDraftContent] = useState("");
  const [originalTitle, setOriginalTitle] = useState("");
  const [originalContent, setOriginalContent] = useState("");
  const [saveLoading, setSaveLoading] = useState(false);
  const [viewedNoticeIds, setViewedNoticeIds] = useState([]);

  const [confirmState, setConfirmState] = useState(DEFAULT_CONFIRM);
  const [noticeState, setNoticeState] = useState(DEFAULT_NOTICE);

  const confirmAcceptButtonRef = useRef(null);

  const totalPages = Math.ceil(listState.totalCount / pageSize);
  const isAdmin = roleConfig.canManage;
  const isCreateMode = detailMode === "create";
  const isEditMode = detailMode === "edit";
  const hasSelectedNotice = Boolean(selectedNoticeId && selectedNotice);
  const hasListData = listState.items.length > 0;
  const hasDetailData = Boolean(selectedNotice);
  const showListInitialLoading = listState.loading && !hasListData;
  const showListErrorState =
    !listState.loading && !hasListData && Boolean(listState.error);
  const showListEmpty =
    !listState.loading && !listState.error && !hasListData;
  const showListOverlay = listState.loading && hasListData;
  const showDetailInitialLoading =
    detailLoading && !hasDetailData && !isCreateMode && !isEditMode;
  const showDetailEmpty =
    !detailLoading &&
    !detailError &&
    !hasDetailData &&
    !isCreateMode &&
    !isEditMode;
  const showDetailOverlay = detailLoading && hasDetailData;

  const trimmedDraftTitle = draftTitle.trim();
  const trimmedDraftContent = draftContent.trim();
  const isDraftFilled = Boolean(trimmedDraftTitle && trimmedDraftContent);
  const isDraftChanged =
    trimmedDraftTitle !== originalTitle.trim() ||
    trimmedDraftContent !== originalContent.trim();

  const isSaveEnabled = isCreateMode
    ? isDraftFilled && !saveLoading
    : isEditMode
      ? isDraftFilled && isDraftChanged && !saveLoading
      : false;

  useEffect(() => {
    setSearchForm(DEFAULT_SEARCH_FORM);
    setAppliedSearch(DEFAULT_SEARCH_FORM);
    setCurrentPage(1);
    setPageSize(5);
    setOrderType("DESC");
    setReloadTick(0);
    setListState({
      items: [],
      totalCount: 0,
      loading: false,
      error: "",
    });
    setSelectedNoticeId(null);
    setSelectedNotice(null);
    setDetailMode("view");
    setDetailLoading(false);
    setDetailError("");
    setDraftTitle("");
    setDraftContent("");
    setOriginalTitle("");
    setOriginalContent("");
    setSaveLoading(false);
    setViewedNoticeIds([]);
    setConfirmState(DEFAULT_CONFIRM);
    setNoticeState(DEFAULT_NOTICE);
  }, [roleConfig.listPath]);

  useEffect(() => {
    let isMounted = true;

    async function loadList() {
      setListState((prev) => ({
        ...prev,
        loading: true,
        error: "",
      }));

      try {
        const response = await api.get(roleConfig.listPath, {
          params: {
            currentPage,
            pageSize,
            searchType: appliedSearch.searchType,
            sname: appliedSearch.keyword.trim(),
            orderType,
          },
        });

        if (!isMounted) {
          return;
        }

        const data = response.data ?? {};
        const items = Array.isArray(data.notice) ? data.notice : [];
        const totalCount = Number(data.noticeCnt ?? 0);

        setListState({
          items,
          totalCount,
          loading: false,
          error: "",
        });

        if (selectedNoticeId && !isCreateMode && !isEditMode) {
          const exists = items.some(
            (item) => Number(item.notice_id) === Number(selectedNoticeId),
          );

          if (!exists) {
            setSelectedNoticeId(null);
            setSelectedNotice(null);
            setDetailError("");
          }
        }
      } catch (error) {
        if (!isMounted) {
          return;
        }

        setListState((prev) => ({
          ...prev,
          loading: false,
          error:
            error?.response?.data?.message ||
            "공지사항 목록을 불러오지 못했습니다.",
        }));
      }
    }

    loadList();

    return () => {
      isMounted = false;
    };
  }, [
    appliedSearch,
    currentPage,
    orderType,
    pageSize,
    reloadTick,
    roleConfig.listPath,
    selectedNoticeId,
    isCreateMode,
    isEditMode,
  ]);

  useEffect(() => {
    if (!confirmState.open) {
      return undefined;
    }

    confirmAcceptButtonRef.current?.focus();

    function handleKeyDown(event) {
      if (event.key === "Escape") {
        event.preventDefault();
        setConfirmState(DEFAULT_CONFIRM);
      }
    }

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [confirmState.open]);

  function showNotice(message, type = "success") {
    setNoticeState({
      open: true,
      message,
      type,
    });
  }

  function hideNotice() {
    setNoticeState(DEFAULT_NOTICE);
  }

  function closeConfirm() {
    setConfirmState(DEFAULT_CONFIRM);
  }

  function openConfirm(message, actionType) {
    setConfirmState({
      open: true,
      message,
      actionType,
    });
  }

  function syncDraftFromNotice(notice) {
    const normalized = normalizeDetail(notice);

    if (!normalized) {
      setDraftTitle("");
      setDraftContent("");
      setOriginalTitle("");
      setOriginalContent("");
      return;
    }

    setDraftTitle(normalized.title);
    setDraftContent(normalized.content);
    setOriginalTitle(normalized.title);
    setOriginalContent(normalized.content);
  }

  async function fetchNoticeDetail(noticeId) {
    const hadDetailData = Boolean(selectedNotice);

    setDetailLoading(true);
    setDetailError("");

    try {
      const response = await api.get("/admin/notices/detail.do", {
        params: { noticeId },
      });

      const nextNotice = normalizeDetail(response.data?.notice);

      if (!nextNotice) {
        throw new Error("존재하지 않는 공지사항입니다.");
      }

      setSelectedNoticeId(nextNotice.notice_id);
      setSelectedNotice(nextNotice);
      setDetailMode("view");
      syncDraftFromNotice(nextNotice);
    } catch (error) {
      if (!hadDetailData) {
        setSelectedNotice(null);
      }
      setDetailError(
        error?.response?.data?.message ||
          error?.message ||
          "공지사항 상세 정보를 불러오지 못했습니다.",
      );
    } finally {
      setDetailLoading(false);
    }
  }

  async function handleRowClick(noticeId) {
    const numericId = Number(noticeId);
    const alreadyViewed = viewedNoticeIds.includes(numericId);

    setSelectedNoticeId(numericId);

    try {
      if (!alreadyViewed) {
        await api.post(
          "/admin/notices/viewCount/list.do",
          createFormBody({ noticeId: numericId }),
        );
        setViewedNoticeIds((prev) =>
          prev.includes(numericId) ? prev : [...prev, numericId],
        );
      }

      await fetchNoticeDetail(numericId);
      setReloadTick((prev) => prev + 1);
    } catch {
      await fetchNoticeDetail(numericId);
      setReloadTick((prev) => prev + 1);
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

  function handlePageSizeChange(event) {
    setPageSize(Number(event.target.value));
    setCurrentPage(1);
  }

  function handleSortToggle() {
    setOrderType((prev) => (prev === "DESC" ? "ASC" : "DESC"));
    setCurrentPage(1);
  }

  function handleCreateMode() {
    if (!isAdmin) {
      return;
    }

    setSelectedNoticeId(null);
    setSelectedNotice(null);
    setDetailError("");
    setDetailMode("create");
    setDraftTitle("");
    setDraftContent("");
    setOriginalTitle("");
    setOriginalContent("");
  }

  function handleEditMode() {
    if (!isAdmin || !selectedNotice) {
      return;
    }

    setDetailMode("edit");
    syncDraftFromNotice(selectedNotice);
  }

  function handleCancel() {
    if (isCreateMode) {
      setDetailMode("view");
      setDraftTitle("");
      setDraftContent("");
      setOriginalTitle("");
      setOriginalContent("");
      setDetailError("");
      return;
    }

    if (isEditMode) {
      if (selectedNotice) {
        syncDraftFromNotice(selectedNotice);
      }
      setDetailMode("view");
    }
  }

  async function executeSave() {
    if (!isSaveEnabled) {
      return;
    }

    setSaveLoading(true);

    try {
      if (isCreateMode) {
        const response = await api.post(
          "/admin/notices/insertNotice/list.do",
          createFormBody({
            title: trimmedDraftTitle,
            content: trimmedDraftContent,
          }),
        );

        if (response.data?.result !== "success") {
          throw new Error(
            response.data?.message || "공지사항 등록에 실패했습니다.",
          );
        }

        setDetailMode("view");
        setDraftTitle("");
        setDraftContent("");
        setOriginalTitle("");
        setOriginalContent("");
        setSelectedNoticeId(null);
        setSelectedNotice(null);
        setCurrentPage(1);
        setReloadTick((prev) => prev + 1);
        showNotice("공지사항이 등록되었습니다.");
        return;
      }

      if (isEditMode && selectedNoticeId) {
        const response = await api.post(
          "/admin/notices/updateContent/list.do",
          createFormBody({
            noticeId: selectedNoticeId,
            title: trimmedDraftTitle,
            content: trimmedDraftContent,
          }),
        );

        if (response.data?.result !== "success") {
          throw new Error(
            response.data?.message || "공지사항 수정에 실패했습니다.",
          );
        }

        await fetchNoticeDetail(selectedNoticeId);
        setReloadTick((prev) => prev + 1);
        showNotice("공지사항이 수정되었습니다.");
      }
    } catch (error) {
      showNotice(
        error?.response?.data?.message ||
          error?.message ||
          "공지사항 저장에 실패했습니다.",
        "error",
      );
    } finally {
      setSaveLoading(false);
    }
  }

  async function executeDelete() {
    if (!selectedNoticeId) {
      return;
    }

    setSaveLoading(true);

    try {
      const response = await api.post(
        "/admin/notices/deleteNotice/list.do",
        createFormBody({ noticeId: selectedNoticeId }),
      );

      if (response.data?.result !== "success") {
        throw new Error(response.data?.message || "공지사항 삭제에 실패했습니다.");
      }

      setSelectedNoticeId(null);
      setSelectedNotice(null);
      setDetailMode("view");
      setDetailError("");
      setDraftTitle("");
      setDraftContent("");
      setOriginalTitle("");
      setOriginalContent("");
      setViewedNoticeIds((prev) =>
        prev.filter((noticeId) => noticeId !== Number(selectedNoticeId)),
      );
      setReloadTick((prev) => prev + 1);
      showNotice("공지사항이 삭제되었습니다.");
    } catch (error) {
      showNotice(
        error?.response?.data?.message ||
          error?.message ||
          "공지사항 삭제에 실패했습니다.",
        "error",
      );
    } finally {
      setSaveLoading(false);
    }
  }

  async function handleConfirmAccept() {
    const { actionType } = confirmState;
    closeConfirm();

    if (actionType === "save") {
      await executeSave();
      return;
    }

    if (actionType === "delete") {
      await executeDelete();
    }
  }

  function handleSaveClick() {
    if (!isSaveEnabled) {
      return;
    }

    openConfirm(
      isCreateMode
        ? "공지사항을 등록하시겠습니까?"
        : "공지사항을 수정하시겠습니까?",
      "save",
    );
  }

  function handleDeleteClick() {
    if (!isAdmin || !selectedNoticeId) {
      return;
    }

    openConfirm("공지사항을 삭제하시겠습니까?", "delete");
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

  function renderDetailBody() {
    if (showDetailInitialLoading) {
      return (
        <div className={styles.emptyState}>공지사항 상세 정보를 불러오는 중입니다.</div>
      );
    }

    if (isCreateMode || isEditMode) {
      return (
        <div className={styles.detailCard}>
          <div className={styles.formGrid}>
            <label className={styles.field}>
              <span className={styles.fieldLabel}>제목</span>
              <input
                type="text"
                className={styles.control}
                value={draftTitle}
                onChange={(event) => setDraftTitle(event.target.value)}
                placeholder="제목을 입력하세요."
              />
            </label>

            <label className={styles.field}>
              <span className={styles.fieldLabel}>내용</span>
              <textarea
                className={styles.textarea}
                value={draftContent}
                onChange={(event) => setDraftContent(event.target.value)}
                placeholder="공지 내용을 입력하세요."
              />
            </label>
          </div>
          <p className={styles.helperText}>
            {isCreateMode
              ? "제목과 내용을 입력하면 저장 버튼이 활성화됩니다."
              : "제목 또는 내용을 변경했을 때만 저장 버튼이 활성화됩니다."}
          </p>
        </div>
      );
    }

    if (detailError && !hasDetailData) {
      return <div className={styles.emptyState}>{detailError}</div>;
    }

    if (showDetailEmpty) {
      return (
        <div className={styles.emptyState}>
          상단 목록에서 공지사항을 선택하면 상세 내용이 표시됩니다.
        </div>
      );
    }

    return (
      <div className={styles.detailCard}>
        <div className={styles.infoTable}>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>글번호</div>
            <div className={styles.infoValue}>
              {textOrDash(selectedNotice.notice_id)}
            </div>
            <div className={styles.infoLabel}>등록일</div>
            <div className={styles.infoValue}>
              {formatListDate(selectedNotice.reg_date)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>작성자</div>
            <div className={styles.infoValue}>
              {textOrDash(selectedNotice.user)}
            </div>
            <div className={styles.infoLabel}>조회수</div>
            <div className={styles.infoValue}>
              {textOrDash(selectedNotice.view_count)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>제목</div>
            <div className={`${styles.infoValue} ${styles.fullWidth}`}>
              {textOrDash(selectedNotice.title)}
            </div>
          </div>
          <div className={styles.infoRow}>
            <div className={styles.infoLabel}>내용</div>
            <div className={`${styles.infoValue} ${styles.fullWidth}`}>
              <div className={styles.contentValue}>
                {selectedNotice.content || "내용이 없습니다."}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <>
      <div className={styles.page}>
        <section className={styles.searchCard}>
          <div className={styles.searchGrid}>
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

              {isAdmin && (
                <button
                  type="button"
                  className={styles.secondaryButton}
                  onClick={handleCreateMode}
                >
                  신규 공지 작성
                </button>
              )}
            </div>
          </div>
        </section>

        <section className={styles.listPanel}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>공지 목록</h2>
            <span className={styles.sectionMeta}>총 {listState.totalCount}건</span>
          </div>

          <div className={styles.tableWrap}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>번호</th>
                  <th>제목</th>
                  <th>작성자</th>
                  <th>
                    <button
                      type="button"
                      className={styles.sortButton}
                      onClick={handleSortToggle}
                    >
                      등록일 {orderType === "DESC" ? "▼" : "▲"}
                    </button>
                  </th>
                  <th>조회수</th>
                </tr>
              </thead>
              <tbody>
                {showListInitialLoading && (
                  <tr>
                    <td colSpan="5" className={styles.tableMessage}>
                      공지사항 목록을 불러오는 중입니다.
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
                        조회된 공지사항이 없습니다.
                      </td>
                    </tr>
                )}

                {hasListData &&
                  listState.items.map((item, index) => {
                    const virtualNumber =
                      listState.totalCount - (currentPage - 1) * pageSize - index;
                    const itemId = Number(item.notice_id);

                    return (
                      <tr
                        key={itemId}
                        className={`${styles.tableRow} ${selectedNoticeId === itemId ? styles.tableRowActive : ""}`}
                        onClick={() => handleRowClick(itemId)}
                      >
                        <td>{virtualNumber}</td>
                        <td className={styles.titleCell}>{textOrDash(item.title)}</td>
                        <td>{textOrDash(item.user)}</td>
                        <td>{formatListDate(item.reg_date)}</td>
                        <td>{textOrDash(item.view_count ?? 0)}</td>
                      </tr>
                    );
                  })}
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
              {isCreateMode
                ? "신규 공지 작성"
                : isEditMode
                  ? "공지사항 수정"
                  : "공지사항 상세"}
            </h2>

            <div className={styles.detailActions}>
              {(isCreateMode || isEditMode) && isAdmin ? (
                <>
                  <button
                    type="button"
                    className={styles.primaryButton}
                    disabled={!isSaveEnabled}
                    onClick={handleSaveClick}
                  >
                    {saveLoading ? "처리 중..." : "저장"}
                  </button>
                  <button
                    type="button"
                    className={styles.ghostButton}
                    onClick={handleCancel}
                  >
                    취소
                  </button>
                </>
              ) : isAdmin ? (
                <>
                  <button
                    type="button"
                    className={styles.secondaryButton}
                    disabled={!hasSelectedNotice}
                    onClick={handleEditMode}
                  >
                    수정
                  </button>
                  <button
                    type="button"
                    className={styles.dangerButton}
                    disabled={!hasSelectedNotice || saveLoading}
                    onClick={handleDeleteClick}
                  >
                    삭제
                  </button>
                </>
              ) : null}
            </div>
          </div>

          <div className={styles.detailBody}>
            {renderDetailBody()}
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
              aria-labelledby="notice-confirm-title"
            >
              <p id="notice-confirm-title" className={styles.confirmText}>
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

export default NoticePage;
