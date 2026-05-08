import { useEffect, useMemo, useRef, useState } from "react"
import { COURSE_STATUS_OPTIONS } from "../attConstants"
import styles from "../AttendancePage.module.css"
import { ensureVisibleInScrollArea, focusRef, moveIndex } from "../utils/keyboardNavigation"

export default function CourseListPanel({
  courseRows,
  selectedCourseId,
  keyword,
  selectedStatuses,
  coursePage,
  onKeywordChange,
  onToggleStatus,
  onSearch,
  onSelectCourse,
  onPageChange,
  containerRef,
  isActive,
  onMoveToStatus,
  onPageSizeChange,
  totalPages,
  searchInputRef,
  onActivate,
  onDeactivate,
}) {
  const [focusedIndex, setFocusedIndex] = useState(-1)
  const [isTableFocused, setIsTableFocused] = useState(false)
  const panelRef = useRef(null)
  const wrapRef = useRef(null)
  const searchButtonRef = useRef(null)
  const checkboxRefs = useRef([])
  const rowRefs = useRef({})
  const paginationRefs = useRef([])

  useEffect(() => {
    // 바깥에서 선택 강의가 바뀌면 테이블 포커스 위치도 같은 행으로 변경
    const index = courseRows.findIndex((course) => course.course_id === selectedCourseId)
    setFocusedIndex(index >= 0 ? index : courseRows.length > 0 ? 0 : -1)
  }, [courseRows, selectedCourseId])

  useEffect(() => {
    if (isActive) {
      searchInputRef?.current?.focus()
    }
  }, [isActive, searchInputRef])

  useEffect(() => {
    if (!isActive) {
      setIsTableFocused(false)
    }
  }, [isActive])

  useEffect(() => {
    const element = wrapRef.current
    if (!element || !onPageSizeChange) return

    // 테이블 영역 높이에 맞춰 한 페이지에 보여줄 행 수를 계산
    const updatePageSize = () => {
      const headerHeight = 42
      const rowHeight = 41
      const rows = Math.max(1, Math.floor((element.clientHeight - headerHeight) / rowHeight))
      onPageSizeChange(rows)
    }

    updatePageSize()

    const observer = new ResizeObserver(updatePageSize)
    observer.observe(element)

    return () => observer.disconnect()
  }, [onPageSizeChange])

  useEffect(() => {
    if (!isActive || focusedIndex < 0) return

    const wrap = containerRef?.current
    const target = rowRefs.current[focusedIndex]
    ensureVisibleInScrollArea({ container: wrap, target })
  }, [focusedIndex, isActive, containerRef, courseRows])

  const visiblePages = useMemo(() => {
    if (!totalPages) return []

    const start = Math.max(1, coursePage - 2)
    const end = Math.min(totalPages, start + 4)
    const adjustedStart = Math.max(1, end - 4)

    return Array.from({ length: end - adjustedStart + 1 }, (_, index) => adjustedStart + index)
  }, [coursePage, totalPages])

  // 패널을 활성화하고 기본 포커스 행을 맞춘다.
  function activatePanel() {
    // 패널에 처음 들어왔을 때 선택 행이 없으면 첫 행부터 탐색
    onActivate?.()
    if (focusedIndex < 0 && courseRows.length > 0) {
      setFocusedIndex(0)
    }
  }

  // 포커스를 목록 테이블 영역으로 이동
  function moveToTable() {
    // 검색/필터 영역에서 아래로 내려오면 테이블 탐색 모드로 전환
    focusRef(containerRef)
    setIsTableFocused(true)
    activatePanel()
  }

  // 상태 필터 체크박스로 포커스를 이동
  function focusCheckbox(index) {
    focusRef(checkboxRefs.current[index])
  }

  // 검색 영역에서 아래 방향키를 눌렀을 때 첫 번째 필터나 테이블로 이동
  function moveDownFromSearchArea() {
    if (checkboxRefs.current[0]) {
      focusCheckbox(0)
      return
    }
    moveToTable()
  }

  // 테이블 첫 행 위에서 위 방향키를 눌렀을 때 필터 영역이나 검색 버튼으로 이동
  function moveUpFromTable() {
    if (checkboxRefs.current.length) {
      focusCheckbox(checkboxRefs.current.length - 1)
      return
    }
    searchButtonRef.current?.focus()
  }

  // 검색 입력창에서 사용하는 키보드 이동을 처리
  function handleSearchInputKeyDown(event) {
    // 검색창에서는 Enter 조회, 방향키 이동
    if (event.key === "Enter") {
      event.preventDefault()
      onSearch(1)
      return
    }

    if (event.key === "ArrowRight") {
      event.preventDefault()
      focusRef(searchButtonRef)
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      moveDownFromSearchArea()
    }
  }

  // 검색 버튼에서 사용하는 키보드 이동을 처리
  function handleSearchButtonKeyDown(event) {
    if (event.key === "ArrowLeft") {
      event.preventDefault()
      focusRef(searchInputRef)
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      moveDownFromSearchArea()
      return
    }

    if (event.key === "Enter") {
      event.preventDefault()
      onSearch(1)
    }
  }

  // 상태 필터 체크박스의 키보드 입력을 처리
  function handleCheckboxKeyDown(event, index, value) {
    // 체크박스 영역도 마우스 없이 탐색할 수 있도록 좌우 이동과 Enter 토글을 지원
    if (event.key === "Enter") {
      event.preventDefault()
      event.stopPropagation()
      onToggleStatus(value)
      return
    }

    if (event.key === "ArrowRight") {
      event.preventDefault()
      const nextIndex = Math.min(index + 1, COURSE_STATUS_OPTIONS.length - 1)
      focusCheckbox(nextIndex)
      return
    }

    if (event.key === "ArrowLeft") {
      event.preventDefault()
      if (index === 0) {
        focusRef(searchButtonRef)
      } else {
        focusCheckbox(index - 1)
      }
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      moveToTable()
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      searchInputRef?.current?.focus()
    }
  }

  // 강의 목록 테이블의 키보드 탐색을 처리
  function handleTableKeyDown(event) {
    // 테이블에서는 위아래로 행 이동, 오른쪽으로 다음 패널 이동
    if (!courseRows.length) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      if (focusedIndex >= courseRows.length - 1) {
        focusPagination(0)
        return
      }
      setFocusedIndex((prev) => moveIndex(prev, 1, courseRows.length - 1))
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      if (focusedIndex <= 0) {
        moveUpFromTable()
        return
      }
      setFocusedIndex((prev) => moveIndex(prev, -1, courseRows.length - 1))
      return
    }

    if (event.key === "ArrowRight") {
      event.preventDefault()
      // 단순 이동일 때는 재선택하지 않고 다음 패널로만 포커스를 넘긴다.
      onMoveToStatus?.()
      return
    }

    if (event.key === "Enter" && focusedIndex >= 0) {
      event.preventDefault()
      onSelectCourse(courseRows[focusedIndex])
      onMoveToStatus?.()
    }
  }

  // 페이지 버튼으로 포커스를 이동
  function focusPagination(index) {
    focusRef(paginationRefs.current[index])
  }

  // 페이지네이션 버튼의 키보드 입력을 처리
  function handlePaginationKeyDown(event, index) {
    // 페이지 버튼에서도 같은 방향키 규칙을 유지
    const lastIndex = paginationRefs.current.length - 1

    if (event.key === "ArrowRight") {
      event.preventDefault()
      focusPagination(Math.min(index + 1, lastIndex))
      return
    }

    if (event.key === "ArrowLeft") {
      event.preventDefault()
      focusPagination(Math.max(index - 1, 0))
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      moveToTable()
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      onMoveToStatus?.()
    }
  }

  return (
    <section
      ref={panelRef}
      className={`${styles.panel} ${styles.coursePanel}`}
      onBlurCapture={(event) => {
        if (!event.currentTarget.contains(event.relatedTarget)) {
          onDeactivate?.()
        }
      }}
    >
      <h2 className={styles.panelTitle}>강의 목록</h2>

      <div className={styles.toolbar}>
        <input
          ref={searchInputRef}
          value={keyword}
          onChange={(event) => onKeywordChange(event.target.value)}
          onFocus={() => {
            setIsTableFocused(false)
            onActivate?.()
          }}
          onKeyDown={handleSearchInputKeyDown}
          placeholder="강의명을 입력하세요"
        />
        <button
          ref={searchButtonRef}
          type="button"
          onClick={() => onSearch(1)}
          onFocus={() => {
            setIsTableFocused(false)
            onActivate?.()
          }}
          onKeyDown={handleSearchButtonKeyDown}
        >
          검색
        </button>
      </div>

      <div className={styles.statusChecks}>
        {COURSE_STATUS_OPTIONS.map((option, index) => {
          const isChecked = selectedStatuses.includes(option.value)

          return (
            <label
              key={option.value}
              className={`${styles.statusCheckLabel} ${isChecked ? styles.statusCheckLabelChecked : ""}`}
            >
              <input
                ref={(node) => {
                  checkboxRefs.current[index] = node
                }}
                type="checkbox"
                checked={isChecked}
                onFocus={() => {
                  setIsTableFocused(false)
                  onActivate?.()
                }}
                onChange={() => onToggleStatus(option.value)}
                onKeyDown={(event) => handleCheckboxKeyDown(event, index, option.value)}
              />
              <span>{option.label}</span>
            </label>
          )
        })}
      </div>

      <div
        className={`${styles.tableWrap} ${styles.tall}`}
        ref={containerRef}
        tabIndex={0}
        onFocus={() => {
          setIsTableFocused(true)
          activatePanel()
        }}
        onBlur={(event) => {
          if (!event.currentTarget.contains(event.relatedTarget)) {
            setIsTableFocused(false)
          }
        }}
        onKeyDown={handleTableKeyDown}
      >
        <div ref={wrapRef} className={styles.innerScroller}>
          <table className={styles.gridTable}>
            <thead>
              <tr>
                <th>강의명</th>
                <th>수강인원</th>
                <th>정원</th>
                <th>출석률</th>
              </tr>
            </thead>
            <tbody>
              {courseRows.length === 0 ? (
                <tr>
                  <td colSpan={4} className={styles.emptyMessage}>검색 결과가 없습니다.</td>
                </tr>
              ) : (
                courseRows.map((course, index) => (
                  <tr
                    key={course.course_id}
                    ref={(node) => {
                      rowRefs.current[index] = node
                    }}
                    className={selectedCourseId === course.course_id ? styles.isSelected : ""}
                    onClick={() => {
                      setIsTableFocused(true)
                      setFocusedIndex(index)
                      onSelectCourse(course)
                    }}
                  >
                    <td className={isActive && isTableFocused && focusedIndex === index ? styles.keyboardFocus : ""}>{course.title}</td>
                    <td>{course.stu_cnt}명</td>
                    <td>{course.people_limit}명</td>
                    <td>{course.att_ratio}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className={styles.pagination}>
        <button
          ref={(node) => {
            paginationRefs.current[0] = node
          }}
          type="button"
          onClick={() => onPageChange(Math.max(1, coursePage - 1))}
          onFocus={() => {
            setIsTableFocused(false)
            onActivate?.()
          }}
          onKeyDown={(event) => handlePaginationKeyDown(event, 0)}
          disabled={coursePage <= 1}
        >
          {"<"}
        </button>
        {visiblePages.map((page) => (
          <button
            key={page}
            ref={(node) => {
              paginationRefs.current[page === visiblePages[0] ? 1 : visiblePages.indexOf(page) + 1] = node
            }}
            type="button"
            className={coursePage === page ? styles.active : ""}
            onClick={() => onPageChange(page)}
            onFocus={() => {
              setIsTableFocused(false)
              onActivate?.()
            }}
            onKeyDown={(event) => handlePaginationKeyDown(event, visiblePages.indexOf(page) + 1)}
          >
            {page}
          </button>
        ))}
        <button
          ref={(node) => {
            paginationRefs.current[visiblePages.length + 1] = node
          }}
          type="button"
          onClick={() => onPageChange(coursePage + 1)}
          onFocus={() => {
            setIsTableFocused(false)
            onActivate?.()
          }}
          onKeyDown={(event) => handlePaginationKeyDown(event, visiblePages.length + 1)}
          disabled={coursePage >= totalPages}
        >
          {">"}
        </button>
      </div>
    </section>
  )
}
