package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    @Override
    public void submitReport(Report report) {
        double score = 0;
        if ("SCAM_ACCOUNT".equals(report.getReasonType())) score += 0.8;
        if ("FRAUD".equals(report.getReasonType())) score += 0.6;

        report.setAiScore(score);
        if (score >= 0.8)      report.setAiResult("HIGH_RISK");
        else if (score >= 0.5) report.setAiResult("SUSPICIOUS");
        else                   report.setAiResult("CLEAN");

        report.setStatus("대기");
        reportRepository.insert(report);

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
}