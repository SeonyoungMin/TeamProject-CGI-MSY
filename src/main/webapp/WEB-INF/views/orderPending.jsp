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

.action-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
	flex-shrink: 0;
}

.cancel-btn {
	padding: 10px 18px;
	background: #fff;
	color: #e74c3c;
	border: 1px solid #e74c3c;
	border-radius: 8px;
	font-weight: bold;
	cursor: pointer;
	font-size: 13px;
}

.cancel-btn:hover {
	background: #fdecea;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="pending-container">

		<h2 class="page-title">거래 관리</h2>
		<p class="page-desc">계좌이체 입금 확인 또는 직거래 약속 완료를 처리해주세요.</p>

		<c:if test="${param.confirmed != null}">
			<div class="banner banner-success"> 거래가 완료되었습니다.</div>
		</c:if>
		<c:if test="${param.completed != null}">
			<div class="banner banner-success"> 직거래가 완료되었습니다.</div>
		</c:if>
		<c:if test="${param.cancelled != null}">
			<div class="banner banner-success"> 예약이 취소되었습니다. 대기자에게 알림이 발송됐어요.</div>
		</c:if>
		<c:if test="${param.error == 'cannot-confirm'}">
			<div class="banner banner-error"> 이미 처리된 주문이거나 권한이 없어요.</div>
		</c:if>
		<c:if test="${param.error == 'cannot-cancel'}">
			<div class="banner banner-error"> 취소할 수 없는 주문이거나 권한이 없어요.</div>
		</c:if>
		<c:if test="${param.approved != null}">
			<div class="banner banner-success"> 거래 요청을 승인했습니다. 구매자에게 알림이 발송됐어요.</div>
		</c:if>
		<c:if test="${param.transferCancelled != null}">
			<div class="banner banner-success"> 거래가 취소되었습니다. 관련 알림도 정리됐어요.</div>
		</c:if>
		<c:if test="${param.error == 'cannot-approve'}">
			<div class="banner banner-error"> 이미 다른 거래가 진행 중이거나 권한이 없습니다.</div>
		</c:if>
		<c:if test="${param.error == 'cannot-cancel-transfer'}">
			<div class="banner banner-error"> 입금이 완료된 거래는 취소할 수 없습니다.</div>
		</c:if>

		<h3 style="font-size: 16px; margin: 18px 0 10px;">계좌이체 거래 요청</h3>
		<c:choose>
			<c:when test="${empty transferRequests}">
				<div class="empty-state" style="padding: 30px 20px;">새로운 거래 요청이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="o" items="${transferRequests}">
					<div class="pending-card">
						<div class="pending-info">
							<div>
								<span class="pending-badge" style="background: #ede9fe; color: #5b21b6;">거래 요청</span>
								<span style="font-size: 12px; color: #999;">#${o.orderNo}</span>
							</div>
							<div class="product-name">${o.productName}</div>
							<div class="meta-row">
								금액 <strong><fmt:formatNumber value="${o.price}" />원</strong>
							</div>
							<div class="meta-row" style="color: #999;">
								<fmt:formatDate value="${o.createdTime}" pattern="yyyy-MM-dd HH:mm" /> 요청
							</div>
						</div>
						<div class="action-group">
							<form action="${ctx}/order/transfer/${o.orderNo}/approve" method="post" style="margin: 0;">
								<button type="submit" class="confirm-btn"
									onclick="return confirm('거래 요청을 승인하시겠어요?\n구매자에게 입금 폼 접근 권한이 부여됩니다.');">
									승인</button>
							</form>
							<form action="${ctx}/order/transfer/cancel" method="post" style="margin: 0;">
								<input type="hidden" name="orderNo" value="${o.orderNo}">
								<button type="submit" class="cancel-btn"
									onclick="return confirm('이 거래 요청을 거절하시겠어요?');">
									거절</button>
							</form>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<h3 style="font-size: 16px; margin: 24px 0 10px;">계좌이체 승인 완료 (구매자 결제 대기)</h3>
		<c:choose>
			<c:when test="${empty approvedTransfers}">
				<div class="empty-state" style="padding: 30px 20px;">결제를 기다리는 승인 거래가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="o" items="${approvedTransfers}">
					<div class="pending-card">
						<div class="pending-info">
							<div>
								<span class="pending-badge" style="background: #dbeafe; color: #1e40af;">승인 완료</span>
								<span style="font-size: 12px; color: #999;">#${o.orderNo}</span>
							</div>
							<div class="product-name">${o.productName}</div>
							<div class="meta-row">
								금액 <strong><fmt:formatNumber value="${o.price}" />원</strong>
							</div>
							<div class="meta-row" style="color: #999;">구매자의 입금을 기다리는 중입니다.</div>
							<div class="meta-row" style="color: #999;">
								<fmt:formatDate value="${o.createdTime}" pattern="yyyy-MM-dd HH:mm" /> 승인
							</div>
						</div>
						<div class="action-group">
							<form action="${ctx}/order/transfer/cancel" method="post" style="margin: 0;">
								<input type="hidden" name="orderNo" value="${o.orderNo}">
								<button type="submit" class="cancel-btn"
									onclick="return confirm('이 승인 거래를 취소하시겠어요?\n상품이 다시 판매중으로 바뀌고 구매자에게 알림이 발송됩니다.');">
									거래 취소</button>
							</form>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<h3 style="font-size: 16px; margin: 24px 0 10px;">계좌이체 입금 대기</h3>
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
						<div class="action-group">
							<form action="${ctx}/order/${o.orderNo}/confirm-payment"
								method="post" style="margin: 0;">
								<button type="submit" class="confirm-btn"
									onclick="return confirm('정말 입금이 확인됐나요?\n확인하면 거래가 완료 처리됩니다.');">
									입금 확인</button>
							</form>
							<form action="${ctx}/order/transfer/cancel"
								method="post" style="margin: 0;">
								<input type="hidden" name="orderNo" value="${o.orderNo}">
								<button type="submit" class="cancel-btn"
									onclick="return confirm('이 거래를 취소하시겠어요?\n상품이 다시 판매중으로 바뀌고 관련 알림이 정리됩니다.');">
									거래 취소</button>
							</form>
						</div>
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
						<div class="action-group">
							<form action="${ctx}/order/direct/${o.orderNo}/complete" method="post" style="margin: 0;">
								<button type="submit" class="confirm-btn"
									onclick="return confirm('거래를 완료 처리하시겠어요?\n구매자에게 완료 알림이 발송됩니다.');">
									거래 완료</button>
							</form>
							<form action="${ctx}/order/direct/${o.orderNo}/cancel" method="post" style="margin: 0;">
								<button type="submit" class="cancel-btn"
									onclick="return confirm('예약을 취소하시겠어요?\n상품이 다시 판매중으로 바뀌고, 대기 신청한 사용자 전원에게 알림이 발송됩니다.');">
									예약 취소</button>
							</form>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>