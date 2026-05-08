import { useEffect, useMemo, useRef, useState } from "react"
import styles from "../AttendancePage.module.css"
import { ensureVisibleInScrollArea, moveIndex } from "../utils/keyboardNavigation"

export default function AttendanceStatusPanel({
  selectedCourseTitle,
  studentRows,
  selectedStudentId,
  onSelectStudent,
  containerRef,
  isActive,
  onMoveToCourse,
  onMoveToEditor,
  onActivate,
  onDeactivate,
}) {
  const [focusedIndex, setFocusedIndex] = useState(-1)
  const [isBodyFocused, setIsBodyFocused] = useState(false)
  const [sortConfig, setSortConfig] = useState({ key: "", direction: "desc" })
  const rowRefs = useRef({})
  const headerButtonRefs = useRef([])

  const sortedRows = useMemo(() => {
    if (!sortConfig.key) {
      return studentRows
    }

    const list = [...studentRows]
    const { key, direction } = sortConfig
    const order = direction === "desc" ? -1 : 1

    list.sort((a, b) => {
      const aValue = a[key] ?? ""
      const bValue = b[key] ?? ""

      if (typeof aValue === "number" && typeof bValue === "number") {
        return (aValue - bValue) * order
      }

      return String(aValue).localeCompare(String(bValue), "ko") * order
    })

    return list
  }, [studentRows, sortConfig])

  useEffect(() => {
    // 현재 선택된 학생이 바뀌면 키보드 포커스도 같은 학생으로 변경
    const index = sortedRows.findIndex((row) => row.stu_loginID === selectedStudentId)
    setFocusedIndex(index >= 0 ? index : sortedRows.length > 0 ? 0 : -1)
  }, [sortedRows, selectedStudentId])

  useEffect(() => {
    if (isActive) {
      containerRef?.current?.focus()
    }
  }, [isActive, containerRef])

  useEffect(() => {
    if (!isActive || focusedIndex < 0) return

    // 키보드 이동 중에도 현재 선택된 학생 행이 화면 안에 보이도록 스크롤 설정
    const wrap = containerRef?.current
    const target = rowRefs.current[focusedIndex]
    ensureVisibleInScrollArea({ container: wrap, target })
  }, [focusedIndex, isActive, containerRef, sortedRows])

  // 패널을 활성화하고 기본 포커스 행을 맞춘다.
  function activatePanel() {
    // 패널이 활성화됐는데 포커스 대상이 없다면 첫 학생부터 탐색할 수 있게 한다.
    onActivate?.()
    setIsBodyFocused(true)
    if (focusedIndex < 0 && sortedRows.length > 0) {
      setFocusedIndex(0)
    }
  }

  // 학생 선택
  function selectRow(row) {
    // 학생을 고르면 부모에서 상세 이력을 조회
    onSelectStudent(row)
    onMoveToEditor?.()
  }

  function focusHeaderButton(index) {
    setIsBodyFocused(false)
    headerButtonRefs.current[index]?.focus()
  }

  function moveToTableFromHeader() {
    containerRef?.current?.focus()
    activatePanel()
  }

  function handleHeaderKeyDown(event, index) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault()
      event.stopPropagation()
      event.currentTarget.click()
      return
    }

    if (event.key === "Tab") {
      event.preventDefault()
      event.stopPropagation()
      if (event.shiftKey) {
        onMoveToCourse?.()
      } else {
        onMoveToEditor?.()
      }
      return
    }

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
        onMoveToCourse?.()
        return
      }
      focusHeaderButton(Math.max(index - 1, 0))
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      event.stopPropagation()
      moveToTableFromHeader()
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      event.stopPropagation()
      onMoveToCourse?.()
    }
  }

  // 학생 목록 테이블의 키보드 탐색을 처리
  function handleKeyDown(event) {
    if (event.key === "Escape" || event.key === "ArrowLeft") {
      event.preventDefault()
      onMoveToCourse?.()
      return
    }

    if (event.key === "ArrowRight") {
      event.preventDefault()
      onMoveToEditor?.()
      return
    }

    if (!sortedRows.length) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      setFocusedIndex((prev) => moveIndex(prev, 1, sortedRows.length - 1))
      return
    }

    if (event.key === "ArrowUp") {
      if (focusedIndex <= 0) {
        event.preventDefault()
        focusHeaderButton(0)
        return
      }

      event.preventDefault()
      setFocusedIndex((prev) => moveIndex(prev, -1, sortedRows.length - 1))
      return
    }

    if (event.key === "Enter" && focusedIndex >= 0) {
      event.preventDefault()
      selectRow(sortedRows[focusedIndex])
    }
  }

  // 학생 목록 정렬 기준을 변경
  function handleSort(key) {
    setSortConfig((prev) => ({
      key,
      direction: prev.key === key && prev.direction === "desc" ? "asc" : "desc",
    }))
  }

  // 현재 정렬 방향에 맞는 표시 문자를 반환
  function sortMarker(key) {
    if (sortConfig.key !== key) return ""
    return sortConfig.direction === "desc" ? "▼" : "▲"
  }

  return (
    <section className={styles.panel}>
      <div className={styles.panelHead}>
        <h2 className={styles.panelTitle}>출석 현황</h2>
        <div className={styles.panelCaption}>강의 : {selectedCourseTitle || "-"}</div>
      </div>

      <div
        className={styles.tableWrap}
        ref={containerRef}
        tabIndex={0}
        onFocus={(event) => {
          const target = event.target
          if (target instanceof HTMLElement && target.closest("thead")) {
            setIsBodyFocused(false)
            onActivate?.()
            return
          }
          activatePanel()
        }}
        onBlur={(event) => {
          if (!event.currentTarget.contains(event.relatedTarget)) {
            setIsBodyFocused(false)
            onDeactivate?.()
          }
        }}
        onKeyDown={handleKeyDown}
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
                  onClick={() => handleSort("prof_name")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 0)}
                >
                  강사명 {sortMarker("prof_name")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[1] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("stu_name")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 1)}
                >
                  학생명 {sortMarker("stu_name")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[2] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("att_cnt")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 2)}
                >
                  출석 {sortMarker("att_cnt")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[3] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("att_per_cnt")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 3)}
                >
                  지각 {sortMarker("att_per_cnt")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[4] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("att_leav_cnt")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 4)}
                >
                  조퇴 {sortMarker("att_leav_cnt")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[5] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("att_out_cnt")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 5)}
                >
                  외출 {sortMarker("att_out_cnt")}
                </button>
              </th>
              <th className={styles.sortableTh}>
                <button
                  ref={(node) => {
                    headerButtonRefs.current[6] = node
                  }}
                  type="button"
                  className={styles.sortableButton}
                  onClick={() => handleSort("att_abs_cnt")}
                  onFocus={() => onActivate?.()}
                  onKeyDown={(event) => handleHeaderKeyDown(event, 6)}
                >
                  결석 {sortMarker("att_abs_cnt")}
                </button>
              </th>
            </tr>
          </thead>
          <tbody>
            {sortedRows.length === 0 ? (
              <tr>
                <td colSpan={7} className={styles.emptyMessage}>
                {!selectedCourseTitle ? "강의를 선택해 주세요." : "수강 학생이 없습니다."}
                </td>
              </tr>
            ) : (
              sortedRows.map((row, index) => (
                <tr
                  key={row.stu_loginID}
                  ref={(node) => {
                    rowRefs.current[index] = node
                  }}
                  className={selectedStudentId === row.stu_loginID ? styles.isSelected : ""}
                  onClick={() => selectRow(row)}
                >
                  <td className={isActive && isBodyFocused && focusedIndex === index ? styles.keyboardFocus : ""}>{row.prof_name}</td>
                  <td>{row.stu_name}</td>
                  <td>{row.att_cnt}</td>
                  <td>{row.att_per_cnt}</td>
                  <td>{row.att_leav_cnt}</td>
                  <td>{row.att_out_cnt}</td>
                  <td>{row.att_abs_cnt}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </section>
  )
}
