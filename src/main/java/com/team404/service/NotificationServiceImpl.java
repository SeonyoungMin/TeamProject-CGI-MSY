package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.Notification;
import com.team404.repository.NotificationRepository;

@Service
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	private NotificationRepository notificationRepsotory;

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
		notificationRepsotory.insert(n);

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
		notificationRepsotory.insert(n);

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
		notificationRepsotory.insert(n);

	}

	@Override
	public void notifyNotice(int boardNo, String title) {
		List<Integer> allUserNos = notificationRepsotory.findAllUserNos();

		for (int userNo : allUserNos) {
			Notification n = new Notification();
			n.setReceiverNo(userNo);
			n.setSenderNo(0);
			n.setNotiType("notice");
			n.setMessage("[공지] " + title);
			n.setLinkUrl(CTX + "/boardList/" + boardNo);
			notificationRepsotory.insert(n);
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
		notificationRepsotory.insert(n);
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
		notificationRepsotory.insert(n);

	}

	// 조회 상태 변경

	@Override
	public List<Notification> getMyNotifications(int receiverNo) {
		return notificationRepsotory.findByReceiver(receiverNo);
	}

	@Override
	public int countUnread(int receiverNo) {
		return notificationRepsotory.countUnread(receiverNo);
	}

	// 알림 클릭 → 읽음 처리 → 해당 linkUrl 반환 (컨트롤러에서 redirect 에 사용)

	@Override
	public String readAndGetLink(int notificationNo) {
		notificationRepsotory.markAsRead(notificationNo);
		return null; // 컨트롤러에서 link 파라미터 직접 받아서 처리함
	}

	@Override
	public void markAllAsRead(int receiverNo) {
		notificationRepsotory.markAllAsRead(receiverNo);
	}

	@Override
	public void delete(int notificationNo) {
		notificationRepsotory.delete(notificationNo);

	}

	@Override
	public void deleteRead(int receiverNo) {
		notificationRepsotory.deleteReadByReceiver(receiverNo);
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
		notificationRepsotory.insert(n);
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
		notificationRepsotory.insert(n);
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
		notificationRepsotory.insert(n);
	}
}
