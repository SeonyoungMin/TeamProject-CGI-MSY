package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.Notification;

@Repository
public class NotificationRepositoryImpl implements NotificationRepository {

	@Autowired
	private JdbcTemplate template;

	// 알림 저장
	public void insert(Notification notification) {
		String SQL = "insert into notification " + "(receiver_no, sender_no, noti_type, message, link_url) "
				+ "values (?, ?, ?, ?, ?)";
		template.update(SQL, notification.getReceiverNo(),
				notification.getSenderNo() == 0 ? null : notification.getSenderNo(), notification.getNotiType(),
				notification.getMessage(), notification.getLinkUrl());
	}

	// 전체 유저 번호 (공지사항 알림용)
	public List<Integer> findAllUserNos() {
		String sql = "SELECT user_no FROM users";
		return template.queryForList(sql, Integer.class);
	}

	// 특정 수신자의 알림 목록 (최신순, 최대 10건)
	public List<Notification> findByReceiver(int receiverNo) {
		String SQL = "select n.notification_no, n.receiver_no, n.sender_no, "
				+ "n.noti_type, n.message, n.link_url, n.is_read, n.created_time, "
				+ "ifnull(u.nickname, '시스템') as sender_nickname " + "from notification n "
				+ "left join users u on n.sender_no = u.user_no " + "where n.receiver_no = ? "
				+ "order by n.created_time desc limit 20";
		return template.query(SQL, new NotificationRowMapper(), receiverNo);
	}

	// 읽지 않은 알림 개수 (헤더 뱃지용)
	public int countUnread(int receiverNo) {
		String SQL = "select count(*) from notification " + "where receiver_no = ? and is_read = 0";
		Integer count = template.queryForObject(SQL, Integer.class, receiverNo);
		return count != null ? count : 0;
	}

	// 알림 단건 읽음 처리
	public void markAsRead(int notificationNo) {
		String SQL = "update notification set is_read = 1 where notification_no = ?";
		template.update(SQL, notificationNo);

	}

	// 특정 수신자의 모든 알림 읽음 처리
	public void markAllAsRead(int receiverNo) {
		String SQL = "update notification set is_read = 1 " + "where receiver_no = ? and is_read = 0";
		template.update(SQL, receiverNo);
	}

	// 알림 단건 삭제
	public void delete(int notificationNo) {
		String SQL = "delete from notification where notification_no = ?";
		template.update(SQL, notificationNo);
	}

	// 특정 수신자의 읽은 알림 전체 삭제 (정리용)
	public void deleteReadByReceiver(int receiverNo) {
		String SQL = "delete from notification where receiver_no = ? and is_read = 1";
		template.update(SQL, receiverNo);
	}

	// link_url에 특정 문자열이 포함된 알림 일괄 삭제
	@Override
	public int deleteByLinkUrlContaining(String urlFragment) {
		String SQL = "delete from notification where link_url like ?";
		return template.update(SQL, "%" + urlFragment + "%");
	}

	// 특정 수신자의 특정 타입 알림 일괄 삭제
	@Override
	public int deleteByReceiverAndType(int receiverNo, String notiType) {
		String SQL = "delete from notification where receiver_no = ? and noti_type = ?";
		return template.update(SQL, receiverNo, notiType);
	}

}