import { useEffect, useState } from "react";
import styles from "./SurveyPage.module.css";
import api from "../../api/axios";
import { useAuth } from "../../context/AuthContext";

const PAGE_SIZE = 10;

/* ─────────────── 학생 뷰 ─────────────── */
function StudentView({ user }) {
  const [surveyList, setSurveyList]         = useState([]);
  const [currentPage, setCurrentPage]       = useState(1);
  const [totalCount, setTotalCount]         = useState(0);
  const [selected, setSelected]             = useState(null);
  const [questionList, setQuestionList]     = useState([]);
  const [selectedAnswer, setSelectedAnswer] = useState(null);
  const [alreadyVoted, setAlreadyVoted]     = useState(false);

  const totalPage = Math.ceil(totalCount / PAGE_SIZE);

  const fetchList = async (pageNum = 1) => {
    try {
      const res = await api.get("/survey/surveyListAjax.do", {
        params: { currentPage: pageNum, pageSize: PAGE_SIZE },
      });
      setSurveyList(res.data?.list || []);
      setTotalCount(res.data?.totalCnt || 0);
      setCurrentPage(pageNum);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchDetail = async (surveyId) => {
    try {
      const res = await api.get("/survey/detailSurvey.do", { params: { surveyId } });
      const data = res.data?.result || {};
      const questions = res.data?.questions || [];
      setSelected({ surveyId, title: data.title || "", courseId: data.courseId });
      setQuestionList(questions);
      setAlreadyVoted(res.data?.alreadyResponded === true);
      setSelectedAnswer(null);
    } catch (err) {
      console.error(err);
    }
  };

  const handleVote = async () => {
    if (selectedAnswer === null) { alert("항목을 선택하세요."); return; }
    const q = questionList[selectedAnswer];
    const fd = new FormData();
    fd.append("action", "I");
    fd.append("surveyId", selected.surveyId);
    fd.append("courseId", selected.courseId);
    fd.append("questionId", q.questionId);
    try {
      await api.post("/survey/surveyResponseSave.do", fd);
      alert("투표가 완료되었습니다.");
      await fetchDetail(selected.surveyId);
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => { fetchList(1); }, []);

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>설문조사</h2>
      <div style={{ display: "flex", gap: 20 }}>

        {/* 목록 */}
        <div style={{ flex: 1 }}>
          <div className={styles.card}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th style={{ width: 50 }}>번호</th>
                  <th>제목</th>
                  <th>작성자</th>
                  <th>등록일</th>
                </tr>
              </thead>
              <tbody>
                {surveyList.length === 0 ? (
                  <tr><td colSpan={4} style={{ textAlign: "center", color: "#999", padding: 24 }}>설문이 없습니다.</td></tr>
                ) : surveyList.map((item, idx) => (
                  <tr key={item.surveyId} className={styles.qRow}>
                    <td>{(currentPage - 1) * PAGE_SIZE + idx + 1}</td>
                    <td
                      style={{ cursor: "pointer", color: "#2b6cb0" }}
                      onClick={() => fetchDetail(item.surveyId)}
                    >
                      {item.title}
                    </td>
                    <td>{item.loginName}</td>
                    <td>{item.createdAt}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className={styles.pagination}>
              <button className={styles.pageBtn} disabled={currentPage === 1} onClick={() => fetchList(currentPage - 1)}>이전</button>
              {Array.from({ length: totalPage }, (_, i) => i + 1).map((p) => (
                <button
                  key={p}
                  className={currentPage === p ? styles.activePage : styles.pageBtn}
                  onClick={() => fetchList(p)}
                >{p}</button>
              ))}
              <button className={styles.pageBtn} disabled={currentPage >= totalPage} onClick={() => fetchList(currentPage + 1)}>다음</button>
            </div>
          </div>
        </div>

        {/* 상세 */}
        <div style={{ flex: 1.2 }}>
          {!selected ? (
            <div className={styles.card} style={{ display: "flex", alignItems: "center", justifyContent: "center", minHeight: 200, color: "#999" }}>
              목록에서 설문을 선택하세요.
            </div>
          ) : (
            <div className={styles.detailCard}>
              <div className={styles.detailRow}>
                <span>제목</span>
                <input type="text" value={selected.title} readOnly />
              </div>

              <div style={{ marginBottom: 14 }}>
                <span style={{ fontWeight: 600, color: "#555", fontSize: 13 }}>설문 문항</span>
                {questionList.map((q, idx) => (
                  <div key={q.questionId} style={{ display: "flex", alignItems: "center", gap: 10, marginTop: 10 }}>
                    <input type="text" value={q.content} readOnly style={{ flex: 1, padding: "8px 10px", border: "1px solid #ccc", borderRadius: 6, fontSize: 13 }} />
                    {!alreadyVoted && (
                      <input
                        type="radio"
                        name="survey"
                        checked={selectedAnswer === idx}
                        onChange={() => setSelectedAnswer(idx)}
                      />
                    )}
                  </div>
                ))}
              </div>

              {alreadyVoted ? (
                <div style={{ padding: "10px 14px", background: "#e6f4ea", borderRadius: 8, color: "#2e7d32", fontSize: 13, fontWeight: 600 }}>
                  이미 참여한 설문입니다.
                </div>
              ) : (
                <div style={{ textAlign: "right" }}>
                  <button className={styles.primaryButton} onClick={handleVote}>투표</button>
                </div>
              )}
            </div>
          )}
        </div>

      </div>
    </div>
  );
}

/* ─────────────── 관리자/강사 뷰 ─────────────── */
function AdminView({ user }) {
  const [surveyList, setSurveyList]     = useState([]);
  const [currentPage, setCurrentPage]   = useState(1);
  const [totalCount, setTotalCount]     = useState(0);
  const [selected, setSelected]         = useState(null);
  const [questionList, setQuestionList] = useState([]);
  const [chartData, setChartData]       = useState([]);
  const [lectureList, setLectureList]   = useState([]);
  const [activeTab, setActiveTab]       = useState("");
  const [form, setForm] = useState({ title: "", lectureId: "", useYn: "Y", questions: [""] });

  const totalPage = Math.ceil(totalCount / PAGE_SIZE);

  const fetchList = async (pageNum = 1) => {
    try {
      const res = await api.get("/survey/surveyListAjax.do", {
        params: { currentPage: pageNum, pageSize: PAGE_SIZE },
      });
      setSurveyList(res.data?.list || []);
      setTotalCount(res.data?.totalCnt || 0);
      setCurrentPage(pageNum);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchLectures = async () => {
    try {
      const res = await api.get("/survey/getActiveCourseList.do");
      setLectureList(res.data?.courseList || []);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchDetail = async (surveyId) => {
    try {
      const res = await api.get("/survey/detailSurvey.do", { params: { surveyId } });
      const data = res.data?.result || {};
      const questions = res.data?.questions || [];
      setSelected({ surveyId, title: data.title || "", courseId: data.courseId });
      setQuestionList(questions);

      const chartRes = await api.get("/survey/getSurveyStatistics.do", {
        params: { surveyId },
      });
      const stats = chartRes.data?.questionStats || [];
      setChartData(stats.map((item) => ({ name: item.questionContent, value: Number(item.responseCount || 0) })));
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => { fetchList(1); fetchLectures(); }, []);

  const handleClickSurvey = (item) => {
    setActiveTab("detail");
    fetchDetail(item.surveyId);
  };

  const handleReset = () => {
    setActiveTab("write");
    setSelected(null);
    setForm({ title: "", lectureId: "", useYn: "Y", questions: [""] });
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleChangeQuestion = (idx, value) => {
    const updated = [...form.questions];
    updated[idx] = value;
    setForm((prev) => ({ ...prev, questions: updated }));
  };

  const handleAddQuestion = () => setForm((prev) => ({ ...prev, questions: [...prev.questions, ""] }));
  const handleRemoveQuestion = (idx) => setForm((prev) => ({ ...prev, questions: prev.questions.filter((_, i) => i !== idx) }));

  const handleSave = async () => {
    if (!form.title.trim()) { alert("제목을 입력하세요."); return; }
    if (!form.lectureId)    { alert("강의를 선택하세요."); return; }
    const validQ = form.questions.filter((q) => q.trim() !== "");
    if (validQ.length === 0) { alert("문항을 최소 1개 입력하세요."); return; }

    const fd = new FormData();
    fd.append("title", form.title);
    fd.append("courseId", form.lectureId);
    fd.append("useYn", form.useYn);
    fd.append("loginId", user.loginId);
    fd.append("action", "I");
    validQ.forEach((q) => { fd.append("questionContents", q); fd.append("questionTypes", "TEXT"); });

    try {
      await api.post("/survey/surveySave.do", fd);
      alert("등록되었습니다.");
      await fetchList(1);
      setActiveTab("");
      setSelected(null);
      setForm({ title: "", lectureId: "", useYn: "Y", questions: [""] });
    } catch (err) {
      console.error(err);
    }
  };

  const handleDelete = async () => {
    if (!selected?.surveyId) return;
    if (!window.confirm("설문을 삭제하시겠습니까?")) return;
    try {
      await api.post("/survey/surveyDelete.do", null, { params: { surveyId: selected.surveyId } });
      alert("삭제되었습니다.");
      setActiveTab("");
      setSelected(null);
      fetchList(currentPage);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>설문조사 관리</h2>
      <div style={{ display: "flex", gap: 20 }}>

        {/* 목록 */}
        <div style={{ flex: 1 }}>
          <div className={styles.card}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th style={{ width: 50 }}>번호</th>
                  <th>제목</th>
                  <th>작성자</th>
                  <th>등록일</th>
                </tr>
              </thead>
              <tbody>
                {surveyList.length === 0 ? (
                  <tr><td colSpan={4} style={{ textAlign: "center", color: "#999", padding: 24 }}>설문이 없습니다.</td></tr>
                ) : surveyList.map((item, idx) => (
                  <tr key={item.surveyId} className={styles.qRow}>
                    <td>{(currentPage - 1) * PAGE_SIZE + idx + 1}</td>
                    <td style={{ cursor: "pointer", color: "#2b6cb0" }} onClick={() => handleClickSurvey(item)}>
                      {item.title}
                    </td>
                    <td>{item.loginName}</td>
                    <td>{item.createdAt}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className={styles.pagination}>
              <button className={styles.pageBtn} disabled={currentPage === 1} onClick={() => fetchList(currentPage - 1)}>이전</button>
              {Array.from({ length: totalPage }, (_, i) => i + 1).map((p) => (
                <button
                  key={p}
                  className={currentPage === p ? styles.activePage : styles.pageBtn}
                  onClick={() => fetchList(p)}
                >{p}</button>
              ))}
              <button className={styles.pageBtn} disabled={currentPage >= totalPage} onClick={() => fetchList(currentPage + 1)}>다음</button>
            </div>
          </div>
        </div>

        {/* 우측 */}
        <div style={{ flex: 1.2 }}>
          {/* 탭 */}
          <div className={styles.tabMenu}>
            {selected && (
              <button
                className={activeTab === "detail" ? styles.tabActive : styles.tab}
                onClick={() => setActiveTab("detail")}
              >상세보기</button>
            )}
            <button
              className={activeTab === "write" ? styles.tabActive : styles.tab}
              onClick={handleReset}
            >설문등록</button>
          </div>

          {/* 상세보기 탭 */}
          {activeTab === "detail" && selected && (
            <div className={styles.detailCard}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
                <b style={{ fontSize: 14 }}>설문 상세</b>
                <button className={styles.dangerButton} onClick={handleDelete}>설문 삭제</button>
              </div>

              <div className={styles.detailRow}>
                <span>제목</span>
                <input type="text" value={selected.title} readOnly />
              </div>
              <div className={styles.detailRow}>
                <span>강의 ID</span>
                <input type="text" value={selected.courseId || ""} readOnly />
              </div>

              <div style={{ marginBottom: 14 }}>
                <span style={{ fontWeight: 600, color: "#555", fontSize: 13 }}>설문 문항</span>
                {questionList.map((q) => (
                  <div key={q.questionId} style={{ marginTop: 10 }}>
                    <input type="text" value={q.content} readOnly style={{ width: "100%", padding: "8px 10px", border: "1px solid #ccc", borderRadius: 6, fontSize: 13, background: "#f8f9fa", boxSizing: "border-box" }} />
                  </div>
                ))}
              </div>

              {chartData.length > 0 && (
                <div style={{ marginTop: 20 }}>
                  <span style={{ fontWeight: 600, color: "#555", fontSize: 13 }}>투표 현황</span>
                  {(() => {
                    const max = Math.max(...chartData.map((d) => d.value), 1);
                    return chartData.map((d, i) => (
                      <div key={i} style={{ marginTop: 10 }}>
                        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 12, color: "#555", marginBottom: 4 }}>
                          <span>{d.name}</span>
                          <span style={{ fontWeight: 700 }}>{d.value}표</span>
                        </div>
                        <div style={{ background: "#e9ecef", borderRadius: 6, height: 20, overflow: "hidden" }}>
                          <div style={{
                            width: `${Math.round((d.value / max) * 100)}%`,
                            height: "100%",
                            background: "linear-gradient(90deg, #2f68d8, #1447ad)",
                            borderRadius: 6,
                            transition: "width 0.4s ease",
                            minWidth: d.value > 0 ? 4 : 0,
                          }} />
                        </div>
                      </div>
                    ));
                  })()}
                </div>
              )}
            </div>
          )}

          {/* 설문등록 탭 */}
          {activeTab === "write" && (
            <div className={styles.detailCard}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
                <b style={{ fontSize: 14 }}>설문 등록</b>
                <button className={styles.primaryButton} onClick={handleSave}>등록</button>
              </div>

              <div className={styles.detailRow}>
                <span>제목</span>
                <input name="title" value={form.title} onChange={handleChange} placeholder="설문 제목" />
              </div>
              <div className={styles.detailRow}>
                <span>강의</span>
                <select name="lectureId" value={form.lectureId} onChange={handleChange} style={{ padding: "8px 10px", border: "1px solid #ccc", borderRadius: 6, fontSize: 13, height: 38 }}>
                  <option value="">강의 선택</option>
                  {lectureList.map((lec) => (
                    <option key={lec.courseId} value={lec.courseId}>[{lec.className}] {lec.title}</option>
                  ))}
                </select>
              </div>
              <div>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
                  <span style={{ fontWeight: 600, color: "#555", fontSize: 13 }}>항목</span>
                </div>
                {form.questions.map((q, idx) => (
                  <div key={idx} className={styles.questionRow}>
                    <span style={{ minWidth: 56, fontSize: 13, color: "#555" }}>항목 {idx + 1}</span>
                    <input
                      value={q}
                      onChange={(e) => handleChangeQuestion(idx, e.target.value)}
                      placeholder={`항목 ${idx + 1}`}
                    />
                    <button className={styles.iconBtn} onClick={handleAddQuestion}>+</button>
                    {form.questions.length > 1 && (
                      <button className={styles.iconBtn} onClick={() => handleRemoveQuestion(idx)}>−</button>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {!activeTab && (
            <div className={styles.card} style={{ display: "flex", alignItems: "center", justifyContent: "center", minHeight: 200, color: "#999" }}>
              설문을 선택하거나 새 설문을 등록하세요.
            </div>
          )}
        </div>

      </div>
    </div>
  );
}

/* ─────────────── 메인 진입점 ─────────────── */
function SurveyPage() {
  const { user } = useAuth();
  const userType = user?.userType || user?.role;

  if (userType === "S") return <StudentView user={user} />;
  return <AdminView user={user} />;
}

export default SurveyPage;
