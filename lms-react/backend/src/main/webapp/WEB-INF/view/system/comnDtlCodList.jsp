<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
					
							<c:if test="${totalCntComnDtlCod eq 0 }">
								<tr>
									<td colspan="12">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:if test="${totalCntComnDtlCod > 0 }">
							    <c:forEach items="${listComnDtlCodModel}" var="list">
								    <tr>
									    <td>${totalCntComnDtlCod - nRow}</td>
									    <td>${list.grp_cod}</td>
									    <td>${list.dtl_cod}</td>
									    <td>${list.dtl_cod_nm}</td>
									    <td>${list.dtl_cod_eplti}</td>
									    <td>${list.use_poa}</td>
									
									    <td><a class="btnType3 color1" href="javascript:fPopModalComnDtlCod('${list.grp_cod}','${list.dtl_cod}');"><span>수정</span></a></td>
								</tr>
							</c:forEach>
						</c:if>	
					
					<input type="hidden"  id="totalCntComnDtlCod" name="totalCntComnDtlCod" value ="${totalCntComnDtlCod}"/>