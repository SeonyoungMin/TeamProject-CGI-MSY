package com.team404.service;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.team404.domain.Image;
import com.team404.domain.ProductDetailDto;
import com.team404.repository.GeminiApiRepository;

@Service
public class AiAnalysisServiceImpl implements AiAnalysisService {

	@Autowired
	private GeminiApiRepository geminiApiRepository;
	@Autowired
	private ImageService imageService;
	@Autowired
	private ProductService productService;

	@Value("${naver.shopping.client-id:}")
	private String naverClientId;
	@Value("${naver.shopping.client-secret:}")
	private String naverClientSecret;

	private final ObjectMapper objectMapper = new ObjectMapper();

	/** 네이버 쇼핑 유사 상품 1건 */
	private static class NaverProduct {
		final String name;
		final long price;
		final String link;

		NaverProduct(String name, long price, String link) {
			this.name = name;
			this.price = price;
			this.link = link;
		}
	}

	@Override
	public String analyzeProduct(int productNo, String description) {
		List<Image> images = imageService.getImages("product", productNo);
		if (images == null || images.isEmpty())
			return "{\"error\": \"사진 없음\"}";

		// 상품명으로 네이버 쇼핑에서 관련도 상위 1~3개 유사 상품 가져옴
		ProductDetailDto product = productService.findProductDetail(productNo);
		String keyword = (product != null) ? product.getProductName() : description;
		long listingPrice = (product != null) ? product.getPrice() : 0; // 판매 등록가
		System.out.println("ai productNo=" + productNo + " / 네이버 검색어(상품명)=[" + keyword + "]");
		List<NaverProduct> similars = getNaverTopProducts(keyword);

		String marketContext = buildMarketContext(similars);
		System.out.println("ai " + marketContext);

		String prompt = buildPrompt(description, marketContext, listingPrice);
		String result = geminiApiRepository.analyzeMultiple(images, prompt);

		// 링크/가격이 AI에 의해 바뀌지 않도록, 네이버 원본값 그대로 확정
		return attachSimilarProducts(result, similars);
	}

	/** 프롬프트에 넣을 시세 참고 텍스트(상위 1~3개 상품을 그대로 나열) */
	private String buildMarketContext(List<NaverProduct> similars) {
		if (similars.isEmpty())
			return "네이버 쇼핑에서 유사 상품을 찾지 못했습니다.";

		StringBuilder sb = new StringBuilder("네이버 쇼핑 유사 상품 검색 결과(상위 " + similars.size() + "개):\n");
		int i = 1;
		for (NaverProduct p : similars) {
			sb.append(i++).append(". 상품명: ").append(p.name).append(" / 가격: ").append(p.price).append("원 / 링크: ")
					.append(p.link).append("\n");
		}
		return sb.toString().trim();
	}

	private String attachSimilarProducts(String json, List<NaverProduct> similars) {
		if (similars == null || similars.isEmpty())
			return json;
		try {
			JsonNode root = objectMapper.readTree(json);
			JsonNode conclusionNode = root.path("conclusion");
			if (root.has("error") || !conclusionNode.isObject())
				return json;

			ArrayNode arr = objectMapper.createArrayNode();
			for (NaverProduct p : similars) {
				ObjectNode o = objectMapper.createObjectNode();
				o.put("name", p.name);
				o.put("price", String.valueOf(p.price));
				o.put("link", p.link);
				arr.add(o);
			}
			((ObjectNode) conclusionNode).set("similarProductInfo", arr);
			return objectMapper.writeValueAsString(root);
		} catch (Exception e) {
			System.err.println("유사 상품 정보 주입 실패(원본 유지): " + e.getMessage());
			return json;
		}
	}

