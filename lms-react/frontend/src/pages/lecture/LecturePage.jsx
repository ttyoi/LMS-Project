import { useEffect, useMemo, useRef, useState } from "react";
import { useLocation } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import api from "../../api/axios";

const colNoStyle = { width: "80px" };
const colTitleStyle = { width: "260px" };
const colRoomStyle = { width: "100px" };
const colPeriodStyle = { width: "320px" };

const pageStyle = {
  padding: "20px",
  background: "#f7f7f7",
  minHeight: "100%",
  fontFamily: "Arial, sans-serif",
};

const cardStyle = {
  background: "#fff",
  border: "1px solid #d9d9d9",
  borderRadius: "8px",
  boxShadow: "0 1px 3px rgba(0,0,0,0.06)",
};

const sectionTitleStyle = {
  fontSize: "28px",
  fontWeight: 700,
  margin: "0",
};

const labelCellStyle = {
  width: "90px",
  background: "#f3f7df",
  border: "1px solid #d7e39f",
  padding: "10px 12px",
  fontWeight: 700,
  fontSize: "14px",
  display: "flex",
  alignItems: "center",
};

const valueCellStyle = {
  flex: 1,
  border: "1px solid #d7e39f",
  padding: "10px 12px",
  minHeight: "42px",
  background: "#fff",
  fontSize: "14px",
  display: "flex",
  alignItems: "center",
};

const registerLabelCellStyle = {
  width: "90px",
  background: "#e8f1ff",
  border: "1px solid #9fc3ff",
  padding: "10px 12px",
  fontWeight: 700,
  fontSize: "14px",
  display: "flex",
  alignItems: "center",
  color: "#1d4f91",
};

const registerValueCellStyle = {
  flex: 1,
  border: "1px solid #9fc3ff",
  padding: "10px 12px",
  minHeight: "42px",
  background: "#f7fbff",
  fontSize: "14px",
  display: "flex",
  alignItems: "center",
};

const inputStyle = {
  width: "100%",
  height: "40px",
  border: "1px solid #cfd8a3",
  padding: "0 10px",
  outline: "none",
  fontSize: "14px",
  boxSizing: "border-box",
};

const registerInputStyle = {
  width: "100%",
  height: "40px",
  border: "1px solid #8fb6ff",
  padding: "0 10px",
  outline: "none",
  fontSize: "14px",
  boxSizing: "border-box",
  background: "#ffffff",
  color: "#123a74",
  boxShadow: "inset 0 0 0 1px rgba(65,131,215,0.06)",
};

const selectStyle = {
  width: "100%",
  height: "40px",
  border: "1px solid #cfd8a3",
  padding: "0 10px",
  outline: "none",
  fontSize: "14px",
  boxSizing: "border-box",
  background: "#fff",
};

const focusedSearchSelectStyle = {
  ...selectStyle,
  border: "1px solid #4a90e2",
  boxShadow: "0 0 0 3px rgba(74,144,226,0.18)",
  background: "#f8fbff",
};

const registerSelectStyle = {
  width: "100%",
  height: "40px",
  border: "1px solid #8fb6ff",
  padding: "0 10px",
  outline: "none",
  fontSize: "14px",
  boxSizing: "border-box",
  background: "#ffffff",
  color: "#123a74",
  boxShadow: "inset 0 0 0 1px rgba(65,131,215,0.06)",
};

const focusedRegisterSelectStyle = {
  ...registerSelectStyle,
  border: "1px solid #1677ff",
  boxShadow: "0 0 0 3px rgba(22,119,255,0.18)",
  background: "#f8fbff",
};

const textareaStyle = {
  width: "100%",
  minHeight: "120px",
  border: "1px solid #cfd8a3",
  padding: "10px",
  outline: "none",
  fontSize: "14px",
  boxSizing: "border-box",
  resize: "vertical",
};

const registerTextareaStyle = {
  width: "100%",
  minHeight: "120px",
  border: "1px solid #8fb6ff",
  padding: "10px",
  outline: "none",
  fontSize: "14px",
  boxSizing: "border-box",
  resize: "vertical",
  background: "#ffffff",
  color: "#123a74",
  boxShadow: "inset 0 0 0 1px rgba(65,131,215,0.06)",
};

const buttonBaseStyle = {
  height: "36px",
  minWidth: "88px",
  border: "1px solid #c8c8c8",
  background: "#efefef",
  cursor: "pointer",
  padding: "0 14px",
  borderRadius: "4px",
  fontSize: "14px",
};

const disabledButtonStyle = {
  ...buttonBaseStyle,
  background: "#f5f5f5",
  color: "#999",
  border: "1px solid #ddd",
  cursor: "not-allowed",
};

const thStyle = {
  border: "1px solid #999",
  padding: "10px 8px",
  fontSize: "14px",
  position: "sticky",
  top: 0,
  background: "#d9d9d9",
  zIndex: 2,
};

const tdStyle = {
  border: "1px solid #c9c9c9",
  padding: "10px 8px",
  fontSize: "14px",
  textAlign: "center",
};

const emptyTdStyle = {
  ...tdStyle,
  padding: "24px 8px",
};

const tableScrollStyle = {
  maxHeight: "260px",
  overflowY: "scroll",
  overflowX: "hidden",
};

const searchCardStyle = {
  ...cardStyle,
  padding: "10px 12px",
  marginBottom: "14px",
};

const emptyForm = {
  course_id: "",
  title: "",
  sub_prof: "",
  classId: "",
  time_code: "",
  start_date: "",
  end_date: "",
  content: "",
  plan: "",
  notice: "",
};

const initialSearchForm = {
  searchKey: "all",
  searchWord: "",
  startDate: "",
  endDate: "",
};

function parseRequestedCourseSelection(search) {
  const params = new URLSearchParams(search);
  const courseId = Number(params.get("courseId"));
  const source = params.get("source") === "all" ? "all" : "my";

  if (!Number.isFinite(courseId) || courseId <= 0) {
    return null;
  }

  return {
    courseId,
    source,
  };
}

