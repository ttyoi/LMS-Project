import React, { useState, useEffect, useCallback, useRef } from 'react';
import axios from '../../api/axios';

function ExamPage() {
  // --- [1] 목록 및 상태 관리 ---
  const [testList, setTestList] = useState([]);
  const [courses, setCourses] = useState([]);
  const [totalCount, setTotalCount] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedCourse, setSelectedCourse] = useState('all');
  const pageSize = 10;

  // --- [2] ERP형 선택 및 뷰 모드 ---
  const [selectedRow, setSelectedRow] = useState(null); // 클릭하여 선택된 행
  const [viewMode, setViewMode] = useState(null);      // 'exam', 'result', null

  // --- [3] 상세 데이터 및 기능 상태 ---
  const [examData, setExamData] = useState([]);        // 시험 문제
  const [answers, setAnswers] = useState({});          // 학생 답안
  const [resultData, setResultData] = useState(null);  // 결과 데이터
  const [remainingTime, setRemainingTime] = useState(2700); // 45분
  const [toast, setToast] = useState({ isVisible: false, message: '' });
  const timerRef = useRef(null);

  // --- 키보드 네비게이션 ---
  const rowRefs = useRef([]);
  const [keyboardIndex, setKeyboardIndex] = useState(0);

  useEffect(() => {
    setKeyboardIndex(0);
  }, [testList]);

  function handleListKeyDown(e, index) {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      const next = Math.min(index + 1, testList.length - 1);
      setKeyboardIndex(next);
      rowRefs.current[next]?.focus();
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      const prev = Math.max(index - 1, 0);
      setKeyboardIndex(prev);
      rowRefs.current[prev]?.focus();
    } else if (e.key === 'Enter') {
      e.preventDefault();
      setSelectedRow(testList[index]);
    }
  }

  // --- [4] 유틸리티: 토스트 알림 ---
  const showToast = (msg) => {
    setToast({ isVisible: true, message: msg });
    setTimeout(() => setToast({ isVisible: false, message: '' }), 3000);
  };

  // --- [5] API: 목록 로드 (.do 적용) ---
  const loadTestList = useCallback(() => {
    const sendCourse = selectedCourse === "all" ? "" : selectedCourse;
    axios.get('/stu/exams/list', {
      params: { course: sendCourse, currentPage: currentPage, pageSize: pageSize }
    })
    .then(res => {
      setTestList(res.data.list || []);
      setTotalCount(res.data.totalCount || 0);
      setSelectedRow(null); 
    })
    .catch(err => { if (err.message !== 'SESSION_EXPIRED') console.error("목록 로드 실패", err); });
  }, [currentPage, selectedCourse]);

  useEffect(() => {
    axios.get('/stu/exams/courses').then(res => setCourses(res.data || []));
    loadTestList();
  }, [loadTestList]);

  // --- [6] 기능: 시험 응시 시작 ---
  const handleExamBtn = () => {
    if (!selectedRow) return;
    const { courseId, period } = selectedRow;
    
    axios.get('/stu/exams/check', { params: { courseId, period } })
      .then(res => {
        if (res.data.available) {
          axios.get(`/stu/exams/test/${courseId}/${period}`)
            .then(res => {
              setExamData(res.data.list || []);
              setAnswers({});
              setRemainingTime(2700);
              setViewMode('exam');
            });
        } else {
          showToast(res.data.message || "현재는 응시 가능한 시간이 아닙니다!");
        }
      })
      .catch(() => showToast("서버 통신 중 오류가 발생했습니다."));
  };

  // --- [7] 기능: 결과 데이터 로드 ---
  const handleResultBtn = () => {
    if (!selectedRow) return;
    const { courseId, period } = selectedRow;
    axios.get(`/stu/exams/result/${courseId}/${period}/data`)
      .then(res => {
        setResultData(res.data);
        setViewMode('result');
      })
      .catch(() => showToast("결과 데이터를 불러오는데 실패했습니다."));
  };

  // --- [8] 기능: 시험 제출 ---
  // --- [8] 기능: 시험 제출 (수정본) ---
 const submitExam = (isAuto = false) => {
    if (!isAuto && !window.confirm("정말로 제출하시겠습니까?")) return;

    // 선택하지 않은 항목은 제외 — null을 INSERT하면 DB NOT NULL 오류 발생
    // 미선택 항목은 결과 조회 시 LEFT JOIN으로 자동 0점 처리됨
    const answerList = examData
      .filter(q => answers[q.questionNo] != null)
      .map(q => ({
        questionNo: q.questionNo,
        studentAnswer: answers[q.questionNo]
      }));

    const payload = {
      loginId: "",
      courseId: selectedRow.courseId,
      period: selectedRow.period,
      answers: answerList
    };

    // 💡 아래 headers 부분을 추가하세요!
    axios.post('/stu/exams/submit', payload, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(res => {
      if (res.data.result === "OK" || res.data.success === true) {
        showToast("시험이 성공적으로 제출되었습니다.");
        setViewMode(null);
        loadTestList(); 
      } else {
        showToast("제출 중 오류가 발생했습니다.");
      }
    })
    .catch(err => {
      console.error("제출 에러:", err);
      showToast("서버 통신 중 오류가 발생했습니다.");
    });
  };

  // --- [9] 타이머 로직 ---
  useEffect(() => {
    if (viewMode === 'exam' && remainingTime > 0) {
      timerRef.current = setInterval(() => setRemainingTime(prev => prev - 1), 1000);
    } else if (remainingTime <= 0 && viewMode === 'exam') {
      clearInterval(timerRef.current);
      submitExam(true);
    }
    return () => clearInterval(timerRef.current);
  }, [viewMode, remainingTime]);

  const formatTime = (sec) => {
    const mm = String(Math.floor(sec / 60)).padStart(2, "0");
    const ss = String(sec % 60).padStart(2, "0");
    return `${mm}:${ss}`;
  };

  return (
    <div style={{ padding: '20px', display: 'flex', gap: '20px', minHeight: '85vh', overflow: 'hidden' }}>
      <style>{`
        @keyframes slideInRight {
          from { opacity: 0; transform: translateX(40px); }
          to   { opacity: 1; transform: translateX(0); }
        }
      `}</style>

      {/* --- 왼쪽: 목록 영역 --- */}
      <div style={{ flex: 1, minWidth: 0, transition: 'flex 0.3s ease' }}>
        <h2 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '15px' }}>학습 관리 {'>'} 시험 목록</h2>
        
        {/* 상단 버튼 바 (ERP 스타일) */}
        <div style={controlBarStyle}>
          <select 
            value={selectedCourse} 
            onChange={(e) => { setSelectedCourse(e.target.value); setCurrentPage(1); }}
            style={{ padding: '5px 10px', border: '1px solid #94a3b8' }}
          >
            <option value="all">과정 전체</option>
            {courses.map((c, i) => <option key={i} value={c.course_id}>{c.title}</option>)}
          </select>

          <div style={{ display: 'flex', gap: '5px' }}>
            <button
              disabled={!selectedRow || selectedRow.score !== null}
              onClick={handleExamBtn}
              style={selectedRow && selectedRow.score === null ? activeBtnStyle : disabledBtnStyle}
            >
              시험응시
            </button>
            <button 
              disabled={!selectedRow || selectedRow.score === null}
              onClick={handleResultBtn}
              style={selectedRow && selectedRow.score !== null ? activeBtnStyle : disabledBtnStyle}
            >
              결과확인
            </button>
          </div>
        </div>

        {/* 그리드 테이블 */}
        <table style={tableStyle}>
          <thead>
            <tr style={{ backgroundColor: '#e2e8f0' }}>
              <th style={thStyle}>상태</th>
              <th style={thStyle}>시험명</th>
              <th style={thStyle}>차시</th>
              <th style={thStyle}>응시 기간</th>
              <th style={thStyle}>점수</th>
            </tr>
          </thead>
          <tbody>
            {testList.map((t, i) => {
              const isSelected = selectedRow && selectedRow.courseId === t.courseId && selectedRow.period === t.period;
              const notStarted = t.startDate && new Date(t.startDate) > new Date();
              const getStatus = () => {
                if (notStarted) return <span style={{ color: '#f59e0b' }}>응시불가</span>;
                if (t.score === null) return '미응시';
                if (t.score === 0 && t.date === null) return <span style={{ color: '#ff4d4f' }}>기간만료</span>;
                return '완료';
              };
              return (
                <tr
                  key={i}
                  ref={(el) => { rowRefs.current[i] = el; }}
                  tabIndex={keyboardIndex === i ? 0 : -1}
                  onClick={() => { setKeyboardIndex(i); setSelectedRow(t); rowRefs.current[i]?.focus(); }}
                  onKeyDown={(e) => handleListKeyDown(e, i)}
                  onFocus={(e) => { setKeyboardIndex(i); e.currentTarget.style.boxShadow = 'inset 0 0 0 2px #4a90e2'; }}
                  onBlur={(e) => { e.currentTarget.style.boxShadow = 'none'; }}
                  style={{ cursor: 'pointer', backgroundColor: isSelected ? '#fff9c4' : '#fff', borderBottom: '1px solid #eee', outline: 'none' }}
                >
                  <td style={tdStyle}>{getStatus()}</td>
                  <td style={{ ...tdStyle, textAlign: 'left', paddingLeft: '15px' }}>{t.title}</td>
                  <td style={tdStyle}>{t.period}</td>
                  <td style={tdStyle}>
                    {t.startDate || t.endDate
                      ? `${t.startDate ?? '?'} ~ ${t.endDate ?? '?'}`
                      : '-'}
                  </td>
                  <td style={tdStyle}>{t.score ?? '-'}</td>
                </tr>
              );
            })}
          </tbody>
        </table>

        {/* 페이지네이션 */}
        {Math.ceil(totalCount / pageSize) > 0 && (
          <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '4px', marginTop: '12px' }}>
            <button
              onClick={() => setCurrentPage(p => Math.max(p - 1, 1))}
              disabled={currentPage === 1}
              style={pageNavBtnStyle(currentPage === 1)}
            >
              이전
            </button>
            {(() => {
              const totalPage = Math.ceil(totalCount / pageSize);
              const DISPLAY = 5;
              const half = Math.floor(DISPLAY / 2);
              let start = Math.max(1, currentPage - half);
              let end = Math.min(totalPage, start + DISPLAY - 1);
              if (end - start + 1 < DISPLAY) start = Math.max(1, end - DISPLAY + 1);
              return Array.from({ length: end - start + 1 }, (_, i) => start + i).map(n => (
                <button
                  key={n}
                  onClick={() => setCurrentPage(n)}
                  style={pageNumBtnStyle(n === currentPage)}
                >
                  {n}
                </button>
              ));
            })()}
            <button
              onClick={() => setCurrentPage(p => Math.min(p + 1, Math.ceil(totalCount / pageSize)))}
              disabled={currentPage === Math.ceil(totalCount / pageSize)}
              style={pageNavBtnStyle(currentPage === Math.ceil(totalCount / pageSize))}
            >
              다음
            </button>
          </div>
        )}
      </div>

      {/* --- 오른쪽: 상세 영역 (고정 헤더 2분할) --- */}
      {viewMode && (
        <div style={{ ...rightPanelStyle, animation: 'slideInRight 0.25s ease' }}>
          
          {/* [고정 헤더] 스크롤 고정 영역 */}
          <div style={stickyHeaderStyle}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
              <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 'bold' }}>
                {viewMode === 'exam' ? `시험 응시 [${formatTime(remainingTime)}]` : '📊 결과 상세'}
              </h3>
            </div>
            
            <div style={{ display: 'flex', gap: '8px' }}>
              {viewMode === 'exam' && (
                <button onClick={() => submitExam(false)} style={submitBtnStyle}>제출하기</button>
              )}
              <button onClick={() => setViewMode(null)} style={closeBtnStyle}>✕ 닫기</button>
            </div>
          </div>

          {/* [스크롤 본문] 문제 및 결과 노출 영역 */}
          <div style={{ padding: '20px', overflowY: 'auto', flex: 1 }}>
            {viewMode === 'exam' ? (
              examData.map((q, idx) => (
                <div key={idx} style={questionBoxStyle}>
                  <p><strong>{q.questionNo}.</strong> {q.content}</p>
                  {[1, 2, 3, 4].map(n => (
                    <div 
                      key={n} 
                      onClick={() => setAnswers({...answers, [q.questionNo]: n})}
                      style={{ 
                        padding: '10px', margin: '5px 0', border: '1px solid #eee', cursor: 'pointer', borderRadius: '4px',
                        backgroundColor: answers[q.questionNo] === n ? '#e6f0ff' : '#fff',
                        borderColor: answers[q.questionNo] === n ? '#3a7df5' : '#eee'
                      }}
                    >
                      {n}. {q[`option${n}`]}
                    </div>
                  ))}
                </div>
              ))
            ) : (
              <div>
                <div style={{ background: '#f8f9fa', padding: '15px', borderRadius: '5px', marginBottom: '20px' }}>
                    <p><strong>시험:</strong> {resultData?.title}</p>
                    <p><strong>최종 점수:</strong> <span style={{ color: '#ff4d4f', fontSize: '18px', fontWeight: 'bold' }}>{resultData?.totalScore}점</span></p>
                </div>
                {resultData?.questions.map((q, idx) => (
                  <div key={idx} style={{ marginBottom: '20px', paddingBottom: '10px', borderBottom: '1px dashed #ddd' }}>
                    <p><strong>Q{q.questionNo}.</strong> {q.content}</p>
                    <p style={{ fontSize: '12px', color: q.studentAnswer === q.correctAnswer ? '#3a7df5' : '#ff4d4f' }}>
                      선택: {q.studentAnswer} / 정답: {q.correctAnswer}
                    </p>
                    <div style={{ marginTop: '5px', padding: '8px', background: '#fffbe6', fontSize: '12px' }}>
                        💡 해설: {q.comment || '해설 없음'}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      )}

      {/* --- 하단 빨간 알림 (Toast) --- */}
      {toast.isVisible && (
        <div style={toastStyle}>{toast.message}</div>
      )}
    </div>
  );
}

// --- CSS 스타일 정의 ---
const controlBarStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px', backgroundColor: '#f1f5f9', border: '1px solid #cbd5e1', marginBottom: '10px' };
const tableStyle = { width: '100%', borderCollapse: 'collapse', border: '1px solid #ddd', backgroundColor: '#fff' };
const thStyle = { padding: '10px', border: '1px solid #cbd5e1', fontSize: '13px', textAlign: 'center' };
const tdStyle = { padding: '10px', border: '1px solid #eee', fontSize: '13px', textAlign: 'center' };
const activeBtnStyle = { padding: '6px 12px', background: '#334155', color: '#fff', border: 'none', cursor: 'pointer', fontSize: '13px' };
const disabledBtnStyle = { padding: '6px 12px', background: '#e2e8f0', color: '#94a3b8', border: 'none', cursor: 'not-allowed', fontSize: '13px' };

const rightPanelStyle = { flex: 1, border: '1px solid #334155', backgroundColor: '#fff', display: 'flex', flexDirection: 'column', height: '85vh', overflow: 'hidden' };
const stickyHeaderStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 20px', backgroundColor: '#f8fafc', borderBottom: '1px solid #cbd5e1', zIndex: 10 };
const submitBtnStyle = { padding: '6px 16px', backgroundColor: '#3a7df5', color: '#fff', border: 'none', borderRadius: '3px', cursor: 'pointer', fontWeight: 'bold', fontSize: '13px' };
const closeBtnStyle = { padding: '6px 12px', backgroundColor: '#fff', color: '#334155', border: '1px solid #cbd5e1', borderRadius: '3px', cursor: 'pointer', fontSize: '13px' };
const questionBoxStyle = { marginBottom: '20px', padding: '15px', border: '1px solid #f1f5f9', borderRadius: '8px' };
const toastStyle = { position: 'fixed', bottom: '20px', left: '50%', transform: 'translateX(-50%)', backgroundColor: '#334155', color: '#fff', padding: '12px 30px', borderRadius: '4px', fontWeight: 'bold', zIndex: 9999, boxShadow: '0 4px 12px rgba(0,0,0,0.2)', fontSize: '14px' };
const pageNavBtnStyle = (disabled) => ({ padding: '5px 10px', fontSize: '13px', border: '1px solid #cbd5e1', borderRadius: '3px', backgroundColor: disabled ? '#f1f5f9' : '#fff', color: disabled ? '#94a3b8' : '#334155', cursor: disabled ? 'not-allowed' : 'pointer' });
const pageNumBtnStyle = (active) => ({ padding: '5px 10px', fontSize: '13px', border: '1px solid #cbd5e1', borderRadius: '3px', backgroundColor: active ? '#334155' : '#fff', color: active ? '#fff' : '#334155', fontWeight: active ? 'bold' : 'normal', cursor: 'pointer' });

export default ExamPage;