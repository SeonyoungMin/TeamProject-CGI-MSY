package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.ReviewDto;
import com.team404.service.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

	@Autowired
	private ReviewService reviewService;

	//테스트용 매핑 합칠 때 없애면 됨
	@GetMapping("/reviewTest")
	public String reviewTest(HttpSession session, Model model) {
		int loginMemberNo = 30001; // 임시

		// 내가 쓴 후기 목록
		List<ReviewDto> reviewList = reviewService.findReviewsByUser(loginMemberNo);
		model.addAttribute("reviewList", reviewList);
		// 상품 상세용 후기 (테스트할 product_no 직접 입력)
		ReviewDto review = reviewService.findReviewByProduct(30001); // 실제 product_no로 변경
		model.addAttribute("review", review);

		return "review";
	}

	@PostMapping("/review")
	public String registerReview(
			@RequestParam("productNo") int productNo,
			@RequestParam("content") String content,
			HttpSession session) {
 
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
		int loginMemberNo = 30001; // 임시 - 로그인 연동 후 변경
 
		reviewService.registerReview(productNo, loginMemberNo, content);
		return "redirect:/reviewTest";
	}

	@PutMapping("/review/{boardNo}")
	public String updateReview(@PathVariable("boardNo") int boardNo, @RequestParam("content") String content,
			HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
		int loginMemberNo = 30001;

		reviewService.updateReview(boardNo, content, loginMemberNo);
		return "redirect:/reviewTest";
	}

	@DeleteMapping("/review/{boardNo}")
	public String deleteReview(@PathVariable("boardNo") int boardNo, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
		int loginMemberNo = 30001;

		reviewService.deleteReview(boardNo, loginMemberNo);
		return "redirect:/reviewTest";
	}

}