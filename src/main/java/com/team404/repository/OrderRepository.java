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

	Order findByOrderNo(int orderNo);

	List<Order> findPendingTransfersBySeller(int sellerNo);

	// 판매자가 처리할 직거래 예약 목록
	List<Order> findReservedDirectsBySeller(int sellerNo);

	// 내가 참여 중인(예약중) 직거래 — 구매자 또는 판매자
	List<Order> findMyReservedDirects(int userNo);
}
