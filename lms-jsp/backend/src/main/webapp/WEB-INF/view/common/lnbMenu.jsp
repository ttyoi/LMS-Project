<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="mainUrl" value="${CTX_PATH}/admin/dashboard" />
<c:set var="defaultImg" value="${CTX_PATH}/images/admin/comm/left_myImg.jpg" />

<c:choose>
    <c:when test="${sessionScope.userType eq 'S'}">
        <c:set var="mainUrl" value="${CTX_PATH}/stu/my-page" />
    </c:when>
    <c:when test="${sessionScope.userType eq 'I'}">
        <c:set var="mainUrl" value="${CTX_PATH}/inst/my-page" />
    </c:when>
    <c:when test="${sessionScope.userType eq 'A'}">
        <c:set var="mainUrl" value="${CTX_PATH}/admin/dashboard" />
    </c:when>
</c:choose>

<h3 class="hidden">lnb 영역</h3>

<div id="lnb_area">
    <div class="logo">
        <a class="logo-link" href="${mainUrl}">
            <img src="${CTX_PATH}/images/admin/login/logo_img.png" alt="메인페이지" />
        </a>
    </div>

    <div class="login">
	    <img
	        id="loginProfileImg"
	        src="${defaultImg}"
	        class="LoginImg"
	        alt="프로필 이미지"
	        onerror="this.src='${defaultImg}'"
	    />
	
	    <div class="login-info">
	        <span class="LoginName">${sessionScope.userNm}</span>
	
	        <div class="btn_loginArea">
	            <a href="javascript:void(0);" onclick="fLogOut();" class="logout">LOGOUT</a>
	        </div>
	    </div>
	</div>

    <div class="nav-title">Navigation</div>

    <ul class="lnbMenu">
        <c:forEach items="${sessionScope.usrMnuAtrt}" var="list">
            <li>
                <dl>
                    <dt>
                        <a class="lnbBtn ${list.mnu_ico_cod}" href="javascript:void(0);">
                            <span class="lnb-text">${list.mnu_nm}</span>
                            <em></em>
                        </a>
                    </dt>

                    <dd>
                        <c:forEach items="${list.nodeList}" var="i">
                            <c:set var="urls" value="${fn:split(i.mnu_url, '/')}" />
                            <c:choose>
                                <c:when test="${fn:indexOf(urls[fn:length(urls)-1], '=') > -1}">
                                    <c:set var="url" value="${fn:split(urls[fn:length(urls)-1], '=')}" />
                                    <a href="${i.mnu_url}" id="lnb_${url[fn:length(url)-1]}">${i.mnu_nm}</a>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="url" value="${fn:split(urls[fn:length(urls)-1], '.')}" />
                                    <a href="${i.mnu_url}" id="lnb_${url[0]}">${i.mnu_nm}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </dd>
                </dl>
            </li>
        </c:forEach>
    </ul>

    <div style="clear: both;"></div>
</div>

<script>
    $(function () {
        loadLoginProfileImage();

        const $menuRoot = $('#lnb_area .lnbMenu');
        const $menuItems = $menuRoot.children('li');
        const $menuButtons = $menuRoot.find('dt > a.lnbBtn');

        // 2depth 초기 상태를 강제로 정리
        $menuItems.removeClass('open');
        $menuButtons.removeClass('on active');
        $menuRoot.find('dd').hide();

        // 기존 이벤트 최대한 차단
        $menuRoot.off();
        $menuButtons.off();

        // 1depth 클릭
        $menuRoot.on('click', 'dt > a.lnbBtn', function (e) {
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();

            const $btn = $(this);
            const $li = $btn.closest('li');
            const $dd = $li.children('dl').children('dd');
            const isOpen = $li.hasClass('open');

            // 모두 닫기
            $menuItems.removeClass('open');
            $menuButtons.removeClass('on active');
            $menuRoot.find('dd').stop(true, true).slideUp(150);

            // 이미 열려 있던 메뉴를 다시 누른 경우 -> 닫기만 하고 종료
            if (isOpen) {
                return false;
            }

            // 새 메뉴 열기
            $li.addClass('open');
            $btn.addClass('on');
            $dd.stop(true, true).slideDown(150);

            return false;
        });

        // 현재 페이지 메뉴 강조
        const currentPath = window.location.pathname;

        $menuRoot.find('dd a').each(function () {
            const href = $(this).attr('href');
            if (!href) return;

            if (currentPath === href) {
                const $sub = $(this);
                const $li = $sub.closest('li');
                const $btn = $li.find('dt > a.lnbBtn').first();
                const $dd = $li.children('dl').children('dd');

                $sub.addClass('current');
                $li.addClass('open');
                $btn.addClass('on');
                $dd.show();
            }
        });
    });

    function loadLoginProfileImage() {
        var userType = "${sessionScope.userType}";
        var ajaxUrl = "";

        if (userType === "I") {
            ajaxUrl = "${CTX_PATH}/inst/userInfoAjax";
        } else if (userType === "S") {
            ajaxUrl = "${CTX_PATH}/stu/userInfoAjax";
        } else {
            return;
        }

        $.ajax({
            url: ajaxUrl,
            type: "POST",
            dataType: "json",
            success: function(res) {
                var defaultImgName = "default_profile.jpg";
                var finalImgName = res.imgName ? res.imgName : defaultImgName;
                var imgLogiPath = res.imgLogiPath ? res.imgLogiPath : "";
                var imageUrl = imgLogiPath + finalImgName;

                $("#loginProfileImg").attr("src", imageUrl);
            },
            error: function() {
                console.log("프로필 이미지 로드 실패");
            }
        });
    }
</script>