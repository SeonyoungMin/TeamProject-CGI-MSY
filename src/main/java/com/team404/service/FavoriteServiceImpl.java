package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Favorite;
import com.team404.repository.FavoriteRepository;

@Service
public class FavoriteServiceImpl implements FavoriteService {

	@Autowired
	private FavoriteRepository repository;

	@Override
	public void insertFavorite(int userNo, int boardNo) {
		repository.insertFavorite(userNo, boardNo);
	}

	@Override
	public void delete(int userNo, int boardNo) {
		repository.delete(userNo, boardNo);
	}

	@Override
	public boolean exists(int userNo, int boardNo) {
		return repository.exists(userNo, boardNo);
	}

	@Override
	public int countByBoard(int boardNo) {
		return repository.countByBoard(boardNo);
	}

	@Override
	public List<Integer> findBoardNosByUser(int userNo) {
		return repository.findBoardNosByUser(userNo);
	}

	@Override
	public Favorite findOne(int userNo, int boardNo) {
		return repository.findOne(userNo, boardNo);
	}

}
