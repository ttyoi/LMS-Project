import { useState, useRef, useEffect } from 'react';

import api from '../../api/axios';
import * as XLSX from 'xlsx';


const handleSampleDownload = () => {
  const wb = XLSX.utils.book_new();

  const sheetData = [
    ['차시', 1, '시험명', 'React 기초 1차 시험'],
    ['번호', '지문', '보기1', '보기2', '보기3', '보기4', '정답', '배점', '해설'],
    [1, 'React에서 상태를 관리하는 훅은?', 'useEffect', 'useState', 'useRef', 'useContext', 2, 10, 'useState는 컴포넌트 상태를 관리합니다.'],
    [2, 'Virtual DOM의 주요 장점은?', '메모리 절약', '보안 강화', '렌더링 성능 최적화', '서버 부하 감소', 3, 10, 'Virtual DOM은 실제 DOM 조작을 최소화합니다.'],
    [3, 'JSX란 무엇인가?', 'JavaScript 라이브러리', 'CSS 전처리기', 'JavaScript XML 문법 확장', 'HTTP 통신 방식', 3, 10, 'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'],
    [4, 'React 컴포넌트 간 데이터 전달 방식은?', 'state', 'props', 'context', 'ref', 2, 10, '부모에서 자식으로 props를 통해 데이터를 전달합니다.'],
    [5, 'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?', '매 렌더링마다', '마운트 시 1회', '언마운트 시', '상태 변경 시마다', 2, 10, '빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'],
    [6, 'React에서 key prop이 필요한 이유는?', '스타일 적용', '리스트 항목 고유 식별', '이벤트 처리', '상태 초기화', 2, 10, 'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'],
    [7, '함수형 컴포넌트에서 ref를 사용하는 훅은?', 'useState', 'useEffect', 'useRef', 'useMemo', 3, 10, 'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'],
    [8, 'React에서 Context API의 주요 용도는?', '서버 통신', '전역 상태 공유', '라우팅 처리', '스타일 관리', 2, 10, 'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'],
    [9, 'useMemo 훅의 목적은?', '사이드 이펙트 처리', 'DOM 접근', '값 메모이제이션으로 성능 최적화', '상태 관리', 3, 10, 'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'],
    [10, 'React에서 조건부 렌더링에 주로 사용하는 연산자는?', '||', '&&', '??', '!', 2, 10, '&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'],
  ];

  const ws = XLSX.utils.aoa_to_sheet(sheetData);
  ws['!cols'] = [
    { wch: 10 }, { wch: 40 }, { wch: 15 }, { wch: 15 },
    { wch: 15 }, { wch: 15 }, { wch: 6 }, { wch: 6 }, { wch: 30 },
  ];
  XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
  XLSX.writeFile(wb, '시험등록_샘플양식.xlsx');
};

function ExamRegistrationPage() {
  const fileInputRef = useRef(null);
  const [courseList, setCourseList] = useState([]);
  const [selectedCourseId, setSelectedCourseId] = useState('');
  const [selectedFile, setSelectedFile] = useState(null);
  const [fileName, setFileName] = useState('선택된 파일 없음');
  const [examData, setExamData] = useState([]);
  const [examMeta, setExamMeta] = useState({ period: '-', title: '-' });
  const [isProcessing, setIsProcessing] = useState(false);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [toast, setToast] = useState({ isVisible: false, message: '' });

  const showToast = (msg) => {
    setToast({ isVisible: true, message: msg });
    setTimeout(() => setToast({ isVisible: false, message: '' }), 3000);
  };

  useEffect(() => {
    api.get('/inst/getcourselist.do')
      .then((res) => {
        const list = Array.isArray(res.data) ? res.data : (res.data.list ?? []);
        setCourseList(list);
        if (list.length > 0) setSelectedCourseId(list[0].course_id);
      })
      .catch((err) => console.error(err));
  }, []);

  // 파일 선택
  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(file);
      setFileName(file.name);
    }
  };

  // 미리보기 (이미지 양식 기준)
const handlePreview = () => {
    if (!selectedFile) {
      showToast("파일을 먼저 선택해주세요.");
      return;
    }
    const reader = new FileReader();
    reader.onload = (e) => {
      const data = new Uint8Array(e.target.result);
      const workbook = XLSX.read(data, { type: 'array' });
      const worksheet = workbook.Sheets[workbook.SheetNames[0]];
      const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

      if (jsonData.length >= 2) {
        // Row 0: [차시, 값, 시험명, 값]
        const metaRow = jsonData[0] || [];

        setExamMeta({
          period: Number(metaRow[1]) || 0,
          title: metaRow[3] || '-',
        });

        // Row 1: 문항 헤더, Row 2~: 문항 데이터
        const questions = jsonData.slice(2)
          .filter(row => row.length > 0 && row[1])
          .map((row) => ({
            questionNo: Number(row[0]),
            content: row[1],
            option1: row[2],
            option2: row[3],
            option3: row[4],
            option4: row[5],
            answer: Number(row[6]),
            score: Number(row[7]),
            comment: row[8]
          }));
        setExamData(questions);
      }
    };
    reader.readAsArrayBuffer(selectedFile);
  };


