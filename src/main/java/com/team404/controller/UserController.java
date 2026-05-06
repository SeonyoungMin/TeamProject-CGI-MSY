package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.SearchDTO;
import com.team404.domain.User;
import com.team404.exception.NoUserFoundException;
import com.team404.service.ProductService;
import com.team404.service.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class UserController {

	@Autowired
	UserService userService;
	@Autowired
	private ProductService productService;

	@GetMapping("/users/search")
	public String getUsersBySearch(@ModelAttribute("searchDTO") SearchDTO searchDTO, Model model) {
		List<User> userBySearch = userService.adminSearchUser(searchDTO);
		model.addAttribute("users", userBySearch);
		return "users";
	}

	@GetMapping("/users/search/{userNo}")
	public String getUserByNo(@PathVariable("userNo") int userNo, Model model) {
		User userByNo = userService.getUserByNo(userNo);
		model.addAttribute("user", userByNo);
		return "user";
	}

	@ExceptionHandler(value = { NoUserFoundException.class })
	public String noUserFoundHandler(NoUserFoundException exception, Model model) {
		model.addAttribute("invalidUserNo", exception.getUserNo());
		return "noUserFound";
	}

	@GetMapping("/signup")
	public String getNewUserForm(@ModelAttribute("newUser") User newUser) {
		return "signup";
	}

	@PostMapping("/users")
	public String signup(@Valid @ModelAttribute User user, BindingResult bindingResult) {

		if (bindingResult.hasErrors()) {
			return "signup";
		}

		userService.setNewUser(user);
		return "redirect:/login";
	}

	@GetMapping("/login")
	public String loginPage(@RequestParam(value = "redirect", required = false) String redirect, Model model) {
		model.addAttribute("redirect", redirect); // 주소창에 있던 redirect 값을 JSP로 보냅니다.
		return "login";
	}

	// 로그인 처리
	@PostMapping("/login")
	public String loginProcess(@RequestParam("userId") String userId, @RequestParam("userPw") String userPw,
			@RequestParam(value = "redirect", required = false) String redirect, HttpSession session) {

		User user = userService.getUserById(userId);

		// 콘솔창
		System.out.println("찾은 유저 정보: " + user);
		if (user != null) {
			System.out.println("DB 비번: " + user.getUserPw());
			System.out.println("입력 비번: " + userPw);
		}

		if (user != null && user.getUserPw().equals(userPw)) {
			session.setAttribute("loginUser", user);
			if (redirect != null && !redirect.isEmpty()) {
				return "redirect:" + redirect;
			}
			return "redirect:/home";
		} else {
			System.out.println("로그인 조건 불일치로 실패 처리됨");
			return "redirect:/login?redirect=" + redirect;
		}
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}

	@GetMapping("/home")
	public String homePage(Model model) {
		// home.jsp에서 사용할 상품 리스트를 가져옴
		List<com.team404.domain.ProductListDto> productList = productService.findAll(0, 10);

		// 모델에 데이터를 담아 home.jsp로 전달
		model.addAttribute("productList", productList);

		return "home"; // WEB-INF/views/home.jsp를 호출
	}

	@GetMapping("/users/edit/{userNo}")
	public String getEditUserForm(@PathVariable("userNo") int userNo, Model model) {
		User userByNo = userService.getUserByNo(userNo);
		model.addAttribute("editUser", userByNo);
		return "editUser";
	}

	@PutMapping("/users/edit")
	public String submitEditUserForm(@ModelAttribute("editUser") User editUser) {
		userService.setEditUser(editUser);
		return "redirect:/users/search/" + editUser.getUserNo();
	}

	@DeleteMapping("/users/delete/{userNo}")
	public String submitDeleteUserForm(@PathVariable("userNo") int userNo) {
		userService.setDeleteUser(userNo);
		return "redirect:/users/search";
	}

	@GetMapping("/")
	public String mainPage(Model model) {
		// findAll(시작번호, 가져올개수)
		List<com.team404.domain.ProductListDto> productList = productService.findAll(0, 10);

		// main.jsp에서 <c:forEach items="${productList}">로 쓸 수 있게 담기
		model.addAttribute("productList", productList);

		return "main";
	}

	@GetMapping("/mypage")
	public String myPage(HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		return "myPage";
	}
}