package com.team404.repository;
 
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.BoardDetailDto;
 
public class BoardDetailRowMapper implements RowMapper<BoardDetailDto> {
 
	public BoardDetailDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		BoardDetailDto dto = new BoardDetailDto();
		dto.setBoardNo(rs.getInt("board_no"));
		dto.setTitle(rs.getString("title"));
		dto.setContent(rs.getString("content"));
		dto.setAuthorNo(rs.getInt("author_no"));
		dto.setCreatedTime(rs.getTimestamp("created_time"));
		dto.setAuthorNickname(rs.getString("author_nickname"));
		return dto;
	}
}