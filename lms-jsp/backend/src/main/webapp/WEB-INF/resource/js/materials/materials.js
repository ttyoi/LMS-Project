// ========================
// 모달 상태 상수
// ========================
const ModalState = {
    REGISTER: "register",
    VIEW: "view",
    EDIT: "edit"
};

let pageSize = 10;
let currentPage = 1;
let currentData = null;

/**
 * 강의 목록 저장 배열 (조회 / 등록 공용)
 */
let myCourseList = [];

// ========================
// 페이지 초기 로딩
// ========================
$(document).ready(function () {

    // 1️⃣ 나의 강의 목록 먼저 조회
    loadMyCourses(function () {

        // 2️⃣ 조회용 강의 셀렉트 세팅
        setSearchCourseSelect();

        // 3️⃣ 자료 목록 조회
        fLoadMaterials();
    });

    // 조회 조건 변경 시 재조회
    $("#mycourse").on("change", function () {
        currentPage = 1;
        fLoadMaterials();
    });

    // 등록 버튼
    $('#openPop').click(function (e) {
        e.preventDefault();
        openMaterialModal(ModalState.REGISTER);
    });
});

// ========================
// 나의 강의 목록 조회 (공통)
// ========================
function loadMyCourses(callback) {

    const param = {
        loginID: getCookie("EMP_ID")
    };

    callAjax(
        "/inst/loadInstCourse",
        "post",
        "json",
        true,
        param,
        function (data) {
            myCourseList = data || [];
            console.log(data);
            callback(data);
        }
    );
}

// ========================
// 조회용 강의 셀렉트 세팅
// ========================
function setSearchCourseSelect() {

    const select = $("#mycourse");
    select.empty();

    select.append(`<option value="">전체 강의</option>`);

    myCourseList.forEach(item => {
        select.append(`
            <option value="${item.course_id}">
                ${item.course_id} - ${item.course_title}
            </option>
        `);
    });
}

// ========================
// 모달 열기
// ========================
function openMaterialModal(state, data = {}) {

    currentData = data;
    gfModalPop("#layer1");

    const tdCourse = $("#td-course");
    const tdTitle = $("#td-title");
    const tdContent = $("#td-content");
    const tdFile = $("#td-file");
    const tdBtns = $("#td-btns");

    tdCourse.empty();
    tdTitle.empty();
    tdContent.empty();
    tdFile.empty();
    tdBtns.empty();

    switch (state) {

        // ========================
        // 등록 모드
        // ========================
        case ModalState.REGISTER:

            tdCourse.html('<select id="course-select" class="material-input"></select>');
            tdTitle.html('<input type="text" id="material-title" class="material-input" />');
            tdContent.html('<textarea id="material-content" class="material-textarea"></textarea>');
            tdFile.html('<input type="file" id="material-file" class="material-file-input" />');

            tdBtns.html(`
                <a href="#" class="btnType blue" id="insertMaterial"><span>등 록</span></a>
                <a href="#" class="btnType white" id="closePop"><span>닫 기</span></a>
            `);

            // 등록 모달 강의 셀렉트 세팅
            setRegisterCourseSelect();

            $("#insertMaterial").off().on("click", function (e) {
                e.preventDefault();
                submitMaterial(ModalState.REGISTER);
            });
            break;

        // ========================
        // 상세 모드
        // ========================
        case ModalState.VIEW:

            $("#materialsId").val(data.materials_id);
            $("#fileId").val(data.file_id);

            tdCourse.html(`<span>${data.course_id} - ${data.course_title}</span>`);
            tdTitle.html(`<span>${data.title}</span>`);
            tdContent.html(`<span>${data.content}</span>`);

            tdFile.html(`
                <span class="material-file-name">${data.file_name || ""}</span>
                <a href="#" class="btnType blue" id="downMaterial"><span>다운로드</span></a>
            `);

            tdBtns.html(`
                <a href="#" class="btnType blue" id="editMaterial"><span>수 정</span></a>
                <a href="#" class="btnType red" id="deleteMaterial"><span>삭 제</span></a>
                <a href="#" class="btnType white" id="closePop"><span>닫 기</span></a>
            `);

            $("#downMaterial").off().on("click", e => {
                e.preventDefault();
                downloadMaterial(data.file_id);
            });

            $("#editMaterial").off().on("click", e => {
                e.preventDefault();
                openMaterialModal(ModalState.EDIT, currentData);
            });

            $("#deleteMaterial").off().on("click", e => {
                e.preventDefault();
                deleteMaterial();
            });
            break;

        // ========================
        // 수정 모드
        // ========================
        case ModalState.EDIT:

            console.log(data.materials_id);

            $("#materialsId").val(data.materials_id);

            tdCourse.html(`${data.course_id} - ${data.course_title}
            <input type="text" id="course_id-hidden" class="hidden" value="${data.course_id}" />`);
            tdTitle.html(`<input type="text" id="material-title" class="material-input" value="${data.title}" />`);
            tdContent.html(`<textarea id="material-content" class="material-textarea">${data.content}</textarea>`);
            tdFile.html('<span class="cant-file-update-msg">파일은 수정할 수 없습니다.</span>');

            tdBtns.html(`
                <a href="#" class="btnType blue" id="updateMaterial"><span>수정완료</span></a>
                <a href="#" class="btnType white" id="toTheBack"><span>뒤 로</span></a>
            `);

            $("#updateMaterial").off().on("click", e => {
                e.preventDefault();
                submitMaterial(ModalState.EDIT);
            });

            $("#toTheBack").off().on("click", e => {
                e.preventDefault();
                openMaterialModal(ModalState.VIEW, currentData);
            });
            break;
    }

    $("#closePop").off().on("click", function (e) {
        e.preventDefault();
        gfCloseModal();
    });
}

