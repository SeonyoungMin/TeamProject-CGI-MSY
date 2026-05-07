package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;
import com.team404.service.BoardService;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;
	
	// 문의글 전체 목록 조회 --> 전체, 필터링 : 재활용
	@GetMapping("/boardList")
	public String getBoardList(@RequestParam(value="pageNum", defaultValue="1") int pageNum, @RequestParam(value="limit", defaultValue="10") int limit, Model model) {
		
		int startNum = limit * (pageNum-1);
		
		List<BoardListDto> list = boardService.findAllInquiry(startNum, limit);
		
		int totalNum = boardService.countAllInquiry();
		
		int totalPages = (totalNum % limit) == 0 ? totalNum / limit : (totalNum / limit) +1;
		
		model.addAttribute("list", list);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNum);
		return "boardList";
	}
	
	// 문의글 상세 조회
	@GetMapping("/boardList/{boardNo}")
	public String getBoard(@PathVariable("boardNo") int boardNo, Model model) {
		BoardDetailDto dto = boardService.findBoardDetail(boardNo);
		model.addAttribute("board", dto);
		return "boardDetail";
	}
	
	// 문의글 등록, 수정(modelAttribute) : 재활용
	// 등록 폼
	@GetMapping("/boardList/addForm")
	public String registerForm(@ModelAttribute("newBoard") Board board, HttpSession session, Model model) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
//		String loginNickname = (String) session.getAttribute("loginNickname");
//		
		int loginMemberNo = 1;
		String loginNickname = "가이니";
		model.addAttribute("authorNo", loginMemberNo);
		model.addAttribute("authorNickname", loginNickname);
		
		
		return "boardAddForm";
	}
	
	// 등록 처리
	@PostMapping("/board")
	public String registerBoard(@ModelAttribute Board board, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");

		int loginMemberNo = 1;
		board.setAuthorNo(loginMemberNo);
		boardService.registerBoard(board, loginMemberNo);
		return "redirect:/boardList";
	}
	
	// 수정 폼
	@GetMapping("/boardList/{boardNo}/edit")
	public String updateForm(@PathVariable("boardNo") int boardNo, HttpSession session, Model model) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
//		String loginNickname = (String) session.getAttribute("loginNickname");
//		
		int loginMemberNo = 1;
		String loginNickname = "가이니";
		model.addAttribute("authorNo", loginMemberNo);
		model.addAttribute("authorNickname", loginNickname);
		

		boardService.findBoardDetail(boardNo);
		
		return "boardEditForm";
	}
	
	//수정 처리
	@PutMapping("/board/{boardNo}")
	public String updateBoard(@PathVariable("boardNo") int boardNo, @ModelAttribute Board board, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");
		int loginMemberNo = 1;
		
		board.setBoardNo(boardNo);
		boardService.updateBoard(board, loginMemberNo);
		
		return "redirect:/board/" + boardNo;
	}
	
	//삭제
	@DeleteMapping("/board/{boardNo}")
	public String deleteBoard(@PathVariable("boardNo") int boardNo, HttpSession session) {
//		if (session.getAttribute("loginMemberNo") == null) {
//			return "redirect:/login";
//		}
//		int loginMemberNo = (int) session.getAttribute("loginMemberNo");

		int loginMemberNo = 1;
		boardService.deleteBoard(boardNo, loginMemberNo);
		
		return "redirect:/boardList";
	}
	
}
