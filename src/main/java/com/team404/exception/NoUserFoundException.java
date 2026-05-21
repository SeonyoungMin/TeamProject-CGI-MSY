package com.team404.exception;

@SuppressWarnings("serial")
public class NoUserFoundException extends RuntimeException {
	
	private int userNo;

	public NoUserFoundException(int userNo) {
		this.userNo = userNo;
	}

	public int getUserNo() {
		return userNo;
	}
	
}
