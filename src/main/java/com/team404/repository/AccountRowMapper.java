package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.Account;

public class AccountRowMapper implements RowMapper<Account> {
	public Account mapRow(ResultSet rs, int rowNum) throws SQLException {
	
		Account account = new Account();
		account.setOrderNo(rs.getInt("order_no"));

		account.setPrice(rs.getInt("price"));
		account.setCreatedTime(rs.getTimestamp("created_time"));
		account.setMemo(rs.getString("memo"));
		account.setProductName(rs.getString("productName"));
		account.setPartnerNickname(rs.getString("partnerNickname"));
		account.setType(rs.getString("type"));

		account.setPrice(rs.getLong("price"));
		account.setCreatedTime(rs.getTimestamp("created_time"));
		account.setMemo(rs.getString("memo"));

		
		return account;
	}
}
