package com.team404.service;

import java.util.List;

import com.team404.domain.SearchDTO;
import com.team404.domain.User;

import jakarta.servlet.http.HttpSession;

public interface UserService {

	// 페이징용 — 전체 행 수
	int countAll();

	// 전체 유저 조회 (페이징)
	List<User> getAllUsers(SearchDTO searchDTO, int pageNumber, int limit);

	// 유저 번호로 조회
	User getUserByNo(int userNo);

	// 검색 DTO 통합검색 (페이징, 결과 개수는 SearchDTO.totalRows 에 채워짐)
	List<User> adminSearchUser(SearchDTO searchDTO, int pageNumber, int limit);

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

	// 파일 업로드
//	void uploadFile(User user);

	// 유저 회원가입
	void setNewUser(User newUser);

	// 유저 회원정보수정
	void setEditUser(User editUser);

	// 유저 회원탈퇴
	void setDeleteUser(int userNo);

	// 구글, 카카오 로그인
	User findByEmail(String email);

	// OAuth 유저 자동 가입
	void registerOAuthUser(User user);

	// 계좌 정보 등록/수정
	void updateAccount(int userNo, String bankName, String accountNumber, String accountHolder);

	// 관리자 신고 알림
	List<User> findAdmins();

	// 신고처리 및 제재 자동화
	void processReport(int userNo, double scoreAdded, HttpSession session);

	// 제재 상태 체크
	boolean isRestricted(int userNo, String actionType);

	// 제재 안내 메시지
	String getRestrictMessage(int userNo);

	// 점수 차감 후에 게시글 기능 해제
	void updateRiskScoreAndSyncStatus(int userNo, double scoreDelta);

}