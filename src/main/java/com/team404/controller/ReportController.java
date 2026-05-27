package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Report;
import com.team404.domain.User;
import com.team404.service.ImageService;
import com.team404.service.ReportService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReportController {

	@Autowired
	private ReportService reportService;

	@Autowired
	private ImageService imageService;

	// 신고 폼 페이지 (모달 방식이라 거의 안 쓰이지만 유지)
	@GetMapping("/report")
	public String reportForm(
			@RequestParam("targetType") String targetType,
			@RequestParam("targetNo") int targetNo,
			HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "redirect:/login";

		if (reportService.isDuplicate(loginUser.getUserNo(), targetType, targetNo)) {
			model.addAttribute("error", "이미 신고한 대상입니다.");
			return "redirect:/home";
		}

		model.addAttribute("targetType", targetType);
		model.addAttribute("targetNo", targetNo);
		return "redirect:/home";
	}

	// 신고 접수
	@PostMapping("/report")
	public String submitReport(
			@RequestParam("targetType") String targetType,
			@RequestParam("targetNo") int targetNo,
			@RequestParam("reasonType") String reasonType,
			@RequestParam(value = "reasonDetail", required = false) String reasonDetail,
			@RequestParam(value = "evidenceFile", required = false) List<MultipartFile> evidenceFiles,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "redirect:/login";

		// 중복 신고 확인
		if (reportService.isDuplicate(loginUser.getUserNo(), targetType, targetNo)) {
			if ("user".equals(targetType)) return "redirect:/users/search/" + targetNo + "?error=duplicate";
			if ("product".equals(targetType)) return "redirect:/product/" + targetNo + "?error=duplicate";
			if ("board".equals(targetType)) return "redirect:/boardList/" + targetNo + "?error=duplicate";
			return "redirect:/home";
		}

		Report report = new Report();
		report.setReporterNo(loginUser.getUserNo());
		report.setTargetType(targetType);
		report.setTargetNo(targetNo);
		report.setReasonType(reasonType);
		report.setReasonDetail(reasonDetail);

		reportService.submitReport(report);

		// 증거 이미지 저장
		if (evidenceFiles != null && !evidenceFiles.isEmpty()) {
			for (MultipartFile file : evidenceFiles) {
				if (!file.isEmpty()) {
					imageService.upload(List.of(file), "report", report.getReportNo());
				}
			}
		}

		// 신고 후 원래 페이지로 돌아가기
		if ("user".equals(targetType)) return "redirect:/users/search/" + targetNo;
		if ("product".equals(targetType)) return "redirect:/product/" + targetNo;
		if ("board".equals(targetType)) return "redirect:/boardList/" + targetNo;
		return "redirect:/home";
	}

	// 관리자 신고 목록
	@GetMapping("/admin/reports")
	public String adminReports(
			@RequestParam(value = "type", required = false) String type,
			HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "redirect:/login";
		if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) return "redirect:/home";

		List<Report> reports = (type != null && !type.isEmpty())
				? reportService.getReportsByType(type)
				: reportService.getAllReports();

		model.addAttribute("reports", reports);
		model.addAttribute("selectedType", type);
		return "adminReports";
	}

	// 관리자 신고 처리완료
	@PostMapping("/admin/reports/{reportNo}/process")
	public String processReport(
			@PathVariable("reportNo") int reportNo,
			@RequestParam(value = "type", required = false) String type,
			HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "redirect:/login";
		if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) return "redirect:/home";

		reportService.processReport(reportNo);

		return type != null ? "redirect:/admin/reports?type=" + type : "redirect:/admin/reports";
	}
}