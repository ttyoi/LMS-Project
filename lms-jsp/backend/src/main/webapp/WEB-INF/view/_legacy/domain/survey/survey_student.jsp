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

	function fButtonClickEvent(){
		$('a[name=btn]').click(function(e){
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch(btnId){
			case 'searchBtn' : selectSurveyList();
				break;
			case 'btnSubmitResponse' : fSubmitResponse();
				break;
			case 'btnClose' : gfCloseModal();
				selectSurveyList();
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

		title = $("#search_title").val();
		from_date =$("#from_date").val();
		to_date =$("#to_date").val();

		var param = {
				title : title ,
				currentPage : currentPage ,
				pageSize : pageSize ,
				from_date:from_date,
				to_date:to_date
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

 	 function board_search(currentPage) {

	      currentPage = currentPage || 1;

	         var title = $('#search_title');
	         var from_date = $('#from_date');
	         var to_date = $('#to_date');

	         var param = {
	                   title : title.val()
	               ,   currentPage : currentPage
	               ,   pageSize : pageSize
	               ,   from_date : from_date.val()
	               ,   to_date : to_date.val()
	         }

	         var resultCallback = function(data) {
	        	 surveyListResult(data, currentPage);
	         };

	         callAjax("/survey/surveyList.do", "post", "text", true, param, resultCallback);
	   }

	 function fSurveyResponseModal(surveyId) {

		 if(surveyId == null || surveyId==""){
			 alert("설문을 선택해주세요.");
			 return;
		 }

		 // 설문 상세 조회 및 응답 모달 오픈
		 var param = {surveyId : surveyId};
		 var resultCallback = function(data){
			 fShowResponseModal(data);
		 };

		 callAjax("/survey/detailSurvey.do", "post", "json", true, param, resultCallback);
	 }

	 function fShowResponseModal(data){

		 if(data.resultMsg == "SUCCESS"){
			 // 이미 응답한 설문인지 확인
			 if(data.alreadyResponded === true){
				 alert("완료된 설문입니다.");
				 return;
			 }

			 gfModalPop("#surveyResponseModal");
			 window.scrollTo(0, 0);

			 // 설문 기본 정보 설정
			 $("#response_surveyId").val(data.result.surveyId);
			 $("#response_surveyTitle").text(data.result.title);

			 // 문항 목록 표시
			 $("#responseQuestionList").empty();

			 if(data.questions && data.questions.length > 0){
				 for(var i = 0; i < data.questions.length; i++){
					 addResponseQuestionRow(data.questions[i], i+1);
				 }
			 }

			 // 모달 내부 스크롤을 맨 위로 초기화
			 $("#surveyResponseModal .content").scrollTop(0);
			 $("#responseQuestionList").scrollTop(0);
		 }else{
			 alert(data.resultMsg);
		 }
	 }

	 function addResponseQuestionRow(question, index) {
		 var html = '<div class="question-box" style="border:1px solid #ccc; padding:15px; margin-top:10px;">' +
			 '<div><strong>문항 ' + index + ':</strong> ' + question.content + '</div>' +
			 '<input type="hidden" name="questionIds" value="' + question.questionId + '">' +
			 '<input type="hidden" name="questionTypes" value="' + question.type + '">';

		 if (question.type === 'score') {
			 html += '<div style="margin-top:10px;">' +
				 '<label><input type="radio" name="response_' + question.questionId + '" value="5"> 매우 그렇다 (5점)</label><br>' +
				 '<label><input type="radio" name="response_' + question.questionId + '" value="4"> 그렇다 (4점)</label><br>' +
				 '<label><input type="radio" name="response_' + question.questionId + '" value="3"> 보통 (3점)</label><br>' +
				 '<label><input type="radio" name="response_' + question.questionId + '" value="2"> 아니다 (2점)</label><br>' +
				 '<label><input type="radio" name="response_' + question.questionId + '" value="1"> 매우 아니다 (1점)</label>' +
				 '</div>';
		 } else {
			 html += '<div style="margin-top:10px;">' +
				 '<textarea name="response_text_' + question.questionId + '" class="inputTxt p100" placeholder="답변을 입력해주세요" rows="4"></textarea>' +
				 '</div>';
		 }

		 html += '</div>';

		 $("#responseQuestionList").append(html);
	 }

	 function fSubmitResponse(){
		 var surveyId = $("#response_surveyId").val();
		 var courseId = 1; // 임시 courseId (실제로는 세션이나 다른 방식으로 가져와야 함)

		 var questionIds = $("input[name='questionIds']");
		 var questionTypes = $("input[name='questionTypes']");

		 var responseData = [];

		 // 초기화
		 responseCount = 0;
		 responseErrors = [];
		 responseTotalCount = questionIds.length;

		 // 각 문항의 응답 수집
		 for(var i = 0; i < questionIds.length; i++){
			 var questionId = $(questionIds[i]).val();
			 var questionType = $(questionTypes[i]).val();

			 var response = {
				 surveyId: surveyId,
				 questionId: questionId,
				 courseId: courseId,
				 action: "I"
			 };

			 if(questionType === 'score'){
				 var scoreValue = $("input[name='response_" + questionId + "']:checked").val();
				 if(!scoreValue){
					 alert("모든 문항에 응답해주세요.");
					 return;
				 }
				 response.scoreValue = scoreValue;
				 response.textValue = "";
			 } else {
				 var textValue = $("textarea[name='response_text_" + questionId + "']").val();
				 if(!textValue || textValue.trim() === ''){
					 alert("모든 문항에 응답해주세요.");
					 return;
				 }
				 response.scoreValue = "";
				 response.textValue = textValue;
			 }

			 console.log("Sending response:", response);

			 // 각 응답을 개별적으로 저장
			 saveResponse(response, i === questionIds.length - 1);
		 }
	 }

	 var responseCount = 0;
	 var responseTotalCount = 0;
	 var responseErrors = [];

	 function saveResponse(response, isLast){
		 var resultCallback = function(data){
			 responseCount++;

			 if(data.resultMsg != "SUCCESS"){
				 responseErrors.push("문항 " + response.questionId + " 저장 실패: " + data.resultMsg);
			 }

			 // 모든 응답 처리 완료
			 if(responseCount >= responseTotalCount){
				 if(responseErrors.length > 0){
					 alert("응답 저장 중 오류가 발생했습니다:\n" + responseErrors.join("\n"));
				 }else{
					 alert("응답이 저장되었습니다.");
					 gfCloseModal();
					 selectSurveyList();
				 }
				 // 초기화
				 responseCount = 0;
				 responseTotalCount = 0;
				 responseErrors = [];
			 }
		 };

		 callAjax("/survey/surveyResponseSave.do", "post", "json", true, response, resultCallback);
	 }
</script>


</head>
<body>
<form id="mySurvey" action="" method="">

	<input type="hidden" id="currentPage" value="1">
	<input type="hidden" id="tmpList" value="">
	<input type="hidden" id="tmpListNum" value="">
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
								<span class="btn_nav bold">설문조사</span>
								<a href="#" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>설문조사</span>
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
						                   <col width="200px">
						                   <col width="80px">
						                   <col width="80px">
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


	<!-- 설문 응답 모달 -->
	<div id="surveyResponseModal" class="layerPop layerType2" style="width: 600px;">
		<input type="hidden" id="response_surveyId" name="response_surveyId" value="">

		<dl>
			<dt>
				<strong>설문 응답</strong>
			</dt>
			<dd class="content" style="max-height: 500px; overflow-y: auto;">
                <div id="surveyResponseArea">

                    <!-- 설문 제목 -->
                    <div style="margin-bottom:20px;">
                        <h3 id="response_surveyTitle"></h3>
                    </div>

                    <hr>

                    <!-- 문항 리스트 -->
                    <div id="responseQuestionList"></div>

                    <div class="btn_areaC mt30">
                        <a href="" class="btnType blue" id="btnSubmitResponse" name="btn"><span>제출</span></a>
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
