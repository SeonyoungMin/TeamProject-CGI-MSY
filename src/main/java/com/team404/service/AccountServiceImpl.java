package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Account;
import com.team404.repository.AccountRepository;

@Service
public class AccountServiceImpl implements AccountService{
	
	@Autowired
	private AccountRepository accountRepository;
	
	public List<Account> findAllByBuyer(int buyerNo, int startNum, int limit) {
		return accountRepository.findAllByBuyer(buyerNo, startNum, limit);
	}
	
	public int countAllByBuyer(int buyerNo) {
		return accountRepository.countAllByBuyer(buyerNo);
	}
	
	public void updateMemo(int orderNo, String memo) {
		accountRepository.updateMemo(orderNo, memo);
	}

}
