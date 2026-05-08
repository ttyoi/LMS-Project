/**
 * instCourse.js
 * 강사 강의 관련 페이지 공통: 강의 목록 조회 + 공통 데이터 로드
 *
 * 의존: jQuery, courseDropdown.js (먼저 로드해야 함)
 * 사용하는 페이지: courseView.jsp, coursePlanView.jsp, attendanceView.jsp
 *
 * API:
 *   POST /inst/getCourseList.json   → { list, totalCount, resultMsg, loginID, userType }
 *   GET  /common/coursetimelist     → [{ time_code, start_time, end_time }]
 *   GET  /common/registeredinstlist → [{ loginID, name }]
 */

// 보조강사 loginID → name 맵 (loadCommonData에서 채워짐)
var instMap = {};
// 전체 강의실 목록 (타임라인 renderTimelineBody에서 사용)
var allClassList = [];

// =============================================
// 강의 목록 조회 (AJAX)
// =============================================
async function fetchCourseList(currentPage, filterList) {
  var params = Object.assign(
    {
      currentPage: 1,
      pageSize: 5,
      title: "",
      search_sdate: "",
      search_edate: "",
      course_class: "",
      time_code: "",
      sub_prof: "",
      cos_sta_code: "",
    },
    filterList || {},
    { currentPage: currentPage || 1 },
  );

  try {
    var response = await fetch("/inst/getCourseList.json", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams(params),
    });
    var data = await response.json();
    $("#inst-course").empty();

    // 삭제된 강의(delete_yn='Y' 등)는 서버에서 제외
    // cos_sta_code=-1(거절)은 목록에 표시하되 disabled 처리
    var visibleList = data.list || [];

    if (visibleList.length === 0) {
      var emptyHtml =
        '<tr class="ckj-empty-row"><td colspan="99">조회된 강의가 없습니다.</td></tr>';
      for (var f = 0; f < params.pageSize - 1; f++) {
        emptyHtml += '<tr class="ckj-row-fill"><td colspan="99"></td></tr>';
      }
      $("#inst-course").html(emptyHtml);
      updatePagination(params.currentPage, 0, params.pageSize);
      updateFilterOptions([]);
      return;
    }

    var todayStr = toDateStr(new Date());
    var html = "";
    visibleList.forEach(function (course, index) {
      var subProfName =
        course.sInst_name ||
        (course.sub_prof ? instMap[course.sub_prof] || course.sub_prof : "");

      // 상태 배지 결정
      var badgeClass,
        badgeLabel,
        trClass = "";
      if (String(course.cos_sta_code) === "-1") {
        badgeClass = "ckj-badge-rejected";
        badgeLabel = "거절";
        trClass = "ckj-status-ended ckj-row-disabled";
      } else if (course.end_date && todayStr > course.end_date) {
        badgeClass = "ckj-badge-ended";
        badgeLabel = "종강";
        trClass = "ckj-status-ended ckj-row-disabled";
      } else if (
        course.start_date &&
        course.end_date &&
        todayStr >= course.start_date &&
        todayStr <= course.end_date
      ) {
        badgeClass = "ckj-badge-active";
        badgeLabel = "진행중";
      } else if (
        String(course.cos_sta_code) === "1" &&
        course.start_date &&
        todayStr < course.start_date
      ) {
        badgeClass = "ckj-badge-recruiting";
        badgeLabel = "모집중";
      } else {
        badgeClass = "ckj-badge-waiting";
        badgeLabel = "대기중";
      }
      var badge =
        '<span class="ckj-status-badge ' +
        badgeClass +
        '">' +
        badgeLabel +
        "</span>";

      html +=
        '<tr data-id="' +
        course.course_id +
        '"' +
        ' data-start="' +
        (course.start_date || "") +
        '"' +
        ' data-end="' +
        (course.end_date || "") +
        '"' +
        (trClass ? ' class="' + trClass + '"' : "") +
        ">" +
        "<td>" +
        ((params.currentPage - 1) * params.pageSize + index + 1) +
        "</td>" +
        "<td>" +
        badge +
        course.title +
        "</td>" +
        "<td>" +
        course.start_date +
        " ~ " +
        course.end_date +
        "</td>" +
        "<td>" +
        (course.class_name || "") +
        "</td>" +
        "<td>" +
        (course.time_code || "") +
        "</td>" +
        "<td>" +
        subProfName +
        "</td>" +
        "<td>" +
        (course.stu_cnt || 0) +
        "</td>" +
        "</tr>";
    });
    // 5개 미만일 경우 빈 행으로 높이 유지
    var fillCount = params.pageSize - visibleList.length;
    for (var i = 0; i < fillCount; i++) {
      html += '<tr class="ckj-row-fill"><td colspan="99"></td></tr>';
    }
    $("#inst-course").html(html);
    updatePagination(params.currentPage, data.totalCount, params.pageSize);
    updateFilterOptions(visibleList);
    if (typeof onListRendered === "function") onListRendered();
  } catch (err) {
    console.error("fetchCourseList 오류:", err);
  }
}

