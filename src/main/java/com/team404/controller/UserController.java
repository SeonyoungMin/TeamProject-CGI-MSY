package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.Image;
import com.team404.domain.ProductListDto;
import com.team404.domain.Rangking;
import com.team404.domain.ReviewDto;
import com.team404.domain.SearchDTO;
import com.team404.domain.User;
import com.team404.exception.NoUserFoundException;
import com.team404.service.ImageService;
import com.team404.service.ProductService;
import com.team404.service.RankingService;
import com.team404.service.ReviewService;
import com.team404.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

	private static final String ROLE_ADMIN = "ROLE_ADMIN";

	@Autowired
	private UserService userService;

	@Autowired
	private ProductService productService;
	
	@Autowired
	private ReviewService reviewService;

	@Autowired
	private ImageService imageService;

	@Autowired
	private RankingService rankingService;

	// 로그인한 사용자가 관리자인지 검사
	private boolean isAdmin(HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		return loginUser != null && ROLE_ADMIN.equals(loginUser.getUserRole());
	}

	@GetMapping("/")
	public String mainPage() {
		return "redirect:/home";
	}

	// 홈
	@GetMapping("/home")
	public String home(@RequestParam(value = "category", required = false) String category, Model model) {
		
		List<ProductListDto> productList;
		
		if (category != null && !category.isEmpty()) {
			productList = productService.findByCategory(category);
		} else {
			productList = productService.findAll(0, 6);
		}
		
		List<Rangking> topSellers = rankingService.findTopSellers(3);
		List<Rangking> topBuyers = rankingService.findTopBuyers(3);
		List<ProductListDto> popularList = productService.findTopByViewCount(3, category);
		
		model.addAttribute("popularList", popularList);
		model.addAttribute("productList", productList);
		model.addAttribute("topSellers", topSellers);
		model.addAttribute("topBuyers", topBuyers);
		model.addAttribute("selectedCategory", category);
		return "home";
	}

	// 회원가입
	@GetMapping("/signup")
	public String signupForm() {
		return "signup";
	}

	// 회원가입 처리 — User 객체에 폼 값 자동 바인딩
	@PostMapping("/users")
	public String signup(@ModelAttribute User user) {
		userService.setNewUser(user);
		return "redirect:/login";
	}

	// 로그인
	@GetMapping("/login")
	public String loginForm(@RequestParam(value = "redirect", required = false) String redirect, Model model) {
		// 로그인 후 원래 가려던 페이지로 보내기 위해 redirect 값을 폼에 hidden으로 넘김
		model.addAttribute("redirect", redirect);
		return "login";
	}

	/*
	 * // 로그인 처리 — 아이디/비밀번호 일치하면 세션에 저장
	 * 
	 * @PostMapping("/login") public String login(@RequestParam("userId") String
	 * userId, @RequestParam("userPw") String userPw,
	 * 
	 * @RequestParam(value = "redirect", required = false) String redirect,
	 * HttpSession session) {
	 * 
	 * User user = userService.getUserById(userId);
	 * 
	 * if (user != null && user.getUserPw().equals(userPw)) {
	 * session.setAttribute("loginUser", user); // redirect 파라미터가 있으면 그쪽으로, 없으면 홈으로
	 * if (redirect != null && !redirect.isEmpty()) { return "redirect:" + redirect;
	 * } return "redirect:/home"; } return "redirect:/login"; }
	 */

	// 마이페이지 — 내 정보 + 내가 등록한 상품 보여줌
	@GetMapping("/mypage")
	public String myPage(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		List<ProductListDto> myProducts = productService.findBySeller(loginUser.getUserNo());

		// 프로필 사진 — 있으면 첫 번째, 없으면 null
		List<Image> profileImages = imageService.getImages("user", loginUser.getUserNo());
		Image profileImage = profileImages.isEmpty() ? null : profileImages.get(0);

		model.addAttribute("user", loginUser);
		model.addAttribute("myProducts", myProducts);
		model.addAttribute("profileImage", profileImage);
		
		int loginMemberNo = 30001;
		List<ReviewDto> reviewList = reviewService.findReviewsByUser(loginMemberNo);
	    model.addAttribute("reviewList", reviewList);
	    
		return "myPage";
	}

	// 관리자 검색 진입점 — 전체 회원 목록으로 보냄
	@GetMapping("/users/search")
	public String redirectLegacySearch(HttpSession session) {
		if (!isAdmin(session)) {
			return "redirect:/home";
		}
		return "redirect:/users/search/allUsers";
	}

	@GetMapping("/users/search/allUsers")
	public String getAllUsers(@ModelAttribute("searchDTO") SearchDTO searchDTO, Model model,
			@RequestParam(defaultValue = "1", value = "pageNumber") int pageNumber,
			@RequestParam(defaultValue = "10", value = "limit") int limit, HttpSession session) {

		if (!isAdmin(session)) {
			return "redirect:/home";
		}

		List<User> allUsers = userService.getAllUsers(searchDTO, pageNumber, limit);
		int countAll = userService.countAll();
		int totalPages = (countAll % limit) == 0 ? countAll / limit : (countAll / limit) + 1;

		model.addAttribute("users", allUsers);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNumber);
		model.addAttribute("limit", limit);
		return "allUsers";
	}

	@GetMapping("/users/search/searchMode")
	public String getUsersBySearch(@ModelAttribute("searchDTO") SearchDTO searchDTO, Model model,
			@RequestParam(defaultValue = "1", value = "pageNumber") int pageNumber,
			@RequestParam(defaultValue = "5", value = "limit") int limit, HttpSession session) {

		if (!isAdmin(session)) {
			return "redirect:/home";
		}

		List<User> userBySearch = userService.adminSearchUser(searchDTO, pageNumber, limit);
		int totalRows = searchDTO.getTotalRows();
		int totalPages = (totalRows % limit) == 0 ? totalRows / limit : (totalRows / limit) + 1;

		model.addAttribute("users", userBySearch);
		model.addAttribute("count", totalRows);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNumber);
		model.addAttribute("limit", limit);
		return "usersBySearch";
	}

	@GetMapping("/users/search/{userNo}")
	public String getUserByNo(@PathVariable("userNo") int userNo, Model model, HttpSession session) {
		if (!isAdmin(session)) {
			return "redirect:/home";
		}
		User userByNo = userService.getUserByNo(userNo);
		model.addAttribute("user", userByNo);
		return "user";
	}

	// 회원 정보 수정 폼 — 본인 또는 관리자만 진입
	@GetMapping("/users/edit/{userNo}")
	public String getEditUserForm(@PathVariable("userNo") int userNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		if (loginUser.getUserNo() != userNo && !isAdmin(session)) {
			return "redirect:/home";
		}
		User userByNo = userService.getUserByNo(userNo);
		model.addAttribute("editUser", userByNo);
		return "editUser";
	}

	// 회원 정보 수정 처리
	@PutMapping("/users/edit")
	public String submitEditUserForm(@ModelAttribute("editUser") User editUser) {
		userService.setEditUser(editUser);
		return "redirect:/users/search/" + editUser.getUserNo();
	}

	// 회원 삭제 (관리자 전용)
	@DeleteMapping("/users/delete/{userNo}")
	public String submitDeleteUserForm(@PathVariable("userNo") int userNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");

		// 본인이거나 관리자인 경우에만 삭제 허용
		if (loginUser != null && (loginUser.getUserNo() == userNo || isAdmin(session))) {
			userService.setDeleteUser(userNo);

			// 본인이 탈퇴한 경우 세션을 무효화(로그아웃) 처리
			if (loginUser.getUserNo() == userNo) {
				session.invalidate();
				return "redirect:/home"; // 로그인 안 된 홈으로 이동
			}
		}

		return "redirect:/home";
	}

	// register.jsp — 테스트용
	@GetMapping("/register")
	public String registerPage() {
		return "register";
	}

	// 잘못된 회원번호로 접근 시 noUserFound 로 보냄
	@ExceptionHandler(NoUserFoundException.class)
	public String noUserFoundHandler(NoUserFoundException exception, Model model) {
		model.addAttribute("invalidUserNo", exception.getUserNo());
		return "noUserFound";
	}
}
