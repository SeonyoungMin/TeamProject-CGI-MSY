package com.team404.service;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.codef.api.EasyCodef;
import io.codef.api.EasyCodefServiceType;

@Service
public class CodefService {

	@Value("${codef.client-id}")
	private String clientId;

	@Value("${codef.client-secret}")
	private String clientSecret;

	@Value("${codef.public-key}")
	private String publicKey;

	public String verifyAccountHolder(String bankCode, String account) throws Exception {
		EasyCodef codef = new EasyCodef();
		codef.setClientInfoForDemo(clientId, clientSecret);
		codef.setPublicKey(publicKey);

		HashMap<String, Object> params = new HashMap<>();
		params.put("organization", bankCode);
		params.put("account", account);

		String result = codef.requestProduct("/v1/kr/bank/a/account/holder", EasyCodefServiceType.DEMO, params);

		System.out.println("CODEF 응답: " + result);

		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(result);
		String code = root.get("result").get("code").asText();

		if ("CF-00000".equals(code)) {
			return root.get("data").get("name").asText();
		}
		return null;
	}
}