export default function LecturePage() {
  const location = useLocation();
  const { user } = useAuth();

  const role = normalizeRole(user?.userType);
  const loginID = user?.loginId || "";
  const userName = user?.userNm || "";
  const requestedSelection = useMemo(
    () => parseRequestedCourseSelection(location.search),
    [location.search]
  );

  const isStudent = role === "student";
  const isInstructor = role === "instructor";

  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  const [allCourses, setAllCourses] = useState([]);
  const [myCourses, setMyCourses] = useState([]);

  const [searchForm, setSearchForm] = useState(initialSearchForm);
  const [isSearchKeyFocused, setIsSearchKeyFocused] = useState(false);

  const [isSubProfFocused, setIsSubProfFocused] = useState(false);
  const [isTimeCodeFocused, setIsTimeCodeFocused] = useState(false);
  const [isClassIdFocused, setIsClassIdFocused] = useState(false);

  const [selectedSource, setSelectedSource] = useState("all");
  const [selectedCourseId, setSelectedCourseId] = useState(null);
  const [selectedDetail, setSelectedDetail] = useState(null);

  const [detailTab, setDetailTab] = useState("detail");
  const [registerForm, setRegisterForm] = useState(emptyForm);

  const [classOptions, setClassOptions] = useState([]);
  const [timeOptions, setTimeOptions] = useState([]);
  const [subInstructorOptions, setSubInstructorOptions] = useState([]);

  const rowRefs = useRef({ all: [], my: [] });
  const searchAreaRef = useRef(null);
  const searchInputRef = useRef(null);
  const lastSelectedCourseRef = useRef({
    source: "all",
    courseId: null,
    detail: null,
  });

  const [keyboardCursor, setKeyboardCursor] = useState({
    source: "all",
    index: 0,
  });

  const filteredAllCourses = useMemo(() => {
    return filterCoursesBySearchForm(allCourses, searchForm);
  }, [allCourses, searchForm]);

  const filteredMyCourses = useMemo(() => {
    return filterCoursesBySearchForm(myCourses, searchForm);
  }, [myCourses, searchForm]);

  const selectedRowKey = useMemo(() => {
    if (!selectedCourseId) return "";
    return `${selectedSource}-${selectedCourseId}`;
  }, [selectedSource, selectedCourseId]);

  const canDeleteStudentCourse =
    isStudent &&
    selectedSource === "my" &&
    !!selectedDetail?.course_id;

  const canDeleteInstructorCourse =
    isInstructor &&
    detailTab !== "register" &&
    selectedSource === "my" &&
    !!selectedDetail?.course_id;

  const isRegisterMode = detailTab === "register";
  const isMyCourseEditMode =
    isInstructor &&
    detailTab === "detail" &&
    selectedSource === "my" &&
    !!selectedDetail?.course_id;

  const isEditableMode = isRegisterMode || isMyCourseEditMode;

  const activeLabelCellStyle = isRegisterMode
    ? registerLabelCellStyle
    : labelCellStyle;
  const activeValueCellStyle = isRegisterMode
    ? registerValueCellStyle
    : valueCellStyle;
  const activeInputStyle = isRegisterMode ? registerInputStyle : inputStyle;
  const activeSelectStyle = isRegisterMode ? registerSelectStyle : selectStyle;
  const activeTextareaStyle = isRegisterMode
    ? registerTextareaStyle
    : textareaStyle;

  const originalDetailForm = useMemo(() => {
    return mapDetailToForm(selectedDetail);
  }, [selectedDetail]);

  const isEditDirty = useMemo(() => {
    if (!isMyCourseEditMode) return false;
    return !isSameForm(registerForm, originalDetailForm);
  }, [isMyCourseEditMode, registerForm, originalDetailForm]);

  const isRegisterDirty = useMemo(() => {
    if (!isRegisterMode) return false;
    return !isSameForm(registerForm, emptyForm);
  }, [isRegisterMode, registerForm]);

  const canSaveInstructor =
    isInstructor &&
    !saving &&
    ((isRegisterMode && isRegisterDirty) || (isMyCourseEditMode && isEditDirty));

  const canResetInstructor =
    isInstructor &&
    ((isRegisterMode && isRegisterDirty) || (isMyCourseEditMode && isEditDirty));

  useEffect(() => {
    if (!user) return;
    loadPageData({
      preserveSelection: Boolean(requestedSelection?.courseId),
      preservedSource: requestedSelection?.source || "all",
      preservedCourseId: requestedSelection?.courseId || null,
    });
  }, [user, requestedSelection]);

  useEffect(() => {
    if (!user) return;
    if (isInstructor) {
      loadInstructorMeta();
    }
  }, [user, isInstructor]);

  useEffect(() => {
    if (loading) return;

    setTimeout(() => {
      searchInputRef.current?.focus();
    }, 0);
  }, [loading]);

  useEffect(() => {
    if (loading) return;
    if (detailTab === "register") return;

    const currentRows =
      selectedSource === "my" ? filteredMyCourses : filteredAllCourses;

    const exists = currentRows.some(
      (item) => String(getCourseId(item)) === String(selectedCourseId)
    );

    if (selectedCourseId && exists) return;

    if (filteredAllCourses.length > 0) {
      const firstCourse = filteredAllCourses[0];
      const firstId = getCourseId(firstCourse);

      setKeyboardCursor({
        source: "all",
        index: 0,
      });

      setSelectedSource("all");
      setSelectedCourseId(firstId);
      handleSelectCourse(firstCourse, "all");
      return;
    }

    if (filteredMyCourses.length > 0) {
      const firstCourse = filteredMyCourses[0];
      const firstId = getCourseId(firstCourse);

      setKeyboardCursor({
        source: "my",
        index: 0,
      });

      setSelectedSource("my");
      setSelectedCourseId(firstId);
      handleSelectCourse(firstCourse, "my");
      return;
    }

    setSelectedCourseId(null);
    setSelectedDetail(null);
  }, [
    loading,
    filteredAllCourses,
    filteredMyCourses,
    selectedSource,
    selectedCourseId,
    detailTab,
  ]);

  async function loadPageData(options = {}) {
    const { preserveSelection = false, preservedSource = "all", preservedCourseId = null } = options;

    setLoading(true);
    setErrorMessage("");

    try {
      let allRes = [];
      let myRes = [];

      if (isInstructor) {
        allRes = await fetchInstructorAllCourseList();
        myRes = await fetchInstructorCourseList();
      } else {
        allRes = await fetchStudentAllCourses(loginID);
        myRes = await fetchStudentMyCourses(loginID);
      }

      const normalizedAll = Array.isArray(allRes) ? allRes.map(normalizeCourse) : [];
      const normalizedMy = Array.isArray(myRes) ? myRes.map(normalizeCourse) : [];

      setAllCourses(normalizedAll);
      setMyCourses(normalizedMy);

      if (preserveSelection && preservedCourseId) {
        const targetRows = preservedSource === "my" ? normalizedMy : normalizedAll;
        const fallbackSource = preservedSource === "my" ? "all" : "my";
        const fallbackRows = fallbackSource === "my" ? normalizedMy : normalizedAll;
        let resolvedSource = preservedSource;
        let resolvedRows = targetRows;
        let foundCourse = targetRows.find(
          (item) => String(getCourseId(item)) === String(preservedCourseId)
        );

        if (!foundCourse) {
          foundCourse = fallbackRows.find(
            (item) => String(getCourseId(item)) === String(preservedCourseId)
          );
          if (foundCourse) {
            resolvedSource = fallbackSource;
            resolvedRows = fallbackRows;
          }
        }

        if (foundCourse) {
          const targetIndex = resolvedRows.findIndex(
            (item) => String(getCourseId(item)) === String(preservedCourseId)
          );

          setDetailTab("detail");
          setSelectedSource(resolvedSource);
          setSelectedCourseId(preservedCourseId);
          setKeyboardCursor({
            source: resolvedSource,
            index: targetIndex >= 0 ? targetIndex : 0,
          });
          rowRefs.current = { all: [], my: [] };

          await handleSelectCourse(foundCourse, resolvedSource);
          setTimeout(() => {
            rowRefs.current[resolvedSource][targetIndex >= 0 ? targetIndex : 0]?.focus();
          }, 0);
          return;
        }
      }

      setSelectedCourseId(null);
      setSelectedDetail(null);
      setDetailTab("detail");
      setRegisterForm({ ...emptyForm });
      setKeyboardCursor({
        source: "all",
        index: 0,
      });
      rowRefs.current = { all: [], my: [] };
    } catch (error) {
      console.error(error);
      setErrorMessage(error?.message || "강의 목록을 불러오는데 실패했습니다.");
    } finally {
      setLoading(false);
    }
  }

  async function loadInstructorMeta() {
    try {
      const [classes, times, subInstructors] = await Promise.all([
        fetchInstructorClassList(),
        fetchInstructorTimeList(),
        fetchInstructorSubList(),
      ]);

      setClassOptions(Array.isArray(classes) ? classes : []);
      setTimeOptions(Array.isArray(times) ? times : []);
      setSubInstructorOptions(Array.isArray(subInstructors) ? subInstructors : []);
    } catch (error) {
      console.error(error);
    }
  }

  async function handleSelectCourse(course, source) {
    const id = getCourseId(course);
    if (!id) return;

    setSelectedSource(source);
    setSelectedCourseId(id);
    setDetailTab("detail");

    try {
      let detail = null;

      if (isStudent) {
        if (source === "all") {
          detail = await fetchStudentCourseDetail(id, loginID);
        } else {
          detail = await fetchStudentMyCourseDetail(id, loginID);
        }
      } else {
        if (source === "all") {
          detail = await fetchInstructorAllCourseDetail(id);
        } else {
          detail = await fetchInstructorCourseDetail(id);
        }
      }

      const merged = normalizeCourse({
        ...course,
        ...(detail || {}),
      });

      setSelectedDetail(merged);
      setRegisterForm(mapDetailToForm(merged));

      lastSelectedCourseRef.current = {
        source,
        courseId: getCourseId(merged),
        detail: merged,
      };
    } catch (error) {
      console.error(error);

      const fallback = normalizeCourse(course);
      setSelectedDetail(fallback);
      setRegisterForm(mapDetailToForm(fallback));

      lastSelectedCourseRef.current = {
        source,
        courseId: getCourseId(fallback),
        detail: fallback,
      };

      alert(error?.message || "강의 상세를 불러오는데 실패했습니다.");
    }
  }

  function moveCursorTo(source, nextIndex, options = {}) {
    const { keepSearchFocus = false } = options;

    const targetRows = source === "all" ? filteredAllCourses : filteredMyCourses;

    if (!targetRows.length) return;

    const safeIndex = Math.max(0, Math.min(nextIndex, targetRows.length - 1));
    const targetCourse = targetRows[safeIndex];

    setKeyboardCursor({
      source,
      index: safeIndex,
    });

    handleSelectCourse(targetCourse, source);

    setTimeout(() => {
      const rowEl = rowRefs.current[source][safeIndex];
      rowEl?.scrollIntoView({ block: "nearest" });

      if (!keepSearchFocus) {
        rowEl?.focus();
      }
    }, 0);
  }

  function handleSearchAreaKeyDown(e) {
    const currentRows =
      selectedSource === "my" ? filteredMyCourses : filteredAllCourses;

    if (!currentRows.length) return;

    const currentIndex = currentRows.findIndex(
      (item) => String(getCourseId(item)) === String(selectedCourseId)
    );

    const safeIndex = currentIndex >= 0 ? currentIndex : 0;

    if (e.key === "ArrowDown") {
      e.preventDefault();
      moveCursorTo(selectedSource, safeIndex + 1, { keepSearchFocus: true });
      return;
    }

    if (e.key === "ArrowUp") {
      e.preventDefault();
      moveCursorTo(selectedSource, safeIndex - 1, { keepSearchFocus: true });
    }
  }

  function handleRowKeyDown(e, source, index) {
    const currentRows = source === "all" ? filteredAllCourses : filteredMyCourses;
    const otherSource = source === "all" ? "my" : "all";
    const otherRows = otherSource === "all" ? filteredAllCourses : filteredMyCourses;

    if (e.key === "ArrowDown") {
      e.preventDefault();
      if (index < currentRows.length - 1) moveCursorTo(source, index + 1);
      return;
    }

    if (e.key === "ArrowUp") {
      e.preventDefault();
      if (index > 0) moveCursorTo(source, index - 1);
      return;
    }

    if (e.key === "ArrowRight" || e.key === "ArrowLeft") {
      e.preventDefault();
      if (otherRows.length) {
        moveCursorTo(otherSource, Math.min(index, otherRows.length - 1));
      }
      return;
    }

    if (e.key === "Enter" || e.key === " ") {
      e.preventDefault();
      handleSelectCourse(currentRows[index], source);
    }
  }

  function handleRegisterTabClick() {
    if (selectedDetail?.course_id) {
      lastSelectedCourseRef.current = {
        source: selectedSource,
        courseId: selectedDetail.course_id,
        detail: selectedDetail,
      };
    }

    setDetailTab("register");
    setSelectedSource("all");
    setSelectedCourseId(null);
    setSelectedDetail(null);
    setRegisterForm({ ...emptyForm });
  }

  function handleDetailTabClick() {
    setDetailTab("detail");

    const saved = lastSelectedCourseRef.current;

    if (saved?.courseId) {
      const source = saved.source || "all";
      const sourceRows = source === "my" ? myCourses : allCourses;
      const foundCourse = sourceRows.find(
        (item) => String(getCourseId(item)) === String(saved.courseId)
      );

      setSelectedSource(source);
      setSelectedCourseId(saved.courseId);

      if (foundCourse) {
        handleSelectCourse(foundCourse, source);
        return;
      }

      if (saved.detail) {
        setSelectedDetail(saved.detail);
        setRegisterForm(mapDetailToForm(saved.detail));
        return;
      }
    }

    const firstCourse = filteredMyCourses[0] || filteredAllCourses[0];
    if (firstCourse) {
      const source = filteredMyCourses.length > 0 ? "my" : "all";
      handleSelectCourse(firstCourse, source);
    } else {
      setSelectedSource("all");
      setSelectedCourseId(null);
      setSelectedDetail(null);
      setRegisterForm({ ...emptyForm });
    }
  }

  function handleReset() {
    if (!isInstructor) return;

    if (isRegisterMode) {
      setRegisterForm({ ...emptyForm });
      return;
    }

    if (isMyCourseEditMode && selectedDetail) {
      setRegisterForm(mapDetailToForm(selectedDetail));
    }
  }

  async function handleSave() {
    if (!isInstructor) return;
    if (!canSaveInstructor) return;

    if (!registerForm.title.trim()) {
      alert("강의명을 입력해주세요.");
      return;
    }
    if (!registerForm.classId) {
      alert("강의실을 선택해주세요.");
      return;
    }
    if (!registerForm.time_code) {
      alert("시간을 선택해주세요.");
      return;
    }
    if (!registerForm.start_date || !registerForm.end_date) {
      alert("강의기간을 입력해주세요.");
      return;
    }

    try {
      setSaving(true);

      const payload = {
        course_id: registerForm.course_id,
        title: registerForm.title,
        sub_prof: registerForm.sub_prof,
        class_id: registerForm.classId,
        time_code: registerForm.time_code,
        start_date: registerForm.start_date,
        end_date: registerForm.end_date,
        content: registerForm.content,
        plan: registerForm.plan,
        notice: registerForm.notice,
        cos_sta_code: "0",
      };

      const preservedSource = selectedSource;
      const preservedCourseId = registerForm.course_id || selectedCourseId;

      if (isRegisterMode || !registerForm.course_id) {
        await createInstructorCourse(payload);
        alert("강의가 등록되었습니다.");

        await loadPageData();
        setDetailTab("detail");
      } else {
        await updateInstructorCourse(payload);
        alert("강의가 수정되었습니다.");

        await loadPageData({
          preserveSelection: true,
          preservedSource,
          preservedCourseId,
        });
        setDetailTab("detail");
      }
    } catch (error) {
      console.error(error);
      alert(error?.message || "저장에 실패했습니다.");
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete() {
    if (!selectedDetail?.course_id) {
      alert("삭제할 강의를 먼저 선택해주세요.");
      return;
    }

    try {
      if (isStudent) {
        if (selectedSource !== "my") {
          alert("나의 강의에서 선택한 강의만 취소할 수 있습니다.");
          return;
        }

        await doStudentCourseAction(selectedDetail.course_id, loginID, "delete");
        alert("수강 취소되었습니다.");
      } else {
        if (selectedSource !== "my") {
          alert("나의 강의에서 선택한 강의만 삭제할 수 있습니다.");
          return;
        }

        await deleteInstructorCourse(selectedDetail.course_id);
        alert("강의가 삭제되었습니다.");
      }

      await loadPageData();
      setSelectedDetail(null);
      setSelectedCourseId(null);
      setSelectedSource("all");
    } catch (error) {
      console.error(error);
      alert(error?.message || "삭제 처리에 실패했습니다.");
    }
  }

  async function handleApply() {
    if (!selectedDetail?.course_id) {
      alert("신청할 강의를 먼저 선택해주세요.");
      return;
    }

    try {
      const result = await doStudentCourseAction(
        selectedDetail.course_id,
        loginID,
        "apply"
      );

      if (result?.msg === "이미 신청한 강의입니다.") {
        alert("이미 신청한 강의입니다.");
        return;
      }

      if (result?.msg === "이미 수강완료한 강의입니다.") {
        alert("이미 수강완료한 강의입니다.");
        return;
      }

      if (result?.msg !== "수강신청") {
        alert(result?.msg || "신청 처리에 실패했습니다.");
        return;
      }

      alert("수강 신청되었습니다.");

      await loadPageData();

      const reloaded = await fetchStudentCourseDetail(
        selectedDetail.course_id,
        loginID
      );

      const normalized = normalizeCourse({
        ...selectedDetail,
        ...(reloaded || {}),
      });

      setSelectedDetail(normalized);
      setSelectedCourseId(selectedDetail.course_id);
      setSelectedSource("all");
    } catch (error) {
      console.error(error);
      alert(error?.message || "신청 처리에 실패했습니다.");
    }
  }

  function handleSearchChange(key, value) {
    setSearchForm((prev) => ({
      ...prev,
      [key]: value,
    }));
  }

  async function handleSearchReset() {
    setSearchForm({ ...initialSearchForm });

    setTimeout(() => {
      searchInputRef.current?.focus();
    }, 0);
  }

  function changeForm(key, value) {
    setRegisterForm((prev) => ({
      ...prev,
      [key]: value,
    }));
  }

  function renderTopBadge() {
    return (
      <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "14px" }}>
        <span style={{ fontSize: "16px", fontWeight: 700 }}>나의강의관리 &gt; 강의목록</span>

        <div style={{ display: "flex", marginLeft: "12px", border: "1px solid #ccc", overflow: "hidden" }}>
          <div
            style={{
              padding: "8px 24px",
              background: isInstructor ? "#cfe7f7" : "#e5e5e5",
              fontWeight: 700,
              borderRight: "1px solid #ccc",
            }}
          >
            강사
          </div>

          <div
            style={{
              padding: "8px 24px",
              background: isStudent ? "#cfe7f7" : "#e5e5e5",
              fontWeight: 700,
            }}
          >
            학생
          </div>
        </div>
      </div>
    );
  }

  function renderSearchBar() {
    return (
      <div style={searchCardStyle} ref={searchAreaRef}>
        <div style={{ display: "flex", alignItems: "center", gap: "10px", flexWrap: "wrap" }}>
          <select
            style={
              isSearchKeyFocused
                ? { ...focusedSearchSelectStyle, width: "120px" }
                : { ...selectStyle, width: "120px" }
            }
            value={searchForm.searchKey}
            onChange={(e) => handleSearchChange("searchKey", e.target.value)}
            onFocus={() => setIsSearchKeyFocused(true)}
            onBlur={() => setIsSearchKeyFocused(false)}
            onKeyDown={handleSearchAreaKeyDown}
          >
            <option value="all">전체</option>
            <option value="title">강의명</option>
            <option value="class_name">강의실</option>
            <option value="professor">강사명</option>
          </select>

          <input
            ref={searchInputRef}
            type="text"
            style={{ ...inputStyle, width: "220px" }}
            value={searchForm.searchWord}
            onChange={(e) => handleSearchChange("searchWord", e.target.value)}
            onKeyDown={handleSearchAreaKeyDown}
            placeholder="검색어 입력"
          />

          <input
            type="date"
            style={{ ...inputStyle, width: "170px" }}
            value={searchForm.startDate}
            onChange={(e) => handleSearchChange("startDate", e.target.value)}
            onKeyDown={handleSearchAreaKeyDown}
          />

          <span>~</span>

          <input
            type="date"
            style={{ ...inputStyle, width: "170px" }}
            value={searchForm.endDate}
            onChange={(e) => handleSearchChange("endDate", e.target.value)}
            onKeyDown={handleSearchAreaKeyDown}
          />

          <button
            type="button"
            style={buttonBaseStyle}
            onClick={handleSearchReset}
            onKeyDown={handleSearchAreaKeyDown}
          >
            초기화
          </button>
        </div>
      </div>
    );
  }

  function renderCourseTable(title, rows, source) {
    const isMyTable = source === "my";

    return (
      <div style={{ flex: 1 }}>
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginBottom: "12px",
          }}
        >
          <h2 style={sectionTitleStyle}>{title}</h2>

          {isMyTable && (isStudent || isInstructor) && (
            <button
              type="button"
              onClick={handleDelete}
              disabled={isStudent ? !canDeleteStudentCourse : !canDeleteInstructorCourse}
              style={
                isStudent
                  ? canDeleteStudentCourse
                    ? buttonBaseStyle
                    : disabledButtonStyle
                  : canDeleteInstructorCourse
                  ? buttonBaseStyle
                  : disabledButtonStyle
              }
            >
              삭제
            </button>
          )}
        </div>

        <div style={{ ...cardStyle, overflow: "hidden" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", tableLayout: "fixed" }}>
            <colgroup>
              <col style={{ width: "76px" }} />
              <col style={{ width: "249px" }} />
              <col style={{ width: "95px" }} />
              <col style={colPeriodStyle} />
            </colgroup>
            <thead>
              <tr>
                <th style={thStyle}>번호</th>
                <th style={thStyle}>강의명</th>
                <th style={thStyle}>강의실</th>
                <th style={thStyle}>강의기간</th>
              </tr>
            </thead>
          </table>

          <div style={tableScrollStyle}>
            <table style={{ width: "100%", borderCollapse: "collapse", tableLayout: "fixed" }}>
              <colgroup>
                <col style={colNoStyle} />
                <col style={colTitleStyle} />
                <col style={colRoomStyle} />
                <col style={colPeriodStyle} />
              </colgroup>
              <tbody>
                {rows.length === 0 ? (
                  <tr>
                    <td colSpan={4} style={emptyTdStyle}>
                      데이터가 없습니다.
                    </td>
                  </tr>
                ) : (
                  rows.map((course, index) => {
                    const id = getCourseId(course);
                    const active = selectedRowKey === `${source}-${id}`;

                    return (
                      <tr
                        key={`${source}-${id}-${index}`}
                        ref={(el) => {
                          rowRefs.current[source][index] = el;
                        }}
                        tabIndex={keyboardCursor.source === source && keyboardCursor.index === index ? 0 : -1}
                        onClick={() => {
                          setKeyboardCursor({ source, index });
                          handleSelectCourse(course, source);
                        }}
                        onKeyDown={(e) => handleRowKeyDown(e, source, index)}
                        onFocus={(e) => {
                          setKeyboardCursor({ source, index });
                          e.currentTarget.style.boxShadow = "inset 0 0 0 2px #4a90e2";
                        }}
                        onBlur={(e) => {
                          e.currentTarget.style.boxShadow = "none";
                        }}
                        aria-selected={active}
                        style={{
                          background: active ? "#d9edf9" : "#fff",
                          cursor: "pointer",
                          outline: "none",
                        }}
                      >
                        <td style={tdStyle}>{index + 1}</td>
                        <td style={tdStyle}>{getCourseTitle(course)}</td>
                        <td style={tdStyle}>{getCourseRoom(course)}</td>
                        <td style={tdStyle}>{formatDateRange(course.start_date, course.end_date)}</td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }

  function renderDetailPanel() {
    function requiredLabel(text) {
      return (
        <span>
          {text}
          {isRegisterMode && isInstructor && (
            <span style={{ color: "red", marginLeft: "4px", fontWeight: 700 }}>*</span>
          )}
        </span>
      );
    }

    const saveButtonStyle = canSaveInstructor ? buttonBaseStyle : disabledButtonStyle;
    const resetButtonStyle = canResetInstructor ? buttonBaseStyle : disabledButtonStyle;

    return (
      <div style={{ ...cardStyle, marginTop: "18px", padding: "14px" }}>
        <h2 style={{ fontSize: "28px", fontWeight: 700, margin: "0 0 12px 0" }}>
          {isRegisterMode ? "강의등록" : "강의상세"}
        </h2>

        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "12px" }}>
          <div style={{ display: "flex", gap: "8px" }}>
            {isInstructor && (
              <>
                <button
                  type="button"
                  onClick={handleDetailTabClick}
                  style={{
                    ...buttonBaseStyle,
                    background: !isRegisterMode ? "#cfe7f7" : "#efefef",
                    color: !isRegisterMode ? "#0c0c0c" : "#0a0a0a",
                    border: !isRegisterMode ? "1px solid #1677ff" : "1px solid #c8c8c8",
                    boxShadow: !isRegisterMode ? "0 0 0 2px rgba(22,119,255,0.2)" : "none",
                    fontWeight: 700,
                  }}
                >
                  강의상세
                </button>

                <button
                  type="button"
                  onClick={handleRegisterTabClick}
                  style={{
                    ...buttonBaseStyle,
                    background: isRegisterMode ? "#cfe7f7" : "#efefef",
                    color: isRegisterMode ? "#0c0c0c" : "#0a0a0a",
                    border: isRegisterMode ? "1px solid #1677ff" : "1px solid #c8c8c8",
                    boxShadow: isRegisterMode ? "0 0 0 2px rgba(22,119,255,0.2)" : "none",
                    fontWeight: 700,
                  }}
                >
                  강의등록
                </button>
              </>
            )}
          </div>

          <div style={{ display: "flex", gap: "8px" }}>
            {!isStudent && (
              <>
                <button
                  type="button"
                  onClick={handleSave}
                  style={saveButtonStyle}
                  disabled={!canSaveInstructor}
                >
                  저장
                </button>
                <button
                  type="button"
                  onClick={handleReset}
                  style={resetButtonStyle}
                  disabled={!canResetInstructor}
                >
                  초기화
                </button>
              </>
            )}

            {!isInstructor && (
              <button type="button" onClick={handleApply} style={buttonBaseStyle}>
                신청
              </button>
            )}
          </div>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "14px", marginBottom: "14px" }}>
          <FieldRow
            label={requiredLabel("강의명")}
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <input
                style={activeInputStyle}
                value={registerForm.title}
                onChange={(e) => changeForm("title", e.target.value)}
              />
            ) : (
              <div>{selectedDetail ? getCourseTitle(selectedDetail) : "-"}</div>
            )}
          </FieldRow>

          <FieldRow
            label="강사"
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            <div>{getProfessorName(selectedDetail, userName || loginID)}</div>
          </FieldRow>

          <FieldRow
            label="보조 강사"
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <select
                style={isSubProfFocused ? focusedRegisterSelectStyle : activeSelectStyle}
                value={registerForm.sub_prof}
                onChange={(e) => changeForm("sub_prof", e.target.value)}
                onFocus={() => setIsSubProfFocused(true)}
                onBlur={() => setIsSubProfFocused(false)}
              >
                <option value="">선택</option>
                {subInstructorOptions.map((item) => (
                  <option key={item.loginID} value={item.loginID}>
                    {item.name}
                  </option>
                ))}
              </select>
            ) : (
              <div>{getSubProfessorDisplayName(selectedDetail)}</div>
            )}
          </FieldRow>

          <FieldRow
            label={requiredLabel("강의기간")}
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <div style={{ display: "flex", gap: "8px", alignItems: "center", width: "100%" }}>
                <input
                  type="date"
                  style={activeInputStyle}
                  value={registerForm.start_date}
                  onChange={(e) => changeForm("start_date", e.target.value)}
                />
                <span>~</span>
                <input
                  type="date"
                  style={activeInputStyle}
                  value={registerForm.end_date}
                  onChange={(e) => changeForm("end_date", e.target.value)}
                />
              </div>
            ) : (
              <div>{formatDateRange(selectedDetail?.start_date, selectedDetail?.end_date)}</div>
            )}
          </FieldRow>

          <FieldRow
            label={requiredLabel("시간")}
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <select
                style={isTimeCodeFocused ? focusedRegisterSelectStyle : activeSelectStyle}
                value={registerForm.time_code}
                onChange={(e) => changeForm("time_code", e.target.value)}
                onFocus={() => setIsTimeCodeFocused(true)}
                onBlur={() => setIsTimeCodeFocused(false)}
              >
                <option value="">선택</option>
                {timeOptions.map((item) => (
                  <option key={item.time_code} value={item.time_code}>
                    {item.start_time} ~ {item.end_time}
                  </option>
                ))}
              </select>
            ) : (
              <div>{getTimeText(selectedDetail, timeOptions)}</div>
            )}
          </FieldRow>

          <FieldRow
            label="수강인원"
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            <div>{getStudentCountText(selectedDetail, classOptions, registerForm.classId)}</div>
          </FieldRow>

          <FieldRow
            label={requiredLabel("강의실")}
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <select
                style={isClassIdFocused ? focusedRegisterSelectStyle : activeSelectStyle}
                value={registerForm.classId}
                onChange={(e) => changeForm("classId", e.target.value)}
                onFocus={() => setIsClassIdFocused(true)}
                onBlur={() => setIsClassIdFocused(false)}
              >
                <option value="">선택</option>
                {classOptions.map((item) => (
                  <option key={item.class_id} value={item.class_id}>
                    {item.class_name}
                  </option>
                ))}
              </select>
            ) : (
              <div>{getCourseRoom(selectedDetail)}</div>
            )}
          </FieldRow>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "14px" }}>
          <FieldBox
            label="수업 내용"
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <textarea
                style={activeTextareaStyle}
                value={registerForm.content}
                onChange={(e) => changeForm("content", e.target.value)}
              />
            ) : (
              <div>{selectedDetail?.content || "-"}</div>
            )}
          </FieldBox>

          <FieldBox
            label="강의 계획"
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <textarea
                style={activeTextareaStyle}
                value={registerForm.plan}
                onChange={(e) => changeForm("plan", e.target.value)}
              />
            ) : (
              <div>{selectedDetail?.plan || "-"}</div>
            )}
          </FieldBox>

          <FieldBox
            label="공지사항"
            labelStyle={activeLabelCellStyle}
            valueStyle={activeValueCellStyle}
          >
            {isEditableMode && isInstructor ? (
              <textarea
                style={activeTextareaStyle}
                value={registerForm.notice}
                onChange={(e) => changeForm("notice", e.target.value)}
              />
            ) : (
              <div>{selectedDetail?.notice || "-"}</div>
            )}
          </FieldBox>
        </div>
      </div>
    );
  }

  return (
    <div style={pageStyle}>
      {renderTopBadge()}
      {renderSearchBar()}

      {errorMessage && (
        <div
          style={{
            marginBottom: "12px",
            padding: "12px",
            background: "#fff1f0",
            border: "1px solid #ffa39e",
            color: "#cf1322",
            borderRadius: "6px",
          }}
        >
          {errorMessage}
        </div>
      )}

      {loading ? (
        <div style={{ padding: "30px 0" }}>불러오는 중...</div>
      ) : (
        <>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "14px" }}>
            {renderCourseTable("전체 강의", filteredAllCourses, "all")}
            {renderCourseTable("나의 강의", filteredMyCourses, "my")}
          </div>
          {renderDetailPanel()}
        </>
      )}
    </div>
  );

  async function fetchStudentAllCourses(loginID) {
    const params = new URLSearchParams({
      page: "1",
      pageSize: "999",
    });

    if (loginID) params.append("loginID", loginID);

    const res = await api.get(`/api/stu/courses?${params.toString()}`);
    return Array.isArray(res.data) ? res.data : res.data.items || [];
  }

  async function fetchStudentMyCourses(loginID) {
    const params = new URLSearchParams({
      currentPage: "1",
      pageSize: "999",
      loginID,
    });

    const res = await api.get(`/api/stu/my-courses/loadMyCourse?${params.toString()}`);
    return Array.isArray(res.data) ? res.data : res.data.list || [];
  }

  async function fetchStudentCourseDetail(courseId, loginID) {
    const params = new URLSearchParams();
    if (loginID) params.append("loginID", loginID);

    const queryString = params.toString();
    const url = queryString
      ? `/api/stu/courses/${courseId}?${queryString}`
      : `/api/stu/courses/${courseId}`;

    const res = await api.get(url);
    return res.data;
  }

  async function fetchStudentMyCourseDetail(courseId, loginID) {
    const params = new URLSearchParams({
      loginID,
      course_id: String(courseId),
    });

    const res = await api.get(`/api/stu/my-courses/myCourseDetail?${params.toString()}`);
    return res.data;
  }

  async function doStudentCourseAction(courseId, loginID, action) {
    const params = new URLSearchParams();
    params.append("action", action);
    params.append("loginID", loginID);

    const res = await api.post(`/api/stu/courses/${courseId}/action`, params);

    if (String(res.data.status) !== "200") {
      throw new Error(res.data.msg || "학생 액션 처리 실패");
    }

    return res.data;
  }

  async function fetchInstructorAllCourseList() {
    const params = new URLSearchParams();
    params.append("currentPage", "1");
    params.append("pageSize", "999");

    const res = await api.post("/api/inst/getAllCourseList.json", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "전체 강의 조회에 실패했습니다.");
    }

    return Array.isArray(res.data) ? res.data : res.data.list || [];
  }

  async function fetchInstructorCourseList() {
    const params = new URLSearchParams();
    params.append("currentPage", "1");
    params.append("pageSize", "999");

    const res = await api.post("/api/inst/getCourseList.json", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "나의 강의 조회에 실패했습니다.");
    }

    return Array.isArray(res.data) ? res.data : res.data.list || [];
  }

  async function fetchInstructorAllCourseDetail(courseId) {
    const params = new URLSearchParams();
    params.append("courseId", String(courseId));
    params.append("course_id", String(courseId));

    const res = await api.post("/api/inst/getAllCourseDetail", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "전체 강의 상세 조회에 실패했습니다.");
    }

    return res.data?.course || null;
  }

  async function fetchInstructorCourseDetail(courseId) {
    const params = new URLSearchParams();
    params.append("courseId", String(courseId));
    params.append("course_id", String(courseId));

    const res = await api.post("/api/inst/getCourseDetail", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "나의 강의 상세 조회에 실패했습니다.");
    }

    return res.data?.course || null;
  }

  async function fetchInstructorClassList() {
    const res = await api.post("/api/inst/classList", new URLSearchParams());

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "강의실 목록 조회에 실패했습니다.");
    }

    return Array.isArray(res.data) ? res.data : res.data.list || [];
  }

  async function fetchInstructorTimeList() {
    const res = await api.post("/api/inst/timeList", new URLSearchParams());

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "강의시간 목록 조회에 실패했습니다.");
    }

    return Array.isArray(res.data) ? res.data : res.data.list || [];
  }

  async function fetchInstructorSubList() {
    const res = await api.post("/api/inst/subInstructorList", new URLSearchParams());

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "보조강사 목록 조회에 실패했습니다.");
    }

    return Array.isArray(res.data) ? res.data : res.data.list || [];
  }

  async function createInstructorCourse(payload) {
    const params = new URLSearchParams();
    params.append("title", payload.title);
    params.append("sub_prof", payload.sub_prof || "");
    params.append("class_id", payload.class_id);
    params.append("time_code", payload.time_code);
    params.append("start_date", payload.start_date);
    params.append("end_date", payload.end_date);
    params.append("content", payload.content || "");
    params.append("plan", payload.plan || "");
    params.append("notice", payload.notice || "");
    params.append("cos_sta_code", payload.cos_sta_code || "0");

    const res = await api.post("/api/inst/courseSave", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "강의 등록에 실패했습니다.");
    }

    return res.data;
  }

  async function updateInstructorCourse(payload) {
    const params = new URLSearchParams();
    params.append("course_id", payload.course_id);
    params.append("title", payload.title);
    params.append("sub_prof", payload.sub_prof || "");
    params.append("class_id", payload.class_id);
    params.append("time_code", payload.time_code);
    params.append("start_date", payload.start_date);
    params.append("end_date", payload.end_date);
    params.append("content", payload.content || "");
    params.append("plan", payload.plan || "");
    params.append("notice", payload.notice || "");

    const res = await api.post("/api/inst/courseUpdate", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "강의 수정에 실패했습니다.");
    }

    return res.data;
  }

  async function deleteInstructorCourse(courseId) {
    const params = new URLSearchParams();
    params.append("course_id", String(courseId));

    const res = await api.post("/api/inst/courseDelete", params);

    if (String(res.data?.result) === "FAIL") {
      throw new Error(res.data?.resultMsg || "강의 삭제에 실패했습니다.");
    }

    return res.data;
  }
}

