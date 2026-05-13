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
