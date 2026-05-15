package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.domain.Account;
import com.team404.domain.User;
import com.team404.service.AccountService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AccountController {

	@Autowired
	private AccountService accountService;
	
	@GetMapping("/accountList")
	public String getAccountList(@RequestParam(value="pageNum", defaultValue="1") int pageNum,
			@RequestParam(value="limit", defaultValue="5") int limit, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		int loginMemberNo = loginUser.getUserNo();

	int startNum = limit * (pageNum - 1);
	
	List<Account> list = accountService.findAllByBuyer(loginMemberNo, startNum, limit);
	
	int totalNum = accountService.countAllByBuyer(loginMemberNo);
	
	int totalPages = (totalNum % limit) == 0 ? totalNum / limit : (totalNum / limit) +1;
	
	long totalBuy = accountService.getTotalBuy(loginMemberNo);
	
	long totalSell = accountService.getTotalSell(loginMemberNo);
	
	// 순수익
	long netProfit = totalSell - totalBuy;
	
	model.addAttribute("list",list);
	model.addAttribute("totalPage",totalPages);
	model.addAttribute("currentPage", pageNum);
	model.addAttribute("totalBuy", totalBuy);
	model.addAttribute("totalSell", totalSell);
	model.addAttribute("netProfit", netProfit);
	
	return "accountList";
	}
	
	// 메모 수정 (구버전, 폼 submit용 — 호환 유지)
	@PostMapping("/account/{orderNo}")
	public String updateMemo(@PathVariable("orderNo") int orderNo, @RequestParam("memo") String memo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		accountService.updateMemo(orderNo, memo);
		return "redirect:/accountList";
	}

	// 메모 수정 (AJAX) — 페이지 이동 없이 저장
	@PostMapping("/account/{orderNo}/memo")
	@ResponseBody
	public String updateMemoAjax(@PathVariable("orderNo") int orderNo, @RequestParam("memo") String memo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "unauthorized";
		}
		try {
			accountService.updateMemo(orderNo, memo);
			return "success";
		} catch (Exception e) {
			return "error";
		}
	}
}
