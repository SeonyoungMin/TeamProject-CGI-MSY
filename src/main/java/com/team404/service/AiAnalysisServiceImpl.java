package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Image;
import com.team404.repository.GeminiApiRepository;

@Service
public class AiAnalysisServiceImpl implements AiAnalysisService {

	@Autowired
	private GeminiApiRepository geminiApiRepository;

	@Autowired
	private ImageService imageService;

	@Override
	public String analyzeProduct(int productNo, String description) {

		// 이미지 가져오기
		List<Image> images = imageService.getImages("product", productNo);

		if (images.isEmpty()) {
			return "이미지가 없습니다.";
		}

		// 대표 이미지 1장 사용
		Image mainImage = images.get(0);

		String prompt = "이 상품을 중고 기준으로 분석해줘.\n"
				+ "1. 상태 등급 (A~F)\n"
				+ "2. 내구성\n"
				+ "3. 예상 중고 가격\n"
				+ "4. 하자 여부\n"
				+ "5. 도용 가능성\n\n"
				+ "상품 설명: " + description;

		// AI 호출 (base64 인코딩 등 디테일은 Repository 내부에서 처리)
		return geminiApiRepository.analyze(mainImage, prompt);
	}
}
