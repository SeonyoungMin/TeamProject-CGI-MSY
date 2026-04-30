package com.team404.service;

import java.io.File;
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

	private static final String ROOT = "C:/team404_upload/";
	private static final String URL_PREFIX = "/uploads/";

	// 단일 규칙: entityType -> "{entityType}Img"
	// 디스크 폴더명과 URL 경로 segment를 같은 곳에서 파생시켜 어긋날 수 없게 함
	private String subDir(String entityType) {
		return entityType + "Img";
	}

	private String diskFolder(String entityType) {
		return ROOT + subDir(entityType) + "/";
	}

	private String urlPath(String entityType, String saveName) {
		return URL_PREFIX + subDir(entityType) + "/" + saveName;
	}

	// =========================
	// 업로드
	// =========================
	@Override
	public void upload(List<MultipartFile> files, String entityType, int entityId) {

		String folderPath = diskFolder(entityType);

		File dir = new File(folderPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}

		for (MultipartFile file : files) {

			if (file == null || file.isEmpty())
				continue;

			String originName = file.getOriginalFilename();
			String saveName = System.currentTimeMillis() + "_" + originName;

			File saveFile = new File(folderPath + saveName);

			try {
				file.transferTo(saveFile);
			} catch (Exception e) {
				e.printStackTrace();
			}

			Image img = new Image();
			img.setFileName(originName);
			img.setFilePath(urlPath(entityType, saveName));
			img.setEntityType(entityType);
			img.setEntityId(entityId);
			img.setThumbnail(false);

			imageRepository.insert(img);
		}
	}

	// =========================
	// 조회
	// =========================
	@Override
	public List<Image> getImages(String entityType, int entityId) {
		return imageRepository.findByEntity(entityType, entityId);
	}

	// =========================
	// 삭제
	// =========================
	@Override
	public void delete(int imageNo) {
		imageRepository.delete(imageNo);
	}

	// =========================
	// 썸네일
	// =========================
	@Override
	public void setThumbnail(int imageNo, String entityType, int entityId) {

		imageRepository.resetThumbnail(entityType, entityId);
		imageRepository.setThumbnail(imageNo);
	}

	// =========================
	// 썸네일 해제
	// =========================
	@Override
	public void cancelThumbnail(String entityType, int entityId) {
		imageRepository.resetThumbnail(entityType, entityId);
	}

}