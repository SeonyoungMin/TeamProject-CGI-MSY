package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.team404.domain.FraudAccount;

@Repository
public class FraudAccountRepositoryImpl implements FraudAccountRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	private RowMapper<FraudAccount> mapper = new RowMapper<FraudAccount>() {

		@Override
		public FraudAccount mapRow(ResultSet rs, int rowNum) throws SQLException {

			FraudAccount f = new FraudAccount();

			f.setFraudNo(rs.getInt("fraud_no"));
			f.setSellerNo(rs.getInt("seller_no"));
			f.setAccountNumber(rs.getString("account_number"));
			f.setBankName(rs.getString("bank_name"));
			f.setReportNo(rs.getInt("report_no"));
			f.setStatus(rs.getString("status"));
			f.setLocked(rs.getBoolean("locked"));

			return f;
		}
	};

	@Override
	public void save(FraudAccount fraud) {

		String sql = "INSERT INTO fraud_account " + "(seller_no, account_number, " + "bank_name, report_no, "
				+ "status, locked) " + "VALUES (?, ?, ?, ?, ?, ?)";

		jdbcTemplate.update(sql,

				fraud.getSellerNo(), fraud.getAccountNumber(), fraud.getBankName(), fraud.getReportNo(),
				fraud.getStatus(), fraud.isLocked());
	}

	@Override
	public boolean existsLockedBySellerNo(int sellerNo) {

		String sql = "SELECT COUNT(*) " + "FROM fraud_account " + "WHERE seller_no=? " + "AND locked=true";

		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, sellerNo);

		return count != null && count > 0;
	}
}