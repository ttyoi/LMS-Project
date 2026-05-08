package kr.happyjob.study.common.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AuthCheckInterceptor extends HandlerInterceptorAdapter {

	// Set logger 
		private final Logger logger = LogManager.getLogger(this.getClass());
		
		@Override
		public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		  String uri = request.getRequestURI();
		  String ctx = request.getContextPath();
		  boolean isHome = "/".equals(uri) || (ctx + "/").equals(uri);

		  // 홈(/)은 로그인으로 보냄
		  if (isHome) {
		    response.sendRedirect(ctx + "/login.do");
		    return false;
		  }

		  HttpSession session = request.getSession(false);
		  Object authInfo = (session != null) ? session.getAttribute("usrMnuAtrt") : null;

		  // Ajax 요청이면 세션 만료 코드
		  String ajaxCall = request.getHeader("AJAX");
		  if ("true".equals(ajaxCall) && authInfo == null) {
		    response.sendError(901);
		    return false;
		  }

		  // 로그인 필요
		  if (authInfo == null) {
		    response.sendRedirect(ctx + "/login.do");
		    return false;
		  }

		  return true;
		}
}
