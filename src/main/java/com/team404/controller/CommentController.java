package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.team404.domain.Comment;
import com.team404.service.CommentService;

@Controller
@RequestMapping("/comment")
public class CommentController {

	@Autowired
	private CommentService service;

	// 댓글 목록
	@GetMapping("/list/{boardNo}")
	@ResponseBody
	public List<Comment> list(@PathVariable("boardNo") int boardNo) {
		return service.findByBoard(boardNo);
	}

	// 댓글 작성
	@PostMapping("/insert")
	@ResponseBody
	public String insert(Comment comment) {
		return service.insert(comment) > 0 ? "success" : "fail";
	}

	// 댓글 삭제
	@PostMapping("/delete/{commentNo}")
	@ResponseBody
	public String delete(@PathVariable("boardNo") int commentNo) {
		return service.delete(commentNo) > 0 ? "success" : "fail";
	}

	// 댓글 수정 (나중용)
	@PostMapping("/update")
	@ResponseBody
	public String update(Comment comment) {
		return service.update(comment) > 0 ? "success" : "fail";
	}
}