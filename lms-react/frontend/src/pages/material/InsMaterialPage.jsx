import React, { useState, useEffect, useCallback, useRef } from 'react';
import axios from '../../api/axios';

function InstMaterialPage() {
  // --- [1] 상태 관리 ---
  const [materialList, setMaterialList] = useState([]);
  const [courses, setCourses] = useState([]);
  const [totalCount, setTotalCount] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedCourse, setSelectedCourse] = useState('all');
  const pageSize = 10;

  const [viewMode, setViewMode] = useState(null);
  const [selectedRow, setSelectedRow] = useState(null);

  const [formData, setFormData] = useState({ course_id: '', title: '', content: '' });
  const [selectedFile, setSelectedFile] = useState(null);
  const fileInputRef = useRef(null);
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

  // --- [2] 초기 데이터 로드 ---
  useEffect(() => {
    axios.get("/inst/loadInstCourse")
      .then(res => {
        // courses.map 에러 방지용 안전한 데이터 세팅
        const data = Array.isArray(res.data) ? res.data : (res.data.courseList || []);
        setCourses(data);
      })
      .catch(err => { if (err.message !== 'SESSION_EXPIRED') console.error("과정 로드 실패", err); });
  }, []);

  // --- [3] 학습자료 목록 로드 ---
  const loadMaterials = useCallback(() => {
    const sendCourse = selectedCourse === "all" ? "" : selectedCourse;
    axios.get("/inst/loadMaterials", {
      params: { currentPage, pageSize, course_id: sendCourse }
    })
    .then(res => {
      setMaterialList(Array.isArray(res.data.materialList) ? res.data.materialList : []);
      setTotalCount(res.data.totalCnt || 0);
    })
    .catch(err => { if (err.message !== 'SESSION_EXPIRED') console.error("목록 로드 실패", err); });
  }, [currentPage, selectedCourse]);

  useEffect(() => { loadMaterials(); }, [loadMaterials]);

  // --- [4] 이벤트 핸들러 ---
  const handleNewRegistration = () => {
    setViewMode('register');
    setSelectedRow(null);
    setFormData({ 
      course_id: selectedCourse !== 'all' ? selectedCourse : '', 
      title: '', 
      content: '' 
    });
    setSelectedFile(null);
  };

  const handleRowClick = (item) => {
    if (!item) return;
    setSelectedRow(item);
    setFormData({ 
      course_id: item.course_id || '', 
      title: item.title || '', 
      content: item.content || '' 
    });
    setViewMode('detail');
  };

  const handleDownload = () => {
    if (!selectedRow || !selectedRow.file_id) {
      showToast("다운로드 정보를 찾을 수 없습니다.");
      return;
    }
    axios.get(`/inst/downloadMaterial?file_id=${selectedRow.file_id}`, { responseType: 'blob' })
      .then(res => {
        const url = window.URL.createObjectURL(new Blob([res.data]));
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', selectedRow.file_name || 'download');
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);
      })
      .catch(err => { if (err.message !== 'SESSION_EXPIRED') showToast('다운로드에 실패했습니다.'); });
  };

  const handleDelete = () => {
    if (!selectedRow) return;
    if (!window.confirm(`"${selectedRow.title}" 학습자료를 삭제하시겠습니까?`)) return;

    const params = new URLSearchParams();
    params.append('materials_id', selectedRow.materials_id);
    if (selectedRow.file_id) params.append('file_id', selectedRow.file_id);

    axios.post('/inst/deleteMaterial', params)
      .then(res => {
        if (res.data.status === 200 || res.data.result === 'SUCCESS') {
          showToast('삭제되었습니다.');
          setViewMode(null);
          setSelectedRow(null);
          loadMaterials();
        } else {
          showToast('삭제 실패: ' + (res.data.msg || '오류 발생'));
        }
      })
      .catch(err => { if (err.message !== 'SESSION_EXPIRED') showToast('삭제 중 오류가 발생했습니다.'); });
  };

  const handleSubmit = () => {
    if (!formData.course_id || !formData.title) {
      showToast("과정명과 제목은 필수 입력 사항입니다.");
      return;
    }

    const data = new FormData();
    data.append("course_id", formData.course_id);
    data.append("title", formData.title);
    data.append("content", formData.content || "");
    if (selectedFile) data.append("file", selectedFile);

    axios.post("/inst/insertMaterial", data, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    .then(res => {
      if (res.data.status === 200 || res.data.result === "SUCCESS") {
        showToast("성공적으로 등록되었습니다.");
        setViewMode(null);
        loadMaterials();
      } else {
        showToast("등록 실패: " + (res.data.msg || "오류 발생"));
      }
    })
    .catch(err => { if (err.message !== 'SESSION_EXPIRED') console.error("등록 서버 에러", err); });
  };

  // --- [5] 페이징 계산 ---
  const totalPage = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageNumbers = Array.from({ length: totalPage }, (_, i) => i + 1)
                           .filter(n => n >= currentPage - 2 && n <= currentPage + 2);

  return (
    <div style={{ padding: '20px', display: 'flex', gap: '20px', minHeight: '85vh', overflow: 'hidden' }}>
      <style>{`
        @keyframes slideInRight {
          from { opacity: 0; transform: translateX(40px); }
          to   { opacity: 1; transform: translateX(0); }
        }
      `}</style>

      {/* 목록 영역 */}
      <div style={{ flex: 1, minWidth: 0, transition: 'flex 0.3s ease' }}>
        <h2 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '15px' }}>학습관리 {'>'} 학습자료 관리</h2>
        
        <div style={controlBarStyle}>
          <select 
            value={selectedCourse} 
            onChange={(e) => { setSelectedCourse(e.target.value); setCurrentPage(1); }}
            style={selectStyle}
          >
            <option value="all">전체 강의</option>
            {/* 🚨 courses.map 에러 방어 */}
            {Array.isArray(courses) && courses.map((c, i) => (
              <option key={i} value={c.course_id}>{c.course_title || c.title}</option>
            ))}
          </select>
          <button onClick={handleNewRegistration} style={activeBtnStyle}>신규등록</button>
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
              <tr style={{ backgroundColor: '#e2e8f0' }}>
                <th style={thStyle}>번호</th>
                <th style={thStyle}>강의명</th>
                <th style={thStyle}>학습자료 제목</th>
                <th style={thStyle}>등록일</th>
              </tr>
            </thead>
            <tbody>
              {materialList && materialList.length > 0 ? (
                materialList.map((m, i) => {
                  const isSelected = selectedRow?.materials_id === m.materials_id;
                  return (
                    <tr
                      key={m.materials_id || i}
                      onClick={() => { setKeyboardIndex(i); handleRowClick(m); setTimeout(() => tableWrapperRef.current?.focus(), 0); }}
                      style={{
                        cursor: 'pointer',
                        backgroundColor: isSelected ? '#fff9c4' : '#fff',
                        borderBottom: '1px solid #eee',
                        boxShadow: isTableFocused && keyboardIndex === i ? 'inset 0 0 0 2px #4a90e2' : 'none',
                      }}
                    >
                      <td style={tdStyle}>{(currentPage - 1) * pageSize + i + 1}</td>
                      <td style={tdStyle}>{m.course_title}</td>
                      <td style={{ ...tdStyle, textAlign: 'left', paddingLeft: '20px' }}>{m.title}</td>
                      <td style={tdStyle}>{(m.reg_date || m.register_date || '').slice(0, 10)}</td>
                    </tr>
                  );
                })
              ) : (
                <tr><td colSpan="3" style={tdStyle}>데이터가 없습니다.</td></tr>
              )}
            </tbody>
          </table>
        </div>

        <div style={{ display: 'flex', justifyContent: 'center', marginTop: '20px', gap: '5px' }}>
          {pageNumbers.map(n => (
            <button key={n} onClick={() => setCurrentPage(n)} style={n === currentPage ? activePageBtn : pageBtnStyle}>{n}</button>
          ))}
        </div>
      </div>

      {/* 상세/등록 영역 */}
      {viewMode && (
        <div style={{ ...rightPanelStyle, animation: 'slideInRight 0.25s ease' }}>
          <div style={stickyHeaderStyle}>
            <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 'bold' }}>
              {viewMode === 'register' ? '📝 학습자료 신규 등록' : '📄 학습자료 상세 정보'}
            </h3>
            <div style={{ display: 'flex', gap: '5px' }}>
              {viewMode === 'register' ? (
                <button onClick={handleSubmit} style={submitBtnStyle}>등록</button>
              ) : (
                <>
                  {selectedRow?.file_id && (
                    <button onClick={handleDownload} style={downloadBtnStyle}>다운로드</button>
                  )}
                  <button onClick={handleDelete} style={deleteBtnStyle}>삭제</button>
                </>
              )}
              <button onClick={() => setViewMode(null)} style={closeBtnStyle}>✕ 닫기</button>
            </div>
          </div>

          <div style={{ padding: '20px', overflowY: 'auto', flex: 1 }}>
            <table style={regTableStyle}>
              <tbody>
                <tr>
                  <th style={regThStyle}>과정명 <span style={{ color: '#ef4444' }}>*</span></th>
                  <td style={regTdStyle}>
                    <select 
                      value={formData.course_id} 
                      onChange={(e) => setFormData({...formData, course_id: e.target.value})}
                      style={inputStyle}
                      disabled={viewMode === 'detail'}
                    >
                      <option value="">과정을 선택해주세요</option>
                      {/* 🚨 courses.map 에러 방어 */}
                      {Array.isArray(courses) && courses.map((c, i) => (
                        <option key={i} value={c.course_id}>{c.course_title || c.title}</option>
                      ))}
                    </select>
                  </td>
                </tr>
                <tr>
                  <th style={regThStyle}>제목 <span style={{ color: '#ef4444' }}>*</span></th>
                  <td style={regTdStyle}>
                    <input 
                      value={formData.title} 
                      onChange={(e) => setFormData({...formData, title: e.target.value})}
                      style={inputStyle}
                      readOnly={viewMode === 'detail'}
                    />
                  </td>
                </tr>
                <tr>
                  <th style={regThStyle}>첨부파일</th>
                  <td style={regTdStyle}>
                    {viewMode === 'register' ? (
                      <input type="file" ref={fileInputRef} onChange={(e) => setSelectedFile(e.target.files[0])} />
                    ) : (
                      <div style={{ fontSize: '13px', color: '#64748b' }}>
                        {selectedRow?.file_name || '첨부파일 없음'}
                      </div>
                    )}
                  </td>
                </tr>
                <tr>
                  <th style={{ ...regThStyle, verticalAlign: 'top' }}>내용</th>
                  <td style={regTdStyle}>
                    <textarea 
                      value={formData.content} 
                      onChange={(e) => setFormData({...formData, content: e.target.value})}
                      style={{ ...inputStyle, height: '300px', resize: 'none' }} 
                      readOnly={viewMode === 'detail'}
                    />
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

