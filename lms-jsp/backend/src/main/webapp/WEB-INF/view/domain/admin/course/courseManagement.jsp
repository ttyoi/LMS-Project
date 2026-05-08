<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>강의 목록</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <script src="https://code.jquery.com/jquery-4.0.0.js" integrity="sha256-9fsHeVnKBvqh3FB2HYu7g2xseAZ5MlN6Kz/qnkASV8U=" crossorigin="anonymous"></script>
</head>
<script>

let fullList = []

const fetchList = async () => {
    return $.ajax({
        url: '/admin/courseManagement/list',
        method: 'GET',
        dataType: 'json',
    })
}

const fetchDetail = async (courseId) => {
    return $.ajax({
        url: '/admin/courseManagement/detail/'+courseId,
        method: 'GET',
        dataType: 'json'
    })
}

const fetchClassroomList = async () => {
    const response = await $.ajax({
        url: '/admin/classrooms/list',
        method: 'GET',
        dataType: 'json'
    })

    return Object.values(response.filter(item => item.status === 1).reduce((acc, cur) => {
        if (!acc[cur.class_name]) {
            acc[cur.class_name] = {
                class_name: cur.class_name,
                people_limit: cur.people_limit,
                isAvailable: {
                    "9:00": true,
                    "12:00": true,
                    "14:00": true
                }
            }
        }
        if (cur.start_time) acc[cur.class_name].isAvailable[cur.start_time] = false
        return acc
    }, {}))
}

const fetchStatus = (status, courseId) => {
    const urlMap = {
        approve: '/admin/courseManagement/approve',
        reject: '/admin/courseManagement/reject',
        cancel: '/admin/courseManagement/cancel'
    }
    return $.ajax({
        url: urlMap[status],
        method: 'POST',
        dataType: 'json',
        data: {
            course_id: courseId
        }
    })
}



const applyFilter = () => {
    const classroom = $('#classroomList').val()
    const status = $('#courseStatus').val()
    const searchType = $('#searchType').val()
    const searchText = $('#searchText').val().toLowerCase()

    let filtered = fullList
    if (classroom) filtered = filtered.filter(item => item.class_name === classroom)
    if (status) filtered = filtered.filter(item => item.cos_sta_code === status)
    if (searchType && searchText) {
        filtered = filtered.filter(item => {
            if (searchType === 'course') return item.title.toLowerCase().includes(searchText)
            if (searchType === 'instructor') return item.name.toLowerCase().includes(searchText)
        })
    }
    displayList(filtered)
}

const displayList = (listArray) => {
    let html = ''
    listArray.forEach((item) => {
        html += `<tr class='courseRow' data-index='`+item.course_id+`'>
                 <td>`+item.title+`</td>
                 <td>`+item.name+`</td>
                 <td>`+item.class_name+`</td>
                 <td>`+(item.start_date? item.start_date.split(' ')[0]:'')+' ~ '+(item.end_date?item.end_date.split(' ')[0]:'')+`</td>
                 <td class='`+(item.cos_sta_code === "0"? "status-pending":item.cos_sta_code === "1"?"status-approved":"status-rejected")+`'>`+
                    (item.cos_sta_code === "0"? "대기":"")+
                    (item.cos_sta_code === "1"? "승인":"")+
                    (item.cos_sta_code === "-1"? "거절":"")+`
                 </td>
                 </tr>`
    })
    if(listArray.length === 0) {
        html = `<tr><td colspan='5' style='text-align: center'>강의가 존재하지 않습니다</td></tr>`
    }
    $('#displayList').html(html)
}

