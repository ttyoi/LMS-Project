<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<title>설문조사</title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

	var pageSize = 5;
	var pageBlock = 5;
	var totalPages = 1; // 전체 페이지 수

	$(function(){
		selectSurveyList();
		fButtonClickEvent();

		// 모달 외부 클릭 시 닫기
		$(document).on('click', '.layerPop', function(e) {
			if (e.target === this) {
				gfCloseModal();
			}
		});
	});

	// 강의 목록 조회 및 드롭다운 채우기
	function loadCourseList() {
		var resultCallback = function(data) {
			if (data.resultMsg === "SUCCESS") {
				var courseSelect = $("#courseId");
				courseSelect.empty();
				courseSelect.append('<option value="">-- 강의를 선택하세요 --</option>');

				if (data.courseList && data.courseList.length > 0) {
					for (var i = 0; i < data.courseList.length; i++) {
						var course = data.courseList[i];
						var displayText = "[" + course.courseId + "] " + course.title;
						if (course.className) {
							displayText += " (" + course.className + ")";
						}
						courseSelect.append('<option value="' + course.courseId + '">' + displayText + '</option>');
					}
				} else {
					courseSelect.append('<option value="">개설된 강의가 없습니다</option>');
				}
			} else {
				alert("강의 목록을 불러오는데 실패했습니다.");
			}
		};

		callAjax("/survey/getActiveCourseList.do", "post", "json", true, {}, resultCallback);
	}

	function fButtonClickEvent(){
		$('a[name=btn]').click(function(e){
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch(btnId){
			case 'btnSaveSurvey' : fSaveSurvey();
				break;
			case 'btnDeleteSurvey' : fDeleteSurvey();
				break;
			case 'btnClose' : gfCloseModal();
				selectSurveyList();
				break;
			case 'btnUpdateSurvey' : fUpdateSurvey();
				break;
			case 'searchBtn' :
				selectSurveyList(1); // 검색 시 첫 페이지로 이동
				break;
			}
		});
	}

	function selectSurveyList(currentPage){

		currentPage = currentPage || 1;

		// 페이지 유효성 검증
		if (currentPage < 1) {
			alert("잘못된 페이지 번호입니다.");
			return;
		}

		if (totalPages > 0 && currentPage > totalPages) {
			alert("존재하지 않는 페이지입니다.");
			return;
		}

		var title = $("#search_title").val();
		var from_date = $("#from_date").val();
		var to_date = $("#to_date").val();

		var param = {
				title : title ,
				currentPage : currentPage ,
				pageSize : pageSize ,
				from_date : from_date,
				to_date : to_date
		}

		var resultCallback = function(data){
			surveyListResult(data, currentPage);
		}

		callAjax("/survey/surveyList.do","post","text", true, param, resultCallback);
	}

	 function surveyListResult(data, currentPage){

		 console.log(data);

		 $('#surveyList').empty();
		 $('#surveyList').append(data);

		 var totalCnt = $("#totcnt").val();

		 // 전체 페이지 수 계산 및 저장
		 totalPages = Math.ceil(totalCnt / pageSize);
		 if (totalPages == 0) {
			 totalPages = 1;
		 }

	     var list = $("#tmpList").val();
	     var pagingnavi = getPaginationHtml(currentPage, totalCnt, pageSize, pageBlock, 'selectSurveyList',[list]);

	     $("#pagingnavi").empty().append(pagingnavi);

	    $("#currentPage").val(currentPage);
	 }


	 function fSurveyModal(surveyId) {

		 if(surveyId == null || surveyId==""){
			$("#action").val("I");
			frealPopModal(surveyId);
			gfModalPop("#survey");
			window.scrollTo(0, 0);
		 }else{
			$("#action").val("U");
			fdetailModal(surveyId);
		 }
	 }

	 function fdetailModal(surveyId){

		 var param = {surveyId : surveyId};
		 var resultCallback2 = function(data){
			 fdetailResult(data);
		 };

		 callAjax("/survey/detailSurvey.do", "post", "json", true, param, resultCallback2);
	 }

	 function fdetailResult(data){

		 if(data.resultMsg == "SUCCESS"){
			 gfModalPop("#survey");
			 window.scrollTo(0, 0);
			frealPopModal(data.result);

			 // 문항 목록 표시
			 if(data.questions && data.questions.length > 0){
				 for(var i = 0; i < data.questions.length; i++){
					 addQuestionRow(data.questions[i]);
				 }
			 }
		 }else{
			 alert(data.resultMsg);
		 }
	 }

	 function frealPopModal(object){

		 // 문항 목록 초기화
		 $("#questionList").empty();
		 questionIndex = 0;

		 // 강의 목록 로드
		 loadCourseList();

		 if(object == "" || object == null || object == undefined){
			 var writer = $("#swriter").val();

			 $("#loginId").val(writer);
			 $("#loginId").attr("readonly", true);

			 $("#write_date").val();
			 $("#title").val("");
			 $("#courseId").val("");
			 $("#useYn").val("Y");

			 $("#btnDeleteSurvey").hide();
			 $("#btnUpdateSurvey").hide();
			 $("#btnSaveSurvey").show();
		 }else{

			 $("#loginId").val(object.loginId);
			 $("#loginId").attr("readonly", true);

			 $("#write_date").val(object.createdAt);
			 $("#write_date").attr("readonly", true);

			 $("#title").val(object.title);

			 // 강의 목록 로드 후 선택된 값 설정
			 setTimeout(function() {
				 $("#courseId").val(object.courseId);
			 }, 100);

			 $("#useYn").val(object.useYn);
			 $("#viewCount").val(object.viewCount);

			 $("#surveyId").val(object.surveyId);

			 $("#btnDeleteSurvey").show();
			 $("#btnSaveSurvey").hide();
			 $("#btnUpdateSurvey").css("display","");
		 }
	 }

	 function fValidatePopup(){
		 var chk = checkNotEmpty(
				 [
					 ["title", "제목을 입력해주세요!"],
					 ["courseId", "강의를 선택해주세요!"]
				 ]
		 );

	 	if(!chk){return;}
	 	return true;
	 }

	 function fSaveSurvey(){

		 if(!(fValidatePopup())){ return; }

		 var resultCallback3 = function(data){
			 fSaveSurveyResult(data);
		 };

		 $("#action").val("I");

		 callAjax("/survey/surveySave.do", "post", "json", true, $("#mySurvey").serialize(), resultCallback3);
	 }

	 function fSaveSurveyResult(data){
		 var currentPage = currentPage || 1;

		 if($("#action").val() != "I"){
			 currentPage = $("#currentPage").val();
		 }

		 if(data.resultMsg == "SUCCESS"){
			 alert("저장 되었습니다.");
		 }else if(data.resultMsg == "UPDATED") {
			 alert("수정 되었습니다.");
		 }else if(data.resultMsg == "DELETED") {
			 alert("삭제 되었습니다.");
		 }else{
			 alert(data.resultMsg);
			 alert("실패 했습니다.");
		 }

		 gfCloseModal();
		 selectSurveyList(currentPage);
		 frealPopModal();
	 }

	 function fUpdateSurvey(){

		 if(!(fValidatePopup())){ return; }

		 var resultCallback3 = function(data){
			 fSaveSurveyResult(data);
		 };

		 $("#action").val("U");

		 callAjax("/survey/surveySave.do", "post", "json", true, $("#mySurvey").serialize(), resultCallback3);
	 }

	 function fDeleteSurvey(){
		 var con = confirm("정말 삭제하겠습니까? \n 삭제시 복구불가합니다.");
		 if(con){
			 var resultCallback3 = function(data){
				 fSaveSurveyResult(data);
			 }
			 $("#action").val("D");
			 callAjax("/survey/surveyDelete.do", "post", "json", true, $("#mySurvey").serialize(), resultCallback3);
		 }else{
			 gfCloseModal();
			 selectSurveyList(currentPage);
			 frealPopModal();
		 }
	 }
    var questionIndex = 0;

    $(document).on('click', '#btnAddQuestion', function () {
        addQuestionRow();
    });

    function addQuestionRow(data) {

        questionIndex++;

        var qid = "q_" + questionIndex;
        var content = data ? data.content : '';
        var type = data ? data.type : 'score';

        var html = '<div class="question-box" id="' + qid + '" style="border:1px solid #ccc; padding:15px; margin-top:10px;">' +
            '<div style="display:flex; justify-content:space-between;">' +
                '<strong>문항 ' + questionIndex + '</strong>' +
                '<button type="button" class="btnType gray btnDelQ" data-id="' + qid + '">삭제</button>' +
            '</div>' +
            '<div style="margin-top:10px;">' +
                '<label>문항 제목</label>' +
                '<input type="text" name="questionContents" class="inputTxt p100 question-title" value="' + content + '">' +
            '</div>' +
            '<div style="margin-top:10px;">' +
                '<label>문항 타입</label>' +
                '<select name="questionTypes" class="inputTxt p100 question-type">' +
                    '<option value="score"' + (type === 'score' ? ' selected' : '') + '>객관식 (5점 척도)</option>' +
                    '<option value="text"' + (type === 'text' ? ' selected' : '') + '>주관식</option>' +
                '</select>' +
            '</div>' +
            '<div class="score-area" style="margin-top:10px;' + (type === 'text' ? 'display:none;' : '') + '">' +
                '<label>선택지 (5점 척도)</label><br>' +
                '<label><input type="radio" disabled> 매우 그렇다 (5점)</label><br>' +
                '<label><input type="radio" disabled> 그렇다 (4점)</label><br>' +
                '<label><input type="radio" disabled> 보통 (3점)</label><br>' +
                '<label><input type="radio" disabled> 아니다 (2점)</label><br>' +
                '<label><input type="radio" disabled> 매우 아니다 (1점)</label>' +
            '</div>' +
            '<div class="text-area" style="margin-top:10px;' + (type === 'score' ? 'display:none;' : '') + '">' +
                '<textarea class="inputTxt p100" placeholder="주관식 답변 작성란 표시 (미리보기)"></textarea>' +
            '</div>' +
        '</div>';

        $("#questionList").append(html);
    }


    /** 문항 타입 변경 시 화면 전환 */
    $(document).on('change', '.question-type', function () {
        var parent = $(this).closest('.question-box');
        var type = $(this).val();

        if (type === 'score') {
            parent.find('.score-area').show();
            parent.find('.text-area').hide();
        } else {
            parent.find('.score-area').hide();
            parent.find('.text-area').show();
        }
    });

    /** 문항 삭제 */
    $(document).on('click', '.btnDelQ', function () {
        var id = $(this).data("id");
        $("#" + id).remove();
    });