// =============================================
// 강의실·보조강사 필터 옵션: 현재 목록 데이터 기준 동적 갱신
// =============================================
function updateFilterOptions(list) {
  // 강의실: 이전 체크 상태 보존 후 재생성
  var $checkboxList = $('[data-col="room"] .ckj-checkbox-list');
  var checkedRooms = $checkboxList
    .find("input:checked")
    .map(function () {
      return this.value;
    })
    .get();
  var rooms = {};
  list.forEach(function (c) {
    if (c.class_name) rooms[c.class_name] = true;
  });
  $checkboxList.empty();
  Object.keys(rooms)
    .sort()
    .forEach(function (name) {
      var isChecked = checkedRooms.indexOf(name) >= 0;
      $checkboxList.append(
        '<label><input type="checkbox" class="ckj-col-filter" data-param="course_class" value="' +
          name +
          '"' +
          (isChecked ? " checked" : "") +
          "> " +
          name +
          "</label>",
      );
    });

  // 보조강사: 이전 선택 값 보존 후 재생성
  var $subProfFilter = $('[data-col="subprof"] select.ckj-col-filter');
  var prevSubProf = $subProfFilter.val();
  var subProfs = {};
  list.forEach(function (c) {
    if (c.sub_prof) {
      subProfs[c.sub_prof] = c.sInst_name || instMap[c.sub_prof] || c.sub_prof;
    }
  });
  $subProfFilter.find("option:not(:first)").remove();
  Object.keys(subProfs)
    .sort()
    .forEach(function (loginID) {
      $subProfFilter.append(
        '<option value="' + loginID + '">' + subProfs[loginID] + "</option>",
      );
    });
  // 이전 선택 값 복원 (해당 option이 여전히 존재하는 경우)
  if (prevSubProf) {
    $subProfFilter.val(prevSubProf);
  }
}

// =============================================
// 공통 데이터 로드 (강의실·차시·보조강사)
// =============================================
async function loadCommonData() {
  try {
    // 전체 강의실 목록 (타임라인용 + 폼용)
    var classInfoList = await fetch("/common/courseclasslist").then(
      function (r) {
        return r.json();
      },
    );
    allClassList = (classInfoList || [])
      .map(function (c) {
        return c.class_name;
      })
      .filter(Boolean)
      .sort();

    // 강의실 셀렉트 (등록/상세 폼 전용)
    var $classSelect = $("#class-id");
    if ($classSelect.length && $classSelect.prop("tagName") === "SELECT") {
      $classSelect.find("option:not(:first)").remove();
      (classInfoList || []).forEach(function (c) {
        $classSelect.append(
          '<option value="' + c.class_id + '">' + c.class_name + "</option>",
        );
      });
    }

    // 차시 셀렉트 (필터 + 등록 폼 + 상세 폼)
    var timeList = await fetch("/common/coursetimelist").then(function (r) {
      return r.json();
    });
    var $timeSelect = $('[data-col="time"] select.ckj-col-filter');
    $timeSelect.find("option:not(:first)").remove();
    timeList.forEach(function (t) {
      $timeSelect.append(
        '<option value="' +
          t.time_code +
          '">' +
          t.time_code +
          "차시 (" +
          t.start_time +
          "~" +
          t.end_time +
          ")</option>",
      );
    });
    var $timeFormSelect = $("#time-code-form");
    if ($timeFormSelect.length) {
      $timeFormSelect.find("option:not(:first)").remove();
      timeList.forEach(function (t) {
        $timeFormSelect.append(
          '<option value="' +
            t.time_code +
            '">' +
            t.time_code +
            "차시 (" +
            t.start_time +
            "~" +
            t.end_time +
            ")</option>",
        );
      });
    }
    // courseView.jsp 상세 폼 차시 셀렉트
    var $timeDetailSelect = $("#time-code");
    if (
      $timeDetailSelect.length &&
      $timeDetailSelect.prop("tagName") === "SELECT"
    ) {
      $timeDetailSelect.find("option:not(:first)").remove();
      timeList.forEach(function (t) {
        $timeDetailSelect.append(
          '<option value="' +
            t.time_code +
            '">' +
            t.time_code +
            "차시 (" +
            t.start_time +
            "~" +
            t.end_time +
            ")</option>",
        );
      });
    }

    // 보조강사 셀렉트 + instMap 구성
    var instList = await fetch("/common/registeredinstlist").then(function (r) {
      return r.json();
    });
    instMap = {};
    instList.forEach(function (inst) {
      instMap[inst.loginID] = inst.name;
    });

    // 신규 등록 폼의 보조강사 셀렉트 (#sub-prof)
    var $subProfForm = $("#sub-prof");
    if ($subProfForm.length) {
      $subProfForm.find("option:not(:first)").remove();
      instList.forEach(function (inst) {
        $subProfForm.append(
          '<option value="' + inst.loginID + '">' + inst.name + "</option>",
        );
      });
    }
  } catch (err) {
    console.error("loadCommonData 오류:", err);
  }
}

// =============================================
// 탭 네비게이션
// =============================================
var TAB_URLS = {
  "신규 등록": "/inst/course-plan",
  "강의 상세": "/inst/course-list",
  "출석 관리": "/inst/attendance",
};

$(document).on("click", ".ckj-tab-btn", function () {
  var label = $(this).text().trim();
  var url = TAB_URLS[label];
  if (url && !$(this).hasClass("active")) {
    if (label === "신규 등록") {
      sessionStorage.removeItem("ckj_selected_course_id");
    }
    location.href = url;
  }
});

// =============================================
// 초기화
// =============================================
$(function () {
  // 행 클릭 시 선택된 course_id 세션 저장 (탭 전환 시 유지)
  $(document).on("click", "#inst-course tr[data-id]", function () {
    sessionStorage.setItem("ckj_selected_course_id", $(this).data("id"));
  });

  // is-error 포커스 시 해제
  $(document).on("focus", ".is-error", function () {
    $(this).removeClass("is-error");
  });

  // loadCommonData 완료 후 타임라인 초기 렌더링 (allClassList 보장)
  loadCommonData().then(function () {
    if ($(".ckj-timeline-container").length > 0 && currentWeekStart) {
      fetchAndRenderTimeline(currentWeekStart);
    }
  });
  fetchCourseList();
});

