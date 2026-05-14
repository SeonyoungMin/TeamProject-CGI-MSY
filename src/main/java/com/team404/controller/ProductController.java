package com.team404.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Comment;
import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;
import com.team404.domain.ReviewDto;
import com.team404.domain.User;
import com.team404.service.CommentService;
import com.team404.service.FavoriteService;
import com.team404.service.ImageService;
import com.team404.service.ProductService;
import com.team404.service.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

	@Autowired
	private ProductService productService;

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private FavoriteService favoriteService;

	@Autowired
	private ImageService imageService;

	@Autowired
	private CommentService commentService;

	// 상품 전체 목록
	@GetMapping("/productList")
	public String list(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum, HttpSession session, // 세션 추가
			Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		int loginUserNo = (loginUser != null) ? loginUser.getUserNo() : 0; // 로그인 안했으면 0

		int limit = 15;
		int start = (pageNum - 1) * limit;

		List<ProductListDto> list = productService.findAll(start, limit, loginUserNo);
		int total = productService.countAll();

		int totalPages = (total % limit == 0) ? (total / limit) : (total / limit) + 1;

		model.addAttribute("list", list);
		model.addAttribute("currentPage", pageNum);
		model.addAttribute("totalPages", totalPages);

		return "productList";
	}

	// 공통 로직 분리
	private Map<String, Object> getProductData(int pageNum, int limit, int loginUserNo) {
		int start = (pageNum - 1) * limit;

		List<ProductListDto> list = productService.findAll(start, limit, loginUserNo);
		int total = productService.countAll();

		int totalPages = (int) Math.ceil((double) total / limit);

		Map<String, Object> map = new HashMap<>();
		map.put("list", list);
		map.put("currentPage", pageNum);
		map.put("totalPages", totalPages);

		return map;
	}

	// 검색어로 상품 찾기
	@GetMapping("/product/search")
	public String search(@RequestParam("keyword") String keyword, Model model) {
		model.addAttribute("list", productService.findByKeyword(keyword));
		model.addAttribute("keyword", keyword);
		return "productList";
	}

	// 카테고리별 상품 보기
	@GetMapping("/product/category")
	public String category(@RequestParam("category") String category, Model model) {
		model.addAttribute("list", productService.findByCategory(category));
		model.addAttribute("category", category);
		return "productList";
	}

	// 내가 등록한 상품 (로그인 필요, 페이징)
	@GetMapping("/product/mylist")
	public String myList(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum, Model model,
			HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		int limit = 10;
		int startNum = limit * (pageNum - 1);
		model.addAttribute("list", productService.findBySeller(loginUser.getUserNo(), startNum, limit));
		int total = productService.countBySeller(loginUser.getUserNo());
		int totalPages = (total % limit) == 0 ? total / limit : (total / limit) + 1;
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNum);
		return "productList";
	}

	// 상품 상세 — 로그인한 사용자라면 찜 여부도 함께 조회
	@GetMapping("/product/{productNo}")
	public String detail(@PathVariable("productNo") int productNo, Model model, HttpSession session) {
		ProductDetailDto product = productService.findProductDetail(productNo);

		if (product != null && ("완료".equals(product.getTradeStatus()))) {
			model.addAttribute("product", product);
			return "orderComplete";
		}

		User loginUser = (User) session.getAttribute("loginUser");

		// 본인 상품이 아니면 조회수 +1
		if (product != null && (loginUser == null || loginUser.getUserNo() != product.getSellerNo())) {
			productService.increaseViewCount(productNo);
		}

		boolean favorite = false;
		if (loginUser != null) {
			favorite = favoriteService.exists(loginUser.getUserNo(), productNo);
		}

		List<Comment> comments = commentService.getComments(productNo);

		model.addAttribute("product", product);
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("favorite", favorite);
		model.addAttribute("comments", comments);

		// 후기 추가
		ReviewDto review = reviewService.findReviewByProduct(productNo);
		model.addAttribute("review", review);

		return "productDetail";
	}

	// 상품 등록 폼 (로그인 필요)
	@GetMapping("/product/new")
	public String addForm(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		model.addAttribute("loginUser", loginUser);
		return "productAddForm";
	}

	// 상품 등록 처리 — 입력값으로 Product 객체를 만들어 서비스에 넘김
	@PostMapping("/product")
	public String add(@RequestParam("productName") String name, @RequestParam("category") String category,
			@RequestParam("price") long price,
			@RequestParam(value = "description", required = false) String description,
			@RequestParam(value = "imgFiles", required = false) List<MultipartFile> imgFiles, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		Product product = new Product();
		product.setProductName(name);
		product.setCategory(category);
		product.setPrice(price);
		product.setDescription(description);
		product.setSellerNo(loginUser.getUserNo());

		productService.registerProduct(product, imgFiles, loginUser.getUserNo());
		return "redirect:/home";
	}

	// 본인이거나 관리자면 true
	private boolean canManage(User loginUser, int sellerNo) {
		if (loginUser == null)
			return false;
		return loginUser.getUserNo() == sellerNo || "ROLE_ADMIN".equals(loginUser.getUserRole());
	}

	// 상품 수정 폼 — 작성자 본인 또는 관리자
	@GetMapping("/product/{productNo}/edit")
	public String editForm(@PathVariable("productNo") int productNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		ProductDetailDto product = productService.findProductDetail(productNo);
		if (!canManage(loginUser, product.getSellerNo())) {
			return "redirect:/product/" + productNo;
		}
		model.addAttribute("product", product);
		return "productEditForm";
	}

	// 상품 수정 처리 — 본인 또는 관리자
	@PostMapping("/product/{productNo}/edit")
	public String edit(@PathVariable("productNo") int productNo, @RequestParam("productName") String name,
			@RequestParam("category") String category, @RequestParam("price") long price,
			@RequestParam(value = "description", required = false) String description,
			@RequestParam(value = "imgFiles", required = false) List<MultipartFile> imgFiles, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		ProductDetailDto origin = productService.findProductDetail(productNo);
		if (!canManage(loginUser, origin.getSellerNo())) {
			return "redirect:/product/" + productNo;
		}

		Product product = new Product();
		product.setProductNo(productNo);
		product.setProductName(name);
		product.setCategory(category);
		product.setPrice(price);
		product.setDescription(description);

		// 서비스 내부의 본인 검증을 통과시키기 위해 원래 판매자 번호를 넘겨줌
		productService.updateProduct(product, imgFiles, origin.getSellerNo());
		return "redirect:/product/" + productNo;
	}

	// 상품 삭제 — 본인 또는 관리자
	@PostMapping("/product/{productNo}/delete")
	public String delete(@PathVariable("productNo") int productNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		ProductDetailDto origin = productService.findProductDetail(productNo);
		if (!canManage(loginUser, origin.getSellerNo())) {
			return "redirect:/product/" + productNo;
		}
		// 서비스 내부 본인 검증 통과시키려고 원래 판매자 번호 사용
		productService.deleteProduct(productNo, origin.getSellerNo());
		return "redirect:/home";
	}

	// 대표 이미지 변경 — 본인 또는 관리자
	@PostMapping("/product/{productNo}/thumbnail")
	public String setThumbnail(@PathVariable("productNo") int productNo, @RequestParam("imageNo") int imageNo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/login";
		}
		ProductDetailDto origin = productService.findProductDetail(productNo);

		System.out.println("loginUser.getUserNo(): " + loginUser.getUserNo());
		System.out.println("origin.getSellerNo(): " + origin.getSellerNo());
		if (!canManage(loginUser, origin.getSellerNo())) {
			return "redirect:/product/" + productNo;
		}
		imageService.setThumbnail(imageNo, "product", productNo);
		return "redirect:/product/" + productNo + "/edit";
	}

	// 이미지 추가 후 redirect
	@PostMapping("/product/{productNo}/addImage")
	public String addImage(@PathVariable("productNo") int productNo,
			@RequestParam(value = "imgFiles", required = false) List<MultipartFile> imgFiles) {
		if (imgFiles != null && !imgFiles.isEmpty()) {
			imageService.upload(imgFiles, "product", productNo);
		}
		return "redirect:/product/" + productNo + "/edit";
	}
}
