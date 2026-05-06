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

	// =========================
	// RowMapper
	// =========================
	private final RowMapper<Comment> commentRowMapper = new RowMapper<Comment>() {
		@Override
		public Comment mapRow(ResultSet rs, int rowNum) throws SQLException {

			Comment c = new Comment();
			c.setCommentNo(rs.getInt("comment_no"));
			c.setContent(rs.getString("content"));
			c.setBoardNo(rs.getInt("board_no"));
			c.setAuthorNo(rs.getInt("author_no"));
			c.setCreatedTime(rs.getTimestamp("created_time"));

			// nickname은 JOIN 있을 때만
			try {
				c.setNickname(rs.getString("nickname"));
			} catch (Exception e) {
			}

			return c;
		}
	};

	// =========================
	// 댓글 조회
	// =========================
	@Override
	public List<Comment> findByBoard(int boardNo) {

		String sql = """
					SELECT c.*, u.nickname
					FROM comment c
					JOIN users u ON c.author_no = u.user_no
					WHERE c.board_no = ?
					ORDER BY c.comment_no DESC
				""";

		return jdbcTemplate.query(sql, commentRowMapper, boardNo);
	}

	// =========================
	// 댓글 작성
	// =========================
	@Override
	public int insert(Comment c) {

		String sql = "INSERT INTO comment (content, board_no, author_no) VALUES (?, ?, ?)";

		return jdbcTemplate.update(sql, c.getContent(), c.getBoardNo(), c.getAuthorNo());
	}

	// =========================
	// 댓글 수정
	// =========================
	@Override
	public int update(Comment c) {

		String sql = "UPDATE comment SET content = ? WHERE comment_no = ?";

		return jdbcTemplate.update(sql, c.getContent(), c.getCommentNo());
	}

	// =========================
	// 특정 댓글 한 개 조회 (수정 폼용)
	// =========================
	@Override
	public Comment findByCommentNo(int commentNo) {
		String sql = "SELECT * FROM comment WHERE comment_no = ?";
		return jdbcTemplate.queryForObject(sql, commentRowMapper, commentNo);
	}

	// =========================
	// 댓글 삭제
	// =========================
	@Override
	public int delete(int commentNo) {

		String sql = "DELETE FROM comment WHERE comment_no = ?";

		return jdbcTemplate.update(sql, commentNo);
	}
}