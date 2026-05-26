package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.team404.domain.Report;
import com.team404.domain.User;
import com.team404.service.ReportService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReportController {

	@Autowired
	private ReportService reportService;

	@PostMapping("/report/create")
	public String create(@ModelAttribute Report report, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		// 로그인 안됨
		if (loginUser == null) {
			return "redirect:/login";
		}

		// 신고자 저장
		report.setReporterNo(loginUser.getUserNo());

		// 서비스 호출
		reportService.report(report);

		return "redirect:/home";
	}
}