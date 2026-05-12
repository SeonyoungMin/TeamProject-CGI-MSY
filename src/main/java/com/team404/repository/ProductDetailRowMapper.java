package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.ProductDetailDto;

public class ProductDetailRowMapper implements RowMapper<ProductDetailDto> {
	public ProductDetailDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		ProductDetailDto productDetailDto = new ProductDetailDto();
		productDetailDto.setProductNo(rs.getInt("product_no"));
		productDetailDto.setProductName(rs.getString("name"));
		productDetailDto.setCategory(rs.getString("category"));
		productDetailDto.setPrice(rs.getLong("price"));
		productDetailDto.setDescription(rs.getString("description"));
		productDetailDto.setTradeStatus(rs.getString("trade_status"));
		productDetailDto.setCreatedTime(rs.getTimestamp("created_time"));
		productDetailDto.setSellerNo(rs.getInt("seller_no"));
		productDetailDto.setSellerNickname(rs.getString("seller_nickname"));
		productDetailDto.setImgName(rs.getString("img_name"));
		productDetailDto.setImgPath(rs.getString("img_path"));
		productDetailDto.setViewCount(rs.getInt("view_count"));
		
		return productDetailDto;
	}

}
