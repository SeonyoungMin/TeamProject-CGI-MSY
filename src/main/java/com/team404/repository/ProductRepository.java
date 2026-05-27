package com.team404.repository;

import java.util.List;

import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;

public interface ProductRepository {

	// 상품 목록 조회 (+페이징)
	List<ProductListDto> findAll(int startNum, int limit, int loginUserNo);

	// 전체 데이터 개수
	int countAll();

	// 상품 상세 조회
	ProductDetailDto findProductDetail(int productNo);

	// 키워드 검색
	List<ProductListDto> findByKeyword(String keyword);

	// 카테고리 조회
	List<ProductListDto> findByCategory(String category);

	// 내 판매 목록 조회 (전체)
	List<ProductListDto> findBySeller(int sellerNo);

	// 내 판매 목록 조회 (페이징)
	List<ProductListDto> findBySeller(int sellerNo, int startNum, int limit);

	// 판매글 개수
	int countBySeller(int sellerNo);

	// 상품 등록
	int insertProduct(Product product);

	// 상품 수정
	void updateProduct(Product product);

	// 상품 삭제
	void deleteProduct(int productNo);

	// 거래 상태 변경
	void updateTradeStatus(int productNo, String tradeStatus);

	// 판매자 번호 조회
	int findSellerNo(int productNo);

	// 주문 생성
	void insertOrder(int productNo, int sellerNo, int buyerNo);

	// 조회수 증가
	void increaseViewCount(int productNo);

	// 인기 상품
	List<ProductListDto> findTopByFavoriteCount(int limit, String category, int loginUserNo);

	// 구매내역 (전체)
	List<ProductListDto> findBoughtListByBuyerNo(int buyerNo);

	// 구매내역 (페이징)
	List<ProductListDto> findBoughtListByBuyerNo(int buyerNo, int startNum, int limit);

	// 구매내역 총 개수
	int countBoughtByBuyerNo(int buyerNo);
}