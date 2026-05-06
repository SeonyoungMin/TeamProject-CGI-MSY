package com.team404.controller;

import java.util.List;

import javax.validation.Valid;

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

import com.team404.domain.SearchDTO;
import com.team404.domain.User;
import com.team404.exception.NoUserFoundException;
import com.team404.service.UserService;

@Controller
public class UserController {

	@Autowired
	UserService userService;

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
	public String loginPage() {
		return "login";
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
		// 최근 등록된 유저(상품) 리스트를 가져오는 서비스 메서드 호출
		// 현재 adminSearchUser를 활용하거나 별도의 최근 리스트 호출 메서드 사용
		SearchDTO mainSearch = new SearchDTO();
		List<User> recentUsers = userService.adminSearchUser(mainSearch);

		// main.jsp에서 사용될 'recentItems'라는 이름으로 데이터를 담습니다.
		model.addAttribute("recentItems", recentUsers);

		return "main"; // WEB-INF/views/main.jsp를 보여줍니다.
	}

}