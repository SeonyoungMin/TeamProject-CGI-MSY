package com.team404.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;
import com.team404.service.ProductService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

	@Autowired
	private ProductService productService;

	@GetMapping("/welcome")
	public String welcome() {
		return "welcome"; // welcome.jsp
	}

	// 상품 전체 목록 조회 (+페이징)
	@GetMapping("/productList")
	@ResponseBody
	public Object getProductList(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "limit", defaultValue = "6") int limit,
			@RequestParam(value = "dataOnly", required = false) String dataOnly, Model model) {

		Map<String, Object> data = getProductData(pageNum, limit);

		// =========================
		// ⭐ 데이터만 요청 (AJAX)
		// =========================
		if ("true".equals(dataOnly)) {
			return data;
		}

		// =========================
		// ⭐ 화면 요청 (JSP)
		// =========================
		model.addAllAttributes(data);
		return "productList";
	}

	// =========================
	// ⭐ 공통 로직 분리
	// =========================
	private Map<String, Object> getProductData(int pageNum, int limit) {

		int start = (pageNum - 1) * limit;

		List<ProductListDto> list = productService.findAll(start, limit);
		int total = productService.countAll();

		int totalPages = (int) Math.ceil((double) total / limit);

		Map<String, Object> map = new HashMap<>();
		map.put("list", list);
		map.put("currentPage", pageNum);
		map.put("totalPages", totalPages);

		return map;
	}

	// 상품 상세 조회
	@GetMapping("/product/{productNo}")
	public String getProduct(@PathVariable("productNo") int productNo, Model model) {
		ProductDetailDto listByProductNo = productService.findProductDetail(productNo);
		model.addAttribute("listByProductNo", listByProductNo);
		return "productDetail";
	}

	// 상품 조건 조회
	@GetMapping("/product/search")
	public String searchProducts(@RequestParam("keyword") String keyword, Model model) {
		List<ProductListDto> searchByKeyword = productService.findByKeyword(keyword);
		model.addAttribute("list", searchByKeyword);
		model.addAttribute("keyword", keyword);
		return "productList";
	}

	// 카테고리별 조회
	@GetMapping("/product/category")
	public String getProductsByCategory(@RequestParam("category") String category, Model model) {
		List<ProductListDto> listByCategory = productService.findByCategory(category);
		model.addAttribute("list", listByCategory);
		model.addAttribute("category", category);
		return "productList";
	}

	// 내 판매 목록 조회
	@GetMapping("/product/mylist")
	public String getMySalesList(Model model, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login"; //아침님이 구현한 로그인 페이지로 돌아가게끔 url경로 바꿔야함
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
		int loginMemberNo = 1;
		List<ProductListDto> mySalesList = productService.findBySeller(loginMemberNo);
		model.addAttribute("list", mySalesList);
		return "productList";
	}

	// 상품 등록 폼 (본인 확인 필요)
	@GetMapping("/product/new")
	public String registerForm(@ModelAttribute("newProduct") Product product, HttpSession session, Model model) {
////		if (session.getAttribute("loginMemberNo") == null) {
////			return "redirect:/login";
////		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
//		String loginNickname = (String) session.getAttribute("loginNickname");
//		
//		model.addAttribute("sellerNo", loginMemberNo);
//		model.addAttribute("sellerNickName", loginNickname);
		model.addAttribute("sellerNo", 1);
		model.addAttribute("sellerNickName", "관리자");

		return "productAddForm";
	}

	// 상품 등록 처리
	@PostMapping("/product")
	public String registerProduct(@RequestParam("productName") String name, @RequestParam("category") String category,
			@RequestParam("price") long price,
			@RequestParam(value = "description", required = false) String description,
			@RequestParam(value = "imgFiles", required = false) List<MultipartFile> imgFiles, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}

//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");

		int loginMemberNo = 1;

		Product product = new Product();
		product.setProductName(name);
		product.setCategory(category);
		product.setPrice(price);
		product.setDescription(description);

		productService.registerProduct(product, imgFiles, loginMemberNo);
		return "redirect:/productList";
	}

	// 상품 수정 폼 (본인 확인 필요)
	@GetMapping("/product/{productNo}/edit")
	public String requestUpdateProduct(@PathVariable("productNo") int productNo, Model model, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
		ProductDetailDto updateForm = productService.findProductDetail(productNo);
		model.addAttribute("update", updateForm);
		return "productEditForm";
	}

	// 상품 수정 처리
	@PutMapping("/product/{productNo}")
	public String submitUpdateProduct(@PathVariable("productNo") int productNo,
			@ModelAttribute("product") Product product,
			@RequestParam(value = "imgFiles", required = false) List<MultipartFile> imgFiles, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo =(int) session.getAttribute("loginMemberNo");

		int loginMemberNo = 1;
		product.setProductNo(productNo);
		productService.updateProduct(product, imgFiles, loginMemberNo);
		return "redirect:/product/" + productNo;
	}

	// 상품 삭제 (본인 확인 필요)
	@DeleteMapping("/product/{productNo}")
	public String requestDeleteProduct(@PathVariable("productNo") int productNo, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
		int loginMemberNo = 1;
		productService.deleteProduct(productNo, loginMemberNo);
		return "redirect:/productList";

	}

	// 상품 거래 상태 변경 (본인 확인 필요)
	@PostMapping("/product/{productNo}/status")
	public String updateTradeStatus(@PathVariable("productNo") int productNo,
			@RequestParam("status") String tradeStatus, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
		int loginMemberNo = 1;
		productService.updateTradeStatus(productNo, tradeStatus, loginMemberNo);
		return "redirect:/product/" + productNo;
	}

}
