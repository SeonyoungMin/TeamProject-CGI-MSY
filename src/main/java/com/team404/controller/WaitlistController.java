package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.ProductService;
import com.team404.service.WaitlistService;

import jakarta.servlet.http.HttpSession;

@Controller
public class WaitlistController {

	@Autowired
	private WaitlistService waitlistService;

	@Autowired
	private ProductService productService;

	// 대기 신청 (예약중 상품에 대해서만)
	@PostMapping("/waitlist/add")
	@ResponseBody
	public String add(@RequestParam("productNo") int productNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "login";

		ProductDetailDto product = productService.findProductDetail(productNo);
		if (product == null)
			return "notfound";
		if (loginUser.getUserNo() == product.getSellerNo())
			return "self";
		if (!"예약중".equals(product.getTradeStatus()))
			return "notreserved";

		waitlistService.add(productNo, loginUser.getUserNo());
		return "added";
	}

	// 대기 취소
	@PostMapping("/waitlist/remove")
	@ResponseBody
	public String remove(@RequestParam("productNo") int productNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "login";

		waitlistService.remove(productNo, loginUser.getUserNo());
		return "removed";
	}
}
