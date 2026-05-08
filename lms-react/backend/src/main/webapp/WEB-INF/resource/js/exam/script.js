//import { downloadSampleExcel } from "./sample";

let uploadedData = null; // 업로드된 엑셀 데이터 저장

// 파일 선택 이벤트
document.getElementById("excelFile").addEventListener("change", function (e) {
    const file = e.target.files[0];

    if (!file) return;

    // 확장자 체크
    const allowedExt = [".xls", ".xlsx", ".xlsm"];
    const ext = file.name.substring(file.name.lastIndexOf(".")).toLowerCase();

    if (!allowedExt.includes(ext)) {
        alert("❌ 올바른 엑셀 파일이 아닙니다.\n허용 확장자: .xls, .xlsx, .xlsm");
        e.target.value = "";
        return;
    }

    document.getElementById("fileName").innerText = file.name;

    // 파일 리더
    const reader = new FileReader();
    reader.onload = function (event) {
        const data = new Uint8Array(event.target.result);
        const workbook = XLSX.read(data, { type: "array" });

        // 첫번째 시트 읽기
        const sheetName = workbook.SheetNames[0];
        const sheet = workbook.Sheets[sheetName];

        // 시트를 배열(JSON-like) 형식으로 변환
        uploadedData = XLSX.utils.sheet_to_json(sheet, { header: 1 });
    };
    reader.readAsArrayBuffer(file);
});

// 샘플양식 다운로드
document
    .getElementById("downloadSample")
    .addEventListener("click", function () {
        downloadSampleExcel();
        // 실제 서버 경로에 맞게 추후 수정
    });

// 미리보기 버튼
document.getElementById("previewBtn").addEventListener("click", function () {
    if (!uploadedData) {
        alert("❗ 먼저 엑셀 파일을 업로드하세요.");
        return;
    }

    // 시험정보 가져오기
    const courseId = uploadedData[1][0] ?? "";
    const period = uploadedData[1][1] ?? "";
    const title = uploadedData[1][2] ?? "";

    // 화면 표시
    document.getElementById("infoCourseId").innerText = courseId || "미입력";
    document.getElementById("infoPeriod").innerText = period || "미입력";
    document.getElementById("infoTitle").innerText = title || "미입력";

    const tbody = document.querySelector("#previewTable tbody");
    tbody.innerHTML = "";

    // 데이터 행
    // uploadedData[0~2] = 헤더 → 무시하고 row 3부터 출력

    for (let i = 3; i < uploadedData.length; i++) {
        const row = uploadedData[i];
        const tr = document.createElement("tr");

        // 총 11개의 column 중 10개만 선택
        for (let col = 0; col < 9; col++) {
            const td = document.createElement("td");
            td.textContent = row[col] ?? ""; // 데이터 없으면 빈 칸
            tr.appendChild(td);
        }

        tbody.appendChild(tr);
    }
});

// 등록하기 버튼
document.getElementById("submitBtn").addEventListener("click", function () {
    if (!uploadedData) {
        alert("❗ 등록할 데이터가 없습니다.");
        return;
    }

    const maxSize = 2 * 1024 * 1024; // 2MB

// 용량제한 (2MB)
    if (uploadedData.size > maxSize) {
        alert("❌ 업로드 가능한 최대 파일 용량은 2MB입니다.");
        e.target.value = "";
        return;
    }


    // 백엔드로 전송할 데이터
    // uploadedData의 1행에서 시험 데이터 가져오기
    const courseId = Number(uploadedData[1][0] ?? 0);
    const period = Number(uploadedData[1][1] ?? 0);
    const title = uploadedData[1][2] ?? "";

    // === 1차 검증 ===
    if (!courseId || !title || !period) {
        alert("❌ 과목코드, 차시, 시험명은 반드시 입력해야 합니다.");
        return;
    }

    // 문제 데이터 수집
    const rows = document.querySelectorAll("#previewTable tbody tr");

    const questions = [...rows].map((tr) => {
        const cols = tr.querySelectorAll("td");
        return {
            questionNo: Number(cols[0].textContent),
            content: cols[1].textContent,
            option1: cols[2].textContent,
            option2: cols[3].textContent,
            option3: cols[4].textContent,
            option4: cols[5].textContent,
            answer: Number(cols[6].textContent),
            score: Number(cols[7].textContent),
            comment: cols[8].textContent,
        };
    });

    // === 문제 필드 검증 ===
    for (let q of questions) {
        if (!q.questionNo || !q.content || !q.option1 || !q.option2 || !q.option3 || !q.option4 || !q.answer || !q.score) {
            alert("❌ 모든 문제의 필수 항목(번호, 지문, 보기, 정답, 배점)은 반드시 입력해야 합니다.");
            return;
        }
    }


    // === 전송 데이터 ===
    const payload = {
        courseId,
        title,
        period,
        questions,
        status: 1
    };


    const confirmResult = confirm("정말로 등록하시겠습니까?");

    if (!confirmResult) return;


    fetch("/inst/exam-register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
    })
        .then((res) => res.json())
        .then((result) => {
            if (result.success) {
                alert("✅ DB 저장 성공!");

                resetAll();
            } else {
                alert("❌" + (result.message || "DB 저장 실패!"));
            }
        })
        .catch(() => alert("❌ 서버 오류가 발생했습니다."));
});

// 취소 버튼
document.getElementById("cancelBtn").addEventListener("click", function () {
    resetAll();
});

// 전체 초기화 함수
function resetAll() {
    document.getElementById("excelFile").value = "";
    document.getElementById("fileName").innerText = "선택된 파일 없음";
    uploadedData = null;

    document.querySelector("#previewTable tbody").innerHTML = "";

    document.getElementById("infoCourseId").innerText = "-";
    document.getElementById("infoPeriod").innerText = "-";
    document.getElementById("infoTitle").innerText = "-";
}

// ------------------------------
// 하드코딩 데이터 (추후 백엔드 연동 부분)
// ------------------------------
const testData = [];
for (let i = 1; i <= 42; i++) {
    testData.push({
        id: i,
        lectureNo: 1111,
        lectureName: "JAVA",
        session: i,
        teacher: "홍강사",
        status: i % 2 === 0 ? "열림" : "닫힘",
    });
}

// 페이징 변수
let currentPage = 1;
const pageSize = 10;

// ------------------------------
// util: 특정 페이지의 데이터 slice
// ------------------------------
function getPageData(page) {
    const start = (page - 1) * pageSize;
    return testData.slice(start, start + pageSize);
}

// ------------------------------
// 테이블에 데이터 렌더링
// ------------------------------
function renderTable() {
    const tbody = document.querySelector("#testTableBody");
    const rows = getPageData(currentPage);

    tbody.innerHTML = rows
        .map(
            (row) => `
      <tr>
        <td>${row.lectureNo}</td>
        <td>${row.lectureName}</td>
        <td>${row.session}</td>
        <td>${row.teacher}</td>
        <td>${row.status}</td>
        <td><button onclick="goDetail(${row.id})">열람</button></td>
      </tr>
    `
        )
        .join("");
}

// ------------------------------
// admin 시험 상세 보기 이동
// ------------------------------
function goDetail(id) {
    alert(id + "번 상세페이지로 이동합니다.");
    window.location.href = "/admin/testDetail";
}
