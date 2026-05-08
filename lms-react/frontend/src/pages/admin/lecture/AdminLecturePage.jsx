import PlaceholderPage from "../../../components/common/PlaceholderPage";
import { useEffect, useRef, useState } from "react";
import axios from "../../../api/axios";
import style from "./AdminLecture.module.css";
//import { useAuth } from "../../context/AuthContext";
/**
 * 강의 관리 페이지 (관리자/강사)
 * TODO: 이 파일을 수정하여 강의 관리 기능을 구현하세요.
 *     <PlaceholderPage
      title="강의 관리"
      description="강의 개설, 수정, 폐강 등 강의를 관리하는 페이지입니다."
      assignee="담당자를 입력하세요"
    />
 */

function CourseDetail({ courseDetail, onUpdateStatus }) {
  if (!courseDetail) {
    return <section className={style.section}></section>;
  }
  return (
    <section className={style.section}>
      <div className={style.listTableWrap}>
        <h3 className={style.title}>강의 상세 정보</h3>

        <div className={style.detailCard}>
          <table className={style.detailTable}>
            <tbody>
              <tr>
                <th>강의명</th>
                <td>{courseDetail.title}</td>

                <th>상태</th>
                <td>
                  {courseDetail.cos_sta_code === "0"
                    ? "대기"
                    : courseDetail.cos_sta_code === "1"
                      ? "승인"
                      : "거절"}
                </td>
                {courseDetail.cos_sta_code === "0" ? (
                  <>
                    <th>상태변경</th>
                    <td className={style.buttonGroup}>
                      <button
                        className={style.approveButton}
                        onClick={() => {
                          if (window.confirm("승인하시겠습니까?")) {
                            onUpdateStatus(courseDetail.course_id, "1");
                          }
                        }}
                      >
                        승인
                      </button>
                      <button
                        className={style.rejectButton}
                        onClick={() => {
                          if (window.confirm("반려하시겠습니까?"))
                            onUpdateStatus(courseDetail.course_id, "-1");
                        }}
                      >
                        반려
                      </button>
                    </td>
                  </>
                ) : (
                  <>
                    <td colSpan={2}></td>
                  </>
                )}
              </tr>

              <tr>
                <th>강사</th>
                <td colSpan={5}>{courseDetail.name}</td>
              </tr>

              <tr>
                <th>기간</th>
                <td>
                  {courseDetail.start_date?.slice(0, 10)} ~{" "}
                  {courseDetail.end_date?.slice(0, 10)}
                </td>

                <th>시간</th>
                <td>
                  {courseDetail.start_time} ~ {courseDetail.end_time}
                </td>

                <th>강의실</th>
                <td>{courseDetail.class_name}호</td>
              </tr>
            </tbody>
          </table>
          <table className={style.detailTable2}>
            <tbody>
              <tr>
                <th>수업내용</th>
              </tr>
              <tr>
                <td>{courseDetail.content}</td>
              </tr>

              <tr>
                <th>강의계획서</th>
              </tr>
              <tr>
                <td>{courseDetail.plan}</td>
              </tr>

              <tr>
                <th>강의공지</th>
              </tr>
              <tr>
                <td>{courseDetail.notice}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}

function AdminLecturePage() {
  const inputRef = useRef(null);

  const [courseList, setCourseList] = useState([]);
  const [coStatusFilter, setCoStatusFilter] = useState("all");
  const [searchType, setSearchType] = useState("all");
  const [searchTypeTemp, setSearchTypeTemp] = useState("all");
  const [searchWord, setSearchWord] = useState("");
  const [searchInput, setSearchInput] = useState("");

  const [currentPage, setCurrentPage] = useState(1);
  const coursePerPage = 5;

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  // 강의목록
  useEffect(() => {
    axios
      .get("/api/admin/courseManagement/list")
      .then((response) => {
        console.log("강의 목록", response.data);

        const list = response.data || [];

        setCourseList(list);
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

  // 승인상태 필터
  const coStatusFilterList =
    coStatusFilter === "all"
      ? courseList
      : courseList.filter((item) => item.cos_sta_code === coStatusFilter);

  // 강사명, 강의명 검색
  const searchList =
    searchWord.trim() === ""
      ? coStatusFilterList
      : coStatusFilterList.filter((item) => {
          if (searchType === "course") {
            return item.title.includes(searchWord);
          } else if (searchType === "instructor") {
            return item.name.includes(searchWord);
          } else if (searchType === "all") {
            return (
              item.title.includes(searchWord) || item.name.includes(searchWord)
            );
          } else {
            return true;
          }
        });

  const startIndex = (currentPage - 1) * coursePerPage;
  const endIndex = startIndex + coursePerPage;
  const pagedList = searchList.slice(startIndex, endIndex);
  const totalPage = Math.ceil(searchList.length / coursePerPage);

  useEffect(() => {
    setCurrentPage(1);
  }, [coStatusFilter, searchWord]);

  /* 강의 상세 정보 */
  const [selectedCourseId, setSelectedCourseId] = useState(null);
  const [courseDetail, setCourseDetail] = useState(null);

  useEffect(() => {
    if (!selectedCourseId) return;
    axios
      .get(`/api/admin/courseManagement/detail/${selectedCourseId}`)
      .then((response) => {
        console.log("강의 상세 정보", response.data);

        setCourseDetail(response.data);
      })
      .catch((err) => {
        console.log("err--", err);
      });
  }, [selectedCourseId]);

  // 상태 변경
  const updateCourseStatus = (courseId, courseStatus) => {
    axios
      .put("/api/admin/courseManagement/updateStatus", null, {
        params: {
          course_id: courseId,
          status: courseStatus,
        },
      })
      .then(() => {
        return axios.get(`/api/admin/courseManagement/detail/${courseId}`);
      })
      .then((detailInfo) => {
        setCourseDetail(detailInfo);
        return axios.get("/api/admin/courseManagement/list");
      })
      .then((response) => {
        setCourseList(response.data || []);
      })
      .catch((err) => {
        console.log(" 업데이트 실패", err);
      });
  };

  return (
    <>
      <section className={style.section}>
        <h3 className={style.title}>강의 목록 관리</h3>
        <div className={style.filterCard}>
          <div className={style.filterItem}>
            <label className={style.searchLabel}>승인상태</label>
            <select
              value={coStatusFilter}
              onChange={(e) => setCoStatusFilter(e.target.value)}
              className={style.searchSelect}
            >
              <option value="all">전체</option>
              <option value="0">대기</option>
              <option value="1">승인</option>
              <option value="-1">거절</option>
            </select>
          </div>
          <div className={style.filterItem}>
            <label className={style.searchLabel}>검색기준</label>
            <select
              value={searchTypeTemp}
              onChange={(e) => {
                setSearchTypeTemp(e.target.value);
              }}
              className={style.searchSelect}
            >
              <option value="all">전체</option>
              <option value="course">강의명</option>
              <option value="instructor">강사명</option>
            </select>
          </div>

          <div className={style.searchRow}>
            <input
              type="text"
              value={searchInput}
              onChange={(e) => setSearchInput(e.target.value)}
              ref={inputRef}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  setSearchWord(searchInput);
                  setCurrentPage(1);
                }
              }}
              className={style.searchInput}
            ></input>
            <button
              onClick={() => {
                setSearchType(searchTypeTemp);
                setSearchWord(searchInput);
                setCurrentPage(1);
              }}
              className={style.searchButton}
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
                setCoStatusFilter("all");
                setCurrentPage(1);
                inputRef.current?.focus();
              }}
            >
              ↻
            </button>
          </div>
        </div>
      </section>
      {/* 강의목록 */}
      <section className={style.section}>
        <div className={style.listTableWrap}>
          <h3>강의 목록</h3>
          <table className={style.listTable}>
            <thead className={style.listTableHead}>
              <tr>
                <th>강의명</th>
                <th>강사</th>
                <th>기간</th>
                <th>승인상태</th>
              </tr>
            </thead>

            <tbody>
              {courseList.length === 0 ? (
                <tr>
                  <td colSpan="4">등록된 강의가 없습니다.</td>
                </tr>
              ) : (
                pagedList.map((item) => (
                  <tr
                    key={item.course_id}
                    onClick={() => setSelectedCourseId(item.course_id)}
                    style={{ cursor: "pointer" }}
                    className={
                      selectedCourseId === item.course_id ? style.activeRow : ""
                    }
                  >
                    <td>{item.title}</td>
                    <td>{item.name}</td>
                    <td>
                      {item.start_date.slice(0, 10)} ~{" "}
                      {item.end_date.slice(0, 10)}
                    </td>
                    <td>
                      <span
                        className={
                          item.cos_sta_code === "0"
                            ? style.statusWait
                            : style.statusApprove
                        }
                      >
                        {item.cos_sta_code === "0" ? "대기" : "승인"}
                      </span>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
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
      {/* 선택한 강의 상세 정보 */}
      <CourseDetail
        courseDetail={courseDetail}
        onUpdateStatus={updateCourseStatus}
      />
    </>
  );
}

export default AdminLecturePage;
