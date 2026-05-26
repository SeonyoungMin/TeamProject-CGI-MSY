package com.team404.service;

import java.util.List;
import com.team404.domain.Order;

public interface OrderService {

	void processOrder(int productNo, int buyerNo);

	List<Integer> findProductNosByBuyerAndSeller(int buyerNo, int sellerNo);

	int createTransferOrder(Order order); // 계좌이체 주문 생성 (입금대기)

	// 직거래: 예약 (Order INSERT + product '예약중'). orderNo 반환
	int reserveDirectOrder(Order order);

	// 직거래: 판매자가 거래 확정 (order='완료', product='완료', sell/buy 카운트++)
	boolean completeDirectOrder(int orderNo, int sellerNo);

	// 직거래: 판매자가 약속 취소 (order='취소', product='판매중' 복원). 성공 여부 반환.
	boolean cancelDirectOrder(int orderNo, int sellerNo);

	boolean confirmPayment(int orderNo, int sellerNo); // 판매자 입금 확인 -> 거래 완료

	Order findByOrderNo(int orderNo);

	List<Order> findPendingTransfersBySeller(int sellerNo);

	// 판매자가 처리할 직거래 예약 목록
	List<Order> findReservedDirectsBySeller(int sellerNo);

	// 내가 참여 중인(예약중) 직거래 — 구매자/판매자 모두 포함
	List<Order> findMyReservedDirects(int userNo);

	// 한 상품에 매달린 진행중 orders 전부 '취소' (예약중→판매중 전환 시 사용)
	int cancelAllActiveByProduct(int productNo);

	// 계좌이체 거래 요청 (구매자) — status='요청'으로 orders insert. orderNo 반환
	int createTransferRequest(int productNo, int buyerNo);

	// 판매자가 승인해야 할 거래 요청 목록
	List<Order> findTransferRequestsBySeller(int sellerNo);

	//계좌조회 요청 알람 승인
	void approveTransfer(int orderNo, int userNo);

	Order findByProductAndBuyer(int productNo, int userNo);

}
