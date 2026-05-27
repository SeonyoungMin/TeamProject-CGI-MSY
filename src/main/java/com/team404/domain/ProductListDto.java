package com.team404.domain;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

//전체 목록 조회  + 상품 검색 + 카테고리 조회 (메인페이지에 배너 생성) + 내 판매목록 조회
// product + orders(seller_no(목록 조회 판매자 정보) + image(썸네일) 조인 담은 DTO

public class ProductListDto {
	private int productNo;
	private String productName;
	private String category;
	private long price;
	private String tradeStatus;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Timestamp createdTime;
	private int viewCount;

	private int favoriteCount;
	private int isFavorite;

	// orders 테이블 데이터 (orders.product_no = product.product_no)
	private int sellerNo;

	// users.nickname
	private String sellerNickname;

	// image 테이블 데이터 (entity_type='product', is_thumbnail=1)
	private String imgName;
	private String imgPath;

	public ProductListDto() {
		super();
	}

	public int getProductNo() {
		return productNo;
	}

	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public long getPrice() {
		return price;
	}

	public void setPrice(long price) {
		this.price = price;
	}

	public String getTradeStatus() {
		return tradeStatus;
	}

	public void setTradeStatus(String tradeStatus) {
		this.tradeStatus = tradeStatus;
	}

	public Timestamp getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}

	public int getViewCount() {
		return viewCount;
	}

	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}

	public int getSellerNo() {
		return sellerNo;
	}

	public void setSellerNo(int sellerNo) {
		this.sellerNo = sellerNo;
	}

	public String getSellerNickname() {
		return sellerNickname;
	}

	public void setSellerNickname(String sellerNickname) {
		this.sellerNickname = sellerNickname;
	}

	public String getImgName() {
		return imgName;
	}

	public void setImgName(String imgName) {
		this.imgName = imgName;
	}

	public String getImgPath() {
		return imgPath;
	}

	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}

	public int getFavoriteCount() {
		return favoriteCount;
	}

	public void setFavoriteCount(int favoriteCount) {
		this.favoriteCount = favoriteCount;
	}

	public int getIsFavorite() {
		return isFavorite;
	}

	public void setIsFavorite(int isFavorite) {
		this.isFavorite = isFavorite;
	}

}