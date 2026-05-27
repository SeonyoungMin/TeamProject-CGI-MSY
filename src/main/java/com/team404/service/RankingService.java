package com.team404.service;


import java.util.List;

import com.team404.domain.Rangking;

public interface RankingService {

	Rangking findSalesKing();

	Rangking findSpendingKing();

	// 이달의 판매왕 상위 N명
	List<Rangking> findTopSellers(int limit);

	// 이달의 소비왕 상위 N명
	List<Rangking> findTopBuyers(int limit);

}