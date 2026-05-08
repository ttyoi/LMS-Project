<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>강의실 목록</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <script src="https://code.jquery.com/jquery-4.0.0.js" integrity="sha256-9fsHeVnKBvqh3FB2HYu7g2xseAZ5MlN6Kz/qnkASV8U=" crossorigin="anonymous"></script>
</head>
<script>
let cachedClassrooms = []
let currentList = []
let timeFilter = {
    '09:00': false,
    '12:00': false,
    '14:00': false
}

const fetchClassroomList = async () => {
    const fetchData = await $.ajax({
        url: '/admin/classrooms/list',
        method: 'GET',
        dataType: 'json'
    })
    const classrooms = Object.values(
        fetchData.reduce((acc, cur) => {
        if (!acc[cur.class_name]) {
            acc[cur.class_name] = {
                class_name: cur.class_name,
                people_limit: cur.people_limit,
                courseId: {
                    "9:00": null,
                    "12:00": null,
                    "14:00": null
                }
            }
        }
        return acc
    }, {}))
    const occupied = Object.values(
        fetchData.filter(item => {
            const minDate = new Date($('#inputMinDate').val())
            const maxDate = new Date($('#inputMaxDate').val())
            const startDate = new Date(item.start_date)
            const endDate = new Date(item.end_date)
            return startDate <= maxDate && endDate >= minDate
        }))
    const classroomMap = classrooms.reduce((acc, cur) => {
        acc[cur.class_name] = cur
        return acc
    }, {})

    occupied.forEach((item) => {
        const classroom = classroomMap[item.class_name]
        if (!classroom) return

        if (item.start_time) {
            classroom.courseId[item.start_time] = item.course_id
        }
    })
    return classrooms
}

const fetchClassDetail = async (classname) => {
    const lists = await $.ajax({
        url: '/admin/classrooms/detail',
        method: 'GET',
        dataType: 'json',
        data: {
            name: classname
        }
    })
    return lists.filter(item => {
        const minDate = new Date($('#inputMinDate').val())
        const maxDate = new Date($('#inputMaxDate').val())
        const startDate = new Date(item.start_date)
        const endDate = new Date(item.end_date)
        return startDate <= maxDate && endDate >= minDate
    })
}

const fetchInsertClassroom = async (classname, peoplelimit) => {
    return $.ajax({
        url: '/admin/classrooms/insert',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            class_name: classname,
            people_limit: peoplelimit,
            status: 1
        }),
        dataType: 'json'
    })
}

const fetchDeleteClassroom = async (classname) => {
    return $.ajax({
        url: '/admin/classrooms/delete?class_name='+encodeURIComponent(classname),
        method: 'DELETE'
    })
}

const displayList = (listArray) => {
    let html = ''
    listArray.forEach((item, index) => {
        html += `<tr class='classDetail' data-index='`+index+`'>
            <td>`+item.class_name+`</td>
            <td>`+item.people_limit+`</td>
            <td>
            <span class='badge `+(item.courseId['9:00'] ? 'disabled' : '')+`'>오전</span>
            <span class='badge `+(item.courseId['12:00'] ? 'disabled' : '')+`'>점심</span>
            <span class='badge `+(item.courseId['14:00'] ? 'disabled' : '')+`'>오후</span>
            </td>
            </tr>`
    })
    $('#classroomList').html(html)
}

