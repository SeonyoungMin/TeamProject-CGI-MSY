package com.team404.service;

import java.util.List;

import com.team404.domain.Comment;

public interface CommentService {
	List<Comment> findByBoard(int boardNo);

	int insert(Comment c);

	int update(Comment c);

	int delete(int commentNo);
}
