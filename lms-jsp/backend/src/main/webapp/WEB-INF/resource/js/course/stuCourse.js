/**
 * stuCourse.js
 * 학생 강의 관련 페이지 공통: 강의 목록 조회 + 공통 데이터 로드 + 수강신청 상태 관리
 *
 * 의존: jQuery, courseDropdown.js (먼저 로드해야 함)
 * 사용하는 페이지: student/scourse/courses.jsp, student/scourse/my-courses.jsp
 *
 * ※ 페이지별 동작 분기: JSP에서 stuCourse.js 로드 전에 window.CKJ_STU_CONFIG를 정의하면 오버라이드 가능
 *
 * SCourseListDTO 필드 (courses.jsp):
 *   course_id, title, name(강사명), start_date(LocalDate), end_date(LocalDate),
 *   class_name, time_code(int), people_limit, stu_num, apply_status(String), cos_sta_code
 *
 * SMyCourseListDTO 필드 (my-courses.jsp):
 *   course_id, title, name(강사명), class_name, start_time, end_time, scs_name, status
 */

// =============================================
// 페이지별 설정 (JSP에서 stuCourse.js 로드 전에 오버라이드 가능)
// =============================================
var CKJ_STU_CONFIG = window.CKJ_STU_CONFIG || {
  listUrl: '/stu/courses/loadAllCourse',
  colSpan: 7,
  renderRow: function(course, index, params) { return renderCourseRow(course, index, params); },
  detailUrl: '/stu/courses/courseDetail',
  fillDetail: function(d) { fillCourseDetail(d); }
};

// =============================================
// 강의 목록 조회 (AJAX) — courseDropdown.js의 applyFilters()에서 호출
// =============================================
async function fetchCourseList(currentPage, filterList) {
  var params = Object.assign({
    currentPage: 1,
    pageSize: 10,
    title: '',
    search_sdate: '',
    search_edate: '',
    course_class: '',
    time_code: '',
    status: ''
  }, filterList || {}, { currentPage: currentPage || 1 });

  try {
    var response = await fetch(CKJ_STU_CONFIG.listUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams(params)
    });
    var list = await response.json();
    $('#inst-course').empty();
    if (!list || list.length === 0) {
      $('#inst-course').html('<tr class="ckj-empty-row"><td colspan="' + CKJ_STU_CONFIG.colSpan + '">조회된 강의가 없습니다.</td></tr>');
      updatePagination(params.currentPage, 0, params.pageSize);
      return;
    }
    var html = '';
    list.forEach(function (course, index) {
      html += CKJ_STU_CONFIG.renderRow(course, index, params);
    });
    $('#inst-course').html(html);
    updateDynamicFilters(list);
    // TODO: 백엔드 API가 totalCount를 반환하면 정확한 값으로 교체 필요
    // 현재는 pageSize 미만이면 마지막 페이지, 이상이면 다음 페이지 있다고 추정
    var estimatedTotal = list.length < params.pageSize
      ? (params.currentPage - 1) * params.pageSize + list.length
      : params.currentPage * params.pageSize + 1;
    updatePagination(params.currentPage, estimatedTotal, params.pageSize);
  } catch (err) {
    console.error('fetchCourseList 오류:', err);
  }
}

// =============================================
// courses.jsp 행 렌더링 (SCourseListDTO)
// =============================================
function renderCourseRow(course, index, params) {
  var rowNum = (params.currentPage - 1) * params.pageSize + index + 1;
  var period = formatDate(course.start_date) + ' ~ ' + formatDate(course.end_date);
  return '<tr data-id="' + course.course_id + '">'
    + '<td>' + rowNum + '</td>'
    + '<td>' + (course.title || '') + '</td>'
    + '<td>' + (course.name || '') + '</td>'
    + '<td>' + period + '</td>'
    + '<td>' + (course.class_name || '') + '</td>'
    + '<td>' + (course.time_code ? course.time_code + '차시' : '') + '</td>'
    + '<td>' + renderApplyStatus(course) + '</td>'
    + '</tr>';
}

