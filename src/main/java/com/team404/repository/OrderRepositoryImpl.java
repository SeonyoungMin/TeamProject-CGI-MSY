package com.team404.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrderRepositoryImpl implements OrderRepository {

	@Autowired
	private JdbcTemplate template;

	// 상품의 거래 상태를 변경하기
	@Override
	public void updateProductStatus(int productNo, String status) {
		String SQL = "UPDATE product SET trade_status = ? WHERE product_no = ?"; // 상태 수정 쿼리
		template.update(SQL, status, productNo); // DB에 반영
	}

	// 새로운 주문 내역 저장하기
	@Override
	public void insertOrder(int productNo, int sellerNo, int buyerNo) {
		String SQL = "INSERT INTO orders (product_no, seller_no, buyer_no, created_time) " // 주문 추가 쿼리
				+ "VALUES (?, ?, ?, NOW())"; // 현재 시간으로 저장
		template.update(SQL, productNo, sellerNo, buyerNo); // DB에 반영
	}
}
