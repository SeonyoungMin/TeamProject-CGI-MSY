package com.team404.service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team404.domain.ChatMessage;
import com.team404.domain.ChatRoom;
import com.team404.repository.ChatRepository;

@Service
public class ChatServiceImpl implements ChatService{

	@Autowired
	private ChatRepository chatRepository;
	
	@Value("${gemini.api.key}")
	private String geminiApiKey;
	
	 private static final String MANUAL =
		        "당신은 minimarket 중고거래 플랫폼의 고객센터 챗봇입니다. " +
		        "아래 매뉴얼을 기반으로 사용자 질문에 친절하게 답변해주세요. " +
		        "매뉴얼에 없는 내용은 '관리자 상담이 필요한 내용입니다.'라고 답변하세요.\\n\\n" +
		        "=== minimarket 운영 매뉴얼 ===\\n\\n" +
		        "【거래 방법】\\n" +
		        "- 직거래와 계좌이체(배송) 두 가지 방식 지원\\n" +
		        "- 구매하기 버튼 클릭 후 거래 방식 선택\\n" +
		        "- 계좌이체는 판매자 승인 후 입금 안내 확인\\n" +
		        "- 직거래는 판매자와 약속 후 진행\\n\\n" +
		        "【거래 취소】\\n" +
		        "- 판매자 승인 전: 구매 요청 취소 가능\\n" +
		        "- 승인 후: 판매자에게 직접 문의 필요\\n\\n" +
		        "【예약중 상품】\\n" +
		        "- 다른 구매자와 거래 진행 중인 상품\\n" +
		        "- 예약 대기 신청 가능, 거래 취소 시 순서대로 연락\\n\\n" +
		        "【신고 방법】\\n" +
		        "- 상품/유저/게시글 페이지에서 신고 버튼 클릭\\n" +
		        "- 신고 사유 선택 및 상세 내용 입력 후 제출\\n" +
		        "- 동일 대상에 중복 신고 불가\\n\\n" +
		        "【신고 누적 처리】\\n" +
		        "- 신고 누적 시 위험 등급에 따라 관리자 검토\\n" +
		        "- 소명 기회 제공 후 계정 정지 또는 탈퇴 처리될 수 있음\\n" +
		        "- 소명은 챗봇에서 관리자 상담 요청\\n\\n" +
		        "【소명 방법】\\n" +
		        "- 신고 알림 수신 후 챗봇에서 관리자 상담 요청\\n" +
		        "- 상담 가능 시간: 평일 오전 9시 ~ 오후 6시\\n" +
		        "- 상담 불가 시간에는 문의 내역 남기기 가능\\n\\n" +
		        "【상품 등록】\\n" +
		        "- 로그인 후 상품 등록 버튼 클릭\\n" +
		        "- 상품명, 가격, 카테고리, 설명, 사진 입력 (사진 제한 없음)\\n\\n" +
		        "【상품 수정/삭제】\\n" +
		        "- 내 상품 상세 페이지에서 수정/삭제 버튼 클릭\\n" +
		        "- 거래 진행 중인 상품은 삭제 불가\\n\\n" +
		        "【계정 관련】\\n" +
		        "- 닉네임 변경: 마이페이지에서 수정 가능\\n" +
		        "- 회원탈퇴: 마이페이지에서 탈퇴 가능\\n\\n" +
		        "【거래 후기】\\n" +
		        "- 거래 완료 후 판매자 프로필 페이지에서 작성 가능\\n" +
		        "- 후기 수정/삭제 가능\\n" +
		        "- 상품당 1개의 후기만 작성 가능\\n\\n" +
		        "매뉴얼에 없는 내용이면 반드시 '관리자 상담이 필요한 내용입니다.'라고만 답변하세요.";

	
	public int createRoom(int userNo) {
		return chatRepository.createRoom(userNo);
	}
	
	public ChatRoom getRoomByUserNo(int userNo) {
		return chatRepository.findRoomByUserNo(userNo);
	}
	
	public ChatRoom getRoomByNo(int roomNo) {
		return chatRepository.findRoomByNo(roomNo);
	}
	
	public List<ChatRoom> getAllRooms() {
		return chatRepository.findAllRooms();
	}
	
	public void saveMessage(ChatMessage message) {
		chatRepository.saveMessage(message);
	}
	
	public List<ChatMessage> getMessages(int roomNo) {
		return chatRepository.findMessageByRoomNo(roomNo);
	}
	
	public void updateRoomStatus(int roomdNo, String status) {
		chatRepository.updateRoomStatus(roomdNo, status);
	}
	
	@Override
    public String askBot(String userMessage) {
        try {
            String prompt = MANUAL + "\\n\\n사용자 질문: " + userMessage;

            String requestBody = "{"
                + "\"contents\": [{"
                + "  \"parts\": [{"
                + "    \"text\": \"" + escapeJson(prompt) + "\""
                + "  }]"
                + "}]"
                + "}";

            URL url = new URL("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + geminiApiKey);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept-Charset", "UTF-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(10000);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(requestBody.getBytes("UTF-8"));
            }

            StringBuilder sb = new StringBuilder();
            InputStream is = conn.getResponseCode() >= 400
                ? conn.getErrorStream()
                : conn.getInputStream();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            System.out.println("Gemini 응답: " + sb.toString());
            System.out.println("API 키: " + geminiApiKey);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(sb.toString());
            return root.path("candidates").get(0)
                       .path("content").path("parts").get(0)
                       .path("text").asText().trim();

        } catch (Exception e) {
            return "현재 챗봇 서비스를 이용할 수 없습니다. 잠시 후 다시 시도해주세요.";
        }
    }

    private String escapeJson(String text) {
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
    
    @Override
    public ChatRoom getActiveRoomByUserNo(int userNo) {
        return chatRepository.findActiveRoomByUserNo(userNo);
    }
}
