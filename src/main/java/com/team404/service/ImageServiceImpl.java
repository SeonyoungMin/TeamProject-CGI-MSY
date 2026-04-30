package com.team404.service;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.repository.ImageRepository;
import com.team404.service.ImageService;

@Service
public class ImageServiceImpl implements ImageService {

	@Autowired
	private ImageRepository imageRepository;

	private static final String ROOT = "C:/team404_upload/";
	private static final String URL_PREFIX = "/team404_upload/";

	// 경로 생성 규칙 메서드
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
	// 1. 이미지 업로드
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

				Image img = new Image();
				img.setFileName(originName);
				img.setFilePath(urlPath(entityType, saveName));
				img.setEntityType(entityType);
				img.setEntityId(entityId);
				img.setThumbnail(false); // 도메인의 setThumbnail(boolean) 사용

				imageRepository.insert(img);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	// =========================
	// 2. 이미지 목록 조회
	// =========================
	@Override
	public List<Image> getImages(String entityType, int entityId) {
		return imageRepository.findByEntity(entityType, entityId);
	}

	// =========================
	// 3. 이미지 삭제
	// =========================
	@Override
	public void delete(int imageNo) {
		try {
			// DB에서 이미지 정보를 먼저 조회하여 경로(filePath)를 확보
			Image img = imageRepository.findByImageNo(imageNo);

			if (img != null) {
				// DB 저장 경로에서 URL 접두어를 지워 실제 디스크 경로
				String relativePath = img.getFilePath().replace(URL_PREFIX, "");
				File file = new File(ROOT + relativePath);

				if (file.exists()) {
					file.delete(); // 실제 파일 삭제
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// DB 데이터 삭제
		imageRepository.delete(imageNo);
	}

	// =========================
	// 4. 대표 이미지(썸네일) 설정
	// =========================
	@Override
	public void setThumbnail(int imageNo, String entityType, int entityId) {
		imageRepository.resetThumbnail(entityType, entityId);
		imageRepository.setThumbnail(imageNo);
	}

	// =========================
	// 5. 대표 이미지 해제
	// =========================
	@Override
	public void cancelThumbnail(String entityType, int entityId) {
		imageRepository.resetThumbnail(entityType, entityId);
	}
}