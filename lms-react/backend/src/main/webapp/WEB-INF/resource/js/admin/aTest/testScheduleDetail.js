/* ================================
   상세 페이지 로딩
================================ */
window.addEventListener("DOMContentLoaded", () => {
    // URL에서 id 가져오기
    const pathParts = window.location.pathname.split('/');
    const courseId = pathParts[pathParts.length -2];
    const period = pathParts[pathParts.length - 1]; // URL 마지막 경로가 period
    if (!period || !courseId) {
        console.error("시험 일정 ID 없음");
        return;
    }

    // 서버에서 상세 데이터 가져오기
    fetch(`/admin/exam/schedule/detail/${courseId}/${period}`)
        .then(res => {
            if (!res.ok) throw new Error(`HTTP 오류 ${res.status}`);
            return res.json();
        })
        .then(data => {
            if (!data) {
                console.error("상세 데이터 없음");
                return;
            }

            // 상단 정보 채우기
            document.getElementById("modalContent").innerHTML = `<h3>${data.testSchedule_title}</h3>`;
            document.getElementById("courseTitle").textContent = data.course_title ?? "-";
            document.getElementById("courseClass").textContent = data.courseClass_className ?? "-";
            document.getElementById("courseProfessor").textContent = data.tbUserinfo_name ?? "-";

            // 시험 일정 테이블 채우기
            renderDetailTable(data);
        })
        .catch(err => console.error(err));
});

/* ================================
   테이블 렌더링
================================ */
function renderDetailTable(data) {
    const tbody = document.getElementById("examInfoBody");
    if (!tbody) return;

    tbody.innerHTML = "";

    const tr = document.createElement("tr");

    tr.innerHTML = `
        <td>1</td>
        <td>${data.testSchedule_title}</td>
        <td>${data.testSchedule_date ?? "-"}</td>
        <td>${data.testSchedule_status == 1 ? "열림" : "닫힘"}</td>
        <td>
            <button id="statusBtn" class="status-btn">
                ${data.testSchedule_status == 1 ? "닫힘" : "열림"}
            </button>
        </td>
    `;

    const statusBtn = tr.querySelector("#statusBtn");
    statusBtn.className = data.testSchedule_status == 1 ? "status-btn closed" : "status-btn open";

    tbody.appendChild(tr);

    // 상태 버튼 이벤트
    document.getElementById("statusBtn").addEventListener("click", () => toggleStatus(data));

    console.log("toggleStatus 호출 데이터:", data);

}

/* ================================
   상태 변경 처리
================================ */
function toggleStatus(data) {
    const statusBtn = document.getElementById("statusBtn");
    statusBtn.disabled = true; // 클릭 중복 방지

    // 새 상태 계산
    const newStatus = data.testSchedule_status == 1 ? 0 : 1;

    fetch(`/admin/exam/updateStatus/${data.course_courseId}/${data.testSchedule_period}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: newStatus })
    })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                // 데이터 상태 업데이트
                data.testSchedule_status = newStatus;

                // 버튼 텍스트: 현재 상태 기준으로 반대 동작 표시
                statusBtn.textContent = newStatus === 1 ? "닫힘" : "열림";
                statusBtn.className = newStatus === 1 ? "status-btn closed" : "status-btn open";

                // 테이블 상태 컬럼도 새 상태 반영
                const statusTd = statusBtn.closest("tr").children[3];
                if (statusTd) statusTd.textContent = newStatus === 1 ? "열림" : "닫힘";
            } else {
                alert("상태 변경 실패");
            }
        })
        .catch(err => {
            console.error(err);
            alert("서버 오류");
        })
        .finally(() => {
            statusBtn.disabled = false;
        });
}

// 모달 닫기(X 버튼)
const closeModalBtn = document.getElementById("closeModal");
if (closeModalBtn) {
    closeModalBtn.addEventListener("click", () => {
        // 목록 페이지로 이동
        window.location.href = "/admin/exam/schedule";
    });
}