// =============================================
// my-courses.jsp 행 렌더링 (SMyCourseListDTO)
// =============================================
function renderMyCourseRow(course, index, params) {
  var rowNum = (params.currentPage - 1) * params.pageSize + index + 1;
  var timeRange = (course.start_time && course.end_time) ? course.start_time + '~' + course.end_time : '';
  return '<tr data-id="' + course.course_id + '">'
    + '<td>' + rowNum + '</td>'
    + '<td>' + (course.title || '') + '</td>'
    + '<td>' + (course.name || '') + '</td>'
    + '<td>' + timeRange + '</td>'
    + '<td>' + (course.class_name || '') + '</td>'
    + '<td></td>'
    + '<td>' + (course.scs_name || '') + '</td>'
    + '</tr>';
}

// =============================================
// 수강신청 상태 뱃지 (apply_status 값 기준)
// =============================================
function renderApplyStatus(course) {
  // 종강 여부 판별
  var endDate = formatDate(course.end_date);
  var todayStr = new Date().toISOString().slice(0, 10);
  if (endDate && todayStr > endDate) {
    return '<span class="ckj-status-badge ended">종강</span>';
  }
  var status = course.apply_status || '';
  if (status === '신청 완료' || status === '신청완료') {
    return '<span class="ckj-status-badge applied">신청완료</span>';
  }
  if (course.isCapacityFull || status === '정원 초과' || status === '정원마감') {
    return '<span class="ckj-status-badge full">정원마감</span>';
  }
  return '<span class="ckj-status-badge open">모집중</span>';
}

// =============================================
// LocalDate 포맷 헬퍼 (Jackson 직렬화: 배열 or 문자열 모두 처리)
// =============================================
function formatDate(val) {
  if (!val) return '';
  // Jackson LocalDate 기본: [2026, 3, 18]
  if (Array.isArray(val)) {
    var y = val[0], m = String(val[1]).padStart(2, '0'), d = String(val[2]).padStart(2, '0');
    return y + '-' + m + '-' + d;
  }
  return String(val);
}

// =============================================
// 동적 필터 옵션 업데이트 (강의실 체크박스 + 강사명 셀렉트)
// =============================================
function updateDynamicFilters(list) {
  // 강의실 체크박스
  var classNames = new Set();
  list.forEach(function (c) { if (c.class_name) classNames.add(c.class_name); });
  var $checkboxList = $('[data-col="room"] .ckj-checkbox-list');
  $checkboxList.empty();
  classNames.forEach(function (name) {
    $checkboxList.append(
      '<label><input type="checkbox" class="ckj-col-filter" data-param="course_class" value="' + name + '"> ' + name + '</label>'
    );
  });

  // 강사명 셀렉트 (data-col="inst")
  var $instSelect = $('[data-col="inst"] select.ckj-col-filter');
  if ($instSelect.length) {
    var instNames = new Set();
    list.forEach(function (c) { if (c.name) instNames.add(c.name); });
    $instSelect.find('option:not(:first)').remove();
    instNames.forEach(function (name) {
      $instSelect.append('<option value="' + name + '">' + name + '</option>');
    });
  }
}

// =============================================
// 공통 데이터 로드 (차시 셀렉트)
// =============================================
async function loadCommonData() {
  try {
    var timeList = await fetch('/common/coursetimelist').then(function (r) { return r.json(); });
    var $timeSelect = $('[data-col="time"] select.ckj-col-filter');
    $timeSelect.find('option:not(:first)').remove();
    timeList.forEach(function (t) {
      $timeSelect.append('<option value="' + t.time_code + '">' + t.time_code + '차시 (' + t.start_time + '~' + t.end_time + ')</option>');
    });
  } catch (err) {
    console.error('loadCommonData 오류:', err);
  }
}

// =============================================
// 초기화
// =============================================
$(function () {
  loadCommonData();
  fetchCourseList();
});

// =============================================
// 행 클릭 → 강의 상세 조회
// =============================================
$(function () {
  $(document).on('click', '#inst-course tr', function () {
    var courseId = $(this).data('id');
    if (!courseId) return;
    var loginId = $('#login-id').val() || '';
    var url = CKJ_STU_CONFIG.detailUrl + '?course_id=' + courseId
      + (loginId ? '&loginID=' + encodeURIComponent(loginId) : '');
    $.get(url, function (detail) {
      if (detail && typeof CKJ_STU_CONFIG.fillDetail === 'function') {
        CKJ_STU_CONFIG.fillDetail(detail);
      }
      $('#inst-course tr').removeClass('is-selected');
      $('#inst-course tr[data-id="' + courseId + '"]').addClass('is-selected');
    });
  });
});

