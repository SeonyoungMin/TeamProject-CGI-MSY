package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class WaitlistRepositoryImpl implements WaitlistRepository {

	@Autowired
	private JdbcTemplate template;

	@Override
	public void insert(int productNo, int userNo) {
		String sql = "INSERT INTO product_waitlist (product_no, user_no) VALUES (?, ?)";
		try {
			template.update(sql, productNo, userNo);
		} catch (DuplicateKeyException ignore) {
			// 이미 신청한 경우 무시 (UNIQUE 위반)
		}
	}

	@Override
	public void delete(int productNo, int userNo) {
		String sql = "DELETE FROM product_waitlist WHERE product_no = ? AND user_no = ?";
		template.update(sql, productNo, userNo);
	}

	@Override
	public boolean exists(int productNo, int userNo) {
		String sql = "SELECT COUNT(*) FROM product_waitlist WHERE product_no = ? AND user_no = ?";
		Integer count = template.queryForObject(sql, Integer.class, productNo, userNo);
		return count != null && count > 0;
	}

	@Override
	public int countByProduct(int productNo) {
		String sql = "SELECT COUNT(*) FROM product_waitlist WHERE product_no = ?";
		Integer count = template.queryForObject(sql, Integer.class, productNo);
		return count != null ? count : 0;
	}

	@Override
	public List<Integer> findUserNosByProduct(int productNo) {
		String sql = "SELECT user_no FROM product_waitlist WHERE product_no = ?";
		return template.queryForList(sql, Integer.class, productNo);
	}

	@Override
	public int deleteAllByProduct(int productNo) {
		String sql = "DELETE FROM product_waitlist WHERE product_no = ?";
		return template.update(sql, productNo);
	}
}