const displayDetail = (classDetail, courseList) => {
    let html = ''
    html +=
        `<div style = "display: flex; justify-content: space-between; align-items: center" id='classroomDetail' data-classname='`+classDetail.class_name+`'>
        <h4>강의실 정보</h4>
    <div>
        <button id='btnRemoveClassroom'>삭제</button>
        <button id='btnCloseDetail'>닫기</button>
    </div>
</div>
    <table>
        <thead><colgroup>
                    <col style="width: 25%"><col style="width: 25%"><col style="width: 25%"><col style="width: 25%">
                </colgroup></thead>
        <tbody>
        <tr>
            <th>강의실명</th>
            <td>`+classDetail.class_name+`</td>
            <th>수용인원</th>
            <td>`+classDetail.people_limit+`</td>
        </tr>
        </tbody>
    </table>
    <div id='courseDetail'>
    <h4>오전</h4>
    <table>
        <thead><colgroup>
                    <col style="width: 25%"><col style="width: 25%"><col style="width: 25%"><col style="width: 25%">
                </colgroup></thead>
        <tbody id='courseDetail9'>
        <tr><td colspan='4'>강의가 존재하지 않습니다</td></tr>
        </tbody>
    </table>
    <h4>점심</h4>
    <table>
        <thead><colgroup>
                    <col style="width: 25%"><col style="width: 25%"><col style="width: 25%"><col style="width: 25%">
                </colgroup></thead>
        <tbody id='courseDetail12'>
        <tr><td colspan='4'>강의가 존재하지 않습니다</td></tr>
        </tbody>
    </table>
    <h4>오후</h4>
    <table>
        <thead><colgroup>
                    <col style="width: 25%"><col style="width: 25%"><col style="width: 25%"><col style="width: 25%">
                </colgroup></thead>
        <tbody id='courseDetail14'>
        <tr><td colspan='4'>강의가 존재하지 않습니다</td></tr>
        </tbody>
    </table>
    </div>`
    $('#article-detail').html(html)
    courseList.forEach((item) => {
        const html = `
        <tr>
            <th>강의명</th>
            <td colSpan="3">`+item.title+`</td>
        </tr>
        <tr>
            <th>강의기간</th>
            <td colSpan="3">`+dateConvert(item.start_date)+` ~ `+dateConvert(item.end_date)+`</td>
        </tr>
        <tr>
            <th>주 강사</th>
            <td>`+item.professor_name+`</td>
            <th>보조 강사</th>
            <td>`+item.sub_prof_name+`</td>
        </tr>`
        if(item.start_time === '9:00') $('#courseDetail9').html(html)
        if(item.start_time === '12:00') $('#courseDetail12').html(html)
        if(item.start_time === '14:00') $('#courseDetail14').html(html)
    })
}

const displayInsertClassroom = () => {
    const html =
        `<div style="display:flex; justify-content: end">
            <button style='margin-right: 10px' id="btnInsertClassroom">저장</button>
            <button id="btnCloseDetail">닫기</button>
        </div>
        <table>
            <thead>
                <colgroup>
                    <col style="width: 25%"><col style="width: 25%"><col style="width: 25%"><col style="width: 25%">
                </colgroup>
            </thead>
            <tbody>
            <tr>
                <th>강의실 명</th>
                <td><input type="text" id="inputClassroomName"></td>
            </tr>
            <tr>
                <th>수용 인원</th>
                <td><input type="number" id="inputPeopleLimit" min='1' max='40'></td>
            </tr>
            </tbody>
        </table>`
    $('#article-detail').html(html)
}

const initialLoad = async () => {
    try {
        cachedClassrooms = await fetchClassroomList()
        currentList = [...cachedClassrooms]
        displayList(currentList)
    } catch (error) {
        console.error(error)
    }
}

const dateConvert = (inputDate) => {
    const date = new Date(inputDate)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return year+'-'+month+'-'+day
}

