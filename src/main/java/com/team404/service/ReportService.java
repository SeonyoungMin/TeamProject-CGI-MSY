package com.team404.service;

import java.util.List;

import com.team404.domain.Report;

public interface ReportService {

	void submitReport(Report report);

	List<Report> getAllReports();

	List<Report> getReportsByType(String targetType);

	void processReport(int reportNo);

	boolean isDuplicate(int reporterNo, String targetType, int targetNo);

}