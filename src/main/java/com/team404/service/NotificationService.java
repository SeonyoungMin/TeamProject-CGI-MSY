package com.team404.service;

import java.util.List;

import com.team404.domain.Notification;

public interface NotificationService {

	// 알림 발송 메서드 (각 이벤트에서 호출)
	public void notifyFavorite(int buyerNo, int sellerNo, int productNo, String productName, String buyerNickname);

	// 댓글 알림: 내 게시글(상품/문의)에 댓글이 달렸을 때
	public void notifyComment(int commenterNo, int boardAuthorNo, int boardNo, String boardType, String commenterNick);

	// 구매후기 알림: 판매자 상품에 구매후기가 등록됐을 때

	public void notifyReview(int reviewerNo, int sellerNo, int productNo, String productName, String reviewerNickname);

	// 공지사항 알림: 전체 유저에게
	public void notifyNotice(int boardNo, String title);

	public void notifySold(int sellerNo, int productNo, String productName);

	// 구매완료 알림 → 구매자에게
	public void notifyBought(int buyerNo, int productNo, String productName);

	// 조회 / 상태 변경

	// 수신자의 알림 목록
	public List<Notification> getMyNotifications(int receiverNo);

	// 읽지 않은 알림 수 (헤더 뱃지)
	public int countUnread(int receiverNo);

	// 단건 읽음 처리 후 linkUrl 반환 (클릭 시 해당 페이지로 이동)
	public String readAndGetLink(int notificationNo);

	// 전체 읽음 처리
	public void markAllAsRead(int receiverNo);

	// 단건 삭제
	public void delete(int notificationNo);

	// 읽은 알림 전체 삭제
	public void deleteRead(int receiverNo);

	// 입금 알람
	void notifyDepositPending(int sellerNo, int buyerNo, int productNo, String productName, String buyerNickname);

	// 직거래 예약 알림 (구매자가 약속 잡음 → 판매자에게)
	void notifyDirectReserved(int sellerNo, int buyerNo, int productNo, String productName, String buyerNickname);

	// 계좌 등록 요청 알림 (구매자 → 판매자)
	void notifyAccountRequest(int sellerNo, int buyerNo, int productNo, String productName, String buyerNickname);

	// 대기 신청 상품이 다시 판매중으로 풀렸을 때 대기자에게
	void notifyBackOnSale(int receiverNo, int productNo, String productName);

	// 계좌 조회 요청 알람 (구매자 → 판매자)
	void notifyTransferRequest(int sellerNo, int buyerNo, int productNo, String productName, String buyerNickName);

	// 거래 요청 승인 알림 (판매자 → 구매자)
	void notifyTransferApproved(int buyerNo, int sellerNo, int productNo, String productName);
}
