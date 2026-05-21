package com.team404.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
		List<Rangking> list = rankingRepository.getAllMonthlySales(); // 판매 기록들 가져오기
		return calculateKing(list); // 계산 로직으로 넘기기
	}

	@Override
	public Rangking findSpendingKing() {
		List<Rangking> list = rankingRepository.getAllMonthlySpendings(); // 구매 기록들 가져오기
		return calculateKing(list); // 계산 로직으로 넘기기
	}

	@Override
	public List<Rangking> findTopSellers(int limit) {
		return rankingRepository.getTopSellers(limit);
	}

	@Override
	public List<Rangking> findTopBuyers(int limit) {
		return rankingRepository.getTopBuyers(limit);
	}

	private Rangking calculateKing(List<Rangking> list) {
		if (list.isEmpty())
			return null; // 리스트 비어있으면 빈값 돌려주기

		// 회원별로 건수를 합치기 위한 지도 만들기
		Map<Integer, Rangking> map = new HashMap<>();
		for (Rangking r : list) { // 리스트 처음부터 끝까지 돌면서
			int no = r.getMemberNo(); // 회원번호 꺼내기
			if (map.containsKey(no)) { // 지도에 이미 이 회원이 있다면
				Rangking e = map.get(no); // 지도에서 꺼내서
				e.setTradeCount(e.getTradeCount() + 1); // 건수만 1 더하기
			} else { // 처음 보는 회원이면
				map.put(no, r); // 지도에 새로 등록
			}
		}

		// 누가 제일 많이 팔았는지
		Rangking king = null; // 왕 찾기
		long maxCount = -1; // 최고 점수 비교용

		for (Rangking r : map.values()) { // 지도 다 뒤져서
			if (r.getTradeCount() > maxCount) { // 더 높은 건수 발견하면
				maxCount = r.getTradeCount(); // 점수 갈아치움
				king = r; // 왕 바꾸기
			}
		}

		return king; // 최종왕 선정

	}
}
