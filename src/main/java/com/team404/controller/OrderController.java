package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.NotificationService;
import com.team404.service.OrderService;
import com.team404.service.ProductService;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

	@Autowired
	private OrderService orderService; // 주문 서비스 연결하기

	@Autowired
	private ProductService productService; // 상품 서비스 연결하기

	@Autowired
	private NotificationService notificationService; // 알림 서비스

	// 상세페이지에서 주문하기 눌렀을 때 선택 페이지 보여주기
	@GetMapping("/order/select")
	public String selectOrder(@RequestParam("productNo") int productNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";
		
		//주문 처리 전에 상품 정보 미리 조회
		ProductDetailDto product = productService.findProductDetail(productNo);
		int sellerNo = product.getSellerNo();
		int buyerNo = loginUser.getUserNo();
		String productName = product.getProductName();

		orderService.processOrder(productNo, buyerNo);
		
		//판매완료 알림
		try {
			notificationService.notifySold(sellerNo, productNo, productName);
		} catch (Exception e) { // 알림 실패가 주문을 막으면 안 됨
			
		}
		
		//구매완료 알림
		try {
			notificationService.notifyBought(buyerNo, productNo, productName);
		} catch (Exception e) { // 알림 실패가 주문을 막으면 안 됨
		}

		model.addAttribute("product", product); // 상품 정보 담기
		return "orderSelect"; // 거래 선택 화면으로 이동
	}

	// 직거래나 계좌이체 버튼 눌렀을 때 최종 처리하기
	@PostMapping("/order/complete")
	public String completeOrder(@RequestParam("productNo") int productNo, Model model) {

		// 완료 페이지에 보여줄 상품 정보 다시 담기
		model.addAttribute("product", productService.findProductDetail(productNo));

		return "orderComplete";
	}
}
