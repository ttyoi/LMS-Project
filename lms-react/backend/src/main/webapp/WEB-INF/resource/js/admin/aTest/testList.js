// sampleTests는 JSP에서 이미 전달되었다고 가정
// JS 파일에서는 선언하지 않고 바로 사용
let filteredData = [...(window.sampleTests || [])]; // 검색 적용된 데이터. 초기엔 전체
let currentPage = 1;
const pageSize = 5; // 한 페이지에 표시할 항목 수

// 테이블 렌더링
function renderTable() {
    const tbody = document.getElementById("testListBody");
    if (!tbody) return;
    tbody.innerHTML = "";

    const startIdx = (currentPage - 1) * pageSize;
    const pageItems = filteredData.slice(startIdx, startIdx + pageSize);

    if (pageItems.length === 0) {
        tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;padding:16px;">조회된 데이터가 없습니다.</td></tr>`;
        return;
    }

    pageItems.forEach((item) => {
        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>${item.no}</td>
            <td>${item.title}</td>
            <td>${item.period}</td>
            <td>${item.teacher}</td>
            <td>${item.status}</td>
            <td class="action-col">
                <button class="btn-red" type="button" onclick="location.href='/admin/test-exam/detail'">열람</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

// 페이징 렌더링 (최대 5개 숫자 페이징)
function renderPagination() {
    const container = document.getElementById("pagination");
    if (!container) return;

    const totalPage = Math.max(1, Math.ceil(filteredData.length / pageSize));
    container.innerHTML = "";

    let start = Math.max(1, currentPage - 2);
    let end = Math.min(totalPage, start + 4);
    if (end - start < 4) start = Math.max(1, end - 4);

    container.appendChild(createNavButton("<<", () => movePage(1), currentPage === 1));
    container.appendChild(createNavButton("<", () => movePage(Math.max(1, currentPage - 1)), currentPage === 1));

    for (let i = start; i <= end; i++) {
        const btn = document.createElement("button");
        btn.className = "page-btn" + (i === currentPage ? " active" : "");
        btn.textContent = i;
        btn.addEventListener("click", () => movePage(i));
        container.appendChild(btn);
    }

    container.appendChild(createNavButton(">", () => movePage(Math.min(totalPage, currentPage + 1)), currentPage === totalPage));
    container.appendChild(createNavButton(">>", () => movePage(totalPage), currentPage === totalPage));
}

// 페이지 이동
function movePage(page) {
    const totalPage = Math.max(1, Math.ceil(filteredData.length / pageSize));
    currentPage = Math.min(Math.max(1, page), totalPage);
    renderTable();
    renderPagination();
}

// 네비게이션 버튼 생성
function createNavButton(label, onClick, disabled) {
    const btn = document.createElement("button");
    btn.className = "page-btn";
    btn.textContent = label;
    if (disabled) {
        btn.disabled = true;
        btn.style.opacity = "0.5";
        btn.style.cursor = "not-allowed";
    } else {
        btn.addEventListener("click", onClick);
    }
    return btn;
}

// DOM 로드 후 초기 렌더링 및 이벤트 등록
window.addEventListener("DOMContentLoaded", () => {
    renderTable();
    renderPagination();

    const searchBtn = document.getElementById("searchBtn");
    if (searchBtn) {
        searchBtn.addEventListener("click", () => {
            const type = document.getElementById("filterType").value;
            const keyword = document.getElementById("searchInput").value.trim().toLowerCase();

            if (keyword === "" || type === "all") {
                filteredData = [...(window.sampleTests || [])];
            } else if (type === "teacher") {
                filteredData = (window.sampleTests || []).filter((t) => t.teacher.toLowerCase().includes(keyword));
            } else if (type === "title") {
                filteredData = (window.sampleTests || []).filter((t) => t.title.toLowerCase().includes(keyword));
            }

            currentPage = 1;
            renderTable();
            renderPagination();
        });
    }
});

// 디버깅용: 외부에서 페이지 이동 호출 가능
window.movePage = movePage;
