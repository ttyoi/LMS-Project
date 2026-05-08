<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<c:if test="${sessionScope.userType ne 'I'}">
    <c:redirect url="/dashboard/dashboard.do"/>
</c:if>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>강의목록</title>
    <!-- sweet alert import -->
    <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
    <!-- sweet swal import -->
    <script type="text/javascript">
        // 그룹코드 페이징 설정
        var pageSizeComnGrpCod = 3;
        var pageBlockSizeComnGrpCod = 5;

        // 상세코드 페이징 설정
        var pageSizeComnDtlCod = 5;
        var pageBlockSizeComnDtlCod = 5;
        //페이지 실행 시 선처리
        $(function(){
            fCoursePlanList();
            //강사 조회
            fListInst();
            //강의실 조회
            fClassList();
            //강의시간 조회
            fCourseTimeList();
            //버튼 이벤트 등록
            fRegisterButtonClickEvent();
            //콤보박스 데이터 불러옴
            comcombo("","testsel","all","");
        })
        //버튼 이벤트 관리 선처리할 때 먼저 실행됨
        function fRegisterButtonClickEvent(){
            $('a[name=btn]').click(function(){
                var btnId = $(this).attr('id');

                switch(btnId){
                    case 'btnSearchCoursePlanList':
                        fSearchCoursePlanList();
                        break;
                    case 'btnCoursePlanReg':
                        fRefCoursePlan();
                        break;
                    case 'btnSaveGrpCod':
                        fSaveCoursePlan();
                        break;
                    case 'btnUpdateCoursePlan':
                        fUpdateCoursePlan();
                        break;
                    case 'btnDeleteCoursePlan':
                        fDeleteCoursePlan();
                        break;
                    case 'btnCloseCoursePlan':
                        fCloseCoursePlan();
                    break;
                }
            })
        }
        function fCloseCoursePlan(){
            gfCloseModal();
        }
        /** 그룹코드 폼 초기화 */
        function fInitFormCoursePlan(object) {
            //console.log('object.course.title=',object.course);
            // var start_date = object.course.start_date;
            // var end_date = object.course.start_date;


            $("#grp_cod").focus();
            if( object == "" || object == null || object == undefined) {

                $("#title").val("");
                $("#content").val("");
                $("#notice").val("");
                $("#plan").val("");
                $("#start_date").val("");
                $("#end_date").val("");
                $("#setMonths").val("");
                $("#grp_cod").attr("readonly", false);
                $("#grp_cod").css("background", "#FFFFFF");
                $("#grp_cod").focus();
                $("#btnDeleteGrpCod").hide();

            } else {
                let months = fSetDate(object.course.start_date);
                //$("input[name=]:checked").each(function(){})
                console.log(object.course.class_name);
                console.log(object.course.inst_name);
                console.log(object.course.sub_prof);

                $("#title").val(object.course.title);
                $("#content").val(object.course.content);
                $("#notice").val(object.course.notice);
                $("#plan").val(object.course.plan);
                $("#start_date").val(object.course.start_date);
                $("#end_date").val(object.course.end_date);
                $("#setMonths").val(months);
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
        // function fCoursePlanList(){
        //
        //     var resultCallback = function(data){
        //         fRefCoursePlan(data)
        //     }
        //     callAjax('/inst/getCoursePlanList',"post","text",true,param,resultCallback);
        // }

        function fRefCoursePlan(){
                gfModalPop('#layer1');
                fInitFormCoursePlan();
                $("#updateCoursePlan").hide();
                $("#insertCoursePlan").show();;
        }
        function fSaveCoursePlan(){
            let title = $("#title");
            let professor =  document.getElementById("instlist1").value;
            let sub_prof = document.getElementById("instlist2").value;
            let classId = document.getElementById("classlist").value;
            let start_date = $("#start_date");
            let end_date = $("#end_date");
            let time_code = document.getElementById("classTimelist").value
            let content = $("#content");
            let notice = $("#notice");
            let plan = $("#plan");

            console.log('title=',title
                ,'professor=',professor
                ,'sub_prof=',sub_prof
                ,'classId=',classId
                ,'start_date=',start_date
                ,'end_date=',end_date
                ,'content=',content
                ,'notice=',notice
                ,'plan=',plan)

            var params = {
                title:title.val()
                ,professor:professor
                ,sub_prof:sub_prof
                ,classId:classId
                ,start_date:start_date.val()
                ,end_date:end_date.val()
                ,time_code:time_code
                ,content:content.val()
                ,notice:notice.val()
                ,plan:plan.val()
            };

            var resultCallback = function(data){
                    swal('등록되었습니다.');
                    gfCloseModal();

            }
            callAjax('/inst/regCoursePlan',"post","text",true,params,resultCallback);
        }

        //강사목록
        function fListInst(){
            var resultCallback = function(data){
                console.log('resultCallback=',data)
                fSelectInstListResult(data);
            }
            callAjax('/inst/instlist',"post","json",true,"",resultCallback);
        }
        function fSelectInstListResult(data){
            let instlist1 =  document.getElementById("instlist1");
            let instlist2 =  document.getElementById("instlist2");

            console.log(instlist1);
            $(instlist1).append("<option value=''>선택</option>");
            for(let i=0; i<data.instlist.length;i++){
                $(instlist1).append("<option value='"+data.instlist[i].loginID+"'>"+data.instlist[i].name+"</option>");
            }
            $(instlist2).append("<option value=''>선택</option>");
            for(let i=0; i<data.instlist.length;i++){
                $(instlist2).append("<option value='"+data.instlist[i].loginID+"'>"+data.instlist[i].name+"</option>");
            }
        }
        //강의실목록
        function fClassList(){
            var resultCallback = function(data){
                fSelectClassListResult(data);
            }
            callAjax('/inst/classList',"post","json",true,"",resultCallback);
        }
        function fSelectClassListResult(data) {
            console.log(data);
            let classlist = document.getElementById("classlist");
            $(classlist).append("<option value=''>선택</option>");

            for (let i = 0; i < data.classlist.length; i++) {
                $(classlist).append("<option value='" + data.classlist[i].class_id + "'>" + data.classlist[i].class_name + "</option>");
            }
        }
        //강의시간
        function fCourseTimeList(){
            var resultCallback = function(data){
                fSelectClassTimeListResult(data);
            }
            callAjax('/inst/classTimelist',"post","json",true,"",resultCallback);
        }
        function fSelectClassTimeListResult(data){
            let courseTimelist = document.getElementById("classTimelist");
            $(courseTimelist).append("<option value=''>선택</option>");

            for (let i = 0; i < data.classTimelist.length; i++) {
                $(courseTimelist).append("<option value='" + data.classTimelist[i].time_code + "'>" + data.classTimelist[i].start_time +" - "+ data.classTimelist[i].end_time + "</option>");
            }
        }
        function fChangeDate(){
            let startDate = $("#start_date").val();
            let endDate = $("#end_date");
            let setEndDate = '';
            let splitDate = startDate.split("-");
            let setMonths = $("#setMonths");


            console.log(splitDate[0]);
            let date = new Date(splitDate[0],splitDate[1],splitDate[2]);
            const year = date.getFullYear();
            const month = (date.getMonth()+3).toString().padStart(2,'0');
            const day = date.getDate().toString().padStart(2,'0');
            console.log(date.getFullYear());

            let date2 = new Date(year,month,day);
            let diffMonths = date2.getMonth() - date.getMonth();

            setEndDate = year + "-" + month + "-" +day;

            endDate.val(setEndDate);
            setMonths.val(diffMonths)
        }

        //계획서조회
        function fCoursePlanList(currentPage){
            currentPage = currentPage||1;
            var sname = $("#sname");
            var searchKey = document.getElementById("searchKey");
            var oname = searchKey.options[searchKey.selectedIndex].value;

            var param = {
                title : sname.val()
                ,oname : oname
                ,currentPage : currentPage
                ,pageSize : pageSizeComnGrpCod
            }

            var resultCallback = function(data){
                fSelectClassPlanListResult(data,currentPage);
            }
            callAjax('/inst/classPlanList',"post","text",true,param,resultCallback);
        }
        function fSelectClassPlanListResult(data,currentPage){
            console.log('fSelectClassPlanListResult=',data);
            $("#listCoursePlan").empty();
            $("#listCoursePlan").append(data);

            var totalCntComnDtlCod = $("#coursePlanTotalCount").val();

            // var grp_cod = $("#tmpGrp_cod").val();
            // var grp_cod_nm = $("#tmpGrpCodNm").val();
            var paginationHtml = getPaginationHtml(currentPage,totalCntComnDtlCod, pageSizeComnGrpCod ,pageBlockSizeComnGrpCod, 'fCoursePlanList');
            $("#comnGrpCodPagination").empty().append(paginationHtml);

            $("#currentPageComnGrpCod").val(currentPage);
        }
        function fListCoursePlanDetail(courseId){
            console.log("courseId=",courseId);
            $("#updateCoursePlan").show();
            $("#insertCoursePlan").hide();
            $("#courseId").val(courseId);
            let param = {
                courseId : courseId,
            }

            var resultCallback = function(data){
                fSelectCoursePlanListResult(data);
            }
            callAjax('/inst/coursePlanDetailList',"post","json",true,param,resultCallback);
        }
        function fSelectCoursePlanListResult(data){
            if(data.result == "SUCCESS"){
                gfModalPop('#layer1');
                fInitFormCoursePlan(data)
            }else{
                console.log(data);
                swal(data.resultMsg);
            }
        }
        function fSetDate(startDate){
            let endDate = $("#end_date");
            let setEndDate = '';
            let splitDate = startDate.split("-");
            //let setMonths = $("#setMonths");

            console.log(splitDate[0]);
            let date = new Date(splitDate[0],splitDate[1],splitDate[2]);
            const year = date.getFullYear();
            const month = (date.getMonth()+3).toString().padStart(2,'0');
            const day = date.getDate().toString().padStart(2,'0');
            console.log(date.getFullYear());

            let date2 = new Date(year,month,day);
            let diffMonths = date2.getMonth() - date.getMonth();

            return diffMonths;
        }

        function fUpdateCoursePlan(){
            let courseId=$("#courseId").val();
            let title = $("#title").val();
            let instlist1 = $("#instlist1").val();
            let instlist2 = $("#instlist2").val();
            let class_id = $("#classlist").val();
            let start_date = $("#start_date").val();
            let end_date = $("#end_date").val();
            let classTimelist = $("#classTimelist").val();
            let content = $("#content").val();
            let notice = $("#notice").val();
            let plan = $("#plan").val();

            console.log('classTimelist=',classTimelist,'start_date=',start_date,'class_id=',class_id);
            console.log("courseId123=",courseId);
            let param = {
                 courseId : courseId
                ,title : title
                ,professor : instlist1
                ,sub_prof : instlist2
                ,time_code : classTimelist
                ,start_date : start_date
                ,end_date : end_date
                ,classId : class_id
                ,content : content
                ,notice : notice
                ,plan : plan
            };
            let resultCallback = function(data){
                fModifyCoursePlanResult(data);
            }
            callAjax('/inst/modifyCoursePlan',"post","json",true,param,resultCallback);
        }
        function fModifyCoursePlanResult(data){
            if(data.result === 'SUCCESS'){
                swal(data.resultMsg);
                gfCloseModal();
            }else{
                swal('에러! 관리자에게 문의해주세요!');
            }
        }
        function fDeleteCoursePlan(){
            let courseId = $("#courseId").val();

            let param = {
                courseId : courseId
            }
            let resultCallback = function(data){
                fDeleteCoursePlanResult(data)
            }
            callAjax('/inst/deleteCoursePlan',"post","json",true,param,resultCallback);
        }
        function fDeleteCoursePlanResult(data){
            if(data.result == "SUCCESS"){
                swal(data.result);
                gfCloseModal();
                fCoursePlanList();
            }else{
                console.log(data.resultMsg);
            }
        }
        function fSearchCoursePlanList(currentPage){
            currentPage = currentPage||1;

            let sname = $("#sname");
            let searchKey = document.getElementById("searchKey");
            console.log("searchKey=",searchKey);
            console.log(searchKey.options[1].value,'=',searchKey.selectedIndex);
            let oname = searchKey.options[searchKey.selectedIndex].value;
            let sdate = $("#search_sdate").val();
            let edate = $("#search_edate").val();

            let param = {
                 title : sname.val()
                ,oname : oname
                ,currentPage : currentPage
                ,pageSize : pageSizeComnGrpCod
                ,search_sdate : sdate
                ,search_edate : edate
            }
            let resultCallback = function(data){
                console.log('Data=',data)
                fSearchClassPlanListResult(data, currentPage);
            }
            callAjax('/inst/searchCoursePlanList',"post","text",true,param,resultCallback);
        }
        function fSearchClassPlanListResult(data,currentPage){
            console.log('returnData=',data)
            $("#listCoursePlan").empty();
            $("#listCoursePlan").append(data);

            var totalCntComnDtlCod = $("#coursePlanTotalCount").val();
            var paginationHtml = getPaginationHtml(currentPage, totalCntComnDtlCod, pageSizeComnDtlCod ,pageBlockSizeComnGrpCod, 'fSearchCoursePlanList');
            $("#comnGrpCodPagination").empty().append(paginationHtml);
            $("#currentPageComnGrpCod").val(currentPage);
        }
        function fSearchDate(){
            let sdate = $("#search_sdate").val();
            let edate = $("#search_edate");
            console.log(sdate);
            let setEdate = '';
            let splitDate = sdate.split("-");
            //Date는 월을 0~11로 인식해서 12월을 클릭했다면 내년 1월로 인식함
            //그래서 -1을 해야함
            let newDate = new Date(splitDate[0],splitDate[1]-1,splitDate[2]);
            //setFullYear = 윤년 계산해줌
            newDate.setFullYear(newDate.getFullYear()+1);
            let year = newDate.getFullYear();
            let month = (newDate.getMonth()+1).toString().padStart(2,'0');
            let day = newDate.getDate().toString().padStart(2,'0');


            setEdate = year+"-"+month+"-"+day;
            console.log('setEdate=',setEdate);
            edate.val(setEdate);
        }
    </script>
</head>
<body>
<form id="myForm" action=""  method="">
    <input type="hidden" id="currentPageComnGrpCod" value="1">
    <input type="hidden" id="currentPageComnDtlCod" value="1">
    <input type="hidden" id="tmpGrpCod" value="">
    <input type="hidden" id="tmpGrpCodNm" value="">
    <input type="hidden" name="action" id="action" value="">
    <input type="hidden" name="courseId" id="courseId" value="">
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
                        <span class="btn_nav bold">강의 계획서</span>
                        <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
                    </p>

                    <p class="conTitle">
                        <span style="margin-right: 10px">강의계획서관리</span>
                        <span>
                            <select name="searchKey" id="searchKey" style="width:150px; height:25px;">
                                <option value="">선택</option>
                                <option value="title">과목</option>
                            </select>
                            <input type="text" style="width:150px; height:25px; margin-right: 20px" id="sname" name="sname" />
                            <input type="date" style="width:150px; height:25px;" name="search_sdate" id="search_sdate" onchange="fSearchDate()"/> ~
                            <input type="date" style="width:150px; height:25px;" name="search_edate" id="search_edate" />
                            <a href="javascript:void(0)" class="btnType blue" style="margin-left: 10px" id="btnSearchCoursePlanList" name="btn"><span>검  색</span></a>
<%--                            <a class="btnType blue" href="javascript:fPopModalComnGrpCod();" name="modal"><span>신규등록</span></a>--%>
                        </span>
                    </p>
                    <div class="divCourseList">
                        <div class="btn_areaR">
                            <a href="javascript:void(0)" class="btnType blue" style="margin-left: 10px;" id="btnCoursePlanReg" name="btn"><span>등  록</span></a>
                        </div>
                        <table class="col" style="width:100%">
                            <caption></caption>
                            <colgroup>

                            </colgroup>
                            <thead>
                                <tr>
                                    <td colspan="7"></td>
                                </tr>
                                <tr>
                                    <th scope="col">순번</th>
                                    <th scope="col">과목</th>
                                    <th scope="col">강사명</th>
                                    <th scope="col">보조강사명</th>
                                    <th scope="col">강의시작일</th>
                                    <th scope="col">강의종료일</th>
                                    <th scope="col">수강신청인원</th>
                                    <th scope="col">정원</th>
                                    <th scope="col">상태</th>
                                </tr>
                            </thead>
                            <tbody id="listCoursePlan"></tbody>
                        </table>
                    </div>
                    <div class="paging_area" id="comnGrpCodPagination"></div>
                </div>
            </li>
        </ul>
    </div>
</div>
<%--모달팝업--%>
<div id="layer1" class="layerPop layerType2" style="width: 800px;">
    <dl>
        <dt>
            <strong>강의계획서</strong>
        </dt>
        <dd class="content">
            <table class="row">
                <caption>caption</caption>
                <colgroup>
                    <col width="120px">
                    <col width="*">
                    <col width="120px">
                    <col width="*">
                    <col width="120px">
                    <col width="*">
                </colgroup>
                <tbody>
                    <tr>
                        <th>과정명</th>
                        <td><input type="text" class="inputTxt" name="title" id="title"/></td>
                        <th>강사명</th>
                        <td>
                            <select name="instlist1" id="instlist1" style="width:120px; height:25px;">
                            </select>
                        </td>
                        <th>보조강사명</th>
                        <td>
                            <select name="instlist2" id="instlist2" style="width:120px; height:25px;">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>강의실</th>
                        <td>
                            <select name="classlist" id="classlist" style="width:120px; height:25px;">
                            </select>
                        </td>
                        <th>최대인원</th>
                        <td>
                            <input type="text" class="inputTxt" name="" id="" style="width: 80px; text-align: right" value="40" readonly/> <span>명</span>
                        </td>
                    </tr>
                    <tr>
                        <th>일자</th>
                        <td colspan="3">
                            <input type="date" style="font-size: 12px;width:100px; height: 28px;" id="start_date" name="start_date" value="" onChange="fChangeDate()" /> ~
                            <input type="date" style="font-size: 12px;width:100px; height: 28px;" id="end_date" name="end_date" value="" />
                        </td>
                        <th>과정(개월)</th>
                        <td>
                            <input type="text" class="inputTxt" id="setMonths" name="setMonths" style="width: 80px; text-align: right;" readonly/> <span>개월</span>
                        </td>
                    </tr>
                    <tr>
                        <th>강의시간</th>
                        <td colspan="5">
                            <select name="classTimelist" id="classTimelist" style="width:120px; height:25px;">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>수업내용</th>
                        <td colspan="5"><textarea name="content" id="content" rows="" cols=""></textarea></td>
                    </tr>
                    <tr>
                        <th>공지사항</th>
                        <td colspan="5"><textarea name="notice" id="notice" rows="" cols=""></textarea></td>
                    </tr>
                    <tr>
                        <th>강의계획</th>
                        <td colspan="5"><textarea name="plan" id="plan" rows="" cols=""></textarea></td>
                    </tr>
                </tbody>
            </table>
            <div id="updateCoursePlan" class="btn_areaC mt30">
                <a href="javascript:void(0)" class="btnType blue" id="btnUpdateCoursePlan" name="btn"><span>수정</span></a>
                <a href="javascript:void(0)" class="btnType blue" id="btnDeleteCoursePlan" name="btn"><span>삭제</span></a>
                <a href="javascript:void(0)" class="btnType gray"  id="btnCloseCoursePlan" name="btn"><span>취소</span></a>
            </div>
            <div id="insertCoursePlan" class="btn_areaC mt30">
                <a href="javascript:void(0)" class="btnType blue" id="btnSaveGrpCod" name="btn"><span>등록</span></a>
                <a href="javascript:void(0)" class="btnType gray"  id="btnCloseCoursePlan" name="btn"><span>취소</span></a>
            </div>
        </dd>
    </dl>
</div>
</form>
</body>
</html>
