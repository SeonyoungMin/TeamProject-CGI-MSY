package com.team404.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.OrderService;
import com.team404.service.ProductService;
import com.team404.service.ReviewService;
import com.team404.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

	@Autowired
	private OrderService orderService;

	@Autowired
	private ProductService productService;

	@Autowired
	private UserService userService;

	@Autowired
	private ReviewService reviewService;

	// 거래 방식 선택 페이지
	@GetMapping("/order/select")
	public String selectOrder(@RequestParam("productNo") int productNo, Model model) {

		model.addAttribute("product", productService.findProductDetail(productNo));

		return "orderSelect";
	}

	// 거래 방식 분기 처리
	@PostMapping("/order/route")
	public String routeOrder(@RequestParam("productNo") int productNo, @RequestParam("type") String type,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login"; //
		}

		// 직거래 선택 시
		if ("DIRECT".equals(type)) {

			if (loginUser.getLatitude() != null && loginUser.getLongitude() != null) {
				return "redirect:/location-auth/check?productNo=" + productNo + "&lat=" + loginUser.getLatitude()
						+ "&lng=" + loginUser.getLongitude();
			}

			return "redirect:/location-auth?productNo=" + productNo; //
		}

		// 계좌이체 → 바로 주문
		if ("TRANSFER".equals(type)) {
			orderService.processOrder(productNo, loginUser.getUserNo()); //
			return "redirect:/complete?productNo=" + productNo; //
		}

		return "redirect:/";
	}

	// 동네 인증 페이지
	@GetMapping("/location-auth")
	public String locationAuth(@RequestParam("productNo") int productNo, Model model) {
		model.addAttribute("productNo", productNo);
		return "locationAuth";
	}

	// 동네 인증 완료
	@RequestMapping(value = "/location-auth/check", method = { RequestMethod.GET, RequestMethod.POST })
	public String checkLocation(@RequestParam("productNo") int productNo, @RequestParam("lat") double userLat,
			@RequestParam("lng") double userLng, HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		ProductDetailDto product = productService.findProductDetail(productNo);
		User seller = userService.getUserByNo(product.getSellerNo());

		double sellerLat = seller.getLatitude();
		double sellerLng = seller.getLongitude();
		double distanceDiff = Math.sqrt(Math.pow(userLat - sellerLat, 2) + Math.pow(userLng - sellerLng, 2));
		boolean verified = distanceDiff <= 0.035;

		model.addAttribute("product", product);
		model.addAttribute("seller", seller);
		model.addAttribute("verified", verified);

		return "locationResult";
	}

	// 직거래 인증 성공
	@PostMapping("/direct-complete")
	public String directComplete(@RequestParam("productNo") int productNo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		orderService.processOrder(productNo, loginUser.getUserNo());
		return "redirect:/complete?productNo=" + productNo;
	}

	// 완료 페이지
	@GetMapping("/complete")
	public String completePage(@RequestParam("productNo") int productNo, HttpSession session, Model model) {

		ProductDetailDto product = productService.findProductDetail(productNo);
		User loginUser = (User) session.getAttribute("loginUser");

		boolean alreadyReviewed = false;
		if (loginUser != null) {
			alreadyReviewed = reviewService.existsReview(productNo, loginUser.getUserNo());
		}

		model.addAttribute("product", product);
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("alreadyReviewed", alreadyReviewed);

		return "orderComplete";
	}
}