function FieldRow({ label, children, labelStyle = labelCellStyle, valueStyle = valueCellStyle }) {
  return (
    <div style={{ display: "flex" }}>
      <div style={labelStyle}>{label}</div>
      <div style={valueStyle}>{children}</div>
    </div>
  );
}

function FieldBox({ label, children, labelStyle = labelCellStyle, valueStyle = valueCellStyle }) {
  return (
    <div style={{ display: "flex", minHeight: "140px" }}>
      <div style={labelStyle}>{label}</div>
      <div style={{ ...valueStyle, alignItems: "stretch" }}>{children}</div>
    </div>
  );
}

function firstValue(obj, keys, defaultValue = "") {
  for (const key of keys) {
    const value = obj?.[key];
    if (value !== undefined && value !== null && String(value).trim() !== "") {
      return value;
    }
  }
  return defaultValue;
}

function normalizeCourse(raw) {
  const course = raw || {};

  return {
    ...course,
    course_id: firstValue(course, ["course_id", "courseId", "lec_id", "lecture_id"], ""),
    title: firstValue(course, ["title", "course_title", "lec_nm", "lecture_name"], ""),
    class_name: firstValue(course, ["class_name", "className", "room_name", "classroom_name"], ""),
    class_id: firstValue(course, ["class_id", "classId"], ""),
    professor: firstValue(course, ["professor", "inst_name", "teacher_name", "name", "userNm"], ""),
    inst_name: firstValue(course, ["inst_name", "teacher_name", "professor", "name", "userNm"], ""),
    sInst_name: firstValue(
      course,
      ["subInstName", "sInstName", "sInst_name", "sub_inst_name", "sub_teacher_name"],
      ""
    ),
    sub_prof: firstValue(course, ["sub_prof"], ""),
    start_date: normalizeServerDate(
      firstValue(course, ["start_date", "startDate", "course_start", "lec_start_date"], "")
    ),
    end_date: normalizeServerDate(
      firstValue(course, ["end_date", "endDate", "course_end", "lec_end_date"], "")
    ),
    time_code: firstValue(course, ["time_code", "timeCode"], ""),
    start_time: firstValue(course, ["start_time", "startTime"], ""),
    end_time: firstValue(course, ["end_time", "endTime"], ""),
    content: firstValue(course, ["content", "contents", "lec_content", "course_content"], ""),
    plan: firstValue(course, ["plan", "course_plan", "lec_plan", "lecture_plan"], ""),
    notice: firstValue(course, ["notice", "course_notice", "lec_notice", "remark", "etc_note"], ""),
    stu_cnt: firstValue(course, ["stu_cnt", "stu_num", "student_count"], ""),
    people_limit: firstValue(course, ["people_limit", "peopleLimit", "max_people", "capacity"], ""),
    loginID: firstValue(course, ["loginID"], ""),
    name: firstValue(course, ["name"], ""),
    user_type: firstValue(course, ["user_type"], ""),
  };
}

