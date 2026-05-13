package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.service.ImageService;

@Controller
@RequestMapping("/images")
public class ImageController {

	@Autowired
	private ImageService imageService;

	// 업로드 폼
	@GetMapping("/uploadForm")
	public String uploadForm() {
		return "image/uploadForm";
	}

	// 업로드 처리 후 목록으로
	@PostMapping("/upload")
	public String upload(@RequestParam("files") List<MultipartFile> files,
			@RequestParam("entityType") String entityType, @RequestParam("entityId") int entityId) {

		imageService.upload(files, entityType, entityId);
		return "redirect:/images/list?entityType=" + entityType + "&entityId=" + entityId;
	}

	// 이미지 목록
	@GetMapping("/list")
	public String list(@RequestParam("entityType") String entityType, @RequestParam("entityId") int entityId,
			Model model) {

		List<Image> images = imageService.getImages(entityType, entityId);
		model.addAttribute("images", images);
		model.addAttribute("entityType", entityType);
		model.addAttribute("entityId", entityId);

		return "image/list";
	}

	// 대표 이미지로 지정
	@GetMapping("/thumbnail")
	public String setThumbnail(@RequestParam("imageNo") int imageNo, @RequestParam("entityType") String entityType,
			@RequestParam("entityId") int entityId) {

		imageService.setThumbnail(imageNo, entityType, entityId);
		return "redirect:/images/list?entityType=" + entityType + "&entityId=" + entityId;
	}

	// 대표 이미지 해제
	@GetMapping("/thumbnail/cancel")
	public String cancelThumbnail(@RequestParam("entityType") String entityType,
			@RequestParam("entityId") int entityId) {

		imageService.cancelThumbnail(entityType, entityId);
		return "redirect:/images/list?entityType=" + entityType + "&entityId=" + entityId;
	}

	// 이미지 삭제
	@PostMapping("/delete")
	public String delete(@RequestParam("imageNo") int imageNo, @RequestParam("entityType") String entityType,
			@RequestParam("entityId") int entityId) {

		imageService.delete(imageNo);
		// entityType이 product면 수정 폼으로 돌아오기
		if ("product".equals(entityType)) {
	        return "redirect:/product/" + entityId + "/edit";
	    }
		return "redirect:/images/list?entityType=" + entityType + "&entityId=" + entityId;
	}
	
} 