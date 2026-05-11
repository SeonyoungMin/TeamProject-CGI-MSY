package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.team404.domain.Comment;

@Repository
public class CommentRepositoryImpl implements CommentRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// RowMapper
	private final RowMapper<Comment> commentRowMapper = new RowMapper<Comment>() {
		@Override
		public Comment mapRow(ResultSet rs, int rowNum) throws SQLException {
			Comment c = new Comment();
			c.setCommentNo(rs.getInt("comment_no"));
			c.setContent(rs.getString("content"));
			c.setBoardNo(rs.getInt("board_no"));
			c.setAuthorNo(rs.getInt("author_no"));
			c.setCreatedTime(rs.getString("created_time"));
			c.setNickname(rs.getString("nickname"));
			return c;
		}
	};

	// 댓글 목록 조회
	@Override
	public List<Comment> findByBoard(int boardNo) {
		String sql = "SELECT c.comment_no, c.content, c.board_no, c.author_no, c.created_time, u.nickname "
				+ "FROM comment c LEFT JOIN users u ON c.author_no = u.user_no "
				+ "WHERE c.board_no = ? ORDER BY c.comment_no DESC";
		return jdbcTemplate.query(sql, commentRowMapper, boardNo);
	}

	// 댓글 작성
	@Override
	public int insert(Comment c) {
		String sql = "INSERT INTO comment (content, board_no, author_no) VALUES (?, ?, ?)";
		return jdbcTemplate.update(sql, c.getContent(), c.getBoardNo(), c.getAuthorNo());
	}

	// 댓글 수정
	@Override
	public int update(Comment c) {
		String sql = "UPDATE comment SET content = ? WHERE comment_no = ?";
		return jdbcTemplate.update(sql, c.getContent(), c.getCommentNo());
	}

	// 댓글 한 개 조회
	@Override
	public Comment findByCommentNo(int commentNo) {
		String sql = "SELECT c.comment_no, c.content, c.board_no, c.author_no, c.created_time, u.nickname "
				+ "FROM comment c LEFT JOIN users u ON c.author_no = u.user_no " + "WHERE c.comment_no = ?";
		return jdbcTemplate.queryForObject(sql, commentRowMapper, commentNo);
	}

	// 댓글 삭제
	@Override
	public int delete(int commentNo) {
		String sql = "DELETE FROM comment WHERE comment_no = ?";
		return jdbcTemplate.update(sql, commentNo);
	}
}
