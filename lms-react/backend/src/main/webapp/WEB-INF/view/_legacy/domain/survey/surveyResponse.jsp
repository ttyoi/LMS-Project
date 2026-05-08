<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<title>설문 응답 관리</title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

	var pageSize = 5;
	var pageBlock = 5;

	$(function(){
		selectSurveyResponseList();
		fButtonClickEvent();
	});

	function fButtonClickEvent(){
		$('a[name=btn]').click(function(e){
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch(btnId){
			case 'btnSaveSurveyResponse' : fSaveSurveyResponse();
				break;
			case 'btnDeleteSurveyResponse' : fDeleteSurveyResponse();
				break;
			case 'btnClose' : gfCloseModal();
				selectSurveyResponseList();
				break;
			case 'btnUpdateSurveyResponse' : fUpdateSurveyResponse();
				break;
			case 'searchBtn' : selectSurveyResponseList();
				break;
			}
		});
	}

	function selectSurveyResponseList(currentPage){

		currentPage = currentPage || 1;

		surveyId = $("#surveyId").val();
		loginId = $("#searchLoginId").val();
		from_date =$("#from_date").val();
		to_date =$("#to_date").val();

		var param = {
				surveyId : surveyId ,
				loginId : loginId ,
				currentPage : currentPage ,
				pageSize : pageSize ,
				from_date:from_date,
				to_date:to_date
		}

		var resultCallback = function(data){
			surveyResponseListResult(data, currentPage);
		}

		callAjax("/survey/surveyResponseList.do","post","text", true, param, resultCallback);
	}

	 function surveyResponseListResult(data, currentPage){

		 console.log(data);

		 $('#surveyResponseList').empty();
		 $('#surveyResponseList').append(data);

		 var totalCnt = $("#totcnt").val();

	     var list = $("#tmpList").val();
	     var pagingnavi = getPaginationHtml(currentPage, totalCnt, pageSize, pageBlock, 'selectSurveyResponseList',[list]);

	     $("#pagingnavi").empty().append(pagingnavi);

	    $("#currentPage").val(currentPage);
	 }

	 function fSurveyResponseModal(responseId) {

		 if(responseId == null || responseId==""){
			$("#action").val("I");
			frealPopModal(responseId);
			gfModalPop("#surveyResponse");
		 }else{
			$("#action").val("U");
			fdetailModal(responseId);
		 }
	 }

	 function fdetailModal(responseId){

		 var param = {responseId : responseId};
		 var resultCallback2 = function(data){
			 fdetailResult(data);
		 };

		 callAjax("/survey/detailSurveyResponse.do", "post", "json", true, param, resultCallback2);
	 }

	 function fdetailResult(data){

		 if(data.resultMsg == "SUCCESS"){
			 gfModalPop("#surveyResponse");
			frealPopModal(data.result);
		 }else{
			 alert(data.resultMsg);
		 }
	 }

	 function frealPopModal(object){

		 if(object == "" || object == null || object == undefined){
			 var writer = $("#swriter").val();

			 $("#modalLoginId").val(writer);
			 $("#modalLoginId").attr("readonly", true);

			 $("#modalSurveyId").val("");
			 $("#questionId").val("");
			 $("#courseId").val("");
			 $("#scoreValue").val("");
			 $("#textValue").val("");

			 $("#btnDeleteSurveyResponse").hide();
			 $("#btnUpdateSurveyResponse").hide();
			 $("#btnSaveSurveyResponse").show();
		 }else{

			 $("#modalLoginId").val(object.loginId);
			 $("#modalLoginId").attr("readonly", true);

			 $("#modalSurveyId").val(object.surveyId);
			 $("#questionId").val(object.questionId);
			 $("#courseId").val(object.courseId);
			 $("#scoreValue").val(object.scoreValue);
			 $("#textValue").val(object.textValue);

			 $("#responseId").val(object.responseId);

			 $("#btnDeleteSurveyResponse").show();
			 $("#btnSaveSurveyResponse").hide();
			 $("#btnUpdateSurveyResponse").css("display","");
		 }
	 }

	 function fValidatePopup(){
		 var chk = checkNotEmpty(
				 [
					 ["modalSurveyId", "설문번호를 입력해주세요!"],
					 ["questionId", "문항번호를 입력해주세요!"],
					 ["courseId", "강의ID를 입력해주세요!"]
				 ]
		 );

	 	if(!chk){return;}
	 	return true;
	 }

	 function fSaveSurveyResponse(){

		 if(!(fValidatePopup())){ return; }

		 var resultCallback3 = function(data){
			 fSaveSurveyResponseResult(data);
		 };

		 $("#action").val("I");

		 callAjax("/survey/surveyResponseSave.do", "post", "json", true, $("#mySurveyResponse").serialize(), resultCallback3);
	 }

	 function fSaveSurveyResponseResult(data){
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
		 selectSurveyResponseList(currentPage);
		 frealPopModal();
	 }

	 function fUpdateSurveyResponse(){

		 if(!(fValidatePopup())){ return; }

		 var resultCallback3 = function(data){
			 fSaveSurveyResponseResult(data);
		 };

		 $("#action").val("U");

		 callAjax("/survey/surveyResponseSave.do", "post", "json", true, $("#mySurveyResponse").serialize(), resultCallback3);
	 }

	 function fDeleteSurveyResponse(){
		 var con = confirm("정말 삭제하겠습니까? \n 삭제시 복구불가합니다.");
		 if(con){
			 var resultCallback3 = function(data){
				 fSaveSurveyResponseResult(data);
			 }
			 $("#action").val("D");
			 callAjax("/survey/surveyResponseDelete.do", "post", "json", true, $("#mySurveyResponse").serialize(), resultCallback3);
		 }else{
			 gfCloseModal();
			 selectSurveyResponseList(currentPage);
			 frealPopModal();
		 }
	 }

