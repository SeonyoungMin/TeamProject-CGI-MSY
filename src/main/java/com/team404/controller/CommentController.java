package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.domain.Comment;
import com.team404.domain.User;
import com.team404.service.CommentService;

import jakarta.servlet.http.HttpSession;


@Controller
public class CommentController {

	@Autowired
	private CommentService commentService;

	// AJAX: 특정 상품의 댓글 목록을 JSON으로 돌려줌
	@GetMapping("/comment/list")
	@ResponseBody
	public List<Comment> list(@RequestParam("boardNo") int boardNo) {
		return commentService.getComments(boardNo);
	}

	// 댓글 등록 (일반 폼 submit). returnTo=board 이면 게시판으로 돌아감
	@PostMapping("/comment/add")
	public String add(@RequestParam("boardNo") int boardNo,
			@RequestParam("content") String content,
			@RequestParam(value = "returnTo", required = false) String returnTo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		Comment c = new Comment();
		c.setBoardNo(boardNo);
		c.setContent(content);
		c.setAuthorNo(loginUser.getUserNo());
		commentService.addComment(c);
		return "board".equals(returnTo)
				? "redirect:/boardList/" + boardNo
				: "redirect:/product/" + boardNo;
	}

	// 댓글 수정 폼 — 작성자 본인만 진입 가능
	@GetMapping("/comment/{commentNo}/edit")
	public String editForm(@PathVariable("commentNo") int commentNo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		Comment comment = commentService.getComment(commentNo);
		if (comment.getAuthorNo() != loginUser.getUserNo()) {
			return "redirect:/product/" + comment.getBoardNo();
		}
		model.addAttribute("comment", comment);
		return "commentUpdateForm";
	}

	// 댓글 수정 처리
	@PostMapping("/comment/{commentNo}/edit")
	public String edit(@PathVariable("commentNo") int commentNo,
			@RequestParam("content") String content,
			@RequestParam("boardNo") int boardNo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		Comment comment = commentService.getComment(commentNo);
		if (comment.getAuthorNo() != loginUser.getUserNo()) {
			return "redirect:/product/" + boardNo;
		}
		comment.setContent(content);
		commentService.updateComment(comment);
		return "redirect:/product/" + boardNo;
	}

	// 댓글 삭제 처리 — 본인 또는 관리자. returnTo=board 이면 게시판으로 돌아감
	@PostMapping("/comment/{commentNo}/delete")
	public String delete(@PathVariable("commentNo") int commentNo,
			@RequestParam("boardNo") int boardNo,
			@RequestParam(value = "returnTo", required = false) String returnTo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		String back = "board".equals(returnTo)
				? "redirect:/boardList/" + boardNo
				: "redirect:/product/" + boardNo;
		Comment comment = commentService.getComment(commentNo);
		boolean isAuthor = comment.getAuthorNo() == loginUser.getUserNo();
		boolean isAdmin = "ROLE_ADMIN".equals(loginUser.getUserRole());
		if (!isAuthor && !isAdmin) {
			return back;
		}
		commentService.deleteComment(commentNo);
		return back;
	}
}
