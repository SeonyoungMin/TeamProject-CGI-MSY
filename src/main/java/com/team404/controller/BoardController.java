package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.team404.domain.BoardListDto;
import com.team404.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;
	
	// 문의글 전체 목록 조회
	@GetMapping("/boardList")
	public String findAllInquiry(Model model) {
		List<BoardListDto> list = boardService.findAllInquiry();
		model.addAttribute("list", list);
		return "boardList";
	}
	
}