const displayDetail = (item) => {
    const statusText = item.cos_sta_code === "0" ? "대기" : item.cos_sta_code === "1" ? "승인" : item.cos_sta_code === "-1" ? "거절" : ""
    const html =
        `<div style='display: flex; justify-content: space-between'><h4>강의 정보</h4>
        <button id="btnCloseDetail">닫기</button></div>
        <table>
            <thead>
            <colgroup>
            <col style="width: 25%">
            <col style="width: 25%">
            <col style="width: 25%">
            <col style="width: 25%">
            </colgroup>
            </thead>
            <tbody>
            <tr>
                <th>강의명</th>
                <td>`+item.title+`</td>
                <th>강의실</th>
                <td>`+item.class_name+`</td>
            </tr>
            <tr>
                <th>주 강사</th>
                <td>`+item.name+`</td>
                <th>보조 강사</th>
                <td>`+(item.subName? item.subName:'')+`</td>
            </tr>
            <tr>
                <th>승인 상태</th>
                <td>`+statusText+`</td>
                <th>상태 변경</th>
                <td><button id="btnApprove">승인</button>
                    <button id="btnReject">거절</button>
                    <button id="btnPending">대기</button></td>
            </tr>
            <tr>
                <th>강의 기간</th>
                <td colSpan="3">`+(item.start_date? item.start_date.split(' ')[0]:'')+' ~ '+(item.end_date?item.end_date.split(' ')[0]:'')+` / `+(item.start_time? item.start_time+' ~ ':'')+(item.end_time? item.end_time:'')+`</td>
            </tr>
            </tbody>
        </table>
        <h4>수업내용</h4>
        <textarea placeholder="수업 내용이 작성됩니다" readonly>`+item.content+`</textarea>
        <h4>강의 계획서</h4>
        <textarea placeholder="강의 계획서가 작성됩니다" readonly>`+item.plan+`</textarea>
        <h4>강의 공지</h4>
        <textarea placeholder="강의 공지사항이 작성됩니다" readonly>`+item.notice+`</textarea>`

    $('#detailArea').html(html)
    $('#detailArea').data('courseId',item.course_id)
    $('#btnApprove').prop('disabled',item.cos_sta_code === "1")
    $('#btnApprove').toggleClass('disabled', item.cos_sta_code === "1")
    $('#btnReject').prop('disabled',item.cos_sta_code === "-1")
    $('#btnReject').toggleClass('disabled', item.cos_sta_code === "-1")
    $('#btnPending').prop('disabled',item.cos_sta_code === "0")
    $('#btnPending').toggleClass('disabled', item.cos_sta_code === "0")
}

const initialLoad = async () => {
    try {
        const lists = await fetchList()
        const classrooms = await fetchClassroomList()
        console.log(lists)
        console.log(classrooms)
        fullList = lists
        displayList(fullList)
        let html = `<option value=''>전체</option>`
        classrooms.forEach((item) => {
            html += `<option value='` + item.class_name + `'>` + item.class_name + `</option>`
        })
        $('#classroomList').html(html)
    } catch (error) {
        console.error(error)
    }
}

