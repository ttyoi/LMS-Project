<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>출석관리</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
    <!-- sweet alert import -->
    <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
    <script type="text/javascript">
        // 그룹코드 페이징 설정
        var pageSizeComnGrpCod = 5;
        var pageBlockSizeComnGrpCod = 5;

        // 상세코드 페이징 설정
        var pageSizeComnDtlCod = 5;
        var pageBlockSizeComnDtlCod = 5;

        // 학생출석조회 페이징 설정
        var pageSizeStuAttDtl = 5;
        var pageBlockSizeStuAttDtl = 5;

        // 출석등록 페이징 설정
        var pageSizeComnStuAttReg = 5;
        var pageBlockSizeStuAttReg = 5;
        //페이지 실행 시 선처리
        $(function(){
            //그룹코드 조회
            fCourseList();

            //버튼 이벤트 등록
            fRegisterButtonClickEvent();
            //콤보박스 데이터 불러옴
            comcombo("","testsel","all","");

            fInitStuAttRadioBtn();

            let curDate = new Date().toLocaleDateString().replace(/\./g, '').replace(/\s/g, '-');
            console.log('curDate=',new Date().toLocaleDateString().replace(/\./g, '').replace(/\s/g, '-'));

            $(".att_date").append(curDate);

            $("#stuAttDtlList").on("click", '.BtnStuAttModify', function () {
                //currentPage = currentPage || 1;
                let btnClick = $(this);
                let row = btnClick.closest('tr');
                let inputTags = row.children('input');
                let currentRow = btnClick.closest('a');
                let tdRows = row.children('td[class=radioWrap]');
                let inputRows = tdRows.children('input');

                console.log('inputTags=',inputTags);
                //강의ID
                let course_id = inputTags[0].value;
                //과목명
                let cour_title = inputTags[1].value;
                //출석일
                let att_date = inputTags[2].value;
                let att_code = inputTags[3].value;
                console.log('course_id=',course_id,'cour_title=',cour_title,'att_date=',att_date);

                <%--let att_date = row.children('td[class=attDateWrap]').find('span');--%>
                <%--console.log('att_date=',att_date.text());--%>

                let iAtt_date = $(`<input type='hidden' name='att_date' value='${att_date.text()}'/>`)

                for(let i=0; i<inputRows.length; i++) {
                    console.log(inputRows[i])
                    inputRows[i].setAttribute('onclick','return false;');
                }

                let btnModify = `<a class="btnType3 color2 btnModify">수정</a>`
                console.log('currentRow=',currentRow);
                currentRow.hide();
                currentRow.closest('td').append(btnModify);

                let att_sta_code = 0;
                for(let i=0; i<inputRows.length; i++) {
                    if(inputRows[i].checked == true) {
                        att_sta_code = (i+1)%5;
                        break;
                    }
                    //inputRows[i].setAttribute('onclick','');
                }

                let param = {
                    course_id:course_id,
                    cour_title:cour_title,
                    att_date:att_date,
                    att_sta_code:att_sta_code,
                    att_code:att_code,
                }

                var resultCallback = function(data){
                    fStuAttModifyResult(data);
                }

                callAjax('/inst/modifyStuAtt',"post","json",true,param,resultCallback);
            })
        })
        function fStuAttModifyResult(data){
            if(data.resultMsg === 'SUCCESS'){
                swal('수정되었습니다.')
            }else{
                swal("Update Fail 관리자에게 문의해주세요.")
            }
        }
        function fInitStuAttRadioBtn() {
            $("#stuAttDtlList").on("click", ".btnModify", function () {
                //수정버튼을 완료버튼으로 토글하기
                let btnClick = $(this);
                let row = btnClick.closest('td');

                let btnRegHtml = `<a class='btnType3 color1 BtnStuAttModify'>완료</a>`;
                console.log(btnClick);

                console.log(row);
                //수정버튼을 클릭하는 순간 radio 버튼 값 변경하기
                fBtnRadioToggle(btnClick);

                btnClick.hide();
                row.empty().append(btnRegHtml);
            })
        }

        function fBtnRadioToggle(btnClick){
            let row = btnClick.closest('tr');
            let tdRows = row.children('td[class=radioWrap]');
            let inputRows = tdRows.children('input');

            for(let i=0; i<inputRows.length; i++) {
                console.log(inputRows[i])
                inputRows[i].setAttribute('onclick','');
            }
            console.log(btnClick);
            console.log(row);

        }

        //버튼 이벤트 관리 선처리할 때 먼저 실행됨
        function fRegisterButtonClickEvent(){
            $('a[name=btn]').click(function(){

                var btnId = $(this).attr('id');

                switch(btnId){
                    case 'btnSearchCourseList':
                        fSearchCourseList();
                        break;
                    case 'btnStuAttDtlRegList':
                        fStuAttDtlRegList();
                        break;
                    // case 'btnStudentAttReg':
                    //     fStuAttDtlReg();
                    //     break;
                    // case 'btnStudentAttRegClose':
                    //     fStuAttDtlRegClose();
                    //     break;
                    case 'btnSaveGrpCod':
                        break;
                }
            })
        }

        /** 그룹코드 폼 초기화 */
        function fInitFormCourse(object) {
            console.log('object.course.title=',object.stuAttDtlList);
            // var start_date = object.course.start_date;
            // var end_date = object.course.start_date;


            $("#grp_cod").focus();
            if( object == "" || object == null || object == undefined) {

                $("#cour_title").val("");
                $("#cour_inst").val("");
                $("#cour_date").val("");
                $("#cour_att").val("");
                $("#cour_per").val("");
                $("#cour_abs").val("");
                $("#grp_cod").attr("readonly", false);
                $("#grp_cod").css("background", "#FFFFFF");
                $("#grp_cod").focus();
                $("#btnDeleteGrpCod").hide();

            } else {
                for(let list in object.stuAttDtlList) {
                    $("#cour_title").val(list.prof_nm);
                    $("#cour_inst").val(list.stu_nm);
                    $("#cour_date").val(list.cour_title);

                    $("#cour_att").val(list.att_date);
                    $("#cour_per").val(list.att_code);
                }
                $("#grp_cod").attr("readonly", true);
                $("#grp_cod").css("background", "#F5F5F5");
                $("#grp_cod_nm").focus();



                if(object.tmp_fld_01>0){
                    $("#btnDeleteGrpCod").hide();
                }else{
                    $("#btnDeleteGrpCod").show();
                }
            }
        }
        //전체강의목록 조회
        function fCourseList(currentPage) {
            currentPage = currentPage || 1;

            // var sname = $('#sname');
            // var searchKey = document.getElementById("searchKey");
            // var oname = searchKey.options[searchKey.selectedIndex].value;

            console.log(currentPage);

            var param = {
                currentPage: currentPage
                ,pageSize : pageSizeComnGrpCod
            }

            var resultCallback = function (data) {
                console.log('resultCallback', data);
                flistGrpCodeResult(data, currentPage);
            }

            callAjax("/inst/allCourseList", "post", "text", true,param, resultCallback);
        }

        function flistGrpCodeResult(data, currentPage){
            $("#listCourse").empty();

            $("#listCourse").append(data);

            //var $data = $($(data).html());

            var totalCntComnDtlCod = $("#courseTotalCount").val();

            // var grp_cod = $("#tmpGrp_cod").val();
            // var grp_cod_nm = $("#tmpGrpCodNm").val();
            var paginationHtml = getPaginationHtml(currentPage,totalCntComnDtlCod, pageSizeComnGrpCod ,pageBlockSizeComnGrpCod, 'fCourseList');
            $("#comnGrpCodPagination").empty().append(paginationHtml);

            $("#currentPageComnGrpCod").val(currentPage);
        }
        function fListCourseStudent(currentPage,courseId){
            console.log('courseId=',courseId,'currentPage=',currentPage);
            currentPage = currentPage || 1;
            let param = {
                currentPage: currentPage,
                course_id: courseId,
                pageSize:pageSizeComnDtlCod

            }
            var resultCallback = function (data) {
                fListCourseStudentResult(data,currentPage);
            }
            callAjax('/inst/courseStudentList',"post","text",true,param, resultCallback);
        }
        function fListCourseStudentResult(data, currentPage){
            $("#listStdDtl").empty();
            $("#listStdDtl").append(data);
            var totalCntComnDtlCod = $("#att_totalCount").val();
            console.log('stuAtt_totalCount=',totalCntComnDtlCod);
            // var grp_cod = $("#tmpGrp_cod").val();
            // var grp_cod_nm = $("#tmpGrpCodNm").val();
            var paginationHtml = getPaginationHtml(currentPage,totalCntComnDtlCod, pageSizeComnGrpCod ,pageBlockSizeComnGrpCod, 'fListCourseStudent');
            $("#comnDtlCodPagination").empty().append(paginationHtml);

            $("#currentPageComnGrpCod").val(currentPage);

        }
        function fStuAttDtl(currentPage,courseId,stu_loginID){
            console.log('courseId=',courseId,'stu_loginID=',stu_loginID,'currentPage=',currentPage);
            currentPage = currentPage || 1;
            let param = {
                currentPage: currentPage,
                course_id: courseId,
                stu_loginID: stu_loginID,
                pageSize:pageSizeStuAttDtl
            }
            var resultCallback = function (data) {
                fStuAttDtlResult(data,param,currentPage);
            }
            callAjax('/inst/stuAttDtlList', 'post','text',true,param, resultCallback);
        }
        function fStuAttDtlResult(data,param,currentPage){
            console.log('fStuAttDtlResult=',data);
            gfModalPop("#layer2");
            fInitFormCourse(data);
            $("#stuAttDtlList").empty();
            $("#stuAttDtlList").append(data);
            let hCourse_id = $("#course_id").val();
            let hStu_loginID = $("#stu_loginID").val();
            //courseId= 1 stu_loginID= 3 currentPage= sunnyday
            //courseId,stu_loginID,currentPage 매개변수 순서
            //currentPage,courseId, stu_loginID 리턴 순서
            let params = [param.course_id,param.stu_loginID];
            var att_totalCount = $("#stuAtt_totalCount").val();
            console.log('att_totalCount=',att_totalCount);
            // var grp_cod = $("#tmpGrp_cod").val();
            // var grp_cod_nm = $("#tmpGrpCodNm").val();
            var paginationHtml = getPaginationHtml(currentPage,att_totalCount, pageSizeStuAttDtl ,pageBlockSizeStuAttDtl, 'fStuAttDtl',params);
            $("#stuAttDtlPagination").empty().append(paginationHtml);

            $("#stuAttDtlPagination").val(currentPage);
        }


        //등록하기
        function fStuAttDtlRegList(){
            let course_id = $('#course_id').val();
            console.log(course_id);
            if(course_id == null || course_id == '' || course_id === undefined){
                swal("먼저 학생조회를 해주세요!");
                return;
            }
            var param = {
                course_id: course_id,
            }
            var resultCallback = function (data) {
                fStuAttDtlRegListResult(data);
            }
            callAjax('/inst/stuAttDtlRegList',"post", "text", true, param, resultCallback);
        }
        function fStuAttDtlRegListResult(data){
            gfModalPop("#layer1");
            $("#stdAttDtlRegList").empty();
            $("#stdAttDtlRegList").append(data);
        }
        function fStuAttDtlReg(e){
            //강의ID, 일자, 학생loginID, 출결코드
            let course_id = $('#course_id').val();
            let title = $('#title').val();
            let date = new Date().toLocaleDateString().replace(/\./g, '').replace(/\s/g, '-');
            let totalCnt = $(".dataRow").length;
            console.log('totalCnt=',totalCnt);

            let attDataList = [];
            $(".dataRow").each(function (index, element) {
                let row = $(element);
                console.log(row);
                let course_id = row.find("input[name=dtl_course_id]").val();
                let stu_loginID = row.find("input[name=stu_loginID]").val();
                let att_code = row.find('input[type=radio]:checked').val();
                let att_count = row.find('input[name=att_totalCount]').val();

                if(att_code === undefined){

                    return false;
                }
                console.log('index=',index,'att_code=',att_code);

                let param = {
                    course_id: course_id,
                    loginID: stu_loginID,
                    date: date,
                    att_sta_code: att_code,
                }
                console.log('att_count=',att_count);
                attDataList.push(param);
            })
            console.log('데이터목록=', attDataList);

            if(totalCnt != attDataList.length){
                swal('출결 상태를 모두 선택해주세요!');
                return false;
            }
            let resultCallback = function (data) {
                fStuAttDtlRegResult(data);
            }

            $.ajax({
                url: '/inst/stuAttDtlReg',
                type: 'POST',
                dataType: 'json',
                async: true,
                data: JSON.stringify(attDataList),
                contentType: "application/json",
                success: function (data) {
                    resultCallback(data);
                },
                error: function (xhr, status, err) {
                    console.log("xhr : " + xhr);
                    console.log("status : " + status);
                    console.log("err : " + err);

                    if (xhr.status == 901) {
                        alert("로그인 정보가 없습니다.\n다시 로그인 해 주시기 바랍니다.");
                        location.replace('/login.do');
                    } else {
                        alert('A system error has occurred.' + err);
                    }
                },
                complete: function (data) {
                    $.unblockUI();
                }
            })
            gfCloseModal();
            //callAjax('/inst/stuAttDtlReg',"post","json",true,attDataList,resultCallback);
        }
        function fStuAttDtlRegResult(data){
            if(data.resultMsg === 'duplicated'){
                swal("이미 출석등록을 하셨습니다.");
                return;
            }
            if(data.resultMsg === 'SUCCESS'){
                swal("등록되었습니다.");
            }else{
                swal("error 관리자에게 문의해주세요!");
            }
        }
        function fStuAttDtlRegClose(){
            console.log("취소");
            gfCloseModal();
        }
    </script>
    <!-- sweet swal import -->
