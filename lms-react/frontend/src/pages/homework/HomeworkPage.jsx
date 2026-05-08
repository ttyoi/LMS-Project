import { Fragment, useCallback, useEffect, useMemo, useState } from 'react'
import { useLocation } from 'react-router-dom'
import api from '../../api/axios'
import { useAuth } from '../../context/AuthContext'
import styles from './HomeworkPage.module.css'

function parseYmdToLocalDate(value) {
  if (!value || typeof value !== 'string') return null
  const datePart = value.trim().slice(0, 10)
  const [y, m, d] = datePart.split('-').map(Number)
  if (!y || !m || !d) return null
  return new Date(y, m - 1, d)
}

function getStatusByDate(startDateText, endDateText) {
  const today = new Date()
  const todayOnly = new Date(today.getFullYear(), today.getMonth(), today.getDate())
  const start = parseYmdToLocalDate(startDateText)
  const end = parseYmdToLocalDate(endDateText)

  if (!start || !end) return '진행중'
  if (todayOnly < start) return '진행 예정'
  if (todayOnly > end) return '마감'
  return '진행중'
}

function isDeadlineClosed(endDateText) {
  const today = new Date()
  const todayOnly = new Date(today.getFullYear(), today.getMonth(), today.getDate())
  const end = parseYmdToLocalDate(endDateText)
  if (!end) return false
  return todayOnly > end
}

function DownloadIcon({ disabled = false }) {
  return (
    <svg
      viewBox="0 0 24 24"
      className={`${styles.downloadIcon} ${disabled ? styles.downloadIconDisabled : ''}`}
      aria-hidden="true"
    >
      <path d="M12 3a1 1 0 0 1 1 1v8.59l2.3-2.29a1 1 0 1 1 1.4 1.41l-4 4a1 1 0 0 1-1.4 0l-4-4a1 1 0 1 1 1.4-1.41L11 12.59V4a1 1 0 0 1 1-1Z" />
      <path d="M5 16a1 1 0 0 1 1 1v2h12v-2a1 1 0 1 1 2 0v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1Z" />
    </svg>
  )
}

