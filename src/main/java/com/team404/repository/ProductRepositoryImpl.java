package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.Product;
import com.team404.domain.ProductDetailDto;
import com.team404.domain.ProductListDto;

@Repository
public class ProductRepositoryImpl implements ProductRepository {

	@Autowired
	private JdbcTemplate template;

	// 상품 목록 조회
	public List<ProductListDto> findAll(int startNum, int limit) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.view_count, p.created_time, "
				+ "p.seller_no, u.nickname as seller_nickname, " + "i.file_name as img_name, i.file_path as img_path, "
				+ "(select count(*) from favorite f where f.product_no = p.product_no) as favorite_count "
				+ "from product p " + "left join users u on u.user_no = p.seller_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail=1 "
				+ "where p.trade_status != '완료' " 
				+ "order by p.created_time desc limit ?, ? ";
		return template.query(SQL, new ProductListRowMapper(), startNum, limit);
	}

	// 전체 데이터 개수 반환
	public int countAll() {
		String SQL = "select count(*) from product p where p.trade_status != '완료'";
		Long total =  template.queryForObject(SQL, Long.class);
		if (total == null) {
			return 0;
		}
		
		return total.intValue();
	}

	// 상품 상세 조회
	public ProductDetailDto findProductDetail(int productNo) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.description, p.trade_status, p.view_count, p.created_time, "

				+ "p.seller_no, u.nickname as sellerNickname, i.file_name as img_name, i.file_path as img_path "
				+ "from product p " + "left join users u on u.user_no = p.seller_no "
				+ "left join image i on i.entity_type='product' and i.entity_id=p.product_no and i.is_thumbnail=1 "
				+ "where p.product_no=?";
		ProductDetailDto listDetail = template.queryForObject(SQL, new ProductDetailRowMapper(), productNo);
		return listDetail;
	}

	// 상품 조건 조회 (키워드)
	public List<ProductListDto> findByKeyword(String keyword) {
		String SQL ="select p.product_no, p.name, p.category, p.price, p.trade_status, p.view_count, p.created_time, "
	            + "p.seller_no, u.nickname as seller_nickname, i.file_name as img_name, i.file_path as img_path, "
	            + "(select count(*) from favorite f where f.product_no = p.product_no) as favorite_count "  // ← 추가
	            + "from product p "
	            + "left join users u on u.user_no = p.seller_no "
	            + "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
	            + "where p.name like ? and p.trade_status != '완료'";
	    return template.query(SQL, new ProductListRowMapper(), "%" + keyword + "%");
	}

	// 카테고리 조회
	public List<ProductListDto> findByCategory(String category) {

		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.view_count, p.created_time, "
				+ "p.seller_no, u.nickname as seller_nickname, i.file_name as img_name, i.file_path as img_path, "
				+ "(select count(*) from favorite f where f.product_no = p.product_no) as favorite_count "
				+ "from product p " + "left join users u on u.user_no = p.seller_no "

				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where p.category=? and p.trade_status != '완료'";
		return template.query(SQL, new ProductListRowMapper(), category);
	}

	// 내 판매목록 조회 (페이징)
	@Override
	public List<ProductListDto> findBySeller(int sellerNo, int startNum, int limit) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.view_count, p.created_time, "
				+ "p.seller_no, u.nickname as seller_nickname, i.file_name as img_name, i.file_path as img_path, "
				+ "(select count(*) from favorite f where f.product_no = p.product_no) as favorite_count "
				+ "from product p " + "left join users u on u.user_no = p.seller_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where p.seller_no=? order by p.created_time desc limit ?, ?";
		return template.query(SQL, new ProductListRowMapper(), sellerNo, startNum, limit);
	}

	// 내 판매목록 카운트
	@Override
	public int countBySeller(int sellerNo) {
		String SQL = "select count(*) from product where seller_no = ?";
		return template.queryForObject(SQL, Integer.class, sellerNo);
	}

	// 내 판매목록 조회 (전체)
	public List<ProductListDto> findBySeller(int sellerNo) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.view_count, p.created_time, "
				+ "p.seller_no, u.nickname as seller_nickname, i.file_name as img_name, i.file_path as img_path, "
				+ "(select count(*) from favorite f where f.product_no = p.product_no) as favorite_count "
				+ "from product p " + "left join users u on u.user_no = p.seller_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where p.seller_no=?";
		return template.query(SQL, new ProductListRowMapper(), sellerNo);
	}

	// 상품 등록
	@Override
	public int insertProduct(Product product) {

		String SQL = "insert into product (name, category, price, description, seller_no, trade_status, created_time) "
				+ "values (?, ?, ?, ?, ?, '판매중', NOW())";

		template.update(SQL, product.getProductName(), product.getCategory(), product.getPrice(),
				product.getDescription(), product.getSellerNo());

		String selectSQL = "SELECT LAST_INSERT_ID()";
		return template.queryForObject(selectSQL, Integer.class);
	}

	// 상품 수정
	public void updateProduct(Product product) {
		String SQL = "update product set name=?, category=?, price=?, description=? where product_no=?";
		template.update(SQL, product.getProductName(), product.getCategory(), product.getPrice(),
				product.getDescription(), product.getProductNo());
	}

	// 상품 삭제
	public void deleteProduct(int productNo) {
		String SQL = "delete from product where product_no=?";
		template.update(SQL, productNo);
	}

	// 거래 상태 변경
	public void updateTradeStatus(int productNo, String tradeStatus) {
		String SQL = "update product set trade_status=? where product_no=?";
		template.update(SQL, tradeStatus, productNo);
	}

	// 본인 확인용
	public int findSellerNo(int productNo) {
		String SQL = "select seller_no from product where product_no=?";
		return template.queryForObject(SQL, Integer.class, productNo);
	}

	// 상품 등록 시 orders 테이블에도 데이터 추가
	public void insertOrder(int productNo, int sellerNo, int buyerNo) {
		String SQL = "insert into orders (product_no, seller_no, buyer_no, created_time) " + "values (?, ?, ?, NOW())";
		template.update(SQL, productNo, sellerNo, buyerNo);
	}

	// 상품 조회수 +1
	@Override
	public void increaseViewCount(int productNo) {
		String SQL = "update product set view_count = view_count + 1 where product_no = ?";
		template.update(SQL, productNo);
	}

	// 인기 상품 (조회수 desc, 거래완료 제외, 카테고리 옵션)
	@Override
	public List<ProductListDto> findTopByViewCount(int limit, String category) {
		String base = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.view_count, p.created_time, "
				+ "p.seller_no, u.nickname as seller_nickname, " + "i.file_name as img_name, i.file_path as img_path, "
				+ "(select count(*) from favorite f where f.product_no = p.product_no) as favorite_count "
				+ "from product p " + "left join users u on u.user_no = p.seller_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where p.trade_status <> '완료' ";

		if (category != null && !category.isEmpty()) {
			String SQL = base + "and p.category = ? order by p.view_count desc limit ?";
			return template.query(SQL, new ProductListRowMapper(), category, limit);
		}
		String SQL = base + "order by p.view_count desc limit ?";
		return template.query(SQL, new ProductListRowMapper(), limit);
	}
}
