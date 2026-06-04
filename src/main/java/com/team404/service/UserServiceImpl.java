package com.team404.service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.domain.SearchDTO;
import com.team404.domain.User;
import com.team404.exception.NoUserFoundException;
import com.team404.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserRepository userRepository;

	@Autowired
	private ImageService image;

	@Override
	public int countAll() {
		return userRepository.countAll();
	}

	@Override
	public User getUserByNo(int userNo) {
		User userByNo = userRepository.getUserByNo(userNo);
		if (userByNo == null) {
			throw new NoUserFoundException(userNo);
		}
		List<Image> images = image.getImages("user", userNo);
		if (images != null && !images.isEmpty()) {

			userByNo.setUserImagePath(images.get(0).getFilePath());
			userByNo.setUserImageName(images.get(0).getFileName());

		}
		return userByNo;
	}

	@Override
	public List<User> adminSearchUser(SearchDTO searchDTO, int pageNumber, int limit) {
		List<User> userBySearch = null;
		int startNumber = limit * (pageNumber - 1);

		if (searchDTO.getSearchMode() == null) {
			return userBySearch;
		}

		switch (searchDTO.getSearchMode()) {
		case "info":
			userBySearch = userRepository.searchUserByInfo(searchDTO, startNumber, limit);
			searchDTO.setTotalRows(userRepository.countForInfo(searchDTO));
			break;
		case "condition":
			userBySearch = userRepository.searchUserByCondition(searchDTO, startNumber, limit);
			searchDTO.setTotalRows(userRepository.countForCondition(searchDTO));
			break;
		}
		return userBySearch;
	}

	@Override
	public List<User> getAllUsers(SearchDTO searchDTO, int pageNumber, int limit) {
		int startNumber = limit * (pageNumber - 1);
		return userRepository.getAllUsers(startNumber, limit);
	}

	@Override
	public User getUserById(String userId) {
		return userRepository.getUserById(userId);
	}

	@Override
	public User getUserByNickName(String userNickName) {
		User userByNickName = userRepository.getUserByNickName(userNickName);
		return userByNickName;
	}

	@Override
	public List<User> getUserByAge(int startUserAge, int endUserAge) {
		List<User> userByAge = userRepository.getUserByAge(startUserAge, endUserAge);
		return userByAge;
	}

	@Override
	public List<User> getUserByAddress(String userAddress) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<User> getUserByGrade(String userGrade) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<User> getUserByCreatedTime(LocalDateTime startTime, LocalDateTime endTime) {
		List<User> userByCreatedTime = userRepository.getUserByCreatedTime(startTime, endTime);
		return userByCreatedTime;
	}

	@Override
	public List<User> getUserByBuyCount(int minCount, int maxCount) {
		List<User> userByBuyCount = userRepository.getUserByBuyCount(minCount, maxCount);
		return userByBuyCount;
	}

	@Override
	public List<User> getUserBySellCount(int minCount, int maxCount) {
		List<User> userBySellCount = userRepository.getUserBySellCount(minCount, maxCount);
		return userBySellCount;
	}

