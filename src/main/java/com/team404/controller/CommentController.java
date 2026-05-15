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

import com.team404.domain.BoardDetailDto;
import com.team404.domain.Comment;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.User;
import com.team404.service.BoardService;
import com.team404.service.CommentService;
import com.team404.service.NotificationService;
import com.team404.service.ProductService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CommentController {

	@Autowired
	private CommentService commentService;

	@Autowired

	private ProductService productService;

	private BoardService boardService;

	@Autowired
	private NotificationService notificationService;

	// AJAX: 특정 상품의 댓글 목록을 JSON으로 돌려줌
	@GetMapping("/comment/list")
	@ResponseBody
	public List<Comment> list(@RequestParam("boardNo") int boardNo) {
		return commentService.getComments(boardNo);
	}

	// 댓글 등록 (일반 폼 submit). returnTo=board 이면 게시판으로 돌아감
	@PostMapping("/comment/add")
	public String add(@RequestParam("boardNo") int boardNo, @RequestParam("content") String content,

			@RequestParam("targetType") String targetType,

			@RequestParam(value = "returnTo", required = false) String returnTo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		Comment c = new Comment();
		c.setBoardNo(boardNo);
		c.setContent(content);
		c.setAuthorNo(loginUser.getUserNo());
		c.setTargetType(targetType);

		commentService.addComment(c);

// 댓글 알림 (게시글, 상품게시글 작성자에게 전송)
		try {
			int boardAuthorNo;
			if ("board".equals(returnTo)) { // 문의 게시판 댓글 -> board 테이블에서 작성자 조회
				BoardDetailDto board = boardService.findBoardDetail(boardNo);
				boardAuthorNo = board.getAuthorNo();
				notificationService.notifyComment(loginUser.getUserNo(), boardAuthorNo, boardNo, "board",
						loginUser.getUserNickName());
			} else { // 상품 삭제 댓글 -> product 테이블에서 판매자 조회
				ProductDetailDto product = productService.findProductDetail(boardNo);
				boardAuthorNo = product.getSellerNo();
				notificationService.notifyComment(loginUser.getUserNo(), boardAuthorNo, boardNo, "product",
						loginUser.getUserNickName());
			}
		} catch (Exception e) {
			// 알림 실패가 댓글 등록 막지 않게 예외 삼킴
		}

		return "board".equals(returnTo) ? "redirect:/boardList/" + boardNo : "redirect:/product/" + boardNo;

	}

	@GetMapping("/comment/product")
	@ResponseBody
	public List<Comment> productComments(@RequestParam("productNo") int productNo) {
		return commentService.getProductComments(productNo);
	}

	@GetMapping("/comment/board")
	@ResponseBody
	public List<Comment> boardComments(@RequestParam("boardNo") int boardNo) {
		return commentService.getComments(boardNo);
	}

// 댓글 수정 폼 — 작성자 본인만 진입 가능 (관리자도 수정 불가)

	@GetMapping("/comment/{commentNo}/edit")
	public String editForm(@PathVariable("commentNo") int commentNo,
			@RequestParam(value = "returnTo", required = false) String returnTo, Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		Comment comment = commentService.getComment(commentNo);
		String back = "board".equals(returnTo) ? "redirect:/boardList/" + comment.getBoardNo()
				: "redirect:/product/" + comment.getBoardNo();
		if (comment.getAuthorNo() != loginUser.getUserNo()) {
			return back;
		}
		model.addAttribute("comment", comment);
		model.addAttribute("returnTo", returnTo);
		return "commentUpdateForm";
	}

	// 댓글 수정 처리 — 작성자 본인만
	@PostMapping("/comment/{commentNo}/edit")
	public String edit(@PathVariable("commentNo") int commentNo, @RequestParam("content") String content,
			@RequestParam("boardNo") int boardNo, @RequestParam(value = "returnTo", required = false) String returnTo,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		String back = "board".equals(returnTo) ? "redirect:/boardList/" + boardNo : "redirect:/product/" + boardNo;
		Comment comment = commentService.getComment(commentNo);
		if (comment.getAuthorNo() != loginUser.getUserNo()) {
			return back;
		}
		comment.setContent(content);
		commentService.updateComment(comment);
		return back;
	}

	// 댓글 삭제 처리 — 본인 또는 관리자. returnTo=board 이면 게시판으로 돌아감
	@PostMapping("/comment/{commentNo}/delete")
	public String delete(@PathVariable("commentNo") int commentNo, @RequestParam("boardNo") int boardNo,
			@RequestParam(value = "returnTo", required = false) String returnTo, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		String back = "board".equals(returnTo) ? "redirect:/boardList/" + boardNo : "redirect:/product/" + boardNo;
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
