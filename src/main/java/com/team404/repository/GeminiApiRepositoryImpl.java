package com.team404.repository;

import java.util.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team404.domain.Image;

// 제미나이 AI API 통신부. 글+이미지 보내고 JSON 답 받음
@Repository
public class GeminiApiRepositoryImpl implements GeminiApiRepository {

	// properties 에서 주소/모델/내 API키 가져옴
	@Value("${gemini.api.base-url}")
	private String baseUrl;
	@Value("${gemini.api.model}")
	private String model;
	@Value("${gemini.api.key}")
	private String apiKey;

	// JSON 변환기
	private final ObjectMapper objectMapper = new ObjectMapper();

	@Override
	public String analyzeMultiple(List<Image> images, String prompt) {
		// 호출 주소 조립
		String url = baseUrl + "/" + model + ":generateContent?key=" + apiKey;

		// AI에 보낼 내용물 = 명령글(prompt) + 이미지들
		List<Map<String, Object>> parts = new ArrayList<>();
		parts.add(Map.of("text", prompt));

		// 이미지 병렬 다운로드 후 base64로 바꿔 넣음
		List<Map<String, Object>> imageParts = images.parallelStream().map(img -> {
			try {
				ResponseEntity<byte[]> imgRes = new RestTemplate().getForEntity(img.getFilePath(), byte[].class);
				byte[] imageBytes = imgRes.getBody();
				if (imageBytes == null || imageBytes.length == 0)
					return null;

				// 타입 틀리면 사진 인식 실패함 → 실제 타입 사용
				String mimeType = (imgRes.getHeaders().getContentType() != null)
						? imgRes.getHeaders().getContentType().toString()
						: guessMimeType(img.getFilePath());

				// 사진 1장 형식 (타입 + base64 데이터)
				Map<String, Object> inlineData = new HashMap<>();
				inlineData.put("mime_type", mimeType);
				inlineData.put("data", Base64.getEncoder().encodeToString(imageBytes));
				return Map.<String, Object>of("inline_data", inlineData);
			} catch (Exception e) {
				// 한 장 실패해도 나머지로 계속 진행
				System.err.println("이미지 다운로드 실패: " + img.getFilePath() + " - " + e.getMessage());
				return null;
			}
		}).filter(Objects::nonNull).toList();
		parts.addAll(imageParts);
		System.out.println("gemini 첨부 이미지 " + imageParts.size() + "장 (전체 " + images.size() + "장 중)");

		// AI 답변 방식 설정
		Map<String, Object> generationConfig = new HashMap<>();
		generationConfig.put("temperature", 0); // 0 = 매번 같은 답
		generationConfig.put("responseMimeType", "application/json"); // JSON으로만 답 받음
		// 사고(thinking) 끔 → 빨라짐
		Map<String, Object> thinkingConfig = new HashMap<>();
		thinkingConfig.put("thinkingBudget", 0);
		generationConfig.put("thinkingConfig", thinkingConfig);

		// 전송할 JSON 본문
		Map<String, Object> requestBody = Map.of("contents", List.of(Map.of("parts", parts)), "generationConfig",
				generationConfig);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON); // JSON 보낸다고 표시

		RestTemplate restTemplate = new RestTemplate();
		try {
			// POST 보내고 응답 받음
			String raw = restTemplate.postForObject(url, new HttpEntity<>(requestBody, headers), String.class);
			return extractText(raw); // 진짜 답만 꺼냄
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("API 호출 실패: " + e.getMessage());
		}
	}

	// 응답 껍데기에서 진짜 답만 꺼냄
	private String extractText(String raw) {
		try {
			JsonNode text = objectMapper.readTree(raw).path("candidates").path(0).path("content").path("parts").path(0)
					.path("text");

			if (text.isMissingNode() || text.asText().isBlank()) {
				return errorJson("AI 응답이 비어있습니다.");
			}

			// 코드펜스(```) 떼고 반환
			return text.asText().replaceAll("(?s)```(?:json)?", "").trim();
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("AI 응답 파싱 실패: " + e.getMessage());
		}
	}

	// 헤더 없을 때 확장자로 타입 추정
	private String guessMimeType(String url) {
		String u = (url == null) ? "" : url.toLowerCase();
		if (u.endsWith(".png"))
			return "image/png";
		if (u.endsWith(".gif"))
			return "image/gif";
		if (u.endsWith(".webp"))
			return "image/webp";
		return "image/jpeg"; // 기본값
	}

	// 에러도 JSON으로 반환
	private String errorJson(String message) {
		try {
			return objectMapper.writeValueAsString(Map.of("error", message));
		} catch (Exception e) {
			return "{\"error\":\"unknown\"}";
		}
	}
}
