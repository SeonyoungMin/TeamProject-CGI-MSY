package com.team404.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Product;
import com.team404.domain.ProductDetailDTO;
import com.team404.domain.ProductListDTO;
import com.team404.repository.ProductRepository;

public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductRepository productRepository;
	
	private static final String UPLOAD_DIR = "C:\\team404_upload\\productImg";

	// 상품 목록 조회 (+페이징)
	public List<ProductListDTO> findAll(int startNum, int limit) {
		return productRepository.findAll(startNum, limit);
	}
	
	//전체 데이터 개수 반환
	public int countAll() {
		return productRepository.countAll();
	}

	// 상품 상세 조회 (productNo 기준)
	public ProductDetailDTO findProductDetail(int productNo) {
		return productRepository.findProductDetail(productNo);
	}

	// 상품 조건 조회(키워드 검색)
	public List<ProductListDTO> findByKeyword(String keyword) {
		return productRepository.findByKeyword(keyword);
	}

	// 카테고리별 조회
	public List<ProductListDTO> findByCategory(String category) {
		return productRepository.findByCategory(category);
	}

	// 내 판매 목록 조회
	public List<ProductListDTO> findBySeller(int sellerNo) {
		return productRepository.findBySeller(sellerNo);
	}

	// 상품 등록
	public int registerProduct(Product product, List<MultipartFile> imgFiles) {
		
		int productNo = productRepository.insertProduct(product);
		
		if (imgFiles != null && !imgFiles.isEmpty()) {
			for (int i = 0; i < imgFiles.size(); i++) {
				MultipartFile file=imgFiles.get(i);
				if (file != null && !file.isEmpty()) {
					String originalName = file.getOriginalFilename();
					String savedName = UUID.randomUUID().toString() + "_" + originalName;
					
					
				}
			}
		}
	}
	
}
