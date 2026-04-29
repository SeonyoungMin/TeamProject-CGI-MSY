package com.team404.repository;

import java.util.List;

import com.team404.domain.Image;
import com.team404.domain.Product;
import com.team404.domain.ProductDetailDTO;
import com.team404.domain.ProductListDTO;

public interface ProductRepository {
	
	//상품 목록 조회 (+페이징)
	List<ProductListDTO> findAll(int startNum, int limit);
	public int countAll();
	//전체 데이터 개수 반환
	
	//상품 상세 조회 (productNo 기준)
	public ProductDetailDTO findProductDetail(int productNo);
	
	//상품 조건 조회(키워드 검색)
	public List<ProductListDTO> findByKeyword(String keyword);
	
	//카테고리별 조회
	public List<ProductListDTO> findByCategory(String category);
	
	//내 판매 목록 조회
	public List<ProductListDTO> findBySeller(int sellerNo);
	
	//상품 등록
	public int insertProduct(Product productNo);
	public void insertImage(Image image);
	
	//상품 수정
	public void updateProduct(Product productNo);
	
	//상품 삭제
	public void deleteProduct(int productNo);
	
	//거래 상태 변경
	public void updateTradeStatus(int productNo, String tradeStatus);
	
	//본인 확인용 (유저가 본인이 등록한 글만 수정/삭제 할 수 있도록 하는 기능)
	public int findSellerNo(int productNo);
}
