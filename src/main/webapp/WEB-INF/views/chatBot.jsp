<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<div class="chat-wrapper">
    <div class="chat-box" id="chatBox">
        <div class="chat-header">
            <div>minimarket 고객센터</div>
            <span>평일 09:00 ~ 18:00 관리자 상담 가능</span>
        </div>
        <div class="chat-messages" id="chatMessages">
            <div class="typing-indicator" id="typingIndicator">입력 중...</div>
        </div>
        <div id="adminRequestArea"></div>
        <div class="chat-input-area">
            <input type="text" id="chatInput" placeholder="메시지를 입력하세요" />
            <button onclick="sendMessage()">전송</button>
        </div>
    </div>
    <button class="chat-toggle-btn" onclick="toggleChat()">
        <i class="fa-solid fa-comment"></i>
    </button>
</div>

<script>
var chatCtx = "${ctx}";
var chatRoomNo = 0;
var chatLoginUser = ${not empty sessionScope.loginUser ? sessionScope.loginUser.userNo : 0};
var stompClient = null;
var isAdminMode = false;

function toggleChat() {
    var box = document.getElementById('chatBox');
    box.classList.toggle('open');
    if (box.classList.contains('open') && document.getElementById('chatMessages').children.length <= 1) {
        appendBotMessage("안녕하세요! minimarket 고객센터입니다. 무엇을 도와드릴까요?");
    }
    scrollToBottom();
}

function sendMessage() {
    var input = document.getElementById('chatInput');
    var msg = input.value.trim();
    if (!msg) return;
    input.value = '';

    appendUserMessage(msg);

    if (isAdminMode) {
        stompClient.send("/app/chat.send", {}, JSON.stringify({
            roomNo: chatRoomNo,
            senderNo: chatLoginUser,
            senderType: 'user',
            content: msg
        }));
    } else {
        showTyping(true);
        $.post(chatCtx + '/chat/bot', { message: msg }, function(reply) {
            showTyping(false);
            if (reply.includes('||NEED_ADMIN')) {
                var text = reply.replace('||NEED_ADMIN', '');
                appendBotMessage(text);
                showAdminRequestBtn();
            } else {
                appendBotMessage(reply);
            }
        });
    }
}

function appendUserMessage(msg) {
    var messages = document.getElementById('chatMessages');
    var div = document.createElement('div');
    div.className = 'msg-user';
    div.textContent = msg;
    messages.insertBefore(div, document.getElementById('typingIndicator'));
    scrollToBottom();
}

function appendBotMessage(msg) {
    var messages = document.getElementById('chatMessages');
    var label = document.createElement('div');
    label.className = 'msg-label';
    label.textContent = 'minimarket 챗봇';
    var div = document.createElement('div');
    div.className = 'msg-bot';
    div.textContent = msg;
    messages.insertBefore(label, document.getElementById('typingIndicator'));
    messages.insertBefore(div, document.getElementById('typingIndicator'));
    scrollToBottom();
}

function showAdminRequestBtn() {
    if (chatLoginUser == 0) {
        document.getElementById('adminRequestArea').innerHTML =
            '<div style="text-align:center; padding: 8px; font-size:12px; color:#888;">관리자 상담은 로그인 후 이용 가능합니다.</div>';
        return;
    }
    document.getElementById('adminRequestArea').innerHTML =
        '<button class="admin-request-btn" onclick="requestAdmin()">관리자 상담 요청하기</button>';
}

function requestAdmin() {
    $.post(chatCtx + '/chat/request-admin', function(result) {
        if (result === 'ok') {
            document.getElementById('adminRequestArea').innerHTML =
                '<div style="text-align:center; padding: 8px; font-size:12px; color:#888;">관리자에게 알림을 보냈습니다. 잠시만 기다려주세요.</div>';
            connectWebSocket();
        }
    });
}

function connectWebSocket() {
    var socket = new SockJS(chatCtx + '/ws');
    stompClient = Stomp.connect(socket, function() {
        stompClient.subscribe('/topic/chat/' + chatRoomNo, function(msg) {
            var data = JSON.parse(msg.body);
            if (data.senderType === 'admin') {
                appendAdminMessage(data.content);
            }
        });
        isAdminMode = true;
    });
}

function appendAdminMessage(msg) {
    var messages = document.getElementById('chatMessages');
    var label = document.createElement('div');
    label.className = 'msg-label';
    label.textContent = '관리자';
    var div = document.createElement('div');
    div.className = 'msg-admin';
    div.textContent = msg;
    messages.insertBefore(label, document.getElementById('typingIndicator'));
    messages.insertBefore(div, document.getElementById('typingIndicator'));
    scrollToBottom();
}

function showTyping(show) {
    document.getElementById('typingIndicator').style.display = show ? 'block' : 'none';
    scrollToBottom();
}

function scrollToBottom() {
    var msgs = document.getElementById('chatMessages');
    msgs.scrollTop = msgs.scrollHeight;
}

document.getElementById('chatInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') sendMessage();
});
</script>