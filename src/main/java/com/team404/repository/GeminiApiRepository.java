package com.team404.repository;

import com.team404.domain.Image;

public interface GeminiApiRepository {

	// 이미지 + 프롬프트를 Gemini에 전달하고 응답 반환.
	// 내부 인코딩(base64) 디테일은 구현체가 책임진다.
	String analyze(Image image, String prompt);
}
