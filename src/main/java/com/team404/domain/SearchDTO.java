package com.team404.domain;

//import java.time.LocalDateTime;

public class SearchDTO {

	private String searchMode;
	private int totalRows;
	private String userId;
	private String userName;
	private String userNickName;
	private Integer startUserAge;
	private Integer endUserAge;
	private String userAddress;
	private String userPhone;
	private String userGrade;
	private String userRole;

	// 검색 결과 총 개수 (페이지네이션 계산용)

	public SearchDTO() {
		this.searchMode = "info";
	}

	public int getTotalRows() {
		return totalRows;
	}

	public void setTotalRows(int totalRows) {
		this.totalRows = totalRows;
	}

	public String getSearchMode() {
		return searchMode;
	}

	public void setSearchMode(String searchMode) {
		this.searchMode = searchMode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public Integer getStartUserAge() {
		return startUserAge;
	}

	public void setStartUserAge(Integer startUserAge) {
		this.startUserAge = startUserAge;
	}

	public Integer getEndUserAge() {
		return endUserAge;
	}

	public void setEndUserAge(Integer endUserAge) {
		this.endUserAge = endUserAge;
	}

	public String getUserAddress() {
		return userAddress;
	}

	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public String getUserGrade() {
		return userGrade;
	}

	public void setUserGrade(String userGrade) {
		this.userGrade = userGrade;
	}

	public String getUserRole() {
		return userRole;
	}

	public void setUserRole(String userRole) {
		this.userRole = userRole;
	}

}
