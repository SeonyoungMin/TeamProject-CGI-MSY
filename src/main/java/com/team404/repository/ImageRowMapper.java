package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.team404.domain.Image;

public class ImageRowMapper implements RowMapper<Image> {
	public Image mapRow(ResultSet rs, int rowNum) throws SQLException {
		
		Image image = new Image();
		image.setImageNo(rs.getInt("image_no"));
		image.setFileName(rs.getString("file_name"));
		image.setFilePath(rs.getString("file_path"));
		image.setEntitlyType(rs.getString("entity_type"));
		image.setEntityId(rs.getInt("entity_id"));
		image.setIsThumnail(rs.getInt("is_thumbnail"));
		image.setCreatedTime(rs.getTimestamp("created_time"));
		return image;
	}

}
