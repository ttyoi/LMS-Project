/* ---------------------------
   DOM
---------------------------- */
const listTbody = document.getElementById("testListBody");

/* ---------------------------
   데이터 변수
---------------------------- */
let scheduleData = [];
let filteredData = [];
let currentPage = 1;
const pageSize = 5;

/* ---------------------------
   목록 테이블 렌더링
---------------------------- */
function renderTable() {
    if (!listTbody) return;
    listTbody.innerHTML = "";

    const startIdx = (currentPage - 1) * pageSize;
    const pageItems = filteredData.slice(startIdx, startIdx + pageSize);

    if (pageItems.length === 0) {
        listTbody.innerHTML = `
            <tr>
                <td colspan="5" style="text-align:center; padding:16px;">
                    조회된 데이터가 없습니다.
                </td>
            </tr>`;
        return;
    }

    pageItems.forEach((item) => {
        const tr = document.createElement("tr");
        tr.style.cursor = "pointer";

        tr.innerHTML = `
            <td>${item.course_courseId}</td>
            <td>${item.testSchedule_title}</td>
            <td>${item.testSchedule_period}</td>
            <td>${item.tbUserinfo_name}</td>
            <td>${item.testSchedule_status == 1 ? "열림" : "닫힘"}</td>
        `;

        // 페이지 이동
        tr.addEventListener("click", () => {
            window.location.href = `/admin/exam/scheduleDetail/${item.course_courseId}/${item.testSchedule_period}`;
        });

        listTbody.appendChild(tr);
    });
}

/* ---------------------------
   데이터 로딩
---------------------------- */
window.addEventListener("DOMContentLoaded", async () => {
    const res = await fetch("/admin/exam/schedule/list");
    scheduleData = await res.json();
    filteredData = [...scheduleData];

    renderTable();
});
