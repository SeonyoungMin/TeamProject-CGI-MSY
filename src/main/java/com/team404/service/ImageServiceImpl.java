package com.team404.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.repository.ImageRepository;

@Service
public class ImageServiceImpl implements ImageService {

	@Autowired
	private ImageRepository imageRepository;

	@Autowired
	private ImgBBService imgBBService; // ImgBB 연동 서비스 주입

	// 이미지 업로드 (ImgBB 클라우드 전송)
	@Override
	public void upload(List<MultipartFile> files, String entityType, int entityId) {

		// 해당 엔티티에 이미 이미지가 있는지 확인 (첫 이미지 자동 썸네일 지정용)
		boolean hasExisting = !imageRepository.findByEntity(entityType, entityId).isEmpty();
		boolean isFirstUpload = !hasExisting;

		System.out.println("[ImageService] upload 호출 - files 개수: " + (files == null ? "null" : files.size())
				+ " / entity: " + entityType + "/" + entityId);

		for (MultipartFile file : files) {
			if (file == null || file.isEmpty()) {
				System.out.println("[ImageService] 빈 파일 건너뜀");
				continue;
			}

			try {
				String cloudUrl = imgBBService.upload(file);

				Image img = new Image();
				img.setFileName(file.getOriginalFilename());
				img.setFilePath(cloudUrl);
				img.setEntityType(entityType);
				img.setEntityId(entityId);
				img.setThumbnail(isFirstUpload);
				if (isFirstUpload) {
					isFirstUpload = false;
				}

				imageRepository.insert(img);
				System.out.println("[ImageService] DB 저장 완료: " + cloudUrl);

			} catch (Exception e) {
				System.out.println("[ImageService] 업로드/DB저장 실패 - " + e.getClass().getSimpleName()
						+ ": " + e.getMessage());
				e.printStackTrace(System.out);
			}
		}
	}

	// 이미지 목록 조회
	@Override
	public List<Image> getImages(String entityType, int entityId) {
		return imageRepository.findByEntity(entityType, entityId);
	}

	// 이미지 단건 삭제
	@Override
	public void delete(int imageNo) {

		imageRepository.delete(imageNo);
	}

	// 엔티티 단위 일괄 삭제
	@Override
	public void deleteByEntity(String entityType, int entityId) {
		List<Image> images = imageRepository.findByEntity(entityType, entityId);

		for (Image img : images) {
			imageRepository.delete(img.getImageNo());
		}
	}

	// 대표 이미지(썸네일) 설정
	@Override
	public void setThumbnail(int imageNo, String entityType, int entityId) {
		imageRepository.resetThumbnail(entityType, entityId);
		imageRepository.setThumbnail(imageNo);
	}

	// 대표 이미지 해제
	@Override
	public void cancelThumbnail(String entityType, int entityId) {
		imageRepository.resetThumbnail(entityType, entityId);
	}
}