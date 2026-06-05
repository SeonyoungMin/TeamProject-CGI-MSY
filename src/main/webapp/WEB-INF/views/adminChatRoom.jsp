<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상담 - ${room.userNickname}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminChatRoom.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="chat-room-container">
		<div class="is-adminChatRoom-1">
			<a href="${ctx}/admin/chat" class="btn">← 상담 목록</a>
		</div>

		<div class="admin-chat-box">
			<div class="admin-chat-header">
				<span>${room.userNickname}님과의 상담</span>
				<div class="is-adminChatRoom-2">
					<span class="is-adminChatRoom-3">${room.status}</span>
					<form action="${ctx}/admin/chat/${room.roomNo}/end" method="post" class="is-adminChatRoom-4">
						<button type="submit" class="btn btn-danger is-adminChatRoom-5"
							onclick="return confirm('상담을 종료하시겠습니까?')">종료</button>
					</form>
				</div>
			</div>
			<div class="admin-chat-messages" id="adminChatMessages">
				<c:forEach var="msg" items="${message}">
					<c:choose>
						<c:when test="${msg.senderType == 'user'}">
							<div class="msg-label">${msg.senderNickname}</div>
							<div class="msg-user">${msg.content}</div>
						</c:when>
						<c:when test="${msg.senderType == 'bot'}">
							<div class="msg-label">minimarket 챗봇</div>
							<div class="msg-bot">${msg.content}</div>
						</c:when>
						<c:when test="${msg.senderType == 'admin'}">
							<div class="msg-label right">관리자</div>
							<div class="msg-admin">${msg.content}</div>
						</c:when>
					</c:choose>
				</c:forEach>
			</div>
			<div class="admin-chat-input-area">
				<input type="text" id="adminInput" placeholder="메시지를 입력하세요" />
				<button onclick="sendAdminMessage()">전송</button>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	<script>
		var ctx = "${ctx}";
		var adminRoomNo = ${room.roomNo};
		var adminNo = ${loginUser.userNo};
		var stompClient = null;

		function connectWebSocket() {
			var socket = new SockJS(ctx + '/ws');
			stompClient = Stomp.over(socket);
			stompClient.connect({}, function() {
				stompClient.subscribe('/topic/chat/' + adminRooNo,
						function(msg) {
							var data = JSON.parse(msg.body);
							if (data.senderType === 'user') {
								appendMessage(data.senderNickname,
										data.content, 'user');
							}
						});
			});
		}

		function sendAdminMessage() {
			var input = document.getElementById('adminInput');
			var msg = input.value.trim();
			if (!msg || !stompClient)
				return;
			input.value = '';

			stompClient.send("/app/chat.send", {}, JSON.stringify({
				roomNo : adminRoomNo,
				senderNo : adminNo,
				senderType : 'admin',
				content : msg
			}));

			appendMessage('관리자', msg, 'admin');
		}

		function appendMessage(sender, content, type) {
			var messages = document.getElementById('adminChatMessages');
			var label = document.createElement('div');
			label.className = 'msg-label' + (type === 'admin' ? ' right' : '');
			label.textContent = sender;
			var div = document.createElement('div');
			div.className = 'msg-' + type;
			div.textContent = content;
			messages.appendChild(label);
			messages.appendChild(div);
			messages.scrollTop = messages.scrollHeight;
		}

		document.getElementById('adminInput').addEventListener('keypress',
				function(e) {
					if (e.key === 'Enter')
						sendAdminMessage();
				});

		connectWebSocket();
		document.getElementById('adminChatMessages').scrollTop = document
				.getElementById('adminChatMessages').scrollHeight;
	</script>
</body>
</html>