// =============================================
// 강의 상세 기능 (courseView.jsp 전용)
// =============================================
var selectedCourse = null;

// 미선택 상태: 폼 전체 readonly 처리, 강의명에 안내 문구
function setFormUnselected() {
  selectedCourse = null;
  $("#course-title, #start_date, #end_date, #content, #plan, #notice")
    .prop("readonly", true)
    .val("");
  $("#class-id, #time-code, #sub-prof").prop("disabled", true).val("");
  $("#save-btn").addClass("disabled");
  $("#inst-course tr").removeClass("is-selected");
}

function fillDetailForm(course) {
  var todayStr = toDateStr(new Date());
  var isEnded = (course.end_date && todayStr > course.end_date) || String(course.cos_sta_code) === "-1";
  var isStarted = course.start_date && todayStr >= course.start_date;

  // is-error 초기화
  $(".ckj-content input, .ckj-content select, .ckj-content textarea").removeClass("is-error");

  // 편집 가능 상태로 전환
  $("#course-title, #end_date, #content, #plan, #notice").prop("readonly", isEnded);
  // 시작된 강의는 시작일 수정 불가
  $("#start_date").prop("readonly", isEnded || isStarted);
  $("#class-id, #time-code, #sub-prof").prop("disabled", isEnded);

  // 종강/거절 시 저장/삭제 버튼 disabled
  if (isEnded) {
    $("#save-btn, #delete-btn").addClass("disabled");
  }

  selectedCourse = course;
  $("#course-id").val(course.course_id || "");
  $("#class-id").val(course.class_id || "");
  $("#time-code").val(course.time_code || "");
  $("#course-title").val(course.title || "");
  $("#start_date").val(course.start_date || "");
  $("#end_date").val(course.end_date || "");
  // 종료일은 시작일 이후만 가능
  if (course.start_date) {
    $("#end_date").attr("min", course.start_date);
  }
  $("#sub-prof").val(course.sub_prof || "");
  $("#content").val(course.content || "");
  $("#plan").val(course.plan || "");
  $("#notice").val(course.notice || "");
  $("#save-btn").addClass("disabled");
  $("#inst-course tr").removeClass("is-selected");
  $('#inst-course tr[data-id="' + course.course_id + '"]').addClass(
    "is-selected",
  );
}

$(function () {
  if ($("#save-btn").length === 0) return; // courseView.jsp에서만 실행

  // 페이지 로드 시 미선택 상태로 초기화
  setFormUnselected();

  // 목록 렌더 완료 후 최초 1회만 이전 선택 행 자동 복원
  var didAutoSelect = false;
  window.onListRendered = function () {
    if (didAutoSelect) return;
    var id = sessionStorage.getItem("ckj_selected_course_id");
    if (!id) return;
    var $row = $('#inst-course tr[data-id="' + id + '"]');
    if ($row.length) {
      didAutoSelect = true;
      $row.trigger("click");
    }
  };

  // 행 클릭 → 상세 조회
  $(document).on("click", "#inst-course tr", function () {
    var courseId = $(this).data("id");
    if (!courseId) return;
    $.post("/inst/getCourseDetail", { course_id: courseId }, function (data) {
      if (data.result === "SUCCESS" && data.course) {
        fillDetailForm(data.course);
      }
    });
  });

  // 필드 변경 → 저장 버튼 활성화
  $(document).on(
    "input change",
    ".ckj-content input:not([readonly]), .ckj-content select, .ckj-content textarea",
    function () {
      if (selectedCourse) {
        $("#save-btn").removeClass("disabled");
      }
    },
  );

  // 종료일 변경 시 시작일 이전 불가 체크
  $(document).on("change", "#end_date", function () {
    var startVal = $("#start_date").val();
    var endVal = $(this).val();
    if (startVal && endVal && endVal < startVal) {
      $(this).addClass("is-error").focus();
      $(this).val(startVal);
    } else {
      $(this).removeClass("is-error");
    }
  });

  // 시작일 변경 시 종료일 min 갱신
  $(document).on("change", "#start_date", function () {
    var startVal = $(this).val();
    if (startVal) {
      $("#end_date").attr("min", startVal);
      if ($("#end_date").val() && $("#end_date").val() < startVal) {
        $("#end_date").val(startVal);
      }
    }
  });

  // 저장 버튼
  $(document).on("click", "#save-btn", function () {
    if ($(this).hasClass("disabled") || !selectedCourse) return;

    // required 검증
    var valid = true;
    $(".ckj-content input, .ckj-content select, .ckj-content textarea").removeClass("is-error");
    var requiredFields = [
      { sel: "#course-title", label: "강의명" },
      { sel: "#start_date", label: "시작일자" },
      { sel: "#end_date", label: "종료일자" },
      { sel: "#class-id", label: "강의실" },
      { sel: "#time-code", label: "차시" }
    ];
    for (var i = requiredFields.length - 1; i >= 0; i--) {
      var $f = $(requiredFields[i].sel);
      if (!$f.val()) {
        $f.addClass("is-error").focus();
        valid = false;
      }
    }
    if (!valid) return;

    var params = {
      course_id: $("#course-id").val(),
      classId: $("#class-id").val(),
      time_code: $("#time-code").val(),
      title: $("#course-title").val(),
      start_date: $("#start_date").val(),
      end_date: $("#end_date").val(),
      sub_prof: $("#sub-prof").val(),
      content: $("#content").val(),
      plan: $("#plan").val(),
      notice: $("#notice").val(),
    };
    $.post("/inst/modifyCoursePlan", params, function (data) {
      if (data.result === "SUCCESS") {
        alert("저장되었습니다.");
        $("#save-btn").addClass("disabled");
        fetchCourseList(CKJ_PAGER.currentPage, CKJ_PAGER.lastFilter);
      } else {
        alert(data.resultMsg || "저장에 실패했습니다.");
      }
    });
  });

  // 취소 버튼
  $(document).on("click", "#cancel-btn", function () {
    if (selectedCourse) fillDetailForm(selectedCourse);
  });

  // 삭제 버튼
  $(document).on("click", "#delete-btn", function () {
    if (!selectedCourse) return;
    if (!confirm("강의를 삭제하시겠습니까?")) return;
    $.post(
      "/inst/deleteCoursePlan",
      { course_id: selectedCourse.course_id },
      function (data) {
        if (data.result === "SUCCESS") {
          alert("삭제되었습니다.");
          setFormUnselected();
          fetchCourseList(1, CKJ_PAGER.lastFilter);
        } else {
          alert(data.resultMsg || "삭제에 실패했습니다.");
        }
      },
    );
  });
});

