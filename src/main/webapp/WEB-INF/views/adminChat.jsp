<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상담 관리</title>
<style>
.chat-admin-container {
    max-width: 900px;
    margin: 30px auto;
    padding: 20px;
}

.chat-room-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
}

.chat-room-table th {
    background: #f5f5f5;
    padding: 12px;
    text-align: center;
    border-bottom: 2px solid #ddd;
    font-weight: bold;
    color: #333;
}

.chat-room-table td {
    padding: 12px;
    border-bottom: 1px solid #eee;
    text-align: center;
    vertical-align: middle;
}

.chat-room-table tr:hover td {
    background: #fafafa;
}

.status-badge {
    display: inline-block;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
}

.status-대기 { background: #fff3cd; color: #856404; }
.status-상담대기 { background: #cce5ff; color: #004085; }
.status-상담중 { background: #d4edda; color: #155724; }
.status-종료 { background: #e2e3e5; color: #383d41; }

.empty-msg {
    text-align: center;
    padding: 60px 0;
    color: #bbb;
    font-size: 15px;
}
</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp"%>

    <div class="chat-admin-container">
        <h2 class="section-title">상담 관리</h2>

        <table class="chat-room-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>유저</th>
                    <th>상태</th>
                    <th>시작일</th>
                    <th>입장</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty rooms}">
                        <tr>
                            <td colspan="5" class="empty-msg">상담 내역이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="room" items="${rooms}">
                            <tr>
                                <td>${room.roomNo}</td>
                                <td>${room.userNickname}</td>
                                <td>
                                    <span class="status-badge status-${room.status}">${room.status}</span>
                                </td>
                                <td>${room.createdTime.toString().substring(0, 10)}</td>
                                <td>
                                    <a href="${ctx}/admin/chat/${room.roomNo}" class="btn btn-primary"
                                        style="font-size: 12px; padding: 4px 10px;">입장</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>