function HomeworkPage() {
  const location = useLocation()
  const { user } = useAuth()

  const isInstAssignmentsPage = location.pathname === '/inst/assignments'
  const isInstSubmissionPage = location.pathname === '/inst/submissions'
  const isStuAssignmentsPage = location.pathname === '/stu/assignments'
  const isStuResultPage = location.pathname === '/stu/assignments-result'

  const [homeworkList, setHomeworkList] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [selectedCourse, setSelectedCourse] = useState('')
  const [keyword, setKeyword] = useState('')
  const [page, setPage] = useState(1)

  const [submissionList, setSubmissionList] = useState([])
  const [evaluationEdited, setEvaluationEdited] = useState({})
  const [activeEvaluationId, setActiveEvaluationId] = useState(null)
  const [evaluationForm, setEvaluationForm] = useState({ score: '', feedback: '' })

  const [showRegisterForm, setShowRegisterForm] = useState(false)
  const [instCourseList, setInstCourseList] = useState([])
  const [registerForm, setRegisterForm] = useState({
    courseId: '',
    title: '',
    instructor: user?.userNm || '',
    startDate: '',
    endDate: '',
    file: null,
  })

  const [activeStudentHomeworkId, setActiveStudentHomeworkId] = useState(null)
  const [studentDetail, setStudentDetail] = useState(null)
  const [studentDetailLoading, setStudentDetailLoading] = useState(false)
  const [studentSubmitFile, setStudentSubmitFile] = useState(null)
  const [studentSubmitting, setStudentSubmitting] = useState(false)
  const [studentResults, setStudentResults] = useState([])

  const pageSize = 4

  const fetchHomeworkList = useCallback(async () => {
    if (!user?.loginId) {
      setHomeworkList([])
      setLoading(false)
      setError('로그인 정보가 없습니다. 다시 로그인해 주세요.')
      return
    }

    try {
      setLoading(true)
      setError('')
      const listUrl = isInstAssignmentsPage ? '/inst/homeworklist.do' : '/stu/homeworklist.do'
      const requestConfig = isInstAssignmentsPage ? {} : { params: { loginId: user.loginId } }
      const { data } = await api.get(listUrl, requestConfig)

      if (!Array.isArray(data)) {
        setHomeworkList([])
        setError('과제 목록 응답 형식이 올바르지 않습니다.')
        return
      }

      const normalized = data.map((item) => {
        const status = getStatusByDate(item.start_date, item.end_date)
        return {
          id: item.homework_code,
          courseName: item.title || item.homework_title || item.course_name || '-',
          instructor: item.teacher_name || item.teacher || '-',
          startDate: item.start_date || '-',
          dueDate: item.end_date || '-',
          status,
          downloadable: status !== '마감' && !!item.file_id,
          fileId: item.file_id,
          submissionCode: item.submission_code || null,
          score: item.score ?? null,
          feedback: item.feedback ?? '',
          submitDate: item.submit_date || '',
        }
      })

      setHomeworkList(normalized)
      return normalized
    } catch {
      setError('과제 목록을 불러오지 못했습니다.')
      return []
    } finally {
      setLoading(false)
    }
  }, [isInstAssignmentsPage, user?.loginId])

  const fetchStudentResults = useCallback(async () => {
    try {
      setLoading(true)
      setError('')
      const { data } = await api.get('/stu/submittedList.do')
      if (!Array.isArray(data)) {
        setStudentResults([])
        setError('과제 결과 응답 형식이 올바르지 않습니다.')
        return
      }
      const normalized = data.map((item, index) => ({
        id: item.submission_code ?? index + 1,
        courseHomework: `${item.course_name || '-'} / ${item.homework_title || '-'}`,
        submitDate: item.submit_date || '-',
        status: item.status === 1 ? '제출 완료' : '미제출',
        score: item.score ?? '-',
        feedback: item.feedback || '-',
      }))
      setStudentResults(normalized)
    } catch {
      setError('과제 결과를 불러오지 못했습니다.')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    if (isInstSubmissionPage || isStuResultPage) return
    fetchHomeworkList()
  }, [isInstSubmissionPage, isStuResultPage, fetchHomeworkList])

  useEffect(() => {
    if (!isInstSubmissionPage) return
    const fetchSubmissionList = async () => {
      try {
        setLoading(true)
        setError('')
        const { data } = await api.get('/inst/submissions/listAll.do')
        if (!Array.isArray(data)) {
          setSubmissionList([])
          setError('제출된 과제 목록 응답 형식이 올바르지 않습니다.')
          return
        }
        const normalized = data.map((item, index) => ({
          id: item.submission_code ?? index + 1,
          studentName: item.student_name || item.student_id || '-',
          courseHomework: `${item.course_name || '-'} / ${item.homework_title || '-'}`,
          submitDate: item.submit_date || '-',
          endDate: item.end_date || '',
          status: item.submit_date ? '제출 완료' : '미제출',
          score: item.score ?? '-',
          rawScore: item.score ?? '',
          rawFeedback: item.feedback ?? '',
          hasEvaluation:
            (item.score !== null && item.score !== undefined) ||
            (item.feedback && String(item.feedback).trim() !== ''),
        }))
        setSubmissionList(normalized)
      } catch {
        setError('제출된 과제 목록을 불러오지 못했습니다.')
      } finally {
        setLoading(false)
      }
    }
    fetchSubmissionList()
  }, [isInstSubmissionPage])

  useEffect(() => {
    if (!isStuResultPage) return
    fetchStudentResults()
  }, [isStuResultPage, fetchStudentResults])

  useEffect(() => {
    if (!isInstAssignmentsPage) return
    const fetchInstCourseList = async () => {
      try {
        const { data } = await api.get('/inst/getcourselist.do')
        setInstCourseList(Array.isArray(data) ? data : [])
      } catch {
        setInstCourseList([])
      }
    }
    fetchInstCourseList()
  }, [isInstAssignmentsPage])

  const courseOptions = useMemo(
    () => [...new Set(homeworkList.map((item) => item.courseName))],
    [homeworkList]
  )

  const filteredList = useMemo(() => {
    const normalizedKeyword = keyword.trim().toLowerCase()
    return homeworkList.filter((item) => {
      const matchCourse = selectedCourse ? item.courseName === selectedCourse : true
      const matchKeyword = normalizedKeyword
        ? item.courseName.toLowerCase().includes(normalizedKeyword)
        : true
      return matchCourse && matchKeyword
    })
  }, [homeworkList, selectedCourse, keyword])

  const totalPages = Math.max(1, Math.ceil(filteredList.length / pageSize))
  const currentPage = Math.min(page, totalPages)
  const pageItems = filteredList.slice((currentPage - 1) * pageSize, currentPage * pageSize)
  const startItem = filteredList.length === 0 ? 0 : (currentPage - 1) * pageSize + 1
  const endItem = Math.min(currentPage * pageSize, filteredList.length)

  const handleSearch = () => setPage(1)

  const handleRegisterField = (e) => {
    const { name, value } = e.target
    setRegisterForm((prev) => ({ ...prev, [name]: value }))
  }
  const handleRegisterFile = (e) => {
    const file = e.target.files?.[0] || null
    if (file && file.size === 0) {
      alert('파일 내용이 없습니다. 내용이 있는 파일을 첨부해 주세요.')
      e.target.value = ''
      return
    }
    setRegisterForm((prev) => ({ ...prev, file }))
  }
  const clearRegisterFile = () => {
    setRegisterForm((prev) => ({ ...prev, file: null }))
  }
  const openRegisterForm = () => {
    setRegisterForm((prev) => ({
      ...prev,
      instructor: user?.userNm || prev.instructor || '',
      courseId: prev.courseId || '',
    }))
    setShowRegisterForm(true)
  }
  const closeRegisterForm = () => {
    setShowRegisterForm(false)
    setRegisterForm({
      courseId: '',
      title: '',
      instructor: user?.userNm || '',
      startDate: '',
      endDate: '',
      file: null,
    })
  }
  const submitRegisterForm = async () => {
    if (!registerForm.courseId || !registerForm.title.trim()) {
      alert('과정과 과제명을 확인해 주세요.')
      return
    }
    if (!registerForm.startDate || !registerForm.endDate) {
      alert('시작일과 마감일을 입력해 주세요.')
      return
    }
    try {
      const formData = new FormData()
      formData.append('course_id', String(Number(registerForm.courseId)))
      formData.append('title', registerForm.title.trim())
      formData.append('content', '')
      formData.append('start_date', registerForm.startDate)
      formData.append('end_date', registerForm.endDate)
      if (registerForm.file) formData.append('files', registerForm.file)
      await api.post('/inst/homeworkInsert.do', formData)
      alert('과제가 등록되었습니다.')
      closeRegisterForm()
      fetchHomeworkList()
    } catch {
      alert('등록에 실패했습니다. 입력값과 파일을 확인해 주세요.')
    }
  }

  const handleEvaluationClick = (item) => {
    setActiveEvaluationId(item.id)
    setEvaluationForm({
      score: item.rawScore !== '' ? String(item.rawScore) : '',
      feedback: item.rawFeedback || '',
    })
  }
  const handleEvaluationField = (e) => {
    const { name, value } = e.target
    setEvaluationForm((prev) => ({ ...prev, [name]: value }))
  }
  const cancelEvaluation = () => {
    setActiveEvaluationId(null)
    setEvaluationForm({ score: '', feedback: '' })
  }
  const saveEvaluation = async (item) => {
    try {
      await api.post(
        '/inst/submissions/update.do',
        {
          submissionCode: item.id,
          score: evaluationForm.score,
          feedback: evaluationForm.feedback,
        },
        { headers: { 'Content-Type': 'application/json' } }
      )
      alert(`${item.studentName} 학생의 점수/피드백이 저장되었습니다.`)
      setSubmissionList((prev) =>
        prev.map((row) =>
          row.id === item.id
            ? {
                ...row,
                score: evaluationForm.score === '' ? '-' : evaluationForm.score,
                rawScore: evaluationForm.score,
                rawFeedback: evaluationForm.feedback,
                hasEvaluation: evaluationForm.score !== '' || evaluationForm.feedback.trim() !== '',
              }
            : row
        )
      )
      setEvaluationEdited((prev) => ({ ...prev, [item.id]: true }))
      setActiveEvaluationId(null)
    } catch {
      alert('저장에 실패했습니다. 잠시 후 다시 시도해 주세요.')
    }
  }

  const openStudentSubmitPanel = async (item) => {
    setActiveStudentHomeworkId(item.id)
    setStudentSubmitFile(null)
    setStudentDetailLoading(true)
    try {
      const submissionId = item.submissionCode || 0
      const { data } = await api.get(`/stu/assignmentDetail/${item.id}/${submissionId}.do`)
      setStudentDetail(data || null)
    } catch {
      setStudentDetail(null)
      alert('과제 상세 정보를 불러오지 못했습니다.')
    } finally {
      setStudentDetailLoading(false)
    }
  }

  const submitStudentHomework = async () => {
    if (!activeStudentHomeworkId) {
      alert('제출할 과제를 선택해 주세요.')
      return
    }
    if (!studentSubmitFile) {
      alert('제출 파일을 첨부해 주세요.')
      return
    }
    if (studentSubmitFile.size === 0) {
      alert('파일 내용이 없습니다. 내용이 있는 파일을 첨부해 주세요.')
      return
    }

    const selected = homeworkList.find((item) => item.id === activeStudentHomeworkId)
    if (!selected || selected.status === '마감') {
      alert('마감된 과제는 제출할 수 없습니다.')
      return
    }

    try {
      setStudentSubmitting(true)
      const vo = {
        homework_code: activeStudentHomeworkId,
      }
      if (selected.submissionCode) {
        vo.submission_code = selected.submissionCode
      }

      const formData = new FormData()
      formData.append('vo', new Blob([JSON.stringify(vo)], { type: 'application/json' }))
      formData.append('uploadFile', studentSubmitFile)

      const { data } = await api.post('/stu/submitSubmission.do', formData)
      if (String(data).toLowerCase().includes('success')) {
        alert('과제가 제출되었습니다.')
        const refreshed = await fetchHomeworkList()
        await fetchStudentResults()
        const refreshedItem = Array.isArray(refreshed)
          ? refreshed.find((row) => row.id === activeStudentHomeworkId)
          : null
        if (refreshedItem) {
          await openStudentSubmitPanel(refreshedItem)
        }
      } else {
        alert('제출에 실패했습니다. 다시 시도해 주세요.')
      }
    } catch {
      alert('제출에 실패했습니다. 다시 시도해 주세요.')
    } finally {
      setStudentSubmitting(false)
    }
  }

  if (isInstSubmissionPage) {
    return (
      <section className={styles.page}>
        <div className={styles.resultHeader}>제출된 과제 현황</div>
        <div className={styles.tableWrap}>
          <table className={styles.table}>
            <thead>
              <tr>
                <th>번호</th>
                <th>학생명</th>
                <th>과정/과제명</th>
                <th>제출일</th>
                <th>상태</th>
                <th>점수</th>
                <th>평가</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr>
                  <td colSpan={7} className={styles.emptyRow}>
                    제출된 과제 목록을 불러오는 중입니다.
                  </td>
                </tr>
              ) : error ? (
                <tr>
                  <td colSpan={7} className={styles.emptyRow}>
                    {error}
                  </td>
                </tr>
              ) : submissionList.length === 0 ? (
                <tr>
                  <td colSpan={7} className={styles.emptyRow}>
                    제출된 내역이 없습니다.
                  </td>
                </tr>
              ) : (
                submissionList.map((item, index) => (
                  <Fragment key={`${item.id}-${index}`}>
                    <tr>
                      <td>{index + 1}</td>
                      <td>{item.studentName}</td>
                      <td className={styles.courseHomeworkCell}>
                        <div>{item.courseHomework}</div>
                        <div className={styles.deadlineText}>
                          마감: {item.endDate ? String(item.endDate).slice(0, 10) : '-'}
                        </div>
                      </td>
                      <td>{item.submitDate}</td>
                      <td>{item.status}</td>
                      <td>{item.score}</td>
                      <td>
                        {isDeadlineClosed(item.endDate) ? (
                          <button
                            type="button"
                            className={styles.evalButton}
                            onClick={() => handleEvaluationClick(item)}
                          >
                            {item.hasEvaluation || evaluationEdited[item.id] ? '수정하기' : '부여하기'}
                          </button>
                        ) : (
                          <span className={styles.evalDisabled}>진행중</span>
                        )}
                      </td>
                    </tr>
                    {activeEvaluationId === item.id && (
                      <tr className={styles.evalRow}>
                        <td colSpan={7}>
                          <div className={styles.evalForm}>
                            <label className={styles.evalLabel}>
                              점수
                              <input
                                type="number"
                                name="score"
                                value={evaluationForm.score}
                                onChange={handleEvaluationField}
                                className={styles.evalInput}
                                min="0"
                                max="100"
                              />
                            </label>
                            <label className={styles.evalLabelWide}>
                              피드백
                              <input
                                type="text"
                                name="feedback"
                                value={evaluationForm.feedback}
                                onChange={handleEvaluationField}
                                className={styles.evalInput}
                                placeholder="피드백을 입력하세요"
                              />
                            </label>
                            <button type="button" className={styles.evalAction} onClick={() => saveEvaluation(item)}>
                              저장
                            </button>
                            <button type="button" className={styles.evalAction} onClick={cancelEvaluation}>
                              취소
                            </button>
                          </div>
                        </td>
                      </tr>
                    )}
                  </Fragment>
                ))
              )}
            </tbody>
          </table>
        </div>
      </section>
    )
  }

  if (isStuResultPage) {
    return (
      <section className={styles.page}>
        <div className={styles.resultHeader}>과제 결과</div>
        <div className={styles.tableWrap}>
          <table className={styles.table}>
            <thead>
              <tr>
                <th>번호</th>
                <th>과정/과제명</th>
                <th>제출일</th>
                <th>상태</th>
                <th>점수</th>
                <th>피드백</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr>
                  <td colSpan={6} className={styles.emptyRow}>
                    과제 결과를 불러오는 중입니다.
                  </td>
                </tr>
              ) : error ? (
                <tr>
                  <td colSpan={6} className={styles.emptyRow}>
                    {error}
                  </td>
                </tr>
              ) : studentResults.length === 0 ? (
                <tr>
                  <td colSpan={6} className={styles.emptyRow}>
                    제출 결과가 없습니다.
                  </td>
                </tr>
              ) : (
                studentResults.map((item, index) => (
                  <tr key={item.id}>
                    <td>{index + 1}</td>
                    <td className={styles.courseHomeworkCell}>{item.courseHomework}</td>
                    <td>{item.submitDate}</td>
                    <td>{item.status}</td>
                    <td>{item.score}</td>
                    <td>{item.feedback}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </section>
    )
  }

  if (isStuAssignmentsPage) {
    const activeRow = homeworkList.find((item) => item.id === activeStudentHomeworkId)
    return (
      <section className={styles.page}>
        <div className={styles.splitLayout}>
          <div className={styles.leftPane}>
            <div className={styles.searchBar}>
              <select
                className={styles.select}
                value={selectedCourse}
                onChange={(e) => setSelectedCourse(e.target.value)}
              >
                <option value="">과정명</option>
                {courseOptions.map((course) => (
                  <option key={course} value={course}>
                    {course}
                  </option>
                ))}
              </select>
              <input
                className={styles.input}
                type="text"
                value={keyword}
                onChange={(e) => setKeyword(e.target.value)}
                placeholder="과정명을 입력하세요"
              />
              <button type="button" className={styles.searchButton} onClick={handleSearch}>
                검색
              </button>
            </div>

            <div className={styles.tableWrap}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>번호</th>
                    <th>과제명</th>
                    <th>담당강사</th>
                    <th>마감일</th>
                    <th>진행상태</th>
                    <th>첨부파일</th>
                  </tr>
                </thead>
                <tbody>
                  {loading ? (
                    <tr>
                      <td colSpan={6} className={styles.emptyRow}>
                        과제 목록을 불러오는 중입니다.
                      </td>
                    </tr>
                  ) : error ? (
                    <tr>
                      <td colSpan={6} className={styles.emptyRow}>
                        {error}
                      </td>
                    </tr>
                  ) : pageItems.length === 0 ? (
                    <tr>
                      <td colSpan={6} className={styles.emptyRow}>
                        조회된 과제가 없습니다.
                      </td>
                    </tr>
                  ) : (
                    pageItems.map((item) => (
                      <tr
                        key={item.id}
                        className={`${item.status === '마감' ? styles.closedRow : ''} ${
                          activeStudentHomeworkId === item.id ? styles.activeRow : ''
                        }`}
                        onDoubleClick={() => openStudentSubmitPanel(item)}
                      >
                        <td>{item.id}</td>
                        <td>{item.courseName}</td>
                        <td>{item.instructor}</td>
                        <td>{item.dueDate}</td>
                        <td>
                          <span
                            className={`${styles.status} ${
                              item.status === '진행중'
                                ? styles.inProgress
                                : item.status === '진행 예정'
                                  ? styles.scheduled
                                  : styles.closed
                            }`}
                          >
                            {item.status}
                          </span>
                        </td>
                        <td className={styles.downloadCell}>
                          <button
                            type="button"
                            className={styles.downloadButton}
                            aria-label="과제 다운로드"
                            disabled={!item.downloadable}
                            onClick={() =>
                              window.open(`/homeworkfile/download.do?fileId=${item.fileId}`, '_blank')
                            }
                          >
                            <DownloadIcon disabled={!item.downloadable} />
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

            <div className={styles.pagination}>
              <span className={styles.itemInfo}>
                총 {filteredList.length}건 중 {startItem}-{endItem}건
              </span>
              <button
                type="button"
                className={styles.pageButton}
                onClick={() => setPage((prev) => Math.max(1, prev - 1))}
                disabled={currentPage === 1}
              >
                &lt;
              </button>
              <span className={styles.pageNumber}>
                {currentPage} / {totalPages}
              </span>
              <button
                type="button"
                className={styles.pageButton}
                onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
                disabled={currentPage === totalPages}
              >
                &gt;
              </button>
              <span className={styles.pageSize}>{pageSize}건/페이지</span>
            </div>
          </div>

          <aside className={styles.rightPane}>
            <div className={styles.panelHeader}>과제 제출</div>
            {!activeRow ? (
              <div className={styles.panelEmpty}>목록에서 과제를 더블클릭하면 제출 패널이 열립니다.</div>
            ) : studentDetailLoading ? (
              <div className={styles.panelEmpty}>상세 정보를 불러오는 중입니다.</div>
            ) : (
              <div className={styles.panelBody}>
                <div className={styles.panelField}>
                  <span className={styles.panelLabel}>과정/과제명</span>
                  <span className={styles.panelValue}>
                    {studentDetail?.course_name || '-'} / {studentDetail?.homework_title || activeRow.courseName}
                  </span>
                </div>
                <div className={styles.panelField}>
                  <span className={styles.panelLabel}>담당강사</span>
                  <span className={styles.panelValue}>{studentDetail?.teacher_name || activeRow.instructor}</span>
                </div>
                <div className={styles.panelField}>
                  <span className={styles.panelLabel}>제출기간</span>
                  <span className={styles.panelValue}>
                    {activeRow.startDate} ~ {activeRow.dueDate}
                  </span>
                </div>
                <div className={styles.panelField}>
                  <span className={styles.panelLabel}>과제 첨부파일</span>
                  <span className={styles.panelValue}>
                    {activeRow.fileId ? '다운로드 가능' : '첨부 없음'}
                  </span>
                </div>
                {activeRow.fileId && (
                  <button
                    type="button"
                    className={styles.panelDownloadButton}
                    onClick={() => window.open(`/homeworkfile/download.do?fileId=${activeRow.fileId}`, '_blank')}
                  >
                    과제 파일 다운로드
                  </button>
                )}
                <div className={styles.panelField}>
                  <span className={styles.panelLabel}>내 제출파일</span>
                  <span className={styles.panelValue}>
                    {studentSubmitFile?.name || studentDetail?.file_name || '미첨부'}
                  </span>
                </div>
                <label className={styles.fileAttach}>
                  제출 파일 첨부
                  <input
                    type="file"
                    className={styles.hiddenFileInput}
                    onChange={(e) => {
                      const file = e.target.files?.[0] || null
                      if (file && file.size === 0) {
                        alert('파일 내용이 없습니다. 내용이 있는 파일을 첨부해 주세요.')
                        e.target.value = ''
                        return
                      }
                      setStudentSubmitFile(file)
                    }}
                  />
                </label>
                <button
                  type="button"
                  className={styles.studentSubmitButton}
                  disabled={studentSubmitting || activeRow.status === '마감'}
                  onClick={submitStudentHomework}
                >
                  {activeRow.status === '마감'
                    ? '마감으로 제출 불가'
                    : studentSubmitting
                      ? '제출 중...'
                      : '제출하기'}
                </button>
              </div>
            )}
          </aside>
        </div>
      </section>
    )
  }

  return (
    <section className={styles.page}>
      <div className={styles.searchBar}>
        <select className={styles.select} value={selectedCourse} onChange={(e) => setSelectedCourse(e.target.value)}>
          <option value="">과정명</option>
          {courseOptions.map((course) => (
            <option key={course} value={course}>
              {course}
            </option>
          ))}
        </select>

        <input
          className={styles.input}
          type="text"
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
          placeholder="과정명을 입력하세요"
        />

        <button type="button" className={styles.searchButton} onClick={handleSearch}>
          검색
        </button>
        {isInstAssignmentsPage && (
          <button type="button" className={styles.registerButton} onClick={openRegisterForm}>
            과제등록
          </button>
        )}
      </div>

      <div className={styles.tableWrap}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>번호</th>
              <th>과제명</th>
              <th>담당강사</th>
              <th>시작일</th>
              <th>마감일</th>
              <th>진행상태</th>
              <th>첨부파일</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={7} className={styles.emptyRow}>
                  과제 목록을 불러오는 중입니다.
                </td>
              </tr>
            ) : error ? (
              <tr>
                <td colSpan={7} className={styles.emptyRow}>
                  {error}
                </td>
              </tr>
            ) : pageItems.length === 0 ? (
              <tr>
                <td colSpan={7} className={styles.emptyRow}>
                  조회된 과제가 없습니다.
                </td>
              </tr>
            ) : (
              pageItems.map((item) => (
                <tr key={item.id} className={item.status === '마감' ? styles.closedRow : ''}>
                  <td>{item.id}</td>
                  <td>{item.courseName}</td>
                  <td>{item.instructor}</td>
                  <td>{item.startDate}</td>
                  <td>{item.dueDate}</td>
                  <td>
                    <span
                      className={`${styles.status} ${
                        item.status === '진행중'
                          ? styles.inProgress
                          : item.status === '진행 예정'
                            ? styles.scheduled
                            : styles.closed
                      }`}
                    >
                      {item.status}
                    </span>
                  </td>
                  <td className={styles.downloadCell}>
                    <button
                      type="button"
                      className={styles.downloadButton}
                      aria-label="과제 다운로드"
                      disabled={!item.downloadable}
                      onClick={() => window.open(`/homeworkfile/download.do?fileId=${item.fileId}`, '_blank')}
                    >
                      <DownloadIcon disabled={!item.downloadable} />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <div className={styles.pagination}>
        <span className={styles.itemInfo}>
          총 {filteredList.length}건 중 {startItem}-{endItem}건
        </span>
        <button
          type="button"
          className={styles.pageButton}
          onClick={() => setPage((prev) => Math.max(1, prev - 1))}
          disabled={currentPage === 1}
        >
          &lt;
        </button>
        <span className={styles.pageNumber}>
          {currentPage} / {totalPages}
        </span>
        <button
          type="button"
          className={styles.pageButton}
          onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
          disabled={currentPage === totalPages}
        >
          &gt;
        </button>
        <span className={styles.pageSize}>{pageSize}건/페이지</span>
      </div>

      {isInstAssignmentsPage && showRegisterForm && (
        <section className={styles.registerPanel}>
          <div className={styles.registerHeader}>
            <h3 className={styles.registerTitle}>과제 등록</h3>
            <div className={styles.registerActions}>
              <button type="button" className={styles.actionButton} onClick={submitRegisterForm}>
                등록
              </button>
              <button type="button" className={styles.actionButton} onClick={closeRegisterForm}>
                취소
              </button>
            </div>
          </div>

          <table className={styles.registerTable}>
            <tbody>
              <tr>
                <th>과정명</th>
                <td>
                  <select
                    className={styles.formControl}
                    name="courseId"
                    value={registerForm.courseId}
                    onChange={handleRegisterField}
                  >
                    <option value="">과정을 선택하세요</option>
                    {instCourseList.map((course) => (
                      <option key={course.course_id} value={course.course_id}>
                        {course.title}
                      </option>
                    ))}
                  </select>
                </td>
                <th>강사명</th>
                <td>
                  <input className={styles.formControl} name="instructor" value={registerForm.instructor} readOnly />
                </td>
              </tr>
              <tr>
                <th>과제명</th>
                <td colSpan={3}>
                  <input
                    className={styles.formControl}
                    name="title"
                    value={registerForm.title}
                    onChange={handleRegisterField}
                    placeholder="과제명을 입력하세요"
                  />
                </td>
              </tr>
              <tr>
                <th>시작일</th>
                <td>
                  <input
                    className={styles.formControl}
                    type="date"
                    name="startDate"
                    value={registerForm.startDate}
                    onChange={handleRegisterField}
                  />
                </td>
                <th>마감일</th>
                <td>
                  <input
                    className={styles.formControl}
                    type="date"
                    name="endDate"
                    value={registerForm.endDate}
                    onChange={handleRegisterField}
                  />
                </td>
              </tr>
            </tbody>
          </table>

          <ul className={styles.noticeList}>
            <li>과제 제출은 목록에서 첨부파일 다운로드 후 작성하여 제출해 주세요.</li>
            <li>제출 기간 종료 후에는 수정이 불가합니다.</li>
            <li>제출 기간 내 미제출 시 0점 처리됩니다.</li>
          </ul>

          <div className={styles.fileRow}>
            <div className={styles.fileName}>{registerForm.file ? registerForm.file.name : '첨부된 파일이 없습니다.'}</div>
            {registerForm.file && (
              <button type="button" className={styles.fileClear} onClick={clearRegisterFile}>
                X
              </button>
            )}
            <label className={styles.fileAttach}>
              첨부하기
              <input type="file" className={styles.hiddenFileInput} onChange={handleRegisterFile} />
            </label>
          </div>
        </section>
      )}
    </section>
  )
}

export default HomeworkPage
