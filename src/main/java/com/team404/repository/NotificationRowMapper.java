package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.Notification;

public class NotificationRowMapper implements RowMapper<Notification> {
	public Notification mapRow(ResultSet rs, int rowNum) throws SQLException {
		Notification n = new Notification();
        n.setNotificationNo(rs.getInt("notification_no"));
        n.setReceiverNo(rs.getInt("receiver_no"));
        n.setSenderNo(rs.getInt("sender_no"));
        n.setNotiType(rs.getString("noti_type"));
        n.setMessage(rs.getString("message"));
        n.setLinkUrl(rs.getString("link_url"));
        n.setRead(rs.getInt("is_read") == 1);
        n.setCreatedTime(rs.getTimestamp("created_time"));
        n.setSenderNickname(rs.getString("sender_nickname"));
		return n;
	}

}
