package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.team404.domain.Report;

@Repository
public class ReportRepositoryImpl implements ReportRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// RowMapper
	private RowMapper<Report> mapper = new RowMapper<Report>() {

		@Override
		public Report mapRow(ResultSet rs, int rowNum) throws SQLException {

			Report r = new Report();

			r.setReportNo(rs.getInt("report_no"));
			r.setReporterNo(rs.getInt("reporter_no"));
			r.setTargetType(rs.getString("target_type"));
			r.setTargetNo(rs.getInt("target_no"));
			r.setReasonType(rs.getString("reason_type"));
			r.setReasonDetail(rs.getString("reason_detail"));
			r.setAiScore(rs.getDouble("ai_score"));
			r.setAiResult(rs.getString("ai_result"));
			r.setStatus(rs.getString("status"));

			return r;
		}
	};

	@Override
	public void save(Report report) {

		String sql = "INSERT INTO report " + "(reporter_no, target_type, target_no, " + "reason_type, reason_detail, "
				+ "ai_score, ai_result, status) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

		jdbcTemplate.update(sql,

				report.getReporterNo(), report.getTargetType(), report.getTargetNo(), report.getReasonType(),
				report.getReasonDetail(), report.getAiScore(), report.getAiResult(), report.getStatus());
	}

	@Override
	public Report findByNo(int reportNo) {

		String sql = "SELECT * FROM report " + "WHERE report_no = ?";

		return jdbcTemplate.queryForObject(sql, mapper, reportNo);
	}
}