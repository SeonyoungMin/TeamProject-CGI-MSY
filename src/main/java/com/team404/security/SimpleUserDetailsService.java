package com.team404.security;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.team404.service.UserService;

/**
 * Spring Security 가 로그인 시 호출하는 사용자 조회 서비스.
 * 기존 UserService 를 그대로 활용해서 DB 의 회원으로 인증되도록 한다.
 * 비밀번호는 평문 그대로 비교 ({noop} 접두사 = 인코더 없음).
 */
@Service("userDetailsService")
public class SimpleUserDetailsService implements UserDetailsService {

	@Autowired
	private UserService userService;

	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
		com.team404.domain.User user = userService.getUserById(userId);
		if (user == null) {
			throw new UsernameNotFoundException("아이디를 찾을 수 없습니다: " + userId);
		}

		String role = user.getUserRole();
		if (role == null || role.isEmpty()) {
			role = "ROLE_USER";
		}

		return User.builder()
				.username(user.getUserId())
				.password("{noop}" + user.getUserPw())
				.authorities(Collections.singletonList(new SimpleGrantedAuthority(role)))
				.build();
	}
}
