package com.team404.service;

import java.util.Base64;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ImgBBService {

	@Value("${imgbb.api.key}")
	private String apiKey;

	public String upload(MultipartFile file) throws Exception {

		// 디버깅: API 키 확인 (앞 5자만 출력)
		if (apiKey == null || apiKey.isEmpty()) {
			throw new RuntimeException("ImgBB API 키가 설정되지 않았습니다. application.properties 확인 필요.");
		}
		System.out.println("[ImgBB] 업로드 시작 - file: " + file.getOriginalFilename()
				+ " / size: " + file.getSize() + " bytes / apiKey: " + apiKey.substring(0, 5) + "...");

		String base64 = Base64.getEncoder().encodeToString(file.getBytes());

		String url = "https://api.imgbb.com/1/upload?key=" + apiKey;
		RestTemplate restTemplate = new RestTemplate();

		MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
		body.add("image", base64);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);

		ResponseEntity<Map> response = restTemplate.postForEntity(url, request, Map.class);

		System.out.println("[ImgBB] 응답 상태: " + response.getStatusCode());

		Map responseBody = response.getBody();
		if (responseBody == null) {
			throw new RuntimeException("ImgBB 응답이 비어있습니다.");
		}

		Object success = responseBody.get("success");
		if (success == null || !Boolean.TRUE.equals(success)) {
			throw new RuntimeException("ImgBB 업로드 실패 (success=false): " + responseBody);
		}

		Map data = (Map) responseBody.get("data");
		if (data == null) {
			throw new RuntimeException("ImgBB 응답에 data 필드 없음: " + responseBody);
		}

		String imageUrl = data.get("url").toString();
		System.out.println("[ImgBB] 업로드 성공: " + imageUrl);
		return imageUrl;
	}
}
