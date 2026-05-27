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
            r.setCreatedTime(rs.getTimestamp("created_time").toLocalDateTime());
            r.setReporterNickname(rs.getString("reporter_nickname"));
            r.setTargetName(rs.getString("target_name"));
            return r;
        }
    };

    @Override
    public void insert(Report report) {
        String sql = "INSERT INTO report (reporter_no, target_type, target_no, reason_type, reason_detail, status) "
                   + "VALUES (?, ?, ?, ?, ?, '대기')";
        jdbcTemplate.update(sql,
                report.getReporterNo(),
                report.getTargetType(),
                report.getTargetNo(),
                report.getReasonType(),
                report.getReasonDetail());
    }

    @Override
    public List<Report> findAll() {
        String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
                   + "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
                   + "u.nickname AS reporter_nickname, "
                   + "CASE r.target_type "
                   + "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
                   + "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
                   + "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
                   + "END AS target_name "
                   + "FROM report r "
                   + "LEFT JOIN users u ON r.reporter_no = u.user_no "
                   + "ORDER BY r.created_time DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Report> findByTargetType(String targetType) {
        String sql = "SELECT r.report_no, r.reporter_no, r.target_type, r.target_no, "
                   + "r.reason_type, r.reason_detail, r.ai_score, r.ai_result, r.status, r.created_time, "
                   + "u.nickname AS reporter_nickname, "
                   + "CASE r.target_type "
                   + "  WHEN 'user'    THEN (SELECT nickname FROM users WHERE user_no = r.target_no) "
                   + "  WHEN 'product' THEN (SELECT name    FROM product WHERE product_no = r.target_no) "
                   + "  WHEN 'board'   THEN (SELECT title   FROM board WHERE board_no = r.target_no) "
                   + "END AS target_name "
                   + "FROM report r "
                   + "LEFT JOIN users u ON r.reporter_no = u.user_no "
                   + "WHERE r.target_type = ? "
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
}