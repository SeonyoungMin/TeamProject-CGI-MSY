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

	List<BoardListDto> getBoardListByType(String boardType, int startNum, int limit);

	int getBoardCountByType(String boardType);

	// 문의, 자유만
	List<BoardListDto> findRecentAll(int startNum, int limit);

	// 공지사항 전용
	List<BoardListDto> findNoticeList(int startNum, int limit);

	// 공지사항전용
	int countNoticeAll();

	// 문의, 자유만
	int countRecentAll();

	// 상세 / 수정 / 삭제
	BoardDetailDto findBoardDetail(int boardNo);

	void updateBoard(Board board, int loginMemberNo);

	void deleteBoard(int boardNo, int loginMemberNo);

	// 관리자 권한 포함 수정/삭제
	void updateBoard(Board board, int loginMemberNo, boolean isAdmin);

	void deleteBoard(int boardNo, int loginMemberNo, boolean isAdmin);
}
