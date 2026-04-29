package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.team404.domain.Comment;
import com.team404.service.CommentService;




// board기능과 병합했을때 쓰이는 API구조 url이 지금 테스트 jsp구조와 맞지 않음 , 테스트는 완료 상태 



@Controller
@RequestMapping("/comments")
public class CommentController {

	@Autowired
	private CommentService service;

	// 댓글 목록 (게시글 기준)
	@GetMapping
	@ResponseBody
	public List<Comment> list(@RequestParam("boardNo") int boardNo) {
		return service.getComments(boardNo);
	}

	// 댓글 작성
	@PostMapping
	@ResponseBody
	public void insert(@RequestBody Comment comment) {
		service.addComment(comment);
	}

	// 댓글 수정
	@PutMapping("/{commentNo}")
	@ResponseBody
	public void update(@PathVariable("commentNo") int commentNo, @RequestBody Comment comment) {

		comment.setCommentNo(commentNo);
		service.updateComment(comment);
	}

	// 댓글 삭제
	@DeleteMapping("/{commentNo}")
	@ResponseBody
	public void delete(@PathVariable("commentNo") int commentNo) {
		service.deleteComment(commentNo);
	}
}