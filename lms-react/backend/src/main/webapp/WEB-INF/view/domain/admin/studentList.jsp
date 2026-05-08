<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>이용자 목록</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <script src="https://code.jquery.com/jquery-4.0.0.js" integrity="sha256-9fsHeVnKBvqh3FB2HYu7g2xseAZ5MlN6Kz/qnkASV8U=" crossorigin="anonymous"></script>
</head>
<script>
    const fetchList = async (userType, param = {}) => {
        const urlMap = {
            S: '/api/admin/stu',
            I: '/api/admin/inst'
        }

        const defaultParam = {
            pageSize: 10,
            sname: '',
            searchType: '',
            statusFilter: ''
        }
        const finalParam = {
            ...defaultParam,
            ...param
        }

        return $.ajax({
            url: urlMap[userType],
            method: 'GET',
            dataType: 'json',
            data: finalParam
        })
    }

    const fetchDetail = async (loginID, userType) => {
        const urlMap = {
            S: '/api/admin/stu/stuDetail',
            I: '/api/admin/inst/instDetail'
        }
        return $.ajax({
            url: urlMap[userType],
            method: 'POST',
            dataType: 'json',
            data: {
                loginID: loginID
            }
        })
    }

    const fetchInstEval = async (loginID) => {
        return $.ajax({
            url: '/api/admin/inst/eval',
            method: 'POST',
            dataType: 'json',
            data: {
                loginID: loginID
            }
        })
    }

    const fetchCourse = async (loginID, userType) => {
        const urlMap = {
            S: '/api/admin/stu/courses',
            I: '/api/admin/inst/courses'
        }
        return $.ajax({
            url: urlMap[userType],
            method: 'POST',
            dataType: 'json',
            data: {
                loginID: loginID
            }
        })
    }

    const fetchUpdate = async (loginID, userType, userStatus, content) => {
        const urlMap = {
            S: ['/api/admin/stu/updateStudentStatus'],
            I: ['/api/admin/inst/updateInstructorStatus','/api/admin/inst/eval/save']
        }
        const requests = urlMap[userType].map((url) => {
            return $.ajax({
                url: url,
                method: 'POST',
                dataType: 'json',
                data: {
                    loginID: loginID,
                    status: userStatus,
                    content: content
                }
            })
        })
        return Promise.all(requests)
    }

    const fetchNewInstID = async () => {
        return $.ajax({
            url: '/inst/registerid',
            method: 'GET',
            dataType: 'text'
        })
    }

    const fetchRegisterInst = async (regID, email) => {
        return $.ajax({
            url: '/inst/registerInstructor',
            method: 'POST',
            dataType: 'text',
            data: {
                id: regID,
                email: email
            }
        })
    }

    const displayList = (listArray) => {
        let html = ''
        listArray.forEach((item) => {
            const phoneRegex = /^\d{3}-\d{4}-\d{4}$/;
            let phone = phoneRegex.test(item.phone) ? item.phone : "";
            html += `<tr class='userDetail'>
                <td>`+item.loginID+`</td>
                <td>`+item.name+`</td>
                <td>`+phone+`</td>
                <td class='`+(item.status === 'W'? 'status-w':item.status === 'R'? 'status-r':item.status === 'D'? 'status-d':'status-q')+`'>
                `+(item.status === 'W'? '가입중':'')+
                (item.status === 'R'? '활성':'')+
                (item.status === 'D'? '일시정지':'')+
                (item.status === 'Q'? '탈퇴':'')+`
                </td>
                </tr>`
        })
        $('#userList').html(html)
    }

    const displayDetail = (userDetail, courses, userType, instEval='') => {
        const html = `<div>
            <div style="display: flex; justify-content: space-between">
            <h4>인적 사항</h4>
        <div>
            <button id="saveDetail">저장</button>
            <button id="closeDetail">닫기</button>
        </div>
    </div>
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
                <th>아이디</th>
                <td>`+userDetail.loginID+`</td>
                <th>이름</th>
                <td>`+userDetail.name+`</td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td>`+userDetail.phone+`</td>
                <th>생년월일</th>
                <td>`+userDetail.birthday+`</td>
            </tr>
            <tr>
                <th>성별</th>
                <td>`+userDetail.gender+`</td>
                <th>가입일</th>
                <td>`+userDetail.reg_date+`</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td colspan="3">`+userDetail.email+`</td>
            </tr>
            <tr>
                <th>주소</th>
                <td colspan="3">`+userDetail.addr1+' '+userDetail.addr2+`</td>
            </tr>
            <tr>
                <th>`+(userType === 'S'? '이력서':'학력')+`</th>
                <td colspan="3" id='SResumeIHistory'></td>
            </tr>
            <tr>
                <th>계정 상태 변경</th>
                <td colspan='3'>
                <select id="updateStatus" data-origin="`+userDetail.status+`">
                    <option value="R" `+(userDetail.status === 'R'? "selected":"")+`>활성</option>
                    <option value="D" `+(userDetail.status === 'D'? "selected":"") +`>일시정지</option>
                    <option value="Q" `+(userDetail.status === 'Q'? "selected":"")+`>탈퇴</option>
                </select>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
        <div>
            <h4>강의 목록</h4>
            <table>
                <thead>
                <colgroup>
                <col style="width: 25%">
                <col style="width: 35%">
                <col style="width: 20%">
                <col style="width: 20%">
                </colgroup>
                <tr>
                    <th>강의명</th>
                    <th>기간</th>
                    <th>강의실</th>
                    <th>강의 상태</th>
                </tr>
                </thead>
                <tbody id='courseDetail'>
                </tbody>
            </table>
        </div>`+(userType === 'S'? "":`<div><h4>강사 평가 및 특이사항</h4><textarea placeholder="강사 평가 및 특이사항을 입력하세요" id="txtInstEval" data-origin='`+instEval+`'>`+instEval+`</textarea></div>`)

        $('#detailArea').html(html)
        $('#detailArea').data('loginID', userDetail.loginID)
        $('#detailArea').data('userType', userType)

        if(userType === 'S') {
            const text = (userDetail.hasResume? userDetail.resumeName:'이력서가 존재하지 않습니다')
            $('#SResumeIHistory').append(text)
        } else {
            const text = (userDetail.edu_level === null? '': userDetail.edu_level) + ' ' + (userDetail.career === null? '': userDetail.career)
            $('#SResumeIHistory').append(text)
            $('#updateStatus').append(`<option value="W" `+(userDetail.status === 'W' ? "selected" : "")+`>가입중</option>`)
            $('#updateStatus').val(userDetail.status)
        }

        if(courses.length === 0) $('#courseDetail').append("<tr><td colspan='5' style='text-align: center'>강의가 존재하지 않습니다</td></tr>")
        else courses.forEach((item) => {
            const html = `<tr>
                    <td>`+item.title+`</td>
                    <td>`+item.start_date+' ~ '+item.end_date+`</td>
                    <td>`+item.class_name+`</td>
                    <td>`+item.scs_name+`</td>
                </tr>`
            $('#courseDetail').append(html)
        })
        $('#saveDetail').toggleClass('disabled', true)
        $('#saveDetail').prop('disabled', true);
    }

    const displayRegisterInst = (regID) => {
        const html = `<div style="display: flex; justify-content: space-between">
            <h4>신규 강사계정 등록</h4>
            <div>
                <button id="btnRegisterSend">저장</button>
                <button id="closeDetail">닫기</button>
            </div>
        </div>
        <table>
            <thead></thead>
            <tbody>
            <tr>
                <th>아이디</th>
                <td>`+regID+`</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td><input type="email" id="txtRegisterEmail"></td>
            </tr>
            </tbody>
        </table>`

        $('#detailArea').html(html)
        $('#detailArea').data('regID', regID)
        $('#btnRegisterSend').prop('disabled', true)
    }

    const renderPagination = (totalCount, currentPage, pageSize) => {
        const totalPage = Math.ceil(totalCount / pageSize);
        let html = '';
        for(let i = 1; i <= totalPage; i++) {
            html += "<button class='pageBtn' data-page='" + i + "'" +
                    "style='" + (i === currentPage ? 'font-weight:bold;' : '') + "'>" +
                    i + "</button>"
        }
        $('#pagination').html(html);
    }

    const loadList = async (page = 1) => {
        const userType = $('#userType').val()
        const userStatus = $('#userStatus').val()

        const param = {
            currentPage: page,
            pageSize: 10,
            statusFilter: userStatus,
            sname: $('#searchValue').val(),
            searchType: $('#searchParam').val()
        };

        const data = await fetchList(userType, param)
        const listArray = userType === 'S' ? data.studentList : data.instructorList
        const totalCnt = userType === 'S' ? data.studentCnt : data.instructorCnt
        displayList(listArray)
        renderPagination(totalCnt, page, 10)
    }

    const toggleStatusOption = () => {
        const userType = $('#userType').val()
        $('#userStatus option[value="W"]').remove()

        if (userType === 'I') {
            $('#userStatus').append('<option value="W">가입중</option>')
        }
    }

    $(function() {
        loadList(1)
        toggleStatusOption()

    $(document).on('click', '.userDetail', async function() {
        const userType = $('#userType').val()
        const loginID = $(this).find("td:first").text()
        const userDetail = await fetchDetail(loginID, userType)
        const courses = await fetchCourse(loginID, userType)
        const instEval = await fetchInstEval(loginID)
        displayDetail(userDetail, courses.list, userType, instEval.content)
    })

    $(document).on('click', '#closeDetail', function() {
        $('#detailArea').html('')
    })

    $(document).on('click', '.pageBtn', function() {
        const page = $(this).data('page');
        loadList(page);
    })

    $(document).on('change', '#updateStatus', function () {
        const origin = $(this).data('origin')
        const current = $(this).val()

        if (origin !== current) {
            $('#saveDetail').prop('disabled', false)
            $('#saveDetail').toggleClass('disabled', false)
        }
        else {
            $('#saveDetail').prop('disabled', true)
            $('#saveDetail').toggleClass('disabled', true)
        }
    })

    $(document).on('input', '#txtInstEval', function () {
        const origin = $(this).data('origin')
        const current = $(this).val()

        if (origin !== current) {
            $('#saveDetail').prop('disabled', false)
            $('#saveDetail').toggleClass('disabled', false)
        }
        else {
            $('#saveDetail').prop('disabled', true)
            $('#saveDetail').toggleClass('disabled', true)
        }
    })

    $(document).on('click', '#saveDetail', async function() {
        const loginID = $('#detailArea').data('loginID')
        const userType = $('#detailArea').data('userType')
        const userStatus = $('#updateStatus').val()
        let content = ''
        if (userType === 'I') content = $('#txtInstEval').val()

        try {
            const result = await fetchUpdate(loginID, userType, userStatus, content)
            alert('저장 완료')
            $('#updateStatus').data('origin', userStatus)
            $('#saveDetail').prop('disabled', true)
            await loadList(1)
        } catch (e) {
            alert('저장 실패')
            console.error(e)
        }
    })

    $(document).on('click', '#btnRegisterSend', async function(){
        const regID = $('#detailArea').data('regID')
        const email = $('#txtRegisterEmail').val()

        try {
            const result = await fetchRegisterInst(regID, email)
            alert('강사 가입 이메일 발송 처리 완료')
            $('#detailArea').html('')
            await loadList(1)
        } catch (error) {
            console.error(error)
        }
    })

    $(document).on('input', '#txtRegisterEmail', function() {
        const email = $(this).val().trim()
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

        if (emailRegex.test(email)) $('#btnRegisterSend').prop('disabled', false)
        else $('#btnRegisterSend').prop('disabled', true)
    })

    $('#userType').on('change', () => {
        toggleStatusOption()
        loadList(1)
    })
    $('#userStatus').on('change', () => loadList(1))
    $('#btnSearch').click(() => loadList(1))
    $('#btnRegisterInst').click(async () => {
        try {
            const result = await fetchNewInstID()
            displayRegisterInst(result)
        } catch (e) {
            console.error(e)
            alert('ID 발급 실패')
        }
    })
    $('#searchValue').on('keypress', function (e) {
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
					    <jsp:param name="menu1" value="사용자 관리"/>
					    <jsp:param name="refreshUrl" value="${CTX_PATH}/admin/stu"/>
					</jsp:include>
				
	                <p class="conTitle">
	                    <span>사용자 관리</span>
	                </p>
	                    
	                <div class="container">
						<div style="display: flex; justify-content: space-between; margin-bottom: 20px">
                            <div style="display: flex; flex-direction: row;">
                                <div>
                                <h4>정렬 기준</h4>
                                <select id="userType">
                                    <option value="S">학생</option>
                                    <option value="I">강사</option>
                                </select>
                                </div>
                                <div>
                                <h4>계정 상태</h4>
                                <select id="userStatus">
                                    <option value="">전체</option>
                                    <option value="R">활성</option>
                                    <option value="D">일시정지</option>
                                    <option value="Q">탈퇴</option>
                                    <option value="W">가입중</option>
                                </select>
                                </div>
                                <div>
                                    <h4>검색 기준</h4>
                                    <select id="searchParam">
                                        <option value="name">이름</option>
                                        <option value="phone">전화번호</option>
                                        <option value="id">아이디</option>
                                    </select>
                                    <input type="text" id="searchValue"/>
                                    <button id="btnSearch">검색</button>
                                </div>
                            </div>
                            <div>
                                <button id="btnRegisterInst">신규 강사 등록</button>
                            </div>
                        </div>
                        <div style="display:flex; flex-direction: row">
                            <div style="width:40%">
                                <table>
                                    <thead>
                                    <colgroup>
                                        <col style="width: 30%">
                                        <col style="width: 20%">
                                        <col style="width: 35%">
                                        <col style="width: 15%">
                                    </colgroup>
                                    <tr>
                                        <th>아이디</th>
                                        <th>이름</th>
                                        <th>전화번호</th>
                                        <th>계정상태</th>
                                    </tr>
                                    </thead>
                                    <tbody id="userList">
                                    </tbody>
                                </table>
                                <div id="pagination" style="margin-top:20px; text-align:center;"></div>
                            </div>
                            <div style="width:60%" id="detailArea">

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
    select, input[type="text"], input[type="email"] {
        padding: 6px 8px;
        border: 1px solid #ccc;
        border-radius: 6px;
        margin: 0 5px;
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
    button.disabled {
        background-color: #dee2e6 !important;
        color: #adb5bd !important;
        cursor: not-allowed;
        opacity: 0.7;
        pointer-events: none;
    }
    #btnSearch, #btnRegisterInst, #btnRegisterSend, #saveDetail {
        background-color: #007bff;
        color: white;
    }
    #closeDetail {
        background-color: #6c757d;
        color: white;
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
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }
    th {
        font-weight: 600;
    }
    .userDetail:hover {
        background-color: #f8f9fa;
        cursor: pointer;
    }
    #detailArea {
        margin-left: 20px;
    }
    textarea {
        width: 100%;
        min-height: 90px;
        resize: none;
        padding: 10px;
        border-radius: 8px;
        border: 1px solid #ddd;
        margin-top: 10px;
        background-color: #f8f9fa;
    }
    #pagination {
        margin-top: 20px;
    }
    .pageBtn {
        margin: 0 3px;
        padding: 5px 10px;
        border-radius: 5px;
        background-color: #e9ecef;
    }
    .pageBtn:hover {
        background-color: #dee2e6;
    }
    .pageBtn[style*="font-weight:bold"] {
        background-color: #007bff;
        color: white;
    }
    #detailArea > div:first-child {
        background: #ffffff;
        padding: 12px 15px;
        border-radius: 10px;
        margin-bottom: 10px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
    }
    #detailArea button {
        margin-left: 5px;
    }
    .status-r { color: #28a745; font-weight: 600; }
    .status-d { color: #ffc107; font-weight: 600; }
    .status-q { color: #dc3545; font-weight: 600; }
    .status-w { color: #6c757d; font-weight: 600; }
</style>
</html>