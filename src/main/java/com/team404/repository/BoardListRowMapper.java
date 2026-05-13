package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.BoardListDto;

public class BoardListRowMapper implements RowMapper<BoardListDto> {
	public BoardListDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		BoardListDto dto = new BoardListDto();
		dto.setBoardNo(rs.getInt("board_no"));
		dto.setTitle(rs.getString("title"));
		dto.setCreatedTime(rs.getTimestamp("created_time"));
		dto.setAuthorNickname(rs.getString("author_nickname"));
		dto.setBoardType(rs.getString("board_type"));
		dto.setPinned(rs.getBoolean("pinned"));

		return dto;
	}

}
