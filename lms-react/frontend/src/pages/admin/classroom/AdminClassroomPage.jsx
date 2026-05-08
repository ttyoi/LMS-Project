import PlaceholderPage from "../../../components/common/PlaceholderPage";
import axios from "../../../api/axios";
import { useState, useEffect, useMemo } from "react";
import style from "./AdminClassroom.module.css";

/**
 * 강의실 관리 페이지 (관리자)
 * TODO: 이 파일을 수정하여 강의실 관리 기능을 구현하세요.
 * <PlaceholderPage
      title="강의실 관리"
      description="강의실 등록, 수정, 삭제 등 강의실 정보를 관리하는 페이지입니다."
      assignee="담당자를 입력하세요"
    />
 */
const TimeClassInfo = ({ label, data, periodInfo }) => {
  return (
    <>
      <tr>
        <th colSpan={2} className={style.listTableHead}>
          {label}
        </th>
      </tr>
      {!data ? (
        <tr>
          <td colSpan={2}>배정된 강의가 존재하지 않습니다.</td>
        </tr>
      ) : (
        <>
          <tr>
            <th>강의명</th>
            <td>{data.title}</td>
          </tr>
          <tr>
            <th>기간</th>
            <td>
              {periodInfo.start_date} ~ {periodInfo.end_date} /{" "}
              {data.start_time} ~ {data.end_time}
            </td>
          </tr>
          <tr>
            <th>강사</th>
            <td>{data.professor_name}</td>
          </tr>
        </>
      )}
    </>
  );
};