function normalizeRole(value) {
  const v = String(value || "").toUpperCase();
  if (v === "I" || v === "INST" || v === "INSTRUCTOR" || v === "TEACHER") return "instructor";
  if (v === "S" || v === "STUDENT") return "student";
  return "student";
}

function getCourseId(course) {
  return Number(course?.course_id || 0);
}

function getCourseTitle(course) {
  return course?.title || "-";
}

function getCourseRoom(course) {
  return course?.class_name || "-";
}

function getProfessorName(detail, fallbackName) {
  return detail?.inst_name || detail?.professor || fallbackName || "-";
}

function getSubProfessorDisplayName(detail) {
  return detail?.sub_inst_name || detail?.subInstName || detail?.sInst_name || detail?.sub_prof || "-";
}

function formatDateRange(start, end) {
  if (!start && !end) return "-";
  if (start && end) return `${formatDate(start)}~${formatDate(end)}`;
  return formatDate(start || end);
}

function formatDate(dateValue) {
  const normalized = normalizeServerDate(dateValue);
  if (!normalized) return "-";
  return normalized.replace(/-/g, ".");
}

function normalizeServerDate(value) {
  if (!value) return "";

  if (typeof value === "string") {
    if (/^\d{4}-\d{2}-\d{2}/.test(value)) {
      return value.slice(0, 10);
    }
    return value;
  }

  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return value.toISOString().slice(0, 10);
  }

  return "";
}

