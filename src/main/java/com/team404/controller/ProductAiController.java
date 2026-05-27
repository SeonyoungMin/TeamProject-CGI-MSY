package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.team404.service.AiAnalysisService;

@Controller
@RequestMapping("/product/ai")
public class ProductAiController {

	@Autowired
	private AiAnalysisService aiAnalysisService;

	// 상품 전체 AI 분석
	@PostMapping("/analyze")
	@ResponseBody
	public String analyze(@RequestParam("productNo") int productNo, @RequestParam("description") String description) {

		return aiAnalysisService.analyzeProduct(productNo, description);

	}
}