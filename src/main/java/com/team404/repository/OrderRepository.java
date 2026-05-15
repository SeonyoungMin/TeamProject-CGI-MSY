package com.team404.repository;

public interface OrderRepository {

	public void updateProductStatus(int productNo, String status);

	void insertOrder(int productNo, int sellerNo, int buyerNo, long price);

	void increaseSellCount(int userNo);

	void increaseBuyCount(int userNo);

}
