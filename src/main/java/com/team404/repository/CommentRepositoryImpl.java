package com.team404.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.team404.domain.Comment;

@Repository
public class CommentRepositoryImpl implements CommentRepository {

	@Autowired
	private DataSource dataSource;

	// =========================
	// RowMapper
	// =========================
	private Comment mapRow(ResultSet rs) {
		try {
			Comment c = new Comment();

			c.setCommentNo(rs.getInt("comment_no"));
			c.setContent(rs.getString("content"));
			c.setBoardNo(rs.getInt("board_no"));
			c.setAuthorNo(rs.getInt("author_no"));
			c.setCreatedTime(rs.getTimestamp("created_time"));

			try {
				c.setNickname(rs.getString("nickname"));
			} catch (Exception e) {
			}

			return c;

		} catch (Exception e) {
			throw new RuntimeException("Comment mapping 실패", e);
		}
	}

	// =========================
	// 댓글 조회
	// =========================
	@Override
	public List<Comment> findByBoard(int boardNo) {

		List<Comment> list = new ArrayList<>();

		String sql = "SELECT c.*, u.nickname " + "FROM comment c " + "JOIN users u ON c.author_no = u.user_no "
				+ "WHERE c.board_no = ? " + "ORDER BY c.comment_no DESC";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, boardNo);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(mapRow(rs));
			}

			rs.close();

		} catch (Exception e) {
			throw new RuntimeException("댓글 조회 실패", e);
		}

		return list;
	}

	// =========================
	// 댓글 작성
	// =========================
	@Override
	public int insert(Comment c) {

		String sql = "INSERT INTO comment (content, board_no, author_no) VALUES (?, ?, ?)";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, c.getContent());
			ps.setInt(2, c.getBoardNo());
			ps.setInt(3, c.getAuthorNo());

			return ps.executeUpdate();

		} catch (Exception e) {
			throw new RuntimeException("댓글 작성 실패", e);
		}
	}

	// =========================
	// 댓글 수정
	// =========================
	@Override
	public int update(Comment c) {

		String sql = "UPDATE comment SET content = ? WHERE comment_no = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, c.getContent());
			ps.setInt(2, c.getCommentNo());

			return ps.executeUpdate();

		} catch (Exception e) {
			throw new RuntimeException("댓글 수정 실패", e);
		}
	}

	// =========================
	// 댓글 삭제
	// =========================
	@Override
	public int delete(int commentNo) {

		String sql = "DELETE FROM comment WHERE comment_no = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, commentNo);

			return ps.executeUpdate();

		} catch (Exception e) {
			throw new RuntimeException("댓글 삭제 실패", e);
		}
	}
}