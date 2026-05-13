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
	public void insertOrder(int productNo, int sellerNo, int buyerNo, long price) {
		String SQL = "INSERT INTO orders (product_no, seller_no, buyer_no, price, order_status, created_time) "
				+ "VALUES (?, ?, ?, ?, '완료', NOW())";
		template.update(SQL, productNo, sellerNo, buyerNo, price);
	}
}
