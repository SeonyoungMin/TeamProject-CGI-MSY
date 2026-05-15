package com.team404.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team404.domain.Notification;
import com.team404.domain.User;
import com.team404.service.NotificationService;

import jakarta.servlet.http.HttpSession;

@Controller
public class NotificationController {

	@Autowired
	private NotificationService notificationService;

	// 알림 목록 페이지

	@GetMapping("/notification")
	public String notificationPage(HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		List<Notification> list = notificationService.getMyNotifications(loginUser.getUserNo());
		model.addAttribute("notifications", list);
		return "notification";
	}

	// 읽지 않는 알림 개수 (헤더 뱃지)

	@GetMapping("/notification/unread-count")
	@ResponseBody
	public Map<String, Integer> unreadCunt(HttpSession session) {
		Map<String, Integer> result = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			result.put("count", 0);
			return result;
		}
		result.put("count", notificationService.countUnread(loginUser.getUserNo()));
		return result;
	}

	// 드롭다운 알림 목록
	@GetMapping("/notification/recent")
	@ResponseBody
	public Map<String, Object> recentNotifications(HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			result.put("notifications", java.util.Collections.emptyList());
			result.put("unreadCount", 0);
			return result;
		}
		List<Notification> list = notificationService.getMyNotifications(loginUser.getUserNo());

		List<Notification> recent = list.size() > 8 ? list.subList(0, 8) : list;
		result.put("notifications", recent);
		result.put("unreadCount", notificationService.countUnread(loginUser.getUserNo()));
		return result;

	}

	// 알림 클릭 후 해당 페이지로 이동
	@GetMapping("/notification/read")
	public String readAndRedirect(@RequestParam("no") int notificationNo,
			@RequestParam(value = "link", required = false) String link, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		notificationService.readAndGetLink(notificationNo);

		if (link != null && !link.isBlank()) {
			return "redirect:" + link;
		}
		return "redirect:/notification";
	}

	// 드롭다운 읾음 처리
	@PostMapping("/notification/read")
	@ResponseBody
	public Map<String, String> readAjax(@RequestParam("no") int notificationNo, HttpSession session) {
		Map<String, String> result = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			result.put("status", "fail");
			return result;
		}
		notificationService.readAndGetLink(notificationNo);
		result.put("status", "ok");
		return result;
	}

	// 전체 읽음 처리
	@PostMapping("/notification/read-all")
	public String readAll(HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		notificationService.markAllAsRead(loginUser.getUserNo());
		return "redirect:/notification";
	}

	// 단건 삭제
	@PostMapping("/notification/delete")
	public String delete(@RequestParam("no") int notificationNo, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		notificationService.delete(notificationNo);
		return "redirect:/notification";
	}

	// 읽우 알림 전체 삭제
	@PostMapping("/notification/delete-read")
	public String deleteRead(HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		notificationService.deleteRead(loginUser.getUserNo());
		return "redirect:/notification";
	}
}
