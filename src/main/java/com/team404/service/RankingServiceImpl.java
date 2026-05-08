package com.team404.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Rangking;
import com.team404.repository.RankingRepository;

@Service
public class RankingServiceImpl implements RankingService {

	@Autowired
	private RankingRepository rankingRepository;

	@Override
	public Rangking findSalesKing() {
		return rankingRepository.getTopSeller();
	}

	@Override
	public Rangking findSpendingKing() {
		return rankingRepository.getTopSpender();
	}

	@Override
	public void insertTestData() {
		rankingRepository.insertTestData();
	}
}
