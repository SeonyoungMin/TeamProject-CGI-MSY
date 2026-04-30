package com.team404.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
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

	// =========================
	// RowMapper
	// =========================
	private final RowMapper<Image> imageRowMapper = new RowMapper<Image>() {
		@Override
		public Image mapRow(ResultSet rs, int rowNum) throws SQLException {

			Image img = new Image();

			img.setImageNo(rs.getInt("image_no"));
			img.setFileName(rs.getString("file_name"));
			img.setFilePath(rs.getString("file_path"));
			img.setEntityType(rs.getString("entity_type"));
			img.setEntityId(rs.getInt("entity_id"));
			img.setThumbnail(rs.getBoolean("is_thumbnail"));
			img.setCreatedTime(rs.getTimestamp("created_time"));

			return img;
		}
	};

	// =========================
	// INSERT
	// =========================
	@Override
	public void insert(Image image) {

		String sql = "INSERT INTO image " + "(file_name, file_path, entity_type, entity_id, is_thumbnail) "
				+ "VALUES (?, ?, ?, ?, ?)";

		jdbcTemplate.update(sql, image.getFileName(), image.getFilePath(), image.getEntityType(), image.getEntityId(),
				image.Thumbnail());
	}

	// =========================
	// 이미지 목록 조회
	// =========================
	@Override
	public List<Image> findByEntity(String entityType, int entityId) {

		String sql = "SELECT * FROM image " + "WHERE entity_type = ? AND entity_id = ? " + "ORDER BY image_no DESC";

		return jdbcTemplate.query(sql, imageRowMapper, entityType, entityId);
	}

	// =========================
	// 삭제
	// =========================
	@Override
	public void delete(int imageNo) {

		String sql = "DELETE FROM image WHERE image_no = ?";

		jdbcTemplate.update(sql, imageNo);
	}

	// =========================
	// 대표이미지 전체 초기화
	// =========================
	@Override
	public void resetThumbnail(String entityType, int entityId) {

		String sql = "UPDATE image SET is_thumbnail = FALSE " + "WHERE entity_type = ? AND entity_id = ?";

		jdbcTemplate.update(sql, entityType, entityId);
	}

	// =========================
	// 대표이미지 1개 설정
	// =========================
	@Override
	public void setThumbnail(int imageNo) {

		String sql = "UPDATE image SET is_thumbnail = TRUE " + "WHERE image_no = ?";

		jdbcTemplate.update(sql, imageNo);
	}
}