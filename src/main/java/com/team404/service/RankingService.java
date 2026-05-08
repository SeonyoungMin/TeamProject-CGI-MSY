package com.team404.service;

import com.team404.domain.Rangking;

public interface RankingService {

	Rangking findSalesKing();

	Rangking findSpendingKing();

	void insertTestData();
}