</script>


</head>
<body>
<form id="mySurvey" action="" method="">

	<input type="hidden" id="currentPage" value="1">
	<input type="hidden" id="tmpList" value="">
	<input type="hidden" id="tmpListNum" value="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" id="swriter" value="${loginId}">

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
							<a href="#" class="btn_set home">메인으로</a>
							<a href="#" class="btn_nav bold">설문조사</a>
								<span class="btn_nav bold">설문조사 관리</span>
								<a href="#" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>설문조사 관리</span> <span class="fr">
								<c:set var="nullNum" value=""></c:set>
								<a class="btnType blue" href="javascript:fSurveyModal(${nullNum});" name="modal">
								<span>설문등록</span></a>
							</span>
						</p>

					<table width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left"
                        style="border-collapse: collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                           <td width="100" height="25" style="font-size: 120%">&nbsp;&nbsp;</td>

                           <td width="50" height="25" style="font-size: 100%">제목</td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="text" style="width: 120px" id="search_title" name="search_title"></td>
                           <td width="50" height="25" style="font-size: 100%">작성일</td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="date" style="width: 120px" id="from_date" name="from_date"></td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="date" style="width: 120px" id="to_date" name="to_date"></td>
                           <td width="110" height="60" style="font-size: 120%">
                           <a href="" class="btnType blue" id="searchBtn" name="btn"><span>검  색</span></a></td>
                        </tr>
                     </table>

						<div class="divSurveyList">
							<table class="col">
								<caption>caption</caption>

		                            <colgroup>
						                   <col width="50px">
						                   <col width="180px">
						                   <col width="80px">
						                   <col width="60px">
						                   <col width="60px">
						                   <col width="50px">
						                   <col width="80px">
					                 </colgroup>
								<thead>
									<tr>
							              <th scope="col">설문번호</th>
							              <th scope="col">설문제목</th>
							              <th scope="col">작성일</th>
							              <th scope="col">조회수</th>
							              <th scope="col">사용여부</th>
							              <th scope="col">작성자</th>
							              <th scope="col">통계</th>
									</tr>
								</thead>
								<tbody id="surveyList"></tbody>
							</table>

							<div class="paging_area" id="pagingnavi">
							</div>

						</div>


					</div>

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>


	<div id="survey" class="layerPop layerType2" style="width: 600px;">
		<input type="hidden" id="surveyId" name="surveyId" value="${surveyId}">
		<input type="hidden" id="useYn" name="useYn" value="Y">

		<dl>
			<dt>
				<strong>설문조사</strong>
			</dt>
			<dd class="content">
                <div id="surveyQuestionArea">

                    <!-- 기본정보 -->
                    <table class="row">
                        <tbody>
                        <tr>
                            <th>작성자</th>
                            <td><input type="text" id="loginId" name="loginId" class="inputTxt p100" readonly></td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td><input type="text" id="title" name="title" class="inputTxt p100"></td>
                        </tr>
                        <tr>
                            <th>강의</th>
                            <td>
                                <select id="courseId" name="courseId" class="inputTxt p100">
                                    <option value="">-- 강의를 선택하세요 --</option>
                                </select>
                            </td>
                        </tr>
                        </tbody>
                    </table>

                    <hr>

                    <!-- 문항 리스트 -->
                    <div id="questionList"></div>

                    <!-- 문항 추가 버튼 -->
                    <div style="margin-top:10px;">
                        <button type="button" id="btnAddQuestion" class="btnType blue"> + 문항추가</button>
                    </div>

                    <div class="btn_areaC mt30">
                        <a href="" class="btnType blue" id="btnSaveSurvey" name="btn"><span>저장</span></a>
                        <a href="" class="btnType blue" id="btnUpdateSurvey" name="btn" style="display:none"><span>수정</span></a>
                        <a href="" class="btnType blue" id="btnDeleteSurvey" name="btn"><span>삭제</span></a>
                        <a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
                    </div>

                </div>
			</dd>

		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

</form>

</body>
</html>
