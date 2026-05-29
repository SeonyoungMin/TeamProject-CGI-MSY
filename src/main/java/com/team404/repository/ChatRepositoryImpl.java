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

import com.team404.domain.ChatMessage;
import com.team404.domain.ChatRoom;

@Repository
public class ChatRepositoryImpl implements ChatRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	private final RowMapper<ChatRoom> roomMapper = new RowMapper<ChatRoom>() {
		@Override
		public ChatRoom mapRow(ResultSet rs, int rowNum) throws SQLException {
			ChatRoom room = new ChatRoom();
			room.setRoomNo(rs.getInt("room_no"));
			room.setUserNo(rs.getInt("user_no"));
			room.setStatus(rs.getString("status"));
			java.sql.Timestamp ts = rs.getTimestamp("created_time");
			room.setCreatedTime(ts != null ? ts.toLocalDateTime() : null);
			try {
				room.setUserNickname(rs.getString("nickname"));
			} catch (Exception e) {
			}
			return room;
		}
	};

	private final RowMapper<ChatMessage> messageMapper = new RowMapper<ChatMessage>() {
		@Override
		public ChatMessage mapRow(ResultSet rs, int rowNum) throws SQLException {
			ChatMessage msg = new ChatMessage();
			msg.setRoomNo(rs.getInt("room_no"));
			msg.setMessageNo(rs.getInt("message_no"));
			msg.setSenderNo(rs.getInt("sender_no"));
			msg.setSenderType(rs.getString("sender_type"));
			msg.setContent(rs.getString("content"));
			msg.setRead(rs.getBoolean("is_read"));
			java.sql.Timestamp ts = rs.getTimestamp("created_time");
			msg.setCreatedTime(ts != null ? ts.toLocalDateTime() : null);
			msg.setSenderNickname(rs.getString("nickname"));
			return msg;
		}
	};

	@Override
	public int createRoom(int userNo) {
		String sql = "INSERT INTO chat_room (user_no, status) VALUES (?, '대기')";
		KeyHolder keyHolder = new GeneratedKeyHolder();
		jdbcTemplate.update(con -> {
			PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, userNo);
			return ps;
		}, keyHolder);
		return keyHolder.getKey().intValue();
	}

	@Override
	public ChatRoom findRoomByUserNo(int userNo) {
		String sql = "select r.*, u.nickname from chat_room r " + "left join users u on r.user_no = u.user_no "
				+ "where r.user_no = ? order by r.created_time desc limit 1";
		List<ChatRoom> rooms = jdbcTemplate.query(sql, roomMapper, userNo);
		return rooms.isEmpty() ? null : rooms.get(0);
	}

	@Override
	public ChatRoom findRoomByNo(int roomNo) {
		String sql = "select r.*, u.nickname from chat_room r " + "left join users u on r.user_no = u.user_no "
				+ "where r.room_no = ?";
		List<ChatRoom> rooms = jdbcTemplate.query(sql, roomMapper, roomNo);
		return rooms.isEmpty() ? null : rooms.get(0);
	}

	@Override
	public List<ChatRoom> findAllRooms() {
		String sql = "select r.*, u.nickname from chat_room r " + "left join users u on r.user_no = u.user_no "
				+ "order By r.created_time dessc";
		return jdbcTemplate.query(sql, roomMapper);
	}

	@Override
	public void saveMessage(ChatMessage message) {
		String sql = "insert into chat_message (room_no, sender_no, sender_type, content) " + "values (?, ?, ?, ?)";
		jdbcTemplate.update(sql, message.getRoomNo(), message.getSenderNo(), message.getSenderType(),
				message.getContent());
	}

	@Override
	public List<ChatMessage> findMessageByRoomNo(int roomNo) {
		String sql = "select m*, u.nickname from chat_message m " + "left join users u on m.sender_no = u.user_no "
				+ " where m.room_no = ? order by m.create_time asc";
		return jdbcTemplate.query(sql, messageMapper, roomNo);
	}
	
	@Override
	public void updateRoomStatus(int roomNo, String status) { 
		String sql = "update chat_room set status = ? where room_no = ?";
		jdbcTemplate.update(sql, status, roomNo);
	}
}
