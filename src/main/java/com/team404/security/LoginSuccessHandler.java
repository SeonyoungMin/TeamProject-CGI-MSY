package com.team404.security;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.team404.domain.User;
import com.team404.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 로그인 성공 시 — 세션에 "loginUser"(User 객체)를 넣어준다.
 * 컨트롤러들이 session.getAttribute("loginUser") 로 사용자 꺼내쓰는 기존 코드와
 * Spring Security 인증을 연결하는 다리 역할.
 */
@Component("loginSuccessHandler")
public class LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

	@Autowired
	private UserService userService;

	public LoginSuccessHandler() {
		setDefaultTargetUrl("/home");
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {

		String userId = authentication.getName();
		User user = userService.getUserById(userId);
		if (user != null) {
			request.getSession().setAttribute("loginUser", user);
		}

		super.onAuthenticationSuccess(request, response, authentication);
	}
}
