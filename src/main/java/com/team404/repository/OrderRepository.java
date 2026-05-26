package com.team404.repository;

import java.util.List;
import com.team404.domain.Order;

public interface OrderRepository {

	public void updateProductStatus(int productNo, String status);

	public void markProductAsSold(int productNo, int buyerNo);

	void insertOrder(int productNo, int sellerNo, int buyerNo, long price);

	void increaseSellCount(int userNo);

	void increaseBuyCount(int userNo);

	// 후기 작성 칸 생성 여부 (구매자에 한해)
	List<Integer> findProductNosByBuyerAndSeller(int buyerNo, int sellerNo);

	int insertTransferOrder(Order order);

	int insertDirectOrder(Order order);

	int confirmPayment(int orderNo, int sellerNo);

	int completeOrder(int orderNo);

	// 직거래: '예약중' → '완료' 로 진행 (판매자 권한 검증)
	int completeDirect(int orderNo, int sellerNo);

	// 직거래: '예약중' → '취소' 로 변경 (판매자 권한 검증)
	int cancelDirect(int orderNo, int sellerNo);

	Order findByOrderNo(int orderNo);

	List<Order> findPendingTransfersBySeller(int sellerNo);

	// 판매자가 처리할 직거래 예약 목록
	List<Order> findReservedDirectsBySeller(int sellerNo);

	// 내가 참여 중인(예약중) 직거래 — 구매자 또는 판매자
	List<Order> findMyReservedDirects(int userNo);

	// 한 상품에 매달려있는 진행중 orders 전부 취소 처리
	// (예약중/입금대기/요청/승인완료 -> 취소). 완료/취소된 건은 건드리지 않음
	int cancelAllActiveByProduct(int productNo);

	// 한 상품의 다른 요청 orders를 취소로 (승인 시 다른 요청 자동 거절)
	int cancelOtherRequests(int productNo, int approvedOrderNo);

	// 한 거래 취소 처리 — 권한(seller/buyer 둘 중 하나 일치) + 진행중 상태일 때만
	int cancelTransferOrder(int orderNo, int userNo);

	// 계좌이체 거래 요청 (구매자가 신청, 판매자 승인 대기)
	int insertTransferRequest(int productNo, int sellerNo, int buyerNo, long price);

	// 동일 구매자가 같은 상품에 이미 진행 중인 거래 요청(요청/승인완료/입금대기)이 있는지
	// → 한 사람당 같은 상품에 한 번만 거래 요청이 뜨도록 보장
	boolean existsActiveTransferRequest(int productNo, int buyerNo);

	// 판매자가 승인해야 할 거래 요청 목록
	List<Order> findTransferRequestsBySeller(int sellerNo);

	// 계좌조회 승인 알람
	void approveTransfer(int orderNo, int userNo);

	Order findByProductAndBuyer(int productNo, int buyerNo);
}
