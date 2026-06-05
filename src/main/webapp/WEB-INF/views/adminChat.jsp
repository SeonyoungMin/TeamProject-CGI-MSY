<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상담 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminChat.css">
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
                                    <a href="${ctx}/admin/chat/${room.roomNo}" class="btn btn-primary is-adminChat-1">입장</a>
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