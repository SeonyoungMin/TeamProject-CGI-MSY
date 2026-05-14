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
import com.team404.domain.Comment;
import com.team404.domain.User;
import com.team404.service.BoardService;
import com.team404.service.CommentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;

	@Autowired
	private CommentService commentService;

	// 전체 게시글 목록 (공지/문의/자유)
	@GetMapping("/board/all")
	public String getAllBoardList(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "limit", defaultValue = "10") int limit, HttpSession session, Model model) {
		int startNum = limit * (pageNum - 1);
		List<BoardListDto> list = boardService.findRecentAll(startNum, limit);
		int totalNum = boardService.countRecentAll();
		int totalPages = (totalNum + limit - 1) / limit;

		model.addAttribute("list", list);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNum);
		model.addAttribute("boardType", "all");
		model.addAttribute("boardTitle", "전체 게시글");
		model.addAttribute("listUrl", "/board/all");
		model.addAttribute("canWrite", session.getAttribute("loginUser") != null);
		return "boardList";
	}

	// 문의 게시판 목록
	@GetMapping("/boardList")
	public String getBoardList(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "limit", defaultValue = "10") int limit, Model model) {
		setBoardListModel("inquiry", "문의 게시판", "/boardList", pageNum, limit, model);
		return "boardList";
	}

	// 공지사항 목록
	@GetMapping("/notice")
	public String getNoticeList(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "limit", defaultValue = "10") int limit, HttpSession session, Model model) {
		setBoardListModel("notice", "공지사항", "/notice", pageNum, limit, model);
		User loginUser = (User) session.getAttribute("loginUser");
		model.addAttribute("canWrite", loginUser != null && "ROLE_ADMIN".equals(loginUser.getUserRole()));
		return "boardList";
	}

	// 자유 게시판 목록
	@GetMapping("/freeBoard")
	public String getFreeBoardList(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "limit", defaultValue = "10") int limit, HttpSession session, Model model) {
		setBoardListModel("free", "자유게시판", "/freeBoard", pageNum, limit, model);
		model.addAttribute("canWrite", session.getAttribute("loginUser") != null);
		return "boardList";
	}

	// 공지 등록 폼 (관리자만)
	@GetMapping("/notice/addForm")
	public String noticeAddForm(@ModelAttribute("newBoard") Board board, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) {
			return "redirect:/notice";
		}
		model.addAttribute("authorNo", loginUser.getUserNo());
		model.addAttribute("authorNickname", loginUser.getUserNickName());
		model.addAttribute("boardType", "notice");
		model.addAttribute("boardTitle", "공지사항");
		model.addAttribute("cancelUrl", "/notice");
		model.addAttribute("isAdmin", true);
		return "boardAddForm";
	}

	// 자유 게시판 등록 폼
	@GetMapping("/freeBoard/addForm")
	public String freeBoardAddForm(@ModelAttribute("newBoard") Board board, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		model.addAttribute("authorNo", loginUser.getUserNo());
		model.addAttribute("authorNickname", loginUser.getUserNickName());
		model.addAttribute("boardType", "free");
		model.addAttribute("boardTitle", "자유게시판");
		model.addAttribute("cancelUrl", "/freeBoard");
		model.addAttribute("isAdmin", "ROLE_ADMIN".equals(loginUser.getUserRole()));
		return "boardAddForm";
	}

	// 글쓰기 폼 - 사용자가 타입 직접 선택
	@GetMapping("/board/write")
	public String boardWriteForm(@ModelAttribute("newBoard") Board board, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		model.addAttribute("authorNo", loginUser.getUserNo());
		model.addAttribute("authorNickname", loginUser.getUserNickName());
		model.addAttribute("boardTitle", "게시글");
		model.addAttribute("cancelUrl", "/home");
		model.addAttribute("typeChoice", true);
		model.addAttribute("isAdmin", "ROLE_ADMIN".equals(loginUser.getUserRole()));
		return "boardAddForm";
	}

	// 게시글 등록 처리 (타입에 따라 다른 목록으로 이동)
	@PostMapping("/board/type")
	public String registerTypedBoard(@ModelAttribute Board board, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		boolean isAdmin = "ROLE_ADMIN".equals(loginUser.getUserRole());
		String type = board.getBoardType();
		if ("notice".equals(type) && !isAdmin) {
			return "redirect:/notice";
		}
		// 관리자만 핀 고정 가능
		if (!isAdmin) {
			board.setPinned(false);
		}
		board.setAuthorNo(loginUser.getUserNo());
		boardService.registerBoard(board, loginUser.getUserNo());
		return "redirect:" + listUrlByType(type);
	}

	// 타입별 목록 모델 세팅
	private void setBoardListModel(String type, String pageTitle, String listUrl, int pageNum, int limit, Model model) {
		int startNum = limit * (pageNum - 1);


		List<BoardListDto> list = boardService.findAllByType(type, startNum, limit);
		int totalNum = boardService.countAllByType(type);

		int totalPages = (totalNum % limit) == 0 ? totalNum / limit : (totalNum / limit) + 1;

		model.addAttribute("list", list);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNum);
		model.addAttribute("boardType", type);
		model.addAttribute("boardTitle", pageTitle);
		model.addAttribute("listUrl", listUrl);
	}

	// 타입별 목록 URL
	private String listUrlByType(String type) {
		if ("notice".equals(type))
			return "/notice";
		if ("free".equals(type))
			return "/freeBoard";
		return "/boardList";
	}

	// 문의글 상세 조회
	@GetMapping("/boardList/{boardNo}")

	public String getBoard(@PathVariable("boardNo") int boardNo, Model model, HttpSession session) {
		BoardDetailDto dto = boardService.findBoardDetail(boardNo);
		model.addAttribute("board", dto);
		
		//댓글 목록
		List<Comment> comments = commentService.getComments(boardNo);
		model.addAttribute("comments", comments);
		
		//로그인 유저 확인
		User loginUser = (User) session.getAttribute("loginUser");
		model.addAttribute("loginUser", loginUser);
		
		return "boardDetail";
	}

	// 문의글 등록, 수정(modelAttribute) : 재활용
	// 문의글 등록 폼

	@GetMapping("/boardList/addForm")
	public String registerForm(@ModelAttribute("newBoard") Board board, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		model.addAttribute("authorNo", loginUser.getUserNo());
		model.addAttribute("authorNickname", loginUser.getUserNickName());
		model.addAttribute("boardType", "inquiry");
		model.addAttribute("boardTitle", "문의 게시판");
		model.addAttribute("cancelUrl", "/boardList");
		model.addAttribute("isAdmin", "ROLE_ADMIN".equals(loginUser.getUserRole()));
		return "boardAddForm";
	}

	// 등록 처리
	@PostMapping("/board")
	public String registerBoard(@ModelAttribute Board board, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		board.setAuthorNo(loginUser.getUserNo());
		boardService.registerBoard(board, loginUser.getUserNo());

		return "redirect:/boardList";
	}

	// 수정 폼
	@GetMapping("/boardList/{boardNo}/edit")
	public String updateForm(@PathVariable("boardNo") int boardNo, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		BoardDetailDto board = boardService.findBoardDetail(boardNo);
		boolean isAdmin = "ROLE_ADMIN".equals(loginUser.getUserRole());
		if (board.getAuthorNo() != loginUser.getUserNo() && !isAdmin) {
			return "redirect:/boardList/" + boardNo;
		}
		model.addAttribute("board", board);
		model.addAttribute("isAdmin", isAdmin);
		return "boardEditForm";
	}

	// 수정 처리
	@PutMapping("/boardList/{boardNo}")
	public String updateBoard(@PathVariable("boardNo") int boardNo, @ModelAttribute Board board,
			@RequestParam(value = "boardType", required = false) String boardType, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		BoardDetailDto existing = boardService.findBoardDetail(boardNo);
		if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) {
			board.setPinned(existing.isPinned());
		}
		if (boardType != null) {
			board.setBoardType(boardType);
		}
		board.setBoardNo(boardNo);
		boardService.updateBoard(board, loginUser.getUserNo());

		return "redirect:/boardList/" + boardNo;
	}

	// 삭제
	@DeleteMapping("/boardList/{boardNo}")
	public String deleteBoard(@PathVariable("boardNo") int boardNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}
		String type = boardService.findBoardDetail(boardNo).getBoardType();
		boardService.deleteBoard(boardNo, loginUser.getUserNo());
		return "redirect:" + listUrlByType(type);
	}

}
