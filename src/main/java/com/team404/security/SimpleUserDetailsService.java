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


//사용자 인증
@Service("userDetailsService")
public class SimpleUserDetailsService implements UserDetailsService {

	@Autowired
	private UserService userService;

	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
	    System.out.println("=== loadUserByUsername 호출됨: " + userId);
		com.team404.domain.User user = userService.getUserById(userId);
		if (user == null) {
			throw new UsernameNotFoundException("아이디를 찾을 수 없습니다: " + userId);
		}

		String role = user.getUserRole();
		if (role == null || role.isEmpty()) {
			role = "ROLE_USER";
		}

	    String pw = user.getUserPw();
	    if (pw == null || pw.equals("OAUTH_NO_PW")) {
	        pw = "OAUTH_NO_PW";
	    }
		
		return User.builder()
				.username(user.getUserId())
				.password("{noop}" + user.getUserPw())
				.authorities(Collections.singletonList(new SimpleGrantedAuthority(role)))
				.build();
	}
}
