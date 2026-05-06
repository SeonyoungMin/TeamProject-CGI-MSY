package com.team404.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.SearchDTO;
import com.team404.domain.User;

public interface UserService {
		
	// 전체 유저 조회 + 페이징 기능 구현 예정
	List<User> getAllUsers();
	
	// 유저 번호로 조회
	User getUserByNo(int userNo);
	
	// 개별 R 메서드를 검색 DTO 활용한 통합검색 메서드로!
	List<User> adminSearchUser(SearchDTO searchDTO);
	
	// 유저 ID로 조회
	User getUserById(String userId);
	
	// 유저 닉네임으로 조회
	User getUserByNickName(String userNickName);
	
	// 유저 연령대로 조회
	List<User> getUserByAge(int startUserAge, int endUserAge);
	
	// 유저 지역으로 조회
	List<User> getUserByAddress(String userAddress);
	
	// 유저 등급으로 조회
	List<User> getUserByGrade(String userGrade);
	
	// 유저계정 생성 시간으로 조회
	List<User> getUserByCreatedTime(LocalDateTime startTime, LocalDateTime endTime);
		
	// 유저 구매 횟수로 조회
	List<User> getUserByBuyCount(int minCount, int maxCount);
	
	// 유저 판매 횟수로 조회
	List<User> getUserBySellCount(int minCount, int maxCount);
	
	// 파일 업로드
//	void uploadFile(User user);
	
	// 유저 회원가입
	void setNewUser(User newUser);
	
	// 유저 회원정보수정
	void setEditUser(User editUser);
	
	// 유저 회원탈퇴
	void setDeleteUser(int userNo);
	
}
