package com.team404.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.team404.domain.ProductDetailDTO;
import com.team404.domain.ProductListDTO;
import com.team404.service.ProductService;

@Controller
public class ProductController {

	@Autowired
	private ProductService productService;
	
	//상품 전체 목록 조회 (+페이징)
	@GetMapping("/productList")
	public String getProductList(@RequestParam(value="pageNum", defaultValue="1") int pageNum, 
			@RequestParam(value="limit", defaultValue="6") int limit, Model model) {
		
		int startNum = limit * (pageNum -1);
		
		List<ProductListDTO> listAll = productService.findAll(startNum, limit);
		
		int totalNum = productService.countAll();
		
		int totalPages = (totalNum % limit) == 0 ? totalNum / limit : (totalNum / limit) +1;
		
		model.addAttribute("list", listAll);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", pageNum);
		return "productList";
	}
	
	//상품 상세 조회
	@GetMapping("/productList/{productNo}")
	public String getProduct (@PathVariable("productNo") int productNo, Model model) {
		ProductDetailDTO listByProductNo = productService.findProductDetail(productNo);
		model.addAttribute("listByProductNo", listByProductNo);
		return "product";
	}
	
	//상품 조건 조회
	@GetMapping("/productList/search")
	public String searchProducts (@RequestParam("keyword") String keyword, Model model) {
		List<ProductListDTO> searchByKeyword = productService.findByKeyword(keyword);
		model.addAttribute("searchByKeyword",searchByKeyword);
		model.addAttribute("keyword", keyword);
		return "productList";
	}
	
	//카테고리별 조회
	@GetMapping(/productList/category)
	public String getProductsByCategory (@RequestParam("category") String category, Model model) {
		List<ProductListDTO> 
	}
	
	//내 판매 목록 조회
	
	//상품 등록 (본인 확인 필요)
	
	//상품 수정 (본인 확인 필요)
	
	//상품 삭제 (본인 확인 필요)
	
	//상품 거래 상태 변경 (본인 확인 필요)
	
}
