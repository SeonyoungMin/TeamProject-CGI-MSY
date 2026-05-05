package com.team404.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team404.domain.Image;
import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;
import com.team404.repository.ProductRepository;

@Service
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductRepository productRepository;
	
	private static final String UPLOAD_DIR = "C:\\team404_upload\\productImg";

	// 상품 목록 조회 (+페이징)
	public List<ProductListDto> findAll(int startNum, int limit) {
		return productRepository.findAll(startNum, limit);
	}
	
	//전체 데이터 개수 반환 (페이징을 위한 보조)
	public int countAll() {
		return productRepository.countAll();
	}

	// 상품 상세 조회 (productNo 기준)
	public ProductDetailDto findProductDetail(int productNo) {
			ProductDetailDto detail = productRepository.findProductDetail(productNo);
			List<Image> images = productRepository.findImagesByProduct(productNo);
			detail.setImages(images);
			return detail;
	}

	// 상품 조건 조회(키워드 검색)
	public List<ProductListDto> findByKeyword(String keyword) {
		return productRepository.findByKeyword(keyword);
	}

	// 카테고리별 조회
	public List<ProductListDto> findByCategory(String category) {
		return productRepository.findByCategory(category);
	}

	// 내 판매 목록 조회
	public List<ProductListDto> findBySeller(int sellerNo) {
		return productRepository.findBySeller(sellerNo);
	}

	// 상품 등록
	public void registerProduct(Product product, List<MultipartFile> imgFiles, int loginMemberNo) {
		
		int productNo = productRepository.insertProduct(product);
		
		productRepository.insertOrder(productNo, loginMemberNo);
		
		if (imgFiles != null && !imgFiles.isEmpty()) {
			for (int i = 0; i < imgFiles.size(); i++) {
				MultipartFile file=imgFiles.get(i);
				if (file != null && !file.isEmpty()) {
					String originalName = file.getOriginalFilename();
					String savedName = UUID.randomUUID().toString() + "_" + originalName;
					File saveFile = new File(UPLOAD_DIR, savedName);
					try {
						saveFile.getParentFile().mkdirs();
						file.transferTo(saveFile);
					} catch (Exception e) {
						throw new RuntimeException("이미지 업로드를 실패하였습니다.", e);
					}
					
					int isThumbnail = (i == 0) ? 1 : 0;
					Image image = new Image(savedName, UPLOAD_DIR + savedName, "product", productNo, isThumbnail);
					productRepository.insertImage(image);
				} 
			}
		}
	}
	
	//상품 수정 (본인 확인 필요)
	public void updateProduct(Product productNo, List<MultipartFile> imgFiles,int loginMemberNo) {
		int sellerNo = productRepository.findSellerNo(productNo.getProductNo());
		
		if (sellerNo != loginMemberNo) {
			throw new RuntimeException("본인의 상품만 수정할 수 있습니다.");
		}
		
		productRepository.updateProduct(productNo);
	}
	
	//상품 삭제 (본인 확인 필요)
	public void deleteProduct(int productNo, int loginMemberNo) {
		int sellerNo = productRepository.findSellerNo(productNo);
		
		if (sellerNo != loginMemberNo) {
			throw new RuntimeException("본인의 상품만 삭제할 수 있습니다.");
			
		}
		
		productRepository.deleteProduct(productNo);
	}
	
	//거래 상태 변경 (본인 확인 필요)
	public void updateTradeStatus(int productNo, String tradeStatus, int loginMemberNo) {
		int sellerNo = productRepository.findSellerNo(productNo);
		
		if (sellerNo != loginMemberNo) {
			throw new RuntimeException("본인의 상품만 상태 변경 할 수 있습니다.");
		}

		productRepository.updateTradeStatus(productNo, tradeStatus);
	}
	
}
