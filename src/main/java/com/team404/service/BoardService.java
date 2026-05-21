package com.team404.service;

import java.util.List;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;

public interface BoardService {

	// 등록
	int registerBoard(Board board, int loginMemberNo);

	// 문의글 목록 / 개수
	List<BoardListDto> findAllInquiry(int startNum, int limit);
	int countAllInquiry();

	// 타입별 목록 / 개수
	List<BoardListDto> findAllByType(String boardType, int startNum, int limit);
	int countAllByType(String boardType);

	// 전체 통합 조회 (공지/문의/자유)
	List<BoardListDto> findRecentAll(int startNum, int limit);
	int countRecentAll();

	// 상세 / 수정 / 삭제
	BoardDetailDto findBoardDetail(int boardNo);
	void updateBoard(Board board, int loginMemberNo);
	void deleteBoard(int boardNo, int loginMemberNo);
}
