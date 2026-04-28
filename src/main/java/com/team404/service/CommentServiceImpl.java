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

	@Override
	public List<Comment> findByBoard(int boardNo) {
		return repository.findByBoard(boardNo);

	}

	@Override
	public int insert(Comment c) {
		return repository.insert(c);
	}

	@Override
	public int update(Comment c) {
		return repository.update(c);
	}

	@Override
	public int delete(int commentNo) {
		return repository.delete(commentNo);
	}

}
