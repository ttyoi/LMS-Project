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
  <c:forEach items="${courseStudentList}" var="list" varStatus="idx">
      <tr>
        <input type="hidden" id="course_id" name="course_id" value="${list.course_id}" />
        <input type="hidden" id="stu_loginID" name="stu_loginID" value="${list.stu_loginID}" />
<%--        <td>${totalCount - nRow}</td>--%>
        <td>${idx.index + 1}</td>
        <td>${list.prof_name}</td>
        <td><a href="javascript:fStuAttDtl('','${list.course_id}','${list.stu_loginID}')">${list.stu_name}</a></td>
        <td>${list.cour_title}</td>
        <td>${list.att_cnt}</td>
        <td>${list.att_per_cnt}</td>
        <td>${list.att_leav_cnt}</td>
        <td>${list.att_out_cnt}</td>
        <td>${list.att_abs_cnt}</td>
      </tr>
    <c:set var="nRow" value="${nRow + 1}" />
  </c:forEach>
</c:if>
<input type="hidden" id="att_totalCount" name="att_totalCount" value="${totalCount}">