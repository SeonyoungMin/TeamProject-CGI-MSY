<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 관리</title>
<style>
.pending-container {
	max-width: 760px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.page-title {
	font-size: 22px;
	font-weight: bold;
	margin: 0 0 8px;
}

.page-desc {
	color: #666;
	margin: 0 0 24px;
	font-size: 14px;
}

.banner {
	padding: 12px 16px;
	border-radius: 8px;
	margin-bottom: 16px;
	font-size: 14px;
}

.banner-success {
	background: #dcfce7;
	color: #166534;
}

.banner-error {
	background: #fef2f2;
	color: #991b1b;
}

.empty-state {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 60px 20px;
	text-align: center;
	color: #888;
}

.pending-card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 18px 22px;
	margin-bottom: 12px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 16px;
}

.pending-info {
	flex: 1;
	min-width: 0;
}

.product-name {
	font-weight: bold;
	font-size: 16px;
	margin: 6px 0;
}

.meta-row {
	font-size: 13px;
	color: #666;
	margin-top: 2px;
}

.meta-row strong {
	color: #121212;
}

.pending-badge {
	display: inline-block;
	padding: 2px 8px;
	background: #fef3c7;
	color: #92400e;
	border-radius: 4px;
	font-size: 12px;
	font-weight: bold;
	margin-right: 6px;
}

.confirm-btn {
	padding: 12px 24px;
	background: #121212;
	color: #fff;
	border: none;
	border-radius: 8px;
	font-weight: bold;
	cursor: pointer;
	font-size: 14px;
	flex-shrink: 0;
}

.confirm-btn:hover {
	background: #333;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="pending-container">

		<h2 class="page-title">거래 관리</h2>
		<p class="page-desc">계좌이체 입금 확인 또는 직거래 약속 완료를 처리해주세요.</p>

		<c:if test="${param.confirmed != null}">
			<div class="banner banner-success">✓ 거래가 완료되었습니다.</div>
		</c:if>
		<c:if test="${param.completed != null}">
			<div class="banner banner-success">✓ 직거래가 완료되었습니다.</div>
		</c:if>
		<c:if test="${param.error == 'cannot-confirm'}">
			<div class="banner banner-error">✗ 이미 처리된 주문이거나 권한이 없어요.</div>
		</c:if>

		<h3 style="font-size: 16px; margin: 18px 0 10px;">계좌이체 입금 대기</h3>
		<c:choose>
			<c:when test="${empty pendingTransfers}">
				<div class="empty-state" style="padding: 30px 20px;">입금 대기 중인 거래가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="o" items="${pendingTransfers}">
					<div class="pending-card">
						<div class="pending-info">
							<div>
								<span class="pending-badge">입금대기</span> <span
									style="font-size: 12px; color: #999;">#${o.orderNo}</span>
							</div>
							<div class="product-name">${o.productName}</div>
							<div class="meta-row">
								입금자명 <strong>${o.depositorName}</strong> · <strong><fmt:formatNumber
										value="${o.price}" />원</strong>
							</div>
							<div class="meta-row">받는 사람: ${o.receiverName} ·
								${o.receiverPhone}</div>
							<div class="meta-row" style="color: #999;">
								<fmt:formatDate value="${o.createdTime}"
									pattern="yyyy-MM-dd HH:mm" />
								주문
							</div>
						</div>
						<form action="${ctx}/order/${o.orderNo}/confirm-payment"
							method="post" style="margin: 0;">
							<button type="submit" class="confirm-btn"
								onclick="return confirm('정말 입금이 확인됐나요?\n확인하면 거래가 완료 처리됩니다.');">
								입금 확인</button>
						</form>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<h3 style="font-size: 16px; margin: 24px 0 10px;">직거래 예약</h3>
		<c:choose>
			<c:when test="${empty reservedDirects}">
				<div class="empty-state" style="padding: 30px 20px;">예약된 직거래가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="o" items="${reservedDirects}">
					<div class="pending-card">
						<div class="pending-info">
							<div>
								<span class="pending-badge" style="background: #e0f2fe; color: #075985;">직거래 예약</span>
								<span style="font-size: 12px; color: #999;">#${o.orderNo}</span>
							</div>
							<div class="product-name">${o.productName}</div>
							<div class="meta-row">
								금액 <strong><fmt:formatNumber value="${o.price}" />원</strong>
							</div>
							<div class="meta-row">
								만남 장소 <strong>${o.meetingPlace}</strong>
							</div>
							<div class="meta-row">
								만남 시간 <strong>
									<c:if test="${not empty o.meetingTime}">
										<fmt:formatDate value="${o.meetingTime}" pattern="yyyy-MM-dd HH:mm" />
									</c:if>
								</strong>
							</div>
							<c:if test="${not empty o.buyerMessage}">
								<div class="meta-row">메시지: ${o.buyerMessage}</div>
							</c:if>
							<div class="meta-row" style="color: #999;">
								<fmt:formatDate value="${o.createdTime}" pattern="yyyy-MM-dd HH:mm" /> 예약
							</div>
						</div>
						<form action="${ctx}/order/direct/${o.orderNo}/complete" method="post" style="margin: 0;">
							<button type="submit" class="confirm-btn"
								onclick="return confirm('거래를 완료 처리하시겠어요?\n구매자에게 완료 알림이 발송됩니다.');">
								거래 완료</button>
						</form>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>