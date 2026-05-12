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
import com.team404.domain.User;
import com.team404.service.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

	@Autowired
	private ReviewService reviewService;

	// 후기 등록 처리
	@PostMapping("/review/add")
	public String registerReview(@RequestParam("productNo") int productNo, @RequestParam("content") String content,
			@RequestParam("sellerNo") int sellerNo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login";
		}

		// 작성자는 로그인한 유저, 타겟은 sellerNo를 가진 판매자
		reviewService.registerReview(productNo, loginUser.getUserNo(), content);

		// 등록 후 다시 보던 판매자의 유저페이지로 이동
		return "redirect:/users/search/" + sellerNo;
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