// =============================================
// 출석 관리 기능 (attendanceView.jsp 전용)
// =============================================
var stuListCache = []; // 수강생 합계 목록
var attDetailCache = []; // 날짜별 출석 상세 목록
var attCourseIsActive = true; // 선택된 강의가 진행중인지 여부

function loadStuList(courseId) {
  $.ajax({
    url: "/inst/courseStudentList.json",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      course_id: String(courseId),
      currentPage: "1",
      pageSize: "9999",
    }),
    success: function (data) {
      stuListCache = data.list || [];
      filterAndRenderStuList();
    },
  });
}

function filterAndRenderStuList() {
  var term = $("#stu-search-input").val().trim();
  var filtered = term
    ? stuListCache.filter(function (s) {
        return (s.stu_name || "").indexOf(term) >= 0;
      })
    : stuListCache;
  var $tbody = $("#stu-list-body");
  $tbody.empty();
  if (!filtered || filtered.length === 0) {
    $tbody.html('<tr><td colspan="8">수강생이 없습니다.</td></tr>');
    return;
  }
  filtered.forEach(function (s, i) {
    var isFailed = String(s.stu_cou_sta_code) === "2";
    // 미확인 = 전체수업일수 - (출석+지각+조퇴+외출+결석)
    var confirmed = (s.att_cnt || 0) + (s.att_per_cnt || 0) + (s.att_leav_cnt || 0) + (s.att_out_cnt || 0) + (s.att_abs_cnt || 0);
    var totalDays = parseInt($("#total-class-days").text()) || 0;
    var unconfirmed = Math.max(totalDays - confirmed, 0);
    $tbody.append(
      '<tr' + (isFailed ? ' class="ckj-stu-disabled"' : '') + '>' +
        "<td>" +
        (i + 1) +
        "</td>" +
        "<td>" +
        (s.stu_name || "") +
        (isFailed ? ' <span style="font-size:10px;color:#999">(낙제)</span>' : '') +
        "</td>" +
        "<td>" +
        unconfirmed +
        "</td>" +
        "<td>" +
        (s.att_cnt || 0) +
        "</td>" +
        "<td>" +
        (s.att_per_cnt || 0) +
        "</td>" +
        "<td>" +
        (s.att_leav_cnt || 0) +
        "</td>" +
        "<td>" +
        (s.att_out_cnt || 0) +
        "</td>" +
        "<td>" +
        (s.att_abs_cnt || 0) +
        "</td>" +
        "</tr>",
    );
  });
}

function loadAttDetail(courseId, date) {
  $.ajax({
    url: "/inst/stuAttDtlList.json",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      course_id: String(courseId),
      date: date,
      currentPage: "1",
      pageSize: "9999",
    }),
    success: function (data) {
      attDetailCache = data.list || [];
      renderAttDetail(attDetailCache, date, courseId);
      updateSaveAllBtn();
    },
  });
}

// att_sta_code: ''=미확인, '1'=출석, '2'=지각, '3'=조퇴, '4'=외출, '0'=결석
var ATT_STAT_CODES = ["", "1", "2", "3", "4", "0"];

function renderAttDetail(list, date, courseId) {
  var $tbody = $("#att-detail-body");
  $tbody.empty();
  if (!list || list.length === 0) {
    $tbody.html('<tr><td colspan="9">데이터가 없습니다.</td></tr>');
    return;
  }
  // 낙제 학생 loginID 맵 (stuListCache 기반)
  var failedMap = {};
  stuListCache.forEach(function (s) {
    if (String(s.stu_cou_sta_code) === "2") failedMap[s.stu_loginID] = true;
  });
  list.forEach(function (s, i) {
    var attCode = s.att_code || 0;
    var currentVal = attCode > 0 ? String(s.att_sta_code) : "";
    var isFailed = failedMap[s.loginID] || false;
    var disabledAttr = (!attCourseIsActive || isFailed) ? " disabled" : "";
    var radioTds = ATT_STAT_CODES.map(function (val) {
      var chk = val === currentVal ? " checked" : "";
      return (
        '<td><input type="radio" name="att-radio-' +
        i +
        '" data-idx="' +
        i +
        '" value="' +
        val +
        '"' +
        chk +
        disabledAttr +
        "></td>"
      );
    }).join("");
    var $tr = $("<tr>").attr({
      "data-idx": i,
      "data-att-code": attCode,
      "data-login-id": s.loginID || "",
      "data-course-id": courseId,
      "data-date": date,
    });
    if (isFailed) $tr.addClass("ckj-stu-disabled");
    $tr.html(
      "<td>" +
        (i + 1) +
        "</td>" +
        "<td>" +
        (s.stu_nm || "") +
        (isFailed ? ' <span style="font-size:10px;color:#999">(낙제)</span>' : '') +
        "</td>" +
        radioTds +
        '<td><button class="ckj-btn att-row-save-btn" disabled data-idx="' +
        i +
        '">저장</button></td>',
    );
    $tbody.append($tr);
  });
}

