import { useState, useEffect, useCallback, useRef } from 'react';
import api from '../../api/axios';
import styles from './InsExamPage.module.css';

const PAGE_SIZE = 10;

function InstructorExamPage() {
  const [examList, setExamList] = useState([]);
  const [courseList, setCourseList] = useState([]);
  const [selectedCourseId, setSelectedCourseId] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalCount, setTotalCount] = useState(0);
  const [selectedRow, setSelectedRow] = useState(null);
  const [examDetail, setExamDetail] = useState(null);
  const [toast, setToast] = useState({ isVisible: false, message: '' });

  // --- 키보드 네비게이션 ---
  const tableWrapperRef = useRef(null);
  const [keyboardIndex, setKeyboardIndex] = useState(0);
  const [isTableFocused, setIsTableFocused] = useState(false);

  useEffect(() => {
    setKeyboardIndex(0);
  }, [examList]);

  const showToast = (msg) => {
    setToast({ isVisible: true, message: msg });
    setTimeout(() => setToast({ isVisible: false, message: '' }), 3000);
  };

  const loadList = useCallback(() => {
    api.get('/inst/exams/list', {
      params: {
        course: selectedCourseId || '',
        currentPage,
        pageSize: PAGE_SIZE,
      },
    })
      .then((res) => {
        setExamList(res.data.list ?? []);
        setTotalCount(res.data.totalCount ?? 0);
      })
      .catch((err) => { if (err.message !== 'SESSION_EXPIRED') console.error(err); });
  }, [currentPage, selectedCourseId]);

  useEffect(() => {
    api.get('/inst/exams/courses')
      .then((res) => setCourseList(Array.isArray(res.data) ? res.data : []))
      .catch((err) => { if (err.message !== 'SESSION_EXPIRED') console.error(err); });
  }, []);

  useEffect(() => {
    loadList();
  }, [loadList]);

  const totalPage = Math.ceil(totalCount / PAGE_SIZE);

  const handleReset = () => {
    setSelectedCourseId('');
    setCurrentPage(1);
    setSelectedRow(null);
    setExamDetail(null);
  };

  const handleRowClick = (exam) => {
    if (isSelected(exam)) {
      setSelectedRow(null);
      setExamDetail(null);
      return;
    }
    setSelectedRow(exam);
    api.get(`/inst/exams/detail-info/${exam.courseId}/${exam.period}`)
      .then((res) => setExamDetail(res.data))
      .catch((err) => { if (err.message !== 'SESSION_EXPIRED') console.error(err); });
  };

  const handleDelete = () => {
    if (!selectedRow) return;
    if (!window.confirm(`"${selectedRow.title}" (${selectedRow.period}차시) 시험을 삭제하시겠습니까?\n학생 응시 기록도 함께 삭제됩니다.`)) return;

    api.delete(`/inst/exams/${selectedRow.courseId}/${selectedRow.period}`)
      .then((res) => {
        if (res.data.success) {
          setSelectedRow(null);
          setExamDetail(null);
          loadList();
          showToast('시험이 삭제되었습니다.');
        } else {
          showToast('삭제 실패: ' + res.data.message);
        }
      })
      .catch((err) => { if (err.message !== 'SESSION_EXPIRED') showToast('삭제 중 오류가 발생했습니다.'); });
  };

  const isSelected = (exam) =>
    selectedRow && selectedRow.courseId === exam.courseId && selectedRow.period === exam.period;

  function handleTableKeyDown(e) {
    if (!examList.length) return;
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setKeyboardIndex(prev => Math.min(prev + 1, examList.length - 1));
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setKeyboardIndex(prev => Math.max(prev - 1, 0));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (examList[keyboardIndex]) handleRowClick(examList[keyboardIndex]);
    }
  }

  return (
    <section className={styles.section} style={{ display: 'flex', gap: '20px', alignItems: 'flex-start' }}>

      {/* 왼쪽: 목록 영역 */}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className={styles.headerRow}>
          <h3 className={styles.title}>시험 목록</h3>
        </div>

        <div className={styles.filterCard}>
          <div className={styles.searchRow}>
            <select
              className={styles.searchInput}
              value={selectedCourseId}
              onChange={(e) => { setSelectedCourseId(e.target.value); setCurrentPage(1); setSelectedRow(null); setExamDetail(null); }}
            >
              <option value="">전체 강의</option>
              {courseList.map((c) => (
                <option key={c.course_id} value={String(c.course_id)}>{c.title}</option>
              ))}
            </select>
            <button className={styles.resetBtn} onClick={handleReset}>↻</button>
            <button
              onClick={handleDelete}
              disabled={!selectedRow}
              style={{
                marginLeft: '8px',
                padding: '6px 14px',
                backgroundColor: selectedRow ? '#ef4444' : '#e2e8f0',
                color: selectedRow ? '#fff' : '#94a3b8',
                border: 'none',
                borderRadius: '4px',
                cursor: selectedRow ? 'pointer' : 'not-allowed',
                fontSize: '13px',
                fontWeight: 'bold',
              }}
            >
              삭제
            </button>
          </div>
        </div>

        <div
          ref={tableWrapperRef}
          tabIndex={0}
          onKeyDown={handleTableKeyDown}
          onFocus={() => setIsTableFocused(true)}
          onBlur={(e) => { if (!e.relatedTarget || !e.currentTarget.contains(e.relatedTarget)) setIsTableFocused(false); }}
          style={{ outline: 'none' }}
          className={styles.tableWrap}
        >
          <table className={styles.table}>
            <thead>
              <tr>
                <th>강의명</th>
                <th>차시</th>
                <th>시험명</th>
                <th>응시 기간</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
              {examList.length === 0 ? (
                <tr>
                  <td colSpan="5" className={styles.empty}>등록된 시험이 없습니다.</td>
                </tr>
              ) : (
                examList.map((exam, idx) => (
                  <tr
                    key={idx}
                    onClick={() => { setKeyboardIndex(idx); handleRowClick(exam); setTimeout(() => tableWrapperRef.current?.focus(), 0); }}
                    style={{
                      cursor: 'pointer',
                      backgroundColor: isSelected(exam) ? '#fff9c4' : '',
                      boxShadow: isTableFocused && keyboardIndex === idx ? 'inset 0 0 0 2px #4a90e2' : 'none',
                    }}
                  >
                    <td>{exam.courseName}</td>
                    <td>{exam.period}차시</td>
                    <td>{exam.title}</td>
                    <td>
                      {exam.startDate || exam.endDate
                        ? `${exam.startDate ?? '?'} ~ ${exam.endDate ?? '?'}`
                        : '-'}
                    </td>
                    <td className={Number(exam.status) === 1 ? styles.statusOpen : styles.statusClosed}>
                      {Number(exam.status) === 1 ? '열림' : '닫힘'}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>

          {totalPage > 0 && (
            <div className={styles.pagination}>
              <button
                className={styles.pageButton}
                onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
                disabled={currentPage === 1}
              >
                이전
              </button>
              {(() => {
                const DISPLAY = 5;
                const half = Math.floor(DISPLAY / 2);
                let start = Math.max(1, currentPage - half);
                let end = Math.min(totalPage, start + DISPLAY - 1);
                if (end - start + 1 < DISPLAY) start = Math.max(1, end - DISPLAY + 1);
                return Array.from({ length: end - start + 1 }, (_, i) => start + i).map((n) => (
                  <button
                    key={n}
                    className={styles.pageButton}
                    onClick={() => setCurrentPage(n)}
                    style={{
                      fontWeight: n === currentPage ? 'bold' : 'normal',
                      backgroundColor: n === currentPage ? '#334155' : '',
                      color: n === currentPage ? '#fff' : '',
                    }}
                  >
                    {n}
                  </button>
                ));
              })()}
              <button
                className={styles.pageButton}
                onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPage))}
                disabled={currentPage === totalPage}
              >
                다음
              </button>
            </div>
          )}
        </div>
      </div>

      {/* 오른쪽: 문제 상세 패널 */}
      <style>{`
        @keyframes slideInRight {
          from { opacity: 0; transform: translateX(40px); }
          to   { opacity: 1; transform: translateX(0); }
        }
      `}</style>
      {examDetail && (
        <div style={{
          flex: 1,
          minWidth: 0,
          border: '1px solid #334155',
          animation: 'slideInRight 0.25s ease',
          backgroundColor: '#fff',
          display: 'flex',
          flexDirection: 'column',
          height: '85vh',
          overflow: 'hidden',
        }}>
          {/* 고정 헤더 */}
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            padding: '12px 20px',
            backgroundColor: '#f8fafc',
            borderBottom: '1px solid #cbd5e1',
          }}>
            <h3 style={{ margin: 0, fontSize: '15px', fontWeight: 'bold' }}>
              📋 {examDetail.title}
            </h3>
            <button
              onClick={() => { setSelectedRow(null); setExamDetail(null); }}
              style={{
                padding: '5px 12px',
                backgroundColor: '#fff',
                color: '#334155',
                border: '1px solid #cbd5e1',
                borderRadius: '3px',
                cursor: 'pointer',
                fontSize: '13px',
              }}
            >
              ✕ 닫기
            </button>
          </div>

          {/* 스크롤 문제 목록 */}
          <div style={{ padding: '16px', overflowY: 'auto', flex: 1 }}>
            {(examDetail.questions ?? []).map((q, idx) => (
              <div
                key={idx}
                style={{
                  marginBottom: '20px',
                  padding: '14px',
                  border: '1px solid #e2e8f0',
                  borderRadius: '6px',
                }}
              >
                <p style={{ fontWeight: 'bold', marginBottom: '8px', fontSize: '13px' }}>
                  Q{q.questionNo}. {q.content}
                  <span style={{ float: 'right', color: '#64748b', fontWeight: 'normal' }}>{q.score}점</span>
                </p>
                {[1, 2, 3, 4].map((n) => (
                  <div
                    key={n}
                    style={{
                      padding: '7px 10px',
                      margin: '4px 0',
                      borderRadius: '4px',
                      fontSize: '13px',
                      backgroundColor: q.correctAnswer === n ? '#d1fae5' : '#f8fafc',
                      color: q.correctAnswer === n ? '#065f46' : '#334155',
                      fontWeight: q.correctAnswer === n ? 'bold' : 'normal',
                      border: `1px solid ${q.correctAnswer === n ? '#6ee7b7' : '#e2e8f0'}`,
                    }}
                  >
                    {n}. {q[`option${n}`]}{q.correctAnswer === n ? ' ✓' : ''}
                  </div>
                ))}
                <div style={{
                  marginTop: '8px',
                  padding: '8px 10px',
                  background: '#fffbe6',
                  fontSize: '12px',
                  borderRadius: '4px',
                  color: '#78350f',
                }}>
                  💡 해설: {q.comment || '해설 없음'}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
      {toast.isVisible && (
        <div style={{
          position: 'fixed', bottom: '20px', left: '50%', transform: 'translateX(-50%)',
          backgroundColor: '#334155', color: '#fff', padding: '12px 30px',
          borderRadius: '4px', fontWeight: 'bold', zIndex: 9999,
          boxShadow: '0 4px 12px rgba(0,0,0,0.2)', fontSize: '14px',
        }}>
          {toast.message}
        </div>
      )}
    </section>
  );
}

export default InstructorExamPage;
