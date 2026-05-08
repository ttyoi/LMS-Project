<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${totalCount eq 0}">
  <tr>
    <td colspan="8">데이터가 존재하지 않습니다.</td>
  </tr>
</c:if>
<c:if test="${totalCount > 0}">
  <c:set var="nRow" value="${pageSize*(currentPage-1)}" />
  <c:forEach items="${stuAttDtlList}" var="list" varStatus="outter">
      <tr class="hi">
        <input type="hidden" id="course_id" name="course_id" value="${list.course_id}">
        <input type="hidden" id="title" name="" value="${list.cour_title}">
        <input type="hidden" id="att_date" name="att_date" value="${list.att_date}">
        <input type="hidden" id="att_code" name="att_code" value="${list.att_code}">
        <td>${outter.index + 1}</td>
        <td>${list.prof_nm}</td>
        <td>${list.stu_nm}</td>
        <td>${list.cour_title}</td>
        <td class="attDateWrap"><span class="att_date1">${list.att_date}</span></td>
        <c:forEach begin="0" end="4" step="1" varStatus="inner">
          <c:choose>
            <c:when test="${list.att_sta_code eq (inner.index+1)%5}">
              <td class="radioWrap"><input type="radio" class=`att` name=`att${outter.index}` value=`${list.att_sta_code}` onclick="return false;" checked /></td>
            </c:when>
            <c:otherwise>
              <td class="radioWrap"><input type="radio" class=`att` name=`att${outter.index}` onclick="return false;"/></td>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <td class="toggleBtn">
          <a class="btnType3 color2 btnModify" href="javascript:fStuAttDtlModify('${list.loginID}','${list.course_id}')"><span>수정</span></a>
        </td>
      </tr>
  </c:forEach>
</c:if>

<input type="hidden" id="stuAtt_totalCount" name="stuAtt_totalCount" value="${totalCount}">