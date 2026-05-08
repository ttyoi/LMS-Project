// 페이징 관련 변수
const pageSize = 10;
let currentPage = 1;

// 페이지 로드 시 첫 번째 페이지 로드
document.addEventListener('DOMContentLoaded', async () => {
    // 첫 페이지 로드
    await loadCourses();

    // 이벤트 연결
    const btnSearch = document.getElementById('btnSearch');
    const searchKeyword = document.getElementById('searchKeyword');
    const searchType = document.getElementById('searchType');

    if (btnSearch) {
        btnSearch.addEventListener('click', async e => {
            e.preventDefault();
            await loadCourses({
                keyword: searchKeyword.value.trim(),
                searchType: searchType.value,
                page: 1,
                pageSize
            });
        });
    }

    if (searchKeyword) {
        searchKeyword.addEventListener('keypress', e => {
            if (e.key === 'Enter') {
                e.preventDefault();
                btnSearch.click();
            }
        });
    }
});


// 강의신청 상태 코드 → 텍스트 매핑
const statusMap = {
    "0": "요청",
    "1": "승인",
    "2": "거절"
};

// 강의 목록 조회 및 표시 (페이징 적용)
async function loadCourses({ keyword = '', searchType = '', page = 1, pageSize = 10 } = {}) {
    try {
        // 검색 키워드가 있으면 전체 리스트 가져오기, 없으면 페이징 API 사용
        let filtered = [];

        if (keyword) {
            const res = await fetch('/admin/courseManagement/list');
            const list = await res.json();

            filtered = list.filter(c => {
                if (searchType === 'instructor') {
                    return c.name.includes(keyword);
                } else if (searchType === 'course') {
                    return c.title.includes(keyword);
                } else {
                    return c.name.includes(keyword) || c.title.includes(keyword);
                }
            });

            displayCourses(filtered);
            document.getElementById('coursePagination').innerHTML = '';
        } else {
            const res = await fetch(`/admin/courseManagement/list/paging?page=${currentPage}&pageSize=${pageSize}`);
            const data = await res.json();
            const list = data.list;

            displayCourses(list);
            renderPagination(data.totalCount, currentPage);
        }
    } catch (err) {
        console.error(err);
    }
}

// 강의 목록 표시
function displayCourses(list) {
    const container = document.getElementById('courseList');
    container.innerHTML = '';

    list.forEach(c => {
        const status = getCourseStatus(c.start_date, c.end_date);

        console.log('현재 데이터:', c);
        console.log('course_id:', c.course_id, 'title:', c.title);

        const row = document.createElement('div');
        row.className = 'content-box table-row';
        row.dataset.id = c.course_id;

        row.innerHTML = `
            <span class="col course-id">${c.course_id}</span>
            <span class="col title">${c.title}</span>
            <span class="col professor">${c.name}</span>
            <span class="col class-id">${c.class_name}</span>
            <span class="col period">${formatDate(c.start_date)} ~ ${formatDate(c.end_date)}</span>
            <span class="col req-status">${statusMap[c.cos_sta_code] || c.cos_sta_code}</span>
            <span class="col status">
                <span class="status-badge" style="${getStatusStyle(status)}">${status}</span>
            </span>
        `;

        container.appendChild(row);
    });

    bindRowEvents();
}

