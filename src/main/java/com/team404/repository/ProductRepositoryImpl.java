package com.team404.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.team404.domain.Image;
import com.team404.domain.Product;
import com.team404.domain.ProductDetailDTO;
import com.team404.domain.ProductListDTO;

@Repository
public class ProductRepositoryImpl implements ProductRepository {

	@Autowired
	private JdbcTemplate template;

	// 상품 목록 조회
	public List<ProductListDTO> findAll(int startNum, int limit) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.created_time, "
				+ "o.seller_no, m.nickname as seller_nickname, " + "o.seller_no, i.file_name as img_name, i.file_path as img_path " + "from product p"
				+ "left join orders o on o.product_no = p.product_no " + "left join users u on u.user_no = o.seller_no"
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumnail=1 "
				+ "order by p.created_time desc limit ?, ?";
		return template.query(SQL, new ProductListRowMapper(), startNum, limit);
	}

	// 전체 데이터 개수 반환
	public int countAll() {
		String SQL = "select count(*) from product";
		return template.queryForObject(SQL, Integer.class);
	}

	// 상품 상세 조회
	public ProductDetailDTO findProductDetail(int productNo) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.description, p.trade_status, p.created_time, "
				+ "o.seller_no, o.buyer_no, u.nickname as seller_nickname, "
				+ "i.file_name as img_name, i.file_path as img_path " + "from product p "
				+ "left join orders o on o.product_no=p.product_no " + "left join users u on u.user_no= o.seller_no "
				+ "left join image i on i.entity_type='product' and i.entity_id=p.product_no and i.is_thumnail=1 "
				+ "where p.product_no=?";
		ProductDetailDTO listDetail = template.queryForObject(SQL, new ProductDetailRowMapper(), productNo);
		return listDetail;
	}

	// 상품 조건 조회 (키워드)
	public List<ProductListDTO> findByKeyword(String keyword) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.create_time, "
				+ "o.seller_no, i.file_name as img_name, i.file_path as img_path " + "from product p"
				+ "left join orders o on o.product_no = p.product_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where p.name like ?";
		return template.query(SQL, new ProductListRowMapper(), "%" + keyword + "%");
	}
	
	//카테고리 조회
	public List<ProductListDTO> findByCategory(String category) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.create_time, "
				+ "o.seller_no, i.file_name as img_name, i.file_path as img_path " + "from product p "
				+ "left join orders o on o.product_no = p.product_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where p.category=?";
		return template.query(SQL, new ProductListRowMapper(), category);
	}
	
	//내 판매목록 조회
	public List<ProductListDTO> findBySeller(int sellerNo) {
		String SQL = "select p.product_no, p.name, p.category, p.price, p.trade_status, p.create_time, "
				+ "o.seller_no, i.file_name as img_name, i.file_path as img_path " + "from product p "
				+ "left join orders o on o.product_no = p.product_no "
				+ "left join image i on i.entity_type = 'product' and i.entity_id = p.product_no and i.is_thumbnail = 1 "
				+ "where o.seller_no=?";
		return template.query(SQL, new ProductListRowMapper(), sellerNo);
	}
	
	//상품 등록
	public int insertProduct(Product productNo) {
		String SQL = "insert into product (name, category, price, description, trade_status, created_time)" + "values (?,?,?,?, '판매중', NOW())";
		
		KeyHolder keyHolder = new GeneratedKeyHolder();
		template.update(con -> {PreparedStatement ps = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
		ps.setString(1, productNo.getProductName());
		ps.setString(2, productNo.getCategory());
		ps.setLong(3, productNo.getPrice());
		ps.setString(4, productNo.getDescription()); 
		return ps;
		}, keyHolder);
		
		return keyHolder.getKey().intValue();
	}
	
	//상품 이미지 등록
	public void insertImage(Image image) {
		String SQL = "insert into image (file_name, file_path, entity_type, entity_id, is_thumbnail, created_time) " + "values(?, ?, ?, ?, ?, NOW())";
		template.update(SQL, image.getFileName(), image.getFilePath(), image.getEntitlyType(), image.getEntityId(), image.getIsThumnail(), image.getCreatedTime());
	}
	
	//상품 수정
	public void updateProduct(Product product) {
		String SQL = "update product set name=?, category=?, price=?, description=? where product_no=?";
		template.update(SQL, product.getProductName(), product.getCategory(), product.getPrice(), product.getDescription());
	}
	
	//상품 삭제
	public void deleteProduct(int productNo) {
		String SQL = "delet from product where product_no=?";
		template.update(SQL, productNo);
	}
	
	//거래 상태 변경
	public void updateTradeStatus(int productNo, String tradeStatus) {
		String SQL = "update product set trade_status=? where product_no=?";
		template.update(SQL, productNo, tradeStatus);
	}
	
	//본인 확인용
	public int findSellerNo(int productNo) {
		String SQL = "select seller_no from orders where product_no=?";
		return template.queryForObject(SQL, Integer.class, productNo);
	}
}
