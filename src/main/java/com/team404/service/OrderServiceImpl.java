package com.team404.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team404.domain.ProductDetailDto;
import com.team404.repository.OrderRepository;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private ProductService productService;

	@Override
	public void processOrder(int productNo, int buyerNo) {
		ProductDetailDto product = productService.findProductDetail(productNo);
		int sellerNo = product.getSellerNo();
		long price = product.getPrice();

		orderRepository.updateProductStatus(productNo, "완료");
		orderRepository.insertOrder(productNo, sellerNo, buyerNo, price);
	}
}
