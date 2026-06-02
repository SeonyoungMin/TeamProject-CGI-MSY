package com.team404.repository;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.SearchDTO;
import com.team404.domain.User;

@Repository
public class UserRepositoryImpl implements UserRepository {

	@Autowired
	JdbcTemplate template;

	@Override
	public int countAll() {
		String SQL = "SELECT COUNT(*) FROM users";
		return template.queryForObject(SQL, Integer.class);
	}

	@Override
	public int countForInfo(SearchDTO searchDTO) {
		StringBuilder SQL = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();
		appendInfoFilters(SQL, params, searchDTO);
		return template.queryForObject(SQL.toString(), Integer.class, params.toArray());
	}

	@Override
	public int countForCondition(SearchDTO searchDTO) {
		StringBuilder SQL = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();
		appendConditionFilters(SQL, params, searchDTO);
		return template.queryForObject(SQL.toString(), Integer.class, params.toArray());
	}

	@Override
	public List<User> getAllUsers(int startNumber, int limit) {
		String SQL = "SELECT * FROM users ORDER BY user_no LIMIT ?, ?";
		return template.query(SQL, new UserRowMapper(), startNumber, limit);
	}

	@Override
	public User getUserByNo(int userNo) {
		String SQL = "SELECT * FROM users WHERE user_no = ?";
		List<User> userByNoTemp = template.query(SQL, new UserRowMapper(), userNo);
		if (userByNoTemp.isEmpty()) {
			return null;
		}
		return userByNoTemp.get(0);
	}

