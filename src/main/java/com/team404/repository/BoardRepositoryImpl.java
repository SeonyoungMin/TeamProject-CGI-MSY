package com.team404.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.team404.domain.Board;
import com.team404.domain.BoardDetailDto;
import com.team404.domain.BoardListDto;

@Repository
public class BoardRepositoryImpl implements BoardRepository {

	@Autowired
	private JdbcTemplate template;

	// 게시글 등록
	public int insertBoard(Board board) {
		String SQL = "insert into board (title, content, author_no, board_type, pinned, created_time) "
				+ "values(?, ?, ?, ?, ?, NOW())";
		KeyHolder keyHolder = new GeneratedKeyHolder();
		template.update(con -> {
			PreparedStatement ps = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, board.getTitle());
			ps.setString(2, board.getContent());
			ps.setInt(3, board.getAuthorNo());
			// boardType 비어있으면 inquiry 기본값
			String type = (board.getBoardType() == null) ? "inquiry" : board.getBoardType();
			ps.setString(4, type);
			ps.setBoolean(5, board.isPinned());
			return ps;
		}, keyHolder);
		return keyHolder.getKey().intValue();
	}

	// 문의글 전체 목록
	public List<BoardListDto> findAllBoard(int startNum, int limit) {
		String SQL = "select b.board_no, b.title, b.board_type, b.pinned, b.created_time, u.nickname as author_nickname "
				+ "from board b " + "left join users u on u.user_no = b.author_no " + "where b.board_type = 'inquiry' "
				+ "order by b.pinned desc, b.created_time desc limit ?, ?";
		return template.query(SQL, new BoardListRowMapper(), startNum, limit);
	}

	// 문의글 총 개수
	public int countAllBoard() {
		String SQL = "select count(*) from board where board_type = 'inquiry'";
		return template.queryForObject(SQL, Integer.class);
	}

	// 타입별 목록 (inquiry / notice / free)
	public List<BoardListDto> findByType(String boardType, int startNum, int limit) {
		String SQL = "select b.board_no, b.title, b.board_type, b.pinned, b.created_time, u.nickname as author_nickname "
				+ "from board b " + "left join users u on u.user_no = b.author_no " + "where b.board_type = ? "
				+ "order by b.pinned desc, b.created_time desc limit ?, ?";
		return template.query(SQL, new BoardListRowMapper(), boardType, startNum, limit);
	}

	// 타입별 총 개수
	public int countByType(String boardType) {
		String SQL = "select count(*) from board where board_type = ?";
		return template.queryForObject(SQL, Integer.class, boardType);
	}

	// 전체 게시글 통합 조회 (공지/문의/자유, review 제외)
	public List<BoardListDto> findRecentAll(int startNum, int limit) {
		String SQL = "select b.board_no, b.title, b.board_type, b.pinned, b.created_time, u.nickname as author_nickname "
				+ "from board b " + "left join users u on u.user_no = b.author_no "
				+ "where b.board_type in ('notice', 'inquiry', 'free') "
				+ "order by b.pinned desc, b.created_time desc limit ?, ?";
		return template.query(SQL, new BoardListRowMapper(), startNum, limit);
	}

	// 전체 게시글 개수 (공지/문의/자유)
	public int countRecentAll() {
		String SQL = "select count(*) from board where board_type in ('notice', 'inquiry', 'free')";
		return template.queryForObject(SQL, Integer.class);
	}

	// 게시글 상세
	public BoardDetailDto findBoardDetail(int boardNo) {
		String SQL = "select b.board_no, b.title, b.content, b.board_type, b.pinned, "
				+ "b.author_no, b.created_time, u.nickname as author_nickname "
				+ "from board b left join users u on u.user_no = b.author_no " + "where b.board_no = ?";
		return template.queryForObject(SQL, new BoardDetailRowMapper(), boardNo);
	}

	// 게시글 수정
	public void updateBoard(Board board) {
		String SQL = "update board set title = ?, content = ?, board_type = ?, pinned = ? where board_no = ?";
		template.update(SQL, board.getTitle(), board.getContent(), board.getBoardType(), board.isPinned(),
				board.getBoardNo());
	}

	// 작성자 번호 조회 (본인 확인용)
	public int findAuthorNo(int boardNo) {
		String SQL = "select author_no from board where board_no = ?";
		List<Integer> result = template.query(SQL, (rs, rowNum) -> rs.getInt("author_no"), boardNo);
		return result.isEmpty() ? 0 : result.get(0);
	}

	// 게시글 삭제
	public void deleteBoard(int boardNo) {
		String SQL = "delete from board where board_no = ?";
		template.update(SQL, boardNo);
	}
}
