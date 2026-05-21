package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.team404.domain.Rangking;

@Repository
public class RankingRepositoryImpl implements RankingRepository {

	@Autowired
	private JdbcTemplate template;

	// 판매 기록 가져 오기 (판매자 기준)
	@Override
	public List<Rangking> getAllMonthlySales() {
		String SQL = "SELECT o.seller_no AS memberNo, u.nickname AS nickname " // 닉네임과 판매자번호를
				+ "FROM orders o " // 오더테이블에서
				+ "JOIN product p ON p.product_no = o.product_no " // 상품 테이블과 합치고
				+ "JOIN users u ON u.user_no = o.seller_no " // 유저 테이블과 합쳐서
				+ "WHERE p.trade_status = '완료' " // 상품이 거래완료 상태이고
				+ "AND DATE_FORMAT(o.created_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')"; // 이번 달 데이터만 가져오기

		return template.query(SQL, (rs, rowNum) -> {
			Rangking r = new Rangking(); // 랭킹 객체 만들고
			r.setMemberNo(rs.getInt("memberNo")); // 멤버번호 넣고
			r.setNickname(rs.getString("nickname")); // 닉네임 넣고
			r.setTradeCount(1L); // 거래건수 한건으로 설정해서
			return r; // 리스트에 담기
		});
	}

	// 이달의 판매왕 상위 N명 (판매완료된 상품 기준)
	@Override
	public List<Rangking> getTopSellers(int limit) {
		String SQL = "SELECT p.seller_no AS memberNo, u.nickname AS nickname, COUNT(*) AS cnt "
				+ "FROM product p "
				+ "JOIN users u ON u.user_no = p.seller_no "
				+ "WHERE p.trade_status = '완료' "
				+ "  AND DATE_FORMAT(p.created_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') "
				+ "GROUP BY p.seller_no, u.nickname "
				+ "ORDER BY cnt DESC "
				+ "LIMIT ?";
		return template.query(SQL, (rs, rowNum) -> {
			Rangking r = new Rangking();
			r.setMemberNo(rs.getInt("memberNo"));
			r.setNickname(rs.getString("nickname"));
			r.setTradeCount(rs.getLong("cnt"));
			return r;
		}, limit);
	}

	// 이달의 소비왕 상위 N명 (판매완료된 상품의 구매자 기준)
	@Override
	public List<Rangking> getTopBuyers(int limit) {
		String SQL = "SELECT o.buyer_no AS memberNo, u.nickname AS nickname, "
				+ "COUNT(DISTINCT o.product_no) AS cnt "
				+ "FROM orders o "
				+ "JOIN product p ON p.product_no = o.product_no "
				+ "JOIN users u ON u.user_no = o.buyer_no "
				+ "WHERE p.trade_status = '완료' "
				+ "  AND DATE_FORMAT(o.created_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') "
				+ "GROUP BY o.buyer_no, u.nickname "
				+ "ORDER BY cnt DESC "
				+ "LIMIT ?";
		return template.query(SQL, (rs, rowNum) -> {
			Rangking r = new Rangking();
			r.setMemberNo(rs.getInt("memberNo"));
			r.setNickname(rs.getString("nickname"));
			r.setTradeCount(rs.getLong("cnt"));
			return r;
		}, limit);
	}

	// 판매 기록 가져 오기 (구매자 기준)
	@Override
	public List<Rangking> getAllMonthlySpendings() {
		String SQL = "SELECT o.buyer_no AS memberNo, u.nickname AS nickname " // 닉네임과 구매자번호를
				+ "FROM orders o " // 오더테이블에서
				+ "JOIN product p ON p.product_no = o.product_no " // 상품 테이블과 합치고
				+ "JOIN users u ON u.user_no = o.buyer_no " // 유저 테이블과 합쳐서
				+ "WHERE p.trade_status = '완료' " // 상품이 거래완료 상태이고
				+ "AND DATE_FORMAT(o.created_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')"; // 이번 달 데이터만 가져오기

		return template.query(SQL, (rs, rowNum) -> {
			Rangking r = new Rangking(); // 랭킹 객체 만들고
			r.setMemberNo(rs.getInt("memberNo")); // 멤버번호 넣고
			r.setNickname(rs.getString("nickname")); // 닉네임 넣고
			r.setTradeCount(1L); // 거래건수 한건으로 설정해서
			return r; // 리스트에 담기
		});

	}
}
