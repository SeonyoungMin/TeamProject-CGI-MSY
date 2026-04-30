package com.team404.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;

public interface ProductService {

	//상품 목록 조회 (+페이징)
		List<ProductListDto> findAll(int startNum, int limit);
		
		public int countAll();
		//전체 데이터 개수 반환
		
		//상품 상세 조회 (productNo 기준)
		public ProductDetailDto findProductDetail(int productNo);
		
		//상품 조건 조회(키워드 검색)
		public List<ProductListDto> findByKeyword(String keyword);
		
		//카테고리별 조회
		public List<ProductListDto> findByCategory(String category);
		
		//내 판매 목록 조회
		public List<ProductListDto> findBySeller(int sellerNo);
		
		//상품 등록
		public void registerProduct(Product product, List<MultipartFile> imgFiles, int loginMemberNo);
		
		//상품 수정 (본인 확인 필요)
		public void updateProduct(Product productNo, List<MultipartFile> imgFiles, int loginMemberNo);
		
		//상품 삭제 (본인 확인 필요)
		public void deleteProduct(int productNo, int loginMemberNo);
		 
		//거래 상태 변경 (본인 확인 필요)
		public void updateTradeStatus(int productNo, String tradeStatus, int loginMemberNo);
		
	}

