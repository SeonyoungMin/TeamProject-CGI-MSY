package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.ReviewDto;

@Repository
public class ReviewRepositoryImpl implements ReviewRepository {

	@Autowired
	private JdbcTemplate template;

	public void insertReview(int productNo, int authorNo, String content) {
		String SQL = "insert into board (title, board_type, content, author_no, product_no, created_time) "
				+ "values ('구매후기', 'review', ?, ?, ?, NOW())";
		template.update(SQL, content, authorNo, productNo);
	}

	// 상품 상세 페이지 후기 조회 (단건)
	public ReviewDto findReviewByProduct(int productNo) {
		String SQL = "select b.board_no, b.content, b.product_no, b.created_time, "
				+ "u.nickname as sellerNickname, p.name as productName " + "from board b "
				+ "join users u on u.user_no = b.author_no " + "join product p on p.product_no = b.product_no "
				+ "where b.product_no = ? and b.board_type = 'review'";
		List<ReviewDto> list = template.query(SQL, new ReviewRowMapper(), productNo);
		return list.isEmpty() ? null : list.get(0);
	}

	// 마이페이지 후기 조회
	public List<ReviewDto> findReviewsByUser(int userNo) {
		String SQL = "SELECT b.board_no, b.content, b.product_no, b.created_time, b.author_no, "
				+ "u.nickname as sellerNickname, p.name as productName " + "FROM board b "
				+ "JOIN product p ON p.product_no = b.product_no " + "JOIN users u ON u.user_no = b.author_no "
				+ "WHERE p.seller_no = ? AND b.board_type = 'review' " + "ORDER BY b.created_time DESC";

		return template.query(SQL, new ReviewRowMapper(), userNo);


	}

	public void updateReview(int boardNo, String content) {
		String SQL = "update board set content = ? where board_no = ?";
		template.update(SQL, content, boardNo);
	}

	public void deleteReview(int boardNo) {
		String SQL = "delete from board where board_no = ?";

		template.update(SQL, boardNo); 
	}

	// 수정, 삭제 본인 확인용
	public int findAuthorNo(int boardNo) {
		String SQL = "select author_no from board where board_no = ?";
		List<Integer> result = template.query(SQL, (rs, rowNum) -> rs.getInt("author_no"), boardNo);
		return result.isEmpty() ? 0 : result.get(0);
	}

	// 같은 유저가 같은 상품에 이미 후기를 썼는지 검사
	public boolean existsReview(int productNo, int authorNo) {
		String SQL = "select count(*) from board "
				+ "where product_no = ? and author_no = ? and board_type = 'review'";
		Integer count = template.queryForObject(SQL, Integer.class, productNo, authorNo);
		return count != null && count > 0;
	}

}
