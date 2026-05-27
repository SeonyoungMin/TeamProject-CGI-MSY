package com.team404.repository;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Base64;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.team404.domain.Image;

@Repository
public class GeminiApiRepositoryImpl implements GeminiApiRepository {

	@Value("${gemini.api.key}")
	private String apiKey;

	@Value("${gemini.api.url}")
	private String apiUrl;

	@Override
	public String analyze(Image image, String prompt) {

		String encoded = encodeToBase64(image);
		if (encoded == null) {
			return "ERROR: 이미지 인코딩 실패";
		}
		return callGemini(encoded, prompt);
	}

	private String callGemini(String inlineImage, String prompt) {
		HttpURLConnection conn = null;
		try {
			URL url = new URL(apiUrl + "?key=" + apiKey);
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setDoOutput(true);
			conn.setConnectTimeout(10_000);
			conn.setReadTimeout(60_000);

			String body = buildRequest(inlineImage, prompt);
			try (OutputStream os = conn.getOutputStream()) {
				os.write(body.getBytes(StandardCharsets.UTF_8));
			}

			int code = conn.getResponseCode();
			InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
			StringBuilder sb = new StringBuilder();
			try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line);
				}
			}
			if (code < 200 || code >= 300) {
				return "ERROR: Gemini HTTP " + code + " - " + sb;
			}
			return sb.toString();

		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR: " + e.getMessage();
		} finally {
			if (conn != null) {
				conn.disconnect();
			}
		}
	}

	private String encodeToBase64(Image image) {
		try {
			byte[] fileBytes = Files.readAllBytes(new File(image.getFilePath()).toPath());
			return Base64.getEncoder().encodeToString(fileBytes);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private String buildRequest(String inlineImage, String prompt) {
		return """
				{
				  "contents": [
				    {
				      "parts": [
				        {
				          "text": "%s"
				        },
				        {
				          "inline_data": {
				            "mime_type": "image/jpeg",
				            "data": "%s"
				          }
				        }
				      ]
				    }
				  ]
				}
				""".formatted(prompt, inlineImage);
	}
}
