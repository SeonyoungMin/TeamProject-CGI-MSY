package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.Waitlist;

public class WaitlistRowMapper implements RowMapper<Waitlist> {

	@Override
	public Waitlist mapRow(ResultSet rs, int rowNum) throws SQLException {
		Waitlist w = new Waitlist();
		w.setWaitlistNo(rs.getInt("waitlist_no"));
		w.setProductNo(rs.getInt("product_no"));
		w.setUserNo(rs.getInt("user_no"));
		w.setCreatedTime(rs.getTimestamp("created_time"));
		return w;
	}
}