$(function () {

    initialLoad()

    $('#classroomList').on('change', applyFilter)
    $('#courseStatus').on('change', applyFilter)
    $('#btnSearch').click(async function () {
        try {
            const result = await fetchList()
            fullList = result
            applyFilter()
        } catch (error) {
            console.error(error)
        }
    })

    $(document).on('click', '.courseRow', async function () {
        const index = $(this).data('index')
        try {
            const item = await fetchDetail(index)
            displayDetail(item)
        } catch (error) {
            alert('강의를 불러올 수 없습니다')
        }
    })

    $(document).on('click','#btnCloseDetail', () => {
        $('#detailArea').html('')
    })
    $(document).on('click','#btnApprove', async () => {
        const courseId = $('#detailArea').data('courseId')
        if(!window.confirm('승인하시겠습니까?')) return
        try {
            const result = await fetchStatus('approve', courseId)
            alert('강의를 승인하였습니다')
            await initialLoad()
            const detail = await fetchDetail(courseId)
            displayDetail(detail)
        } catch (error) {
            console.error(error)
            console.log(error.responseText)
        }
    })
    $(document).on('click','#btnReject', async () => {
        const courseId = $('#detailArea').data('courseId')
        if(!window.confirm('거절하시겠습니까?')) return
        try {
            const result = await fetchStatus('reject', courseId)
            alert('강의를 거절하였습니다')
            await initialLoad()
            const detail = await fetchDetail(courseId)
            displayDetail(detail)
        } catch (error) {
            console.error(error)
            console.log(error.responseText)
        }
    })
    $(document).on('click','#btnPending', async () => {
        const courseId = $('#detailArea').data('courseId')
        if(!window.confirm('보류하시겠습니까?')) return
        try {
            const result = await fetchStatus('cancel', courseId)
            alert('강의를 보류하였습니다')
            await initialLoad()
            const detail = await fetchDetail(courseId)
            displayDetail(detail)
        } catch (error) {
            console.error(error)
            console.log(error.responseText)
        }
    })
    $('#searchText').on('keypress', function (e) {
        if (e.which === 13) {
            e.preventDefault();
            $('#btnSearch').click();
        }
    })
})
</script>
<body>
<div id="wrap_area">
    <div id="container">
        <ul>
            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>
            <li class="contents">
                <div class="content">
                    <jsp:include page="/WEB-INF/view/common/header.jsp">
					    <jsp:param name="menu1" value="강의 운영"/>
					    <jsp:param name="menu2" value="강의 목록"/>
					    <jsp:param name="refreshUrl" value="${CTX_PATH}/admin/courseManagement"/>
					</jsp:include>
				
	                <p class="conTitle">
	                    <span>강의 목록</span>
	                </p>
	                    
	                <div class="container">
                        <div style="display: flex; flex-direction: row; margin-bottom: 10px;">
                            <div style="margin-right: 10px">
                            <h4>강의실</h4>
                            <select id="classroomList"></select>
                            </div>
                            <div style="margin-right: 10px">
                            <h4>승인 상태</h4>
                            <select id="courseStatus">
                                <option value="">전체</option>
                                <option value="0">대기</option>
                                <option value="1">승인</option>
                                <option value="-1">거절</option>
                            </select>
                            </div>
                            <div>
                            <h4>검색 기준</h4>
                            <select id="searchType">
                                <option value="">-- 선택 --</option>
                                <option value="course">강의명</option>
                                <option value="instructor">강사명</option>
                            </select>
                            <input type="text" id="searchText" />
                            <button id="btnSearch">검색</button>
                            </div>
                        </div>
                        <div style="display: flex; flex-direction: row">
                            <div style="width: 40%">
                                <table>
                                    <thead>
                                    <colgroup>
                                        <col style="width: 25%">
                                        <col style="width: 15%">
                                        <col style="width: 15%">
                                        <col style="width: 30%">
                                        <col style="width: 15%">
                                    </colgroup>
                                    <tr>
                                        <th>강의명</th>
                                        <th>강사</th>
                                        <th>강의실</th>
                                        <th>기간</th>
                                        <th>승인 상태</th>
                                    </tr>
                                    </thead>
                                    <tbody id="displayList">
                                    </tbody>
                                </table>
                            </div>
                            <div style="width: 60%" id="detailArea">
                            </div>
                        </div>
	                </div> <!-- container end -->
                </div>
            </li>
        </ul>
    </div>
</div>
</body>
<style>
    h4 {
        font-size: 15px;
        font-weight: 600;
        margin: 15px 0 8px;
        padding-left: 10px;
        border-left: 4px solid #007bff;
    }
    select, input[type="text"] {
        padding: 6px 8px;
        border: 1px solid #ccc;
        border-radius: 6px;
    }
    button {
        border: none;
        padding: 7px 12px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 13px;
        transition: 0.2s;
    }
    button:hover {
        opacity: 0.9;
    }
    #btnSearch {
        background-color: #007bff;
        color: white;
    }
    #btnApprove {
        background-color: #28a745;
        color: white;
    }
    #btnReject {
        background-color: #dc3545;
        color: white;
    }
    #btnPending {
        background-color: #ffc107;
        color: black;
    }
    #btnCloseDetail {
        background-color: #6c757d;
        color: white;
        margin-bottom: 10px;
    }
    button.disabled {
        background-color: #dee2e6 !important;
        color: #adb5bd !important;
        cursor: not-allowed;
        opacity: 0.7;
        pointer-events: none;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
    }
    thead {
        background-color: #f1f3f5;
    }
    th, td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }
    th {
        font-weight: 600;
    }
    .courseRow:hover {
        background-color: #f8f9fa;
        cursor: pointer;
    }
    #detailArea {
        margin-left: 20px;
    }
    textarea {
        width: 100%;
        min-height: 80px;
        resize: none;
        padding: 10px;
        border-radius: 8px;
        border: 1px solid #ddd;
        margin-bottom: 15px;
        background-color: #f8f9fa;
    }
    .status-pending {
        color: #ffc107;
        font-weight: 600;
    }
    .status-approved {
        color: #28a745;
        font-weight: 600;
    }
    .status-rejected {
        color: #dc3545;
        font-weight: 600;
    }
</style>
</html>
