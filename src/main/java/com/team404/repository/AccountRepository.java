package com.team404.repository;

import java.util.List;

import com.team404.domain.Account;

public interface AccountRepository {

	//구매 완료 내역 목록 조회

	public List<Account> findAllByUser(int userNo, int startNum, int limit);
	
	//목록조회 페이징용
	public int countAllByBuyer(int userNo);
	
	//메모 수정
	public void updateMemo(int orderNo, String memo);
	
	//구매 지출 합계
	public long getTotalBuy(int userNo);
	
	//판매 수익 합계
	public long getTotalSell(int userNo);

	public List<Account> findAllByBuyer(int buyerNo, int startNum, int limit);


}
