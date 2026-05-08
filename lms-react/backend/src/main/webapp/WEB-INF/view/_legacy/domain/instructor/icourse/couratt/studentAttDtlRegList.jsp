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
  <c:forEach items="${stdAttDtlRegList}" var="list" varStatus="outter">
      <tr class="hi dataRow">
        <input type="hidden" class="dtl_course_id" name="dtl_course_id" value="${list.course_id}">
        <input type="hidden" class="stu_loginID" name="stu_loginID" value="${list.stu_loginID}">
        <td>${outter.index + 1}</td>
        <td>${list.prof_name}</td>
        <td>${list.stu_name}</td>
        <td>${list.cour_title}</td>
        <c:forEach begin="0" end="4" step="1" varStatus="inner">
          <td class="radioWrap"><input type="radio" class="att" name="att_${outter.index}"  value="${(inner.index+1)%5}" /></td>
        </c:forEach>
      </tr>
  </c:forEach>
    <tr class="hi2">
      <td colspan="9">
        <a href="javascript:fStuAttDtlReg(this)" class="btnType3 color2" id="btnStudentAttReg">등록</a>
        <a href="javascript:fStuAttDtlRegClose()" class="btnType3 color1" id="btnStudentAttRegClose" name="btn">취소</a>
      </td>
    </tr>
</c:if>