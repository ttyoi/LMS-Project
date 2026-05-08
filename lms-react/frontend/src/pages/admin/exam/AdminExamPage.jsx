import PlaceholderPage from "../../../components/common/PlaceholderPage";
import axios from "../../../api/axios";
import { useState, useEffect, useMemo, useRef } from "react";
import style from "./AdminExamPage.module.css";

/**
 * 시험 관리 페이지 (관리자/강사)
 * TODO: 이 파일을 수정하여 시험 관리 기능을 구현하세요.
 */
function AdminExamPage() {
  const [testList, setTestList] = useState({ list: [], totalCount: 0 });
  const [searchWord, setSearchWord] = useState("");
  const [searchType, setSearchType] = useState("all");
  const [searchTypeTemp, setSearchTypeTemp] = useState("all");
  const [searchInput, setSearchInput] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const coursePerPage = 5;

  const inputRef = useRef(null);
  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  // 시험문제목록
  const RenderTestList = () => {
    axios
      .get("/api/admin/test-exam/list")
      .then((response) => {
        console.log("시험문제목록 : ", response.data);
        setTestList(response.data);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  useEffect(() => {
    RenderTestList();
  }, []);

  // 강사명, 강의명 검색
  const searchList =
    searchWord.trim() === ""
      ? testList.list
      : testList.list.filter((item) => {
          if (searchType === "course") {
            return item.title.includes(searchWord);
          } else if (searchType === "instructor") {
            return item.professorName.includes(searchWord);
          } else if (searchType === "all") {
            return (
              item.title.includes(searchWord) ||
              item.professorName.includes(searchWord)
            );
          } else {
            return false;
          }
        });

  const startIndex = (currentPage - 1) * coursePerPage;
  const endIndex = startIndex + coursePerPage;
  const pagedList = searchList?.slice(startIndex, endIndex);
  const totalPage = Math.ceil(searchList?.length / coursePerPage);

  useEffect(() => {
    setCurrentPage(1);
  }, []);

  //시험 상세
  const [selectedCourseId, setSelectedCourseId] = useState(null);
  const [selectedPeriod, setSelectedPeriod] = useState(null);
  const [testQuestions, setTestQuestions] = useState([]);
  const [selectedTestInfo, setSelectedTestInfo] = useState({
    courseName: "",
    testName: "",
  });
  const [testInfo, setTestInfo] = useState([]);

  const testDetail = () => {
    if (!selectedCourseId || !selectedPeriod) return;
    axios
      .get(
        `/api/admin/test-exam/detail/${selectedCourseId}/${selectedPeriod}/data`,
      )
      .then((response) => {
        console.log("시험문제", response.data);
        setTestQuestions(response.data);
        if (response.data.length > 0) {
          setSelectedTestInfo({
            courseName: response.data[0].courseName,
            testName: response.data[0].testName,
          });
        } else {
          setSelectedTestInfo({ courseName: "", testName: "" });
        }
      })
      .catch((err) => {
        console.log(err);
      });
  };

  // 시험 일정 - 상세
  const testScheduleDetail = () => {
    if (!selectedCourseId || !selectedPeriod) return;
    axios
      .get(
        `/api/admin/exam/schedule/detail/${selectedCourseId}/${selectedPeriod}`,
      )
      .then((response) => {
        console.log("시험일정 - 시험 상세", response.data);
        setTestInfo(response.data);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  useEffect(() => {
    testDetail();
    testScheduleDetail();
  }, [selectedCourseId, selectedPeriod]);

  // 시험 문항 수정
  const [showEditForm, setShowEditForm] = useState(false);
  const [showTestDetail, setShowTestDetail] = useState(false);
  const [originQuestions, setOriginQuestions] = useState([]);
  const [editQuestions, setEditQuestions] = useState([]);

  useEffect(() => {
    if (testQuestions) {
      setOriginQuestions(testQuestions);
      setEditQuestions(testQuestions);
    }
  }, [testQuestions]);

  const handleChange = (index, field, value) => {
    const update = [...editQuestions];

    let newScore = value;

    if (field === "score") {
      newScore = value.trim();
      if (isNaN(newScore)) {
        alert("숫자만 입력 가능합니다.");
        return;
      } else {
        newScore = Number(newScore);
      }
    }
    update[index] = {
      ...update[index],
      [field]: newScore,
    };
    setEditQuestions(update);
  };

  // 취소 -> 원본으로 되돌리기
  const handleCancel = () => {
    setEditQuestions(originQuestions);
  };

  // 수정 사항 저장
  const updateTest = () => {
    const confirm = window.confirm("수정 사항을 저장하시겠습니까?");

    if (!confirm) return;

    // 공백, score == 0 확인
    for (let i = 0; i < editQuestions.length; i++) {
      const question = editQuestions[i];
      if (!question || question.content.trim() === "") {
        alert(`${question.questionNo}번 문항 내용을 입력하세요.`);
        return;
      }

      if (
        !question.option1.trim() ||
        !question.option2.trim() ||
        !question.option3.trim() ||
        !question.option4.trim()
      ) {
        alert(`${question.questionNo}번 보기 내용을 모두 입력하세요.`);
        return;
      }

      if (!question.score || question.score <= 0) {
        alert(`${question.questionNo}번 배점을 확인하세요.`);
        return;
      }

      if (!question.answer) {
        alert(`${question.questionNo}번 정답을 선택하세요.`);
        return;
      }
    }
    axios
      .post("/api/admin/test-exam/edit", editQuestions)
      .then((response) => {
        console.log("수정 성공 :", response.data);
        alert("수정에 성공하였습니다.");
        testDetail();
        setEditQuestions([]);
      })
      .catch((err) => {
        console.log("수정 실패", err);
      });
  };

  /* 시험 일정 상세, 시험문제  탭 */
  const [activeTab, setActiveTab] = useState("");
  const isInfoTab = showTestDetail && activeTab === "info";
  const isQuestionTab = showTestDetail && activeTab === "question";

  /* 시험 상태 업데이트 */
  const updateStatus = (status) => {
    axios
      .post(
        `/api/admin/exam/updateStatus/${selectedCourseId}/${selectedPeriod}`,
        { status },
      )
      .then((response) => {
        console.log("상태 변경 성공", response.data);
        testScheduleDetail();
        RenderTestList();
      })
      .catch((err) => {
        console.error("상태 변경 실패", err);
      });
  };

  return (
    <>
      <section className={style.section}>
        <h3 className={style.title}>시험 관리</h3>
        <div className={style.filterCard}>
          <div className={style.filterItem}>
            <label className={style.searchLabel}>검색기준</label>
            <select
              className={style.searchSelect}
              value={searchTypeTemp}
              onChange={(e) => {
                setSearchTypeTemp(e.target.value);
              }}
            >
              <option value="all">전체</option>
              <option value="course">강의명</option>
              <option value="instructor">강사명</option>
            </select>
          </div>

          <div className={style.searchRow}>
            <input
              type="text"
              className={style.searchInput}
              value={searchInput}
              onChange={(e) => setSearchInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  setSearchWord(searchInput);
                  setSearchType(searchTypeTemp);
                  setCurrentPage(1);
                }
              }}
              ref={inputRef}
            ></input>
            <button
              className={style.searchButton}
              onClick={() => {
                setSearchType(searchTypeTemp);
                setSearchWord(searchInput);
                setCurrentPage(1);
              }}
            >
              검색
            </button>
            <button
              className={style.resetBtn}
              type="button"
              onClick={() => {
                setSearchTypeTemp("all");
                setSearchInput("");
                setSearchWord("");
                setCurrentPage(1);
                inputRef.current?.focus();
              }}
            >
              ↻
            </button>
          </div>
        </div>
      </section>

      {/* 시험문제 목록 */}
      <section className={style.section}>
        <div className={style.listTableWrap}>
          <h3>시험 목록</h3>
          <table className={style.listTable}>
            <thead className={style.listTableHead}>
              <tr>
                <th>강의번호</th>
                <th>강의명</th>
                <th>강사명</th>
                <th>차시</th>
                <th>시험상태</th>
              </tr>
            </thead>
            {pagedList?.length === 0 ? (
              <tbody>
                <tr>
                  <td colSpan="4">등록된 시험이 존재하지 않습니다.</td>
                </tr>
              </tbody>
            ) : (
              <tbody>
                {pagedList?.map((test, index) => (
                  <tr
                    key={`${test.courseId}- ${index}`}
                    onClick={() => {
                      ((setSelectedCourseId(test.courseId),
                      setSelectedPeriod(test.period)),
                        setShowTestDetail(true),
                        setActiveTab("info"));
                    }}
                    className={
                      selectedCourseId === test.courseId &&
                      selectedPeriod === test.period
                        ? style.activeRow
                        : ""
                    }
                  >
                    <td>{test.courseId}</td>
                    <td>{test.title}</td>
                    <td>{test.professorName}</td>
                    <td>{test.period}</td>
                    <td
                      className={
                        test.status === 1
                          ? style.statusApprove
                          : style.statusReject
                      }
                    >
                      {test.status === 1 ? "열림" : "닫힘"}
                    </td>
                  </tr>
                ))}
              </tbody>
            )}
          </table>
          <div className={style.pagination}>
            <button
              onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
              disabled={currentPage === 1}
              className={style.pageButton}
            >
              이전
            </button>

            <span className={style.pageInfo}>
              {currentPage} / {totalPage}
            </span>

            <button
              onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPage))}
              disabled={currentPage === totalPage}
              className={style.pageButton}
            >
              다음
            </button>
          </div>
        </div>
        <hr className={style.underLine}></hr>
      </section>

      {showTestDetail && (
        <div className={style.tabWrapSection}>
          <div className={style.tabWrap}>
            <button
              className={`${style.tabBtn} ${
                activeTab === "info" ? style.active : ""
              }`}
              onClick={() => setActiveTab("info")}
            >
              시험 상세
            </button>
            <button
              className={`${style.tabBtn} ${
                activeTab === "question" ? style.active : ""
              }`}
              onClick={() => setActiveTab("question")}
            >
              시험 문제
            </button>
          </div>
        </div>
      )}

      {isInfoTab && (
        <section className={style.section}>
          <div className={style.testDetailTableWrap}>
            <h3>시험 상세</h3>
            <table className={style.testDetailTable}>
              <thead className={style.listTableHead}>
                <tr>
                  <th>차시</th>
                  <th>시험명</th>
                  <th>시험날짜</th>
                  <th>상태</th>
                  <th>동작</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>{testInfo.testSchedule_period}</td>
                  <td>{testInfo.testSchedule_title}</td>
                  <td>{testInfo.testSchedule_date?.slice(0, 10)}</td>
                  <td>
                    {testInfo.testSchedule_status === 0 ? "닫힘" : "열림"}
                  </td>
                  <td>
                    {testInfo.testSchedule_status === 0 ? (
                      <button
                        className={style.statusOpenBtn}
                        onClick={() => updateStatus(1)}
                      >
                        열기
                      </button>
                    ) : (
                      <button
                        className={style.statusCloseBtn}
                        onClick={() => updateStatus(0)}
                      >
                        닫기
                      </button>
                    )}
                  </td>
                </tr>
                <tr>
                  <th>강의명</th>
                  <td>{testInfo.course_title}</td>
                  <th>강의실</th>
                  <td colSpan={2}>{testInfo.courseClass_className}호</td>
                </tr>
                <tr>
                  <th>강사</th>
                  <td colSpan={4}>{testInfo.tbUserinfo_name}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <hr className={style.underLine}></hr>
        </section>
      )}

      {isQuestionTab && showEditForm && (
        <section className={style.section}>
          <div className={style.testDetail}>
            <div className={style.headerRow}>
              <div className={style.testInfo}>
                <div className={style.infoItem}>
                  <span className={style.label}>강의명 </span>
                  <span className={style.value}>
                    {selectedTestInfo.courseName}
                  </span>
                </div>
                <div className={style.infoItem}>
                  <span className={style.label}>시험명 </span>
                  <span className={style.value}>
                    {selectedTestInfo.testName}
                  </span>
                </div>
              </div>
              <div className={style.btnWrap}>
                <button
                  type="button"
                  onClick={updateTest}
                  className={style.saveBtn}
                >
                  저장
                </button>
                <button
                  type="button"
                  onClick={handleCancel}
                  className={style.cancelBtn}
                >
                  리셋
                </button>
                <button
                  type="button"
                  className={style.closeBtn}
                  onClick={() => {
                    (setShowEditForm(false), setActiveTab("info"));
                  }}
                >
                  닫기
                </button>
              </div>
            </div>
            <div className={style.testCard}>
              {editQuestions?.map((quest, index) => {
                return (
                  <div key={index} className={style.testQuestion}>
                    <div className={style.questNo}>
                      {quest.questionNo}번 문항
                    </div>
                    <div className={style.score}>
                      배점 :
                      <input
                        type="text"
                        value={quest.score}
                        min="0"
                        onChange={(e) =>
                          handleChange(index, "score", e.target.value)
                        }
                      />
                      점
                    </div>
                    <textarea
                      className={style.updateQuest}
                      value={quest.content}
                      onChange={(e) =>
                        handleChange(index, "content", e.target.value)
                      }
                    ></textarea>

                    {["option1", "option2", "option3", "option4"].map(
                      (option, optIndex) => (
                        <div key={optIndex} className={style.optionWrapper}>
                          <input
                            type="radio"
                            name={quest.questionNo}
                            value={optIndex + 1}
                            checked={quest.answer === optIndex + 1}
                            onChange={() =>
                              handleChange(index, "answer", optIndex + 1)
                            }
                          ></input>
                          ({optIndex + 1})
                          <input
                            type="text"
                            key={optIndex}
                            value={quest[option]}
                            onChange={(e) =>
                              handleChange(index, option, e.target.value)
                            }
                          ></input>
                        </div>
                      ),
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        </section>
      )}

      {isQuestionTab && !showEditForm && (
        <section className={style.section}>
          <div className={style.testDetail}>
            <div className={style.headerRow}>
              <div className={style.testInfo}>
                <div className={style.infoItem}>
                  <span className={style.label}>강의명 </span>
                  <span className={style.value}>
                    {selectedTestInfo.courseName}
                  </span>
                </div>
                <div className={style.infoItem}>
                  <span className={style.label}>시험명 </span>
                  <span className={style.value}>
                    {selectedTestInfo.testName}
                  </span>
                </div>
              </div>
              <div className={style.updateBtn}>
                <button
                  type="button"
                  onClick={() => setShowEditForm(true)}
                  className={style.saveBtn}
                >
                  수정
                </button>
                <button
                  type="button"
                  onClick={() => {
                    (setShowEditForm(false), setActiveTab("info"));
                  }}
                  className={style.closeBtn}
                >
                  닫기
                </button>
              </div>
            </div>
            <div className={style.testCard}>
              {testQuestions?.map((quest, index) => {
                return (
                  <div key={index} className={style.testQuestion}>
                    <div className={style.questNo}>
                      {quest.questionNo}번 문항
                    </div>
                    <div className={style.score}>배점 : {quest.score}점</div>
                    <div className={style.content}>{quest.content}</div>
                    {[
                      quest.option1,
                      quest.option2,
                      quest.option3,
                      quest.option4,
                    ].map((option, index) => (
                      <div
                        key={index}
                        className={`${style.option} ${
                          quest.answer === index + 1 ? style.correct : ""
                        }`}
                      >
                        ({index + 1}) {option}
                      </div>
                    ))}
                  </div>
                );
              })}
            </div>
          </div>
        </section>
      )}
    </>
  );
}

export default AdminExamPage;
