package com.team404.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.team404.domain.Comment;
import com.team404.domain.User;
import com.team404.service.CommentService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/comments")
public class CommentController {

	@Autowired
	private CommentService service;

	private User getLoginUser(HttpSession session) {
		return (User) session.getAttribute("loginUser");
	}

	@GetMapping("/view")
	public String commentPage() {
		return "comment"; // WEB-INF/views/comment.jsp
	}

	// 댓글 목록 조회 (AJAX) — 비로그인도 조회 가능
	@GetMapping
	@ResponseBody
	public List<Comment> list(@RequestParam("boardNo") int boardNo) {
		return service.getComments(boardNo);
	}

	// 댓글 작성 — 로그인 필요
	@PostMapping
	@ResponseBody
	public void insert(@RequestBody Comment comment, HttpSession session, HttpServletResponse response)
			throws IOException {
		if (getLoginUser(session) == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "login required");
			return;
		}
		service.addComment(comment);
	}

	// 댓글 수정 — 로그인 필요
	@PutMapping("/{commentNo}")
	@ResponseBody
	public void update(@PathVariable("commentNo") int commentNo, @RequestBody Comment comment,
			HttpSession session, HttpServletResponse response) throws IOException {
		if (getLoginUser(session) == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "login required");
			return;
		}
		comment.setCommentNo(commentNo);
		service.updateComment(comment);
	}

	// 댓글 삭제 — 로그인 필요
	@DeleteMapping("/{commentNo}")
	@ResponseBody
	public void delete(@PathVariable("commentNo") int commentNo, HttpSession session, HttpServletResponse response)
			throws IOException {
		if (getLoginUser(session) == null) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "login required");
			return;
		}
		service.deleteComment(commentNo);
	}
}