function AdminClassroomPage() {
  const [classRoomList, setClassRoomList] = useState([]);

  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [selectedTime, setSelectedTime] = useState([]);
  const [filteredList, setFilteredList] = useState([]);
  const [isSearched, setIsSearched] = useState(false);

  const [currentPage, setCurrentPage] = useState(1);
  const classRoomPerPage = 10;

  // 강의실 목록 조회
  const selectClassRoomList = () => {
    axios
      .get("/api/admin/classrooms/list")
      .then((response) => {
        console.log("강의실 목록", response.data);
        const filterStatusList = response.data.filter(
          (item) => item.status === 1,
        );
        console.log("status === 1 확인 ", filterStatusList);
        setClassRoomList(filterStatusList);
      })
      .catch((err) => {
        console.log("강의실 목록 조회 실패", err);
      });
  };

  useEffect(() => {
    selectClassRoomList();
  }, []);

  // 강의실별로 묶기 (중복 행 묶기) - ex) 102강의실 -> 3과목의 수업이 예정
  const groupedClassRoomList = useMemo(() => {
    const map = {};

    classRoomList.forEach((item) => {
      if (!map[item.class_name]) {
        map[item.class_name] = {
          class_id: item.class_id,
          class_name: item.class_name,
          people_limit: item.people_limit,
          courses: [],
        };
      }

      map[item.class_name].courses.push(item);
    });

    return Object.values(map).sort((a, b) => {
      return a.class_name.localeCompare(b.class_name);
    });
  }, [classRoomList]);

  // 운영시간
  const TIME_SLOTS = [
    { key: "morning", label: "오전", start: "09:00", end: "12:00" },
    { key: "lunch", label: "점심", start: "12:00", end: "14:00" },
    { key: "afternoon", label: "오후", start: "14:00", end: "18:00" },
  ];

  const toMinutes = (time) => {
    const [hour, min] = time.split(":").map(Number);
    return hour * 60 + min;
  };

  const isOverlap = (start, end, slotStart, slotEnd) => {
    return (
      toMinutes(start) < toMinutes(slotEnd) &&
      toMinutes(end) > toMinutes(slotStart)
    );
  };

  const timeStatus = useMemo(() => {
    const operatingTime = {};

    classRoomList.forEach((item) => {
      const sameClassCourse = classRoomList.filter((c) => {
        return c.class_id === item.class_id;
      });

      operatingTime[item.class_id] = TIME_SLOTS.reduce((acc, slot) => {
        acc[slot.key] = sameClassCourse.some((c) => {
          return isOverlap(c.start_time, c.end_time, slot.start, slot.end);
        });
        return acc;
      }, {});
    });
    return operatingTime;
  }, [classRoomList]);

  // 조건별 검색
  const toggleTime = (key) => {
    console.log("선택 시간 :", key);
    setSelectedTime((prev) => {
      return prev.includes(key)
        ? prev.filter((k) => k !== key)
        : [...prev, key];
    });
  };

  const handleSearch = () => {
    let result = [...groupedClassRoomList];
    console.log("검색 시 전체 목록:", result);

    if (startDate && endDate) {
      result = result.filter((item) => {
        const inRange = item.courses.some((course) => {
          const courseStart = formatDate(course.start_date);
          const courseEnd = formatDate(course.end_date);
          let isInRange = false;
          if (courseStart) {
            if (courseStart >= startDate && courseStart <= endDate) {
              isInRange = true;
            }
          }

          if (!isInRange && courseEnd) {
            if (courseEnd >= startDate && courseEnd <= endDate) {
              isInRange = true;
            }
          }

          console.log(
            `강의실: ${item.class_name}, 강의: ${course.title}, start: ${courseStart}, end: ${courseEnd}, inRange: ${isInRange}`,
          );
          return isInRange;
        });
        return inRange;
      });
    }

    if (selectedTime.length > 0) {
      result = result.filter((item) => {
        const matchesTime = selectedTime.some((timeKey) => {
          return timeStatus[item.class_id]?.[timeKey];
        });
        console.log(`강의실: ${item.class_name}, matchesTime: ${matchesTime}`);
        return matchesTime;
      });
      console.log("검색 결과:", result);
    }

    setFilteredList(result);
    setIsSearched(true);
    setCurrentPage(1);

    console.log("최종 검색 결과:", result);
  };

  const searchList = isSearched ? filteredList : groupedClassRoomList;

  const startIndex = (currentPage - 1) * classRoomPerPage;
  const endIndex = startIndex + classRoomPerPage;
  const pagedList = searchList.slice(startIndex, endIndex);
  const totalPage = Math.ceil(searchList.length / classRoomPerPage);

  useEffect(() => {
    setCurrentPage(1);
  }, [classRoomList]);

  // 강의실 추가
  const [showAddForm, setShowAddForm] = useState(null);
  const [form, setForm] = useState({
    class_name: "",
    people_limit: "",
    status: 1,
  });

  const handleChange = (e) => {
    const { name, value } = e.target;

    setForm((prev) => ({
      ...prev,
      [name]: value.replace(/[^0-9]/g, ""),
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!form.class_name.trim()) {
      alert("강의실 이름을 입력하세요.");
      return;
    } else if (!form.people_limit.trim() || Number(form.people_limit) <= 0) {
      alert("강의실 정원을 입력하세요.");
      return;
    } else if (Number(form.people_limit) > 50) {
      alert("강의실의 최대 정원 50명을 초과했습니다.");
      return;
    }

    if (!/^\d+$/.test(form.people_limit) && !/^\d+$/.test(form.people_name)) {
      alert("숫자만 입력하세요");
      return;
    }

    const isDuplicate = classRoomList.some((item) => {
      console.log("중복검사 : ", item.class_name);
      return item.class_name === form.class_name;
    });

    if (isDuplicate) {
      alert("이미 존재하는 강의실 이름입니다.");
      return;
    }

    axios
      .post("/api/admin/classrooms/insert", form)
      .then(() => {
        alert("강의실이 등록되었습니다.");

        setIsSearched(false);
        setSelectedTime([]);
        setStartDate("");
        setEndDate("");
        setCurrentPage(1);

        setForm({
          class_name: "",
          people_limit: "",
        });

        selectClassRoomList();
      })
      .catch((err) => {
        console.log("강의실 등록 실패", err);
        alert("강의실 등록에 실패하였습니다.");
      });
  };

  /* 강의실 상세 정보 조회 */
  const [selectedClassName, setSelectedClassName] = useState("close");
  const [classDetail, setClassDetail] = useState(null);

  useEffect(() => {
    if (!selectedClassName) return;
    axios
      .get(`/api/admin/classrooms/detail/`, {
        params: { name: selectedClassName },
      })
      .then((response) => {
        console.log(response.data);
        setClassDetail(response.data);
      })
      .catch((err) => {
        console.log("상세정보조회 실패 ", err);
      });
  }, [selectedClassName]);

  // 공통 정보 : 강의실명, 정원
  const classInfo = useMemo(() => {
    return {
      class_name: classDetail?.[0]?.class_name,
      people_limit: classDetail?.[0]?.people_limit,
    };
  }, [classDetail]);

  // 시간대별 수업 정보
  const timeGroup = useMemo(() => {
    if (!classDetail) {
      return { morning: null, lunch: null, afternoon: null };
    }
    const result = {
      morning: null,
      lunch: null,
      afternoon: null,
    };

    classDetail.forEach((item) => {
      if (!item?.start_time) return;
      const hour = parseInt(item.start_time.split(":")[0]);
      if (hour >= 0 && hour < 12) {
        if (!result.morning) result.morning = item;
      } else if (hour >= 12 && hour < 14) {
        if (!result.lunch) result.lunch = item;
      } else {
        if (!result.afternoon) result.afternoon = item;
      }
    });

    return result;
  }, [classDetail]);

  const formatDate = (timestamp) => {
    if (!timestamp) return "";

    const date = new Date(timestamp);

    return (
      date.getFullYear() +
      "-" +
      String(date.getMonth() + 1).padStart(2, "0") +
      "-" +
      String(date.getDate()).padStart(2, "0")
    );
  };

  const periodInfo = useMemo(() => {
    if (!classDetail?.[0]) return "";
    const temp = classDetail[0];
    return {
      ...temp,
      start_date: formatDate(temp.start_date),
      end_date: formatDate(temp.end_date),
    };
  }, [classDetail]);

  const time = [
    { key: "morning", label: "오전" },
    { key: "lunch", label: "점심" },
    { key: "afternoon", label: "오후" },
  ];

  /* 강의실 삭제 */
  const deleteClassRoom = () => {
    if (!classInfo?.class_name) return;

    const confirmDelete = window.confirm("해당 강의실을 삭제하시겠습니까?");
    if (!confirmDelete) return;

    axios
      .delete("/api/admin/classrooms/delete", {
        params: { class_name: classInfo.class_name },
      })
      .then((resonse) => {
        alert("해당 강의실이 삭제되었습니다.");

        setIsSearched(false);
        setSelectedTime([]);
        setStartDate("");
        setEndDate("");
        setCurrentPage(1);
        setShowAddForm("close");

        selectClassRoomList();
      })
      .catch((err) => {
        console.log("강의실 삭제 실패");
        alert("삭제에 실패하였습니다.");
      });
  };

  return (
    <>
      <h3>강의실 목록 관리</h3>
      <div className={style.container}>
        <div className={style.left}>
          <section>
            <div className={style.filterCard}>
              <div className={style.filterItem}>
                <label>강의기간</label>
                <div className={style.dateWrap}>
                  <input
                    type="date"
                    value={startDate}
                    onChange={(e) => setStartDate(e.target.value)}
                  />
                  ~
                  <input
                    type="date"
                    value={endDate}
                    onChange={(e) => setEndDate(e.target.value)}
                  />
                </div>
              </div>
              <div className={style.filterItem}>
                <label>운영시간</label>
                <div className={style.BtnWrap}>
                  <button
                    type="button"
                    onClick={() => toggleTime("morning")}
                    className={`${style.timeBtn} ${
                      selectedTime.includes("morning") ? style.ButtonActive : ""
                    }`}
                  >
                    오전
                  </button>
                  <button
                    type="button"
                    onClick={() => toggleTime("lunch")}
                    className={`${style.timeBtn} ${
                      selectedTime.includes("lunch") ? style.ButtonActive : ""
                    }`}
                  >
                    점심
                  </button>
                  <button
                    type="button"
                    onClick={() => toggleTime("afternoon")}
                    className={`${style.timeBtn} ${
                      selectedTime.includes("afternoon")
                        ? style.ButtonActive
                        : ""
                    }`}
                  >
                    오후
                  </button>
                  <button
                    type="button"
                    onClick={handleSearch}
                    className={style.searchBtn}
                  >
                    검색
                  </button>
                  <button
                    className={style.resetBtn}
                    type="button"
                    onClick={() => {
                      setIsSearched(false);
                      setSelectedTime([]);
                      setStartDate("");
                      setEndDate("");
                      setCurrentPage(1);
                    }}
                  >
                    ↻
                  </button>
                </div>
              </div>
            </div>
            <div className={style.listTableWrap}>
              <h3>강의실 목록</h3>
              <table className={style.listTable}>
                <thead className={style.listTableHead}>
                  <tr>
                    <th>강의실</th>
                    <th>정원</th>
                    <th>운영시간</th>
                  </tr>
                </thead>
                <tbody>
                  {searchList.length === 0 ? (
                    <tr>
                      <td colSpan="3">등록된 강의실이 없습니다.</td>
                    </tr>
                  ) : (
                    pagedList.map((item) => (
                      <tr
                        key={`${item.class_id}-${item.course_id}-${item.start_date}`}
                        onClick={() => {
                          setSelectedClassName(item.class_name);
                          setShowAddForm("detail");
                        }}
                        className={
                          selectedClassName === item.class_name
                            ? style.activeRow
                            : ""
                        }
                      >
                        <td>{item.class_name}</td>
                        <td>{item.people_limit}</td>
                        <td>
                          <div className={style.timeSlots}>
                            {TIME_SLOTS.map((slot) => {
                              const isBusy =
                                timeStatus[item.class_id]?.[slot.key];

                              return (
                                <span
                                  key={slot.key}
                                  className={
                                    isBusy ? style.busyText : style.freeText
                                  }
                                >
                                  {slot.label}
                                </span>
                              );
                            })}
                          </div>
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
                  onClick={() =>
                    setCurrentPage((p) => Math.min(p + 1, totalPage))
                  }
                  disabled={currentPage === totalPage}
                  className={style.pageButton}
                >
                  다음
                </button>
              </div>
            </div>
          </section>
        </div>

        <div className={style.right}>
          <div className={style.addDiv}>
            <div className={style.addBtnWrap}>
              <button
                type="button"
                className={style.addBtn}
                onClick={() => setShowAddForm("add")}
              >
                강의실 추가
              </button>
            </div>
            {showAddForm === "add" && (
              <section className={style.addSection}>
                <div>
                  <div className={style.addTitleWrap}>
                    <h3>강의실 등록</h3>
                    <div className={style.closeBtnWrap}>
                      <button
                        type="button"
                        className={style.closeBtn}
                        onClick={() => setShowAddForm("close")}
                      >
                        닫기
                      </button>
                    </div>
                  </div>
                  <form onSubmit={handleSubmit} className={style.addForm}>
                    <div className={style.inputWrap}>
                      <label>
                        <div>
                          강의실명 <span style={{ color: "red" }}>*</span>
                        </div>
                        <input
                          name="class_name"
                          value={form.class_name}
                          onChange={handleChange}
                        />
                      </label>
                      <label>
                        <div>
                          정원 <span style={{ color: "red" }}>*</span>
                        </div>
                        <input
                          type="number"
                          name="people_limit"
                          value={form.people_limit}
                          onChange={handleChange}
                        />
                      </label>
                    </div>
                    <div className={style.submitBtnWrap}>
                      <button type="submit" className={style.insertBtn}>
                        등록
                      </button>
                    </div>
                  </form>
                </div>
              </section>
            )}
          </div>

          {/* 강의실 상세 정보 */}
          {showAddForm === "detail" && (
            <section>
              <div className={style.detailCard}>
                <h3>강의실 상세 정보</h3>
                <table className={style.detailTable}>
                  <thead className={style.listTableHead}>
                    <tr>
                      <th colSpan={2}>강의실 정보</th>
                      <th colSpan={2}>
                        <div className={style.deleteBtnWrap}>
                          <button
                            type="button"
                            onClick={deleteClassRoom}
                            className={style.deleteBtn}
                          >
                            삭제
                          </button>
                          <button
                            type="button"
                            onClick={() => setShowAddForm("close")}
                            className={style.closeBtn}
                          >
                            닫기
                          </button>
                        </div>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <th>강의실</th>
                      <td>{classInfo?.class_name}</td>
                      <th>정원</th>
                      <td>{classInfo?.people_limit}</td>
                    </tr>
                  </tbody>
                </table>
                <table className={style.detailTable}>
                  <thead>
                    <tr>
                      <th colSpan={2}>수업 진행 중인 강의</th>
                    </tr>
                  </thead>
                  <tbody>
                    {time.map((time) => (
                      <TimeClassInfo
                        key={time.key}
                        label={time.label}
                        data={timeGroup?.[time.key]}
                        periodInfo={periodInfo}
                      />
                    ))}
                  </tbody>
                </table>
              </div>
            </section>
          )}
        </div>
      </div>
    </>
  );
}

export default AdminClassroomPage;
