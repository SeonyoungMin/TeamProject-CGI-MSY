package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.team404.domain.Favorite;

@Repository
public class FavoriteRepositoryImpl implements FavoriteRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	private final RowMapper<Favorite> favoriteRowMapper = new RowMapper<Favorite>() {
		@Override
		public Favorite mapRow(ResultSet rs, int rowNum) throws SQLException {
			Favorite fav = new Favorite();
			fav.setFavoriteNo(rs.getInt("favorite_no"));
			fav.setUserNo(rs.getInt("user_no"));
			fav.setBoardNo(rs.getInt("board_no"));
			fav.setCreatedTime(rs.getTimestamp("created_time"));
			return fav;
		}
	};

	// 찜 추가
	public void insertFavorite(int userNo, int boardNo) {
		String sql = "insert into favorite (user_no, board_no) values (?,?)";
		jdbcTemplate.update(sql, userNo, boardNo);
	}

	// 찜 삭제
	public void delete(int userNo, int boardNo) {
		String sql = "DELETE FROM favorite WHERE user_no=? AND board_no=?";
		jdbcTemplate.update(sql, userNo, boardNo);
	}

	// 찜 확인
	public boolean exists(int userNo, int boardNo) {
		String sql = "SELECT COUNT(*) FROM favorite WHERE user_no=? AND board_no=?";
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userNo, boardNo);
		return count != null && count > 0;
	}

	// 특정 게시글 찜 개수
	public int countByBoard(int boardNo) {
		String sql = "SELECT COUNT(*) FROM favorite WHERE board_no=?";
		return jdbcTemplate.queryForObject(sql, Integer.class, boardNo);
	}

	// 내가 찜한 게시글 목록
	public List<Integer> findBoardNosByUser(int userNo) {
		String sql = "SELECT board_no FROM favorite WHERE user_no=?";
		return (List<Integer>) jdbcTemplate.query(sql, (rs, rowNum) -> rs.getInt("board_no"), userNo);
	}

	// 단건 조회 (필요하면)
	public Favorite findOne(int userNo, int boardNo) {
		String sql = "SELECT * FROM favorite WHERE user_no=? AND board_no=?";
		try {
			return jdbcTemplate.queryForObject(sql, favoriteRowMapper, userNo, boardNo);
		} catch (EmptyResultDataAccessException e) {
			return null;
		}
	}
}
