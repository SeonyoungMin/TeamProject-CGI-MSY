package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;
import com.team404.repository.BoardRepository;

@Service
public class BoardServiceImpl implements BoardService{

	@Autowired
	private BoardRepository boardRepository;
	
	// 문의글 등록
	public void registerBoard(Board board, int loginMemberNo) {
		board.setAuthorNo(loginMemberNo);
		boardRepository.insertBoard(board);
	}
 
	// 문의글 전체목록 조회
	public List<BoardListDto> findAllInquiry() {
		return boardRepository.findAllBoard();
	}
 
	//  문의글 상세 조회
	public BoardDetailDto findBoardDetail(int boardNo) {
		return boardRepository.findBoardDetail(boardNo);
	}
 
	// 문의글 수정 (본인 확인)
	public void updateBoard(Board board, int loginMemberNo) {
		int authorNo = boardRepository.findAuthorNo(board.getBoardNo());
		 
		if (authorNo != loginMemberNo) {
			throw new RuntimeException("본인의 문의글만 수정할 수 있습니다.");
		}
		boardRepository.updateBoard(board);
	}
 
	// 문의글 삭제 (본인 확인)
	public void deleteBoard(int boardNo, int loginMemberNo) {
		int authorNo = boardRepository.findAuthorNo(boardNo);
		 
		if (authorNo != loginMemberNo) {
			throw new RuntimeException("본인의 문의글만 삭제할 수 있습니다.");
		}
		boardRepository.deleteBoard(boardNo);
	}
}