function updateSaveAllBtn() {
  var $rows = $("#att-detail-body tr[data-idx]");
  if ($rows.length === 0 || !attCourseIsActive) {
    $("#att-save-all-btn").prop("disabled", true).addClass("disabled");
    $("#att-save-warning").addClass("ckj-hidden");
    return;
  }
  var hasConfirmed = false;
  var hasUnconfirmed = false;
  $rows.each(function () {
    var idx = $(this).data("idx");
    var val = $('input[name="att-radio-' + idx + '"]:checked').val();
    if (val !== "" && val !== undefined) {
      hasConfirmed = true;
    } else {
      hasUnconfirmed = true;
    }
  });
  if (hasConfirmed) {
    $("#att-save-all-btn").prop("disabled", false).removeClass("disabled");
  } else {
    $("#att-save-all-btn").prop("disabled", true).addClass("disabled");
  }
  if (hasUnconfirmed) {
    $("#att-save-warning").removeClass("ckj-hidden");
  } else {
    $("#att-save-warning").addClass("ckj-hidden");
  }
}

function saveAttRow($tr, callback) {
  var idx = $tr.data("idx");
  var attCode = parseInt($tr.data("att-code")) || 0;
  var loginId = $tr.data("login-id");
  var courseId = $tr.data("course-id");
  var date = $tr.data("date");
  var val = $('input[name="att-radio-' + idx + '"]:checked').val();
  if (val === "" || val === undefined) {
    if (callback) callback(true);
    return;
  }
  var attStaCode = parseInt(val);

  if (attCode > 0) {
    $.ajax({
      url: "/inst/modifyStuAtt",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        attendance_code: attCode,
        att_sta_code: attStaCode,
      }),
      success: function (d) {
        if (callback) callback(d.resultMsg === "SUCCESS");
      },
      error: function () {
        if (callback) callback(false);
      },
    });
  } else {
    $.ajax({
      url: "/inst/stuAttDtlReg",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify([
        {
          course_id: String(courseId),
          date: date,
          loginID: loginId,
          att_sta_code: attStaCode,
          attendance_code: 0,
        },
      ]),
      success: function (d) {
        if (callback) callback(d.resultMsg === "SUCCESS");
      },
      error: function () {
        if (callback) callback(false);
      },
    });
  }
}

