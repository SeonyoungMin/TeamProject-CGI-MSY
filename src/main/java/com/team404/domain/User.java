package com.team404.domain;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

public class User {

	private int userNo;
	private String userId;
	private String userPw;
	private String userName;
	private String userNickName;
	private int userAge;
	private String userAddress;
	private String userPhone;
	private String userGrade;
	private String userRole;
	private String userImageName;
	private MultipartFile userImageFile;
	private String userImagePath;
	private LocalDateTime userCreatedTime;
	private int userBuyCount;
	private int userSellCount;

	private Double latitude;
	private Double longitude;
	private String verifiedArea;
	private Timestamp verifiedAt;

	private String userBankName;
	private String userAccountNumber;
	private String userAccountHolder;

	public User() {
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
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

	public int getUserAge() {
		return userAge;
	}

	public void setUserAge(int userAge) {
		this.userAge = userAge;
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

	public String getUserImageName() {
		return userImageName;
	}

	public void setUserImageName(String userImageName) {
		this.userImageName = userImageName;
	}

	public MultipartFile getUserImageFile() {
		return userImageFile;
	}

	public void setUserImageFile(MultipartFile userImageFile) {
		this.userImageFile = userImageFile;
	}

	public LocalDateTime getUserCreatedTime() {
		return userCreatedTime;
	}

	public String getUserImagePath() {
		return userImagePath;
	}

	public void setUserImagePath(String userImagePath) {
		this.userImagePath = userImagePath;
	}

	public void setUserCreatedTime(LocalDateTime userCreatedTime) {
		this.userCreatedTime = userCreatedTime;
	}

	public int getUserBuyCount() {
		return userBuyCount;
	}

	public void setUserBuyCount(int userBuyCount) {
		this.userBuyCount = userBuyCount;
	}

	public int getUserSellCount() {
		return userSellCount;
	}

	public void setUserSellCount(int userSellCount) {
		this.userSellCount = userSellCount;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}

	public String getVerifiedArea() {
		return verifiedArea;
	}

	public void setVerifiedArea(String verifiedArea) {
		this.verifiedArea = verifiedArea;
	}

	public Timestamp getVerifiedAt() {
		return verifiedAt;
	}

	public void setVerifiedAt(Timestamp verifiedAt) {
		this.verifiedAt = verifiedAt;
	}

	public String getUserBankName() {
		return userBankName;
	}

	public void setUserBankName(String userBankName) {
		this.userBankName = userBankName;
	}

	public String getUserAccountNumber() {
		return userAccountNumber;
	}

	public void setUserAccountNumber(String userAccountNumber) {
		this.userAccountNumber = userAccountNumber;
	}

	public String getUserAccountHolder() {
		return userAccountHolder;
	}

	public void setUserAccountHolder(String userAccountHolder) {
		this.userAccountHolder = userAccountHolder;
	}

}