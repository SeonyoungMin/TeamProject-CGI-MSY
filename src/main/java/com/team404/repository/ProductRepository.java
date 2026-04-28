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
	
	//상품 상제 조회 (productNo 기준)
	public ProductDetailDTO findProductDetail(int productNo);
	
	//상품 조건 조회 (상품이름)
	List<ProductListDTO> selectProductByName();
	
	//카테고리 조회
	List<ProductListDTO> selectProdcutByCategory();
	
	//상품 등록
	public void insertProduct(Product productNo);
	public void insertImage(Image image);
	
	//상품 수정
	public void updateProduct(Product productNo);
	
	//상품 삭제
	public void deleteProduct(int productNo);
	
}