$(function () {
    $('#inputMinDate').val(dateConvert(new Date()))
    $('#inputMaxDate').val(dateConvert(new Date()))
    initialLoad()


    $(document).on('click', '.classDetail', async function () {
        const classInfo = currentList[$(this).data('index')]
        try {
            const courseInfo = await fetchClassDetail(classInfo.class_name)
            displayDetail(classInfo, courseInfo)
        } catch (error) {
            console.error(error)
        }
    })

    $(document).on('click', '#btnCloseDetail', function () { $('#article-detail').html('') })
    $(document).on('click', '#btnInsertClassroom', async function () {
        const classname = $('#inputClassroomName').val().trim()
        const peoplelimit = $('#inputPeopleLimit').val().trim()
        if(!classname) {
            alert('강의실 명을 입력하세요')
            return
        }
        if (!peoplelimit) {
            alert('수용 인원을 입력해주세요.')
            return
        }
        const peopleNum = parseInt(peoplelimit)
        if (isNaN(peopleNum) || peopleNum < 1 || peopleNum > 40) {
            alert('수용 인원은 1~40 사이의 숫자여야 합니다.')
            return
        }
        try {
            await fetchInsertClassroom(classname, peopleNum)
            alert('강의실이 추가되었습니다.')
            cachedClassrooms = await fetchClassroomList()
            currentList = [...cachedClassrooms]
            displayList(currentList)
            $('#article-detail').html('')
        } catch (error) {
            console.error(error)
            alert('강의실 추가 중 오류가 발생했습니다.')
        }
    })
    $(document).on('click', '#btnRemoveClassroom', async function() {
        const className = $('#classroomDetail').data('classname');
        if (!className) return
        if (!confirm(`강의실을 정말 삭제하시겠습니까?`)) return
        try {
            await fetchDeleteClassroom(className)
            alert('삭제가 완료되었습니다')
            cachedClassrooms = await fetchClassroomList()
            currentList = [...cachedClassrooms]
            displayList(currentList)
            $('#article-detail').html('')
        } catch (error) {
            console.error(error)
            alert('강의실 삭제 중 오류가 발생했습니다.')
        }
    })

    $('#btnToggle09').on('click', function () {
        timeFilter["9:00"] = !timeFilter["9:00"]
        $(this).toggleClass('active')
    })

    $('#btnToggle12').on('click', function () {
        timeFilter["12:00"] = !timeFilter["12:00"]
        $(this).toggleClass('active')
    })

    $('#btnToggle14').on('click', function () {
        timeFilter["14:00"] = !timeFilter["14:00"]
        $(this).toggleClass('active')
    })

    $('#btnSearch').on('click', async function () {
        cachedClassrooms = await fetchClassroomList()
        currentList = cachedClassrooms.filter(item => {
            return Object.keys(timeFilter).every(time => {
                if (!timeFilter[time]) return true
                return item.courseId[time] === null
            })
        })
        displayList(currentList)
    })

    $('#btnInsertClassroomForm').click(displayInsertClassroom)
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
                        <jsp:param name="menu2" value="강의실 목록"/>
                        <jsp:param name="refreshUrl" value="${CTX_PATH}/admin/classrooms"/>
                    </jsp:include>

                    <p class="conTitle">
                        <span>강의실 목록</span>
                    </p>

                    <div class="container">
                        <div class="container-header"
                             style="display: flex; justify-content: space-between; align-items: center;">
                            <div class="search-area" style="margin-bottom: 10px;  display: flex; flex-direction: row;">
                                <div>
                                    <h4>강의 기간</h4>
                                    <div style="margin-right: 10px">
                                        <input type="date" id="inputMinDate">
                                        <span> ~ </span>
                                        <input type="date" id="inputMaxDate">
                                    </div>
                                </div>
                                <div>
                                    <h4>가용 시간</h4>
                                    <div>
                                        <button id="btnToggle09">오전</button>
                                        <button id="btnToggle12">점심</button>
                                        <button id="btnToggle14">오후</button>
                                        <button id="btnSearch">검색</button>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <button id="btnInsertClassroomForm">강의실 추가</button>
                            </div>
                        </div>
                        <div id="article-area" style="display: flex; flex-direction: row">
                            <div id="article-table" style="width: 40%">
                                <table>
                                    <colgroup>
                                        <col style="width: 25%">
                                        <col style="width: 35%">
                                        <col style="width: 40%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>강의실명</th>
                                        <th>수용인원</th>
                                        <th>가용시간</th>
                                    </tr>
                                    </thead>
                                    <tbody id="classroomList">
                                    </tbody>
                                </table>
                            </div>
                            <div id="article-detail" style="width: 60%">
                            </div>
                        </div>
	                </div>
                </div>
            </li>
        </ul>
    </div>
</div>
</body>
<style>
    button {
        border: none;
        padding: 8px 14px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        transition: 0.2s;
    }
    button:hover {
        opacity: 0.9;
    }
    #btnSearch, #btnInsertClassroom, #btnInsertClassroomForm {
        background-color: #007bff;
        color: white;
    }
    #btnToggle09, #btnToggle12, #btnToggle14 {
        background-color: #e9ecef;
    }
    .active {
        background-color: #007bff !important;
        color: #fff;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background: #ffffff;
        border-radius: 10px;
        overflow: hidden;
    }
    thead {
        background-color: #f1f3f5;
    }
    th, td {
        padding: 12px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }
    th {
        font-weight: 600;
    }
    .classDetail:hover {
        background-color: #f8f9fa;
        cursor: pointer;
    }
    .badge {
        background-color: #007bff;
        color: #fff;
        border-radius: 8px;
        padding: 3px 6px;
    }
    .disabled {
        background-color: #dee2e6;
        color: transparent;
    }
    #article-detail {
        margin-left: 20px;
    }

    #classroomDetail {
        background: #ffffff;
        padding: 12px 15px;
        border-radius: 10px;
        margin-bottom: 10px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
    }

    /* 상세 테이블 */
    #article-detail table {
        margin-bottom: 15px;
    }
    input[type="text"],
    input[type="number"],
    input[type="date"] {
        padding: 6px 8px;
        border: 1px solid #ccc;
        border-radius: 6px;
        width: 150px
    }
    #classroomDetail button {
        margin-left: 5px;
        background-color: #dc3545;
        color: white;
    }
    #btnCloseDetail {
        background-color: #6c757d !important;
        color: white;
    }
    h4 {
        font-size: 16px;
        font-weight: 600;
        margin: 20px 0 10px;
        padding-left: 10px;
        border-left: 4px solid #007bff;
        color: #333;
    }
</style>
</html>
