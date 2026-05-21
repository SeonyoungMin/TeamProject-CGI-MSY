package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.NotificationService;
import com.team404.service.ProductService;
import com.team404.service.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private ProductService productService; // 상품 정보(판매자) 조회용

	@Autowired
	private NotificationService notificationService; // 알림 서비스

	// 후기 등록 처리
	@PostMapping("/review/add")
	public String registerReview(@RequestParam("productNo") int productNo, @RequestParam("content") String content,
			@RequestParam("sellerNo") int sellerNo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login";
		}

		// 이미 이 상품에 후기를 작성한 경우 등록 차단
		if (reviewService.existsReview(productNo, loginUser.getUserNo())) {
			return "redirect:/users/search/" + sellerNo + "?productNo=" + productNo;
		}

		// 작성자는 로그인한 유저, 타겟은 sellerNo를 가진 판매자
		reviewService.registerReview(productNo, loginUser.getUserNo(), content);

		// 구매후기 알림
		try {
			ProductDetailDto product = productService.findProductDetail(productNo);
			notificationService.notifyReview(loginUser.getUserNo(), sellerNo, productNo, product.getProductName(),
					loginUser.getUserNickName());
		} catch (Exception e) {

		}

		// 등록 후 다시 보던 판매자의 유저페이지로 이동
		return "redirect:/users/search/" + sellerNo;

	}

	@PostMapping("/review/{boardNo}/edit")
	public String updateReview(@PathVariable("boardNo") int boardNo, @RequestParam("sellerNo") int sellerNo,
			@RequestParam("productNo") int productNo,
			@RequestParam("content") String content, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login";
		}

		// 기존 후기 삭제
		reviewService.deleteReview(boardNo, loginUser.getUserNo());

		session.setAttribute("prevReviewContent", content);

		return "redirect:/users/search/" + sellerNo + "?productNo=" + productNo;
	}

	@PostMapping("/review/{boardNo}/delete")
	public String deleteReview(@PathVariable("boardNo") int boardNo, @RequestParam("productNo") int productNo,
			@RequestParam("sellerNo") int sellerNo, @RequestParam("content") String content, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login";
		}
		reviewService.deleteReview(boardNo, loginUser.getUserNo());

		session.setAttribute("prevReviewContent", content);
		return "redirect:/users/search/" + sellerNo + "?productNo=" + productNo;
	}

}