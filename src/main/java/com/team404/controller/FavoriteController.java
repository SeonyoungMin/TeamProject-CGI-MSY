package com.team404.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.team404.service.FavoriteService;

@Controller
@RequestMapping("/favorite")
public class FavoriteController {

	@Autowired
	private FavoriteService service;

	// 1. 찜 페이지 이동 (GET /favorite)
	@GetMapping("")
	public String favoritePage() {
		return "favorite";
	}

	// 2. 내 찜 목록 데이터 반환 (GET /favorite/my)
	@GetMapping("/my")
	@ResponseBody
	public List<Integer> myFavorites(@RequestParam("userNo") int userNo) {

		return service.findBoardNosByUser(userNo);
	}

	// 3. 찜 추가 (POST /favorite/add)
	@PostMapping("/add")
	@ResponseBody
	public void addFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo) {
		service.insertFavorite(userNo, boardNo);
	}

	// 4. 찜 삭제 (POST 또는 DELETE /favorite/remove)
	@PostMapping("/remove")
	@ResponseBody
	public void removeFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo) {
		service.delete(userNo, boardNo);
	}
}