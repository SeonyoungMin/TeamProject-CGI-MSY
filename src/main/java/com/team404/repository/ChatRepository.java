package com.team404.repository;

import java.util.List;

import com.team404.domain.ChatMessage;
import com.team404.domain.ChatRoom;

public interface ChatRepository {

	//채팅방 생성
	int createRoom(int userNo);
	
	//채팅방 조회(유저별)
	ChatRoom findRoomByUserNo(int userNo);
	
	//채빙방 조회(방 번호)
	ChatRoom findRoomByNo(int roomNo);
	
	//전체 채팅방 조회 ( 관리자용)
	List<ChatRoom> findAllRooms();
	
	//메시지 저장
	void saveMessage(ChatMessage message);
	
	//메시지 목록 조회
	List<ChatMessage> findMessageByRoomNo(int roomNo);
	
	//채팅방 상태 변경
	void updateRoomStatus(int roomNo, String status);
	
	ChatRoom findActiveRoomByUserNo(int userNo);
	
}