$(function () {
  if ($("#att-date-input").length === 0) return; // attendanceView.jsp에서만 실행

  // 목록 렌더 완료 후 최초 1회만 이전 선택 행 자동 복원
  var didAutoSelect = false;
  window.onListRendered = function () {
    if (didAutoSelect) return;
    var id = sessionStorage.getItem("ckj_selected_course_id");
    if (!id) return;
    var $row = $('#inst-course tr[data-id="' + id + '"]');
    if ($row.length) {
      didAutoSelect = true;
      $row.trigger("click");
    }
  };

  // 날짜 초기값: 오늘, max: 오늘
  var todayStr = new Date().toISOString().slice(0, 10);
  $("#att-date-input").val(todayStr).attr("max", todayStr);

  // 이전 날 버튼
  $(document).on("click", "#att-prev-btn", function () {
    var $input = $("#att-date-input");
    var d = new Date($input.val() + "T00:00:00");
    d.setDate(d.getDate() - 1);
    $input.val(toDateStr(d)).trigger("change");
  });

  // 오늘 버튼
  $(document).on("click", "#att-today-btn", function () {
    $("#att-date-input")
      .val(new Date().toISOString().slice(0, 10))
      .trigger("change");
  });

  // 다음 날 버튼 (오늘 이후로 이동 불가)
  $(document).on("click", "#att-next-btn", function () {
    var $input = $("#att-date-input");
    var today = new Date().toISOString().slice(0, 10);
    var current = $input.val();
    if (current >= today) return;
    var d = new Date(current + "T00:00:00");
    d.setDate(d.getDate() + 1);
    $input.val(toDateStr(d)).trigger("change");
  });

  // 평일 수업일수 계산 (토/일 제외)
  function countWeekdaysInst(startStr, endStr) {
    if (!startStr || !endStr) return 0;
    var sd = new Date(startStr + "T00:00:00");
    var ed = new Date(endStr + "T00:00:00");
    var count = 0;
    var cur = new Date(sd);
    while (cur <= ed) {
      var dow = cur.getDay();
      if (dow !== 0 && dow !== 6) count++;
      cur.setDate(cur.getDate() + 1);
    }
    return count;
  }

  // 강의 행 클릭
  $(document).on("click", "#inst-course tr", function () {
    var courseId = $(this).data("id");
    if (!courseId) return;
    var startDate = String($(this).data("start") || "");
    var endDate = String($(this).data("end") || "");
    attCourseIsActive = !!(
      startDate &&
      endDate &&
      todayStr >= startDate &&
      todayStr <= endDate
    );
    $("#att-selected-course-id").val(courseId);
    $("#inst-course tr").removeClass("is-selected");
    $(this).addClass("is-selected");

    // 수업일수 표시 (평일 기준)
    var totalDays = countWeekdaysInst(startDate, endDate);
    var currentDays = countWeekdaysInst(startDate, todayStr > endDate ? endDate : todayStr);
    $("#total-class-days").text(totalDays);
    $("#current-class-days").text(currentDays);

    // 날짜 입력 범위를 선택한 강의 기간으로 제한
    if (startDate) $("#att-date-input").attr("min", startDate);
    if (endDate) $("#att-date-input").attr("max", endDate);

    // 현재 날짜를 강의 기간 내로 조정
    var dateToUse = todayStr;
    if (endDate && todayStr > endDate) dateToUse = endDate;
    if (startDate && todayStr < startDate) dateToUse = startDate;
    $("#att-date-input").val(dateToUse);

    loadStuList(courseId);
    loadAttDetail(courseId, dateToUse);
  });

  // 날짜 변경
  $(document).on("change", "#att-date-input", function () {
    var courseId = $("#att-selected-course-id").val();
    if (!courseId) return;
    loadAttDetail(courseId, $(this).val());
  });

  // 학생 검색
  $(document).on("click", "#stu-search-btn", filterAndRenderStuList);
  $(document).on("keydown", "#stu-search-input", function (e) {
    if (e.key === "Enter") filterAndRenderStuList();
  });

  // 라디오 변경 → 행 저장 버튼 활성화 + 전체 저장 버튼 상태 갱신
  $(document).on("change", '#att-detail-body input[type="radio"]', function () {
    var idx = $(this).data("idx");
    $('#att-detail-body tr[data-idx="' + idx + '"] .att-row-save-btn').prop(
      "disabled",
      false,
    );
    updateSaveAllBtn();
  });

  // thead th 더블클릭 → 모든 학생 해당 열로 일괄 설정
  // 컬럼 순서: 번호(0) 학생명(1) 미확인(2) 출석(3) 지각(4) 조퇴(5) 외출(6) 결석(7) 저장(8)
  $(document).on("dblclick", ".ckj-content-attendance thead th", function () {
    if (!attCourseIsActive) return;
    var colIdx = $(this).index();
    var attCodeIdx = colIdx - 2; // ATT_STAT_CODES 인덱스
    if (attCodeIdx < 0 || attCodeIdx > 5) return;
    var val = ATT_STAT_CODES[attCodeIdx];
    $("#att-detail-body tr[data-idx]").each(function () {
      var idx = $(this).data("idx");
      $('input[name="att-radio-' + idx + '"][value="' + val + '"]').prop(
        "checked",
        true,
      );
      $(this).find(".att-row-save-btn").prop("disabled", false);
    });
    updateSaveAllBtn();
  });

  // 행별 저장
  $(document).on("click", ".att-row-save-btn", function () {
    var $tr = $(this).closest("tr");
    saveAttRow($tr, function (ok) {
      if (ok) {
        var courseId = $("#att-selected-course-id").val();
        var date = $("#att-date-input").val();
        loadStuList(courseId);
        loadAttDetail(courseId, date);
      } else {
        alert("저장에 실패했습니다.");
      }
    });
  });

  // 전체 저장
  $(document).on("click", "#att-save-all-btn", function () {
    if ($(this).hasClass("disabled") || $(this).prop("disabled")) return;
    var $rows = $("#att-detail-body tr[data-idx]");
    if ($rows.length === 0) return;

    var newRecs = [],
      modRecs = [];
    $rows.each(function () {
      var idx = $(this).data("idx");
      var code = parseInt($(this).data("att-code")) || 0;
      var val = $('input[name="att-radio-' + idx + '"]:checked').val();
      if (val === "" || val === undefined) return;
      var sta = parseInt(val);
      if (code > 0) {
        modRecs.push({ attendance_code: code, att_sta_code: sta });
      } else {
        newRecs.push({
          course_id: String($(this).data("course-id")),
          date: $(this).data("date"),
          loginID: $(this).data("login-id"),
          att_sta_code: sta,
          attendance_code: 0,
        });
      }
    });

    var promises = [];
    if (newRecs.length > 0) {
      promises.push(
        $.ajax({
          url: "/inst/stuAttDtlReg",
          method: "POST",
          contentType: "application/json",
          data: JSON.stringify(newRecs),
        }),
      );
    }
    modRecs.forEach(function (r) {
      promises.push(
        $.ajax({
          url: "/inst/modifyStuAtt",
          method: "POST",
          contentType: "application/json",
          data: JSON.stringify(r),
        }),
      );
    });

    $.when
      .apply($, promises)
      .done(function () {
        alert("전체 저장되었습니다.");
        var courseId = $("#att-selected-course-id").val();
        var date = $("#att-date-input").val();
        loadStuList(courseId);
        loadAttDetail(courseId, date);
      })
      .fail(function () {
        alert("저장 중 오류가 발생했습니다.");
      });
  });

  // 취소
  $(document).on("click", "#att-cancel-btn", function () {
    $("#att-selected-course-id").val("");
    $("#stu-list-body, #att-detail-body").empty();
    $("#inst-course tr").removeClass("is-selected");
    updateSaveAllBtn();
  });
});

// =============================================
// 타임라인 기능 (courseView.jsp, coursePlanView.jsp 공통)
// =============================================
var currentWeekStart = null;

var DAY_NAMES = ["일", "월", "화", "수", "목", "금", "토"];

