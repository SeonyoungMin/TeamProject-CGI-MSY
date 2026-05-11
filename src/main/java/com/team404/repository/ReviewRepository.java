package com.team404.repository;

import java.util.List;

import com.team404.domain.ReviewDto;

public interface ReviewRepository {
	
	public void insertReview(int productNo, int authorNo, String content);
	public ReviewDto findReviewByProduct(int productNo);
	public List<ReviewDto> findReviewsByUser(int userNo);
	public void updateReview(int boardNo, String content);
	public void deleteReview(int boardNo);
	public int findAuthorNo(int boardNo);
}
