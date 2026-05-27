package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Notification;
import com.team404.repository.NotificationRepository;

@Service
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	private NotificationRepository notificationRepository;

	private static final String CTX = "/minimarket";

	@Override
	public void notifyFavorite(int buyerNo, int sellerNo, int productNo, String productName, String buyerNickname) {
		if (buyerNo == sellerNo)
			return;

		Notification n = new Notification();
		n.setReceiverNo(sellerNo);
		n.setSenderNo(buyerNo);
		n.setNotiType("favorite");
		n.setMessage(buyerNickname + "님이 '" + productName + "' 상품을 찜했습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);

	}

	@Override
	public void notifyComment(int commenterNo, int boardAuthorNo, int boardNo, String boardType,
			String commenterNickname) {
		if (commenterNo == boardAuthorNo)
			return;

		String link = "board".equals(boardType) ? CTX + "/boardList/" + boardNo : CTX + "/product/" + boardNo;

		Notification n = new Notification();
		n.setReceiverNo(boardAuthorNo);
		n.setSenderNo(commenterNo);
		n.setNotiType("comment");
		n.setMessage(commenterNickname + "님이 댓글을 남겼습니다.");
		n.setLinkUrl(link);
		notificationRepository.insert(n);

	}

	@Override
	public void notifyReview(int reviewerNo, int sellerNo, int productNo, String productName, String reviewerNickname) {
		if (reviewerNo == sellerNo)
			return;

		Notification n = new Notification();
		n.setReceiverNo(sellerNo);
		n.setSenderNo(reviewerNo);
		n.setNotiType("review");
		n.setMessage(reviewerNickname + "님이 '" + productName + "'에 구매후기를 남겼습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);

	}

	@Override
	public void notifyNotice(int boardNo, String title) {
		List<Integer> allUserNos = notificationRepository.findAllUserNos();

		for (int userNo : allUserNos) {
			Notification n = new Notification();
			n.setReceiverNo(userNo);
			n.setSenderNo(0);
			n.setNotiType("notice");
			n.setMessage("[공지] " + title);
			n.setLinkUrl(CTX + "/boardList/" + boardNo);
			notificationRepository.insert(n);
		}

	}

	@Override
	public void notifySold(int sellerNo, int productNo, String productName) {

		Notification n = new Notification();
		n.setReceiverNo(sellerNo);
		n.setSenderNo(0);
		n.setNotiType("sold");
		n.setMessage("' " + productName + "' 상품이 판매 완료됐습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);
	}

	@Override
	public void notifyBought(int buyerNo, int productNo, String productName) {

		Notification n = new Notification();
		n.setReceiverNo(buyerNo);
		n.setSenderNo(0);
		n.setNotiType("bought");
		n.setMessage("' " + productName + "' 상품 구매가 완료됐습니다. 후기를 남겨주세요.");
		// 거래완료 페이지로 → 거기서 후기 작성 분기
		n.setLinkUrl(CTX + "/complete?productNo=" + productNo);
		notificationRepository.insert(n);

	}

	// 조회 상태 변경

	@Override
	public List<Notification> getMyNotifications(int receiverNo) {
		return notificationRepository.findByReceiver(receiverNo);
	}

	@Override
	public int countUnread(int receiverNo) {
		return notificationRepository.countUnread(receiverNo);
	}

	// 알림 클릭 → 읽음 처리 → 해당 linkUrl 반환 (컨트롤러에서 redirect 에 사용)

	@Override
	public String readAndGetLink(int notificationNo) {
		notificationRepository.markAsRead(notificationNo);
		return null; // 컨트롤러에서 link 파라미터 직접 받아서 처리함
	}

	@Override
	public void markAllAsRead(int receiverNo) {
		notificationRepository.markAllAsRead(receiverNo);
	}

	@Override
	public void delete(int notificationNo) {
		notificationRepository.delete(notificationNo);

	}

	@Override
	public void deleteRead(int receiverNo) {
		notificationRepository.deleteReadByReceiver(receiverNo);
	}

	@Override
	public void notifyDepositPending(int sellerNo, int buyerNo, int productNo, String productName,
			String buyerNickname) {
		Notification n = new Notification();
		n.setReceiverNo(sellerNo); // 알림 받을 사람: 판매자
		n.setSenderNo(buyerNo); // 알림 보낸 사람: 구매자
		n.setNotiType("deposit_pending");
		n.setMessage(buyerNickname + "님이 '" + productName + "' 상품 입금을 대기 중입니다. 관리 페이지에서 확인해 주세요.");
		n.setLinkUrl(CTX + "/order/pending");
		notificationRepository.insert(n);
	}

	@Override
	public void notifyDirectReserved(int sellerNo, int buyerNo, int productNo, String productName,
			String buyerNickname) {
		Notification n = new Notification();
		n.setReceiverNo(sellerNo);
		n.setSenderNo(buyerNo);
		n.setNotiType("direct_reserved");
		n.setMessage(buyerNickname + "님이 '" + productName + "' 직거래를 예약했습니다. 만남 후 거래완료를 눌러주세요.");
		n.setLinkUrl(CTX + "/order/pending");
		notificationRepository.insert(n);
	}

	@Override
	public void notifyAccountRequest(int sellerNo, int buyerNo, int productNo, String productName,
			String buyerNickname) {
		Notification n = new Notification();
		n.setReceiverNo(sellerNo);
		n.setSenderNo(buyerNo);
		n.setNotiType("account_request");
		n.setMessage(buyerNickname + "님이 '" + productName + "' 구매를 위해 계좌 등록을 요청했습니다.");
		n.setLinkUrl(CTX + "/mypage/account");
		notificationRepository.insert(n);

	}

	@Override
	public void notifyReserved(int buyerNo, int productNo, String productName) {
		Notification n = new Notification();
		n.setReceiverNo(buyerNo);
		n.setSenderNo(0);
		n.setNotiType("reserved");
		n.setMessage("'" + productName + "' 상품 예약이 완료됐습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);
	}

	@Override
	public void notifyBackOnSale(int receiverNo, int productNo, String productName) {
		Notification n = new Notification();
		n.setReceiverNo(receiverNo);
		n.setSenderNo(0);
		n.setNotiType("waitlist");
		n.setMessage("대기 신청하신 '" + productName + "' 상품이 다시 판매중입니다. 지금 구매해 보세요!");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);
	}

	@Override
	public void notifyTransferRequest(int sellerNo, int buyerNo, int productNo, String productName,
			String buyerNickName) {

		Notification n = new Notification();
		n.setReceiverNo(sellerNo);
		n.setSenderNo(buyerNo);
		n.setNotiType("transfer_request");
		n.setMessage(buyerNickName + "님이 '" + productName + "' 상품의 거래를 요청했습니다.");
		n.setLinkUrl(CTX + "/order/pending");
		notificationRepository.insert(n);
	}

	@Override
	public void notifyDirectCancelled(int buyerNo, int productNo, String productName) {
		Notification n = new Notification();
		n.setReceiverNo(buyerNo);
		n.setSenderNo(0);
		n.setNotiType("trade_cancelled");
		n.setMessage("'" + productName + "' 상품의 직거래 약속이 취소되었습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);
	}

	@Override
	public void notifyTransferRejected(int buyerNo, int productNo, String productName) {
		Notification n = new Notification();
		n.setReceiverNo(buyerNo);
		n.setSenderNo(0);
		n.setNotiType("trade_rejected");
		n.setMessage("'" + productName + "' 상품의 거래 요청이 거절되었습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);
	}

	@Override
	public void notifyTransferCancelled(int receiverNo, int productNo, String productName, boolean cancelledBySeller) {
		String who = cancelledBySeller ? "판매자" : "구매자";
		Notification n = new Notification();
		n.setReceiverNo(receiverNo);
		n.setSenderNo(0);
		n.setNotiType("trade_cancelled");
		n.setMessage(who + "가 '" + productName + "' 상품의 거래를 취소했습니다.");
		n.setLinkUrl(CTX + "/product/" + productNo);
		notificationRepository.insert(n);
	}

	@Override
	public void notifyTransferApproved(int buyerNo, int sellerNo, int productNo, String productName) {

		Notification n = new Notification();
		n.setReceiverNo(buyerNo);
		n.setSenderNo(sellerNo);
		n.setNotiType("transfer_approved");
		n.setMessage("'" + productName + "' 상품의 거래 요청이 승인되었습니다. 입금 정보를 입력해 주세요.");
		n.setLinkUrl(CTX + "/order/transfer/form?productNo=" + productNo);
		notificationRepository.insert(n);
	}
}