function getSunday(date) {
  var d = new Date(date);
  d.setDate(d.getDate() - d.getDay()); // 0=일이므로 그냥 빼면 일요일
  d.setHours(0, 0, 0, 0);
  return d;
}

function toDateStr(date) {
  var y = date.getFullYear();
  var m = String(date.getMonth() + 1).padStart(2, "0");
  var d = String(date.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + d;
}

function getWeekDates(monday) {
  var dates = [];
  for (var i = 0; i < 7; i++) {
    var d = new Date(monday);
    d.setDate(d.getDate() + i);
    dates.push(d);
  }
  return dates;
}

function getWeekLabel(sunday) {
  var y = sunday.getFullYear();
  var m = sunday.getMonth() + 1;
  var firstDay = new Date(y, sunday.getMonth(), 1);
  var weekNum = Math.ceil((sunday.getDate() + firstDay.getDay()) / 7);
  return y + "년 " + m + "월 " + weekNum + "주차";
}

function updateTimelineHeader(sunday) {
  var weekDates = getWeekDates(sunday);
  $(".ckj-info").text(getWeekLabel(sunday));
  var today = new Date();
  today.setHours(0, 0, 0, 0);
  var $ths = $(".ckj-timeline-dates th");
  weekDates.forEach(function (d, i) {
    var $th = $($ths[i + 1]);
    var dow = d.getDay(); // 0=일, 6=토
    var isToday = d.getTime() === today.getTime();
    $th.removeClass("is-sunday is-saturday is-today");
    if (dow === 0) $th.addClass("is-sunday");
    if (dow === 6) $th.addClass("is-saturday");
    if (isToday) $th.addClass("is-today");
    $th.html(
      '<span class="date-num">' +
        d.getDate() +
        "</span>" +
        '<span class="date-day">' +
        DAY_NAMES[dow] +
        "</span>",
    );
  });
}

function renderTimelineBody(courses, monday) {
  var weekDates = getWeekDates(monday);
  var $tbody = $("#timeline-body");
  $tbody.empty();

  // 전체 강의실 목록 사용 (없으면 courses에서 추출)
  var classNames;
  if (allClassList.length > 0) {
    classNames = allClassList;
  } else {
    var classSet = {};
    courses.forEach(function (c) {
      if (c.class_name) classSet[c.class_name] = true;
    });
    classNames = Object.keys(classSet).sort();
  }

  if (classNames.length === 0) {
    $tbody.html(
      '<tr><td colspan="8" style="text-align:center;padding:12px;">이번 주 강의 없음</td></tr>',
    );
    return;
  }

  var slotClass = ["first", "second", "third"];

  classNames.forEach(function (className) {
    [1, 2, 3].forEach(function (slot, slotIdx) {
      var $tr = $("<tr>");
      if (slotIdx === 0) {
        $tr.addClass("ckj-room-first-row");
        $tr.append('<th rowspan="3">' + className + "호</th>");
      }
      weekDates.forEach(function (d) {
        var dateStr = toDateStr(d);
        var match = null;
        for (var i = 0; i < courses.length; i++) {
          var c = courses[i];
          if (
            c.class_name === className &&
            String(c.time_code) === String(slot) &&
            c.start_date <= dateStr &&
            c.end_date >= dateStr
          ) {
            match = c;
            break;
          }
        }
        var $td = $("<td>");
        if (match) {
          var instName =
            match.sInst_name ||
            (match.sub_prof
              ? instMap[match.sub_prof] || match.sub_prof
              : "미지정");
          var tooltip =
            "강의명: " +
            match.title +
            "\n강사명: " +
            instName +
            "\n기  간: " +
            match.start_date +
            " ~ " +
            match.end_date;
          $td.html(
            '<div class="ckj-timeline-event ' +
              slotClass[slotIdx] +
              '" title="' +
              tooltip +
              '">' +
              match.title +
              "</div>",
          );
        }
        $tr.append($td);
      });
      $tbody.append($tr);
    });
  });
}

function updateNavButtons(monday, hasNextWeekData) {
  var todayMonday = getSunday(new Date());
  var $prevBtn = $(".ckj-nav-btn.last-week");
  var $nextBtn = $(".ckj-nav-btn.next-week");

  // 이전주: 오늘 주 이하면 disabled
  if (monday.getTime() <= todayMonday.getTime()) {
    $prevBtn.addClass("disabled").prop("disabled", true);
  } else {
    $prevBtn.removeClass("disabled").prop("disabled", false);
  }

  // 다음주: 데이터 없으면 disabled
  if (hasNextWeekData === true) {
    $nextBtn.removeClass("disabled").prop("disabled", false);
  } else if (hasNextWeekData === false) {
    $nextBtn.addClass("disabled").prop("disabled", true);
  }
}

async function fetchAndRenderTimeline(monday) {
  if ($(".ckj-timeline-container").length === 0) return;
  var weekEnd = new Date(monday);
  weekEnd.setDate(weekEnd.getDate() + 6);
  try {
    var courses = await fetch("/inst/weeklySchedule", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        weekStart: toDateStr(monday),
        weekEnd: toDateStr(weekEnd),
      }),
    }).then(function (r) {
      return r.json();
    });
    updateTimelineHeader(monday);
    renderTimelineBody(courses, monday);

    // 이전주 버튼 즉시 갱신
    updateNavButtons(monday, null);

    // 다음주 데이터 확인 후 버튼 갱신
    var nextMonday = new Date(monday);
    nextMonday.setDate(nextMonday.getDate() + 7);
    var nextWeekEnd = new Date(nextMonday);
    nextWeekEnd.setDate(nextWeekEnd.getDate() + 6);
    var nextCourses = await fetch("/inst/weeklySchedule", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        weekStart: toDateStr(nextMonday),
        weekEnd: toDateStr(nextWeekEnd),
      }),
    }).then(function (r) {
      return r.json();
    });
    updateNavButtons(
      monday,
      Array.isArray(nextCourses) && nextCourses.length > 0,
    );
  } catch (err) {
    console.error("fetchAndRenderTimeline 오류:", err);
  }
}

