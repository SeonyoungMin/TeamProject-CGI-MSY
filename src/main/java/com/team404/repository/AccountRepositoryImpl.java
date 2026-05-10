package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.Account;

@Repository
public class AccountRepositoryImpl implements AccountRepository {

	@Autowired
	private JdbcTemplate template;

	@Override
	public List<Account> findAllByUser(int userNo, int startNum, int limit) {
		String SQL = "select o.order_no, p.name as productName, o.price, o.created_time, o.memo, u.nickname as partnerNickname, 'SELL' as type "
				+ "from orders o " + "join product p on p.product_no = o.product_no "
				+ "join users u on u.user_no = o.buyer_no "
				+ "where o.seller_no = ? and o.order_status = 'DONE' "
				
				+ "UNION ALL "
				+ "select o.order_no, p.name as productName, o.price, o.created_time, "
				+ "o.memo, u.nickname as partnerNickname, 'BUY' as type "
				+ "from orders o "
				+ "join product p on p.product_no = o.product_no "
				+ "join users u on u.user_no = o.seller_no "
				+ "where o.buyer_no = ? and o.order_status = 'DONE' "
				
				+ "order by created_time desc "
				+ "limit ?, ?";
		return template.query(SQL, new AccountRowMapper(), userNo, userNo, startNum, limit);
	}

	// 목록조회 페이징용
	public int countAllByBuyer(int userNo) {
		String SQL = "select count(*) from orders where (buyer_no = ? or seller_no = ?) and order_status = 'DONE'";
		return template.queryForObject(SQL, Integer.class, userNo, userNo);
	}

	public void updateMemo(int orderNo, String memo) {
		String SQL = "update orders set memo = ? where order_no = ?";
		template.update(SQL, memo, orderNo);
	}

	public long getTotalBuy(int userNo) {
		String SQL = "select coalesce(sum(price), 0) from orders where buyer_no = ? and order_status = 'DONE'";
		return template.queryForObject(SQL, Long.class, userNo);
	}

	public long getTotalSell(int userNo) {
		String SQL = "select coalesce(sum(price), 0) from orders where seller_no = ? and order_status = 'DONE'";
		return template.queryForObject(SQL, Long.class, userNo);
	}

}
