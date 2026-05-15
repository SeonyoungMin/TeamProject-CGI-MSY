package com.team404.controller;

import java.net.URI;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.client.RestTemplate;

import com.team404.domain.Account;
import com.team404.domain.BoardListDto;
import com.team404.domain.Image;
import com.team404.domain.ProductListDto;
import com.team404.domain.Rangking;
import com.team404.domain.ReviewDto;
import com.team404.domain.SearchDTO;
import com.team404.domain.User;
import com.team404.exception.NoUserFoundException;
import com.team404.service.AccountService;
import com.team404.service.BoardService;
import com.team404.service.GeoService;
import com.team404.service.ImageService;
import com.team404.service.KakaoService;
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

	@Autowired
	private AccountService accountService;

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private KakaoService kakaoService;

	@Autowired
	private GeoService geoService;

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
	public String home(@RequestParam(value = "category", required = false) String category,
			@RequestParam(value = "pageNum", defaultValue = "1") int pageNum, HttpSession session, // 1. 세션 파라미터 추가
			Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		int loginUserNo = (loginUser != null) ? loginUser.getUserNo() : 0;
		int limit = 9;
		int startNum = limit * (pageNum - 1);

		List<ProductListDto> productList;
		if (category != null && !category.isEmpty()) {
			productList = productService.findByCategory(category);
		} else {
			productList = productService.findAll(startNum, limit, loginUserNo);
		}

		int totalNum = productService.countAll();
		int totalPages = (totalNum % limit) == 0 ? totalNum / limit : (totalNum / limit) + 1;

		List<Rangking> topSellers = rankingService.findTopSellers(3);
		List<Rangking> topBuyers = rankingService.findTopBuyers(3);
		List<ProductListDto> popularList = productService.findTopByViewCount(3, category, loginUserNo);
		List<BoardListDto> recentBoards = boardService.findRecentAll(0, 8);

		model.addAttribute("productList", productList);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNum);
		model.addAttribute("topSellers", topSellers);
		model.addAttribute("topBuyers", topBuyers);
		model.addAttribute("selectedCategory", category);
		model.addAttribute("popularList", popularList);
		model.addAttribute("recentBoards", recentBoards);

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
		System.out.println(user.getLatitude());
		System.out.println(user.getLongitude());
		System.out.println(user.getVerifiedArea());
		user.setVerifiedAt(new java.sql.Timestamp(System.currentTimeMillis()));

		userService.setNewUser(user);

		return "redirect:/login";
	}

	// 회원가입시 동네 인증 카카오 API 사용
	@GetMapping(value = "/users/reverse-geocode", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String reverseGeocode(@RequestParam("lat") double lat, @RequestParam("lng") double lng) {

		String apiKey = "42a10ba0a3d99a111dca0c6e0bcd8c93";

		String url = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=" + lng + "&y=" + lat;

		RestTemplate rest = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "KakaoAK " + apiKey);

		HttpEntity<String> entity = new HttpEntity<>(headers);

		ResponseEntity<String> response = rest.exchange(URI.create(url), HttpMethod.GET, entity, String.class);

		String body = response.getBody();

		int start = body.indexOf("\"address_name\":\"") + 16;
		int end = body.indexOf("\"", start);

		return body.substring(start, end);
	}

	@ResponseBody
	@PostMapping("/location")
	public String location(@RequestParam double lat, @RequestParam double lng) {

		return geoService.getAddress(lat, lng);
	}

	// 마이페이지에서 즉시 위치 인증 처리
	@PostMapping("/users/update-location-ajax")
	@ResponseBody
	public String updateLocationAjax(@RequestParam("userNo") int userNo, @RequestParam("address") String address,
			@RequestParam("lat") Double lat, @RequestParam("lng") Double lng, HttpSession session) {

		try {
			User user = userService.getUserByNo(userNo);

			user.setUserAddress(address);
			user.setVerifiedArea(address);
			user.setLatitude(lat);
			user.setLongitude(lng);
			user.setVerifiedAt(new java.sql.Timestamp(System.currentTimeMillis()));

			userService.setEditUser(user);
			session.setAttribute("loginUser", user);

			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}

	// 로그인
	@GetMapping("/login")
	public String loginForm(@RequestParam(value = "redirect", required = false) String redirect, Model model) {
		// 로그인 후 원래 가려던 페이지로 보내기 위해 redirect 값을 폼에 hidden으로 넘김
		model.addAttribute("redirect", redirect);
		return "login";
	}

	// 마이페이지 — 내 정보 + 최근 상품/가계부/구매내역/받은 후기 미리보기
	@GetMapping("/mypage")
	public String myPage(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		int userNo = loginUser.getUserNo();

		List<ProductListDto> myProducts = productService.findBySeller(userNo, 0, 5);

		List<Image> profileImages = imageService.getImages("user", userNo);
		Image profileImage = profileImages.isEmpty() ? null : profileImages.get(0);

		List<Account> accountList = accountService.findAllByBuyer(userNo, 0, 6);

		// 최근 구매내역은 4건만
		List<ProductListDto> boughtList = productService.findBoughtListByBuyerNo(userNo, 0, 4);
		int totalBought = productService.countBoughtByBuyerNo(userNo);

		// 나에게 작성된 후기 (최근 5건만 미리보기)
		List<ReviewDto> allMyReviews = reviewService.findReviewsByUser(userNo);
		int totalMyReviews = allMyReviews.size();
		List<ReviewDto> recentMyReviews = allMyReviews.size() > 5 ? allMyReviews.subList(0, 5) : allMyReviews;

		model.addAttribute("boughtList", boughtList);
		model.addAttribute("totalBought", totalBought);
		model.addAttribute("user", loginUser);
		model.addAttribute("myProducts", myProducts);
		model.addAttribute("profileImage", profileImage);
		model.addAttribute("accountList", accountList);
		model.addAttribute("myReviews", recentMyReviews);
		model.addAttribute("totalMyReviews", totalMyReviews);
		return "myPage";
	}

	// 구매내역 전체보기 (페이지당 15개)
	@GetMapping("/mypage/bought")
	public String boughtListPage(@RequestParam(value = "page", defaultValue = "1") int page,
			HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		int userNo = loginUser.getUserNo();
		int pageSize = 15;
		int total = productService.countBoughtByBuyerNo(userNo);
		int totalPages = (total + pageSize - 1) / pageSize;
		if (page < 1) {
			page = 1;
		}
		if (totalPages > 0 && page > totalPages) {
			page = totalPages;
		}
		int startNum = (page - 1) * pageSize;

		List<ProductListDto> boughtList = total > 0
				? productService.findBoughtListByBuyerNo(userNo, startNum, pageSize)
				: new java.util.ArrayList<>();

		model.addAttribute("boughtList", boughtList);
		model.addAttribute("totalBought", total);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		return "boughtList";
	}

	// 받은 후기 전체보기
	@GetMapping("/mypage/reviews")
	public String myReviewsPage(@RequestParam(value = "page", defaultValue = "1") int page,
			HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		int userNo = loginUser.getUserNo();
		List<ReviewDto> all = reviewService.findReviewsByUser(userNo);

		int pageSize = 10;
		int total = all.size();
		int totalPages = (total + pageSize - 1) / pageSize;
		if (page < 1) {
			page = 1;
		}
		if (totalPages > 0 && page > totalPages) {
			page = totalPages;
		}
		int start = (page - 1) * pageSize;
		int end = Math.min(start + pageSize, total);
		List<ReviewDto> paged = (start < total) ? all.subList(start, end) : new java.util.ArrayList<>();

		model.addAttribute("reviews", paged);
		model.addAttribute("totalMyReviews", total);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		return "myReviews";
	}

	// 유저 페이지
	@GetMapping("/users/search/{userNo}")
	public String userPage(@PathVariable("userNo") int userNo,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "productPage", defaultValue = "1") int productPage,
			@RequestParam(value = "productNo", required = false) Integer productNo,
			@SessionAttribute(name = "loginUser", required = false) User loginUser, Model model) {
		int loginUserNo = (loginUser != null) ? loginUser.getUserNo() : 0;
		User user = userService.getUserByNo(userNo);

		// 후기 작성 대상 상품이 지정된 경우, 같은 유저가 이미 작성했는지 검사
		boolean alreadyReviewed = false;
		if (productNo != null && loginUser != null) {
			alreadyReviewed = reviewService.existsReview(productNo, loginUser.getUserNo());
		}
		model.addAttribute("alreadyReviewed", alreadyReviewed);
		model.addAttribute("selectedProductNo", productNo);

		// 판매 상품 페이징 (한 페이지 8개)
		int productPageSize = 8;
		int productStartNum = (productPage - 1) * productPageSize;
		List<ProductListDto> myProducts = productService.findBySeller(userNo, productStartNum, productPageSize);
		int totalMyProducts = productService.countBySeller(userNo);
		int totalProductPages = (totalMyProducts + productPageSize - 1) / productPageSize;

		// 프로필 이미지
		List<Image> profileImages = imageService.getImages("user", userNo);
		Image profileImage = profileImages.isEmpty() ? null : profileImages.get(0);

		List<ReviewDto> allReviews = reviewService.findReviewsByUser(userNo);

		// 후기 페이징
		int pageSize = 5;
		int totalReviews = allReviews.size();
		int totalPages = (totalReviews + pageSize - 1) / pageSize;
		int start = (page - 1) * pageSize;
		int end = Math.min(start + pageSize, totalReviews);

		List<ReviewDto> pagedReviews = (start < totalReviews) ? allReviews.subList(start, end)
				: new java.util.ArrayList<>();

		model.addAttribute("user", user);
		model.addAttribute("myProducts", myProducts);
		model.addAttribute("totalMyProducts", totalMyProducts);
		model.addAttribute("currentProductPage", productPage);
		model.addAttribute("totalProductPages", totalProductPages);
		model.addAttribute("profileImage", profileImage);
		model.addAttribute("reviews", pagedReviews);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);

		return "userPage";
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


	// 회원 정보 수정 처리 403 Forbidden 에러 방지를 위해 @PutMapping 대신 @PostMapping을 사용
	@PostMapping("/users/edit")
	public String submitEditUserForm(@ModelAttribute("editUser") User editUser, HttpSession session) {

		if (editUser.getLatitude() != null) {
			editUser.setVerifiedAt(new java.sql.Timestamp(System.currentTimeMillis()));
		}

		userService.setEditUser(editUser);
		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser != null) {

			if (loginUser.getUserNo() == editUser.getUserNo()) {
				User updatedUser = userService.getUserByNo(editUser.getUserNo());
				session.setAttribute("loginUser", updatedUser);
			}
		}
		return "redirect:/mypage";
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
	
	// 카카오 로그인
	@GetMapping("/login/kakao/callback")
	public String kakaoCallback(@RequestParam("code") String code, HttpSession session) {
	    try {
	        // 토큰 받기
	        String accessToken = kakaoService.getAccessToken(code);

	        // 사용자 정보 받기
	        Map<String, Object> userInfo = kakaoService.getUserInfo(accessToken);
	        System.out.println("=== 카카오 userInfo: " + userInfo);

	        String kakaoId = String.valueOf(userInfo.get("id"));
	        String userId = "kakao_" + kakaoId;

	        Map<String, Object> properties = (Map<String, Object>) userInfo.get("properties");
	        String nickname = properties != null ? (String) properties.get("nickname") : "카카오유저";

	        // DB 조회 및 자동 가입
	        User user = userService.findByEmail(userId);
	        if (user == null) {
	            user = new User();
	            user.setUserId(userId);
	            user.setUserNickName(nickname);
	            userService.registerOAuthUser(user);
	            user = userService.findByEmail(userId);
	        }

	        // 세션 저장
	        session.setAttribute("loginUser", user);
	        
	        List<GrantedAuthority> authorities = Collections.singletonList(
	        	    new SimpleGrantedAuthority("ROLE_USER")
	        	);
	        	UsernamePasswordAuthenticationToken authToken = 
	        	    new UsernamePasswordAuthenticationToken(user.getUserId(), null, authorities);
	        	SecurityContextHolder.getContext().setAuthentication(authToken);
	        	
	        	session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
	        	
	        return "redirect:/home";

	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/login?error=true";
	    }
	}
}
