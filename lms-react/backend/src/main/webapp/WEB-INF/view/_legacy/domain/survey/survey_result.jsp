<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<title>설문 결과 통계</title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">
	var surveyId = "${surveyId}";

	$(function(){
		loadSurveyStatistics();

		// 모달 외부 클릭 시 닫기
		$(document).on('click', '.layerPop', function(e) {
			if (e.target === this) {
				gfCloseModal();
			}
		});
	});

	function loadSurveyStatistics(){
		var param = {surveyId : surveyId};

		var resultCallback = function(data){
			if(data.resultMsg == "SUCCESS"){
				displaySurveyInfo(data.survey);
				displayQuestionStatistics(data.questionStats);
				displayAllResponses(data.allResponses);
			}else{
				alert("통계 조회에 실패했습니다.");
			}
		};

		callAjax("/survey/getSurveyStatistics.do", "post", "json", true, param, resultCallback);
	}

	function displaySurveyInfo(survey){
		$("#surveyTitle").text(survey.title);
		$("#surveyCreatedAt").text(survey.createdAt);
		$("#surveyViewCount").text(survey.viewCount);
	}

	function displayQuestionStatistics(questionStats){
		$("#questionStatsArea").empty();

		if(!questionStats || questionStats.length == 0){
			$("#questionStatsArea").append('<p>응답 데이터가 없습니다.</p>');
			return;
		}

		for(var i = 0; i < questionStats.length; i++){
			var question = questionStats[i];
			var html = '';

			html += '<div class="question-stat-box" style="border:1px solid #ddd; padding:20px; margin-bottom:20px; background:#f9f9f9;">';
			html += '<h3>문항 ' + question.questionOrder + ': ' + question.questionContent + '</h3>';
			html += '<p>응답자 수: <strong>' + question.responseCount + '명</strong></p>';

			if(question.questionType === 'score'){
				// 객관식 통계
				var maxCount = Math.max(
					question.score5Count || 0,
					question.score4Count || 0,
					question.score3Count || 0,
					question.score2Count || 0,
					question.score1Count || 0
				);

				html += '<div style="margin-top:15px;">';
				html += '<p>평균 점수: <strong>' + (question.avgScore || 0) + '점</strong></p>';

				// 그래프 토글 버튼 추가
				html += '<div style="margin-top:10px;">';
				html += '<a href="javascript:void(0);" class="btnType blue toggle-chart-btn" data-question-id="' + question.questionId + '"><span>▼ 그래프 보기</span></a>';
				html += '</div>';

				// 그래프 영역 (처음엔 숨김)
				html += '<div class="score-distribution chart-area" id="chart-' + question.questionId + '" style="margin-top:20px; display:none;">';

				// 5점
				html += '<div class="bar-item">';
				html += '<span class="bar-label">5점 (매우 그렇다)</span>';
				html += '<div class="bar-container">';
				html += '<div class="bar bar-5" style="width:' + (maxCount > 0 ? ((question.score5Count || 0) / maxCount * 100) : 0) + '%"></div>';
				html += '<span class="bar-count">' + (question.score5Count || 0) + '명</span>';
				html += '</div></div>';

				// 4점
				html += '<div class="bar-item">';
				html += '<span class="bar-label">4점 (그렇다)</span>';
				html += '<div class="bar-container">';
				html += '<div class="bar bar-4" style="width:' + (maxCount > 0 ? ((question.score4Count || 0) / maxCount * 100) : 0) + '%"></div>';
				html += '<span class="bar-count">' + (question.score4Count || 0) + '명</span>';
				html += '</div></div>';

				// 3점
				html += '<div class="bar-item">';
				html += '<span class="bar-label">3점 (보통)</span>';
				html += '<div class="bar-container">';
				html += '<div class="bar bar-3" style="width:' + (maxCount > 0 ? ((question.score3Count || 0) / maxCount * 100) : 0) + '%"></div>';
				html += '<span class="bar-count">' + (question.score3Count || 0) + '명</span>';
				html += '</div></div>';

				// 2점
				html += '<div class="bar-item">';
				html += '<span class="bar-label">2점 (아니다)</span>';
				html += '<div class="bar-container">';
				html += '<div class="bar bar-2" style="width:' + (maxCount > 0 ? ((question.score2Count || 0) / maxCount * 100) : 0) + '%"></div>';
				html += '<span class="bar-count">' + (question.score2Count || 0) + '명</span>';
				html += '</div></div>';

				// 1점
				html += '<div class="bar-item">';
				html += '<span class="bar-label">1점 (매우 아니다)</span>';
				html += '<div class="bar-container">';
				html += '<div class="bar bar-1" style="width:' + (maxCount > 0 ? ((question.score1Count || 0) / maxCount * 100) : 0) + '%"></div>';
				html += '<span class="bar-count">' + (question.score1Count || 0) + '명</span>';
				html += '</div></div>';

				html += '</div></div>';
			} else {
				// 주관식 응답 보기 버튼
				html += '<div style="margin-top:15px;">';
				html += '<a href="javascript:viewTextResponses(' + question.questionId + ');" class="btnType blue"><span>주관식 응답 보기</span></a>';
				html += '</div>';
			}

			html += '</div>';

			$("#questionStatsArea").append(html);
		}

		// 그래프 토글 이벤트 바인딩
		$(".toggle-chart-btn").off('click').on('click', function(){
			var questionId = $(this).data('question-id');
			var chartArea = $("#chart-" + questionId);
			var btnText = $(this).find('span');

			if(chartArea.is(':visible')){
				chartArea.slideUp();
				btnText.text('▼ 그래프 보기');
			} else {
				chartArea.slideDown();
				btnText.text('▲ 그래프 숨기기');
			}
		});
	}

	function viewTextResponses(questionId){
		var param = {questionId : questionId};

		var resultCallback = function(data){
			if(data.resultMsg == "SUCCESS"){
				displayTextResponsesModal(data.textResponses);
			}else{
				alert("주관식 응답 조회에 실패했습니다.");
			}
		};

		callAjax("/survey/getTextResponses.do", "post", "json", true, param, resultCallback);
	}

	function displayTextResponsesModal(textResponses){
		$("#textResponsesList").empty();

		if(!textResponses || textResponses.length == 0){
			$("#textResponsesList").append('<p>응답이 없습니다.</p>');
		} else {
			for(var i = 0; i < textResponses.length; i++){
				var response = textResponses[i];
				var html = '<div style="border:1px solid #ddd; padding:10px; margin-bottom:10px; background:#fff;">';
				html += '<p><strong>' + response.userName + '</strong> (' + response.loginId + ')</p>';
				html += '<p>' + response.textValue + '</p>';
				html += '<p style="color:#999; font-size:12px;">' + response.createdAt + '</p>';
				html += '</div>';
				$("#textResponsesList").append(html);
			}
		}

		gfModalPop("#textResponsesModal");
	}

	function displayAllResponses(allResponses){
		$("#allResponsesArea").empty();

		if(!allResponses || allResponses.length == 0){
			$("#allResponsesArea").append('<p>응답 데이터가 없습니다.</p>');
			return;
		}

		// 응답자별로 그룹화
		var responsesByUser = {};
		for(var i = 0; i < allResponses.length; i++){
			var response = allResponses[i];
			var userId = response.loginId;

			if(!responsesByUser[userId]){
				responsesByUser[userId] = {
					userName: response.userName,
					loginId: response.loginId,
					responses: []
				};
			}

			responsesByUser[userId].responses.push(response);
		}

		// 응답자별로 표시
		var html = '<table class="col" style="width:100%; margin-top:20px;">';
		html += '<thead><tr><th>응답자</th><th>문항</th><th>응답</th><th>응답일시</th></tr></thead>';
		html += '<tbody>';

		for(var userId in responsesByUser){
			var user = responsesByUser[userId];
			var rowspan = user.responses.length;

			for(var j = 0; j < user.responses.length; j++){
				var response = user.responses[j];
				html += '<tr>';

				if(j === 0){
					html += '<td rowspan="' + rowspan + '">' + user.userName + '<br>(' + user.loginId + ')</td>';
				}

				html += '<td>문항 ' + response.questionOrder + ': ' + response.questionContent + '</td>';

				if(response.questionType === 'score'){
					html += '<td>' + response.scoreValue + '점</td>';
				} else {
					html += '<td>' + response.textValue + '</td>';
				}

				if(j === 0){
					html += '<td rowspan="' + rowspan + '">' + response.createdAt + '</td>';
				}

				html += '</tr>';
			}
		}

		html += '</tbody></table>';

		$("#allResponsesArea").append(html);
	}

	function goBack(){
		window.location.href = "/survey/survey.do";
	}
