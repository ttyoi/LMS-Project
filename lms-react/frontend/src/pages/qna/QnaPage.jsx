import { useEffect, useState } from "react";
import api from "../../api/axios";
import styles from "./QnaPage.module.css";
import { useAuth } from "../../context/AuthContext";

// ── 역할별 API 엔드포인트 맵 ──────────────────────────────────────────────
const EP = {
  A: {
    list:          "/api/admin/qna/list",
    save:          "/api/admin/qna/save",
    update:   (id) => `/api/admin/qna/update?postId=${id}`,
    del:      (id) => `/api/admin/qna/delete?postId=${id}`,
    comments: (id) => `/api/admin/qna/comments/${id}`,
    commentsKey:   "comments",
    commentSave:   "/api/admin/qna/comment/save",
    commentUpdate: "/api/admin/qna/comment/update",
    commentDel:    "/api/admin/qna/comment/delete",
  },
  I: {
    list:          "/inst/qna/list",
    save:          "/inst/qna/save",
    update:   (id) => `/inst/qna/update?postId=${id}`,
    del:      (id) => `/inst/qna/delete?postId=${id}`,
    comments: (id) => `/inst/qna/comment/list?postId=${id}`,
    commentsKey:   "data",
    commentSave:   "/inst/qna/comment/save",
    commentUpdate: "/inst/qna/comment/update",
    commentDel:    "/inst/qna/comment/delete",
  },
  S: {
    list:          "/stu/qna/list",
    save:          "/stu/qna/save",
    update:   (id) => `/stu/qna/update?postId=${id}`,
    del:      (id) => `/stu/qna/delete?postId=${id}`,
    comments: (id) => `/stu/qna/comment/list?postId=${id}`,
    commentsKey:   "data",
    commentSave:   "/stu/qna/comment/save",
    commentUpdate: "/stu/qna/comment/update",
    commentDel:    "/stu/qna/comment/delete",
  },
};