const handleSubmit = () => {
    if (examData.length === 0) {
      showToast("등록할 시험 데이터가 없습니다.");
      return;
    }
    if (!window.confirm("이 데이터로 시험 문제를 등록하시겠습니까?")) return;

    if (!selectedCourseId) {
      showToast("강의를 선택해주세요.");
      return;
    }

    if (!startDate || !endDate) {
      showToast("응시 기간(시작일, 종료일)을 모두 입력해주세요.");
      return;
    }

    if (startDate > endDate) {
      showToast("종료일은 시작일보다 이후여야 합니다.");
      return;
    }

    setIsProcessing(true);

    const payload = {
        courseId: Number(selectedCourseId),
        period: Number(examMeta.period),
        title: examMeta.title,
        questions: examData,
        status: 1,
        startDate: startDate || null,
        endDate: endDate || null,
    };

    api.post('/inst/exam-register.do', payload, {
      headers: { 'Content-Type': 'application/json' },
    })
      .then((res) => {
        if(res.data.success) {
            showToast("성공적으로 등록되었습니다.");
            handleCancel();
        } else {
            showToast("등록 실패: " + (res.data.message || '알 수 없는 오류'));
        }
      })
      .catch((err) => {
        console.error(err);
        showToast("등록 중 시스템 오류 발생");
      })
      .finally(() => setIsProcessing(false));
  };

  const handleCancel = () => {
    setExamData([]);
    setExamMeta({ period: '-', title: '-' });
    setFileName('선택된 파일 없음');
    setSelectedFile(null);
    setStartDate('');
    setEndDate('');
    if (fileInputRef.current) fileInputRef.current.value = '';
    if (courseList.length > 0) setSelectedCourseId(courseList[0].course_id);
  };

  return (
    <div style={{ padding: '20px', backgroundColor: '#fff', minHeight: '85vh' }}>
      <h2 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '10px' }}>나의 강의 관리 {'>'} 시험 문제 등록</h2>
      
      <div style={sectionStyle}>
        {/* 강의 선택 */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '15px' }}>
          <label style={{ fontSize: '13px', fontWeight: 'bold', color: '#334155', whiteSpace: 'nowrap' }}>강의 선택 <span style={{ color: '#ef4444' }}>*</span></label>
          <select
            value={selectedCourseId}
            onChange={(e) => setSelectedCourseId(e.target.value)}
            style={{ padding: '6px 10px', border: '1px solid #94a3b8', fontSize: '13px', minWidth: '250px' }}
          >
            {courseList.length === 0
              ? <option value="">강의 없음</option>
              : courseList.map((c) => (
                  <option key={c.course_id} value={c.course_id}>{c.title}</option>
                ))
            }
          </select>
        </div>

        {/* 응시 기간 */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '15px' }}>
          <label style={{ fontSize: '13px', fontWeight: 'bold', color: '#334155', whiteSpace: 'nowrap' }}>응시 기간 <span style={{ color: '#ef4444' }}>*</span></label>
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            style={{ padding: '6px 10px', border: '1px solid #94a3b8', fontSize: '13px' }}
          />
          <span style={{ fontSize: '13px', color: '#64748b' }}>~</span>
          <input
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            style={{ padding: '6px 10px', border: '1px solid #94a3b8', fontSize: '13px' }}
          />
          <span style={{ fontSize: '12px', color: '#ef4444' }}>필수 입력</span>
        </div>

        {/* 파일 첨부 라인 */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '20px' }}>
          <label htmlFor="excelFile" style={btnStyle}>파일 첨부하기</label>
          <input ref={fileInputRef} type="file" id="excelFile" accept=".xls,.xlsx" onChange={handleFileChange} hidden />
          <span style={{ fontSize: '14px', color: '#666', minWidth: '150px' }}>{fileName}</span>
          
          <button onClick={handleSampleDownload} style={{ ...btnStyle, backgroundColor: '#64748b', color: '#fff', border: 'none' }}>샘플양식 다운로드</button>
        </div>

        {/* 버튼 그룹 + 시험 정보 (한 줄 배치) */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
          <div style={{ display: 'flex', gap: '8px' }}>
            <button onClick={handlePreview} style={previewBtnStyle}>미리보기</button>
            
            <button 
              onClick={handleSubmit} 
              disabled={examData.length === 0 || isProcessing}
              style={examData.length > 0 ? { ...previewBtnStyle, backgroundColor: '#3a7df5' } : disabledBtnStyle}
            >
              {isProcessing ? '등록 중...' : '등록하기'}
            </button>

            <button 
            onClick={handleCancel} 
            // examData에 아무것도 없으면(미리보기 전이면) 비활성화
            disabled={examData.length === 0} 
            style={examData.length > 0 ? cancelBtnInRowStyle : disabledBtnStyle}
            >
            취소
            </button>
          </div>
          
          <div style={infoBoxStyle}>
            <h4 style={{ margin: '0 0 10px 0', fontSize: '13px', borderBottom: '1px solid #ddd', paddingBottom: '5px', color: '#334155' }}>실시간 엑셀 인식 정보</h4>
            <div style={{ display: 'flex', gap: '15px', fontSize: '13px' }}>
              <p><b>강의코드:</b> {selectedCourseId || '-'}</p>
              <p><b>차시:</b> {examMeta.period}</p>
              <p><b>시험명:</b> {examMeta.title}</p>
            </div>
          </div>
        </div>
      </div>

      {/* 테이블 영역 */}
      <div style={{ marginTop: '20px', border: '1px solid #cbd5e1', borderRadius: '4px', overflow: 'hidden' }}>
        <table style={tableStyle}>
          <thead style={{ backgroundColor: '#f1f5f9' }}>
            <tr>
              <th style={thStyle}>번호</th>
              <th style={thStyle}>지문</th>
              <th style={thStyle}>보기1</th>
              <th style={thStyle}>보기2</th>
              <th style={thStyle}>보기3</th>
              <th style={thStyle}>보기4</th>
              <th style={thStyle}>정답</th>
              <th style={thStyle}>배점</th>
              <th style={thStyle}>해설</th>
            </tr>
          </thead>
          <tbody>
            {examData.length > 0 ? examData.map((q, idx) => (
              <tr key={idx} style={{ borderBottom: '1px solid #eee' }}>
                <td style={tdStyle}>{q.questionNo}</td>
                <td style={{ ...tdStyle, textAlign: 'left', minWidth: '200px' }}>{q.content}</td>
                <td style={tdStyle}>{q.option1}</td>
                <td style={tdStyle}>{q.option2}</td>
                <td style={tdStyle}>{q.option3}</td>
                <td style={tdStyle}>{q.option4}</td>
                <td style={tdStyle}>{q.answer}</td>
                <td style={tdStyle}>{q.score}</td>
                <td style={{ ...tdStyle, textAlign: 'left', fontSize: '12px', color: '#666' }}>{q.comment}</td>
              </tr>
            )) : (
              <tr><td colSpan="9" style={{ padding: '100px', textAlign: 'center', color: '#999' }}>파일을 첨부한 뒤 [미리보기]를 눌러주세요.</td></tr>
            )}
          </tbody>
        </table>
      </div>
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
    </div>
  );
}

