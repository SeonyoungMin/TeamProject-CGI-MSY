package com.team404.service;

import java.io.File;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.domain.SearchDTO;
import com.team404.domain.User;
import com.team404.exception.NoUserFoundException;
import com.team404.repository.UserRepository;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserRepository userRepository;

	@Autowired
	private ImageService image;

	@Override
	public User getUserByNo(int userNo) {
		User userByNo = userRepository.getUserByNo(userNo);
		if (userByNo == null) {
			throw new NoUserFoundException(userNo);
		}
		return userByNo;
	}

	@Override
	public List<User> adminSearchUser(SearchDTO searchDTO) {
		List<User> userBySearch = null;

		if (searchDTO.getSearchMode() == null) {
			userBySearch = userRepository.getAllUsers();
		} else {
			switch (searchDTO.getSearchMode()) {
			case "info":
				userBySearch = userRepository.searchUserByInfo(searchDTO);
				break;
			case "condition":
				userBySearch = userRepository.searchUserByCondition(searchDTO);
			}
		}

		return userBySearch;
	}

	@Override
	public List<User> getAllUsers() {
		return null;
	}

	@Override
	public User getUserById(String userId) {
		// TODO Auto-generated method stub
		return null;
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
			// 새 이미지가 업로드된 경우: 본인의 ImageService 호출
			List<MultipartFile> imageList = Collections.singletonList(editUser.getUserImageFile());

			// 필요하다면 기존 이미지를 먼저 삭제하는 로직을 ImageService에 추가하거나 호출하세요.
			image.upload(imageList, "user", editUser.getUserNo());
		}
		// 이미지가 비어있다면 기존 이미지 정보를 유지하도록 설정 (DB 설계에 따라 다름)

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
}