</head>
<body>
<div id="mask"></div>
<div id="wrap_area">
    <h2 class="hidden">header 영역</h2>
    <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

    <h2 class="hidden">컨텐츠 영역</h2>
    <div id="container">
        <ul>
            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
            </li>
            <li class="contents">
                <h3 class="hidden">contents 영역</h3>
                <div class="content">
                    <p class="Location">
                        <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                        <span class="btn_nav bold">나의 강의 관리</span>
                        <span class="btn_nav bold">출석 관리</span>
                        <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
                    </p>

                    <p class="conTitle">
                        <span style="margin-right: 10px">출석관리</span>
                        <span>
                            <select style="width:150px; height:25px;">
                                <option value="grp_cod">선택</option>
                                <option value="grp_cod_nm">과목</option>
                            </select>
                            <input type="text" style="width:150px; height:25px; margin-right: 20px" id="sname" name="sname" />
                            <input type="date" style="width:150px; height:25px;" name="start_date" /> ~
                            <input type="date" style="width:150px; height:25px;" name="end_date" />
                            <a href="" class="btnType blue" style="margin-left: 10px" id="btnSearchCourseList" name="btn"><span>검  색</span></a>
<%--                            <a class="btnType blue" href="javascript:fPopModalComnGrpCod();" name="modal"><span>신규등록</span></a>--%>
                        </span>
                    </p>
                    <div class="divCourseList">
                        <table class="col">
                            <caption>caption</caption>
                            <colgroup>
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">순번</th>
                                    <th scope="col">과목</th>
                                    <th scope="col">강사명</th>
                                    <th scope="col">강의시작일</th>
                                    <th scope="col">강의종료일</th>
                                    <th scope="col">수강인원</th>
                                    <th scope="col">정원</th>
                                    <th scope="col">출석</th>
                                </tr>
                            </thead>
                            <tbody id="listCourse"></tbody>
                        </table>
                    </div>
                    <div class="paging_area" id="comnGrpCodPagination"></div>
                    <p class="conTitle mt50">
                        <span>학생명단</span>
                        <span class="fr">
                            <a class="btnType blue" href="javascript:void(0)" id="btnStuAttDtlRegList" name="btn"><span>등  록</span></a>
                        </span>
                    </p>
                    <div class="divStuDtlList">
                        <table class="col">
                            <caption>caption</caption>
                            <colgroup>
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">순번</th>
                                    <th scope="col">강사명</th>
                                    <th scope="col">학생명</th>
                                    <th scope="col">과목명</th>
                                    <th scope="col">출석</th>
                                    <th scope="col">지각</th>
                                    <th scope="col">조퇴</th>
                                    <th scope="col">외출</th>
                                    <th scope="col">결석</th>
                                </tr>
                            </thead>
                            <tbody id="listStdDtl">
                            </tbody>
                        </table>
                    </div>
                    <div class="paging_area"  id="comnDtlCodPagination"> </div>
                </div>
                <h3 class="hidden">풋터 영역</h3>
                <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
            </li>
        </ul>
    </div>
