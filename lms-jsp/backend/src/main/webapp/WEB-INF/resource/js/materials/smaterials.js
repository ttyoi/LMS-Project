let pageSize = 10;
let currentPage = 1;

$(document).ready(function () {
    floadMyCourses();
    fLoadMaterials();
    $("#closePop").off().on("click", function (e) {
        e.preventDefault();
        gfCloseModal();
    });
});

// ========================
// 나의 강의 목록 조회 (공통)
// ========================
function floadMyCourses(callback) {

    const param = {
        loginID: getCookie("EMP_ID")
    };

    callAjax(
        "/stu/loadStuCourse",
        "post",
        "json",
        true,
        param,
        function (myCourseList) {
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
    );
}

// ========================
// 목록 조회
// ========================
function fLoadMaterials(page) {
    if (page) currentPage = page;

    const course_id = $("#mycourse").val()

    const param = {
        loginID: getCookie("EMP_ID"),
        currentPage,
        pageSize,
        course_id

    };

    callAjax("/stu/loadMaterials", "post", "json", true, param, settingData);
}

function settingData(data) {
    let html = "";

    if (!data.materialList || data.materialList.length === 0) {
        html = `<tr><td colspan="5" class="no-material-msg">조회된 학습자료가 없습니다.</td></tr>`;
    } else {
        data.materialList.forEach(item => {
            html += `
            <tr onclick='openDetail(${JSON.stringify(item)})'>
                <td>${item.materials_id}</td>
                <td>${item.title}</td>
                <td>${item.course_id} - ${item.course_title}</td>
                <td>${item.register_date.substring(0, 10)}</td>
                <td>${item.file_name}</td>
            </tr>`;
        });
    }

    $("#listMaterial").html(html);
    makePaging(data.totalCnt);
}

// ========================
// 상세 조회 (읽기 전용)
// ========================
function openDetail(data) {

    $("#td-course").text(`${data.course_id} - ${data.course_title}`);
    $("#td-title").text(data.title);
    $("#td-content").text(data.content);

    $("#td-file").html(`
        <span class="material-file-name">${data.file_name}</span>
        <a href="#" class="btnType blue" onclick="downloadMaterial(${data.file_id})">
            <span>다운로드</span>
        </a>
    `);

    gfModalPop("#layer1");
}

// ========================
// 파일 다운로드
// ========================
function downloadMaterial(file_id) {
    window.location.href = "/stu/downloadMaterial?file_id=" + file_id;
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
        html += `<a href="#" onclick="fLoadMaterials(${currentPage - 1})"><</a>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        html += (i === currentPage)
            ? `<a href="#" class="current">${i}</a>`
            : `<a href="#" onclick="fLoadMaterials(${i})">${i}</a>`;
    }

    if (currentPage < totalPage) {
        html += `<a href="#" onclick="fLoadMaterials(${currentPage + 1})">></a>`;
    }

    $("#Pagination").html(html);
}
