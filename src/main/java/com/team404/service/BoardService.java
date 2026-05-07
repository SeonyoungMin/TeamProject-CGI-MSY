package com.team404.service;
 
import java.util.List;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;

public interface BoardService {
 
	// 문의글 등록
	public void registerBoard(Board board, int loginMemberNo);
 
	// 문의글 전체목록 조회
	public List<BoardListDto> findAllInquiry(int startNum, int limit);
	
	// 전체 조회 페이징
	public int countAllInquiry();
 
	//  문의글 상세 조회
	public BoardDetailDto findBoardDetail(int boardNo);
 
	// 문의글 수정 (본인 확인)
	public void updateBoard(Board board, int loginMemberNo);
 
	// 문의글 삭제 (본인 확인)
	public void deleteBoard(int boardNo, int loginMemberNo);

}