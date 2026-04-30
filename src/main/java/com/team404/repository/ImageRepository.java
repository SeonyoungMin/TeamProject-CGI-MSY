package com.team404.repository;

import java.util.List;

import com.team404.domain.Image;

public interface ImageRepository {
	void insert(Image image);

	List<Image> findByEntity(String entityType, int entityId);

	void delete(int imageNo);

	void resetThumbnail(String entityType, int entityId);

	void setThumbnail(int imageNo);
}