</div>
<%--모달팝업--%>
<%--출석등록하기--%>
<div id="layer1" class="layerPop layerType2"  style="width: 600px;">
    <dl>
        <dt>
            <strong>출석등록</strong>
        </dt>
        <dd>
            <span class="att_date" style="font-weight: bold"></span>
            <table class="col">
                <caption>caption</caption>
                <colgroup>
                    <col>
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">순번</th>
                        <th scope="col">강사명</th>
                        <th scope="col">학생명</th>
                        <th scope="col">과목명</th>
                        <th scope="col">출석</th>
                        <th scope="col">지각</th>
                        <th scope="col">조퇴</th>
                        <th scope="col">외출</th>
                        <th scope="col">결석</th>
                    </tr>
                </thead>
                <tbody id="stdAttDtlRegList">
                    <%-- 리스트 --%>
                </tbody>
            </table>
        </dd>
    </dl>
</div>
<%--학생수정모달--%>
<div id="layer2" class="layerPop layerType2"  style="width: 700px;">
    <dl>
        <dt>
            <strong>학생 출석 조회</strong>
            <span class="fr">
                <input type="date" style="width:150px; height:25px;"/>
                <a class="btnType blue" href="" name="modal"><span>조회</span></a>
            </span>
        </dt>
        <dd class="content">
            <table class="col">
                <caption>caption</caption>
                <colgroup>
                    <col>
                </colgroup>
                <thead>
                    <th scope="col">순번</th>
                    <th scope="col">강사명</th>
                    <th scope="col">학생명</th>
                    <th scope="col">과목명</th>
                    <th scope="col">출석일</th>
                    <th scope="col">출석</th>
                    <th scope="col">지각</th>
                    <th scope="col">조퇴</th>
                    <th scope="col">외출</th>
                    <th scope="col">결석</th>
                    <th scopde="col">비고</th>
                </thead>
                <tbody id="stuAttDtlList">
                </tbody>
            </table>
            <div class="paging_area" id="stuAttDtlPagination"></div><br>
            <div style="text-align: center">
                <a href="javascript:fStuAttDtlRegClose()" class="btnType3 color1">닫기</a>
            </div>
        </dd>
    </dl>
</div>
</body>
</html>