// =============================================
// courses.jsp 상세 채우기 (SCourseDetailDTO)
// =============================================
function fillCourseDetail(d) {
  $('#course-title').val(d.title || '');
  $('#inst-name').val(d.professor || '');
  $('#sub-prof-name').val(d.sub_prof || '');
  $('#period').val((d.start_date || '') + ' ~ ' + (d.end_date || ''));
  $('#stu-count').val((d.stu_num || 0) + ' / ' + (d.people_limit || 0));
  $('#class-name').val(d.class_name || '');
  var timeInfo = d.time_code ? d.time_code + '차시' : '';
  if (d.start_time && d.end_time) timeInfo += ' (' + d.start_time + '~' + d.end_time + ')';
  $('#time-info').val(timeInfo);
  $('#content').val(d.content || '');
  $('#plan').val(d.plan || '');
  $('#notice').val(d.notice || '');

  // 선택된 강의 ID 저장
  $('#selected-course-id').val(d.course_id || '');

  // 버튼 상태 분기
  var status = d.apply_status || '';
  var applied = (status === '신청완료' || status === '신청 완료');
  var disabled = !applied && (d.isCapacityFull || d.capacityFull || d.isEnrollDeadlinePassed || d.enrollDeadlinePassed);

  if (applied) {
    $('#enroll-btn').hide();
    $('#cancel-enroll-btn').show();
    $('#enroll-warning').show();
  } else {
    $('#enroll-btn').show().toggleClass('disabled', !!disabled);
    $('#cancel-enroll-btn').hide();
    $('#enroll-warning').hide();
  }
}

// =============================================
// my-courses.jsp 상세 채우기 (SMyCosDetailDTO)
// =============================================
// 평일(토/일 제외) 수업일수 계산
function countWeekdays(startStr, endStr) {
  if (!startStr || !endStr) return 0;
  var sd = new Date(startStr + 'T00:00:00');
  var ed = new Date(endStr + 'T00:00:00');
  var count = 0;
  var cur = new Date(sd);
  while (cur <= ed) {
    var dow = cur.getDay();
    if (dow !== 0 && dow !== 6) count++;
    cur.setDate(cur.getDate() + 1);
  }
  return count;
}

function fillMyCourseDetail(d) {
  $('#course-title').val(d.title || '');
  $('#inst-name').val(d.professior || ''); // DTO 오타 필드명
  $('#sub-prof-name').val(d.sub_prof || '');
  $('#inst-email').val(d.email || '');
  $('#inst-phone').val(d.phone || '');
  var timeInfo = d.time_code ? d.time_code + '차시' : '';
  if (d.start_time && d.end_time) timeInfo += ' (' + d.start_time + '~' + d.end_time + ')';
  $('#time-info').val(timeInfo);
  $('#content').val(d.content || '');
  $('#notice').val(d.notice || '');
  // 출결 현황
  $('#att-count').text((d.attendance || 0) + '일');
  $('#tard-count').text((d.tard_levEarly || 0) + '회');
  $('#abs-count').text((d.absen_sick || 0) + '회');
  // 전체 수업일수: 평일 기준 start_date ~ end_date
  var totalDays = countWeekdays(d.start_date, d.end_date);
  $('#study-days').text((d.attendance || 0) + ' / ' + totalDays + '일');

  // 선택된 강의 ID 저장
  $('#selected-course-id').val(d.course_id || '');

  // 신청취소 버튼: 수강대기 상태일 때만 표시
  if (d.stu_cou_sta_name === '수강대기') {
    $('#cancel-enroll-btn').show();
    $('#enroll-warning').show();
  } else {
    $('#cancel-enroll-btn').hide();
    $('#enroll-warning').hide();
  }
}

