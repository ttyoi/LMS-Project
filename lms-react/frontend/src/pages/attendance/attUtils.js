export function formatDateInput(date = new Date()) {
  return new Date(date.getTime() - date.getTimezoneOffset() * 60000)
    .toISOString()
    .slice(0, 10)
}

export function mapCourseRow(row) {
  return {
    ...row,
    course_id: row.course_id ?? row.courseId,
    title: row.title ?? row.cour_title ?? "",
    current_people: row.current_people ?? row.studentCount ?? row.stu_cnt ?? "-",
    capacity: row.capacity ?? row.max_people ?? row.maxPeople ?? row.people_limit ?? "-",
    attendanceRate: row.attendanceRate ?? row.att_rate ?? row.att_ratio ?? "-",
  }
}

export function resolveAttendanceCode(value) {
  return value === null || value === undefined || value === "" ? 0 : Number(value)
}

export function mapRegisterRows(studentRows, attDate) {
  return studentRows.map((row) => ({
    attendance_code: row.today_att_code_pk ?? row.today_att_code ?? null,
    course_id: row.course_id,
    loginID: row.stu_loginID,
    studentName: row.stu_name,
    date: attDate,
    att_sta_code: resolveAttendanceCode(row.today_att_code),
  }))
}

export function extractCourseStatus(course, currentDate = formatDateInput()) {
  const startDate = course.start_date ?? course.startDate
  const endDate = course.end_date ?? course.endDate

  if (!startDate || !endDate) return null

  if (currentDate < startDate) return "RECRUIT"
  if (currentDate > endDate) return "END"
  return "ING"
}

export function isDateWithinCoursePeriod(course, targetDate) {
  const startDate = course?.start_date ?? course?.startDate
  const endDate = course?.end_date ?? course?.endDate

  if (!startDate || !endDate || !targetDate) return false
  return targetDate >= startDate && targetDate <= endDate
}

export function filterCoursesByStatus(list, selectedStatuses, currentDate = formatDateInput()) {
  if (!selectedStatuses.length) return list

  return list.filter((course) => {
    const courseStatus = extractCourseStatus(course, currentDate)
    return courseStatus ? selectedStatuses.includes(courseStatus) : false
  })
}

export function sortCoursesByStatus(list, currentDate = formatDateInput()) {
  const statusOrder = {
    ING: 0,
    RECRUIT: 1,
    END: 2,
  }

  return [...list].sort((a, b) => {
    const aStatus = extractCourseStatus(a, currentDate)
    const bStatus = extractCourseStatus(b, currentDate)
    const aOrder = statusOrder[aStatus] ?? 999
    const bOrder = statusOrder[bStatus] ?? 999
    return aOrder - bOrder
  })
}
