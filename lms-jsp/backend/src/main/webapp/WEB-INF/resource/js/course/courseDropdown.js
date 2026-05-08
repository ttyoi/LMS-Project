/**
 * courseDropdown.js
 * 강의 관련 페이지 공통: 컬럼 드롭다운 필터/정렬 시스템 + 페이지네이션
 *
 * 의존: jQuery
 * 사용하는 페이지: courseView.jsp, coursePlanView.jsp, attendanceView.jsp, courses.jsp, my-courses.jsp
 *
 * ※ fetchCourseList(page, filterList)는 각 페이지 JS에서 전역 함수로 정의해야 동작함
 * ※ fetchCourseList 완료 후 updatePagination(currentPage, totalCount, pageSize) 호출 필요
 */

// =============================================
// 페이지네이션 공통 상태 및 렌더링
// =============================================
var CKJ_PAGER = { currentPage: 1, totalPages: 1, pageSize: 5, lastFilter: {} };

function updatePagination(currentPage, totalCount, pageSize) {
  CKJ_PAGER.currentPage = currentPage || 1;
  if (pageSize) CKJ_PAGER.pageSize = pageSize;
  CKJ_PAGER.totalPages = Math.max(1, Math.ceil(totalCount / CKJ_PAGER.pageSize));

  var cur = CKJ_PAGER.currentPage;
  var total = CKJ_PAGER.totalPages;
  var $pagination = $('.ckj-pagination');

  // 번호 버튼 재생성 (현재 페이지 중심 최대 5개)
  $pagination.find('.ckj-nav-btn:not(.first):not(.prev):not(.next):not(.last)').remove();
  var $nextBtn = $pagination.find('.ckj-nav-btn.next');
  var startPage = Math.max(1, cur - 2);
  var endPage = Math.min(total, startPage + 4);
  startPage = Math.max(1, endPage - 4);
  for (var p = startPage; p <= endPage; p++) {
    var $btn = $('<button class="ckj-btn ckj-nav-btn" data-page="' + p + '">' + p + '</button>');
    if (p === cur) $btn.addClass('active');
    $nextBtn.before($btn);
  }

  // first/prev/next/last 비활성화
  $pagination.find('.ckj-nav-btn.first, .ckj-nav-btn.prev').toggleClass('disabled', cur <= 1);
  $pagination.find('.ckj-nav-btn.next, .ckj-nav-btn.last').toggleClass('disabled', cur >= total);
}

