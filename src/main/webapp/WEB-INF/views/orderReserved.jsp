<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직거래 예약 완료</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orderReserved.css">
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