$(function () {
  if ($(".ckj-timeline-container").length === 0) return;

  currentWeekStart = getSunday(new Date());
  // fetchAndRenderTimeline은 loadCommonData().then()에서 호출됨 (allClassList 로드 보장)

  // 이전주
  $(document).on("click", ".ckj-nav-btn.last-week", function () {
    currentWeekStart.setDate(currentWeekStart.getDate() - 7);
    fetchAndRenderTimeline(currentWeekStart);
  });

  // 다음주
  $(document).on("click", ".ckj-nav-btn.next-week", function () {
    currentWeekStart.setDate(currentWeekStart.getDate() + 7);
    fetchAndRenderTimeline(currentWeekStart);
  });

  // 오늘
  $(document).on("click", "#timeline-today-btn", function () {
    currentWeekStart = getSunday(new Date());
    fetchAndRenderTimeline(currentWeekStart);
  });

  // 날짜선택
  $(document).on("click", ".ckj-img-btn.calendar", function () {
    var el = document.getElementById("timeline-date-input");
    if (el) {
      if (typeof el.showPicker === "function") {
        el.showPicker();
      } else {
        el.click();
      }
    }
  });

  $(document).on("change", "#timeline-date-input", function () {
    var val = $(this).val();
    if (val) {
      currentWeekStart = getSunday(new Date(val + "T00:00:00"));
      fetchAndRenderTimeline(currentWeekStart);
    }
  });
});

// =============================================
// 신규 등록 기능 (coursePlanView.jsp 전용)
// =============================================
function resetPlanForm() {
  $("#course-title").val("");
  $("#start_date, #end_date").val("");
  $("#class-id, #time-code-form, #sub-prof").val("");
  $("#content, #plan, #notice").val("");
}

// 주말 여부 판별 (토=6, 일=0)
function isWeekend(dateStr) {
  var d = new Date(dateStr + "T00:00:00");
  var day = d.getDay();
  return day === 0 || day === 6;
}

$(function () {
  if ($("#reg-btn").length === 0) return; // coursePlanView.jsp에서만 실행

  // 행 클릭 → 강의 상세 페이지로 이동
  $(document).on("click", "#inst-course tr[data-id]", function () {
    location.href = "/inst/course-list";
  });

  // 시작일/종료일 주말 검증 + 종료일 min 갱신
  $(document).on("change", "#start_date, #end_date", function () {
    var val = $(this).val();
    if (val && isWeekend(val)) {
      $(this).addClass("is-error").focus();
      $(this).val("");
      alert("주말은 시작일/종료일로 설정할 수 없습니다.");
      return;
    }
    $(this).removeClass("is-error");
    // 시작일 변경 시 종료일 min 갱신
    if (this.id === "start_date" && val) {
      $("#end_date").attr("min", val);
      if ($("#end_date").val() && $("#end_date").val() < val) {
        $("#end_date").val("");
      }
    }
    // 종료일이 시작일 전 불가
    if (this.id === "end_date" && val) {
      var sv = $("#start_date").val();
      if (sv && val < sv) {
        $(this).addClass("is-error").focus();
        $(this).val("");
        alert("종료일은 시작일 이전으로 설정할 수 없습니다.");
      }
    }
  });

  // 등록 버튼
  $(document).on("click", "#reg-btn", function () {
    // required 검증 + is-error 처리
    $(".ckj-content input, .ckj-content select, .ckj-content textarea").removeClass("is-error");
    var valid = true;
    var requiredFields = [
      { sel: "#course-title", label: "강의명" },
      { sel: "#start_date", label: "시작일자" },
      { sel: "#end_date", label: "종료일자" },
      { sel: "#class-id", label: "강의실" },
      { sel: "#time-code-form", label: "차시" }
    ];
    for (var i = requiredFields.length - 1; i >= 0; i--) {
      var $f = $(requiredFields[i].sel);
      if (!$f.val() || !$f.val().trim()) {
        $f.addClass("is-error").focus();
        valid = false;
      }
    }
    if (!valid) return;

    var title = $("#course-title").val().trim();
    var startDate = $("#start_date").val();
    var endDate = $("#end_date").val();
    var classId = $("#class-id").val();
    var timeCode = $("#time-code-form").val();

    var params = {
      title: title,
      start_date: startDate,
      end_date: endDate,
      classId: classId,
      time_code: timeCode,
      sub_prof: $("#sub-prof").val(),
      content: $("#content").val(),
      plan: $("#plan").val(),
      notice: $("#notice").val(),
    };

    $.post("/inst/regCoursePlan", params, function (data) {
      alert("등록되었습니다.");
      resetPlanForm();
      fetchCourseList(1, CKJ_PAGER.lastFilter);
    }).fail(function (xhr) {
      var data = xhr.responseJSON;
      alert((data && data.resultMsg) || "등록에 실패했습니다.");
    });
  });

  // 초기화 버튼
  $(document).on("click", "#reset-plan-btn", function () {
    $(".ckj-content input, .ckj-content select, .ckj-content textarea").removeClass("is-error");
    resetPlanForm();
  });
});
