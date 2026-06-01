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
	public void updateRiskScore(int userNo, double score) {
		userRepository.updateRiskScore(userNo, score);
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
		String alertMsg = "신고가 접수 되었습니다. 현재 누적 점수: " + currentScore + "점. "
				+ "제재 기준 3(게시글 7일 업로드 금지), 5점(30일 금지), 8점(전체 활동 제재).";

		session.setAttribute("reportAlert", alertMsg);
		session.setAttribute("saddedScore", scoreAdded);

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

}