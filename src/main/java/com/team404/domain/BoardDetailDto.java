package com.team404.domain;

import java.sql.Timestamp;

public class BoardDetailDto {

	private int boardNo;
	private String title;
	private String content;
	private int authorNo;
	private int productNo;
	private Timestamp createdTime;
	private String authorNickname;
	private String boardType;
	private boolean pinned;
	
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}

	public int getAuthorNo() {
		return authorNo;
	}
	public void setAuthorNo(int authorNo) {
		this.authorNo = authorNo;
	}
	public int getProductNo() {
		return productNo;
	}
	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}
	public Timestamp getCreatedTime() {
		return createdTime;
	}
	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}
	public String getAuthorNickname() {
		return authorNickname;
	}
	public void setAuthorNickname(String authorNickname) {
		this.authorNickname = authorNickname;
	}
	public String getBoardType() {
		return boardType;
	}
	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}
	public boolean isPinned() {
		return pinned;
	}
	public void setPinned(boolean pinned) {
		this.pinned = pinned;
	}
}
