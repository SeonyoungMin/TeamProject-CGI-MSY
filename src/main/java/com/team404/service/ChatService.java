package com.team404.service;

import java.util.List;

import com.team404.domain.ChatMessage;
import com.team404.domain.ChatRoom;

public interface ChatService {

	int createRoom(int userNo);
	ChatRoom getRoomByUserNo(int userNo);
	ChatRoom getRoomByNo(int roomNo);
	List<ChatRoom> getAllRooms();
	void saveMessage(ChatMessage message);
	List<ChatMessage> getMessages(int roomNo);
	void updateRoomStatus(int roomNo, String status);
	String askBot(String userMessage);
}
