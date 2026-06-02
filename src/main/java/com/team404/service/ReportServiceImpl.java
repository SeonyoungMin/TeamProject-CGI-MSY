package com.team404.service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team404.domain.FraudAccount;
import com.team404.domain.Report;
import com.team404.domain.User;
import com.team404.repository.FraudAccountRepository;
import com.team404.repository.ReportRepository;

@Service
public class ReportServiceImpl implements ReportService {

	@Autowired
	private ReportRepository reportRepository;

	@Autowired
	private FraudAccountRepository fraudRepository;

	@Autowired
	private UserService userService;

	@Autowired
	private NotificationService notificationService;

	@Value("${gemini.api.key}")
	private String geminiApiKey;

	@Override
	public void submitReport(Report report) {
		System.out.println("accusedUserNo: " + report.getAccusedUserNo());
		double[] aiResult = anlyzeWithGemini(report);
		double score = aiResult[0];
		int resultCode = (int) aiResult[1];

		report.setAiScore(score);
		if (resultCode == 2)
			report.setAiResult("위험");
		else if (resultCode == 1)
			report.setAiResult("주의");
		else
			report.setAiResult("안전");

		report.setStatus("대기");
		reportRepository.insert(report);

		String targetTypeName = "user".equals(report.getTargetType()) ? "유저"
				: "product".equals(report.getTargetType()) ? "상품" : "게시글";
		notificationService.notifyReport(report.getReporterNo(), targetTypeName, report.getTargetType(), report.getAccusedUserNo());

		// 사기계좌 처리
		if ("ACCOUNT".equals(report.getTargetType()) && score >= 0.8) {
			User seller = userService.getUserByNo(report.getTargetNo());
			FraudAccount fraud = new FraudAccount();
			fraud.setSellerNo(seller.getUserNo());
			fraud.setAccountNumber(seller.getUserAccountNumber());
			fraud.setBankName(seller.getUserBankName());
			fraud.setStatus("SUSPECTED");
			fraud.setLocked(true);
			fraudRepository.save(fraud);
		}
	}

	private double[] anlyzeWithGemini(Report report) {
		try {
			String prompt = buildPrompt(report);

			// 요청 JSON 구성
			String requestBody = "{" + "\"contents\": [{" + "  \"parts\": [{" + "    \"text\": \"" + escapeJson(prompt)
					+ "\"" + "  }]" + "}]" + "}";

			// Gemini API 호출
			URL url = new URL(
					"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key="
							+ geminiApiKey);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setDoOutput(true);
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(10000);

			try (OutputStream os = conn.getOutputStream()) {
				os.write(requestBody.getBytes("UTF-8"));
			}

			// 응답 읽기
			StringBuilder sb = new StringBuilder();
			InputStream is = conn.getResponseCode() >= 400 ? conn.getErrorStream() : conn.getInputStream();
			try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
				String line;
				while ((line = br.readLine()) != null)
					sb.append(line);
			}
			System.out.println("Gemini 응답: " + sb.toString());

			// 응답 파싱
			ObjectMapper mapper = new ObjectMapper();
			JsonNode root = mapper.readTree(sb.toString());

			String text = root.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText()
					.trim();

			System.out.println("파싱할 텍스트: " + text);

			double score = 0.5;
			int resultCode = 1;
			for (String part : text.split(",")) {
				String[] kv = part.trim().split(":");
				if (kv.length == 2) {
					String key = kv[0].trim();
					String value = kv[1].trim();
					System.out.println("key: " + key + ", value: " + value);
					if ("score".equals(key))
						score = Double.parseDouble(value);
					if ("result".equals(key))
						resultCode = Integer.parseInt(value);
				}
			}
			System.out.println("최종 score: " + score + ", resultCode: " + resultCode);
			return new double[] { score, resultCode };

		} catch (Exception e) {
			System.out.println("Gemini API 오류: " + e.getMessage());
			e.printStackTrace();
			// API 호출 실패 시 기존 규칙 기반으로 폴백
			double score = 0;
			if ("SCAM_ACCOUNT".equals(report.getReasonType()))
				score += 0.8;
			if ("FRAUD".equals(report.getReasonType()))
				score += 0.6;
			int resultCode = score >= 0.8 ? 2 : score >= 0.5 ? 1 : 0;
			return new double[] { score, resultCode };
		}
	}

	private String buildPrompt(Report report) {
		return "당신은 중고거래 플랫폼의 신고 점수 계산기입니다. " + "아래 신고 유형에 따라 정해진 점수를 반환하세요.\\n\\n" + "신고 유형별 점수표:\\n"
				+ "SCAM_ACCOUNT: 0.8\\n" + "FRAUD: 0.7\\n" + "FALSE_LISTING: 0.5\\n" + "ABUSE: 0.5\\n"
				+ "RULE_VIOLATION: 0.4\\n" + "DUPLICATE: 0.2\\n" + "SPAM: 0.2\\n" + "ETC: 0.1\\n\\n" + "신고 유형: "
				+ report.getReasonType() + "\\n\\n" + "위 점수표에서 해당 유형의 점수를 찾아 반드시 아래 형식으로만 응답하세요:\\n"
				+ "score:0.00,result:0\\n\\n" + "result는 score >= 0.8이면 2, score >= 0.5이면 1, 그 외 0입니다.";
	}

	private String escapeJson(String text) {
		return text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t",
				"\\t");
	}

	@Override
	public List<Report> getAllReports() {
		return reportRepository.findAll();
	}

	@Override
	public List<Report> getReportsByType(String targetType) {
		return reportRepository.findByTargetType(targetType);
	}

	@Override
	public void processReport(int reportNo) {
		reportRepository.updateStatus(reportNo, "처리완료");
	}

	@Override
	public boolean isDuplicate(int reporterNo, String targetType, int targetNo) {
		return reportRepository.existsReport(reporterNo, targetType, targetNo);
	}

	@Override
	public List<Report> getReportsByStatus(String status) {
		return reportRepository.findByStatus(status);
	}
	
	@Override
	public void submitAppeal(int reportNo, int userNo, String appealContent) {
	    Report report = reportRepository.findByReportNoAndAccused(reportNo, userNo);
	    if (report == null) throw new IllegalArgumentException("소명 권한이 없습니다.");
	    reportRepository.updateAppeal(reportNo, appealContent);
	}

	@Override
	public Report getReportByNoAndAccused(int reportNo, int userNo) {
	    return reportRepository.findByReportNoAndAccused(reportNo, userNo);
	}
	
	@Override
	public List<Report> getReportsByAccused(int accusedUserNo) {
	    return reportRepository.findByAccusedUserNo(accusedUserNo);
	}
	
	@Override
	public Report getReportByNo(int reportNo) {
	    return reportRepository.findByReportNo(reportNo);
	}
	
	@Override
	public void updateAppealStatus(int reportNo, String appealStatus) {
	    reportRepository.updateAppealStatus(reportNo, appealStatus);
	}

	@Override
	public void revertReport(int reportNo) {
	    reportRepository.updateStatus(reportNo, "대기");
	    Report report = reportRepository.findByReportNo(reportNo);
	    if (report != null && report.getAppealContent() != null) {
	        reportRepository.updateAppealStatus(reportNo, "검토중");
	    }
	}
}