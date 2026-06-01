package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team404.domain.Order;
import com.team404.domain.ProductDetailDto;
import com.team404.repository.NotificationRepository;
import com.team404.repository.OrderRepository;
import com.team404.repository.ProductRepository;
import com.team404.repository.WaitlistRepository;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private ProductRepository productRepository;

	@Autowired
	private WaitlistRepository waitlistRepository;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private WaitlistService waitlistService;

	@Autowired
	private NotificationRepository notificationRepository;

	// 주문 처리 핵심 로직
	@Transactional
	public void processOrder(int productNo, int buyerNo) {

		// 상품 정보 조회
		ProductDetailDto product = productRepository.findProductDetail(productNo);

		if (product == null) {
			throw new IllegalArgumentException("상품이 존재하지 않습니다.");
		}

		// 이미 판매된 상품이면 차단
		if ("완료".equals(product.getTradeStatus())) {
			throw new IllegalStateException("이미 판매된 상품입니다.");
		}

		int sellerNo = product.getSellerNo();
		long price = product.getPrice();

		// 주문 저장
		orderRepository.insertOrder(productNo, sellerNo, buyerNo, price);
		// product.trade_status='완료' + buyer_no 함께 기록 (구매내역/후기 분기에서 사용)
		orderRepository.markProductAsSold(productNo, buyerNo);

		// 거래 누적 카운트 갱신 (판매자 sell_count, 구매자 buy_count)
		orderRepository.increaseSellCount(sellerNo);
		orderRepository.increaseBuyCount(buyerNo);
	}

	public List<Integer> findProductNosByBuyerAndSeller(int buyerNo, int sellerNo) {
		return orderRepository.findProductNosByBuyerAndSeller(buyerNo, sellerNo);
	}

	@Override
	@Transactional
	public int createTransferOrder(Order order) {
		ProductDetailDto product = productRepository.findProductDetail(order.getProductNo());
		if (product == null)
			throw new IllegalArgumentException("상품이 존재하지 않습니다.");
		if ("완료".equals(product.getTradeStatus()))
			throw new IllegalStateException("이미 거래가 완료된 상품입니다.");

		// 본인이 승인받은 거래자인지 확인 — 승인 안 받은 사람은 폼 제출 자체를 차단
		Order approved = orderRepository.findByProductAndBuyer(order.getProductNo(), order.getBuyerNo());
		if (approved == null || !"승인완료".equals(approved.getOrderStatus())) {
			throw new IllegalStateException("승인된 거래만 입금 정보를 등록할 수 있습니다.");
		}

		// 가격, 판매자번호는 서버에서 채움
		order.setSellerNo(product.getSellerNo());
		order.setPrice(product.getPrice());

		// 기존 승인완료 row는 취소 처리 (같은 (product,buyer)에 활성 row 1개만 남도록)
		orderRepository.cancelTransferOrder(approved.getOrderNo(), order.getBuyerNo());

		// 새 입금대기 row insert (receiver/depositor 등 폼 입력값 포함)
		int orderNo = orderRepository.insertTransferOrder(order);

		// 상품이 아직 판매중이면 예약중으로 (이미 예약중이면 그대로)
		if ("판매중".equals(product.getTradeStatus())) {
			orderRepository.updateProductStatus(order.getProductNo(), "예약중");
		}

		return orderNo;
	}

	@Override
	@Transactional
	public int reserveDirectOrder(Order order) {
		ProductDetailDto product = productRepository.findProductDetail(order.getProductNo());
		if (product == null)
			throw new IllegalArgumentException("상품이 존재하지 않습니다.");
		if (!"판매중".equals(product.getTradeStatus()))
			throw new IllegalStateException("이미 거래중이거나 완료된 상품입니다.");

		order.setSellerNo(product.getSellerNo());
		order.setPrice(product.getPrice());

		int orderNo = orderRepository.insertDirectOrder(order);
		orderRepository.updateProductStatus(order.getProductNo(), "예약중");
		return orderNo;
	}

	@Override
	@Transactional
	public boolean completeDirectOrder(int orderNo, int sellerNo) {
		int rows = orderRepository.completeDirect(orderNo, sellerNo);
		if (rows == 0)
			return false; // 권한 없거나 이미 처리됨

		Order order = orderRepository.findByOrderNo(orderNo);
		orderRepository.markProductAsSold(order.getProductNo(), order.getBuyerNo());
		orderRepository.increaseSellCount(order.getSellerNo());
		orderRepository.increaseBuyCount(order.getBuyerNo());
		return true;
	}

	@Override
	@Transactional
	public boolean cancelDirectOrder(int orderNo, int sellerNo) {
		int rows = orderRepository.cancelDirect(orderNo, sellerNo);
		if (rows == 0)
			return false; // 권한 없거나 이미 처리됨

		Order order = orderRepository.findByOrderNo(orderNo);
		int productNo = order.getProductNo();

		// 상품을 다시 판매중으로 복원
		orderRepository.updateProductStatus(productNo, "판매중");

		// 대기자 전원에게 알림 발송 + 대기 목록 비우기 (WaitlistService에 위임)
		waitlistService.notifyBackOnSaleAndClear(productNo);

		// 관련 알림 정리 — 직거래 예약 안내 (orderNo 기반) + 입금 관련 잔존 알림
		try {
			notificationRepository.deleteByLinkUrlContaining("/order/direct/reserved/" + orderNo);
			notificationRepository.deleteByLinkUrlContaining("/order/waiting/" + orderNo);
		} catch (Exception e) {
			System.out.println("직거래 취소 알림 정리 실패: " + e.getMessage());
		}

		// 구매자에게 직거래 취소 알림
		try {
			ProductDetailDto product = productRepository.findProductDetail(productNo);
			String productName = product != null ? product.getProductName() : "";
			notificationService.notifyDirectCancelled(order.getBuyerNo(), productNo, productName);
		} catch (Exception e) {
			System.out.println("직거래 취소 알림 발송 실패: " + e.getMessage());
		}

		return true;
	}

	@Override
	@Transactional
	public boolean confirmPayment(int orderNo, int sellerNo) {
		int rows = orderRepository.confirmPayment(orderNo, sellerNo);
		if (rows == 0)
			return false; // 권한 없거나 이미 처리됨

		// 입금 확인 = 거래 완료까지 한 번에 진행
		Order order = orderRepository.findByOrderNo(orderNo);
		orderRepository.completeOrder(orderNo);
		orderRepository.markProductAsSold(order.getProductNo(), order.getBuyerNo());
		orderRepository.increaseSellCount(order.getSellerNo());
		orderRepository.increaseBuyCount(order.getBuyerNo());
		return true;
	}

	@Override
	public Order findByOrderNo(int orderNo) {
		return orderRepository.findByOrderNo(orderNo);
	}

	@Override
	public List<Order> findPendingTransfersBySeller(int sellerNo) {
		return orderRepository.findPendingTransfersBySeller(sellerNo);
	}

	@Override
	public List<Order> findReservedDirectsBySeller(int sellerNo) {
		return orderRepository.findReservedDirectsBySeller(sellerNo);
	}

	@Override
	public List<Order> findMyReservedDirects(int userNo) {
		return orderRepository.findMyReservedDirects(userNo);
	}

	@Override
	public int cancelAllActiveByProduct(int productNo) {
		return orderRepository.cancelAllActiveByProduct(productNo);
	}

	@Override
	@Transactional
	public int createTransferRequest(int productNo, int buyerNo) {
		ProductDetailDto product = productRepository.findProductDetail(productNo);
		if (product == null)
			throw new IllegalArgumentException("상품이 존재하지 않습니다.");
		if (product.getSellerNo() == buyerNo)
			throw new IllegalStateException("본인 상품에는 거래 요청할 수 없습니다.");
		if (!"판매중".equals(product.getTradeStatus()))
			throw new IllegalStateException("판매중인 상품에만 거래 요청할 수 있습니다.");

		// 한 사람당 같은 상품에 활성 요청은 1건만 허용 (중복 알림/카드 방지)
		if (orderRepository.existsActiveTransferRequest(productNo, buyerNo))
			throw new IllegalStateException("이미 진행 중인 거래 요청이 있습니다.");

		return orderRepository.insertTransferRequest(productNo, product.getSellerNo(), buyerNo, product.getPrice());
	}

	@Override
	public List<Order> findTransferRequestsBySeller(int sellerNo) {
		return orderRepository.findTransferRequestsBySeller(sellerNo);
	}

	@Override
	public List<Order> findApprovedTransfersBySeller(int sellerNo) {
		return orderRepository.findApprovedTransfersBySeller(sellerNo);
	}

	@Override
	public Order findActiveReservationByProduct(int productNo) {
		return orderRepository.findActiveReservationByProduct(productNo);
	}

	// 거래 요청 승인 — 중복 승인 방지를 위한 핵심 트랜잭션
	@Override
	@Transactional
	public boolean approveTransfer(int orderNo, int userNo) {
		Order order = orderRepository.findByOrderNo(orderNo);
		if (order == null)
			return false;

		// 본인(판매자)이 아니면 거부 — SQL 조건으로도 보장되지만 명시적 차단
		if (order.getSellerNo() != userNo)
			return false;

		ProductDetailDto product = productRepository.findProductDetail(order.getProductNo());
		if (product == null)
			return false;

		// 이미 다른 거래가 진행 중(예약중/완료)이면 승인 거부
		if (!"판매중".equals(product.getTradeStatus()))
			return false;

		orderRepository.approveTransfer(orderNo, userNo);
		orderRepository.updateProductStatus(order.getProductNo(), "예약중");
		orderRepository.cancelOtherRequests(order.getProductNo(), orderNo);

		return true;
	}

	// 계좌이체 거래 취소 — 판매자 또는 구매자 본인
	@Override
	@Transactional
	public boolean cancelTransferOrder(int orderNo, int userNo) {
		Order order = orderRepository.findByOrderNo(orderNo);
		if (order == null)
			return false;

		// 취소 직전 상태 보관 — 알림 분기에 사용
		String prevStatus = order.getOrderStatus();

		// 입금완료,완료 이후는 차단
		int rows = orderRepository.cancelTransferOrder(orderNo, userNo);
		if (rows == 0)
			return false;

		int productNo = order.getProductNo();

		// 상품이 예약중이었다면 판매중으로 복원 + 대기자 알림
		ProductDetailDto product = productRepository.findProductDetail(productNo);
		if (product != null && "예약중".equals(product.getTradeStatus())) {
			orderRepository.updateProductStatus(productNo, "판매중");
			waitlistService.notifyBackOnSaleAndClear(productNo);
		}

		// 관련 알림 정리 — 입금 안내 + 승인 알림
		try {
			notificationRepository.deleteByLinkUrlContaining("/order/waiting/" + orderNo);
			notificationRepository.deleteByLinkUrlContaining("/order/transfer/form?productNo=" + productNo);
		} catch (Exception e) {
			System.out.println("거래 취소 알림 정리 실패: " + e.getMessage());
		}

		// 상대방에게 거절/취소 알림 발송
		try {
			String productName = product != null ? product.getProductName() : "";
			boolean cancelledBySeller = (userNo == order.getSellerNo());
			int receiverNo = cancelledBySeller ? order.getBuyerNo() : order.getSellerNo();

			if ("요청".equals(prevStatus)) {
				// 요청 단계에서 취소 = 거절 (보통 판매자가 거절)
				notificationService.notifyTransferRejected(order.getBuyerNo(), productNo, productName);
			} else {
				// 승인완료/입금대기 단계에서 취소
				notificationService.notifyTransferCancelled(receiverNo, productNo, productName, cancelledBySeller);
			}
		} catch (Exception e) {
			System.out.println("거래 취소/거절 알림 발송 실패: " + e.getMessage());
		}

		return true;
	}

	@Override
	public Order findByProductAndBuyer(int productNo, int buyerNo) {
		return orderRepository.findByProductAndBuyer(productNo, buyerNo);
	}

}