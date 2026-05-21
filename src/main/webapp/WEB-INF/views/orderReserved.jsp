<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직거래 예약 완료</title>
<style>
.container {
	max-width: 640px;
	margin: 40px auto;
	padding: 24px;
	font-family: 'Pretendard', sans-serif;
}

h2 {
	font-size: 22px;
	margin: 0 0 8px;
}

.lead {
	color: #666;
	margin-bottom: 24px;
}

.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 18px 22px;
	margin-bottom: 18px;
}

.section-title {
	font-size: 14px;
	color: #888;
	margin: 0 0 10px;
}

.info-row {
	display: flex;
	padding: 8px 0;
	border-bottom: 1px solid #f3f3f3;
}

.info-row:last-child {
	border-bottom: none;
}

.info-label {
	width: 110px;
	color: #888;
	font-size: 14px;
}

.info-value {
	flex: 1;
	font-size: 15px;
	color: #222;
}

.notice {
	background: #fff7e6;
	border: 1px solid #ffd58a;
	color: #8a5b00;
	padding: 14px 18px;
	border-radius: 10px;
	font-size: 14px;
	line-height: 1.6;
	margin-bottom: 18px;
}

.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 10px;
}

.btn {
	flex: 1;
	padding: 14px;
	border: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
	text-decoration: none;
	text-align: center;
}

.btn-primary {
	background: #121212;
	color: #fff;
}

.btn-line {
	background: #f0f0f0;
	color: #333;
}

.price {
	color: #ff8a3d;
	font-weight: bold;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<h2>직거래 약속이 잡혔습니다</h2>
		<p class="lead">판매자(<strong>${seller.userNickName}</strong>)에게 약속이 전달되었습니다.</p>

		<div class="notice">
			만남 후 판매자가 <strong>거래 완료</strong> 버튼을 누르면 거래가 확정됩니다.<br>
			확정되면 알림으로 안내드리며, 그때 후기를 작성하실 수 있어요.
		</div>

		<div class="card">
			<div class="section-title">상품</div>
			<div class="info-row">
				<span class="info-label">상품명</span>
				<span class="info-value">${product.productName}</span>
			</div>
			<div class="info-row">
				<span class="info-label">금액</span>
				<span class="info-value price">
					<fmt:formatNumber value="${product.price}" />원
				</span>
			</div>
		</div>

		<div class="card">
			<div class="section-title">약속 정보</div>
			<div class="info-row">
				<span class="info-label">만남 장소</span>
				<span class="info-value">${order.meetingPlace}</span>
			</div>
			<div class="info-row">
				<span class="info-label">만남 시간</span>
				<span class="info-value">
					<c:if test="${not empty order.meetingTime}">
						<fmt:formatDate value="${order.meetingTime}" pattern="yyyy-MM-dd HH:mm" />
					</c:if>
				</span>
			</div>
			<c:if test="${not empty order.buyerMessage}">
				<div class="info-row">
					<span class="info-label">메시지</span>
					<span class="info-value">${order.buyerMessage}</span>
				</div>
			</c:if>
		</div>

		<div class="btn-group">
			<a href="${ctx}/mypage" class="btn btn-line">마이페이지로</a>
			<a href="${ctx}/home" class="btn btn-primary">홈으로</a>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
