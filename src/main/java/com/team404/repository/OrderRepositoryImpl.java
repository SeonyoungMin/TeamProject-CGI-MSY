package com.team404.repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.team404.domain.Order;

@Repository
public class OrderRepositoryImpl implements OrderRepository {

	@Autowired
	private JdbcTemplate template;

	// RowMapper
	private RowMapper<Order> rowMapper = new RowMapper<Order>() {
		@Override
		public Order mapRow(ResultSet rs, int rowNum) throws SQLException {
			Order o = new Order();
			o.setOrderNo(rs.getInt("order_no"));
			o.setProductNo(rs.getInt("product_no"));
			o.setBuyerNo(rs.getInt("buyer_no"));
			o.setSellerNo(rs.getInt("seller_no"));
			o.setPrice(rs.getLong("price"));
			o.setOrderStatus(rs.getString("order_status"));
			o.setCreatedTime(rs.getTimestamp("created_time"));
			o.setMemo(rs.getString("memo"));
			o.setTradeType(rs.getString("trade_type"));
			o.setMeetingPlace(rs.getString("meeting_place"));
			o.setMeetingTime(rs.getTimestamp("meeting_time"));
			o.setBuyerMessage(rs.getString("buyer_message"));
			o.setReceiverName(rs.getString("receiver_name"));
			o.setReceiverPhone(rs.getString("receiver_phone"));
			o.setZipCode(rs.getString("zip_code"));
			o.setAddress(rs.getString("address"));
			o.setAddressDetail(rs.getString("address_detail"));
			o.setDeliveryRequest(rs.getString("delivery_request"));
			o.setDepositorName(rs.getString("depositor_name"));
			o.setPaidAt(rs.getTimestamp("paid_at"));
			return o;
		}
	};

	// product 상태 변경 / 카운트
	@Override
	public void updateProductStatus(int productNo, String status) {
		template.update("UPDATE product SET trade_status=? WHERE product_no=?", status, productNo);
	}

	@Override
	public void markProductAsSold(int productNo, int buyerNo) {
		template.update("UPDATE product SET trade_status='완료', buyer_no=? WHERE product_no=?", buyerNo, productNo);
	}

	@Override
	public void increaseSellCount(int userNo) {
		template.update("UPDATE users SET sell_count=sell_count+1 WHERE user_no=?", userNo);
	}

	@Override
	public void increaseBuyCount(int userNo) {
		template.update("UPDATE users SET buy_count=buy_count+1 WHERE user_no=?", userNo);
	}

	@Override
	public void insertOrder(int productNo, int sellerNo, int buyerNo, long price) {
		template.update(
				"INSERT INTO orders(product_no,seller_no,buyer_no,price,order_status,created_time) VALUES(?,?,?,?,'완료',NOW())",
				productNo, sellerNo, buyerNo, price);
	}

	@Override
	public int insertTransferOrder(Order order) {
		String sql = "INSERT INTO orders(product_no,buyer_no,seller_no,price,order_status,created_time,trade_type,"
				+ "receiver_name,receiver_phone,zip_code,address,address_detail,delivery_request,depositor_name)"
				+ " VALUES(?,?,?,?,'입금대기',NOW(),'TRANSFER',?,?,?,?,?,?,?)";

		KeyHolder keyHolder = new GeneratedKeyHolder();
		template.update(conn -> {
			PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, order.getProductNo());
			ps.setInt(2, order.getBuyerNo());
			ps.setInt(3, order.getSellerNo());
			ps.setLong(4, order.getPrice());
			ps.setString(5, order.getReceiverName());
			ps.setString(6, order.getReceiverPhone());
			ps.setString(7, order.getZipCode());
			ps.setString(8, order.getAddress());
			ps.setString(9, order.getAddressDetail());
			ps.setString(10, order.getDeliveryRequest());
			ps.setString(11, order.getDepositorName());
			return ps;
		}, keyHolder);

