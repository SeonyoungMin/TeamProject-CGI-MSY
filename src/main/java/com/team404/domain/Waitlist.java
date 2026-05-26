package com.team404.domain;

import java.sql.Timestamp;

public class Waitlist {

	private int waitlistNo;
	private int productNo;
	private int userNo;
	private Timestamp createdTime;

	public int getWaitlistNo() {
		return waitlistNo;
	}

	public void setWaitlistNo(int waitlistNo) {
		this.waitlistNo = waitlistNo;
	}

	public int getProductNo() {
		return productNo;
	}

	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public Timestamp getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}
}
