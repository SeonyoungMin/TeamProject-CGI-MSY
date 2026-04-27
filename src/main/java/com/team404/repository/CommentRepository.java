package com.team404.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.team404.domain.Comment;

public class CommentRepository {

	private Connection conn;

	// 🔹 이미 만들어진 DB 연결을 받아서 사용 
	public CommentRepository(Connection conn) {
		this.conn = conn;
	}

	// =========================
	// RowMapper 역할
	// =========================
	private Comment mapRow(ResultSet rs) throws Exception {

		Comment c = new Comment();

		c.setCommentNo(rs.getInt("comment_no"));
		c.setContent(rs.getString("content"));
		c.setBoardNo(rs.getInt("board_no"));
		c.setAuthorNo(rs.getInt("author_no"));
		c.setCreatedTime(rs.getTimestamp("created_time"));

		try {
			c.setNickname(rs.getString("nickname"));
		} catch (Exception e) {
			// join 없을 때 대비
		}

		return c;
	}

	// =========================
	// 댓글 목록 조회
	// =========================
	public List<Comment> findByBoard(int boardNo) throws Exception {

		String sql = "SELECT c.*, u.nickname " + "FROM comment c " + "JOIN users u ON c.author_no = u.user_no "
				+ "WHERE c.board_no = ? " + "ORDER BY c.comment_no DESC";

		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setInt(1, boardNo);

		ResultSet rs = ps.executeQuery();

		List<Comment> list = new ArrayList<>();

		while (rs.next()) {
			list.add(mapRow(rs));
		}

		rs.close();
		ps.close();

		return list;
	}

	// =========================
	// 댓글 작성
	// =========================
	public int insert(Comment c) throws Exception {

		String sql = "INSERT INTO comment (content, board_no, author_no) VALUES (?, ?, ?)";

		PreparedStatement ps = conn.prepareStatement(sql);

		ps.setString(1, c.getContent());
		ps.setInt(2, c.getBoardNo());
		ps.setInt(3, c.getAuthorNo());

		int result = ps.executeUpdate();

		ps.close();

		return result;
	}

	// =========================
	// 댓글 수정
	// =========================
	public int update(Comment c) throws Exception {

		String sql = "UPDATE comment SET content = ? WHERE comment_no = ?";

		PreparedStatement ps = conn.prepareStatement(sql);

		ps.setString(1, c.getContent());
		ps.setInt(2, c.getCommentNo());

		int result = ps.executeUpdate();

		ps.close();

		return result;
	}

	// =========================
	//  댓글 삭제
	// =========================
	public int delete(int commentNo) throws Exception {

		String sql = "DELETE FROM comment WHERE comment_no = ?";

		PreparedStatement ps = conn.prepareStatement(sql);

		ps.setInt(1, commentNo);

		int result = ps.executeUpdate();

		ps.close();

		return result;
	}
}