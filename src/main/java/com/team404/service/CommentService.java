package com.team404.service;

import java.util.List;
import com.team404.domain.Comment;

public interface CommentService {

	public List<Comment> getProductComments(int productNo);

	public List<Comment> getComments(int boardNo);

	void addComment(Comment comment);

	void updateComment(Comment comment);

	void deleteComment(int commentNo);

	Comment getComment(int commentNo);
}