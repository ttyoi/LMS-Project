import {
  fetchAttendanceRegisterList,
  fetchCourseList,
  fetchCourseStudentList,
  fetchStudentAttendanceDetail,
} from "../api/attendanceApi"
import {
  filterCoursesByStatus,
  mapCourseRow,
  mapRegisterRows,
  resolveAttendanceCode,
  sortCoursesByStatus,
} from "../attUtils"

// 강의 목록 전체를 페이지 단위로 이어서 조회
async function fetchAllCourseRows(title) {
  const pageSize = 100
  let currentPage = 1
  let totalCount = null
  let sourceRows = []

  while (true) {
    const data = await fetchCourseList({
      currentPage,
      pageSize,
      title,
    })

    const pageRows = data.list || []
    sourceRows = [...sourceRows, ...pageRows]

    const parsedTotalCount = Number(data.totalCount)
    if (Number.isFinite(parsedTotalCount) && parsedTotalCount >= 0) {
      totalCount = parsedTotalCount
    }

    if (!pageRows.length) break
    if (totalCount !== null && sourceRows.length >= totalCount) break
    if (pageRows.length < pageSize) break

    currentPage += 1
  }

  return sourceRows
}

// 강의 목록을 화면용 데이터로 가공하고 페이지 정보와 함께 반환
export async function getCourseListPage({ keyword, selectedStatuses, page, pageSize }) {
  const sourceRows = await fetchAllCourseRows(keyword)
  const mappedRows = sourceRows.map(mapCourseRow)
  const filteredRows = filterCoursesByStatus(mappedRows, selectedStatuses)
  const sortedRows = sortCoursesByStatus(filteredRows)
  const totalCount = sortedRows.length
  const safePage = Math.min(
    Math.max(1, page),
    Math.max(1, Math.ceil(totalCount / Math.max(1, pageSize)))
  )
  const startIndex = (safePage - 1) * pageSize

  return {
    rows: sortedRows.slice(startIndex, startIndex + pageSize),
    totalCount,
    safePage,
  }
}

// 특정 강의의 학생 목록을 조회
export async function getStudentRows(courseId) {
  const data = await fetchCourseStudentList({
    courseId,
    currentPage: 1,
    pageSize: 10,
  })

  return data.list || []
}

// 특정 학생의 출석 이력을 조회, 필요하면 날짜로 한 번 더 필터링
export async function getStudentDetailRows({ courseId, studentLoginId, dateFilter = "" }) {
  const pageSize = 100
  let currentPage = 1
  let totalCount = null
  let sourceRows = []

  // 개인 출석 이력도 여러 페이지로 나뉠 수 있어서 필요한 만큼 이어붙여서 사용
  while (true) {
    const data = await fetchStudentAttendanceDetail({
      courseId,
      studentLoginId,
      currentPage,
      pageSize,
    })

    const pageRows = data.list || []
    sourceRows = [...sourceRows, ...pageRows]

    const parsedTotalCount = Number(data.totalCount)
    if (Number.isFinite(parsedTotalCount) && parsedTotalCount >= 0) {
      totalCount = parsedTotalCount
    }

    if (!pageRows.length) break
    if (totalCount !== null && sourceRows.length >= totalCount) break
    if (pageRows.length < pageSize) break

    currentPage += 1
  }

  return dateFilter
    ? sourceRows.filter((row) => String(row.att_date).slice(0, 10) === dateFilter)
    : sourceRows
}

// 특정 날짜 기준의 일괄 등록용 출석 행 생성
export async function getRegisterRowsByDate({ courseId, targetDate, today, studentRows }) {
  // 오늘 날짜 출석은 아직 등록 이력이 없을 수 있어서,
  // 이미 불러온 학생 목록만으로도 기본 입력 행을 바로 만들 수 있게 해둔다.
  // 오늘 날짜 출석은 이미 불러온 학생 목록으로 기본 행을 바로 만들 수 있다.
  if (targetDate === today) {
    return mapRegisterRows(studentRows, targetDate)
  }

  const response = await fetchAttendanceRegisterList({
    courseId,
    attDate: targetDate,
  })

  if (response?.list?.length) {
    return response.list.map((item) => ({
      attendance_code: item.today_att_code ?? null,
      course_id: item.course_id,
      loginID: item.stu_loginID,
      studentName: item.stu_name,
      date: response.att_date || targetDate,
      att_sta_code: resolveAttendanceCode(item.att_sta_code),
    }))
  }

  return mapRegisterRows(studentRows, targetDate)
}
