let pageSize = 5;
let currentPage = 1;

function loadSearchKeys() {
    $.ajax({
        url: "/stu/courses/loadSearchKeys",
        method: "get",
        data: {
            group_code : "cou_sea_code"
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

function makeCoursePaging(data) {

    const totalCount = data.totalCnt;

    if (totalCount === 0) {
        $("#Pagination").html("");
        return;
    }

    const pageBlock = 5;
    const totalPage = Math.ceil(totalCount / pageSize);

    // currentPage 보정
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPage) currentPage = totalPage;

    let startPage =
        Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
    let endPage =
        Math.min(startPage + pageBlock - 1, totalPage);

    let html = "";

    if (currentPage > 1) {
        html += `<a href="#" onclick="loadAllCourse(${currentPage - 1})">&lt;</a>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        html += (i === currentPage)
            ? `<a href="#" class="current">${i}</a>`
            : `<a href="#" onclick="loadAllCourse(${i})">${i}</a>`;
    }

    if (currentPage < totalPage) {
        html += `<a href="#" onclick="loadAllCourse(${currentPage + 1})">></a>`;
    }

    $("#Pagination").html(html);
}


function loadAllCourse(page) {
    const searchKey = $("#searchKey").val();
    const searchWord = $("#searchWord").val();

    if (page) currentPage = page;

    const param = {
        searchKey,
        searchWord,
        currentPage,
        pageSize
    };

    console.log("searchKey : ", searchKey, " searchWord : ", searchWord);

    $.ajax({
        url: "/stu/courses/loadAllCourse",
        method: 'post',
        data : param,
        dataType: "json",
        success: function(data) {
            let html = "";

            if(data.length === 0){
                html = `<tr><td colspan="8" class="course-empty-msg">조회된 강의가 없습니다.</td></tr>`;
            } else {
                console.log("data : ",data)
                data.forEach(item => {
                    html += `
                        <tr id="${item.course_id}" onclick="goDetail('${item.course_id}')">
                            <td>${item.course_id}</td>
                            <td>${item.title}</td>
                            <td>${item.name}</td>
                            <td>${item.class_name}</td>
                            <td>${item.start_time}</td>
                            <td>${item.end_time}</td>
                            <td>${item.stu_num}/ ${item.people_limit}</td>
                            <td></td>
                        </tr>
                    `;
                });
            }

            $("#course-table-body").html(html);
        },
        error: function(xhr, status, error){
            console.log("AJAX error:", status, error);
        }
    });

    $.ajax({
        url: "/stu/courses/totalCount",
        method: "post",
        data : param,
        dataType: "json",
        success: function(data) {
            makeCoursePaging(data);
        },
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
            console.log("리턴값: ",data);
            alert(data.msg + "에 성공하였습니다.")

            loadAllCourse();
            goDetail(course_id);
        }
    })
}

function choiceBtn(enrollable, course_id) {

    console.log("enrollable: ",enrollable);

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
    console.log("고디테일 진입 : ",cos_id)

    const loginID = getCookie("EMP_ID");

    $.ajax({
        url: '/stu/courses/courseDetail',
        method: 'get',
        data: {
                course_id : cos_id
                , loginID
        },
        dataType: 'json',
        success: function (data){
            console.log("데이타 : ", data);
            $("#dataspan").val(JSON.stringify(data));


            // 기본 정보
            $("#course_id").text(data.course_id);
            $("#title").text(data.title);

            // 교수 정보
            $("#professor").text(data.professor);
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

            // textarea 항목
            $("#content").text(data.content);
            $("#notice").text(data.notice);
            $("#plan").text(data.plan);
            

            choiceBtn(data.enrollable, data.course_id);

            gfModalPop("#layer1");
        }
    })



}