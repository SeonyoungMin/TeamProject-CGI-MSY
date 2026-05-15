package com.team404.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrderRepositoryImpl implements OrderRepository {

	@Autowired
	private JdbcTemplate template;

	@Override
	public void updateProductStatus(int productNo, String status) {
		String SQL = "UPDATE product SET trade_status = ? WHERE product_no = ?";
		template.update(SQL, status, productNo);
	}

	@Override
	public void markProductAsSold(int productNo, int buyerNo) {
		String SQL = "UPDATE product SET trade_status = '완료', buyer_no = ? WHERE product_no = ?";
		template.update(SQL, buyerNo, productNo);
	}

	@Override
	public void insertOrder(int productNo, int sellerNo, int buyerNo, long price) {
		String SQL = "INSERT INTO orders (product_no, seller_no, buyer_no, price, order_status, created_time) "
				+ "VALUES (?, ?, ?, ?, '완료', NOW())";
		template.update(SQL, productNo, sellerNo, buyerNo, price);
	}

	@Override
	public void increaseSellCount(int userNo) {
		String SQL = "UPDATE users SET sell_count = sell_count + 1 WHERE user_no = ?";
		template.update(SQL, userNo);
	}

	@Override
	public void increaseBuyCount(int userNo) {
		String SQL = "UPDATE users SET buy_count = buy_count + 1 WHERE user_no = ?";
		template.update(SQL, userNo);
	}
}
