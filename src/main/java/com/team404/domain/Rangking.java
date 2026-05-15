package com.team404.domain;

public class Rangking {
	private int memberNo;
	private String nickname;

	private long totalAmount;
	private long tradeCount;

	public int getMemberNo() {
		return memberNo;
	}

	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public long getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(long totalAmount) {
		this.totalAmount = totalAmount;
	}


	public long getTradeCount() {
		return tradeCount;
	}

	public void setTradeCount(long tradeCount) {
		this.tradeCount = tradeCount;

	}
}
