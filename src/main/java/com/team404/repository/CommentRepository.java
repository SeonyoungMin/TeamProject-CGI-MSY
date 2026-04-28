package com.team404.repository;

import java.util.List;

import com.team404.domain.Comment;

public interface CommentRepository {

	List<Comment> findByBoard(int boardNo);

	int insert(Comment c);

	int update(Comment c);

	int delete(int commentNo);

}
