package com.team404.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team404.domain.ProductDetailDto;
import com.team404.repository.OrderRepository;
import com.team404.repository.ProductRepository;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private ProductRepository productRepository;

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
}