<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${usertotalcnt eq 0 }">
								<tr>
									<td colspan="7">사용자가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${usertotalcnt > 0 }">
								<c:set var="nRow" value="${pagesize*(currentpage-1)}" />
								<c:forEach items="${userlist}" var="list">
									<tr>
										<td>${usertotalcnt - nRow}</td>
										<td>${list.loginId}</td>
										<td>${list.name}</td>
										<td>${list.user_type}</td>
										<td>${list.regdate}</td>
										<td>${list.birthday}</td>
										<td>
											<a class="btnType3 color1" href="javascript:moduser('${list.loginId}');"><span>수정</span></a>
										</td>
									</tr>
									<c:set var="nRow" value="${nRow + 1}" />
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="usertotalcnt" name="usertotalcnt" value ="${usertotalcnt}"/>