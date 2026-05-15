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
	void insert(Notification notification) {
		String SQL = "insert into notification " + "(receiver_no, sender_no, noti_type, message, link_url) "
				+ "values (?, ?, ?, ?, ?)";
		template.update(SQL, notification.getReceiverNo(), notification.getSenderNo() == 0 ? null : notification.getSenderNo(), notification.getNotiType(), notification.getMessage(), notification.getLinkUrl());
	}

	// 특정 수신자의 알림 목록 (최신순, 최대 10건)
	List<Notification> findByReceiver(int receiverNo) {
		
	}

	// 읽지 않은 알림 개수 (헤더 뱃지용)
	int countUnread(int receiverNo);

	// 알림 단건 읽음 처리
	void markAsRead(int notificationNo);

	// 특정 수신자의 모든 알림 읽음 처리
	void markAllAsRead(int receiverNo);

	// 알림 단건 삭제
	void delete(int notificationNo);

	// 특정 수신자의 읽은 알림 전체 삭제 (정리용)
	void deleteReadByReceiver(int receiverNo);

}