function getTimeText(detail, timeOptions) {
  if (!detail) return "-";

  if (detail.start_time && detail.end_time) {
    return `${detail.start_time} ~ ${detail.end_time}`;
  }

  if (detail.time_code && Array.isArray(timeOptions)) {
    const found = timeOptions.find((item) => String(item.time_code) === String(detail.time_code));
    if (found) return `${found.start_time} ~ ${found.end_time}`;
  }

  return "-";
}

function getStudentCountText(detail, classOptions, classId) {
  if (detail) {
    const current = detail.stu_cnt;
    const limit = detail.people_limit;

    if (current !== "" && limit !== "") return `${current} / ${limit}`;
    if (limit !== "") return String(limit);
    if (current !== "") return String(current);
  }

  if (classId && Array.isArray(classOptions)) {
    const found = classOptions.find((item) => String(item.class_id) === String(classId));
    if (found?.people_limit != null) return String(found.people_limit);
    if (found?.people_limmit != null) return String(found.people_limmit);
  }

  return "-";
}

function mapDetailToForm(detail) {
  return {
    course_id: String(detail?.course_id || ""),
    title: detail?.title || "",
    sub_prof: detail?.sub_prof || "",
    classId: String(detail?.class_id || ""),
    time_code: String(detail?.time_code || ""),
    start_date: normalizeDateInput(detail?.start_date),
    end_date: normalizeDateInput(detail?.end_date),
    content: detail?.content || "",
    plan: detail?.plan || "",
    notice: detail?.notice || "",
  };
}

