package com.team404.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class KakaoService {

	@Value("${spring.security.oauth2.client.registration.kakao.client-id}")
	private String clientId;

	@Value("${spring.security.oauth2.client.registration.kakao.client-secret}")
	private String clientSecret;

	@Autowired
	private RestTemplate restTemplate;

	public String getAccessToken(String code) throws Exception {
		String tokenUrl = "https://kauth.kakao.com/oauth/token";

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();

		params.add("grant_type", "authorization_code");
		params.add("client_id", clientId);
		params.add("redirect_uri", "http://localhost:8080/minimarket/login/kakao/callback");
		params.add("code", code);
		params.add("client_secret", clientSecret);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
		ResponseEntity<String> response = restTemplate.exchange(tokenUrl, HttpMethod.POST, request, String.class);

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = mapper.readValue(response.getBody(), Map.class);
		return (String) map.get("access_token");
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getUserInfo(String accessToken) throws Exception {
		String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(accessToken);

		HttpEntity<Void> request = new HttpEntity<>(headers);
		ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, request, String.class);

		ObjectMapper mapper = new ObjectMapper();
		return mapper.readValue(response.getBody(), Map.class);
	}
}