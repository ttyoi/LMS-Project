package kr.happyjob.study.common.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AuthCheckInterceptor extends HandlerInterceptorAdapter {

	private final Logger logger = LogManager.getLogger(this.getClass());

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		String uri = request.getRequestURI();
		String ctx = request.getContextPath();
		boolean isHome = "/".equals(uri) || (ctx + "/").equals(uri);

		if (isHome) {
			response.sendRedirect(ctx + "/login.do");
			return false;
		}

		HttpSession session = request.getSession(false);
		Object authInfo = (session != null) ? session.getAttribute("usrMnuAtrt") : null;

		String ajaxCall = request.getHeader("AJAX");
		boolean isAjax = "true".equals(ajaxCall)
				|| "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
				|| uri.endsWith(".json")
				|| request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json");

		// 세션 없으면 미로그인 처리
		if (authInfo == null) {
			if (isAjax) {
				response.sendError(901);
			} else {
				response.sendRedirect(ctx + "/login.do");
			}
			return false;
		}

		// URL 패턴별 권한(userType) 검증
		String userType = (String) session.getAttribute("userType");
		String path = uri.substring(ctx.length()); // context path 제거

		if (path.startsWith("/inst/") && !"I".equals(userType)) {
			logger.warn("[권한오류] " + userType + " 계정이 강사 URL 접근 시도: " + uri);
			if (isAjax) {
				response.sendError(403);
			} else {
				response.sendRedirect(ctx + "/login.do");
			}
			return false;
		}

		if (path.startsWith("/stu/") && !"S".equals(userType)) {
			logger.warn("[권한오류] " + userType + " 계정이 학생 URL 접근 시도: " + uri);
			if (isAjax) {
				response.sendError(403);
			} else {
				response.sendRedirect(ctx + "/login.do");
			}
			return false;
		}

		if (path.startsWith("/adm/") && !"A".equals(userType)) {
			logger.warn("[권한오류] " + userType + " 계정이 관리자 URL 접근 시도: " + uri);
			if (isAjax) {
				response.sendError(403);
			} else {
				response.sendRedirect(ctx + "/login.do");
			}
			return false;
		}

		return true;
	}
}