		return keyHolder.getKey().intValue();
	}

	@Override
	public int insertDirectOrder(Order order) {
		String sql = "INSERT INTO orders(product_no,buyer_no,seller_no,price,order_status,created_time,trade_type,"
				+ "meeting_place,meeting_time,buyer_message)" + " VALUES(?,?,?,?,'예약중',NOW(),'DIRECT',?,?,?)";

		KeyHolder keyHolder = new GeneratedKeyHolder();
		template.update(conn -> {
			PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, order.getProductNo());
			ps.setInt(2, order.getBuyerNo());
			ps.setInt(3, order.getSellerNo());
			ps.setLong(4, order.getPrice());
			ps.setString(5, order.getMeetingPlace());
			ps.setTimestamp(6, order.getMeetingTime());
			ps.setString(7, order.getBuyerMessage());
			return ps;
		}, keyHolder);

		return keyHolder.getKey().intValue();
	}

	// 동일 구매자가 같은 상품에 진행 중인 요청을 갖고 있는지
	@Override
	public boolean existsActiveTransferRequest(int productNo, int buyerNo) {
		String sql = "SELECT COUNT(*) FROM orders " + "WHERE product_no=? AND buyer_no=? AND trade_type='TRANSFER' "
				+ "AND order_status IN ('요청','승인완료','입금대기')";
		Integer count = template.queryForObject(sql, Integer.class, productNo, buyerNo);
		return count != null && count > 0;
	}

	// 계좌이체 거래 요청 (구매자 ->판매자 승인 대기)
	@Override
	public int insertTransferRequest(int productNo, int sellerNo, int buyerNo, long price) {
		String sql = "INSERT INTO orders(product_no,seller_no,buyer_no,price,order_status,created_time,trade_type)"
				+ " VALUES(?,?,?,?,'요청',NOW(),'TRANSFER')";

		KeyHolder keyHolder = new GeneratedKeyHolder();
		template.update(conn -> {
			PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, productNo);
			ps.setInt(2, sellerNo);
			ps.setInt(3, buyerNo);
			ps.setLong(4, price);
			return ps;
		}, keyHolder);

		return keyHolder.getKey().intValue();
	}

	@Override
	public int confirmPayment(int orderNo, int sellerNo) {
		return template.update(
				"UPDATE orders SET order_status='입금완료', paid_at=NOW() WHERE order_no=? AND seller_no=? AND order_status='입금대기'",
				orderNo, sellerNo);
	}

	@Override
	public int completeOrder(int orderNo) {
		return template.update("UPDATE orders SET order_status='완료' WHERE order_no=?", orderNo);
	}

	@Override
	public int completeDirect(int orderNo, int sellerNo) {
		return template.update(
				"UPDATE orders SET order_status='완료' WHERE order_no=? AND seller_no=? AND trade_type='DIRECT' AND order_status='예약중'",
				orderNo, sellerNo);
	}

	@Override
	public int cancelDirect(int orderNo, int sellerNo) {
		return template.update(
				"UPDATE orders SET order_status='취소' WHERE order_no=? AND seller_no=? AND trade_type='DIRECT' AND order_status='예약중'",
				orderNo, sellerNo);
	}

	@Override
	public void approveTransfer(int orderNo, int userNo) {
		template.update("UPDATE orders SET order_status='승인완료' WHERE order_no=? AND seller_no=? AND order_status='요청'",
				orderNo, userNo);
	}

	@Override
	public int cancelAllActiveByProduct(int productNo) {
		String sql = "UPDATE orders SET order_status='취소' "
				+ "WHERE product_no=? AND order_status IN ('예약중','입금대기','요청','승인완료')";
		return template.update(sql, productNo);
	}

	@Override
	public int cancelOtherRequests(int productNo, int approvedOrderNo) {
		String sql = "UPDATE orders SET order_status='취소' "
				+ "WHERE product_no=? AND order_no<>? AND order_status='요청'";
		return template.update(sql, productNo, approvedOrderNo);
	}

	// 본인(구매자 또는 판매자)이 진행중 거래를 취소.
	// 완료/입금완료 상태는 차단, 0행이면 권한 없거나 이미 처리됨
	@Override
	public int cancelTransferOrder(int orderNo, int userNo) {
		String sql = "UPDATE orders SET order_status='취소' " + "WHERE order_no=? AND (seller_no=? OR buyer_no=?) "
				+ "AND trade_type='TRANSFER' " + "AND order_status IN ('요청','승인완료','입금대기')";
		return template.update(sql, orderNo, userNo, userNo);
	}

	@Override
	public List<Integer> findProductNosByBuyerAndSeller(int buyerNo, int sellerNo) {
		return template.queryForList("SELECT product_no FROM orders WHERE buyer_no=? AND seller_no=?", Integer.class,
				buyerNo, sellerNo);
	}

	@Override
	public Order findByOrderNo(int orderNo) {
		return template.queryForObject("SELECT * FROM orders WHERE order_no=?", rowMapper, orderNo);
	}

	@Override
	public Order findByProductAndBuyer(int productNo, int buyerNo) {
		List<Order> list = template.query(
				"SELECT * FROM orders WHERE product_no=? AND buyer_no=? ORDER BY order_no DESC LIMIT 1", rowMapper,
				productNo, buyerNo);
		return list.isEmpty() ? null : list.get(0);
	}

	@Override
	public List<Order> findPendingTransfersBySeller(int sellerNo) {
		String sql = "SELECT o.*, p.name AS product_name FROM orders o "
				+ "JOIN product p ON o.product_no=p.product_no " + "WHERE o.seller_no=? AND o.order_status='입금대기' "
				+ "ORDER BY o.created_time DESC";
		return template.query(sql, (rs, rn) -> {
			Order o = rowMapper.mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, sellerNo);
	}

	@Override
	public List<Order> findReservedDirectsBySeller(int sellerNo) {
		String sql = "SELECT o.*, p.name AS product_name FROM orders o "
				+ "JOIN product p ON o.product_no=p.product_no "
				+ "WHERE o.seller_no=? AND o.trade_type='DIRECT' AND o.order_status='예약중' "
				+ "ORDER BY o.created_time DESC";
		return template.query(sql, (rs, rn) -> {
			Order o = rowMapper.mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, sellerNo);
	}

	@Override
	public List<Order> findMyReservedDirects(int userNo) {
		String sql = "SELECT o.*, p.name AS product_name FROM orders o "
				+ "JOIN product p ON o.product_no=p.product_no "
				+ "WHERE (o.buyer_no=? OR o.seller_no=?) AND o.trade_type='DIRECT' AND o.order_status='예약중' "
				+ "ORDER BY o.meeting_time ASC";
		return template.query(sql, (rs, rn) -> {
			Order o = rowMapper.mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, userNo, userNo);
	}

	// 판매자가 승인해야 할 거래 요청 목록
	@Override
	public List<Order> findTransferRequestsBySeller(int sellerNo) {
		String sql = "SELECT o.*, p.name AS product_name FROM orders o "
				+ "JOIN product p ON o.product_no=p.product_no "
				+ "WHERE o.seller_no=? AND o.trade_type='TRANSFER' AND o.order_status='요청' "
				+ "ORDER BY o.created_time DESC";
		return template.query(sql, (rs, rn) -> {
			Order o = rowMapper.mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, sellerNo);
	}

	// 승인했으나 아직 구매자 결제 전인 계좌이체 주문 목록
	@Override
	public List<Order> findApprovedTransfersBySeller(int sellerNo) {
		String sql = "SELECT o.*, p.name AS product_name FROM orders o "
				+ "JOIN product p ON o.product_no=p.product_no "
				+ "WHERE o.seller_no=? AND o.trade_type='TRANSFER' AND o.order_status='승인완료' "
				+ "ORDER BY o.created_time DESC";
		return template.query(sql, (rs, rn) -> {
			Order o = rowMapper.mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, sellerNo);
	}

	// 상품을 현재 점유 중인 활성 예약 주문 — 직거래 예약중 / 계좌이체 승인완료·입금대기
	@Override
	public Order findActiveReservationByProduct(int productNo) {
		String sql = "SELECT * FROM orders WHERE product_no=? "
				+ "AND order_status IN ('예약중','승인완료','입금대기') "
				+ "ORDER BY order_no DESC LIMIT 1";
		List<Order> list = template.query(sql, rowMapper, productNo);
		return list.isEmpty() ? null : list.get(0);
	}
}