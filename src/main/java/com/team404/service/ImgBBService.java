package com.team404.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ImgBBService {

	@Value("${imgbb.api.key}")
	private String apiKey;

	private static final String UPLOAD_URL = "https://api.imgbb.com/1/upload";
	private static final ObjectMapper mapper = new ObjectMapper();

	public String upload(MultipartFile file) throws Exception {
		if (apiKey == null || apiKey.isEmpty()) {
			throw new RuntimeException("ImgBB API 키가 설정되지 않았습니다. application.properties 확인 필요.");
		}
		System.out.println("[ImgBB] 업로드 시작 - file: " + file.getOriginalFilename()
				+ " / size: " + file.getSize() + " bytes / apiKey: " + apiKey.substring(0, 5) + "...");

		String boundary = "----Boundary" + System.currentTimeMillis();
		URL url = new URL(UPLOAD_URL + "?key=" + apiKey);

		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
		conn.setDoOutput(true);
		conn.setConnectTimeout(10_000);
		conn.setReadTimeout(30_000);

		// multipart/form-data 본문 직접 작성
		String filename = file.getOriginalFilename() != null ? file.getOriginalFilename() : "upload.jpg";
		String contentType = file.getContentType() != null ? file.getContentType() : "application/octet-stream";

		try (DataOutputStream out = new DataOutputStream(conn.getOutputStream())) {
			out.writeBytes("--" + boundary + "\r\n");
			out.writeBytes("Content-Disposition: form-data; name=\"image\"; filename=\"" + filename + "\"\r\n");
			out.writeBytes("Content-Type: " + contentType + "\r\n\r\n");
			out.write(file.getBytes());
			out.writeBytes("\r\n");
			out.writeBytes("--" + boundary + "--\r\n");
			out.flush();
		}

		int code = conn.getResponseCode();
		System.out.println("[ImgBB] 응답 상태: " + code);

		// 성공/실패에 따라 InputStream / ErrorStream 분기
		InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
		StringBuilder sb = new StringBuilder();
		try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
		}
		conn.disconnect();

		if (code < 200 || code >= 300) {
			throw new RuntimeException("ImgBB HTTP " + code + " - " + sb);
		}

		@SuppressWarnings("unchecked")
		Map<String, Object> body = mapper.readValue(sb.toString(), Map.class);
		Object success = body.get("success");
		if (!Boolean.TRUE.equals(success)) {
			throw new RuntimeException("ImgBB 업로드 실패 (success=false): " + body);
		}

		@SuppressWarnings("unchecked")
		Map<String, Object> data = (Map<String, Object>) body.get("data");
		if (data == null) {
			throw new RuntimeException("ImgBB 응답에 data 필드 없음: " + body);
		}

		String imageUrl = String.valueOf(data.get("url"));
		System.out.println("[ImgBB] 업로드 성공: " + imageUrl);
		return imageUrl;
	}
}