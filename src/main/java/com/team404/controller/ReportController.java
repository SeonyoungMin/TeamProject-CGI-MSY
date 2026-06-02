package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.BoardDetailDto;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.Report;
import com.team404.domain.User;
import com.team404.service.BoardService;
import com.team404.service.ImageService;
import com.team404.service.ProductService;
import com.team404.service.ReportService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReportController {

	@Autowired
	private ReportService reportService;

	@Autowired
	private ImageService imageService;
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private BoardService boardService;

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

		/*
		 * // 중복 신고 확인 if (reportService.isDuplicate(loginUser.getUserNo(), targetType,
		 * targetNo)) { if ("user".equals(targetType)) return "redirect:/users/search/"
		 * + targetNo + "?error=duplicate"; if ("product".equals(targetType)) return
		 * "redirect:/product/" + targetNo + "?error=duplicate"; if
		 * ("board".equals(targetType)) return "redirect:/boardList/" + targetNo +
		 * "?error=duplicate"; return "redirect:/home"; }
		 */
		
		// 중복 신고 확인
		boolean dup = reportService.isDuplicate(loginUser.getUserNo(), targetType, targetNo);
		System.out.println("중복 체크: " + dup + ", reporterNo=" + loginUser.getUserNo() + ", targetType=" + targetType + ", targetNo=" + targetNo);
		if (dup) {
		    if ("user".equals(targetType)) return "redirect:/users/search/" + targetNo + "?error=duplicate";
		    if ("product".equals(targetType)) return "redirect:/product/" + targetNo + "?error=duplicate";
		    if ("board".equals(targetType)) return "redirect:/boardList/" + targetNo + "?error=duplicate";
		    return "redirect:/home";
		}

		Report report = new Report();
		if ("user".equals(targetType)) {
			report.setAccusedUserNo(targetNo);
		} else if ("product".equals(targetType)) { 
			ProductDetailDto product = productService.findProductDetail(targetNo);
			report.setAccusedUserNo(product.getSellerNo());
		} else if ("board".equals(targetType)) {
			BoardDetailDto board = boardService.findBoardDetail(targetNo);
			report.setAccusedUserNo(board.getAuthorNo());
		}
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
	        @RequestParam(value = "status", required = false) String status,
	        HttpSession session, Model model) {

	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) return "redirect:/login";
	    if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) return "redirect:/home";

	    List<Report> reports;
	    if (status != null && !status.isEmpty()) {
	        reports = reportService.getReportsByStatus(status);
	    } else if (type != null && !type.isEmpty()) {
	        reports = reportService.getReportsByType(type);
	    } else {
	        reports = reportService.getAllReports();
	    }

	    model.addAttribute("reports", reports);
	    model.addAttribute("selectedType", type);
	    model.addAttribute("selectedStatus", status);
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
		
		Report report = reportService.getReportByNo(reportNo);
		if (report != null && report.getAppealContent() != null) {
			reportService.updateAppealStatus(reportNo, "처리완료");
		}
 
		return type != null ? "redirect:/admin/reports?type=" + type : "redirect:/admin/reports";
	}
	
	// 소명 폼 페이지
	@GetMapping("/appeal/{reportNo}")
	public String appealForm(@PathVariable("reportNo") int reportNo, HttpSession session, Model model) {
		
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "redirect:/login";
		
		Report report = reportService.getReportByNoAndAccused(reportNo, loginUser.getUserNo());
		if (report == null) return "redirect:/home";
		
		model.addAttribute("report", report);
		return "appeal";
	}
	
	// 소명 제출
	@PostMapping("/appeal/{reportNo}")
	public String submitAppeal(@PathVariable("reportNo") int reportNo, @RequestParam("appealContent") String appealContent, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) return "redirect:/login";
		
		reportService.submitAppeal(reportNo, loginUser.getUserNo(), appealContent);
		return "redirect:/mypage";
	}
	
	//중복 체크 엔드포인트
	@GetMapping("/report/check-duplicate")
	@ResponseBody
	public String checkDuplicate(@RequestParam("targetType") String targetType,
	        @RequestParam("targetNo") int targetNo,
	        HttpSession session) {
	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) return "login";
	    
	    return reportService.isDuplicate(loginUser.getUserNo(), targetType, targetNo) ? "duplicate" : "ok";
	}
	
	@GetMapping("/admin/reports/{reportNo}/appeal")
	public String viewAppeal(@PathVariable("reportNo") int reportNo, HttpSession session, Model model) {
	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) return "redirect:/login";
	    if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) return "redirect:/home";
	    
	    model.addAttribute("report", reportService.getReportByNo(reportNo));
	    return "adminAppeal";
	}

	@PostMapping("/admin/reports/{reportNo}/appeal/done")
	public String doneAppeal(@PathVariable("reportNo") int reportNo, HttpSession session) {
		System.out.println("소명 처리완료 호출: " + reportNo);
	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) return "redirect:/login";
	    if (!"ROLE_ADMIN".equals(loginUser.getUserRole())) return "redirect:/home";
	    
	    reportService.updateAppealStatus(reportNo, "처리완료");
	    return "redirect:/admin/reports";
	}
}
	