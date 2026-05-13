package com.team404.service;

import java.util.List;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;

public interface BoardService {

	// 등록
	void registerBoard(Board board, int loginMemberNo);

	// 문의글 목록 / 개수
	List<BoardListDto> findAllInquiry(int startNum, int limit);
	int countAllInquiry();

	// 타입별 목록 / 개수
	List<BoardListDto> findAllByType(String boardType, int startNum, int limit);
	int countAllByType(String boardType);

	// 전체 통합 조회 (홈 사이드바용)
	List<BoardListDto> findRecentAll(int startNum, int limit);

	// 상세 / 수정 / 삭제
	BoardDetailDto findBoardDetail(int boardNo);
	void updateBoard(Board board, int loginMemberNo);
	void deleteBoard(int boardNo, int loginMemberNo);
}