export default function QnaPage() {
  const { user } = useAuth();
  const userType  = user?.userType || "S";
  const ep        = EP[userType] || EP.S;
  const isAdmin   = userType === "A";
  const isInst    = userType === "I";
  const loginId   = user?.loginID || user?.loginId || "";
  const userName  = user?.userNm || "";

  const [qnaList,      setQnaList]      = useState([]);
  const [commentsMap,  setCommentsMap]  = useState({});
  const [categoryList, setCategoryList] = useState([]);
  const [page,         setPage]         = useState(1);
  const [totalCnt,     setTotalCnt]     = useState(0);
  const [selectedId,   setSelectedId]   = useState(null);
  const [selectedPost, setSelectedPost] = useState(null);
  const [activeTab,    setActiveTab]    = useState("write");

  const [form, setForm] = useState({ categoryCode: "", title: "", content: "" });
  const [answerForm, setAnswerForm] = useState({ commentId: null, content: "" });

  const pageSize = 10;

  // 수정/삭제 가능 여부: 관리자는 전체, 나머지는 본인 글만
  const canEditPost = (item) => isAdmin || (item?.loginID === loginId);
  // 답변 작성 가능 여부: 관리자 또는 강사
  const canAnswer = isAdmin || isInst;

  // ── 목록 + 댓글 일괄 조회 ───────────────────────────────────────────────
  const fetchData = async (pageNum = 1) => {
    try {
      const res  = await api.get(ep.list, { params: { page: pageNum, size: pageSize } });
      const list = res.data.qnaList || [];
      setQnaList(list);
      setTotalCnt(res.data.totalCnt || 0);

      if (res.data.categories) {
        setCategoryList(
          res.data.categories.map((c) => ({ code: c.categoryCode, name: c.categoryName }))
        );
      }

      const commentResults = await Promise.all(
        list.map((item) =>
          api.get(ep.comments(item.postId)).catch(() => ({ data: {} }))
        )
      );
      const map = {};
      commentResults.forEach((r, i) => {
        map[list[i].postId] = r.data[ep.commentsKey] || [];
      });
      setCommentsMap(map);
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => { fetchData(page); }, [page]);

  // ── 목록 클릭 → 상세 탭 전환 ────────────────────────────────────────────
  const handleQClick = (item) => {
    setSelectedId(item.postId);
    setSelectedPost(item);
    setActiveTab("detail");

    const comments = commentsMap[item.postId] || [];
    const answer   = [...comments]
      .filter((c) => c.isTeacher === "Y")
      .sort((a, b) => b.commentId - a.commentId)[0] || null;

    setForm({
      categoryCode: item.categoryCode || "",
      title:        item.title        || "",
      content:      item.content      || "",
    });
    setAnswerForm({
      commentId: answer?.commentId || null,
      content:   answer?.content   || "",
    });
  };

  // ── 신규 작성 탭으로 초기화 ─────────────────────────────────────────────
  const handleNewWrite = () => {
    setSelectedId(null);
    setSelectedPost(null);
    setActiveTab("write");
    setForm({ categoryCode: categoryList[0]?.code || "", title: "", content: "" });
    setAnswerForm({ commentId: null, content: "" });
  };

  // ── 게시글 저장/수정 ────────────────────────────────────────────────────
  const handleSubmit = async () => {
    if (!form.title.trim() || !form.content.trim()) {
      alert("제목과 내용을 입력해주세요.");
      return;
    }
    try {
      const formData = new FormData();
      formData.append("categoryCode", form.categoryCode);
      formData.append("title",        form.title);
      formData.append("content",      form.content);

      if (selectedId && canEditPost(selectedPost)) {
        await api.post(ep.update(selectedId), formData);
      } else if (!selectedId) {
        await api.post(ep.save, formData);
        handleNewWrite();
      }
      fetchData(page);
    } catch (err) {
      console.error(err);
    }
  };

  // ── 게시글 삭제 ─────────────────────────────────────────────────────────
  const handleDelete = async () => {
    if (!selectedId || !canEditPost(selectedPost)) return;
    if (!window.confirm("정말로 이 게시글을 삭제하시겠습니까?")) return;
    try {
      await api.post(ep.del(selectedId));
      handleNewWrite();
      fetchData(page);
    } catch (err) {
      console.error(err);
    }
  };

  // ── 답변(댓글) 저장/수정 ────────────────────────────────────────────────
  const handleAnswerSubmit = async () => {
    if (!selectedId || !answerForm.content?.trim()) return;
    try {
      if (!answerForm.commentId) {
        await api.post(ep.commentSave, { postId: selectedId, content: answerForm.content });
      } else {
        await api.post(ep.commentUpdate, { commentId: answerForm.commentId, content: answerForm.content });
      }
      // 해당 게시글 댓글만 재조회
      const r        = await api.get(ep.comments(selectedId)).catch(() => ({ data: {} }));
      const comments = r.data[ep.commentsKey] || [];
      setCommentsMap((prev) => ({ ...prev, [selectedId]: comments }));

      const answer = [...comments]
        .filter((c) => c.isTeacher === "Y")
        .sort((a, b) => b.commentId - a.commentId)[0] || null;
      setAnswerForm({ commentId: answer?.commentId || null, content: answer?.content || "" });
    } catch (err) {
      console.error(err);
    }
  };

  const totalPage    = Math.ceil(totalCnt / pageSize);
  const requiredMark = <span style={{ color: "red", marginLeft: "2px" }}>*</span>;

  return (
    <div className={styles.container} style={{ maxWidth: "1400px", margin: "0 auto" }}>
      <h2 className={styles.title}>Q&amp;A 게시판</h2>

      <div style={{ display: "flex", gap: "30px", alignItems: "flex-start" }}>
        {/* ── 좌측: 목록 ─────────────────────────────────────────────────── */}
        <div style={{ flex: "1", minWidth: "0" }}>
          <div className={styles.card} style={{ margin: 0, padding: "15px" }}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th style={{ width: "50px" }}>번호</th>
                  <th>제목</th>
                  <th style={{ width: "90px" }}>카테고리</th>
                  <th style={{ width: "70px" }}>답변</th>
                </tr>
              </thead>
              <tbody>
                {qnaList.length === 0 ? (
                  <tr>
                    <td colSpan={4} style={{ textAlign: "center", color: "#999", padding: "30px" }}>
                      등록된 Q&amp;A가 없습니다.
                    </td>
                  </tr>
                ) : (
                  qnaList.map((item, index) => {
                    const displayNum = totalCnt - (page - 1) * pageSize - index;
                    const answered   = (commentsMap[item.postId] || []).some((c) => c.isTeacher === "Y");
                    return (
                      <tr
                        key={item.postId}
                        onClick={() => handleQClick(item)}
                        className={styles.qRow}
                        style={{
                          backgroundColor: selectedId === item.postId ? "#f0f4ff" : "transparent",
                          cursor: "pointer",
                        }}
                      >
                        <td style={{ textAlign: "center" }}>{displayNum}</td>
                        <td style={{ whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                          <span className={styles.q}>Q.</span> {item.title}
                        </td>
                        <td style={{ textAlign: "center" }}>{item.categoryName || "미분류"}</td>
                        <td style={{ textAlign: "center" }}>
                          <span className={answered ? styles.badgeYes : styles.badgeNo}>
                            {answered ? "완료" : "대기"}
                          </span>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>

            <div className={styles.pagination}>
              {Array.from({ length: totalPage }, (_, i) => (
                <button
                  key={i}
                  className={page === i + 1 ? styles.activePage : styles.pageBtn}
                  onClick={() => setPage(i + 1)}
                >
                  {i + 1}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* ── 우측: 탭 + 폼 ──────────────────────────────────────────────── */}
        <div style={{ flex: "1.2", minWidth: "0" }}>
          <div className={styles.tabMenu} style={{ marginTop: 0 }}>
            {selectedId && (
              <div
                className={activeTab === "detail" ? styles.tabActive : styles.tab}
                onClick={() => setActiveTab("detail")}
              >
                상세보기
              </div>
            )}
            <div
              className={activeTab === "write" ? styles.tabActive : styles.tab}
              onClick={handleNewWrite}
            >
              Q 작성
            </div>
          </div>

          {activeTab ? (
            <div className={styles.detailCard} style={{ marginTop: "-2px" }}>
              {/* 카드 헤더 */}
              <div
                className={styles.cardHeader}
                style={{ display: "flex", justifyContent: "space-between", marginBottom: "20px" }}
              >
                <h4 style={{ margin: 0 }}>
                  {activeTab === "write" ? "Q 등록" : "상세보기"}
                </h4>
                <div style={{ display: "flex", gap: "10px" }}>
                  {/* 저장 버튼: write 탭이면 항상, detail 탭이면 본인/관리자만 */}
                  {(activeTab === "write" || (activeTab === "detail" && canEditPost(selectedPost))) && (
                    <button className={styles.primaryButton} onClick={handleSubmit}>
                      저장
                    </button>
                  )}
                  {activeTab === "detail" && selectedId && canEditPost(selectedPost) && (
                    <button className={styles.dangerButton} onClick={handleDelete}>
                      삭제
                    </button>
                  )}
                </div>
              </div>

              {/* 카테고리 / 작성자 */}
              <div className={styles.detailRow}>
                <span>{requiredMark}카테고리</span>
                <select
                  value={form.categoryCode}
                  onChange={(e) =>
                    (activeTab === "write" || canEditPost(selectedPost)) &&
                    setForm({ ...form, categoryCode: e.target.value })
                  }
                  disabled={activeTab === "detail" && !canEditPost(selectedPost)}
                >
                  {categoryList.map((cat) => (
                    <option key={cat.code} value={cat.code}>
                      {cat.name}
                    </option>
                  ))}
                </select>
                <span>작성자</span>
                <input
                  value={activeTab === "detail" ? (selectedPost?.writerName || "") : userName}
                  readOnly
                  style={{ backgroundColor: "#f8f9fa", textAlign: "center" }}
                />
              </div>

              {/* 제목 */}
              <div className={styles.detailRow}>
                <span>{requiredMark}제목</span>
                <input
                  value={form.title}
                  onChange={(e) =>
                    (activeTab === "write" || canEditPost(selectedPost)) &&
                    setForm({ ...form, title: e.target.value })
                  }
                  readOnly={activeTab === "detail" && !canEditPost(selectedPost)}
                  placeholder="제목을 입력하세요."
                  style={{ gridColumn: "2 / 5" }}
                />
              </div>

              {/* 질문 내용 */}
              <div className={styles.detailRow}>
                <span>{requiredMark}질문 내용</span>
                <textarea
                  value={form.content}
                  onChange={(e) =>
                    (activeTab === "write" || canEditPost(selectedPost)) &&
                    setForm({ ...form, content: e.target.value })
                  }
                  readOnly={activeTab === "detail" && !canEditPost(selectedPost)}
                  placeholder="질문 내용을 입력하세요."
                  style={{ height: "120px", minHeight: "120px" }}
                />
              </div>

              {/* ── 답변 섹션: 상세 탭에서만 표시 ─────────────────────── */}
              {activeTab === "detail" && selectedId && (
                <div style={{ marginTop: "20px", borderTop: "2px solid #e5e7eb", paddingTop: "15px" }}>
                  <div
                    className={styles.cardHeader}
                    style={{ marginBottom: "10px" }}
                  >
                    <span style={{ fontWeight: "bold", color: "#1447ad", fontSize: "14px" }}>
                      A. 답변
                    </span>
                    {canAnswer && (
                      <button
                        className={styles.secondaryButton}
                        onClick={handleAnswerSubmit}
                        style={{ marginLeft: "auto" }}
                      >
                        답변 저장
                      </button>
                    )}
                  </div>
                  <div className={styles.detailRow}>
                    <span>답변 내용</span>
                    <textarea
                      value={answerForm.content}
                      onChange={(e) =>
                        canAnswer && setAnswerForm({ ...answerForm, content: e.target.value })
                      }
                      readOnly={!canAnswer}
                      placeholder={
                        canAnswer
                          ? "답변을 입력하세요."
                          : answerForm.content
                          ? undefined
                          : "등록된 답변이 없습니다."
                      }
                      style={{ height: "120px", minHeight: "120px" }}
                    />
                  </div>

                  {/* 학생 댓글 목록 */}
                  {(() => {
                    const stuComments = (commentsMap[selectedId] || []).filter(
                      (c) => c.isTeacher === "N"
                    );
                    if (stuComments.length === 0) return null;
                    return (
                      <div style={{ marginTop: "12px" }}>
                        <div style={{ fontSize: "13px", fontWeight: 600, color: "#555", marginBottom: "8px" }}>
                          댓글 ({stuComments.length})
                        </div>
                        {stuComments.map((c) => (
                          <div key={c.commentId} className={styles.commentItem}>
                            <span className={styles.commentWriter}>{c.writerName}</span>
                            <span className={styles.commentContent}>{c.content}</span>
                            <span className={styles.commentDate}>
                              {c.createdAt ? new Date(c.createdAt).toLocaleDateString() : ""}
                            </span>
                          </div>
                        ))}
                      </div>
                    );
                  })()}
                </div>
              )}
            </div>
          ) : (
            <div
              className={styles.card}
              style={{
                height: "200px",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                color: "#999",
              }}
            >
              목록에서 항목을 선택하여 내용을 확인하세요.
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
