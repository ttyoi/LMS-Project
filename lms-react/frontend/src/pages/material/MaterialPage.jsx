import React, { useState, useEffect, useCallback, useRef } from 'react';
import axios from '../../api/axios';

function MaterialsPage() {
  const [materialList, setMaterialList] = useState([]);
  const [courses, setCourses] = useState([]);
  const [totalCount, setTotalCount] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedCourse, setSelectedCourse] = useState('all');
  const pageSize = 10;

  const [selectedRow, setSelectedRow] = useState(null);
  const [detailData, setDetailData] = useState(null);
  const [toast, setToast] = useState({ isVisible: false, message: '' });

  // --- 키보드 네비게이션 ---
  const tableWrapperRef = useRef(null);
  const [keyboardIndex, setKeyboardIndex] = useState(0);
  const [isTableFocused, setIsTableFocused] = useState(false);

  useEffect(() => {
    setKeyboardIndex(0);
  }, [materialList]);

  function handleTableKeyDown(e) {
    if (!materialList.length) return;
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setKeyboardIndex(prev => Math.min(prev + 1, materialList.length - 1));
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setKeyboardIndex(prev => Math.max(prev - 1, 0));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (materialList[keyboardIndex]) handleRowClick(materialList[keyboardIndex]);
    }
  }

  const showToast = (msg) => {
    setToast({ isVisible: true, message: msg });
    setTimeout(() => setToast({ isVisible: false, message: '' }), 3000);
  };

  // --- [1] 과정 목록 로드 ---
  useEffect(() => {
    axios.post('/stu/loadStuCourse')
      .then(res => {
        const data = Array.isArray(res.data) ? res.data : (res.data.courseList || []);
        setCourses(data);
      })
      .catch(err => { if (err.message !== 'SESSION_EXPIRED') console.error("과정 목록 로드 실패", err); });
  }, []);

  // --- [2] 학습자료 목록 로드 ---
  const loadMaterials = useCallback(() => {
    const sendCourse = selectedCourse === "all" ? "" : selectedCourse;
    
    axios.post('/stu/loadMaterials', {
        currentPage,
        pageSize,
        course_id: sendCourse
    }, { headers: { 'Content-Type': 'application/json' } })
    .then(res => {
      setMaterialList(Array.isArray(res.data.materialList) ? res.data.materialList : []);
      setTotalCount(res.data.totalCnt || 0);
      setSelectedRow(null);
      setDetailData(null);
    })
    .catch(err => { if (err.message !== 'SESSION_EXPIRED') console.error("학습자료 로드 실패", err); });
  }, [currentPage, selectedCourse]);

  useEffect(() => { loadMaterials(); }, [loadMaterials]);

  // --- [3] 상세 조회 ---
  const handleRowClick = (item) => {
    setSelectedRow(item);
    setDetailData(item); 
  };

  // --- [4] 다운로드 로직 ---
  // window.location.href 대신 axios blob 방식 사용
  // → Vite 프록시 bypass(text/html 차단)를 우회
  const handleDownload = () => {
    if (!detailData || !detailData.file_id) {
      showToast("다운로드 정보를 찾을 수 없습니다.");
      return;
    }
    axios.get(`/stu/downloadMaterial?file_id=${detailData.file_id}`, { responseType: 'blob' })
      .then(res => {
        const url = window.URL.createObjectURL(new Blob([res.data]));
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', detailData.file_name || 'download');
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);
      })
      .catch(err => { if (err.message !== 'SESSION_EXPIRED') showToast('다운로드에 실패했습니다.'); });
  };

  const pageNumbers = Array.from({ length: Math.max(1, Math.ceil(totalCount / pageSize)) }, (_, i) => i + 1)
                           .filter(n => n >= currentPage - 2 && n <= currentPage + 2);

  return (
    <div style={{ padding: '20px', display: 'flex', gap: '20px', minHeight: '85vh', overflow: 'hidden' }}>
      <style>{`
        @keyframes slideInRight {
          from { opacity: 0; transform: translateX(40px); }
          to   { opacity: 1; transform: translateX(0); }
        }
      `}</style>

      {/* --- 왼쪽: 학습자료 목록 영역 --- */}
      <div style={{ flex: 1, minWidth: 0, backgroundColor: '#fff', padding: '20px', borderRadius: '4px', border: '1px solid #ddd', transition: 'flex 0.3s ease' }}>
        <h2 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '15px' }}>학습관리 {'>'} 학습자료</h2>
        
        <div style={controlBarStyle}>
          <select value={selectedCourse} onChange={(e) => { setSelectedCourse(e.target.value); setCurrentPage(1); }} style={selectStyle}>
            <option value="all">전체 강의</option>
            {courses.map((c, i) => <option key={i} value={c.course_id}>{c.course_title || c.title}</option>)}
          </select>
          <span style={{ fontSize: '13px', color: '#666' }}>총 {totalCount}건</span>
        </div>

        <div
          ref={tableWrapperRef}
          tabIndex={0}
          onKeyDown={handleTableKeyDown}
          onFocus={() => setIsTableFocused(true)}
          onBlur={(e) => { if (!e.relatedTarget || !e.currentTarget.contains(e.relatedTarget)) setIsTableFocused(false); }}
          style={{ outline: 'none' }}
        >
          <table style={tableStyle}>
            <thead>
              <tr style={{ backgroundColor: '#f8fafc' }}>
                <th style={thStyle}>순번</th>
                <th style={thStyle}>강의명</th>
                <th style={thStyle}>제목</th>
                <th style={thStyle}>작성일</th>
              </tr>
            </thead>
            <tbody>
              {materialList.map((item, idx) => (
                <tr
                  key={idx}
                  onClick={() => { setKeyboardIndex(idx); handleRowClick(item); setTimeout(() => tableWrapperRef.current?.focus(), 0); }}
                  style={{
                    cursor: 'pointer',
                    backgroundColor: selectedRow?.materials_id === item.materials_id ? '#fff9c4' : '#fff',
                    borderBottom: '1px solid #eee',
                    boxShadow: isTableFocused && keyboardIndex === idx ? 'inset 0 0 0 2px #4a90e2' : 'none',
                  }}
                >
                  <td style={tdStyle}>{(currentPage - 1) * pageSize + idx + 1}</td>
                  <td style={tdStyle}>{item.course_title}</td>
                  <td style={{ ...tdStyle, textAlign: 'left', paddingLeft: '15px' }}>{item.title}</td>
                  <td style={tdStyle}>{(item.reg_date || item.register_date || '').slice(0, 10)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div style={{ display: 'flex', justifyContent: 'center', marginTop: '20px', gap: '5px' }}>
          {pageNumbers.map(n => (
            <button key={n} onClick={() => setCurrentPage(n)} style={n === currentPage ? activePageBtn : pageBtnStyle}>{n}</button>
          ))}
        </div>
      </div>

      {/* --- 오른쪽: 상세 정보 영역 --- */}
      {detailData && (
        <div style={{ ...rightPanelStyle, animation: 'slideInRight 0.25s ease' }}>
          <div style={stickyHeaderStyle}>
            <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 'bold' }}>📄 학습자료 상세</h3>
            <div style={{ display: 'flex', gap: '5px' }}>
                {detailData.file_id && (
                    <button onClick={handleDownload} style={downloadBtnStyle}>다운로드</button>
                )}
                <button onClick={() => setDetailData(null)} style={closeBtnStyle}>✕ 닫기</button>
            </div>
          </div>

          <div style={{ padding: '20px', overflowY: 'auto', flex: 1 }}>
            <table style={detailTableStyle}>
              <tbody>
                <tr>
                  <th style={detailThStyle}>제목</th>
                  <td style={detailTdStyle}>{detailData.title}</td>
                </tr>
                <tr>
                  <th style={detailThStyle}>첨부파일</th>
                  <td style={detailTdStyle}>{detailData.file_name || '첨부파일 없음'}</td>
                </tr>
                <tr>
                  <th style={{ ...detailThStyle, verticalAlign: 'top' }}>내용</th>
                  <td style={{ ...detailTdStyle, whiteSpace: 'pre-wrap', height: '150px' }}>
                    {detailData.content}
                  </td>
                </tr>
              </tbody>
            </table>
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
    </div>
  );
}

// --- 스타일 정의 (강사 페이지와 통일) ---
const controlBarStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px', backgroundColor: '#f1f5f9', border: '1px solid #cbd5e1', marginBottom: '10px' };
const selectStyle = { padding: '6px 10px', border: '1px solid #cbd5e1', borderRadius: '4px', fontSize: '13px' };
const tableStyle = { width: '100%', borderCollapse: 'collapse', border: '1px solid #ddd', backgroundColor: '#fff' };
const thStyle = { padding: '12px 8px', border: '1px solid #cbd5e1', fontSize: '13px', fontWeight: 'bold', textAlign: 'center' };
const tdStyle = { padding: '12px 8px', border: '1px solid #eee', fontSize: '13px', textAlign: 'center' };
const rightPanelStyle = { flex: 0.8, border: '1px solid #334155', backgroundColor: '#fff', display: 'flex', flexDirection: 'column', height: '80vh', overflow: 'hidden', borderRadius: '4px' };
const stickyHeaderStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 20px', backgroundColor: '#f8fafc', borderBottom: '1px solid #cbd5e1' };
const closeBtnStyle = { padding: '4px 10px', backgroundColor: '#fff', border: '1px solid #ccc', cursor: 'pointer', borderRadius: '3px' };
const downloadBtnStyle = { padding: '4px 10px', background: '#10b981', color: '#fff', border: 'none', cursor: 'pointer', borderRadius: '3px', fontSize: '13px' };
const detailTableStyle = { width: '100%', borderCollapse: 'collapse', border: '1px solid #ddd' };
const detailThStyle = { width: '25%', padding: '12px', backgroundColor: '#f9f9f9', border: '1px solid #ddd', fontSize: '13px', fontWeight: 'bold', textAlign: 'left' };
const detailTdStyle = { padding: '12px', border: '1px solid #ddd', fontSize: '13px' };
const pageBtnStyle = { padding: '5px 10px', border: '1px solid #ccc', backgroundColor: '#fff', cursor: 'pointer', fontSize: '12px' };
const activePageBtn = { ...pageBtnStyle, backgroundColor: '#334155', color: '#fff', border: 'none' };

export default MaterialsPage;