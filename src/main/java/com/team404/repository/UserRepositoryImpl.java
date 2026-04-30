package com.team404.repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.SearchDTO;
import com.team404.domain.User;

@Repository
public class UserRepositoryImpl implements UserRepository {

	@Autowired
	JdbcTemplate template;

	void setJdbcTemplate(DataSource dataSource) {
		template = new JdbcTemplate(dataSource);
	}

	@Override
	public List<User> getAllUsers() {
		String SQL = "SELECT * FROM users";
		List<User> allUsers = template.query(SQL, new UserRowMapper());
		System.out.println("all 조회 쿼리문 실행");
		return allUsers;
	}

	@Override
	public User getUserByNo(int userNo) {
		String SQL = "SELECT * FROM users WHERE user_no = ?";
		List<User> userByNoTemp = template.query(SQL, new UserRowMapper(), userNo);
		System.out.println("one 조회 쿼리문 실행");

		if (userByNoTemp.isEmpty()) {
			return null;
		}

		User userByNo = userByNoTemp.get(0);
		return userByNo;
	}

	@Override
	public List<User> searchUserByInfo(SearchDTO searchDTO) {
		StringBuilder SQL = new StringBuilder("SELECT * FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();

		if (searchDTO.getUserId() != null && !searchDTO.getUserId().isEmpty()) {
			SQL.append(" AND id LIKE ? ");
			params.add(searchDTO.getUserId() + "%");
			System.out.println("1개 AND 추가 실행");
		}

		if (searchDTO.getUserName() != null && !searchDTO.getUserName().isEmpty()) {
			SQL.append(" AND name LIKE ? ");
			params.add(searchDTO.getUserName() + "%");
			System.out.println("1개 AND 추가 실행");
		}

		if (searchDTO.getUserAddress() != null && !searchDTO.getUserAddress().isEmpty()) {
			SQL.append(" AND address LIKE ? ");
			params.add("%" + searchDTO.getUserAddress() + "%");
			System.out.println("1개 AND 추가 실행");
		}

		if (searchDTO.getUserPhone() != null && !searchDTO.getUserPhone().isEmpty()) {
			SQL.append(" AND phone LIKE ? ");
			params.add("%" + searchDTO.getUserPhone() + "%");
			System.out.println("1개 AND 추가 실행");
		}

		if (searchDTO.getUserRole() != null && !searchDTO.getUserRole().isEmpty()) {
			SQL.append(" AND role = ? ");
			params.add(searchDTO.getUserRole());
			System.out.println("1개 AND 추가 실행");
		}

		List<User> userByInfo = template.query(SQL.toString(), new UserRowMapper(), params.toArray());
		System.out.println("최종 some (info) 쿼리문 실행");
		System.out.println("-------------");
		return userByInfo;
	}

	@Override
	public List<User> searchUserByCondition(SearchDTO searchDTO) {
		StringBuilder SQL = new StringBuilder("SELECT * FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();

		if (searchDTO.getStartTime() != null && searchDTO.getEndTime() != null) {
			SQL.append(" AND created_time BETWEEN ? AND ? ");
			params.add(searchDTO.getStartTime());
			params.add(searchDTO.getEndTime());
			System.out.println("1개 AND 추가 실행");
		}

		if (searchDTO.getMinBuyCount() != null && searchDTO.getMaxBuyCount() != null) {
			SQL.append(" AND buy_count BETWEEN ? AND ? ");
			params.add(searchDTO.getMinBuyCount());
			params.add(searchDTO.getMaxBuyCount());
			System.out.println("1개 AND 추가 실행");
		}

		if (searchDTO.getMinSellCount() != null && searchDTO.getMaxSellCount() != null) {
			SQL.append(" AND sell_count BETWEEN ? AND ? ");
			params.add(searchDTO.getMinSellCount());
			params.add(searchDTO.getMaxSellCount());
			System.out.println("1개 AND 추가 실행");
		}

		List<User> userByCondition = template.query(SQL.toString(), new UserRowMapper(), params.toArray());
		System.out.println("최종 some (condition) 쿼리문 실행");
		System.out.println("-------------");
		return userByCondition;
	}

	@Override
	public User getUserById(String userId) {
		String SQL = "SELECT * FROM users WHERE id = ?";
		List<User> userByIdTemp = template.query(SQL, new UserRowMapper(), userId);
		User userById = userByIdTemp.get(0);
		return userById;
	}

	@Override
	public User getUserByNickName(String userNickName) {
		String SQL = "SELECT * FROM users WHERE nickname = ?";
		List<User> userByNickNameTemp = template.query(SQL, new UserRowMapper(), userNickName);
		User userByNickName = userByNickNameTemp.get(0);
		return userByNickName;
	}

	@Override
	public List<User> getUserByAge(int startUserAge, int endUserAge) {
		String SQL = "SELECT * FROM users WHERE age BETWEEN ? and ?";
		List<User> userByAge = template.query(SQL, new UserRowMapper(), startUserAge, endUserAge);
		return userByAge;
	}

	@Override
	public List<User> getUserByAddress(String userAddress) {
		String SQL = "SELECT * FROM users WHERE address = ?";
		List<User> userByAddress = template.query(SQL, new UserRowMapper(), userAddress);
		return userByAddress;
	}

	@Override
	public List<User> getUserByGrade(String userGrade) {
		String SQL = "SELECT * FROM users WHERE grade = ?";
		List<User> userByGrade = template.query(SQL, new UserRowMapper(), userGrade);
		return userByGrade;
	}

	@Override
	public List<User> getUserByCreatedTime(LocalDateTime startTime, LocalDateTime endTime) {
		String SQL = "SELECT * FROM users WHERE created_time BETWEEN ?, ?";
		List<User> userByCreatedTime = template.query(SQL, new UserRowMapper(), startTime, endTime);
		return userByCreatedTime;
	}

	@Override
	public List<User> getUserByBuyCount(int minCount, int maxCount) {
		String SQL = "SELECT * FROM users WHERE buy_count BETWEEN ? and ?";
		List<User> userByBuyCount = template.query(SQL, new UserRowMapper(), minCount, maxCount);
		return userByBuyCount;
	}

	@Override
	public List<User> getUserBySellCount(int minCount, int maxCount) {
		String SQL = "SELECT * FROM users WHERE sell_count BETWEEN ? and ?";
		List<User> userBySellCount = template.query(SQL, new UserRowMapper(), minCount, maxCount);
		return userBySellCount;
	}

	@Override
	public void setNewUser(User newUser) {
		String SQL = "INSERT INTO users(id, pw, name, nickname, age, address, phone) VALUES(?,?,?,?,?,?,?)";
		template.update(SQL, newUser.getUserId(), newUser.getUserPw(), newUser.getUserName(), newUser.getUserNickName(),
				newUser.getUserAge(), newUser.getUserAddress(), newUser.getUserPhone());
//		String SQLforImg = "INSERT INTO image(file_name, file_path, entity_type) VALUES(?, ?, ?)";
//		template.update(SQLforImg, newUser.getUserImageName(), newUser.getUserImagePath(), "user");
	}

	@Override
	public void setEditUser(User editUser) {
		String SQL = "UPDATE users SET id = ?, pw = ?, name = ?, nickname = ?, age = ?, address = ?, phone = ? WHERE user_no = ?";
		template.update(SQL, editUser.getUserId(), editUser.getUserPw(), editUser.getUserName(),
				editUser.getUserNickName(), editUser.getUserAge(), editUser.getUserAddress(), editUser.getUserPhone(),
				editUser.getUserNo());
//		String SQLforDeleteImg = "DELETE FROM image WHERE entity_id = ? AND entity_type = ?";
//		template.update(SQLforDeleteImg, editUser.getUserNo(), "user");
//		String SQLforInsertImg = "INSERT INTO image(file_name, file_path, entity_type) VALUES(?, ?, ?)";
//		template.update(SQLforInsertImg, editUser.getUserImageName(), editUser.getUserImagePath(), "user");
	}

	@Override
	public void setDeleteUser(int userNo) {
		System.out.println(userNo);
		String SQL = "DELETE FROM users WHERE user_no = ?";
		template.update(SQL, userNo);
	}
}
