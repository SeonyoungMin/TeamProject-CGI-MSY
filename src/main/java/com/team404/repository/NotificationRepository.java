package com.team404.repository;

import java.util.List;

import com.team404.domain.Notification;

public interface NotificationRepository {
	
	
	// 알림 저장
    void insert(Notification notification);
 
    // 특정 수신자의 알림 목록 (최신순, 최대 10건)
    List<Notification> findByReceiver(int receiverNo);
 
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
