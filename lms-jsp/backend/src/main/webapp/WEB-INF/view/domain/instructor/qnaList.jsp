<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Q&A</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
</head>
<body>
<div id="wrap_area">
	<div id="container">
		<ul>
            <li class="lnb"> 
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>
            <li class="contents">
            	<div class="content">
                    <jsp:include page="/WEB-INF/view/common/header.jsp">
					    <jsp:param name="menu1" value="커뮤니티"/>
					    <jsp:param name="menu2" value="Q&A"/>
					    <jsp:param name="refreshUrl" value="${CTX_PATH}/inst/qna"/>
					</jsp:include>
				
	                <p class="conTitle">
	                    <span>Q&A</span>
	                </p>
	                    
	                <div class="container">
						<!-- 본문 영역 -->
	                </div>
                </div>
            </li>
        </ul>
    </div>
</div>
</body>
</html>
