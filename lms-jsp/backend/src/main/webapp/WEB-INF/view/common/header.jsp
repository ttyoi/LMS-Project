<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="homeUrl" value="${CTX_PATH}/admin/dashboard"/>

<c:choose>
    <c:when test="${sessionScope.userType eq 'S'}">
        <c:set var="homeUrl" value="${CTX_PATH}/stu/my-page"/>
    </c:when>

    <c:when test="${sessionScope.userType eq 'I'}">
        <c:set var="homeUrl" value="${CTX_PATH}/inst/my-page"/>
    </c:when>

    <c:when test="${sessionScope.userType eq 'A'}">
        <c:set var="homeUrl" value="${CTX_PATH}/admin/dashboard"/>
    </c:when>
</c:choose>

<p class="Location">
    <a href="${empty param.homeUrl ? homeUrl : param.homeUrl}" class="btn_set home">
        메인으로
    </a>

    <c:if test="${not empty param.menu1}">
        <span class="btn_nav bold">${param.menu1}</span>
    </c:if>

    <c:if test="${not empty param.menu2}">
        <span class="btn_nav bold">${param.menu2}</span>
    </c:if>

    <c:if test="${not empty param.menu3}">
        <span class="btn_nav bold">${param.menu3}</span>
    </c:if>

    <c:if test="${not empty param.refreshUrl}">
        <a href="${param.refreshUrl}" class="btn_set refresh">새로고침</a>
    </c:if>
</p>
