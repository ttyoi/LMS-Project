import { forwardRef, useEffect, useMemo, useRef, useState } from "react"
import DatePicker from "react-datepicker"
import "react-datepicker/dist/react-datepicker.css"
import { ATTENDANCE_OPTIONS } from "../attConstants"
import { ensureVisibleInScrollArea, moveFocusByOffset } from "../utils/keyboardNavigation"
import styles from "../AttendancePage.module.css"

const DateInput = forwardRef(function DateInput(
  { inputRef, onInputKeyDown, onInputFocus, ...props },
  ref,
) {
  function setRefs(node) {
    if (typeof ref === "function") {
      ref(node)
    } else if (ref) {
      ref.current = node
    }

    if (typeof inputRef === "function") {
      inputRef(node)
    } else if (inputRef) {
      inputRef.current = node
    }
  }

  function handleKeyDown(event) {
    onInputKeyDown?.(event)
    if (event.defaultPrevented) return
    props.onKeyDown?.(event)
  }

  function handleFocus(event) {
    onInputFocus?.(event)
    props.onFocus?.(event)
  }

  return <input {...props} ref={setRefs} onFocus={handleFocus} onKeyDown={handleKeyDown} />
})

// 문자열 날짜를 DatePicker가 사용하는 Date 객체로 변환
function parseDateString(value) {
  if (!value) return null
  const [year, month, day] = value.split("-").map(Number)
  return new Date(year, month - 1, day)
}

// Date 객체를 화면 상태에서 사용하는 yyyy-MM-dd 문자열로 변환
function formatDateString(date) {
  if (!date) return ""
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, "0")
  const day = String(date.getDate()).padStart(2, "0")
  return `${year}-${month}-${day}`
}