// --- CSS 스타일 ---
const sectionStyle = { padding: '20px', backgroundColor: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: '8px' };
const btnStyle = { padding: '8px 15px', border: '1px solid #334155', backgroundColor: '#fff', cursor: 'pointer', borderRadius: '4px', fontSize: '13px' };

// 미리보기 & 등록하기용 스타일 (검정 계열)
const previewBtnStyle = { padding: '10px 20px', backgroundColor: '#334155', color: '#fff', border: 'none', borderRadius: '4px', cursor: 'pointer', fontWeight: 'bold', fontSize: '14px' };

// 취소 버튼 스타일 (흰색 배경)
const cancelBtnInRowStyle = { ...previewBtnStyle, backgroundColor: '#fff', color: '#334155', border: '1px solid #334155' };

const disabledBtnStyle = { ...previewBtnStyle, backgroundColor: '#cbd5e1', cursor: 'not-allowed' };
const infoBoxStyle = { backgroundColor: '#fff', padding: '12px 20px', border: '1px solid #cbd5e1', borderRadius: '4px', minWidth: '400px' };
const tableStyle = { width: '100%', borderCollapse: 'collapse', fontSize: '13px' };
const thStyle = { padding: '12px 8px', border: '1px solid #cbd5e1', fontWeight: 'bold' };
const tdStyle = { padding: '10px 8px', border: '1px solid #ddd', textAlign: 'center' };

export default ExamRegistrationPage;