$(function () {

  // =============================================
  // 정렬 상태
  // =============================================
  var sortState = { col: null, dir: null };

  // =============================================
  // 드롭다운 열기/닫기
  // =============================================
  function closeAllDropdowns() {
    $('.ckj-col-dropdown').removeClass('is-open').css({ top: '', left: '', right: '' });
    $('.ckj-col-menu-btn').removeClass('is-open');
  }

  // 버튼 클릭 → 해당 드롭다운 좌표 계산 후 열기 (버튼 오른쪽 끝 기준 왼쪽하단)
  $(document).on('click', '.ckj-col-menu-btn', function (e) {
    e.stopPropagation();
    var $btn = $(this);
    var $th = $btn.closest('.ckj-col-th');
    var $dropdown = $th.find('.ckj-col-dropdown');
    var isAlreadyOpen = $dropdown.hasClass('is-open');
    closeAllDropdowns();
    if (!isAlreadyOpen) {
      var rect = this.getBoundingClientRect();
      $dropdown.css({
        top:   (rect.bottom + 4) + 'px',
        right: (window.innerWidth - rect.right) + 'px',
        left:  'auto'
      });
      $dropdown.addClass('is-open');
      $btn.addClass('is-open');
    }
  });

  // 외부 클릭 시 닫기: 타겟이 드롭다운 또는 헤더 th 안이면 닫지 않음
  // (네이티브 select 옵션 선택 시 document에 직접 발사되는 이벤트도 정확히 처리)
  $(document).on('click', function (e) {
    if (!$(e.target).closest('.ckj-col-dropdown, .ckj-col-th').length) {
      closeAllDropdowns();
    }
  });
  $(window).on('scroll resize', function () { closeAllDropdowns(); });

  // =============================================
  // 정렬 버튼 (단일 선택, 재클릭 시 해제)
  // =============================================
  $(document).on('click', '.ckj-sort-btn', function () {
    var $th = $(this).closest('.ckj-col-th');
    var col = $th.data('col');
    var dir = $(this).data('dir');
    if (sortState.col === col && sortState.dir === dir) {
      sortState = { col: null, dir: null };
      $(this).removeClass('is-active');
      $th.find('.ckj-sort-icon').text('↕');
      $th.find('.ckj-col-menu-btn').removeClass('is-sorted');
    } else {
      $('.ckj-sort-btn').removeClass('is-active');
      $('.ckj-sort-icon').text('↕');
      $('.ckj-col-menu-btn').removeClass('is-sorted');
      $(this).addClass('is-active');
      sortState = { col: col, dir: dir };
      $th.find('.ckj-sort-icon').text(dir === 'asc' ? '↑' : '↓');
      $th.find('.ckj-col-menu-btn').addClass('is-sorted');
    }
  });

  // =============================================
  // 적용 / 초기화 버튼
  // =============================================
  $(document).on('click', '.ckj-apply-btn', function () {
    closeAllDropdowns();
    applyFilters();
  });

  $(document).on('click', '.ckj-reset-btn', function () {
    var $th = $(this).closest('.ckj-col-th');
    var col = $th.data('col');
    $th.find('input[type="text"], select').val('');
    $th.find('input[type="date"]').val('');
    $th.find('input[type="checkbox"]').prop('checked', false);
    if (sortState.col === col) {
      sortState = { col: null, dir: null };
      $th.find('.ckj-sort-btn').removeClass('is-active');
      $th.find('.ckj-sort-icon').text('↕');
      $th.find('.ckj-col-menu-btn').removeClass('is-sorted');
    }
    $th.find('.ckj-col-menu-btn').removeClass('is-filtered');
    closeAllDropdowns();
    applyFilters();
  });

  // =============================================
  // applyFilters: 필터 수집 → fetchCourseList 호출
  // =============================================
  function applyFilters() {
    var filterList = {};

    // 텍스트·날짜·셀렉트
    $('input.ckj-col-filter[type!="checkbox"], select.ckj-col-filter').each(function () {
      var param = $(this).data('param');
      var val = $(this).val();
      if (val) filterList[param] = val;
    });

    // 체크박스 (같은 param 콤마 합산 → FIND_IN_SET)
    var checkedGroups = {};
    $('input.ckj-col-filter[type="checkbox"]:checked').each(function () {
      var param = $(this).data('param');
      if (!checkedGroups[param]) checkedGroups[param] = [];
      checkedGroups[param].push($(this).val());
    });
    $.each(checkedGroups, function (param, vals) { filterList[param] = vals.join(','); });

    // 정렬 (oname/order 파라미터)
    if (sortState.col) {
      var colMap = { title: 'title', date: 'start_date', stu: 'stu_cnt' };
      filterList['oname'] = colMap[sortState.col] || '';
      filterList['order'] = sortState.dir === 'asc' ? 'ASC' : 'DESC';
    }

    // is-filtered 인디케이터 업데이트
    $('.ckj-col-th').each(function () {
      var hasFilter = $(this).find('.ckj-col-filter').toArray().some(function (el) {
        return el.type === 'checkbox' ? el.checked : el.value !== '';
      });
      $(this).find('.ckj-col-menu-btn').toggleClass('is-filtered', hasFilter);
    });

    // lastFilter 저장 (페이지네이션에서 재사용)
    CKJ_PAGER.lastFilter = filterList;

    // 각 페이지 JS에서 전역 함수로 정의된 fetchCourseList 호출
    if (typeof fetchCourseList === 'function') {
      fetchCourseList(1, filterList);
    }
  }

  // =============================================
  // 페이지네이션 버튼 클릭
  // =============================================
  $(document).on('click', '.ckj-nav-btn', function () {
    var $btn = $(this);
    if ($btn.hasClass('disabled') || $btn.hasClass('active')) return;

    var cur = CKJ_PAGER.currentPage;
    var total = CKJ_PAGER.totalPages;
    var page;

    if ($btn.hasClass('first'))       page = 1;
    else if ($btn.hasClass('prev'))   page = Math.max(1, cur - 1);
    else if ($btn.hasClass('next'))   page = Math.min(total, cur + 1);
    else if ($btn.hasClass('last'))   page = total;
    else                              page = parseInt($btn.data('page'), 10);

    if (page && typeof fetchCourseList === 'function') {
      fetchCourseList(page, CKJ_PAGER.lastFilter);
    }
  });

});
