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
  <c:forEach items="${courseListModel}" var="list">
      <tr>
        <td>${totalCount - nRow}</td>
        <td><a href="javascript:fListCourseStudent('','${list.course_id}')">${list.title}</a></td>
        <td>${list.inst_name}</td>
        <td>${list.start_date}</td>
        <td>${list.end_date}</td>
        <td>${list.stu_cnt}</td>
        <td>${list.people_limit}</td>
        <td>${list.att_ratio}%</td>
      </tr>
    <c:set var="nRow" value="${nRow + 1}" />
  </c:forEach>
</c:if>
<input type="hidden" id="courseTotalCount" name="courseTotalCount" value ="${totalCount}"/>