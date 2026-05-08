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

	// 문의글 등록
	public int insertBoard(Board board) {
		String SQL = "insert into board (title, content, author_no, board_type, created_time) "
				+ "values(?, ?, ?, ?, NOW())";
		KeyHolder keyHolder = new GeneratedKeyHolder();
		template.update(con -> {
			PreparedStatement ps = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, board.getTitle());
//			ps.setString(2, board.getCategory());
			ps.setString(2, board.getContent());
			ps.setInt(3, board.getAuthorNo());
			//boardType이 비어있다면 기본값으로 'inquiry'를 넣어주는 방어코드 /나중을 대비해서 만듦
			String type = (board.getBoardType() == null) ? "inquiry" : board.getBoardType();
	        ps.setString(4, type);
			return ps;
		}, keyHolder);

		return keyHolder.getKey().intValue();
	}

	// 문의글 전체 조회
	public List<BoardListDto> findAllBoard(int startNum, int limit) {
		String SQL = "select b.board_no, b.title, b.created_time, " + "u.nickname as author_nickname " + "from board b "
				+ "left join users u on u.user_no = b.author_no " + "where b.board_type = 'inquiry' "
				+ "order by b.created_time desc limit ?, ?";
		return template.query(SQL, new BoardListRowMapper(), startNum, limit);
	}
	
	//전체조회 페이징
	public int countAllBoard() {
		String SQL = "select count(*) from board where board_type = 'inquiry'";
		return template.queryForObject(SQL, Integer.class);
	}


	// 문의글 상세 조회
	public BoardDetailDto findBoardDetail(int boardNo) {
		String SQL = "select b.board_no, b.title, b.content, " + "b.author_no, b.created_time, "
				+ "u.nickname as author_nickname " + "from board b " + "left join users u on u.user_no = b.author_no "
				+ "where b.board_no = ?";
		return template.queryForObject(SQL, new BoardDetailRowMapper(), boardNo);
	}

	// 문의글 수정 (본인 확인 필요)
	public void updateBoard(Board board) {
		String SQL = "update board set title = ?, content = ? where board_no = ?";
		board.getBoardNo();
		template.update(SQL, board.getTitle(), board.getContent(), board.getBoardNo());
	}

	public int findAuthorNo(int boardNo) { // 본인 확인용
		String SQL = "select author_no from board where board_no = ?";
		List<Integer> result = template.query(SQL, (rs, rowNum) -> rs.getInt("author_no"), boardNo);
		return result.isEmpty() ? 0 : result.get(0);
	}

	// 문의글 삭제 (본인 확인 필요)
	public void deleteBoard(int boardNo) {
		String SQL = "delete from board where board_no = ?";
		template.update(SQL, boardNo);
	}

}
