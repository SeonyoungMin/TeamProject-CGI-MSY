package com.team404.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class ImageTestController {

	private final String BASE_PATH = "C:/team404_upload/";

	@GetMapping("/")
	public String index() {
		return "index";
	}

	@PostMapping("/uploadImage")
	public String upload(@RequestParam("file") MultipartFile file, @RequestParam("type") String type, Model model)
			throws IOException {

		if (file.isEmpty()) {
			model.addAttribute("msg", "파일 없음");
			return "index";
		}

		// ✅ 반드시 밖에서 선언
		String savePath = "";
		String folder = "";

		switch (type) {
		case "user":
			savePath = BASE_PATH + "profileImg/";
			folder = "profileImg/";
			break;
		case "product":
			savePath = BASE_PATH + "productImg/";
			folder = "productImg/";
			break;
		case "board":
			savePath = BASE_PATH + "boardImg/";
			folder = "boardImg/";
			break;
		default:
			model.addAttribute("msg", "잘못된 타입");
			return "index";
		}

		// 파일명 생성
		String originalName = file.getOriginalFilename();
		String ext = originalName.substring(originalName.lastIndexOf("."));
		String uuid = UUID.randomUUID().toString();
		String fileName = uuid + ext;

		// 파일 저장
		File saveFile = new File(savePath + fileName);
		file.transferTo(saveFile);

		// 웹 경로
		String imgPath = "/upload/" + folder + fileName;

		model.addAttribute("imgPath", imgPath);
		model.addAttribute("msg", "업로드 성공");

		return "result";
	}
}