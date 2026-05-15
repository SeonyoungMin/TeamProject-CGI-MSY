package com.team404.service;

import java.util.List;

import com.team404.domain.ReviewDto;

public interface ReviewService {
	
	public void registerReview(int productNo, int loginMemberNo, String content);
	public ReviewDto findReviewByProduct(int productNo);
	public List<ReviewDto> findReviewsByUser(int userNo);
	public void updateReview(int boardNo, String content, int loginMemberNo);
	public void deleteReview(int boardNo, int loginMemberNo);
	public boolean existsReview(int productNo, int authorNo);

}
