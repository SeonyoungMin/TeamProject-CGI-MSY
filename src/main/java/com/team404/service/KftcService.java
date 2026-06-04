package com.team404.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class KftcService {

	@Value("${kftc.client-id}")
	private String clientId;

	@Value("${kftc.client-secret}")
	private String clientSecret;

	@Value("${kftc.institution-code}")
	private String institutionCode;

	// Access Token 발급
	private String getAccessToken() throws Exception {
		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("client_id", clientId);
		params.add("client_secret", clientSecret);
		params.add("scope", "oob");
		params.add("grant_type", "client_credentials");

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

		ResponseEntity<String> response = restTemplate.exchange("https://testapi.openbanking.or.kr/oauth/2.0/token",
				HttpMethod.POST, request, String.class);

		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(response.getBody());
		return root.get("access_token").asText();
	}

	// 계좌실명조회
	public String verifyRealName(String bankCode, String accountNo, String birthDate) throws Exception {

		// 숫자만 추출
		System.out.println("birthDate: " + birthDate);
		birthDate = birthDate.replaceAll("[^0-9]", "");
		accountNo = accountNo.replaceAll("[^0-9]", "");

		String accessToken = getAccessToken();

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(accessToken);

		String tranDtime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

		String tran = String.valueOf(System.currentTimeMillis());
		String bankTranId = institutionCode + "U" + tran.substring(tran.length() - 9);

		Map<String, String> body = new HashMap<>();
		body.put("bank_tran_id", bankTranId);
		body.put("bank_code_std", bankCode);
		body.put("account_num", accountNo);
		body.put("account_holder_info_type", "");
		body.put("account_holder_info", birthDate); 
		body.put("tran_dtime", tranDtime);

		HttpEntity<Map<String, String>> request = new HttpEntity<>(body, headers);

		ResponseEntity<String> response = restTemplate.exchange(
				"https://testapi.openbanking.or.kr/v2.0/inquiry/real_name", HttpMethod.POST, request, String.class);

		System.out.println("KFTC 응답: " + response.getBody());

		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(response.getBody());
		String rspCode = root.get("rsp_code").asText();

		if ("A0000".equals(rspCode)) {
			return root.get("account_holder_name").asText();
		}
		return null;
	}
}