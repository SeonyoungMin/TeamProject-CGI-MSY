package com.team404.service;

public interface WaitlistService {

	void add(int productNo, int userNo);

	void remove(int productNo, int userNo);

	boolean exists(int productNo, int userNo);

	int countByProduct(int productNo);

	// 상품이 다시 '판매중'으로 풀렸을 때 대기자 전원에게 알림 발송 + 대기 목록 비우기
	void notifyBackOnSaleAndClear(int productNo);
}
