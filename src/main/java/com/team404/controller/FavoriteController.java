package com.team404.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.FavoriteService;
import com.team404.service.NotificationService;
import com.team404.service.ProductService;

import jakarta.servlet.http.HttpSession;


@Controller
public class FavoriteController {

	@Autowired
	private FavoriteService favoriteService;

	@Autowired
	private ProductService productService;
	
	@Autowired
	private NotificationService notificationService;

	// 내 찜 목록 페이지
	@GetMapping("/favorite")
	public String favoritePage(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		// 찜한 상품 번호들을 가져와서, 각각 상세 정보까지 채워서 화면으로 전달
		List<Integer> productNos = favoriteService.findBoardNosByUser(loginUser.getUserNo());
		List<ProductDetailDto> products = new ArrayList<>();
		for (Integer pNo : productNos) {
			try {
				products.add(productService.findProductDetail(pNo));
			} catch (Exception e) {
				// 이미 삭제된 상품은 건너뜀
			}
		}
		model.addAttribute("products", products);
		return "favorite";
	}

	// AJAX: 찜 버튼 누르면 — 이미 찜이면 삭제, 아니면 추가
	@PostMapping("/favorite/toggle")
	@ResponseBody
	public String toggleFavorite(@RequestParam("productNo") int productNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "login";
		}

		int userNo = loginUser.getUserNo();
		if (favoriteService.exists(userNo, productNo)) {
			favoriteService.delete(userNo, productNo);
			return "removed";
		} else {
			favoriteService.insertFavorite(userNo, productNo);
			
			try {
				ProductDetailDto product = productService.findProductDetail(productNo);
				notificationService.notifyFavorite(loginUser.getUserNo(), product.getSellerNo(), productNo, product.getProductName(), loginUser.getUserNickName());
			}catch (Exception e) {
				
			}
			return "added";
		}
	}

	// 찜 목록 페이지에서 찜 취소 버튼 누르면 단순 삭제 후 다시 찜 목록으로
	@PostMapping("/favorite/remove")
	public String remove(@RequestParam("productNo") int productNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		favoriteService.delete(loginUser.getUserNo(), productNo);
		return "redirect:/favorite";
	}
}
