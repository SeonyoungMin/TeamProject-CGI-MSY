package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team404.domain.ReviewDto;
import com.team404.repository.ReviewRepository;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	private ReviewRepository reviewRepository;

	public void registerReview(int productNo, int loginMemberNo, String content) {
		reviewRepository.insertReview(productNo, loginMemberNo, content);
	}

	public ReviewDto findReviewByProduct(int productNo) {
		return reviewRepository.findReviewByProduct(productNo);
	}

	public List<ReviewDto> findReviewsByUser(int userNo) {
		return reviewRepository.findReviewsByUser(userNo);
	}

	public void updateReview(int boardNo, String content, int loginMemberNo) {
		reviewRepository.updateReview(boardNo, content);
	}

	public void deleteReview(int boardNo, int loginMemberNo) {
		reviewRepository.deleteReview(boardNo);
	}

	public boolean existsReview(int productNo, int authorNo) {
		return reviewRepository.existsReview(productNo, authorNo);
	}

}