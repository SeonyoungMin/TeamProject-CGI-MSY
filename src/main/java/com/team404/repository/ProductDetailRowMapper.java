package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.ProductDetailDTO;

public class ProductDetailRowMapper implements RowMapper<ProductDetailDTO> {
	public ProductDetailDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		ProductDetailDTO productDetailDto = new ProductDetailDTO();
		productDetailDto.setProductNo(rs.getInt("product_no"));
		productDetailDto.setProductName(rs.getString("name"));
		productDetailDto.setCategory(rs.getString("category"));
		productDetailDto.setPrice(rs.getLong("price"));
		productDetailDto.setDescription(rs.getString("description"));
		productDetailDto.setTradeStatus(rs.getString("trade_status"));
		productDetailDto.setCreatedTime(rs.getTimestamp("created_time"));
		productDetailDto.setSellerNo(rs.getInt("seller_no"));
		productDetailDto.setBuyerNo(rs.getInt("buyer_no"));
		productDetailDto.setSellerNickname(rs.getString("seller_nickname"));
		productDetailDto.setImgName(rs.getString("img_name"));
		productDetailDto.setImgPath(rs.getString("img_path"));
		
		return productDetailDto;
	}

}
