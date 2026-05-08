package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.Account;

@Repository
public class AccountRepositoryImpl implements AccountRepository{
	
	@Autowired
	private JdbcTemplate template;
	
	@Override
	public List<Account> findAllByBuyer(int buyerNo, int startNum, int limit) {
		String SQL = "select o.order_no, o.price, o.created_time, o.memo, " + "p.name as productName " + "from orders o " 
	+ "join product p on p.product_no = o.product_no where o.buyer_no = ? and o.order_status = 'DONE' order by o.created_time desc limit ?, ?"; 
		return template.query(SQL, new AccountRowMapper(), buyerNo, startNum, limit);
	}
	
	//목록조회 페이징용
	public int countAllByBuyer(int buyerNo) {
		String SQL = "select count(*) from orders where buyer_no = ? and order_status = 'DONE'";
		return template.queryForObject(SQL, Integer.class, buyerNo);
	}

	public void updateMemo(int orderNo, String memo) {
		String SQL = "update orders set memo = ? where order_no";
		template.update(SQL, memo, orderNo);
	}

}
