package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Comment;
import com.team404.repository.CommentRepository;

@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	private CommentRepository repository;

	// 댓글 조회
	@Override
	public List<Comment> getComments(int boardNo) {
		return repository.findByBoard(boardNo);
	}

	// 댓글 작성
	@Override
	public void addComment(Comment comment) {
		repository.insert(comment);
	}

	// 댓글 수정
	@Override
	public void updateComment(Comment comment) {
		repository.update(comment);
	}

	// 댓글 삭제
	@Override
	public void deleteComment(int commentNo) {
		repository.delete(commentNo);
	}
}