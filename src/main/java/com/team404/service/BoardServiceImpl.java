package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;
import com.team404.repository.BoardRepository;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardRepository boardRepository;

	// 등록
	public int registerBoard(Board board, int loginMemberNo) {
		board.setAuthorNo(loginMemberNo);
		return boardRepository.insertBoard(board);
	}

	// 문의글 목록 / 개수
	public List<BoardListDto> findAllInquiry(int startNum, int limit) {
		return boardRepository.findAllBoard(startNum, limit);
	}

	public int countAllInquiry() {
		return boardRepository.countAllBoard();
	}

	// 타입별 목록 / 개수
	public List<BoardListDto> findAllByType(String boardType, int startNum, int limit) {
		return boardRepository.findByType(boardType, startNum, limit);
	}

	public int countAllByType(String boardType) {
		return boardRepository.countByType(boardType);
	}

	// 전체 통합 조회
	public List<BoardListDto> findRecentAll(int startNum, int limit) {
		return boardRepository.findRecentAll(startNum, limit);
	}

	@Override
	public List<BoardListDto> findNoticeList(int startNum, int limit) {
		return boardRepository.findNoticeList(startNum, limit);
	}

	@Override
	public int countNoticeAll() {
		return boardRepository.countNoticeAll();
	}

	@Override
	public List<BoardListDto> getBoardListByType(String boardType, int startNum, int limit) {
		if ("notice".equals(boardType)) {
			return boardRepository.findNoticeList(startNum, limit);
		} else if ("free".equals(boardType)) {
			return boardRepository.findByType("free", startNum, limit);
		} else {
			// inquiry(문의) 또는 올바르지 않은 값이 들어왔을 때 기본값 처리
			return boardRepository.findByType("inquiry", startNum, limit);
		}
	}

	@Override
	public int getBoardCountByType(String boardType) {
		if ("notice".equals(boardType)) {
			return boardRepository.countNoticeAll();
		} else if ("free".equals(boardType)) {
			return boardRepository.countByType("free");
		} else {
			return boardRepository.countByType("inquiry");
		}
	}

	public int countRecentAll() {
		return boardRepository.countRecentAll();
	}

	// 상세
	public BoardDetailDto findBoardDetail(int boardNo) {
		return boardRepository.findBoardDetail(boardNo);
	}

	// 수정 (본인 확인)
	public void updateBoard(Board board, int loginMemberNo) {
		updateBoard(board, loginMemberNo, false);
	}

	// 삭제 (본인 확인)
	public void deleteBoard(int boardNo, int loginMemberNo) {
		deleteBoard(boardNo, loginMemberNo, false);
	}

	// 수정 (관리자는 본인글이 아니어도 가능)
	@Override
	public void updateBoard(Board board, int loginMemberNo, boolean isAdmin) {
		int authorNo = boardRepository.findAuthorNo(board.getBoardNo());
		if (!isAdmin && authorNo != loginMemberNo) {
			throw new RuntimeException("본인의 글만 수정할 수 있습니다.");
		}
		boardRepository.updateBoard(board);
	}

	// 삭제 (관리자는 본인글이 아니어도 가능)
	@Override
	public void deleteBoard(int boardNo, int loginMemberNo, boolean isAdmin) {
		int authorNo = boardRepository.findAuthorNo(boardNo);
		if (!isAdmin && authorNo != loginMemberNo) {
			throw new RuntimeException("본인의 글만 삭제할 수 있습니다.");
		}
		boardRepository.deleteBoard(boardNo);
	}
}
