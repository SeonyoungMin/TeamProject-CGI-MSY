package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.service.RankingService;

@Controller
@RequestMapping("/ranking")
public class RankingController {

	@Autowired
	private RankingService rankingService;

	@GetMapping("")
	public String rankingMain(Model model) {
		model.addAttribute("salesKing", rankingService.findSalesKing());
		model.addAttribute("spendingKing", rankingService.findSpendingKing());
		return "ranking";
	}

	
//	 테스트용 
	@GetMapping(value = "/test", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String insertTestData() {
		rankingService.insertTestData();
		return "테스트 데이터 삽입 완료 /ranking 에서 확인";
	}
}
