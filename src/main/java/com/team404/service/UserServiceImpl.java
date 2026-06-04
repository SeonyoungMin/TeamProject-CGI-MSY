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

		if ("info".equals(searchDTO.getSearchMode())) {
			userBySearch = userRepository.searchUserByInfo(searchDTO, startNumber, limit);
			searchDTO.setTotalRows(userRepository.countForInfo(searchDTO));
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
		return null;
	}

	@Override
	public List<User> getUserByGrade(String userGrade) {
		return null;
	}

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

		if (editUser.getUserPw() == null || editUser.getUserPw().isEmpty()) {
			editUser.setUserPw(userOriginByNo.getUserPw());
		}

		if (editUser.getUserImageFile() != null && !editUser.getUserImageFile().isEmpty()) {

			List<Image> oldImages = image.getImages("user", editUser.getUserNo());
			for (Image oldImg : oldImages) {
				image.delete(oldImg.getImageNo());
			}

			List<MultipartFile> imageList = Collections.singletonList(editUser.getUserImageFile());
			image.upload(imageList, "user", editUser.getUserNo());
		}

		userRepository.setEditUser(editUser);
	}

	@Override
	public void setDeleteUser(int userNo) {
		List<Image> userImages = image.getImages("user", userNo);

		for (Image img : userImages) {
			image.delete(img.getImageNo());
		}

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

	private Timestamp addDays(int days) {
		return new Timestamp(System.currentTimeMillis() + (long) days * 24 * 60 * 60 * 1000L);
	}

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

	@Override
	@Transactional
	public void updateRiskScoreAndSyncStatus(int userNo, double scoreDelta) {

		userRepository.addRiskScore(userNo, scoreDelta);

		double currentScore = userRepository.getRiskScore(userNo);

		int newLevel;
		Timestamp newUntil;

		if (currentScore >= 8) {
			newLevel = 3;
			newUntil = null;
		} else if (currentScore >= 5) {
			newLevel = 2;
			newUntil = addDays(30);
		} else if (currentScore >= 3) {
			newLevel = 1;
			newUntil = addDays(7);
		} else {
			newLevel = 0;
			newUntil = null;
		}

		userRepository.updateSuspension(userNo, newUntil, newLevel, null);
	}

}