import api from "../../../api/axios"

function postJson(url, payload) {
  return api.post(url, payload, {
    headers: {
      "Content-Type": "application/json",
    },
  })
}

export async function fetchCourseList({ currentPage = 1, pageSize = 5, title = "" }) {
  const response = await postJson("/inst/allCourseList.do", {
    currentPage,
    pageSize,
    title,
  })

  return response.data
}

export async function fetchCourseStudentList({ courseId, currentPage = 1, pageSize = 10 }) {
  const response = await postJson("/inst/courseStudentList.do", {
    course_id: courseId,
    currentPage: String(currentPage),
    pageSize: String(pageSize),
  })

  return response.data
}

export async function fetchStudentAttendanceDetail({
  courseId,
  studentLoginId,
  currentPage = 1,
  pageSize = 10,
}) {
  const response = await postJson("/inst/stuAttDtlList.do", {
    course_id: courseId,
    stu_loginID: studentLoginId,
    currentPage: String(currentPage),
    pageSize: String(pageSize),
  })

  return response.data
}

export async function updateAttendanceStatus({ attCode, attStaCode }) {
  const response = await postJson("/inst/modifyStuAtt.do", {
    att_code: attCode,
    att_sta_code: attStaCode,
  })

  return response.data
}

export async function saveAttendanceBatch(rows) {
  const response = await postJson("/inst/stuAttDtlReg.do", rows)
  return response.data
}

export async function fetchAttendanceRegisterList({ courseId, attDate }) {
  const response = await postJson("/inst/stuAttDtlRegList.do", {
    course_id: courseId,
    att_date: attDate,
  })

  return response.data
}
