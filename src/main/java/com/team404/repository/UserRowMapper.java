package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.User;

public class UserRowMapper implements RowMapper<User> {

	@Override
	public User mapRow(ResultSet rs, int rowNum) throws SQLException {
		User user = new User();
		user.setUserNo(rs.getInt("user_no"));
		user.setUserId(rs.getString("id"));
		user.setUserPw(rs.getString("pw"));
		user.setUserName(rs.getString("name"));
		user.setUserNickName(rs.getString("nickname"));
		user.setUserAge(rs.getInt("age"));
		user.setUserAddress(rs.getString("address"));
		user.setUserPhone(rs.getString("phone"));
		user.setUserRole(rs.getString("role"));
		user.setUserGrade(rs.getString("grade"));
		// DB datetime 속성값을 LocalDateTime 클래스로 변환하는 방법
		user.setUserCreatedTime(rs.getTimestamp("created_time").toLocalDateTime());
		user.setUserSellCount(rs.getInt("sell_count"));
		user.setUserBuyCount(rs.getInt("buy_count"));
		return user;
	}
}
