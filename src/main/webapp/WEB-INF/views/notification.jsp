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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notification.css">
</head>

<body style="background: #fafafa; font-family: 'Malgun Gothic', sans-serif;">

<div class="app-container">
	<div class="noti-toolbar">
		<h2 class="section-title is-notification-1">알림</h2>
		<div class="noti-toolbar-actions">
			<%-- 읽지 않은 알림이 있을 때만 전체 읽음 버튼 표시 --%>
			<c:if test="${not empty notifications}">
				<form action="${ctx}/notification/read-all" method="post" class="is-notification-2">
					<button type="submit" class="btn is-notification-3">
						<i class="fa-solid fa-check-double"></i> 전체 읽음
					</button>
				</form>
				<form action="${ctx}/notification/delete-read" method="post" class="is-notification-4">
					<button type="submit" class="btn btn-danger is-notification-5"
						onclick="return confirm('읽은 알림을 모두 삭제할까요?')">
						<i class="fa-solid fa-trash"></i> 읽은 알림 삭제
					</button>
				</form>
			</c:if>
		</div>
	</div>

	<div class="card is-notification-6">
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
										<span class="is-notification-7">NEW</span>
									</c:if>
								</div>
							</div>

							<%-- 단건 삭제 버튼 (li 클릭 이벤트와 분리) --%>
							<form action="${ctx}/notification/delete" method="post" onclick="event.stopPropagation();" class="is-notification-8">
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