// 페이지네이션 UI 렌더링
function renderPagination(totalCount, page) {
    const totalPages = Math.ceil(totalCount / pageSize);
    const paginationContainer = document.getElementById('coursePagination');
    paginationContainer.innerHTML = '';

    // 이전 버튼
    const prevBtn = document.createElement('button');
    prevBtn.textContent = '이전';
    prevBtn.disabled = page <= 1;
    prevBtn.onclick = () => {
        if (page > 1) {
            currentPage = page - 1;
            loadCourses();
        }
    };
    paginationContainer.appendChild(prevBtn);

    // 페이지 번호 (앞뒤로 2페이지씩)
    const pageWindow = 5;
    const startPage = Math.max(1, page - Math.floor(pageWindow / 2));
    const endPage = Math.min(totalPages, startPage + pageWindow - 1);

    // 첫 페이지
    if (startPage > 1) {
        const firstBtn = document.createElement('button');
        firstBtn.textContent = '1';
        firstBtn.onclick = () => {
            currentPage = 1;
            loadCourses();
        };
        paginationContainer.appendChild(firstBtn);

        if (startPage > 2) {
            const dots = document.createElement('span');
            dots.textContent = '...';
            paginationContainer.appendChild(dots);
        }
    }

    // 페이지 번호 버튼
    for (let i = startPage; i <= endPage; i++) {
        const pageBtn = document.createElement('button');
        pageBtn.textContent = i;
        pageBtn.onclick = () => {
            currentPage = i;
            loadCourses();
        };

        if (i === page) {
            pageBtn.className = 'active';
        }

        paginationContainer.appendChild(pageBtn);
    }

    // 마지막 페이지
    if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
            const dots = document.createElement('span');
            dots.textContent = '...';
            paginationContainer.appendChild(dots);
        }

        const lastBtn = document.createElement('button');
        lastBtn.textContent = totalPages;
        lastBtn.onclick = () => {
            currentPage = totalPages;
            loadCourses();
        };
        paginationContainer.appendChild(lastBtn);
    }

    // 다음 버튼
    const nextBtn = document.createElement('button');
    nextBtn.textContent = '다음';
    nextBtn.disabled = page >= totalPages;
    nextBtn.onclick = () => {
        if (page < totalPages) {
            currentPage = page + 1;
            loadCourses();
        }
    };
    paginationContainer.appendChild(nextBtn);
}

// 강의 상태 판단 함수
function getCourseStatus(startDate, endDate) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const start = new Date(startDate);
    start.setHours(0, 0, 0, 0);

    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999);

    if (today < start) {
        return '강의예정';
    } else if (today >= start && today <= end) {
        return '강의중';
    } else {
        return '종강';
    }
}

// 상태에 따른 스타일
function getStatusStyle(status) {
    switch (status) {
        case '강의중':
            return 'background-color: #4CAF50; color: white;';
        case '강의예정':
            return 'background-color: #2196F3; color: white;';
        case '종강':
            return 'background-color: #f44336; color: white;';
        default:
            return '';
    }
}

// 날짜 포맷팅 (YYYY-MM-DD)
function formatDate(dateString) {
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 검색 버튼 클릭
const btnSearch = document.getElementById('btnSearch');
if (btnSearch) {
    btnSearch.addEventListener('click', async e => {
        e.preventDefault();

        const keyword = document.getElementById('searchKeyword').value.trim();
        const searchType = document.getElementById('searchType').value;

        currentPage = 1; // 검색 시 첫 페이지로 초기화

        // 검색어, 검색 타입, 페이지 정보를 loadCourses 함수에 전달
        await loadCourses({
            keyword: keyword,
            searchType: searchType,
            page: currentPage,
            pageSize: pageSize // 미리 정의된 페이지당 개수
        });
    });
}


// 엔터키로 검색
const searchKeyword = document.getElementById('searchKeyword');
if (searchKeyword) {
    searchKeyword.addEventListener('keypress', e => {
        if (e.key === 'Enter') {
            e.preventDefault();
            if (btnSearch) btnSearch.click();
        }
    });
}

// 행 이벤트 바인딩
function bindRowEvents() {
    document.querySelectorAll('.table-row').forEach(row => {
        // 행 클릭 → 상세보기
        row.addEventListener('click', async e => {
            if (e.target.tagName === 'BUTTON') return;
            const courseId = row.dataset.id;
            console.log('상세보기:', courseId);
        });

        // 수정 버튼
        row.querySelector('.btn-edit')?.addEventListener('click', e => {
            e.stopPropagation();
            const courseId = row.dataset.id;
            console.log('수정:', courseId);
        });

        // 삭제 버튼
        row.querySelector('.btn-remove')?.addEventListener('click', e => {
            e.stopPropagation();
            const courseId = row.dataset.id;
            console.log('삭제:', courseId);
        });
    });
}