// =============================================
// 수강신청 / 신청취소 핸들러
// =============================================
$(function () {
  // 수강신청 버튼 (courses.jsp)
  $(document).on('click', '#enroll-btn', function () {
    if ($(this).hasClass('disabled')) return;
    var courseId = $('#selected-course-id').val();
    var loginId  = $('#login-id').val();
    if (!courseId || !loginId) { alert('강의를 선택해주세요.'); return; }
    $.post('/stu/courses/postCourse', { apply_status: 'apply', course_id: courseId, loginID: loginId },
      function (data) {
        if (data.status === '200') {
          alert('수강신청이 완료되었습니다.');
          fetchCourseList(CKJ_PAGER.currentPage, CKJ_PAGER.lastFilter);
          $.get('/stu/courses/courseDetail?course_id=' + courseId + '&loginID=' + encodeURIComponent(loginId),
            function (d) { if (d) fillCourseDetail(d); });
        } else {
          alert(data.msg || '수강신청에 실패했습니다.');
        }
      }
    );
  });

  // 신청취소 버튼 (courses.jsp + my-courses.jsp 공통)
  $(document).on('click', '#cancel-enroll-btn', function () {
    if (!confirm('수강신청을 취소하시겠습니까?')) return;
    var courseId = $('#selected-course-id').val();
    var loginId  = $('#login-id').val();
    if (!courseId || !loginId) return;
    $.post('/stu/courses/postCourse', { apply_status: 'delete', course_id: courseId, loginID: loginId },
      function (data) {
        if (data.status === '200') {
          alert('수강신청이 취소되었습니다.');
          fetchCourseList(CKJ_PAGER.currentPage, CKJ_PAGER.lastFilter);
          // 버튼 초기화
          $('#cancel-enroll-btn').hide();
          $('#enroll-warning').hide();
          if ($('#enroll-btn').length) $('#enroll-btn').show().removeClass('disabled');
        } else {
          alert(data.msg || '신청취소에 실패했습니다.');
        }
      }
    );
  });
});

// =============================================
// my-courses.jsp 버튼 라우팅
// =============================================
$(function () {
  if ($('#assignment-btn').length === 0) return;

  $(document).on('click', '#assignment-btn', function () {
    var courseId = $('#selected-course-id').val();
    if (!courseId) { alert('강의를 선택해주세요.'); return; }
    location.href = '/stu/assignments?course_id=' + courseId;
  });

  $(document).on('click', '#exam-btn', function () {
    var courseId = $('#selected-course-id').val();
    if (!courseId) { alert('강의를 선택해주세요.'); return; }
    location.href = '/stu/exams?course_id=' + courseId;
  });
});

// =============================================
// 달력 공통 헬퍼
// =============================================
function buildCalendarRows(year, month, cellFn) {
  // month: 1-based
  var firstDay = new Date(year, month - 1, 1).getDay(); // 0=일
  var lastDate = new Date(year, month, 0).getDate();
  var rows = '';
  var day = 1;
  var started = false;
  for (var week = 0; week < 6; week++) {
    if (day > lastDate) break;
    var tr = '<tr>';
    for (var dow = 0; dow < 7; dow++) {
      if (!started && dow < firstDay) {
        tr += '<td></td>';
      } else if (day > lastDate) {
        tr += '<td></td>';
      } else {
        started = true;
        var dateStr = year + '-' + String(month).padStart(2, '0') + '-' + String(day).padStart(2, '0');
        var colorClass = dow === 0 ? ' ckj-cal-sun' : (dow === 6 ? ' ckj-cal-sat' : '');
        tr += '<td class="ckj-cal-cell' + colorClass + '">'
          + '<span class="ckj-cal-day">' + day + '</span>'
          + cellFn(dateStr)
          + '</td>';
        day++;
      }
    }
    tr += '</tr>';
    rows += tr;
  }
  return rows;
}

function calLabelText(year, month) {
  return year + '년 ' + month + '월';
}

