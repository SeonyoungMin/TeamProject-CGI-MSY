package com.team404.service;

import java.util.List;

import com.team404.domain.Report;

public interface ReportService {

	void submitReport(Report report);

	List<Report> getAllReports();

	List<Report> getReportsByType(String targetType);

	void processReport(int reportNo);

	boolean isDuplicate(int reporterNo, String targetType, int targetNo);

	List<Report> getReportsByStatus(String status);
	
	void submitAppeal(int reportNo, int userNo, String appealContent);
	
	Report getReportByNoAndAccused(int reportNo, int userNo);
	
	List<Report> getReportsByAccused(int accusedUserNo);
	
	Report getReportByNo(int reportNo);
	
	void updateAppealStatus(int reportNo, String appealStatus);
}