package com.team404.service;

import java.util.List;

import com.team404.domain.Account;

public interface AccountService {
 
	public List<Account> findAllByBuyer(int orderNo, int startNum, int limit);
	
	public int countAllByBuyer(int buyerNo);
	
	public void updateMemo(int orderNo, String memo);
}