	/** 네이버 쇼핑 검색 결과의 관련도 상위 1~3개 상품을 그대로 파싱 */
	private List<NaverProduct> getNaverTopProducts(String keyword) {
		List<NaverProduct> products = new ArrayList<>();
		if (keyword == null || keyword.isBlank() || naverClientId.isBlank() || naverClientSecret.isBlank())
			return products;
		try {

			// 인코딩 문제를 위해 추가 uri
			URI uri = URI.create("https://openapi.naver.com/v1/search/shop.json?display=10&sort=sim&query="
					+ URLEncoder.encode(keyword, StandardCharsets.UTF_8));

			HttpHeaders headers = new HttpHeaders();
			headers.set("X-Naver-Client-Id", naverClientId);
			headers.set("X-Naver-Client-Secret", naverClientSecret);

			ResponseEntity<String> res = new RestTemplate().exchange(uri, HttpMethod.GET, new HttpEntity<>(headers),
					String.class);

			JsonNode items = objectMapper.readTree(res.getBody()).path("items");
			if (!items.isArray())
				return products;

			for (JsonNode item : items) {
				String lprice = item.path("lprice").asText("");
				if (lprice.isBlank())
					continue;
				String name = item.path("title").asText("").replaceAll("<[^>]*>", "").trim();
				String link = item.path("link").asText("");
				products.add(new NaverProduct(name, Long.parseLong(lprice), link));
			}

			// 최저가 순으로 정렬 후 3개만 남김
			products.sort((a, b) -> Long.compare(a.price, b.price));
			if (products.size() > 3)
				products = new ArrayList<>(products.subList(0, 3));
		} catch (Exception e) {
			System.err.println("네이버 쇼핑 시세 조회 실패: " + e.getMessage());
		}
		return products;
	}

	// 제미나이 명령 프롬프트 //
	private String buildPrompt(String description, String marketContext, long listingPrice) {
		return "당신은 중고거래 상품 검수 전문가입니다. 첨부된 4방향 사진과 아래 [상품 정보]를 보고 " + "다음 단계로 분석한 뒤, 반드시 아래 [출력 형식]의 JSON 하나만 출력하세요. "
				+ "마크다운(```json)이나 설명 문장은 절대 붙이지 마세요. 값은 한국어로 작성하세요.\n\n" + "[상품 정보]\n" + "- 판매글 설명: " + description
				+ "\n" + "- 판매 등록가: " + listingPrice + "원\n" + "- 네이버 쇼핑 검색 결과:\n" + marketContext + "\n\n"
				+ "[분석 단계]\n"
				+ "이미지 분석: 상품의 정체와 상태는 반드시 '첨부 사진'만 근거로 판단하세요. "
				+ "네이버 검색 결과는 시세 참고용일 뿐이니, 그 상품명으로 사진 속 물건을 단정하지 마세요(검색 결과가 실제 상품과 다를 수 있음). "
				+ "상태 설명, 스크래치/훼손 여부, 외관 등급(A/B/C).\n" + "텍스트 분석: 판매글의 과장 여부, 신뢰도(0~100 숫자), 문구 도용/복붙 의심 여부.\n"
				+ "시세 안내: 절대 가격을 직접 계산하거나 추천가·평균가를 만들지 마세요. " + "위 네이버 쇼핑 검색 결과를 '있는 그대로' 전달하기만 하세요.\n"
				+ "최종 결론: 종합 상태 등급(예: B+), 핵심 리스크, 재판매 가치(상/중/하), 그리고 시세 안내 총평.\n\n" + "[작성 규칙]\n"
				+ "- conclusion.comment 는 다음 문장으로 시작하세요: " + "\"이 상품은 현재 네이버 쇼핑에서 아래와 같이 검색되는 유사 상품들과 시세가 형성되어 있습니다.\" "
				+ "그 뒤에 검색된 상품명과 가격을 그대로 언급하고, 마지막에 판매 등록가와 네이버 시세를 대조해 "
				+ "이 가격이면 사도 좋은지 / 시세보다 비싸서 비추천인지 구매 의견을 한 줄로 제시하세요(새 가격을 계산하지 말고 비교·판단만).\n"
				+ "- conclusion.similarProductInfo 에는 위 네이버 검색 결과 상품들을 [{name, price, link}, ...] 배열로 그대로 담으세요. 지어내지 마세요.\n\n"
				+ "[출력 형식]\n" + "{" + "\"imageAnalysis\":{\"condition\":\"\",\"damage\":\"\",\"grade\":\"\"},"
				+ "\"textAnalysis\":{\"exaggeration\":\"\",\"trustScore\":\"\",\"plagiarismRisk\":\"\"},"
				+ "\"conclusion\":{\"similarProductInfo\":[{\"name\":\"\",\"price\":\"\",\"link\":\"\"}],\"grade\":\"\",\"risk\":\"\",\"resaleGrade\":\"\",\"comment\":\"\"}"
				+ "}";
	}
}
