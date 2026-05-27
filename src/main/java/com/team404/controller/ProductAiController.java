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

	@PostMapping(value = "/analyze", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String analyze(@RequestParam(value = "productNo", defaultValue = "0") int productNo,
			@RequestParam(value = "description", defaultValue = "") String description) {
		System.out.println("상품번호 : " + productNo);
		System.out.println("제품설명 : " + description);
		return aiAnalysisService.analyzeProduct(productNo, description);
	}
}