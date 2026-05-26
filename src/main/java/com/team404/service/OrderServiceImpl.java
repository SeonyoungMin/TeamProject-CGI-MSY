package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team404.domain.ProductDetailDto;
import com.team404.repository.OrderRepository;
import com.team404.repository.ProductRepository;
import com.team404.repository.WaitlistRepository;
import com.team404.domain.Order;

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
		if (!"판매중".equals(product.getTradeStatus()))
			throw new IllegalStateException("이미 거래중이거나 완료된 상품입니다.");

		// 가격,판매자번호는 서버에서 채움
		order.setSellerNo(product.getSellerNo());
		order.setPrice(product.getPrice());

		int orderNo = orderRepository.insertTransferOrder(order);

		// 다른 사람 못 사게 '예약중'으로
		orderRepository.updateProductStatus(order.getProductNo(), "예약중");

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

		// 상품을 다시 '판매중'으로 복원
		orderRepository.updateProductStatus(productNo, "판매중");

		// 대기자 전원에게 알림 발송 + 대기 목록 비우기 (WaitlistService에 위임)
		waitlistService.notifyBackOnSaleAndClear(productNo);

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

		return orderRepository.insertTransferRequest(productNo, product.getSellerNo(), buyerNo, product.getPrice());
	}

	@Override
	public List<Order> findTransferRequestsBySeller(int sellerNo) {
		return orderRepository.findTransferRequestsBySeller(sellerNo);
	}

	@Override
	public void approveTransfer(int orderNo, int userNo) {
		orderRepository.approveTransfer(orderNo, userNo);
	}

	@Override
	public Order findByProductAndBuyer(int productNo, int buyerNo) {
		return orderRepository.findByProductAndBuyer(productNo, buyerNo);
	}

}