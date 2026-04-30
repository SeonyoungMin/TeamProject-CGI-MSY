package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.ProductListDto;

public class ProductListRowMapper implements RowMapper<ProductListDto> {
	public ProductListDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		ProductListDto productListDto = new ProductListDto();
		productListDto.setProductNo(rs.getInt("product_no"));
		productListDto.setProductName(rs.getString("name"));
		productListDto.setCategory(rs.getString("category"));
		productListDto.setPrice(rs.getLong("price"));
		productListDto.setTradeStatus(rs.getNString("trade_status"));
		productListDto.setCreatedTime(rs.getTimestamp("created_time"));
		productListDto.setSellerNo(rs.getInt("seller_no"));
		productListDto.setSellerNickname(rs.getString("seller_nickname"));
		productListDto.setImgName(rs.getString("img_name"));
		productListDto.setImgPath(rs.getString("img_path"));
		
		return productListDto;
	}
}
