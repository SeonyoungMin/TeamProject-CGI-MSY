package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.team404.domain.Image;
import com.team404.service.ImageService;



//board와 user, product 기능과 병합했을때 쓰이는 API구조 url이 지금 테스트 jsp구조와 맞지 않음 , 테스트는 완료 상태 




@RestController
@RequestMapping("/api/images")
public class ImageController {

	@Autowired
	private ImageService imageService;

	// =========================
	// 이미지 목록 조회
	// =========================
	@GetMapping
	public List<Image> list(@RequestParam String entityType, @RequestParam int entityId) {

		return imageService.getImages(entityType, entityId);
	}

	// =========================
	// 이미지 업로드
	// =========================
	@PostMapping("/upload")
	public void upload(@RequestParam List<org.springframework.web.multipart.MultipartFile> files,
			@RequestParam String entityType, @RequestParam int entityId) {

		imageService.upload(files, entityType, entityId);
	}

	// =========================
	// 대표 이미지 설정
	// =========================
	@PutMapping("/{imageNo}/thumbnail")
	public void setThumbnail(@PathVariable int imageNo, @RequestParam String entityType, @RequestParam int entityId) {

		imageService.setThumbnail(imageNo, entityType, entityId);
	}

	// =========================
	// 대표 이미지 해제
	// =========================
	@DeleteMapping("/thumbnail")
	public void cancelThumbnail(@RequestParam String entityType, @RequestParam int entityId) {

		imageService.cancelThumbnail(entityType, entityId);
	}

	// =========================
	// 이미지 삭제
	// =========================
	@DeleteMapping("/{imageNo}")
	public void delete(@PathVariable int imageNo) {

		imageService.delete(imageNo);
	}
}