package com.team404.repository;

import java.util.List;
import com.team404.domain.Image;

public interface GeminiApiRepository {

	// 이미지들을 꺼내서 ai 분석
	String analyzeMultiple(List<Image> images, String prompt);
}