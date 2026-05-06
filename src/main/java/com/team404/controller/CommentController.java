package com.team404.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.team404.domain.Comment;
import com.team404.service.CommentService;

@Controller
@RequestMapping("/comments")
public class CommentController {

	@Autowired
	private CommentService service;
	
	@GetMapping("/view")
	public String commentPage() {
	    return "comment"; // WEB-INF/views/comment.jsp 
	}

	// 댓글 목록 조회 (AJAX)
	@GetMapping
	@ResponseBody
	public List<Comment> list(@RequestParam("boardNo") int boardNo) {
		return service.getComments(boardNo);
	}

	// 댓글 작성 (@RequestBody로 JSON 수신)
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