function normalizeDateInput(value) {
  return normalizeServerDate(value);
}

function filterCoursesBySearchForm(courses, searchForm) {
  const { searchKey, searchWord, startDate, endDate } = searchForm || {};
  let result = [...courses];

  if (searchWord) {
    const q = String(searchWord).toLowerCase().trim();

    result = result.filter((course) => {
      const title = String(course?.title || "").toLowerCase();
      const className = String(course?.class_name || "").toLowerCase();
      const professor = String(course?.inst_name || course?.professor || "").toLowerCase();

      if (!searchKey || searchKey === "all") {
        return title.includes(q) || className.includes(q) || professor.includes(q);
      }

      const map = {
        title,
        class_name: className,
        professor,
      };

      return String(map[searchKey] || "").includes(q);
    });
  }

  if (startDate) {
    result = result.filter((course) => {
      const s = normalizeServerDate(course?.start_date);
      return s && s >= startDate;
    });
  }

  if (endDate) {
    result = result.filter((course) => {
      const e = normalizeServerDate(course?.end_date);
      return e && e <= endDate;
    });
  }

  return result;
}

function isSameForm(a, b) {
  return (
    String(a?.course_id || "") === String(b?.course_id || "") &&
    String(a?.title || "") === String(b?.title || "") &&
    String(a?.sub_prof || "") === String(b?.sub_prof || "") &&
    String(a?.classId || "") === String(b?.classId || "") &&
    String(a?.time_code || "") === String(b?.time_code || "") &&
    String(a?.start_date || "") === String(b?.start_date || "") &&
    String(a?.end_date || "") === String(b?.end_date || "") &&
    String(a?.content || "") === String(b?.content || "") &&
    String(a?.plan || "") === String(b?.plan || "") &&
    String(a?.notice || "") === String(b?.notice || "")
  );
}
