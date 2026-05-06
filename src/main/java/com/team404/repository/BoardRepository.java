package com.team404.repository;

import java.util.List;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;


public interface BoardRepository {

	//문의글 등록
	public int insertBoard(Board board);
	
	//문의글 전체 조회
	public List<BoardListDto> findAllBoard();
	
	//문의글 상세 조회 
	public BoardDetailDto findBoardDetail(int boardNo);
	
	//문의글 수정 (본인 확인 필요)
	public void updateBoard(Board board);
	public int findAuthorNo(int boardNo); //본인 확인용
	
	//문의글 삭제 (본인 확인 필요)
	public void deleteBoard(int boardNo);
}