</script>

<style>
.question-stat-box h3 {
	color: #333;
	margin-bottom: 10px;
}

.score-distribution {
	max-width: 700px;
}

.bar-item {
	margin-bottom: 15px;
	clear: both;
}

.bar-label {
	display: block;
	font-weight: bold;
	margin-bottom: 5px;
	color: #333;
}

.bar-container {
	position: relative;
	background-color: #f0f0f0;
	height: 35px;
	border-radius: 5px;
	overflow: hidden;
}

.bar {
	height: 100%;
	transition: width 0.5s ease;
	display: inline-block;
	border-radius: 5px 0 0 5px;
}

.bar-5 {
	background: linear-gradient(90deg, #4CAF50, #66BB6A);
}

.bar-4 {
	background: linear-gradient(90deg, #2196F3, #42A5F5);
}

.bar-3 {
	background: linear-gradient(90deg, #FFC107, #FFD54F);
}

.bar-2 {
	background: linear-gradient(90deg, #FF9800, #FFB74D);
}

.bar-1 {
	background: linear-gradient(90deg, #F44336, #EF5350);
}

.bar-count {
	position: absolute;
	right: 10px;
	top: 50%;
	transform: translateY(-50%);
	font-weight: bold;
	color: #333;
	text-shadow: 0 0 3px white;
}

table.col {
	border-collapse: collapse;
}

table.col th,
table.col td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

table.col th {
	background-color: #f5f5f5;
	font-weight: bold;
}
</style>

</head>
<body>
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
						<a href="/survey/survey.do" class="btn_nav bold">설문조사</a>
						<span class="btn_nav bold">설문 결과 통계</span>
						<a href="#" class="btn_set refresh">새로고침</a>
					</p>

					<p class="conTitle">
						<span>설문 결과 통계</span>
						<span class="fr">
							<a href="javascript:goBack();" class="btnType gray"><span>목록으로</span></a>
						</span>
					</p>

					<!-- 설문 기본 정보 -->
					<div style="background:#f5f5f5; padding:20px; margin-bottom:30px; border-radius:5px;">
						<h2 id="surveyTitle" style="margin-bottom:10px;"></h2>
						<p>작성일: <span id="surveyCreatedAt"></span> | 조회수: <span id="surveyViewCount"></span></p>
					</div>

					<!-- 문항별 통계 -->
					<div class="divSurveyResult">
						<h3 style="margin-bottom:20px;">문항별 통계</h3>
						<div id="questionStatsArea"></div>
					</div>

					<!-- 전체 응답자 목록 -->
					<div class="divAllResponses" style="margin-top:50px;">
						<h3 style="margin-bottom:20px;">전체 응답 내역</h3>
						<div id="allResponsesArea"></div>
					</div>

				</div>

				<h3 class="hidden">풋터 영역</h3>
				<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
			</li>
		</ul>
	</div>
</div>

<!-- 주관식 응답 모달 -->
<div id="textResponsesModal" class="layerPop layerType2" style="width: 700px;">
	<dl>
		<dt>
			<strong>주관식 응답 목록</strong>
		</dt>
		<dd class="content">
			<div id="textResponsesList" style="max-height:500px; overflow-y:auto;"></div>

			<div class="btn_areaC mt30">
				<a href="" class="btnType gray closePop"><span>닫기</span></a>
			</div>
		</dd>
	</dl>
	<a href="" class="closePop"><span class="hidden">닫기</span></a>
</div>

</body>
</html>
