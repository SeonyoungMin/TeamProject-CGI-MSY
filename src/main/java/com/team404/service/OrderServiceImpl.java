package com.team404.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team404.domain.ProductDetailDto;
import com.team404.repository.OrderRepository;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderRepository orderRepository; // 주문 리포지토리 연결

	@Autowired
	private ProductService productService; // 상품 정보 조회를 위해 연결

	@Override
	public void processOrder(int productNo, int buyerNo) {
		//상품 상세 정보 가져와서 판매자 번호 알아내기
		ProductDetailDto product = productService.findProductDetail(productNo);
		int sellerNo = product.getSellerNo(); // 판매자 번호 꺼내기

		//상품 상태를 '완료'로 바꾸기 (그래야 랭킹에 집계됨)
		orderRepository.updateProductStatus(productNo, "완료");

		//주문 테이블에 기록 남기 (판매왕/소비왕 집계용)
		orderRepository.insertOrder(productNo, sellerNo, buyerNo);
	}
}
