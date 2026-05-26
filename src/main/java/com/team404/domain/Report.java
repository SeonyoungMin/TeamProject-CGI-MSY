package com.team404.domain;

import java.time.LocalDateTime;

public class Report {

	private int reportNo;
	private int reporterNo;

	private String targetType;
	private int targetNo;

	private String reasonType;
	private String reasonDetail;

	private double aiScore;
	private String aiResult;

	private String status;

	private LocalDateTime createdTime;

	public int getReportNo() {
		return reportNo;
	}

	public void setReportNo(int reportNo) {
		this.reportNo = reportNo;
	}

	public int getReporterNo() {
		return reporterNo;
	}

	public void setReporterNo(int reporterNo) {
		this.reporterNo = reporterNo;
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public int getTargetNo() {
		return targetNo;
	}

	public void setTargetNo(int targetNo) {
		this.targetNo = targetNo;
	}

	public String getReasonType() {
		return reasonType;
	}

	public void setReasonType(String reasonType) {
		this.reasonType = reasonType;
	}

	public String getReasonDetail() {
		return reasonDetail;
	}

	public void setReasonDetail(String reasonDetail) {
		this.reasonDetail = reasonDetail;
	}

	public double getAiScore() {
		return aiScore;
	}

	public void setAiScore(double aiScore) {
		this.aiScore = aiScore;
	}

	public String getAiResult() {
		return aiResult;
	}

	public void setAiResult(String aiResult) {
		this.aiResult = aiResult;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDateTime getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(LocalDateTime createdTime) {
		this.createdTime = createdTime;
	}
}