</script>


</head>
<body>
<form id="mySurveyResponse" action="" method="">

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
								<span class="btn_nav bold">설문 응답 관리</span>
								<a href="#" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>설문 응답 관리</span> <span class="fr">
								<c:set var="nullNum" value=""></c:set>
								<a class="btnType blue" href="javascript:fSurveyResponseModal(${nullNum});" name="modal">
								<span>신규등록</span></a>
							</span>
						</p>

					<table width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left"
                        style="border-collapse: collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                           <td width="100" height="25" style="font-size: 120%">&nbsp;&nbsp;</td>

                           <td width="50" height="25" style="font-size: 100%">설문번호</td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="number" style="width: 120px" id="surveyId" name="surveyId"></td>
                           <td width="50" height="25" style="font-size: 100%">사용자ID</td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="text" style="width: 120px" id="searchLoginId" name="searchLoginId"></td>
                           <td width="50" height="25" style="font-size: 100%">작성일</td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="date" style="width: 120px" id="from_date" name="from_date"></td>
                           <td width="50" height="25" style="font-size: 100%">
                            <input type="date" style="width: 120px" id="to_date" name="to_date"></td>
                           <td width="110" height="60" style="font-size: 120%">
                           <a href="" class="btnType blue" id="searchBtn" name="btn"><span>검  색</span></a></td>
                        </tr>
                     </table>

						<div class="divSurveyResponseList">
							<table class="col">
								<caption>caption</caption>

		                            <colgroup>
					                   <col width="50px">
					                   <col width="60px">
					                   <col width="60px">
					                   <col width="80px">
					                   <col width="80px">
					                   <col width="150px">
					                   <col width="50px">
				                 </colgroup>
								<thead>
									<tr>
							              <th scope="col">응답번호</th>
							              <th scope="col">설문번호</th>
							              <th scope="col">문항번호</th>
							              <th scope="col">점수응답</th>
							              <th scope="col">주관식응답</th>
							              <th scope="col">응답일시</th>
							              <th scope="col">응답자</th>
									</tr>
								</thead>
								<tbody id="surveyResponseList"></tbody>
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


	<div id="surveyResponse" class="layerPop layerType2" style="width: 600px;">
		<input type="hidden" id="responseId" name="responseId" value="${responseId}">

		<dl>
			<dt>
				<strong>설문 응답</strong>
			</dt>
			<dd class="content">
				<table class="row">
					<caption>caption</caption>

					<tbody>
						<tr>
							<th scope="row">응답자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="loginId" id="modalLoginId" /></td>
						</tr>
						<tr>
							<th scope="row">설문번호 <span class="font_red">*</span></th>
							<td><input type="number" class="inputTxt p100" name="surveyId" id="modalSurveyId" /></td>
						</tr>
						<tr>
							<th scope="row">문항번호 <span class="font_red">*</span></th>
							<td><input type="number" class="inputTxt p100" name="questionId" id="questionId" /></td>
						</tr>
						<tr>
							<th scope="row">강의ID <span class="font_red">*</span></th>
							<td><input type="number" class="inputTxt p100" name="courseId" id="courseId" /></td>
						</tr>
						<tr>
							<th scope="row">점수형 응답</th>
							<td><input type="number" class="inputTxt p100" name="scoreValue" id="scoreValue" /></td>
						</tr>
						<tr>
							<th scope="row">주관식 응답</th>
							<td colspan="3">
								<textarea class="inputTxt p100" name="textValue" id="textValue">
								</textarea>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveSurveyResponse" name="btn"><span>저장</span></a>
					<a href="" class="btnType blue" id="btnUpdateSurveyResponse" name="btn" style="display:none"><span>수정</span></a>
					<a href="" class="btnType blue" id="btnDeleteSurveyResponse" name="btn"><span>삭제</span></a>
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>

		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

</form>

</body>
</html>
