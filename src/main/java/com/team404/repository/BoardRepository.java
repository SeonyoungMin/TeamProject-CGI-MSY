package com.team404.repository;

import java.util.List;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;

public interface BoardRepository {

	// 게시글 등록
	int insertBoard(Board board);

	// 문의글 목록 / 개수
	List<BoardListDto> findAllBoard(int startNum, int limit);

	int countAllBoard();

	// 타입별 목록 / 개수
	List<BoardListDto> findByType(String boardType, int startNum, int limit);

	int countByType(String boardType);

	// 전체 게시글 통합 조회
	List<BoardListDto> findRecentAll(int startNum, int limit);

	// 공지사항 목록 전용
	List<BoardListDto> findNoticeList(int startNum, int limit);

	// 공지사항 전용
	int countNoticeAll();

	int countRecentAll();

	// 상세 조회
	BoardDetailDto findBoardDetail(int boardNo);

	// 수정 / 삭제
	void updateBoard(Board board);

	void deleteBoard(int boardNo);

	// 작성자 번호 (본인 확인용)
	int findAuthorNo(int boardNo);

}