//	@Override
//	public void uploadFile(User user) {
//		
//		MultipartFile userImageFile = user.getUserImageFile();
//		
//		if (userImageFile != null && !userImageFile.isEmpty()) {
//			String saveName = UUID.randomUUID().toString() + "_" + userImageFile.getOriginalFilename();
//			String savePath = "C:\\team404_upload\\profileImg";
//			File saveFile = new File(savePath, saveName);
//			
//			try {
//				userImageFile.transferTo(saveFile);
//				user.setUserImageName(saveName);
//				user.setUserImagePath(savePath);
//				System.out.println("이미지 파일 업로드 성공: [" + saveFile.getPath() + "]");
//			} catch (Exception e) {
//				throw new RuntimeException("이미지 파일 업로드 실패", e);
//			}
//		}
//	}
	// UserServiceImpl.java (상대방 파일)

	@Override
	public void setNewUser(User newUser) {

		userRepository.setNewUser(newUser);

		if (newUser.getUserImageFile() != null && !newUser.getUserImageFile().isEmpty()) {

			List<MultipartFile> imageList = Collections.singletonList(newUser.getUserImageFile());

			image.upload(imageList, "user", newUser.getUserNo());

		}
	}

	@Override
	public void setEditUser(User editUser) {
		User userOriginByNo = userRepository.getUserByNo(editUser.getUserNo());

		// 비밀번호 유지 로직
		if (editUser.getUserPw() == null || editUser.getUserPw().isEmpty()) {
			editUser.setUserPw(userOriginByNo.getUserPw());
		}

		// 2. 이미지 처리
		if (editUser.getUserImageFile() != null && !editUser.getUserImageFile().isEmpty()) {

			List<Image> oldImages = image.getImages("user", editUser.getUserNo());
			for (Image oldImg : oldImages) {
				image.delete(oldImg.getImageNo());
			}

			// 새 이미지 업로드
			List<MultipartFile> imageList = Collections.singletonList(editUser.getUserImageFile());
			image.upload(imageList, "user", editUser.getUserNo());
		}

		userRepository.setEditUser(editUser);
	}

	@Override
	public void setDeleteUser(int userNo) {
		// 1. 해당 유저의 이미지 리스트를 가져옴
		List<Image> userImages = image.getImages("user", userNo);

		// 2. 반복문(for)을 사용해서 하나씩 삭제 처리
		for (Image img : userImages) {
			image.delete(img.getImageNo()); // 이제 img 변수를 인식합니다.
		}

		// 3. (선택) 찜 목록 등 추가 연동 삭제
		// favoriteService.deleteByUser(userNo);

		// 4. 마지막으로 유저 삭제
		userRepository.setDeleteUser(userNo);
	}

	@Override
	public User findByEmail(String email) {
		return userRepository.findByEmail(email);
	}

	@Override
	public void registerOAuthUser(User user) {
		userRepository.insertOAuthUser(user);
	}

	@Override
	public void updateAccount(int userNo, String bankName, String accountNumber, String accountHolder) {
		userRepository.updateAccount(userNo, bankName, accountNumber, accountHolder);
	}

	@Override
	public List<User> findAdmins() {
		return userRepository.findAdmins();
	}

	@Override
	@Transactional
	public void processReport(int userNo, double scoreAdded, HttpSession session) {
		userRepository.addRiskScore(userNo, scoreAdded);

		Double currentScore = userRepository.getRiskScore(userNo);

		session.setAttribute("reportAlert", "신고가 정상적으로 접수되었습니다.");

		if (currentScore >= 10) {
			userRepository.setDeleteUser(userNo);
		} else if (currentScore >= 8) {
			userRepository.updateSuspension(userNo, null, 3, addDays(7));
		} else if (currentScore >= 5) {
			userRepository.updateSuspension(userNo, addDays(30), 2, addDays(7));
		} else if (currentScore >= 3) {
			userRepository.updateSuspension(userNo, addDays(7), 1, addDays(7));
		}

	}

	// 현재 시간 + n 일후의 Timestamp 반환
	private Timestamp addDays(int days) {
		return new Timestamp(System.currentTimeMillis() + (long) days * 24 * 60 * 60 * 1000L);
	}

	// 제재 상태 체크
	@Override
	public boolean isRestricted(int userNo, String actionType) {
		User user = userRepository.getUserByNo(userNo);

		if (user.getSuspendLevel() == 3)
			return true;

		if ("post".equals(actionType) && (user.getSuspendLevel() == 1 || user.getSuspendLevel() == 2)) {
			return user.getSuspendUntil() != null
					&& user.getSuspendUntil().after(new Timestamp(System.currentTimeMillis()));
		}
		return false;
	}

	@Override
	public String getRestrictMessage(int userNo) {
		User user = userRepository.getUserByNo(userNo);
		double score = user.getRiskScore();
		int level = user.getSuspendLevel();
		Timestamp until = user.getSuspendUntil();

		StringBuilder msg = new StringBuilder();
		msg.append("현재 누적 점수: ").append(String.format("%.1f", score)).append("점\\n");

		if (level == 3) {
			msg.append("제재 등급: 영구 제한 (8점 이상)\\n");
			msg.append("모든 게시글/상품 등록이 영구 제한됩니다.");
		} else if (level == 2) {
			msg.append("제재 등급: 30일 제한 (5점 이상)\\n");
			if (until != null) {
				long remain = (until.getTime() - System.currentTimeMillis()) / (1000 * 60 * 60 * 24);
				msg.append("제한 해제까지 약 ").append(Math.max(remain, 1)).append("일 남았습니다.");
			}
		} else if (level == 1) {
			msg.append("제재 등급: 7일 제한 (3점 이상)\\n");
			if (until != null) {
				long remain = (until.getTime() - System.currentTimeMillis()) / (1000 * 60 * 60 * 24);
				msg.append("제한 해제까지 약 ").append(Math.max(remain, 1)).append("일 남았습니다.");
			}
		}

		return msg.toString();
	}

	/**
	 * 위험 점수를 가산/차감(scoreDelta)한 뒤, 갱신된 점수에 맞춰 제재 상태를 동기화하는 단일 진입점.
	 * 점수 업데이트 관련 로직은 이 메서드로 일원화한다(중복 메서드 금지).
	 *
	 * 1) addRiskScore 로 점수를 반영(DB 에서 [0,10] 범위로 클램프)
	 * 2) 갱신된 최신 점수를 다시 읽어 제재 등급 산정
	 * 3) updateSuspension 으로 상태 갱신 — 3점 미만이면 suspend_level 을 반드시 0 으로 강제하여 제재 해제
	 *
	 * 세 단계가 하나의 트랜잭션으로 묶여 원자적으로 처리된다.
	 */
	@Override
	@Transactional
	public void updateRiskScoreAndSyncStatus(int userNo, double scoreDelta) {

		// 1) 점수 반영
		userRepository.addRiskScore(userNo, scoreDelta);

		// 2) 반영된 최신 점수 조회 (이미지 로딩이 따라오는 getUserByNo 대신 점수만 조회)
		double currentScore = userRepository.getRiskScore(userNo);

		// 3) 점수 구간에 따른 제재 등급/기간 산정
		int newLevel;
		Timestamp newUntil;

		if (currentScore >= 8) {
			newLevel = 3;            // 영구 제한
			newUntil = null;
		} else if (currentScore >= 5) {
			newLevel = 2;            // 30일 제한
			newUntil = addDays(30);
		} else if (currentScore >= 3) {
			newLevel = 1;            // 7일 제한
			newUntil = addDays(7);
		} else {
			newLevel = 0;            // 3점 미만 → 제재 완전 해제(레벨 0 강제)
			newUntil = null;
		}

		// suspend_until / suspend_level / appeal_deadline 을 항상 덮어쓰므로,
		// 레벨 0 일 때 suspend_until 과 appeal_deadline 이 모두 초기화되어 제재가 풀린다.
		userRepository.updateSuspension(userNo, newUntil, newLevel, null);
	}

}