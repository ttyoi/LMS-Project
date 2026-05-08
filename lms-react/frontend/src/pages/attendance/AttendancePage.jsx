import { useEffect, useMemo, useRef, useState } from "react"
import {
    saveAttendanceBatch,
    updateAttendanceStatus,
} from "./api/attendanceApi"
import {
    getCourseListPage,
    getRegisterRowsByDate,
    getStudentDetailRows,
    getStudentRows,
} from "./services/attendanceService"
import CourseListPanel from "./components/CourseListPanel"
import AttendanceStatusPanel from "./components/AttendanceStatusPanel"
import AttendanceEditorPanel from "./components/AttendanceEditorPanel"
import { formatDateInput, isDateWithinCoursePeriod } from "./attUtils"
import styles from "./AttendancePage.module.css"
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

// 일괄 등록 행 두 개를 비교해서 변경 여부를 확인
function isRegisterRowEqual(left, right) {
    return (
        left.attendance_code === right.attendance_code &&
        left.course_id === right.course_id &&
        left.loginID === right.loginID &&
        left.date === right.date &&
        Number(left.att_sta_code) === Number(right.att_sta_code)
    )
}

// 개인 수정 행 두 개를 비교해서 변경 여부를 확인
function isDetailRowEqual(left, right) {
    return left.att_code === right.att_code && Number(left.att_sta_code) === Number(right.att_sta_code)
}

function isFutureDate(targetDate, today) {
    return targetDate > today
}

