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

	@GetMapping("/users/new")
	public String getNewUserForm(@ModelAttribute("newUser") User newUser) {
		return "newUser";
	}

	@PostMapping("/users")
	public String submitNewUserForm(@ModelAttribute("newUser") User newUser, BindingResult bindingResult) {
		userService.setNewUser(newUser);
		return "redirect:/users/search";
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
		return "redirect:/users/" + editUser.getUserNo();
	}

	@DeleteMapping("/users/delete/{userNo}")
	public String submitDeleteUserForm(@PathVariable("userNo") int userNo) {
		userService.setDeleteUser(userNo);
		return "redirect:/users/search";
	}

}