package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.Rangking;

@Repository
public class RankingRepositoryImpl implements RankingRepository {

	@Autowired
	private JdbcTemplate template;

	@Override
	public Rangking getTopSeller() {
		String SQL = "SELECT o.seller_no AS memberNo, u.nickname AS nickname, "
				+ "SUM(p.price) AS totalAmount "
				+ "FROM orders o "
				+ "JOIN product p ON p.product_no = o.product_no "
				+ "JOIN users u ON u.user_no = o.seller_no "
				+ "WHERE p.trade_status = '완료' "
				+ "AND DATE_FORMAT(o.created_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') "
				+ "GROUP BY o.seller_no, u.nickname "
				+ "ORDER BY totalAmount DESC LIMIT 1";

		List<Rangking> list = template.query(SQL, (rs, rowNum) -> {
			Rangking r = new Rangking();
			r.setMemberNo(rs.getInt("memberNo"));
			r.setNickname(rs.getString("nickname"));
			r.setTotalAmount(rs.getLong("totalAmount"));
			return r;
		});

		return list.isEmpty() ? null : list.get(0);
	}

	@Override
	public Rangking getTopSpender() {
		String SQL = "SELECT o.buyer_no AS memberNo, u.nickname AS nickname, "
				+ "SUM(p.price) AS totalAmount "
				+ "FROM orders o "
				+ "JOIN product p ON p.product_no = o.product_no "
				+ "JOIN users u ON u.user_no = o.buyer_no "
				+ "WHERE p.trade_status = '완료' "
				+ "AND DATE_FORMAT(o.created_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') "
				+ "GROUP BY o.buyer_no, u.nickname "
				+ "ORDER BY totalAmount DESC LIMIT 1";

		List<Rangking> list = template.query(SQL, (rs, rowNum) -> {
			Rangking r = new Rangking();
			r.setMemberNo(rs.getInt("memberNo"));
			r.setNickname(rs.getString("nickname"));
			r.setTotalAmount(rs.getLong("totalAmount"));
			return r;
		});

		return list.isEmpty() ? null : list.get(0);
	}
	
	// 테스트용

	@Override
	public void insertTestData() {
		template.update("INSERT INTO product(name, category, price, description, trade_status, created_time) "
				+ "VALUES('테스트상품A', '전자기기', 500000, '판매왕 테스트용', '완료', NOW())");
		int productNoA = template.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);

		template.update("INSERT INTO product(name, category, price, description, trade_status, created_time) "
				+ "VALUES('테스트상품B', '의류', 300000, '소비왕 테스트용', '완료', NOW())");
		int productNoB = template.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);

		template.update("INSERT INTO orders(product_no, seller_no, buyer_no, created_time) "
				+ "VALUES(?, 1200990, 3, NOW())", productNoA);
		template.update("INSERT INTO orders(product_no, seller_no, buyer_no, created_time) "
				+ "VALUES(?, 1200990, 3, NOW())", productNoB);
	}
}
