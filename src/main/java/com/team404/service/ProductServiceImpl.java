package com.team404.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;
import com.team404.repository.ProductRepository;

// ProductService는 더 이상 이미지 처리(File/transferTo/UUID/ProductImage 생성/insertImage)를 알지 않음
//->모든 이미지 처리는 ImageService 로 위임
@Service
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductRepository productRepository;

	// 공통 이미지 서비스 — product / user / board 모두 재사용 가능
	@Autowired
	private ImageService imageService;

	// 상품 목록 조회 (+페이징)
	@Override
	public List<ProductListDto> findAll(int startNum, int limit) {
		return productRepository.findAll(startNum, limit);
	}

	// 전체 데이터 개수 반환
	@Override
	public int countAll() {
		return productRepository.countAll();
	}

	// 상품 상세 조회
	@Override
	public ProductDetailDto findProductDetail(int productNo) {

		ProductDetailDto detail = productRepository.findProductDetail(productNo);

		// productRepository.findImagesByProduct(productNo) 제거
		// 공통 ImageService 로 조회
		List<Image> images = imageService.getImages("product", productNo);
		detail.setImages(images);

		return detail;
	}

	// 키워드 검색
	@Override
	public List<ProductListDto> findByKeyword(String keyword) {
		return productRepository.findByKeyword(keyword);
	}

	// 카테고리 조회
	@Override
	public List<ProductListDto> findByCategory(String category) {
		return productRepository.findByCategory(category);
	}

	// 내 판매 목록
	@Override
	public List<ProductListDto> findBySeller(int sellerNo) {
		return productRepository.findBySeller(sellerNo);
	}

	// 상품 등록
	@Override
	public void registerProduct(Product product, List<MultipartFile> imgFiles, int loginMemberNo) {

		// 1. 상품 저장
		int productNo = productRepository.insertProduct(product);

		// 2. 판매자 정보 저장
		productRepository.insertOrder(productNo, loginMemberNo);

		// 3. File/transferTo/파일명 생성/ProductImage 생성/insertImage 전부 제거
		// 공통 ImageService 로 일괄 위임
		if (imgFiles != null && !imgFiles.isEmpty()) {
			imageService.upload(imgFiles, "product", productNo);
		}
	}

	// 상품 수정
	@Override
	public void updateProduct(Product product, List<MultipartFile> imgFiles, int loginMemberNo) {

		int sellerNo = productRepository.findSellerNo(product.getProductNo());

		if (sellerNo != loginMemberNo) {
			throw new RuntimeException("본인의 상품만 수정할 수 있습니다.");
		}

		// 상품 정보 수정
		productRepository.updateProduct(product);

		// 이미지 추가 업로드도 공통 서비스로 위임
		if (imgFiles != null && !imgFiles.isEmpty()) {
			imageService.upload(imgFiles, "product", product.getProductNo());
		}
	}

	// 상품 삭제
	@Override
	public void deleteProduct(int productNo, int loginMemberNo) {

		int sellerNo = productRepository.findSellerNo(productNo);

		if (sellerNo != loginMemberNo) {
			throw new RuntimeException("본인의 상품만 삭제할 수 있습니다.");
		}

		// 상품 삭제 전 이미지 일괄 삭제 (디스크 파일 + DB)
		imageService.deleteByEntity("product", productNo);

		// 상품 삭제
		productRepository.deleteProduct(productNo);
	}

	// 거래 상태 변경
	@Override
	public void updateTradeStatus(int productNo, String tradeStatus, int loginMemberNo) {

		int sellerNo = productRepository.findSellerNo(productNo);

		if (sellerNo != loginMemberNo) {
			throw new RuntimeException("본인의 상품만 상태 변경 할 수 있습니다.");
		}

		productRepository.updateTradeStatus(productNo, tradeStatus);
	}
}
