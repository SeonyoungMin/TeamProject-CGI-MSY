package com.team404.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.FavoriteService;
import com.team404.service.ProductService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/favorite")
public class FavoriteController {

	@Autowired
	private FavoriteService service;

	@Autowired
	private ProductService productService;

	private User getLoginUser(HttpSession session) {
		return (User) session.getAttribute("loginUser");
	}

	// 1. 찜 페이지 이동 — 로그인 필요
	@GetMapping("")
	public String favoritePage(HttpSession session) {
		if (getLoginUser(session) == null) {
			return "redirect:/login?redirect=/favorite";
		}
		return "favorite";
	}

	// 2. 내가 찜한 productNo 목록 (productDetail.jsp 의 checkFavorite 가 사용)
	@GetMapping("/my")
	@ResponseBody
	public List<Integer> myFavorites(@RequestParam("userNo") int userNo) {
		return service.findBoardNosByUser(userNo);
	}

	// 3. 내 찜 목록 + 상품 상세
	@GetMapping("/my/products")
	@ResponseBody
	public List<ProductDetailDto> myFavoriteProducts(@RequestParam("userNo") int userNo) {
		List<Integer> productNos = service.findBoardNosByUser(userNo);
		List<ProductDetailDto> result = new ArrayList<>();
		for (Integer pNo : productNos) {
			try {
				result.add(productService.findProductDetail(pNo));
			} catch (Exception e) {
				// 이미 삭제된 상품 등 — 조용히 skip
			}
		}
		return result;
	}

	// 3. 찜 추가 — 로그인 필요 (비로그인 시 401)
	@PostMapping("/add")
	@ResponseBody
	public void addFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo,
			HttpSession session, HttpServletResponse response) throws java.io.IOException {
		if (getLoginUser(session) == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "login required");
			return;
		}
		service.insertFavorite(userNo, boardNo);
	}

	// 4. 찜 삭제 — 로그인 필요 (비로그인 시 401)
	@PostMapping("/remove")
	@ResponseBody
	public void removeFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo,
			HttpSession session, HttpServletResponse response) throws java.io.IOException {
		if (getLoginUser(session) == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "login required");
			return;
		}
		service.delete(userNo, boardNo);
	}
}