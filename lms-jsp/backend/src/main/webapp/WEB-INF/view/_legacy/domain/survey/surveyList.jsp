<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


		<!-- 갯수가 0인 경우  -->
		<c:if test="${surveyCnt eq 0 }">
			<tr>
				<td colspan="7">데이터가 존재하지 않습니다.</td>
			</tr>
		</c:if>


		<!-- 갯수가 있는 경우  -->
		<c:if test="${surveyCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" />
			<c:forEach items="${survey}" var="list">
				<tr>
					<td>${list.surveyId}</td>
					<td>
						<c:choose>
							<c:when test="${userType eq 'S'}">
								<a href="javascript:fSurveyResponseModal(${list.surveyId});">${list.title}</a>
							</c:when>
							<c:otherwise>
								<a href="javascript:fSurveyModal(${list.surveyId});">${list.title}</a>
							</c:otherwise>
						</c:choose>
					</td>
					<td>${list.createdAt}</td>
					<td>${list.viewCount}</td>
					<td>${list.useYn}</td>
					<td>${list.loginId}</td>

					<td style="text-align:center;">
                        <c:if test="${userType eq 'A' or userType eq 'I'}">
                    <td style="text-align:center;">
                        <a href="/survey/surveyResult.do?surveyId=${list.surveyId}" class="btnType blue" style="padding:3px 8px; font-size:12px;">
                            <span>통계</span>
                        </a>
                    </td>
                    </c:if>
					</td>
				</tr>
				 <c:set var="nRow" value="${nRow + 1}" />
			</c:forEach>
		</c:if>

        <input type="hidden" id="totcnt" name="totcnt" value="${surveyCnt}"/>
