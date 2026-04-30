package com.team404.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import com.team404.domain.Image;

@Repository
public class ImageRepositoryImpl implements ImageRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	private final RowMapper<Image> imageRowMapper = (rs, rowNum) -> {
		Image img = new Image();
		img.setImageNo(rs.getInt("image_no"));
		img.setFileName(rs.getString("file_name"));
		img.setFilePath(rs.getString("file_path"));
		img.setEntityType(rs.getString("entity_type"));
		img.setEntityId(rs.getInt("entity_id"));
		img.setThumbnail(rs.getBoolean("is_thumbnail"));
		return img;
	};

	@Override
	public void insert(Image image) {
		String sql = "INSERT INTO image (file_name, file_path, entity_type, entity_id, is_thumbnail) VALUES (?, ?, ?, ?, ?)";
		jdbcTemplate.update(sql, image.getFileName(), image.getFilePath(), image.getEntityType(), image.getEntityId(),
				image.Thumbnail());
	}

	@Override
	public List<Image> findByEntity(String entityType, int entityId) {
		String sql = "SELECT * FROM image WHERE entity_type = ? AND entity_id = ?";
		return jdbcTemplate.query(sql, imageRowMapper, entityType, entityId);
	}

	@Override
	public Image findByImageNo(int imageNo) {
		String sql = "SELECT * FROM image WHERE image_no = ?";
		return jdbcTemplate.queryForObject(sql, imageRowMapper, imageNo);
	}

	@Override
	public void delete(int imageNo) {
		jdbcTemplate.update("DELETE FROM image WHERE image_no = ?", imageNo);
	}

	@Override
	public void setThumbnail(int imageNo) {
		jdbcTemplate.update("UPDATE image SET is_thumbnail = 1 WHERE image_no = ?", imageNo);
	}

	@Override
	public void resetThumbnail(String entityType, int entityId) {
		jdbcTemplate.update("UPDATE image SET is_thumbnail = 0 WHERE entity_type = ? AND entity_id = ?", entityType,
				entityId);
	}
}