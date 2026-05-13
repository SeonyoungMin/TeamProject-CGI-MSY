package com.team404.service;

import java.util.List;

import com.team404.domain.Account;

public interface AccountService {

	public List<Account> findAllByBuyer(int userNo, int startNum, int limit);

	public int countAllByBuyer(int userNo);

	public void updateMemo(int orderNo, String memo);

	public long getTotalBuy(int userNo);

	public long getTotalSell(int userNo);

}
