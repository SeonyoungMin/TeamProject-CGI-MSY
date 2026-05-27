package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.Product;

public class ProductRowMapper implements RowMapper<Product> {
	public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		Product product = new Product();
		product.setProductNo(rs.getInt("product_no"));
		product.setProductName(rs.getNString("name"));
		product.setCategory(rs.getNString("category"));
		product.setPrice(rs.getLong("price"));
		product.setDescription(rs.getNString("description"));
		product.setTradeStatus(rs.getNString("trade_status"));
		product.setCreatedTime(rs.getTimestamp("created_time"));
		return product;
	}

}