// =============================================
// courses.jsp 달력 (수강중인 강의 월별 표시)
// =============================================
$(function () {
  if ($('#courses-cal-body').length === 0) return;

  var calYear  = new Date().getFullYear();
  var calMonth = new Date().getMonth() + 1;
  var myCourseCache = [];

  function loadAndRenderCoursesCal() {
    var loginId = $('#login-id').val();
    if (!loginId) { renderCoursesCal(); return; }
    $.post('/stu/my-courses/loadMyCourse',
      { currentPage: 1, pageSize: 9999, loginID: loginId },
      function (list) {
        myCourseCache = list || [];
        renderCoursesCal();
      }
    );
  }

  function renderCoursesCal() {
    $('#courses-cal-label').text('수강중인 강의 일정 — ' + calLabelText(calYear, calMonth));
    var rows = buildCalendarRows(calYear, calMonth, function (dateStr) {
      var cell = '';
      myCourseCache.forEach(function (c) {
        var sd = c.start_date ? String(c.start_date).substring(0, 10) : '';
        var ed = c.end_date   ? String(c.end_date).substring(0, 10)   : '';
        if (!sd || !ed) return;
        if (dateStr >= sd && dateStr <= ed) {
          var tc = c.time_code || 1;
          var timeColors = { 1: 'var(--color-time-1)', 2: 'var(--color-time-2)', 3: 'var(--color-time-3)' };
          var bg = timeColors[tc] || '#e0e0e0';
          cell += '<div class="ckj-cal-event" style="background:' + bg + '" title="' + (c.title || '') + ' / ' + (c.name || '') + ' / ' + (c.class_name || '') + '">'
            + (c.title || '') + '</div>';
        }
      });
      return cell;
    });
    $('#courses-cal-body').html(rows);
  }

  loadAndRenderCoursesCal();

  $('#courses-cal-prev').on('click', function () {
    calMonth--;
    if (calMonth < 1) { calMonth = 12; calYear--; }
    loadAndRenderCoursesCal();
  });
  $('#courses-cal-today').on('click', function () {
    calYear  = new Date().getFullYear();
    calMonth = new Date().getMonth() + 1;
    loadAndRenderCoursesCal();
  });
  $('#courses-cal-next').on('click', function () {
    calMonth++;
    if (calMonth > 12) { calMonth = 1; calYear++; }
    loadAndRenderCoursesCal();
  });
});

// =============================================
// my-courses.jsp 달력 (선택 강의 출결 월별 표시)
// =============================================
$(function () {
  if ($('#my-cal-body').length === 0) return;

  var myCalYear  = new Date().getFullYear();
  var myCalMonth = new Date().getMonth() + 1;
  var myCalCourseId = null;

  // fillMyCourseDetail 호출 후 달력 갱신 트리거
  var _origFillMyCourseDetail = window.fillMyCourseDetail;
  window.fillMyCourseDetail = function (d) {
    _origFillMyCourseDetail(d);
    myCalCourseId = d.course_id || null;
    myCalYear  = new Date().getFullYear();
    myCalMonth = new Date().getMonth() + 1;
    loadAndRenderMyCourseCal();
  };

  function loadAndRenderMyCourseCal() {
    if (!myCalCourseId) {
      $('#my-cal-label').text('나의 출결 현황');
      $('#my-cal-body').html('');
      return;
    }
    var loginId = $('#login-id').val() || '';
    $.get('/stu/my-courses/myCourseAttCalendar', {
      loginID: loginId, course_id: myCalCourseId,
      year: myCalYear, month: myCalMonth
    }, function (list) {
      var attMap = {};
      (list || []).forEach(function (r) { attMap[r.att_date] = r.att_sta_code; });
      renderMyCourseCal(attMap);
    });
  }

  function renderMyCourseCal(attMap) {
    $('#my-cal-label').text('나의 출결 현황 — ' + calLabelText(myCalYear, myCalMonth));
    var codeToClass = { '1': 'present', '0': 'absent', '2': 'late', '3': 'early', '4': 'out' };
    var codeToLabel = { '1': '출석', '0': '결석', '2': '지각', '3': '조퇴', '4': '외출' };
    var rows = buildCalendarRows(myCalYear, myCalMonth, function (dateStr) {
      var code = attMap[dateStr];
      if (code === undefined || code === null) return '';
      var codeStr = String(code);
      var cls = codeToClass[codeStr] || 'unconfirmed';
      var lbl = codeToLabel[codeStr] || '';
      return '<span class="ckj-att-badge ' + cls + '">' + lbl + '</span>';
    });
    $('#my-cal-body').html(rows);
  }

  $('#my-cal-prev').on('click', function () {
    myCalMonth--;
    if (myCalMonth < 1) { myCalMonth = 12; myCalYear--; }
    loadAndRenderMyCourseCal();
  });
  $('#my-cal-today').on('click', function () {
    myCalYear  = new Date().getFullYear();
    myCalMonth = new Date().getMonth() + 1;
    loadAndRenderMyCourseCal();
  });
  $('#my-cal-next').on('click', function () {
    myCalMonth++;
    if (myCalMonth > 12) { myCalMonth = 1; myCalYear++; }
    loadAndRenderMyCourseCal();
  });
});
