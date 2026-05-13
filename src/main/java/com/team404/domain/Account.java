package com.team404.domain;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

//가계부 목록 조회용
//orders 테이블 + product 테이블 JOIN
public class Account {

	private int orderNo;
	private long price;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Timestamp createdTime;
	private String memo;


	// product
	private String productName;

	// users
	private String partnerNickname;
	
	// 'SELL' or 'BUY'
	private String type;

	public Account() {
	}

	public int getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}

	public long getPrice() {
		return price;
	}

	public void setPrice(long price) {
		this.price = price;
	}

	public Timestamp getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}


	public String getPartnerNickname() {
		return partnerNickname;
	}

	public void setPartnerNickname(String partnerNickname) {
		this.partnerNickname = partnerNickname;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

}