// ========================
// 등록 모달 강의 셀렉트 세팅
// ========================
function setRegisterCourseSelect() {

    const select = $("#course-select");
    select.empty();

    myCourseList.forEach(item => {
        select.append(`
            <option value="${item.course_id}">
                ${item.course_id} - ${item.course_title}
            </option>
        `);
    });
}

// ========================
// 등록 / 수정
// ========================
function submitMaterial(state) {

    const title = $("#material-title").val();
    const content = $("#material-content").val();
    let course_id;
    if(state === ModalState.REGISTER) {
         course_id = $("#course-select").val();
    }
    else{
        course_id = $("#course_id-hidden").val();
    }
    const materials_id = $("#materialsId").val();

    console.log("materials_id" + materials_id);

    let url = (state === ModalState.REGISTER)
        ? "/inst/insertMaterial"
        : "/inst/updateMaterial";

    let formData = new FormData();
    formData.append("title", title);
    formData.append("content", content);
    formData.append("course_id", course_id);

    if (state === ModalState.REGISTER) {
        formData.append("register_date", getFormatDate(new Date()));
    } else {
        formData.append("materials_id", materials_id);
        formData.append("update_date", getFormatDate(new Date()));
    }

    const files = $("#material-file")[0]?.files;
    if (files && files.length > 0) {
        formData.append("file", files[0]);
    }

    console.log("url : " + url);

    formData.forEach((value, key) => console.log(`${key} : ${value}`));

    $.ajax({
        url: url,
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: flogcallback,
        error: function () {
            alert("파일 업로드 실패!");
        }
    });
}

function flogcallback() {
    fLoadMaterials();
    gfCloseModal();
}

// ========================
// 목록 로딩
// ========================
function fLoadMaterials(page) {

    if (page) currentPage = page;

    const param = {
        loginID: getCookie("EMP_ID"),
        course_id: $("#mycourse").val(),
        currentPage,
        pageSize
    };

    callAjax("/inst/loadMaterials", "post", "json", true, param, settingData);
}

function settingData(data) {

    let html = "";

    if (!data.materialList || data.materialList.length === 0) {
        html = `<tr><td colspan="6" class="no-material-msg">조회된 학습자료가 없습니다.</td></tr>`;
    } else {
        data.materialList.forEach(item => {
            html += `
            <tr onclick='fGoDetail(${JSON.stringify(item)})'>
                <td>${item.materials_id}</td>
                <td>${item.title}</td>
                <td>${item.course_id} - ${item.course_title}</td>
                <td>${item.register_date.substring(0, 10)}</td>
                <td>${item.file_name || ""}</td>
            </tr>`;
        });
    }

    $("#listMaterial").html(html);
    makePaging(data.totalCnt);
}

// ========================
// 삭제
// ========================
function deleteMaterial() {

    if (!confirm("학습자료를 삭제하시겠습니까?")) return;

    const param = {
        materials_id: $("#materialsId").val(),
        file_id: $("#fileId").val()
    };

    callAjax("/inst/deleteMaterial", "post", "json", true, param, flogcallback);
}

// ========================
// 기타 유틸
// ========================
function fGoDetail(item) {
    openMaterialModal(ModalState.VIEW, item);
}

function getFormatDate(date) {
    return date.getFullYear() + "-"
        + ("0" + (date.getMonth() + 1)).slice(-2) + "-"
        + ("0" + date.getDate()).slice(-2);
}

function downloadMaterial(file_id) {
    location.href = "/inst/downloadMaterial?file_id=" + file_id;
}

// ========================
// 페이징
// ========================
function makePaging(totalCount) {

    if (totalCount === 0) {
        $("#Pagination").html("");
        return;
    }

    const pageBlock = 5;
    const totalPage = Math.ceil(totalCount / pageSize);

    let startPage = Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
    let endPage = Math.min(startPage + pageBlock - 1, totalPage);

    let html = "";

    if (currentPage > 1) {
        html += `<a href="#" class="prev" onclick="fLoadMaterials(${currentPage - 1})"><</a>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        html += (i === currentPage)
            ? `<a href="#" class="current">${i}</a>`
            : `<a href="#" onclick="fLoadMaterials(${i})">${i}</a>`;
    }

    if (currentPage < totalPage) {
        html += `<a href="#" class="next" onclick="fLoadMaterials(${currentPage + 1})">></a>`;
    }

    $("#comnGrpCodPagination").html(html);
}
