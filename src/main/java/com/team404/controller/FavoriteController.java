package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.team404.service.FavoriteService;







//board기능과userNo기능이 병합했을때 쓰이는 API구조 url이 지금 테스트 jsp구조와 맞지 않음 , 테스트는 완료 상태 







@Controller
@RequestMapping("/favorite")
public class FavoriteController {

	@Autowired
	private FavoriteService service;

	// 찜 페이지
	@GetMapping
	public String favoritePage() {
		return "favorite";
	}

	// 찜 추가
	@PostMapping
	@ResponseBody
	public void addFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo) {

		service.insertFavorite(userNo, boardNo);
	}

	// 찜 삭제
	@DeleteMapping
	@ResponseBody
	public void removeFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo) {

		service.delete(userNo, boardNo);
	}

	// 찜 여부 확인
	@GetMapping("/check")
	@ResponseBody
	public boolean isFavorite(@RequestParam("userNo") int userNo, @RequestParam("boardNo") int boardNo) {

		return service.exists(userNo, boardNo);
	}

	// 게시글 찜 개수
	@GetMapping("/count")
	@ResponseBody
	public int count(@RequestParam("boardNo") int boardNo) {
		return service.countByBoard(boardNo);
	}

	// 내 찜 목록
	@GetMapping("/my")
	@ResponseBody
	public List<Integer> myFavorites(@RequestParam("userNo") int userNo) {
		return service.findBoardNosByUser(userNo);
	}
}