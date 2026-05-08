let pageSize = 5;
let currentPage = 1;
function loadSearchKeys() {
    $.ajax({
        url: "/stu/courses/loadSearchKeys",
        method: "get",
        data: {
            group_code : "stu_cou_status"
        },
        dataType : 'json',
        success: function (dataList) {
            console.log("data : " , dataList);
            $("#searchKey").append(
                $('<option></option>').val("").text("전체")
            );
            dataList.forEach(item => {
                $("#searchKey").append(
                    $('<option></option>').val(item.detail_code).text(item.detail_name)
                );
            });
        }

    })
}

function makeMyCoursePaging(data) {


    const totalCount = data.totalCnt;
    if (totalCount === 0) {
        $("#Pagination").html("");
        return;
    }

    console.log(totalCount);

    const pageBlock = 5;
    const totalPage = Math.ceil(totalCount / pageSize);

    // 🔒 currentPage 보정
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPage) currentPage = totalPage;

    let startPage =
        Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
    let endPage =
        Math.min(startPage + pageBlock - 1, totalPage);

    let html = "";

    if (currentPage > 1) {
        html += `<a href="#" onclick="loadMyCourse(${currentPage - 1})">&lt;</a>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        html += (i === currentPage)
            ? `<a href="#" class="current">${i}</a>`
            : `<a href="#" onclick="loadMyCourse(${i})">${i}</a>`;
    }

    if (currentPage < totalPage) {
        html += `<a href="#" onclick="loadMyCourse(${currentPage + 1})">></a>`;
    }

    $("#Pagination").html(html);
}


function loadMyCourse(page) {

    const searchKey = $("#searchKey").val();
    const getLoginID = getCookie('EMP_ID');
    console.log('getLoginID : ', getLoginID);
    if (page) currentPage = page;

    const param = {
        loginID : getLoginID,
        searchKey,
        currentPage,
        pageSize
    };


    $.ajax({
        url: "/stu/my-courses/loadMyCourse",
        method: 'post',
        data: param,
        dataType: "json",
        success: function(data) {
            let html = "";

            if(data.length === 0){
                html = `<tr><td colspan="6" class="course-empty-msg">조회된 강의가 없습니다.</td></tr>`;
            } else {
                data.forEach(item => {
                    html += `
                        <tr id="${item.course_id}" onclick="goDetail('${item.course_id}')">
                            <td>${item.course_id}</td>
                            <td>${item.title}</td>
                            <td>${item.name}</td>
                            <td>${item.class_name}</td>
                            <td>${item.start_time}</td>
                            <td>${item.end_time}</td>
                            <td>${item.scs_name}</td>
                        </tr>
                    `;
                            // <td>${item.status}</td>
                });
            }

            $("#course-table-body").html(html);
        },
        error: function(xhr, status, error){
            console.log("AJAX error:", status, error);
        }
    });
    $.ajax({
        url: "/stu/my-courses/totalCount",
        method: "post",
        data: param,
        dataType: "json",
        success: function(data) {
            makeMyCoursePaging(data)},
        error: function(xhr, status, error){
            console.log("AJAX error:", status, error);
        }
    });
}

function postCourse(status, course_id){

    let msg;

    if(status == 'apply'){
        msg = "수강신청 하시겠습니까?";
    }
    else if(status == 'delete'){
        msg = "수강신청을 취소하시겠습니까?"
    }

    if(!confirm(msg)){
        return;
    }

    const loginID = getCookie('EMP_ID');

    console.log(`수강신청 메서드
    status : ${status},
     course_id : ${course_id}, 
     loginID : ${loginID}`);


    $.ajax({
        url: '/stu/courses/postCourse',
        method: 'post',
        data: {
            apply_status : status,
            course_id,
            loginID
        },
        dataType: 'json',
        success: function (data){
            console.log("포스트코스 리턴값 ",data);
            alert(data.msg + "에 성공하였습니다.")

            console.log("새로고침한다");

            loadMyCourse();
            $('#mask').hide();
            $('.layerPop').hide();
        }
    })
}

function choiceBtn(enrollable, course_id) {

    console.log("enrollable : ",enrollable);

    let $btn = $("#changebtn");

    // 기존 클래스 & 클릭 제거
    $btn.removeClass("blue-btn red-btn disable-btn");
    $btn.off("click");

    if (enrollable === "available") {
        $btn.text("신청하기");
        $btn.addClass("blue-btn");
        $btn.on("click", () => postCourse("apply", course_id));

    } else if (enrollable === "cancel") {
        $btn.text("수강취소");
        $btn.addClass("red-btn");
        $btn.on("click", () => postCourse("delete", course_id));

    } else {
        $btn.text("신청불가");
        $btn.addClass("disable-btn");
        // 클릭 비활성화
    }
}


function goDetail (cos_id) {

    const loginID = getCookie("EMP_ID");

    console.log('cos_ID : ',cos_id, '    loginID : ', loginID);

    $.ajax({
        url: '/stu/my-courses/myCourseDetail',
        method: 'get',
        data: {
            course_id : cos_id,
            loginID : loginID
        },
        dataType: 'json',
        success: function (data){
            console.log(data);
            $("#dataspan").val(JSON.stringify(data));


            // 기본 정보
            $("#course_id").text(data.course_id);
            $("#title").text(data.title);

            // 교수 정보
            $("#professor").text(data.professior);
            $("#sub_prof").text(data.sub_prof);

            // 강의 시간
            $("#time_range").text(data.start_time + " ~ " + data.end_time);

            // 강의실 / 정원
            $("#class_name").text(data.class_name);
            $("#people_limit").text(`${data.stu_num} / ${data.people_limit}`);

            // 기간
            let s = data.start_date ?? "미정";
            let e = data.end_date ?? "미정";
            $("#date_range").text(s + " ~ " + e);

            let days;

            const startDate = new Date(s);
            const endDate = new Date(e);

            // 유효한 날짜인지 체크
            if (!isNaN(startDate) && !isNaN(endDate)) {
                days = (endDate - startDate) / (1000 * 60 * 60 * 24);
            }

            console.log("days : ", days);

            console.log("attendance : ", data.attendance);

            $("#attendance").text(data.attendance);
            $("#tard_levEarly").text(data.tard_levEarly);
            $("#absen_sick").text(data.absen_sick);
            const att_percent =  isNaN(data.attendance/days) ? 0 : Math.round(((data.attendance/days)*100));
            $("#att_percent").text(att_percent+" %");



            // textarea 항목
            $("#content").text(data.content);
            $("#notice").text(data.notice);
            $("#plan").text(data.plan);

            choiceBtn(data.enrollable, data.course_id);

            gfModalPop("#layer1");
        }
    })



}