export default function AttendanceEditorPanel({
  mode,
  selectedCourseTitle,
  selectedCourseId,
  selectedStudentName,
  selectedStudentId,
  registerDate,
  detailDate,
  registerRows,
  detailRows,
  bulkSaveEnabled,
  detailSaveEnabled,
  onModeChange,
  onRegisterDateChange,
  onDetailDateChange,
  onBulkSearch,
  onBulkSave,
  onDetailSearch,
  onDetailSave,
  onRegisterStatusChange,
  onDetailStatusChange,
  containerRef,
  isActive,
  onMoveToCourse,
  onMoveToStatus,
  onActivate,
  isDetailLoading,
  shouldAutoFocusDetailTable,
  onDetailTableAutoFocused,
}) {
  const rows = mode === "bulk" ? registerRows : detailRows
  const [focusedRowIndex, setFocusedRowIndex] = useState(0)
  const [focusedColIndex, setFocusedColIndex] = useState(0)
  const [isGridFocused, setIsGridFocused] = useState(false)
  const [openCalendar, setOpenCalendar] = useState("")
  const cellRefs = useRef({})
  const scrollWrapRef = useRef(null)
  const headerButtonRefs = useRef([])

  const bulkTabRef = useRef(null)
  const registerDateRef = useRef(null)
  const detailDateRef = useRef(null)
  const bulkSearchRef = useRef(null)
  const bulkSaveRef = useRef(null)
  const detailSearchRef = useRef(null)
  const detailSaveRef = useRef(null)

  const defaultSortConfig = { key: "date", direction: "desc" }
  const [sortConfig, setSortConfig] = useState(defaultSortConfig)
  const [showSortMarker, setShowSortMarker] = useState(false)

  useEffect(() => {
    // 강의나 학생이 변경시 정렬 상태 초기화
    setSortConfig(defaultSortConfig)
    setShowSortMarker(false)
  }, [mode, selectedStudentId, selectedCourseId])

  const sortedRows = useMemo(() => {
    // 정렬은 화면에 보여줄 순서만 변경, 원본 상태 자체는 부모가 관리
    if (sortConfig.key === null || sortConfig.key === undefined || sortConfig.key === "") {
      return rows
    }

    const list = [...rows]
    const { key, direction } = sortConfig
    const order = direction === "desc" ? -1 : 1

    list.sort((a, b) => {
      let aValue
      let bValue

      if (key === "studentName") {
        aValue = a.studentName ?? selectedStudentName ?? ""
        bValue = b.studentName ?? selectedStudentName ?? ""
      } else if (key === "date") {
        aValue = new Date(a.date ?? a.att_date ?? 0).getTime()
        bValue = new Date(b.date ?? b.att_date ?? 0).getTime()
      } else {
        aValue = Number(a.att_sta_code) === key ? 1 : 0
        bValue = Number(b.att_sta_code) === key ? 1 : 0
      }

      if (typeof aValue === "number" && typeof bValue === "number") {
        return (aValue - bValue) * order
      }

      return String(aValue).localeCompare(String(bValue), "ko") * order
    })

    return list
  }, [rows, sortConfig, selectedStudentName])

  useEffect(() => {
    // 모드가 바뀌면 키보드 포커스 좌표도 처음 칸으로 초기화
    setFocusedRowIndex(0)
    setFocusedColIndex(0)
  }, [mode])

  useEffect(() => {
    setOpenCalendar("")
  }, [mode])

  useEffect(() => {
    if (!isActive) {
      setIsGridFocused(false)
      return
    }

    if (mode === "individual" && isDetailLoading) {
      return
    }

    requestAnimationFrame(() => {
      if (mode === "bulk") {
        bulkTabRef.current?.focus()
        setIsGridFocused(false)
        return
      }
      if (sortedRows.length > 0) {
        scrollWrapRef.current?.focus()
        setFocusedRowIndex(0)
        setFocusedColIndex(0)
        setIsGridFocused(true)

        if (shouldAutoFocusDetailTable) {
          onDetailTableAutoFocused?.()
        }
        return
      }
      detailDateRef.current?.focus()
      setIsGridFocused(false)
      onDetailTableAutoFocused?.()
    })

  }, [isActive, mode, sortedRows.length, isDetailLoading, shouldAutoFocusDetailTable])

  useEffect(() => {
    if (!isActive || !isGridFocused) return

    // 방향키로 이동할 때 현재 포커스된 셀이 항상 화면 안에 보이도록 설정
    const key = `${mode}-${focusedRowIndex}-${focusedColIndex}`
    const target = cellRefs.current[key]
    const wrap = scrollWrapRef.current
    ensureVisibleInScrollArea({ container: wrap, target, includeHorizontal: true })
  }, [mode, focusedRowIndex, focusedColIndex, isActive, isGridFocused, sortedRows])

  // 현재 모드에서 사용할 상단 컨트롤 참조 목록을 반환
  function getToolbarControls() {
    if (mode === "bulk") {
      return [bulkTabRef, registerDateRef, bulkSearchRef, bulkSaveRef]
    }

    return [bulkTabRef, detailDateRef, detailSearchRef, detailSaveRef]
  }

  // 현재 사용할 수 있는 상단 컨트롤만 골라서 반환
  function getEnabledToolbarControls() {
    // 비활성 버튼은 생략
    return getToolbarControls().filter((ref) => ref.current && !ref.current.disabled)
  }

  // 상단 툴바 안에서 이전 또는 다음 컨트롤로 포커스를 이동
  function moveToolbarFocus(currentRef, direction) {
    const controls = getEnabledToolbarControls()
    moveFocusByOffset(controls, currentRef, direction)
  }

  function getCurrentDateRef() {
    return openCalendar === "detail" ? detailDateRef : registerDateRef
  }

  function focusOpenCalendarDay() {
    requestAnimationFrame(() => {
      const target =
        document.querySelector(".react-datepicker__day--keyboard-selected") ||
        document.querySelector(".react-datepicker__day--selected") ||
        document.querySelector(".react-datepicker__day[tabindex='0']")

      target?.focus?.()
    })
  }

  useEffect(() => {
    if (!openCalendar) return

    focusOpenCalendarDay()

    function handleCalendarKeyDown(event) {
      const activeElement = document.activeElement
      const calendarRoot = activeElement?.closest?.(".react-datepicker")
      if (!calendarRoot) return

      if (event.key === "Tab") {
        event.preventDefault()
        const dateRef = getCurrentDateRef()
        setOpenCalendar("")
        requestAnimationFrame(() => {
          moveToolbarFocus(dateRef, event.shiftKey ? -1 : 1)
        })
        return
      }

      if (event.key === "Escape") {
        event.preventDefault()
        const dateRef = getCurrentDateRef()
        setOpenCalendar("")
        requestAnimationFrame(() => {
          dateRef.current?.focus?.()
        })
      }
    }

    document.addEventListener("keydown", handleCalendarKeyDown, true)
    return () => document.removeEventListener("keydown", handleCalendarKeyDown, true)
  }, [openCalendar])

  // 상단 툴바에서 표 영역으로 포커스를 이동
  function moveFromToolbarToTable() {
    if (openCalendar) return
    // 상단 툴바에서 아래로 내려오면 표 탐색 모드로 전환
    scrollWrapRef.current?.focus()
    setIsGridFocused(true)
  }

  // 표 영역에서 다시 상단 툴바로 포커스를 이동
  function moveFromTableToToolbar() {
    // 표의 첫 줄 위로 올라가면 다시 툴바로 돌아갈 수 있게 연결
    const controls = getEnabledToolbarControls()
    const lastControl = controls[controls.length - 1]
    lastControl?.current?.focus()
    setIsGridFocused(false)
  }

  function focusHeaderButton(index) {
    headerButtonRefs.current[index]?.focus()
  }

  function moveFromToolbarToHeader() {
    setIsGridFocused(false)
    onActivate?.()
    focusHeaderButton(0)
  }

  function moveFromHeaderToTable() {
    scrollWrapRef.current?.focus()
    setIsGridFocused(true)
    onActivate?.()
  }

  function handleToolbarFocus() {
    setOpenCalendar("")
    setIsGridFocused(false)
    onActivate?.()
  }

  function handleHeaderKeyDown(event, index) {
    if (event.key === "ArrowRight") {
      event.preventDefault()
      event.stopPropagation()
      focusHeaderButton(Math.min(index + 1, headerButtonRefs.current.length - 1))
      return
    }

    if (event.key === "ArrowLeft") {
      event.preventDefault()
      event.stopPropagation()
      if (index === 0) {
        onMoveToStatus?.()
        return
      }
      focusHeaderButton(Math.max(index - 1, 0))
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      event.stopPropagation()
      moveFromHeaderToTable()
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      event.stopPropagation()
      const controls = getEnabledToolbarControls()
      controls[controls.length - 1]?.current?.focus()
    }
  }

  // 상단 툴바의 키보드 이동을 처리
  function handleToolbarKeyDown(event, currentRef) {
    const controls = getEnabledToolbarControls()
    const firstControl = controls[0]
    const lastControl = controls[controls.length - 1]

    if ((event.key === "ArrowLeft" || event.key === "ArrowUp") && currentRef === firstControl) {
      event.preventDefault()
      setIsGridFocused(false)
      onMoveToStatus?.()
      return
    }

    if (event.key === "ArrowLeft" || event.key === "ArrowUp") {
      event.preventDefault()
      moveToolbarFocus(currentRef, -1)
      return
    }

    if (event.key === "ArrowRight") {
      if (currentRef === lastControl) {
        event.preventDefault()
        moveFromToolbarToHeader()
        return
      }
      event.preventDefault()
      moveToolbarFocus(currentRef, 1)
      return
    }

    if (event.key === "ArrowDown") {
      if (openCalendar) {
        return
      }
      event.preventDefault()
      moveFromToolbarToHeader()
      return
    }
  }

  // 날짜 입력창에서 사용하는 키보드 입력을 처리
  function handleDateKeyDown(event, onSearch, currentRef, calendarKey) {
    if (openCalendar === calendarKey) {
      if (
        event.key === "ArrowLeft" ||
        event.key === "ArrowRight" ||
        event.key === "ArrowUp" ||
        event.key === "ArrowDown" ||
        event.key === "Enter"
      ) {
        return
      }
    }

    if (event.key === "Enter") {
      event.preventDefault()
      onSearch?.()
      return
    }
    if (event.key === "ArrowLeft" || event.key === "ArrowUp") {
      event.preventDefault()
      moveToolbarFocus(currentRef, -1)
      return
    }

    if (event.key === "ArrowRight") {
      event.preventDefault()
      moveToolbarFocus(currentRef, 1)
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      setOpenCalendar(calendarKey)
      return
    }
  }

  // 출석 편집 테이블의 키보드 탐색을 처리
  function handleTableKeyDown(event) {
    // 표 안에서는 방향키로 칸을 이동하고, Enter로 현재 칸의 출석 상태를 선택
    const tagName = event.target.tagName
    const isFormControl =
      tagName === "INPUT" ||
      tagName === "BUTTON" ||
      tagName === "SELECT" ||
      tagName === "TEXTAREA"

    if (isFormControl) return

    if (event.key === "Escape") {
      event.preventDefault()
      setIsGridFocused(false)
      onMoveToCourse?.()
      return
    }

    if (!sortedRows.length) return

    if (event.key === "ArrowUp" && focusedRowIndex === 0) {
      event.preventDefault()
      setIsGridFocused(false)
      focusHeaderButton(0)
      return
    }

    if (event.key === "ArrowLeft" && focusedColIndex === 0) {
      event.preventDefault()
      setIsGridFocused(false)
      onMoveToStatus?.()
      return
    }

    if (event.key === "ArrowRight") {
      event.preventDefault()
      setFocusedColIndex((prev) => Math.min(prev + 1, ATTENDANCE_OPTIONS.length - 1))
      return
    }

    if (event.key === "ArrowLeft") {
      event.preventDefault()
      setFocusedColIndex((prev) => Math.max(prev - 1, 0))
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      setFocusedRowIndex((prev) => Math.min(prev + 1, sortedRows.length - 1))
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      setFocusedRowIndex((prev) => Math.max(prev - 1, 0))
      return
    }

    if (event.key === "Enter") {
      event.preventDefault()
      const row = sortedRows[focusedRowIndex]
      const option = ATTENDANCE_OPTIONS[focusedColIndex]
      if (!row || !option) return

      // 그리드 포커스를 유지한 채 현재 칸의 출석 상태를 적용
      if (mode === "bulk") {
        onRegisterStatusChange(row.loginID, option.value)
      } else {
        onDetailStatusChange(row.att_code, option.value)
      }
    }
  }

  // 정렬 기준과 방향을 변경(오름차순<->내림차순)
  function handleSort(key) {
    setShowSortMarker(true)
    setSortConfig((prev) => ({
      key,
      direction: prev.key === key && prev.direction === "desc" ? "asc" : "desc",
    }))
  }

  // 현재 정렬 방향에 맞는 표시 문자를 반환
  function sortMarker(key) {
    if (!showSortMarker) return ""
    if (sortConfig.key !== key) return ""
    return sortConfig.direction === "desc" ? "▼" : "▲"
  }

  return (
    <section
      className={styles.panel}
      ref={containerRef}
      tabIndex={-1}
      onFocusCapture={() => onActivate?.()}
    >
      <div className={styles.panelHead}>
        <h2 className={styles.panelTitle}>출석 등록</h2>
        {mode === "bulk" ? (
          <div className={styles.panelCaption}>강의 : {selectedCourseTitle || "-"}</div>
        ) : (
          <div className={styles.panelCaption}>
            강의 : {selectedCourseTitle || "-"} / 학생 : {selectedStudentName || "-"}
          </div>
        )}
      </div>

      <div className={`${styles.toolbar} ${styles.compact}`}>
        <div className={styles.segmented}>
          <button
            ref={bulkTabRef}
            type="button"
            className={`${mode === "bulk" ? styles.active : ""}`}
            onClick={() => onModeChange("bulk")}
            onFocus={handleToolbarFocus}
            onKeyDown={(event) => handleToolbarKeyDown(event, bulkTabRef)}
          >
            날짜별 출석 조회
          </button>
        </div>
        {mode === "bulk" ? (
          <div className={styles.editBtn}>
            <DatePicker
              selected={parseDateString(registerDate)}
              open={openCalendar === "register"}
              onChange={(date) => {
                onRegisterDateChange(formatDateString(date))
                setOpenCalendar("")
              }}
              onCalendarOpen={() => setOpenCalendar("register")}
              onCalendarClose={() => setOpenCalendar("")}
              preventOpenOnFocus
              dateFormat="yyyy-MM-dd"
              placeholderText="날짜 선택"
              customInput={
                <DateInput
                  inputRef={registerDateRef}
                  onInputFocus={handleToolbarFocus}
                  onInputKeyDown={(event) =>
                    handleDateKeyDown(event, onBulkSearch, registerDateRef, "register")
                  }
                />
              }
              popperClassName={styles.datePickerPopper}
              calendarClassName={styles.datePickerCalendar}
            />

            <button
              ref={bulkSearchRef}
              type="button"
              onClick={onBulkSearch}
              onFocus={handleToolbarFocus}
              disabled={!selectedCourseTitle}
              onKeyDown={(event) => handleToolbarKeyDown(event, bulkSearchRef)}
            >
              조회
            </button>
            <button
              ref={bulkSaveRef}
              type="button"
              className={styles.primary}
              onClick={onBulkSave}
              onFocus={handleToolbarFocus}
              disabled={!bulkSaveEnabled}
              onKeyDown={(event) => handleToolbarKeyDown(event, bulkSaveRef)}
            >
              저장
            </button>
          </div>
        ) : (
          <div className={styles.editBtn}>
            <DatePicker
              selected={parseDateString(detailDate)}
              open={openCalendar === "detail"}
              onChange={(date) => {
                onDetailDateChange(formatDateString(date))
                setOpenCalendar("")
              }}
              onCalendarOpen={() => setOpenCalendar("detail")}
              onCalendarClose={() => setOpenCalendar("")}
              preventOpenOnFocus
              dateFormat="yyyy-MM-dd"
              placeholderText="날짜 선택"
              customInput={
                <DateInput
                  inputRef={detailDateRef}
                  onInputFocus={handleToolbarFocus}
                  onInputKeyDown={(event) =>
                    handleDateKeyDown(event, onDetailSearch, detailDateRef, "detail")
                  }
                />
              }
              popperClassName={styles.datePickerPopper}
              calendarClassName={styles.datePickerCalendar}
            />

            <button
              ref={detailSearchRef}
              type="button"
              onClick={onDetailSearch}
              onFocus={handleToolbarFocus}
              disabled={!selectedStudentName}
              onKeyDown={(event) => handleToolbarKeyDown(event, detailSearchRef)}
            >
              조회
            </button>
            <button
              ref={detailSaveRef}
              type="button"
              className={styles.primary}
              onClick={onDetailSave}
              onFocus={handleToolbarFocus}
              disabled={!detailSaveEnabled}
              onKeyDown={(event) => handleToolbarKeyDown(event, detailSaveRef)}
            >
              저장
            </button>
          </div>
        )}
      </div>

      <div
        className={styles.tableWrap}
        ref={scrollWrapRef}
        tabIndex={0}
        onFocus={(event) => {
          const target = event.target
          if (target instanceof HTMLElement && target.closest("thead")) {
            setIsGridFocused(false)
            onActivate?.()
            return
          }
          setIsGridFocused(true)
          onActivate?.()
        }}
        onBlur={(event) => {
          if (!event.currentTarget.contains(event.relatedTarget)) {
            setIsGridFocused(false)
          }
        }}
        onKeyDown={handleTableKeyDown}
      >
        <table className={styles.gridTable}>
          <thead>
            <tr>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[0] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("studentName")}
                  onFocus={handleToolbarFocus}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 0)}
                >
                  학생명 {sortMarker("studentName")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[1] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("date")}
                  onFocus={handleToolbarFocus}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 1)}
                >
                  날짜 {sortMarker("date")}
                </button>
              </th>
              {ATTENDANCE_OPTIONS.map((option, headerIndex) => (
                <th key={option.value} className={styles.sortableTh}>
                  <button
                    ref={(node) => {
                      headerButtonRefs.current[headerIndex + 2] = node
                    }}
                    type="button"
                    className={styles.sortableButton}
                    onClick={() => handleSort(option.value)}
                    onFocus={handleToolbarFocus}
                    onKeyDown={(event) => handleHeaderKeyDown(event, headerIndex + 2)}
                  >
                    {option.label} {sortMarker(option.value)}
                  </button>
                </th>
              ))}
            </tr>
          </thead>

          <tbody>
            {mode === "bulk" ? (
              rows.length === 0 ? (
                <tr>
                  <td colSpan={2 + ATTENDANCE_OPTIONS.length} className={styles.emptyMessage}>
                    {!selectedCourseId ? "강의를 선택해 주세요." : "조회된 출석 데이터가 없습니다."}
                  </td>
                </tr>
              ) : (
                sortedRows.map((row, rowIndex) => (
                  <tr key={row.loginID}>
                    <td>{row.studentName}</td>
                    <td>{row.date}</td>
                    {ATTENDANCE_OPTIONS.map((option, optionIndex) => (
                      <td key={option.value}>
                        <input
                          type="radio"
                          name={`register-${row.loginID}`}
                          checked={Number(row.att_sta_code) === option.value}
                          onChange={() => {
                            setIsGridFocused(true)
                            setFocusedRowIndex(rowIndex)
                            setFocusedColIndex(optionIndex)
                            onRegisterStatusChange(row.loginID, option.value)
                            scrollWrapRef.current?.focus()
                          }}
                        />
                        {isActive && isGridFocused && focusedRowIndex === rowIndex && focusedColIndex === optionIndex ? (
                          <span
                            ref={(node) => {
                              cellRefs.current[`bulk-${rowIndex}-${optionIndex}`] = node
                            }}
                            className={styles.cellFocus}
                          />
                        ) : null}
                      </td>
                    ))}
                  </tr>
                ))
              )
            ) : rows.length === 0 ? (
              <tr>
                <td colSpan={2 + ATTENDANCE_OPTIONS.length} className={styles.emptyMessage}>
                  {!selectedCourseId ? "강의를 선택해 주세요" :
                    !selectedStudentId ? "학생을 선택해 주세요" :
                      `조회된 ${selectedStudentName || "선택한"} 학생의 출석 데이터가 없습니다.`}
                </td>
              </tr>
            ) : (
              sortedRows.map((row, rowIndex) => (
                <tr key={row.att_code}>
                  <td>{selectedStudentName || "-"}</td>
                  <td>{String(row.att_date).slice(0, 10)}</td>
                  {ATTENDANCE_OPTIONS.map((option, optionIndex) => (
                    <td key={option.value}>
                      <input
                        type="radio"
                        name={`detail-${row.att_code}`}
                        checked={Number(row.att_sta_code) === option.value}
                        onChange={() => {
                          setIsGridFocused(true)
                          setFocusedRowIndex(rowIndex)
                          setFocusedColIndex(optionIndex)
                          onDetailStatusChange(row.att_code, option.value)
                          scrollWrapRef.current?.focus()
                        }}
                      />
                      {isActive && isGridFocused && focusedRowIndex === rowIndex && focusedColIndex === optionIndex ? (
                        <span
                          ref={(node) => {
                            cellRefs.current[`individual-${rowIndex}-${optionIndex}`] = node
                          }}
                          className={styles.cellFocus}
                        />
                      ) : null}
                    </td>
                  ))}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </section>
  )
}