	@Override
	public List<User> searchUserByInfo(SearchDTO searchDTO, int startNumber, int limit) {
		StringBuilder SQL = new StringBuilder("SELECT * FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();
		appendInfoFilters(SQL, params, searchDTO);

		SQL.append(" ORDER BY user_no LIMIT ?, ?");
		params.add(startNumber);
		params.add(limit);

		return template.query(SQL.toString(), new UserRowMapper(), params.toArray());
	}

	@Override
	public List<User> searchUserByCondition(SearchDTO searchDTO, int startNumber, int limit) {
		StringBuilder SQL = new StringBuilder("SELECT * FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();
		appendConditionFilters(SQL, params, searchDTO);

		SQL.append(" ORDER BY user_no LIMIT ?, ?");
		params.add(startNumber);
		params.add(limit);

		return template.query(SQL.toString(), new UserRowMapper(), params.toArray());
	}

	// info 모드 필터 (id/name/address/phone/role) — count/select 양쪽에서 재사용
	private void appendInfoFilters(StringBuilder SQL, List<Object> params, SearchDTO searchDTO) {
		if (searchDTO.getUserId() != null && !searchDTO.getUserId().isEmpty()) {
			SQL.append(" AND id LIKE ? ");
			params.add(searchDTO.getUserId() + "%");
		}
		if (searchDTO.getUserName() != null && !searchDTO.getUserName().isEmpty()) {
			SQL.append(" AND name LIKE ? ");
			params.add(searchDTO.getUserName() + "%");
		}
		if (searchDTO.getUserAddress() != null && !searchDTO.getUserAddress().isEmpty()) {
			SQL.append(" AND address LIKE ? ");
			params.add("%" + searchDTO.getUserAddress() + "%");
		}
		if (searchDTO.getUserPhone() != null && !searchDTO.getUserPhone().isEmpty()) {
			SQL.append(" AND phone LIKE ? ");
			params.add("%" + searchDTO.getUserPhone() + "%");
		}
		if (searchDTO.getUserRole() != null && !searchDTO.getUserRole().isEmpty()) {
			SQL.append(" AND role = ? ");
			params.add(searchDTO.getUserRole());
		}
	}

	// condition 모드 필터 (createdTime/buyCount/sellCount)
	private void appendConditionFilters(StringBuilder SQL, List<Object> params, SearchDTO searchDTO) {
		if (searchDTO.getStartTime() != null && searchDTO.getEndTime() != null) {
			SQL.append(" AND created_time BETWEEN ? AND ? ");
			params.add(searchDTO.getStartTime());
			params.add(searchDTO.getEndTime());
		}
		if (searchDTO.getMinBuyCount() != null && searchDTO.getMaxBuyCount() != null) {
			SQL.append(" AND buy_count BETWEEN ? AND ? ");
			params.add(searchDTO.getMinBuyCount());
			params.add(searchDTO.getMaxBuyCount());
		}
		if (searchDTO.getMinSellCount() != null && searchDTO.getMaxSellCount() != null) {
			SQL.append(" AND sell_count BETWEEN ? AND ? ");
			params.add(searchDTO.getMinSellCount());
			params.add(searchDTO.getMaxSellCount());
		}
	}

	@Override
	public User getUserById(String userId) {
		String SQL = "SELECT * FROM users WHERE id = ?";
		List<User> userByIdTemp = template.query(SQL, new UserRowMapper(), userId);
		if (userByIdTemp.isEmpty()) {
			return null;
		}
		return userByIdTemp.get(0);
	}

	@Override
	public User getUserByNickName(String userNickName) {
		String SQL = "SELECT * FROM users WHERE nickname = ?";
		List<User> userByNickNameTemp = template.query(SQL, new UserRowMapper(), userNickName);
		if (userByNickNameTemp.isEmpty()) {
			return null;
		}
		return userByNickNameTemp.get(0);
	}

	@Override
	public List<User> getUserByAge(int startUserAge, int endUserAge) {
		String SQL = "SELECT * FROM users WHERE age BETWEEN ? and ?";
		return template.query(SQL, new UserRowMapper(), startUserAge, endUserAge);
	}

	@Override
	public List<User> getUserByAddress(String userAddress) {
		String SQL = "SELECT * FROM users WHERE address = ?";
		return template.query(SQL, new UserRowMapper(), userAddress);
	}

	@Override
	public List<User> getUserByGrade(String userGrade) {
		String SQL = "SELECT * FROM users WHERE grade = ?";
		return template.query(SQL, new UserRowMapper(), userGrade);
	}

	@Override
	public List<User> getUserByCreatedTime(LocalDateTime startTime, LocalDateTime endTime) {
		String SQL = "SELECT * FROM users WHERE created_time BETWEEN ?, ?";
		return template.query(SQL, new UserRowMapper(), startTime, endTime);
	}

	@Override
	public List<User> getUserByBuyCount(int minCount, int maxCount) {
		String SQL = "SELECT * FROM users WHERE buy_count BETWEEN ? and ?";
		return template.query(SQL, new UserRowMapper(), minCount, maxCount);
	}

	@Override
	public List<User> getUserBySellCount(int minCount, int maxCount) {
		String SQL = "SELECT * FROM users WHERE sell_count BETWEEN ? and ?";
		return template.query(SQL, new UserRowMapper(), minCount, maxCount);
	}

	// 동네 인증까지
	@Override
	public void setNewUser(User newUser) {

		String SQL = "INSERT INTO users(" + "id, pw, name, nickname, age, address, phone, "
				+ "latitude, longitude, verified_area, verified_at" + ") VALUES(?,?,?,?,?,?,?,?,?,?,?)";

		template.update(SQL, newUser.getUserId(), newUser.getUserPw(), newUser.getUserName(), newUser.getUserNickName(),
				newUser.getUserAge(), newUser.getUserAddress(), newUser.getUserPhone(), newUser.getLatitude(),
				newUser.getLongitude(), newUser.getVerifiedArea(), newUser.getVerifiedAt());

		Integer lastId = template.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);

		if (lastId != null) {
			newUser.setUserNo(lastId);
		}
	}

	// 동네 인증포함
	@Override
	public void setEditUser(User editUser) {

		String SQL = "UPDATE users SET " + "id=?, pw=?, name=?, nickname=?, age=?, address=?, phone=?, "
				+ "latitude=?, longitude=?, verified_area=?, verified_at=? " + "WHERE user_no=?";

		template.update(SQL, editUser.getUserId(), editUser.getUserPw(), editUser.getUserName(),
				editUser.getUserNickName(), editUser.getUserAge(), editUser.getUserAddress(), editUser.getUserPhone(),
				editUser.getLatitude(), editUser.getLongitude(), editUser.getVerifiedArea(), editUser.getVerifiedAt(),
				editUser.getUserNo());
	}

	@Override
	public void setDeleteUser(int userNo) {
		String SQL = "DELETE FROM users WHERE user_no = ?";
		template.update(SQL, userNo);
	}

	// 이메일로 유저 조회 (id 컬럼에 이메일 저장)
	public User findByEmail(String email) {
		String SQL = "select * from users where id = ?";
		List<User> result = template.query(SQL, new UserRowMapper(), email);
		return result.isEmpty() ? null : result.get(0);
	}

	public void insertOAuthUser(User user) {
		String uniqueNickname = user.getUserNickName() + "_" + user.getUserId().replace("kakao_", "");
		String SQL = "INSERT INTO users(id, pw, name, nickname) VALUES(?, ?, ?, ?)";
		template.update(SQL, user.getUserId(), "OAUTH_NO_PW", // pw 기본값
				user.getUserNickName() != null ? user.getUserNickName() : "소셜유저", // name 기본값
				uniqueNickname);

		Integer lastId = template.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
		if (lastId != null) {
			user.setUserNo(lastId);
		}
	}

	@Override
	public void updateAccount(int userNo, String bankName, String accountNumber, String accountHolder) {
		String SQL = "UPDATE users SET bank_name = ?, account_number = ?, account_holder = ? WHERE user_no = ?";
		template.update(SQL, bankName, accountNumber, accountHolder, userNo);
	}

	@Override
	public void updateRiskScore(int userNo, double score) {
		String sql = "UPDATE users SET risk_score = GREATEST(LEAST(risk_score + ?, 10), 0) WHERE user_no = ?";
		int rows = template.update(sql, score, userNo);
		System.out.println("updateRiskScore SQL 실행완료 - userNo=" + userNo + ", score=" + score + ", affected rows=" + rows);
	}

	@Override
	public List<User> findAdmins() {
		String SQL = "select * from users where role = 'ROLE_ADMIN'";
		return template.query(SQL, new UserRowMapper());
	}

	@Override
	public void addRiskScore(int userNo, double delta) {
		String SQL = "UPDATE users SET risk_score = GREATEST(LEAST(risk_score + ?, 10), 0) WHERE user_no = ?";
		template.update(SQL, delta, userNo);
	}

	// 제재 상태 업데이트
	@Override
	public void updateSuspension(int userNo, Timestamp until, int level, Timestamp deadline) {
		String SQL = "UPDATE users SET suspend_until = ?, suspend_level = ?, appeal_deadline = ? WHERE user_no = ?";
		template.update(SQL, until, level, deadline, userNo);
	}

	@Override
	public Double getRiskScore(int userNo) {
		String sql = "SELECT risk_score FROM users WHERE user_no = ?";
		try {
			return template.queryForObject(sql, Double.class, userNo);
		} catch (EmptyResultDataAccessException e) {
			return 0.0;
		}
	}
}