// 출석 페이지 전체 상태와 데이터 흐름 관리
export default function AttendancePage() {
    const today = formatDateInput()
    const searchInputRef = useRef(null)
    const coursePanelRef = useRef(null)
    const statusPanelRef = useRef(null)
    const editorPanelRef = useRef(null)

    const [keyword, setKeyword] = useState("")
    const [searchedKeyword, setSearchedKeyword] = useState("")
    const [selectedStatuses, setSelectedStatuses] = useState(["ING", "RECRUIT"])
    const [coursePage, setCoursePage] = useState(1)
    const [coursePageSize, setCoursePageSize] = useState(10)
    const [totalCourseCount, setTotalCourseCount] = useState(0)
    const [courseRows, setCourseRows] = useState([])
    const [selectedCourse, setSelectedCourse] = useState(null)
    const [studentRows, setStudentRows] = useState([])
    const [registerRows, setRegisterRows] = useState([])
    const [initialRegisterRows, setInitialRegisterRows] = useState([])
    const [detailRows, setDetailRows] = useState([])
    const [initialDetailRows, setInitialDetailRows] = useState([])
    const [selectedStudent, setSelectedStudent] = useState(null)
    const [registerDate, setRegisterDate] = useState(today)
    const [registerQueryDate, setRegisterQueryDate] = useState(today)
    const [detailDate, setDetailDate] = useState(today)
    const [mode, setMode] = useState("")
    const [loading, setLoading] = useState(false)
    const [activePanel, setActivePanel] = useState("")
    const [isDetailLoading, setIsDetailLoading] = useState(false)
    const [shouldAutoFocusDetailTable, setShouldAutoFocusDetailTable] = useState(false)

    const baseToastStyle = {
        fontWeight: "bold",
        fontSize: "13px"
    }

    const showErr = (msg) => {
        toast.error(msg, {
            style: {
                ...baseToastStyle,
                color: "#ef4444",
            }
        });
    }

    const showWarn = (msg) => {
        toast.warn(msg, {
            style: {
                ...baseToastStyle,
                color: "#f59e0b",
            }
        });
    }

    const showSuccess = (msg) => {
        toast.success(msg, {
            style: {
                ...baseToastStyle,
                color: "#22c55e"
            }
        })
    }

    // 학생 선택과 개인 출석 상세 데이터 초기화
    function resetDetailSelection() {
        setSelectedStudent(null)
        setDetailRows([])
        setInitialDetailRows([])
    }

    // 일괄 등록 목록과 초기 비교용 목록 초기화.
    function resetRegisterSelection() {
        setRegisterRows([])
        setInitialRegisterRows([])
    }

    // 강의 선택이 해제될 때 하위 패널 상태 초기화
    function resetCourseSelection() {
        setSelectedCourse(null)
        setStudentRows([])
        resetDetailSelection()
        resetRegisterSelection()
        setMode("")
    }

    useEffect(() => {
        loadCourseList()
    }, [])

    useEffect(() => {
        searchInputRef.current?.focus()
    }, [])

    useEffect(() => {
        if (coursePageSize > 0) {
            loadCourseList(1)
        }
    }, [coursePageSize, selectedStatuses])

    useEffect(() => {
        if (!selectedCourse?.course_id) return
        loadStudentRows(selectedCourse.course_id)
    }, [selectedCourse?.course_id])

    const bulkSaveEnabled = useMemo(() => {
        // 현재 행과 처음 불러온 행을 비교해서 실제 수정이 있을 때만 저장 버튼 활성화
        if (!registerRows.length || registerRows.length !== initialRegisterRows.length) return false
        return registerRows.some((row, index) => !isRegisterRowEqual(row, initialRegisterRows[index]))
    }, [registerRows, initialRegisterRows])

    const detailSaveEnabled = useMemo(() => {
        // 개인 수정 화면도 같은 방식으로 변경 여부를 계산
        if (!detailRows.length || detailRows.length !== initialDetailRows.length) return false
        return detailRows.some((row, index) => !isDetailRowEqual(row, initialDetailRows[index]))
    }, [detailRows, initialDetailRows])

    // 일괄 등록 목록과 초기 비교용 목록을 같은 값으로 맞춘다.
    function syncRegisterRows(list) {
        // 화면에 보이는 행과 초기 스냅샷을 함께 맞춰둬야 이후 변경 비교가 쉬워진다.
        setRegisterRows(list)
        setInitialRegisterRows(list)
    }

    // 강의 목록을 조회
    async function loadCourseList(page = 1, targetKeyword = searchedKeyword) {
        setLoading(true)

        const trimmedKeyword = targetKeyword.trim()

        try {
            const { rows: targetList, totalCount, safePage } = await getCourseListPage({
                keyword: trimmedKeyword,
                selectedStatuses,
                page,
                pageSize: coursePageSize,
            })
            if (trimmedKeyword && totalCount === 0) {
                setCourseRows([])
                setTotalCourseCount(0)
                resetCourseSelection()
                showWarn("검색 결과가 없습니다.")
            } else {
                setCourseRows(targetList)
                setTotalCourseCount(totalCount)
                setSelectedCourse((prev) => {
                    if (!prev) return null

                    const exists = targetList.some((item) => item.course_id === prev.course_id)
                    if (exists) return prev

                    setStudentRows([])
                    resetDetailSelection()
                    resetRegisterSelection()
                    setMode("")
                    return null
                })
            }
            setCoursePage(safePage)
        } catch {
            setCourseRows([])
            setTotalCourseCount(0)
            resetCourseSelection()
            showErr("강의 목록 조회에 실패했습니다.")
        } finally {
            setLoading(false)
        }
    }

    // 현재 입력한 검색어를 기준으로 강의 목록 검색
    function handleCourseSearch(page = 1) {
        const nextKeyword = keyword.trim()
        setSearchedKeyword(nextKeyword)
        loadCourseList(page, nextKeyword)
    }

    // 선택한 강의의 학생 목록과 일괄 등록용 출석 행을 조회
    async function loadStudentRows(courseId, options = {}) {
        const { preserveStudent = false } = options
        setLoading(true)

        try {
            const list = await getStudentRows(courseId)
            setStudentRows(list)
            setSelectedStudent((prev) => {
                if (!preserveStudent || !prev) return null
                return list.find((student) => student.stu_loginID === prev.stu_loginID) ?? null
            })
            setDetailRows((prev) => (preserveStudent ? prev : []))
            setInitialDetailRows((prev) => (preserveStudent ? prev : []))
            syncRegisterRows(
                await getRegisterRowsByDate({
                    courseId,
                    targetDate: registerQueryDate,
                    today,
                    studentRows: list,
                })
            )
            return list
        } catch {
            setStudentRows([])
            resetDetailSelection()
            resetRegisterSelection()
            showErr("출석 현황 조회에 실패했습니다.")
            return []
        } finally {
            setLoading(false)
        }
    }


    async function loadStudentDetail(courseId, studentLoginId, dateFilter = "") {
        setIsDetailLoading(true)
        try {
            const nextRows = await getStudentDetailRows({
                courseId,
                studentLoginId,
                dateFilter,
            })
            const validRows = nextRows.filter((row) => row.att_date)

            setDetailRows(validRows)
            setInitialDetailRows(validRows)

            if (validRows.length === 0) {
                showWarn("조회된 개인 출석 이력이 없습니다.")
            }
        } catch {
            setDetailRows([])
            setInitialDetailRows([])
            showErr("학생 개인 출석 이력 조회에 실패했습니다.")
        } finally {
            setIsDetailLoading(false)
        }
    }

    // 선택한 날짜 기준 조회
    async function reloadRegisterRowsByDate(courseId, targetDate, sourceStudentRows = studentRows) {
        if (!courseId || !targetDate) return

        // 날짜 필터가 변경시 일괄 등록 표 전체를 다시 조회
        try {
            // 현재 조회한 날짜 기준으로 출석 행을 다시 조회
            const nextRows = await getRegisterRowsByDate({
                courseId,
                targetDate,
                today,
                studentRows: sourceStudentRows,
            })
            syncRegisterRows(nextRows)
        } catch {
            showErr("날짜별 출석 조회에 실패했습니다.")
            syncRegisterRows(
                await getRegisterRowsByDate({
                    courseId,
                    targetDate: today,
                    today,
                    studentRows: sourceStudentRows,
                })
            )
        }
    }

    // 일괄 등록용 날짜 조회
    async function handleBulkSearch() {
        if (!selectedCourse?.course_id) return

        // 강의 기간 밖의 날짜 필터링
        if (!isDateWithinCoursePeriod(selectedCourse, registerDate)) {
            showWarn(`조회 날짜는 ${selectedCourse.start_date} ~ ${selectedCourse.end_date} 사이여야 합니다.`)
            return
        }

        if (isFutureDate(registerDate, today)) {
            showWarn("오늘 이후 날짜는 조회할 수 없습니다.")
            return
        }


        setRegisterQueryDate(registerDate)

        await reloadRegisterRowsByDate(selectedCourse.course_id, registerDate)
    }

    // 개인 수정용 날짜 조회를 실행
    async function handleDetailSearch() {
        if (!selectedCourse?.course_id || !selectedStudent?.stu_loginID) return

        // 개인 이력 조회도 같은 기준으로 날짜를 검증해서 불필요한 요청을 줄인다.
        if (!isDateWithinCoursePeriod(selectedCourse, detailDate)) {
            showWarn(`조회 날짜는 ${selectedCourse.start_date} ~ ${selectedCourse.end_date} 사이여야 합니다.`)
            return
        }

        if (isFutureDate(detailDate, today)) {
            showWarn("오늘 이후 날짜는 조회할 수 없습니다.")
            return
        }

        await loadStudentDetail(selectedCourse.course_id, selectedStudent.stu_loginID, detailDate)
    }

    // 에디터 패널의 작업 모드를 변경
    function handleModeChange(nextMode) {
        if (mode === nextMode) return

        // 필요한 선택 정보가 준비된 상태에서만 모드를 바꿔서 빈 화면 전환을 막는다.
        if (nextMode === "bulk") {
            if (!selectedCourse) {
                showWarn("선택된 강의가 없습니다. 강의를 선택해 주세요.")
                focusCoursePanel()
                return
            }
            setMode("bulk")
            return
        }

        if (nextMode === "individual") {
            if (!selectedCourse) {
                showWarn("선택된 강의가 없습니다. 강의를 선택해 주세요.")
                focusCoursePanel()
                return
            }
            if (!selectedStudent) {
                showWarn("선택된 학생이 없습니다. 학생을 선택해 주세요.")
                focusStatusPanel()
                return
            }
            setMode("individual")
        }
    }

    // 수정한 학생 행만 바꿔서 저장 가능 여부를 초기 스냅샷과 비교
    // 일괄 등록 목록에서 특정 학생의 출석 상태를 변경
    function handleRegisterStatusChange(loginID, value) {
        setRegisterRows((prev) =>
            prev.map((row) =>
                row.loginID === loginID
                    ? { ...row, att_sta_code: Number(value) }
                    : row
            )
        )
    }

    // 개인 이력 수정도 같은 방식으로 한 행만 갱신
    // 개인 출석 이력 목록에서 특정 항목의 상태를 변경
    function handleDetailStatusChange(attCode, value) {
        setDetailRows((prev) =>
            prev.map((row) =>
                row.att_code === attCode
                    ? { ...row, att_sta_code: Number(value) }
                    : row
            )
        )
    }
    // 일괄 등록 화면의 출석 상태를 저장
    async function handleBulkSave() {
        if (!bulkSaveEnabled) return

        try {
            const payload = registerRows.map((row) => ({
                attendance_code: row.attendance_code,
                course_id: row.course_id,
                loginID: row.loginID,
                date: row.date,
                att_sta_code: Number(row.att_sta_code),
            }))
            const result = await saveAttendanceBatch(payload)

            if (result.resultMsg === "SUCCESS") {
                const latestStudentRows = await loadStudentRows(selectedCourse.course_id, {
                    preserveStudent: Boolean(selectedStudent),
                })
                await reloadRegisterRowsByDate(
                    selectedCourse.course_id,
                    registerQueryDate || registerDate,
                    latestStudentRows
                )
                showSuccess("출석이 저장되었습니다.")
            } else {
                showErr("출석 저장에 실패했습니다.")
            }
        } catch {
            showErr("출석 저장 중 오류가 발생했습니다.")
        }
    }

    // 개인 수정 화면에서 변경된 출석 이력만 저장
    async function handleDetailSave() {
        if (!detailSaveEnabled) return

        try {
            const changedRows = detailRows.filter((row, index) => !isDetailRowEqual(row, initialDetailRows[index]))

            const results = await Promise.all(
                changedRows.map((row) =>
                    updateAttendanceStatus({
                        attCode: row.att_code,
                        attStaCode: row.att_sta_code,
                    })
                )
            )

            const hasFailure = results.some((result) => result.resultMsg !== "SUCCESS")

            if (hasFailure) {
                showErr("출석 수정에 실패했습니다.")
                return
            }

            setInitialDetailRows(detailRows)
            
            await loadStudentRows(selectedCourse.course_id, {
                preserveStudent: true,
            })

            showSuccess("출석 상태가 수정되었습니다.")
        } catch {
            showErr("출석 수정 중 오류가 발생했습니다.")
        }
    }

    // 강의 상태 필터를 추가하거나 제거
    function handleToggleStatus(status) {
        // 체크 상태 토글은 배열 포함 여부를 바꾸는 방식으로 처리
        setSelectedStatuses((prev) =>
            prev.includes(status)
                ? prev.filter((item) => item !== status)
                : [...prev, status]
        )
    }

    // 강의를 선택하고 관련 상태를 초기화
    function handleSelectCourse(course) {
        // 강의를 바꾸면 학생/상세 이력은 새 강의 기준 재조회
        setSelectedCourse(course)
        resetDetailSelection()
        setRegisterDate(today)
        setRegisterQueryDate(today)
        setDetailDate(today)
        setMode("bulk")
    }

    async function handleSelectStudent(student) {
        const isSameStudent = selectedStudent?.stu_loginID === student?.stu_loginID

        setIsDetailLoading(true)
        setShouldAutoFocusDetailTable(true)
        setSelectedStudent(student)
        setDetailDate(today)
        setMode("individual")
        focusEditorPanel()

        if (!isSameStudent) {
            setDetailRows([])
            setInitialDetailRows([])
        }

        if (!selectedCourse?.course_id || !student?.stu_loginID) {
            setIsDetailLoading(false)
            setShouldAutoFocusDetailTable(false)
            return
        }

        await loadStudentDetail(selectedCourse.course_id, student.stu_loginID)
    }

    // 강의 목록 패널로 포커스를 이동
    function focusCoursePanel() {
        // 패널 이동은 active 상태를 먼저 바꾸고, 다음 프레임에서 실제 포커스를 넘긴다.
        setActivePanel("course")
        requestAnimationFrame(() => {
            coursePanelRef.current?.focus()
        })
    }

    // 학생 현황 패널로 포커스를 이동한다.
    function focusStatusPanel() {
        setActivePanel("status")
        requestAnimationFrame(() => {
            statusPanelRef.current?.focus()
        })
    }

    // 출석 편집 패널을 활성화한다.
    function focusEditorPanel() {
        // 에디터는 내부 포커스 대상이 많아서 어느 패널이 활성인지부터 먼저 맞춘다.
        setActivePanel("editor")
    }

    const totalPages = Math.max(1, Math.ceil(totalCourseCount / Math.max(1, coursePageSize)))

    return (
        <div className={styles.pageShell}>
            <div className={styles.boardGrid}>
                <CourseListPanel
                    courseRows={courseRows}
                    selectedCourseId={selectedCourse?.course_id ?? null}
                    keyword={keyword}
                    selectedStatuses={selectedStatuses}
                    coursePage={coursePage}
                    onKeywordChange={setKeyword}
                    onToggleStatus={handleToggleStatus}
                    onSearch={handleCourseSearch}
                    onSelectCourse={handleSelectCourse}
                    onPageChange={loadCourseList}
                    containerRef={coursePanelRef}
                    isActive={activePanel === "course"}
                    onMoveToStatus={focusStatusPanel}
                    onPageSizeChange={setCoursePageSize}
                    totalPages={totalPages}
                    searchInputRef={searchInputRef}
                    onActivate={() => setActivePanel("course")}
                    onDeactivate={() => setActivePanel("")}
                />

                <section className={styles.stackRight}>
                    <AttendanceStatusPanel
                        selectedCourseTitle={selectedCourse?.title}
                        studentRows={studentRows}
                        selectedStudentId={selectedStudent?.stu_loginID ?? null}
                        onSelectStudent={handleSelectStudent}
                        containerRef={statusPanelRef}
                        isActive={activePanel === "status"}
                        onMoveToCourse={focusCoursePanel}
                        onMoveToEditor={focusEditorPanel}
                        onActivate={() => setActivePanel("status")}
                        onDeactivate={() => setActivePanel("")}
                    />

                    <AttendanceEditorPanel
                        mode={mode}
                        selectedCourseTitle={selectedCourse?.title}
                        selectedCourseId={selectedCourse?.course_id ?? null}
                        selectedStudentName={selectedStudent?.stu_name}
                        selectedStudentId={selectedStudent?.stu_loginID ?? null}
                        registerDate={registerDate}
                        detailDate={detailDate}
                        registerRows={registerRows}
                        detailRows={detailRows}
                        bulkSaveEnabled={bulkSaveEnabled}
                        detailSaveEnabled={detailSaveEnabled}
                        onModeChange={handleModeChange}
                        onRegisterDateChange={setRegisterDate}
                        onDetailDateChange={setDetailDate}
                        onBulkSearch={handleBulkSearch}
                        onBulkSave={handleBulkSave}
                        onDetailSearch={handleDetailSearch}
                        onDetailSave={handleDetailSave}
                        onRegisterStatusChange={handleRegisterStatusChange}
                        onDetailStatusChange={handleDetailStatusChange}
                        containerRef={editorPanelRef}
                        isActive={activePanel === "editor"}
                        onMoveToCourse={focusCoursePanel}
                        onMoveToStatus={focusStatusPanel}
                        onActivate={() => setActivePanel("editor")}
                        isDetailLoading={isDetailLoading}
                        shouldAutoFocusDetailTable={shouldAutoFocusDetailTable}
                        onDetailTableAutoFocused={() => setShouldAutoFocusDetailTable(false)}
                    />
                </section>
            </div>


            <ToastContainer position="bottom-right" autoClose={2000} />
        </div>
    )
}
