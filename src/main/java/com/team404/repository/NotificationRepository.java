package com.team404.repository;

import java.util.List;

import com.team404.domain.Notification;

public interface NotificationRepository {
	
	
	// 알림 저장
    public void insert(Notification notification);
    
    // 전체 유저 번호 목록 (공지 알림 전송용)
    public List<Integer> findAllUserNos();
 
    // 특정 수신자의 알림 목록 (최신순, 최대 10건)
    public List<Notification> findByReceiver(int receiverNo);
 
    // 읽지 않은 알림 개수 (헤더 뱃지용)
    public int countUnread(int receiverNo);
 
    // 알림 단건 읽음 처리
    public void markAsRead(int notificationNo);
 
    // 특정 수신자의 모든 알림 읽음 처리
    public void markAllAsRead(int receiverNo);
 
    // 알림 단건 삭제 
    public void delete(int notificationNo);
 
    // 특정 수신자의 읽은 알림 전체 삭제 (정리용)
    public void deleteReadByReceiver(int receiverNo);
}
