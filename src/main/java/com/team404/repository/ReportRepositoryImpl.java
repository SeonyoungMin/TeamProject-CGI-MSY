package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.team404.domain.Report;

@Repository
public class ReportRepositoryImpl implements ReportRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	private final RowMapper<Report> rowMapper = new RowMapper<Report>() {
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
			java.sql.Timestamp ts = rs.getTimestamp("created_time");
			r.setCreatedTime(ts != null ? ts.toLocalDateTime() : null);
			r.setReporterNickname(rs.getString("reporter_nickname"));
			r.setTargetName(rs.getString("target_name"));
			r.setAccusedUserNo(rs.getInt("accused_user_no"));
			r.setAccusedNickname(rs.getString("accused_nickname"));
			r.setUserRiskScore(rs.getDouble("user_risk_score"));
			r.setAppealContent(rs.getString("appeal_content"));
			r.setAppealStatus(rs.getString("appeal_status"));
			return r;
		}
	};

	@Override
	public void insert(Report report) {
		String sql = "INSERT INTO report (reporter_no, target_type, target_no, reason_type, reason_detail, ai_score, ai_result, status, accused_user_no) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, '대기', ?)";
		jdbcTemplate.update(sql, report.getReporterNo(), report.getTargetType(), report.getTargetNo(),
				report.getReasonType(), report.getReasonDetail(), report.getAiScore(), report.getAiResult(),
				report.getAccusedUserNo());
	}

	@Override
	public List<Report> findAll() {
		String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
				+ "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
				+ "r.accused_user_no, " + "r.accused_user_no, r.appeal_content, r.appeal_status, "
				+ "u.nickname AS reporter_nickname, " + "au.nickname AS accused_nickname, "
				+ "au.risk_score AS user_risk_score, " + "CASE r.target_type "
				+ "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
				+ "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
				+ "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
				+ "END AS target_name " + "FROM report r " + "LEFT JOIN users u ON r.reporter_no = u.user_no "
				+ "LEFT JOIN users au ON r.accused_user_no = au.user_no " + "ORDER BY r.created_time DESC";
		return jdbcTemplate.query(sql, rowMapper);
	}

	@Override
	public List<Report> findByTargetType(String targetType) {
		String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
				+ "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
				+ "r.accused_user_no, " + "r.accused_user_no, r.appeal_content, r.appeal_status, "
				+ "u.nickname AS reporter_nickname, " + "au.nickname AS accused_nickname, "
				+ "au.risk_score AS user_risk_score, " + "CASE r.target_type "
				+ "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
				+ "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
				+ "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
				+ "END AS target_name " + "FROM report r " + "LEFT JOIN users u ON r.reporter_no = u.user_no "
				+ "LEFT JOIN users au ON r.accused_user_no = au.user_no " + "WHERE r.target_type = ? "
				+ "ORDER BY r.created_time DESC";
		return jdbcTemplate.query(sql, rowMapper, targetType);
	}

	@Override
	public void updateStatus(int reportNo, String status) {
		String sql = "UPDATE report SET status = ? WHERE report_no = ?";
		jdbcTemplate.update(sql, status, reportNo);
	}

	@Override
	public boolean existsReport(int reporterNo, String targetType, int targetNo) {
		String sql = "SELECT COUNT(*) FROM report WHERE reporter_no = ? AND target_type = ? AND target_no = ?";
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, reporterNo, targetType, targetNo);
		return count != null && count > 0;
	}

	@Override
	public List<Report> findByStatus(String status) {
		String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
				+ "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
				+ "r.accused_user_no, " + "r.accused_user_no, r.appeal_content, r.appeal_status, "
				+ "u.nickname AS reporter_nickname, " + "au.nickname AS accused_nickname, "
				+ "au.risk_score AS user_risk_score, " + "CASE r.target_type "
				+ "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
				+ "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
				+ "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
				+ "END AS target_name " + "FROM report r " + "LEFT JOIN users u ON r.reporter_no = u.user_no "
				+ "LEFT JOIN users au ON r.accused_user_no = au.user_no " + "WHERE r.status = ? "
				+ "ORDER BY r.created_time DESC";
		return jdbcTemplate.query(sql, rowMapper, status);
	}

	@Override
	public void updateAppeal(int reportNo, String appealContent) {
		String sql = "UPDATE report SET appeal_content = ?, appeal_status = '검토중' WHERE report_no = ?";
		jdbcTemplate.update(sql, appealContent, reportNo);
	}

	@Override
	public Report findByReportNoAndAccused(int reportNo, int userNo) {
		String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
				+ "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
				+ "r.accused_user_no, r.appeal_content, r.appeal_status, " + "u.nickname AS reporter_nickname, "
				+ "au.nickname AS accused_nickname, " + "au.risk_score AS user_risk_score, " + "CASE r.target_type "
				+ "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
				+ "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
				+ "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
				+ "END AS target_name " + "FROM report r " + "LEFT JOIN users u ON r.reporter_no = u.user_no "
				+ "LEFT JOIN users au ON r.accused_user_no = au.user_no "
				+ "WHERE r.report_no = ? AND r.accused_user_no = ?";
		List<Report> list = jdbcTemplate.query(sql, rowMapper, reportNo, userNo);
		return list.isEmpty() ? null : list.get(0);
	}

	@Override
	public List<Report> findByAccusedUserNo(int accusedUserNo) {
		String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
				+ "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
				+ "r.accused_user_no, r.appeal_content, r.appeal_status, " + "u.nickname AS reporter_nickname, "
				+ "au.nickname AS accused_nickname, " + "au.risk_score AS user_risk_score, " + "CASE r.target_type "
				+ "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
				+ "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
				+ "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
				+ "END AS target_name " + "FROM report r " + "LEFT JOIN users u ON r.reporter_no = u.user_no "
				+ "LEFT JOIN users au ON r.accused_user_no = au.user_no "
				+ "WHERE r.accused_user_no = ? AND r.status != '처리완료' ORDER BY r.created_time DESC";
		return jdbcTemplate.query(sql, rowMapper, accusedUserNo);
	}
	
	@Override
	public Report findByReportNo(int reportNo) {
	    String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
	               + "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
	               + "r.accused_user_no, r.appeal_content, r.appeal_status, "
	               + "u.nickname AS reporter_nickname, "
	               + "au.nickname AS accused_nickname, "
	               + "au.risk_score AS user_risk_score, "
	               + "CASE r.target_type "
	               + "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
	               + "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
	               + "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
	               + "END AS target_name "
	               + "FROM report r "
	               + "LEFT JOIN users u ON r.reporter_no = u.user_no "
	               + "LEFT JOIN users au ON r.accused_user_no = au.user_no "
	               + "WHERE r.report_no = ?";
	    List<Report> list = jdbcTemplate.query(sql, rowMapper, reportNo);
	    return list.isEmpty() ? null : list.get(0);
	}
	
	@Override
	public void updateAppealStatus(int reportNo, String appealStatus) {
	    String sql = "UPDATE report SET appeal_status = ? WHERE report_no = ?";
	    jdbcTemplate.update(sql, appealStatus, reportNo);
	}
}