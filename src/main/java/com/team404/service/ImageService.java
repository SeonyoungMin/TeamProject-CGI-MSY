package com.team404.service;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.team404.domain.Image;

public interface ImageService {

	// 이미지 업로드
	void upload(List<MultipartFile> files, String entityType, int entityId);

	// 이미지 조회
	List<Image> getImages(String entityType, int entityId);

	// 이미지 삭제
	void delete(int imageNo);

	// 썸네일 설정
	void setThumbnail(int imageNo, String entityType, int entityId);

	// 썸네일 해제
	void cancelThumbnail(String entityType, int entityId);
}