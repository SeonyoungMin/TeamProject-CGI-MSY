package com.team404.security;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.team404.domain.User;
import com.team404.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class OAuth2SuccessHandler implements AuthenticationSuccessHandler {

    private final UserService userService;

    public OAuth2SuccessHandler(UserService userService) {
        this.userService = userService;
    }
    
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication) throws IOException {

		System.out.println("=== SuccessHandler 진입 registrationId: " + 
			    ((org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken) authentication)
			    .getAuthorizedClientRegistrationId());
		
		OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();

		String userId = null;
		String nickname = null;

		if (oAuth2User.getAttribute("email") != null) {
			String email = oAuth2User.getAttribute("email");
			String name = oAuth2User.getAttribute("name");
			userId = "google_" + email;  // google_xxx@gmail.com
			nickname = name;

		// 이메일 권한 없으므로 카카오 고유 ID 사용
		} else {
		    // 카카오 응답 최상위에 id가 있음
		    Object idObj = oAuth2User.getAttribute("id");
		    String kakaoId = idObj != null ? String.valueOf(idObj) : null;
		    
		    System.out.println("=== 카카오 전체 attributes: " + oAuth2User.getAttributes());
		    
		    if (kakaoId == null) {
		        response.sendRedirect("/minimarket/login?error=true");
		        return;
		    }
		    
		    userId = "kakao_" + kakaoId;
		    Map<String, Object> properties = oAuth2User.getAttribute("properties");
		    if (properties != null) {
		        nickname = (String) properties.get("nickname");
		    }
		    if (nickname == null) {
		        nickname = "카카오유저";
		    }
		}

		// DB에서 유저 조회
		// 없으면 자동 회원가입
		User user = userService.findByEmail(userId);

		if (user == null) {
			user = new User();
			user.setUserId(userId);
			user.setUserNickName(nickname);
			userService.registerOAuthUser(user);
			user = userService.findByEmail(userId);
		}

		// 세션에 저장
		HttpSession session = request.getSession();
		session.setAttribute("loginUser", user);

		System.out.println("=== OAuth2 userId: " + userId);
		System.out.println("=== OAuth2 user from DB: " + user);
		System.out.println("=== session loginUser: " + session.getAttribute("loginUser"));

		response.sendRedirect("/minimarket/home");
	}
}