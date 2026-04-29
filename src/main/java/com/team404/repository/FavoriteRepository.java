package com.team404.repository;

import java.util.List;

import com.team404.domain.Favorite;

public interface FavoriteRepository {

	public void insertFavorite(int userNo, int boardNo);

	public void delete(int userNo, int boardNo);

	public boolean exists(int userNo, int boardNo);

	public int countByBoard(int boardNo);

	public List<Integer> findBoardNosByUser(int userNo);

	public Favorite findOne(int userNo, int boardNo);
}
