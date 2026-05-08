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
        var pageSizeComnGrpCod = 15;
        var pageBlockSizeComnGrpCod = 5;

        // 상세코드 페이징 설정
        var pageSizeComnDtlCod = 5;
        var pageBlockSizeComnDtlCod = 5;
        //페이지 실행 시 선처리
        $(function(){
            //전체 강의목록 조회
            fCourseList();
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
                    case 'btnSearchCourseList':
                        fsearchCourseList();
                        break;
                    case 'btnSaveGrpCod':
                        break;
                    case 'btnSaveGrpCod':
                        break;
                    case 'btnSaveGrpCod':
                        break;
                    case 'btnSaveGrpCod':
                        break;
                }
            })
        }

        /** 그룹코드 폼 초기화 */
        function fInitFormCourse(object) {
            console.log('object.course.title=',object);
            var start_date = object.course.start_date;
            var end_date = object.course.start_date;
           // let prog_cnt = `<span>object.course.prog_cnt/66</span>`
            //let prog_cnt = fProgressDat;
            //console.log('prog_cnt=',prog_cnt);
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

                $("#cour_title").val(object.course.title);
                $("#cour_inst").val(object.course.inst_name);
                $("#cour_date").val(object.course.period_cnt);

                $("#cour_att").val(object.course.att_ratio+'%');
                $("#cour_per").val(object.course.per_ratio+'%');
                $("#cour_abs").val(object.course.abs_ratio+'%');
                $("#cour_content").append(object.course.content);
                $("#cour_progress").val(object.course.cour_cnt);
                //$("#cour_progress").append(prog_cnt);
                $("#prog_cnt").text(' ' +object.course.cour_cnt + '/' +66+'');
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

        function fCourseList(currentPage){
            currentPage = currentPage||1;

            var sname = $('#sname');
            var searchKey = document.getElementById("searchKey");
            var oname = searchKey.options[searchKey.selectedIndex].value;

            console.log(currentPage);

            var param = {
                sname : sname.val()
               ,oname : oname
               ,currentPage : currentPage
               ,pageSize : pageSizeComnGrpCod
            }

            var resultCallback = function(data) {
                console.log('resultCallback',data);
                flistGrpCodeResult(data, currentPage);
            }

            callAjax("/inst/getCourseList","post", "text", true, param, resultCallback);
        }
        function flistGrpCodeResult(data, currentPage){
            $("#listCourse").empty();

            $("#listCourse").append(data);

            //var $data = $($(data).html());

            var totalCntComnDtlCod = $("#courseTotalCount").val();
            console.log('totalCntComnDtlCod=',totalCntComnDtlCod);
            // var grp_cod = $("#tmpGrp_cod").val();
            // var grp_cod_nm = $("#tmpGrpCodNm").val();
            var paginationHtml = getPaginationHtml(currentPage,totalCntComnDtlCod, pageSizeComnGrpCod ,pageBlockSizeComnGrpCod, 'fCourseList');
            $("#comnGrpCodPagination").empty().append(paginationHtml);

            $("#currentPageComnGrpCod").val(currentPage);
        }

    //상세 조회
        function fListCourseDetail(courseId){
            let courData = {'courseId': courseId};

            var resultCallback = function(data) {
                fSelectCouseDetail(data);
            }
            callAjax("/inst/getCourseDetail","post", "json", true, courData, resultCallback);
        }

        function fSelectCouseDetail(data){
            if(data.result == "SUCCESS"){
                gfModalPop('#layer1');
                fInitFormCourse(data);
            }else{
                console.log(data);
                swal(data.resultMsg)
            }
        }
        function fsearchCourseList(currentPage){
            currentPage = currentPage||1;
            var sname = $("#sname");
            var searchKey = document.getElementById("searchKey");
            var oname = searchKey.options[searchKey.selectedIndex].value;
            let sdate = $("#search_sdate").val();
            let edate = $("#search_edate").val();

            var param = {
                title : sname.val()
                ,oname : oname
                ,currentPage : currentPage
                ,pageSize : pageSizeComnGrpCod
                ,search_sdate : sdate
                ,search_edate : edate
            }
            var resultCallback = function(data) {
                console.log('searchDate =',data);
                flistGrpCodeResult(data,currentPage);
            }
            callAjax("/inst/searchCourseList","post", "text", true, param , resultCallback);
        }
        function fSearchDate(){
            let sdate = $("#search_sdate").val();
            let edate = $("#search_edate");
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
        function fProgressDate(progCnt){
            let val = $("#cour_progress").val();

            console.log('progress=',progCnt);
        }
        function fCourseClose(){
            gfCloseModal();
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
                            <span class="btn_nav bold">강의 목록</span>
<%--                            <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>--%>
                        </p>

                        <p class="conTitle">
                            <span style="margin-right: 10px">강의목록</span>
                            <span>
                                <select id="searchKey" name="searchKey" style="width:150px; height:25px;">
                                    <option value="">선택</option>
                                    <option value="title">과목</option>
                                </select>
                                <input type="text" style="width:150px; height:25px; margin-right: 20px" id="sname" name="sname" />
                                <input type="date" style="width:150px; height:25px;" id="search_sdate" name="search_sdate" onchange="fSearchDate()" /> ~
                                <input type="date" style="width:150px; height:25px;" id="search_edate" name="search_edate" />
                                <a href="javascript:void(0)" class="btnType blue" style="margin-left: 10px" id="btnSearchCourseList" name="btn"><span>검  색</span></a>
    <%--                            <a class="btnType blue" href="javascript:fPopModalComnGrpCod();" name="modal"><span>신규등록</span></a>--%>
                            </span>
                        </p>
                        <div class="divCourseList">
                            <table class="col" style="width:100%">
                                <caption></caption>
                                <colgroup>
                                    <col width="6%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="15%">
                                    <col width="15%">
                                    <col width="10%">
                                    <col width="5%">
                                    <col width="5%">
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
                    </div>
                </li>
            </ul>
        </div>
    </div>

    <%--모달팝업--%>
    <div id="layer1" class="layerPop layerType2"  style="width: 800px;">
        <dl>
            <dt>
                <strong>상세정보</strong>
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
                            <td><input type="text" class="inputTxt p100" name="cour_title" id="cour_title"/></td>
                            <th>강사</th>
                            <td><input type="text" class="inputTxt p100" name="cour_inst" id="cour_inst"/></td>
                            <th>강의기간</th>
                            <td><input type="text" class="inputTxt p100" name="cour_date" id="cour_date"/></td>
                        </tr>
                        <tr>
                            <th>강의내용</th>
                            <td colspan="5"><textarea rows="" cols="" name="cour_content" id="cour_content"></textarea></td>
                        </tr>
                        <tr>
                            <th>진도</th>
                            <td colspan="5"><progress max="66" value="0" id="cour_progress"></progress><span id="prog_cnt"></span></td>
                        </tr>
                        <tr>
                            <th>출석</th>
                            <td><input type="text" class="inputTxt p100" name="cour_att" id="cour_att"/></td>
                            <th>지각</th>
                            <td><input type="text" class="inputTxt p100" name="cour_per" id="cour_per"/></td>
                            <th>결석</th>
                            <td><input type="text" class="inputTxt p100" name="cour_abs" id="cour_abs"/></td>
                        </tr>
                        <tr>
                            <td colspan="6" style="text-align: center">
                                <a href="javascript:fCourseClose()" class="btnType3 color1">닫기</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </dd>
        </dl>
    </div>
</form>
</body>
</html>