package com.team404.repository;

import com.team404.domain.Report;

public interface ReportRepository {

	void save(Report report);

	Report findByNo(int reportNo);
}