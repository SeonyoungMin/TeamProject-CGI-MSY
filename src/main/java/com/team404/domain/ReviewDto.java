package com.team404.domain;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ReviewDto {

	private String sellerNickname;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Timestamp createdTime;
	private String content;
	private int boardNo;
	private int productNo;
	private String productName;
	
	
	public String getSellerNickname() {
		return sellerNickname;
	}
	
	public void setSellerNickname(String sellerNickname) {
		this.sellerNickname = sellerNickname;
	}
	
	public Timestamp getCreatedTime() {
		return createdTime;
	}
	
	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}

	public int getBoardNo() {
		return boardNo;
	}

	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}

	public int getProductNo() {
		return productNo;
	}

	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	
	
	
}
