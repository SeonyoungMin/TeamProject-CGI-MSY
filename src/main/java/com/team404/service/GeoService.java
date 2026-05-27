package com.team404.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team404.domain.Document;
import com.team404.domain.KakaoResponse;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

@Service
public class GeoService {

	private final String KAKAO_KEY = "42a10ba0a3d99a111dca0c6e0bcd8c93";

	@Autowired
	private ObjectMapper objectMapper;

	public String getAddress(double lat, double lng) {

		try {
			String urlStr = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json" + "?x=" + lng + "&y=" + lat;

			HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();

			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_KEY);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

			StringBuilder sb = new StringBuilder();
			String line;

			while ((line = br.readLine()) != null) {
				sb.append(line);
			}

			br.close();

			KakaoResponse response = objectMapper.readValue(sb.toString(), KakaoResponse.class);

			if (response != null && response.documents != null && !response.documents.isEmpty()) {

				Document doc = response.documents.get(0);

				// 👉 "창원시 성산구" 형태로 반환
				return doc.region_2depth_name + " " + doc.region_3depth_name;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
}