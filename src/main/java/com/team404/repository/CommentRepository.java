package com.team404.repository;

import java.util.List;
import com.team404.domain.Comment;

public interface CommentRepository {

	// 보드용 목록 조회
	List<Comment> findByBoard(int boardNo);

	// 게시글용 목록 조회
	List<Comment> findByProduct(int productNo);

	// 댓글 작성
	int insert(Comment comment);

	// 댓글 수정
	int update(Comment comment);

	// 댓글 삭제
	int delete(int commentNo);

	Comment findByCommentNo(int commentNo);
}