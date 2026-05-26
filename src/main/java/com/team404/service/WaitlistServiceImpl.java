package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.ProductDetailDto;
import com.team404.repository.ProductRepository;
import com.team404.repository.WaitlistRepository;

@Service
public class WaitlistServiceImpl implements WaitlistService {

	@Autowired
	private WaitlistRepository waitlistRepository;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private ProductRepository productRepository;

	@Override
	public void add(int productNo, int userNo) {
		waitlistRepository.insert(productNo, userNo);
	}

	@Override
	public void remove(int productNo, int userNo) {
		waitlistRepository.delete(productNo, userNo);
	}

	@Override
	public boolean exists(int productNo, int userNo) {
		return waitlistRepository.exists(productNo, userNo);
	}

	@Override
	public int countByProduct(int productNo) {
		return waitlistRepository.countByProduct(productNo);
	}

	@Override
	public void notifyBackOnSaleAndClear(int productNo) {
		List<Integer> waiterUserNos = waitlistRepository.findUserNosByProduct(productNo);
		if (waiterUserNos.isEmpty())
			return;

		ProductDetailDto product = productRepository.findProductDetail(productNo);
		String productName = product != null ? product.getProductName() : "";

		for (Integer userNo : waiterUserNos) {
			try {
				notificationService.notifyBackOnSale(userNo, productNo, productName);
			} catch (Exception e) {
				System.out.println("대기자 알림 발송 실패 userNo=" + userNo + " : " + e.getMessage());
			}
		}
		waitlistRepository.deleteAllByProduct(productNo);
	}
}
