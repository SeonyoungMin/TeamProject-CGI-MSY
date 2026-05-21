package com.team404.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import com.team404.domain.Order;

@Repository
public class OrderRepositoryImpl implements OrderRepository {

	@Autowired
	private JdbcTemplate template;

	@Override
	public void updateProductStatus(int productNo, String status) {
		String SQL = "UPDATE product SET trade_status = ? WHERE product_no = ?";
		template.update(SQL, status, productNo);
	}

	@Override
	public void markProductAsSold(int productNo, int buyerNo) {
		String SQL = "UPDATE product SET trade_status = '완료', buyer_no = ? WHERE product_no = ?";
		template.update(SQL, buyerNo, productNo);
	}

	@Override
	public void insertOrder(int productNo, int sellerNo, int buyerNo, long price) {
		String SQL = "INSERT INTO orders (product_no, seller_no, buyer_no, price, order_status, created_time) "
				+ "VALUES (?, ?, ?, ?, '완료', NOW())";
		template.update(SQL, productNo, sellerNo, buyerNo, price);
	}

	@Override
	public void increaseSellCount(int userNo) {
		String SQL = "UPDATE users SET sell_count = sell_count + 1 WHERE user_no = ?";
		template.update(SQL, userNo);
	}

	@Override
	public void increaseBuyCount(int userNo) {
		String SQL = "UPDATE users SET buy_count = buy_count + 1 WHERE user_no = ?";
		template.update(SQL, userNo);
	}

	// 후기 작성 칸 생성 여부 (구매자에 한해)
	@Override
	public List<Integer> findProductNosByBuyerAndSeller(int buyerNo, int sellerNo) {
		String SQL = "select product_no from orders where buyer_no = ? and seller_no = ?";
		return template.queryForList(SQL, Integer.class, buyerNo, sellerNo);
	}

	@Override
	public int insertTransferOrder(Order order) {
		String sql = "INSERT INTO orders (" + "product_no, buyer_no, seller_no, price, "
				+ "order_status, created_time, trade_type, " + "receiver_name, receiver_phone, "
				+ "zip_code, address, address_detail, delivery_request, " + "depositor_name) "
				+ "VALUES (?, ?, ?, ?, '입금대기', NOW(), 'TRANSFER', " + "?, ?, ?, ?, ?, ?, ?)";

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
		String sql = "INSERT INTO orders (" + "product_no, buyer_no, seller_no, price, "
				+ "order_status, created_time, trade_type, " + "meeting_place, meeting_time, buyer_message) "
				+ "VALUES (?, ?, ?, ?, '예약중', NOW(), 'DIRECT', " + "?, ?, ?)";

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

	@Override
	public int confirmPayment(int orderNo, int sellerNo) {
		String sql = "UPDATE orders " + "SET order_status = '입금완료', paid_at = NOW() "
				+ "WHERE order_no = ? AND seller_no = ? AND order_status = '입금대기'";
		return template.update(sql, orderNo, sellerNo);
	}

	@Override
	public int completeOrder(int orderNo) {
		String sql = "UPDATE orders SET order_status = '완료' WHERE order_no = ?";
		return template.update(sql, orderNo);
	}

	@Override
	public Order findByOrderNo(int orderNo) {
		String sql = "SELECT * FROM orders WHERE order_no = ?";
		return template.queryForObject(sql, this::mapRow, orderNo);
	}

	private Order mapRow(ResultSet rs, int rowNum) throws SQLException {
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

	@Override
	public List<Order> findPendingTransfersBySeller(int sellerNo) {
		String sql = "SELECT o.*, p.name as product_name " + "FROM orders o "
				+ "JOIN product p ON o.product_no = p.product_no "
				+ "WHERE o.seller_no = ? AND o.order_status = '입금대기' " + "ORDER BY o.created_time DESC";
		return template.query(sql, (rs, rn) -> {
			Order o = mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, sellerNo);
	}

	@Override
	public int completeDirect(int orderNo, int sellerNo) {
		String sql = "UPDATE orders SET order_status = '완료' "
				+ "WHERE order_no = ? AND seller_no = ? AND trade_type = 'DIRECT' AND order_status = '예약중'";
		return template.update(sql, orderNo, sellerNo);
	}

	@Override
	public List<Order> findReservedDirectsBySeller(int sellerNo) {
		String sql = "SELECT o.*, p.name as product_name FROM orders o "
				+ "JOIN product p ON o.product_no = p.product_no "
				+ "WHERE o.seller_no = ? AND o.trade_type = 'DIRECT' AND o.order_status = '예약중' "
				+ "ORDER BY o.created_time DESC";
		return template.query(sql, (rs, rn) -> {
			Order o = mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, sellerNo);
	}

	@Override
	public List<Order> findMyReservedDirects(int userNo) {
		String sql = "SELECT o.*, p.name as product_name FROM orders o "
				+ "JOIN product p ON o.product_no = p.product_no "
				+ "WHERE (o.buyer_no = ? OR o.seller_no = ?) "
				+ "AND o.trade_type = 'DIRECT' AND o.order_status = '예약중' "
				+ "ORDER BY o.meeting_time ASC";
		return template.query(sql, (rs, rn) -> {
			Order o = mapRow(rs, rn);
			o.setProductName(rs.getString("product_name"));
			return o;
		}, userNo, userNo);
	}
}
