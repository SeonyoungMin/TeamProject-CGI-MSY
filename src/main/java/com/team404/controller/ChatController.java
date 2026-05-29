package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.domain.ChatMessage;
import com.team404.domain.ChatRoom;
import com.team404.domain.User;
import com.team404.service.ChatService;
import com.team404.service.NotificationService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatController {

	@Autowired
	private ChatService chatService;

	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	@Autowired
	private NotificationService notificationService;

	// 채팅방 입장 (유저)
	@GetMapping("/chat")
	public String chatRoom(HttpSession session, Model model) {
	    User loginUser = (User) session.getAttribute("loginUser");
	    
	    if (loginUser != null) {
	        ChatRoom room = chatService.getRoomByUserNo(loginUser.getUserNo());
	        if (room == null) {
	            int roomNo = chatService.createRoom(loginUser.getUserNo());
	            room = chatService.getRoomByNo(roomNo);
	        }
	        List<ChatMessage> messages = chatService.getMessages(room.getRoomNo());
	        model.addAttribute("room", room);
	        model.addAttribute("messages", messages);
	    }
	    
	    model.addAttribute("loginUser", loginUser);
	    return "chat";
	}

	// 관리자 채팅 목록
	@GetMapping("/admin/chat")
	public String adminChatList(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";
		if (!"ROLE_ADMIN".equals(loginUser.getUserRole()))
			return "redirect:/home"; 

		model.addAttribute("rooms", chatService.getAllRooms());
		return "adminChat";
	}

	// 관리자 특정 채팅방 입장
	@GetMapping("/admin/chat/{roomNo}")
	public String adminChatRoom(@PathVariable("roomNo") int roomNo, HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";
		if (!"ROLE_ADMIN".equals(loginUser.getUserRole()))
			return "redirect:/home";

		ChatRoom room = chatService.getRoomByNo(roomNo);
		List<ChatMessage> message = chatService.getMessages(roomNo);
		model.addAttribute("room", room);
		model.addAttribute("message", message);
		model.addAttribute("loginUser", loginUser);
		return "adminChatRoom";
	}

	// 봇 응답 (REST)
	@PostMapping("/chat/bot")
	@ResponseBody
	public String botResponse(@RequestParam("message") String message, HttpSession session) {
		String botReply = chatService.askBot(message);
		
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser != null) {
			// 회원이면 내역 DB 저장
			ChatRoom room = chatService.getRoomByUserNo(loginUser.getUserNo());
			if (room == null) {
				int roomNo = chatService.createRoom(loginUser.getUserNo());
				room = chatService.getRoomByNo(roomNo);
			}
			
			ChatMessage userMsg = new ChatMessage();
			userMsg.setRoomNo(room.getRoomNo());
			userMsg.setSenderNo(loginUser.getUserNo());
			userMsg.setSenderType("user");
			userMsg.setContent(message);
			chatService.saveMessage(userMsg);
			
			ChatMessage botMsg = new ChatMessage();
			botMsg.setRoomNo(room.getRoomNo());
			botMsg.setSenderNo(0);
			botMsg.setSenderType("bot");
			botMsg.setContent(botReply);
			chatService.saveMessage(botMsg);
		}
		
		if (botReply.contains("관리자 상담이 필요한 내용입니다.")) {
			return botReply + "||NEED_ADMIN";
		}
		return botReply;
	}
	
	// WebSocket 메시지 처리 (관리자-유저 실시간)
	@MessageMapping("/chat.send")
	public void sendMessage(@Payload ChatMessage message) {
		chatService.saveMessage(message);
		messagingTemplate.convertAndSend("/topic/chat/" + message.getRoomNo(), message);
	}
	
	// 관리자 상담 요청
	@PostMapping("/chat/request-admin")
	@ResponseBody
	public String requestAdmin(HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "fail";
				
		ChatRoom room = chatService.getRoomByUserNo(loginUser.getUserNo());
		chatService.updateRoomStatus(room.getRoomNo(), "상담대기");
		
		// 관리자 알림
		notificationService.notifyReport(loginUser.getUserNo(), "상담", "새 상담 요청이 있습니다");    
		
		return "ok";
	}
}
