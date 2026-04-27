package com.team404.domain;

import java.sql.Timestamp;

public class Comment {

	private int commentNo;
	private String content;
	private int boardNo;
	private int authorNo;
	private java.sql.Timestamp createdTime;

	private String nickname;

	public int getCommentNo() {
		return commentNo;
	}

	public void setCommentNo(int commnetNo) {
		this.commentNo = commnetNo;
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

	public int getAuthorNo() {
		return authorNo;
	}

	public void setAuthorNo(int authorNo) {
		this.authorNo = authorNo;
	}

	public Timestamp getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

}
