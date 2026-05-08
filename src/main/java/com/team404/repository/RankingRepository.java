package com.team404.repository;

import com.team404.domain.Rangking;

public interface RankingRepository {

	Rangking getTopSeller();

	Rangking getTopSpender();

	void insertTestData();
}
