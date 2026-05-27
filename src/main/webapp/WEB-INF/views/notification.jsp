<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림 - team404</title>
<%@ include file="header.jsp"%>
<style>
/* ===== 알림 페이지 전용 스타일 ===== */
.noti-toolbar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.noti-toolbar-actions {
	display: flex;
	gap: 8px;
}

.noti-list {
	list-style: none;
	margin: 0;
	padding: 0;
}

.noti-item {
	display: flex;
	align-items: flex-start;
	gap: 14px;
	padding: 16px 20px;
	border-bottom: 1px solid #f0f0f0;
	background: #fff;
	transition: background 0.1s;
	cursor: pointer;
	position: relative;
}

.noti-item:hover {
	background: #f9f9f9;
}

/* 읽지 않은 항목 강조 */
.noti-item.unread {
	background: #fffbf0;
	border-left: 3px solid #f39c12;
}

.noti-item.unread:hover {
	background: #fff8e6;
}

/* 아이콘 원 */
.noti-icon {
	flex-shrink: 0;
	width: 40px;
	height: 40px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 17px;
	color: #fff;
}

.noti-icon.favorite { background: #e74c3c; }
.noti-icon.comment  { background: #3498db; }
.noti-icon.review   { background: #9b59b6; }
.noti-icon.sold     { background: #27ae60; }
.noti-icon.bought   { background: #2980b9; }
.noti-icon.default  { background: #aaa; }

/* 내용 영역 */
.noti-body {
	flex: 1;
	min-width: 0;
}

.noti-message {
	font-size: 14px;
	color: #222;
	line-height: 1.5;
	white-space: pre-line;
	word-break: break-word;
}

.noti-meta {
	font-size: 12px;
	color: #999;
	margin-top: 4px;
}

/* 삭제 버튼 */
.noti-delete-btn {
	flex-shrink: 0;
	background: none;
	border: none;
	color: #ccc;
	font-size: 16px;
	cursor: pointer;
	padding: 4px;
	border-radius: 4px;
	transition: color 0.15s;
}

.noti-delete-btn:hover {
	color: #e74c3c;
}

/* 빈 상태 */
.noti-empty {
	text-align: center;
	padding: 60px 20px;
	color: #aaa;
	font-size: 15px;
}

.noti-empty i {
	font-size: 48px;
	display: block;
	margin-bottom: 16px;
	color: #ddd;
}
</style>
</head>

<body style="background: #fafafa; font-family: 'Malgun Gothic', sans-serif;">

<div class="app-container">
	<div class="noti-toolbar">
		<h2 class="section-title" style="margin: 0; border: none;">알림</h2>
		<div class="noti-toolbar-actions">
			<%-- 읽지 않은 알림이 있을 때만 전체 읽음 버튼 표시 --%>
			<c:if test="${not empty notifications}">
				<form action="${ctx}/notification/read-all" method="post" style="margin:0;">
					<button type="submit" class="btn" style="font-size:13px; padding: 7px 14px;">
						<i class="fa-solid fa-check-double"></i> 전체 읽음
					</button>
				</form>
				<form action="${ctx}/notification/delete-read" method="post" style="margin:0;">
					<button type="submit" class="btn btn-danger" style="font-size:13px; padding: 7px 14px;"
						onclick="return confirm('읽은 알림을 모두 삭제할까요?')">
						<i class="fa-solid fa-trash"></i> 읽은 알림 삭제
					</button>
				</form>
			</c:if>
		</div>
	</div>

	<div class="card" style="padding: 0; overflow: hidden;">
		<c:choose>
			<c:when test="${empty notifications}">
				<div class="noti-empty">
					<i class="fa-regular fa-bell-slash"></i>
					새 알림이 없습니다.
				</div>
			</c:when>

			<c:otherwise>
				<ul class="noti-list">
					<c:forEach var="n" items="${notifications}">

						<%-- 아이콘 선택 --%>
						<c:set var="iconClass" value="default" />
						<c:set var="iconFa"    value="fa-bell" />
						<c:if test="${n.notiType == 'favorite'}">
							<c:set var="iconClass" value="favorite" />
							<c:set var="iconFa"    value="fa-heart" />
						</c:if>
						<c:if test="${n.notiType == 'comment'}">
							<c:set var="iconClass" value="comment" />
							<c:set var="iconFa"    value="fa-comment" />
						</c:if>
						<c:if test="${n.notiType == 'review'}">
							<c:set var="iconClass" value="review" />
							<c:set var="iconFa"    value="fa-star" />
						</c:if>
						<c:if test="${n.notiType == 'sold'}">
							<c:set var="iconClass" value="sold" />
							<c:set var="iconFa"    value="fa-circle-check" />
						</c:if>
						<c:if test="${n.notiType == 'bought'}">
							<c:set var="iconClass" value="bought" />
							<c:set var="iconFa"    value="fa-bag-shopping" />
						</c:if>
						<c:if test="${n.notiType == 'notice'}">
							<c:set var="iconClass" value="default" />
							<c:set var="iconFa"    value="fa-bullhorn" />
						</c:if>

						<li class="noti-item ${n.read ? '' : 'unread'}"
							onclick="goNoti(${n.notificationNo}, '${n.linkUrl}')">

							<div class="noti-icon ${iconClass}">
								<i class="fa-solid ${iconFa}"></i>
							</div>

							<div class="noti-body">
								<div class="noti-message">${n.message}</div>
								<div class="noti-meta">
									<c:if test="${n.senderNo != 0}">
										<span>${n.senderNickname}</span> ·
									</c:if>
									<fmt:formatDate value="${n.createdTime}" pattern="yyyy.MM.dd HH:mm" />
									<c:if test="${!n.read}">
										<span style="color:#f39c12; font-weight:bold; margin-left:6px;">NEW</span>
									</c:if>
								</div>
							</div>

							<%-- 단건 삭제 버튼 (li 클릭 이벤트와 분리) --%>
							<form action="${ctx}/notification/delete" method="post"
								style="margin:0;" onclick="event.stopPropagation();">
								<input type="hidden" name="no" value="${n.notificationNo}">
								<button type="submit" class="noti-delete-btn" title="삭제">
									<i class="fa-solid fa-xmark"></i>
								</button>
							</form>
						</li>
					</c:forEach>
				</ul>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<script>
	/**
	 * 알림 클릭 → 읽음 처리 후 해당 링크로 이동
	 * /notification/read?no=NNN&link=URL
	 */
	function goNoti(notiNo, linkUrl) {
		var ctx = '${ctx}';
		var dest = ctx + '/notification/read?no=' + notiNo;
		if (linkUrl && linkUrl.trim() !== '') {
			dest += '&link=' + encodeURIComponent(linkUrl);
		}
		window.location.href = dest;
	}
</script>

<%@ include file="footer.jsp"%>
</body>
</html>