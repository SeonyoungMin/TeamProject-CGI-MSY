package com.team404.repository;

import java.util.List;

import com.team404.domain.Rangking;

public interface RankingRepository {

	List<Rangking> getAllMonthlySales();

	public List<Rangking> getAllMonthlySpendings();

	// 이달의 판매왕 상위 N명
	List<Rangking> getTopSellers(int limit);

	// 이달의 소비왕 상위 N명
	List<Rangking> getTopBuyers(int limit);
}
