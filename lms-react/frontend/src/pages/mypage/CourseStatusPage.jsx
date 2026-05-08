import { useEffect, useMemo, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import api from "../../api/axios";
import { useAuth } from "../../context/AuthContext";
import styles from "./CourseStatusPage.module.css";

const EMPTY_SUMMARY = {
  totalCount: 0,
  inProgressCount: 0,
  scheduledCount: 0,
  completedCount: 0,
};
const AJAX_REQUEST_CONFIG = { headers: { AJAX: "true" } };
const STUDENT_SEARCH_OPTIONS = [
  { value: "title", label: "강의명" },
  { value: "instructorName", label: "강사명" },
  { value: "className", label: "강의실" },
];
const INSTRUCTOR_SEARCH_OPTIONS = [
  { value: "title", label: "강의명" },
  { value: "className", label: "강의실" },
];

function normalizeCount(value) {
  const parsedValue = Number(value);
  return Number.isFinite(parsedValue) ? parsedValue : 0;
}

function getRoleConfig(userType, pathname) {
  const normalized = String(userType ?? "").toUpperCase();

  if (normalized === "I" || pathname.startsWith("/inst/")) {
    return {
      pageTitle: "강의 현황",
      endpoint: "/api/inst/my-page/course-status",
      detailPath: "/inst/course-list",
      isInstructor: true,
      searchOptions: INSTRUCTOR_SEARCH_OPTIONS,
    };
  }

  return {
    pageTitle: "수강 현황",
    endpoint: "/api/stu/my-page/course-status",
    detailPath: "/stu/my-courses",
    isInstructor: false,
    searchOptions: STUDENT_SEARCH_OPTIONS,
  };
}

function formatDateRange(startDate, endDate) {
  if (!startDate && !endDate) return "-";
  if (startDate && endDate) return `${startDate} ~ ${endDate}`;
  return startDate || endDate;
}

function formatTimeRange(startTime, endTime) {
  if (!startTime && !endTime) return "-";
  if (startTime && endTime) return `${startTime} ~ ${endTime}`;
  return startTime || endTime;
}

function buildDetailPath(basePath, courseId) {
  const normalizedCourseId = Number(courseId);

  if (!Number.isFinite(normalizedCourseId) || normalizedCourseId <= 0) {
    return basePath;
  }

  const params = new URLSearchParams({
    courseId: String(normalizedCourseId),
    source: "my",
  });

  return `${basePath}?${params.toString()}`;
}

function getSearchTarget(course, searchKey) {
  if (searchKey === "className") return course.className || "";
  if (searchKey === "instructorName") return course.instructorName || "";
  return course.title || "";
}

function createSearchState(searchKey) {
  return {
    searchKey,
    keyword: "",
  };
}

function CourseStatusPage() {
  const location = useLocation();
  const navigate = useNavigate();
  const { user } = useAuth();
  const roleConfig = useMemo(
    () => getRoleConfig(user?.userType, location.pathname),
    [location.pathname, user?.userType],
  );
  const defaultSearchKey = roleConfig.searchOptions[0]?.value ?? "title";

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [summary, setSummary] = useState(EMPTY_SUMMARY);
  const [courses, setCourses] = useState([]);
  const [activeFilter, setActiveFilter] = useState("total");
  const [searchForm, setSearchForm] = useState(() => createSearchState(defaultSearchKey));
  const [appliedSearch, setAppliedSearch] = useState(() => createSearchState(defaultSearchKey));

  useEffect(() => {
    let ignore = false;

    const loadCourseStatus = async () => {
      setLoading(true);
      setError("");

      try {
        const response = await api.get(roleConfig.endpoint, AJAX_REQUEST_CONFIG);
        if (ignore) return;

        if (response.data?.result === "FAIL") {
          throw new Error(response.data?.msg || "강의 현황을 불러오지 못했습니다.");
        }

        const responseSummary = response.data?.summary ?? {};
        setSummary({
          totalCount: normalizeCount(responseSummary.totalCount),
          inProgressCount: normalizeCount(responseSummary.inProgressCount),
          scheduledCount: normalizeCount(responseSummary.scheduledCount),
          completedCount: normalizeCount(responseSummary.completedCount),
        });
        setCourses(Array.isArray(response.data?.courses) ? response.data.courses : []);
      } catch (loadError) {
        console.error("마이페이지 강의 현황 조회 오류:", loadError);
        if (!ignore) {
          setError("강의 현황을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.");
          setSummary(EMPTY_SUMMARY);
          setCourses([]);
        }
      } finally {
        if (!ignore) setLoading(false);
      }
    };

    loadCourseStatus();
    return () => {
      ignore = true;
    };
  }, [roleConfig.endpoint]);

  useEffect(() => {
    const nextSearchState = createSearchState(defaultSearchKey);
    setActiveFilter("total");
    setSearchForm(nextSearchState);
    setAppliedSearch(nextSearchState);
  }, [defaultSearchKey, roleConfig.endpoint]);

  const summaryItems = [
    { key: "total", label: "전체 강좌", count: summary.totalCount },
    { key: "inProgress", label: "진행중", count: summary.inProgressCount },
    { key: "scheduled", label: "예정", count: summary.scheduledCount },
    { key: "completed", label: "완료", count: summary.completedCount },
  ];

  const activeFilterLabel = useMemo(
    () => summaryItems.find((item) => item.key === activeFilter)?.label ?? "전체 강좌",
    [activeFilter],
  );

  const filteredCourses = useMemo(() => {
    const keyword = appliedSearch.keyword.trim().toLowerCase();
    let nextCourses =
      activeFilter === "total"
        ? courses
        : courses.filter((course) => course.statusCode === activeFilter);

    if (!keyword) return nextCourses;

    return nextCourses.filter((course) =>
      String(getSearchTarget(course, appliedSearch.searchKey)).toLowerCase().includes(keyword),
    );
  }, [activeFilter, appliedSearch.keyword, appliedSearch.searchKey, courses]);

  const emptyMessage = useMemo(() => {
    if (appliedSearch.keyword.trim()) {
      return activeFilter === "total"
        ? "검색 결과가 없습니다."
        : `${activeFilterLabel} 강의 검색 결과가 없습니다.`;
    }

    if (activeFilter === "inProgress") return "진행중 강의가 없습니다.";
    if (activeFilter === "scheduled") return "예정 강의가 없습니다.";
    if (activeFilter === "completed") return "완료 강의가 없습니다.";
    return "등록된 강의가 없습니다.";
  }, [activeFilter, activeFilterLabel, appliedSearch.keyword]);

  const handleSearchFieldChange = (event) => {
    const { name, value } = event.target;
    setSearchForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSearchSubmit = () => {
    setAppliedSearch({
      searchKey: searchForm.searchKey,
      keyword: searchForm.keyword.trim(),
    });
  };

  const handleResetSearch = () => {
    const nextSearchState = createSearchState(defaultSearchKey);
    setSearchForm(nextSearchState);
    setAppliedSearch(nextSearchState);
  };

  const handleSearchKeyDown = (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      handleSearchSubmit();
    }
  };

  return (
    <div className={styles.page}>
      <section className={styles.sheet}>
        <header className={styles.pageHeader}>
          <h1 className={styles.pageTitle}>{roleConfig.pageTitle}</h1>
        </header>

        {loading ? (
          <section className={styles.feedbackCard}>강의 현황을 불러오는 중입니다.</section>
        ) : error ? (
          <section className={styles.feedbackCard}>
            <p className={styles.errorText}>{error}</p>
            <button
              type="button"
              className={styles.detailButton}
              onClick={() => window.location.reload()}
            >
              다시 시도
            </button>
          </section>
        ) : (
          <>
            <section className={styles.searchCard}>
              <div className={styles.searchGrid}>
                <label className={styles.field}>
                  <span className={styles.fieldLabel}>검색 조건</span>
                  <select
                    name="searchKey"
                    className={styles.control}
                    value={searchForm.searchKey}
                    onChange={handleSearchFieldChange}
                  >
                    {roleConfig.searchOptions.map((option) => (
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
                    onChange={handleSearchFieldChange}
                    onKeyDown={handleSearchKeyDown}
                    placeholder="검색어를 입력하세요"
                  />
                </label>

                <div className={styles.searchActions}>
                  <button
                    type="button"
                    className={styles.primaryButton}
                    onClick={handleSearchSubmit}
                  >
                    검색
                  </button>
                  <button
                    type="button"
                    className={styles.secondaryButton}
                    onClick={handleResetSearch}
                  >
                    초기화
                  </button>
                </div>
              </div>
            </section>

            <section className={styles.summaryGrid}>
              {summaryItems.map((item) => (
                <button
                  key={item.key}
                  type="button"
                  className={`${styles.summaryCard} ${styles[`${item.key}Card`]} ${
                    activeFilter === item.key ? styles.summaryCardActive : ""
                  }`}
                  onClick={() => setActiveFilter(item.key)}
                >
                  <span className={styles.summaryLabel}>{item.label}</span>
                  <strong className={styles.summaryCount}>{item.count}</strong>
                </button>
              ))}
            </section>

            <section className={styles.courseList}>
              {filteredCourses.length === 0 ? (
                <article className={styles.emptyCard}>{emptyMessage}</article>
              ) : (
                filteredCourses.map((course) => (
                  <article key={course.courseId} className={styles.courseCard}>
                    <div className={styles.courseInfo}>
                      <div className={styles.courseHead}>
                        <h2 className={styles.courseTitle}>{course.title}</h2>
                        <span
                          className={`${styles.statusBadge} ${
                            styles[`${course.statusCode}Badge`]
                          }`}
                        >
                          {course.statusLabel}
                        </span>
                      </div>

                      <p className={styles.metaLine}>
                        {roleConfig.isInstructor
                          ? `수강생 수: ${normalizeCount(course.studentCount)}명`
                          : `${course.instructorName || "-"} 교수`}
                        {" / "}강의실: {course.className || "-"}
                      </p>
                      <p className={styles.metaLine}>
                        강의 기간: {formatDateRange(course.startDate, course.endDate)}
                        {" / "}강의 시간: {formatTimeRange(course.startTime, course.endTime)}
                      </p>
                    </div>

                    <button
                      type="button"
                      className={styles.detailButton}
                      onClick={() => navigate(buildDetailPath(roleConfig.detailPath, course.courseId))}
                    >
                      강의 상세보기로 이동
                    </button>
                  </article>
                ))
              )}
            </section>
          </>
        )}
      </section>
    </div>
  );
}

export default CourseStatusPage;
