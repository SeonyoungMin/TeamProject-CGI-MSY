package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.ReviewDto;

public class ReviewRowMapper implements RowMapper<ReviewDto> {
	public ReviewDto mapRow(ResultSet rs, int rowNum) throws SQLException{
		

		ReviewDto reviewDto = new ReviewDto();
		reviewDto.setBoardNo(rs.getInt("board_no"));
		reviewDto.setContent(rs.getString("content"));
		reviewDto.setProductNo(rs.getInt("product_no"));
		reviewDto.setCreatedTime(rs.getTimestamp("created_time"));
		reviewDto.setSellerNickname(rs.getString("sellerNickname"));
		reviewDto.setProductName(rs.getString("productName"));
		
		return reviewDto;
	}
}
