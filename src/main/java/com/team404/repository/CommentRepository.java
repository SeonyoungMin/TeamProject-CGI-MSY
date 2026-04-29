package com.team404.repository;

import java.util.List;
import com.team404.domain.Comment;

public interface CommentRepository {

	// 댓글 목록
	List<Comment> findByBoard(int boardNo);

	// 댓글 작성
	int insert(Comment comment);

	// 댓글 수정
	int update(Comment comment);

	// 댓글 삭제
	int delete(int commentNo);
}