// --- 스타일 설정 (변경 없음) ---
const controlBarStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px', backgroundColor: '#f1f5f9', border: '1px solid #cbd5e1', marginBottom: '10px' };
const selectStyle = { padding: '5px 10px', border: '1px solid #94a3b8', borderRadius: '4px', fontSize: '14px' };
const activeBtnStyle = { padding: '6px 12px', background: '#334155', color: '#fff', border: 'none', cursor: 'pointer', fontSize: '13px', borderRadius: '4px' };
const tableStyle = { width: '100%', borderCollapse: 'collapse', border: '1px solid #ddd', backgroundColor: '#fff' };
const thStyle = { padding: '12px', border: '1px solid #cbd5e1', fontSize: '13px', fontWeight: 'bold', textAlign: 'center' };
const tdStyle = { padding: '12px', border: '1px solid #eee', fontSize: '13px', textAlign: 'center' };
const rightPanelStyle = { flex: 0.8, border: '1px solid #334155', backgroundColor: '#fff', display: 'flex', flexDirection: 'column', height: '80vh', overflow: 'hidden', borderRadius: '4px' };
const stickyHeaderStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 20px', backgroundColor: '#f8fafc', borderBottom: '1px solid #cbd5e1' };
const closeBtnStyle = { padding: '4px 10px', backgroundColor: '#fff', border: '1px solid #ccc', cursor: 'pointer', borderRadius: '3px' };
const submitBtnStyle = { ...activeBtnStyle, background: '#3b82f6' };
const downloadBtnStyle = { ...activeBtnStyle, background: '#10b981' };
const deleteBtnStyle = { ...activeBtnStyle, background: '#ef4444' };
const regTableStyle = { width: '100%', borderCollapse: 'collapse' };
const regThStyle = { width: '100px', backgroundColor: '#f9fafb', border: '1px solid #ddd', padding: '12px', fontSize: '13px', textAlign: 'left', fontWeight: 'bold' };
const regTdStyle = { border: '1px solid #ddd', padding: '10px' };
const inputStyle = { width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px', boxSizing: 'border-box', fontSize: '13px' };
const pageBtnStyle = { padding: '5px 10px', border: '1px solid #ccc', backgroundColor: '#fff', cursor: 'pointer', fontSize: '12px' };
const activePageBtn = { ...pageBtnStyle, backgroundColor: '#334155', color: '#fff', border: 'none' };

export default InstMaterialPage;