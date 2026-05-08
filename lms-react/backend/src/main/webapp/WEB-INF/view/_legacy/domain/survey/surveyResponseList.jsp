<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


		<!-- 갯수가 0인 경우  -->
		<c:if test="${surveyResponseCnt eq 0 }">
			<tr>
				<td colspan="7">데이터가 존재하지 않습니다.</td>
			</tr>
		</c:if>


		<!-- 갯수가 있는 경우  -->
		<c:if test="${surveyResponseCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" />
			<c:forEach items="${surveyResponse}" var="list">
				<tr>
					<td>${list.responseId}</td>
					<td><a href="javascript:fSurveyResponseModal(${list.responseId});">${list.surveyId}</a></td>
					<td>${list.questionId}</td>
					<td>${list.scoreValue}</td>
					<td>${list.textValue}</td>
					<td>${list.createdAt}</td>
					<td>${list.loginId}</td>
				</tr>
				 <c:set var="nRow" value="${nRow + 1}" />
			</c:forEach>
		</c:if>

        <input type="hidden" id="totcnt" name="totcnt" value="${surveyResponseCnt}"/>
