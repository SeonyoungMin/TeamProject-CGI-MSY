<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입금 대기 중</title>
<style>
.waiting-container {
	max-width: 600px;
	margin: 40px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.status-icon {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	background: #fef3c7;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 16px;
	font-size: 32px;
	color: #92400e;
}

.status-title {
	text-align: center;
	font-size: 22px;
	font-weight: bold;
	margin: 0 0 8px;
}

.status-desc {
	text-align: center;
	color: #666;
	line-height: 1.6;
	margin: 0 0 30px;
}

.info-card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 20px;
	margin-bottom: 16px;
}

.info-row {
	display: flex;
	justify-content: space-between;
	padding: 8px 0;
	font-size: 14px;
	border-bottom: 1px solid #f5f5f5;
}

.info-row:last-child {
	border-bottom: none;
}

.info-label {
	color: #888;
}

.info-value {
	font-weight: 500;
}

.account-box {
	background: #f8f9fa;
	border-radius: 12px;
	padding: 16px 20px;
	margin-bottom: 16px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.copy-btn {
	padding: 6px 12px;
	background: #fff;
	border: 1px solid #ddd;
	border-radius: 6px;
	cursor: pointer;
	font-size: 13px;
}

.notice-box {
	background: #e6f1fb;
	border-radius: 12px;
	padding: 14px 18px;
	margin-bottom: 24px;
	color: #0c447c;
	font-size: 13px;
	line-height: 1.6;
}

.btn-group {
	display: flex;
	gap: 10px;
}

.btn {
	flex: 1;
	padding: 14px;
	border: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
	text-align: center;
	text-decoration: none;
}

.btn-line {
	background: #f0f0f0;
	color: #555;
}

.btn-dark {
	background: #121212;
	color: #fff;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="waiting-container">

		<div class="status-icon">⏱</div>
		<h2 class="status-title">입금을 기다리고 있어요</h2>
		<p class="status-desc">
			아래 계좌로 입금해주세요.<br> 판매자가 입금을 확인하면 자동으로 거래가 완료됩니다.
		</p>

		<div class="info-card">
			<div class="info-row">
				<span class="info-label">주문번호</span> <span class="info-value">#${order.orderNo}</span>
			</div>
			<div class="info-row">
				<span class="info-label">상품명</span> <span class="info-value">${product.productName}</span>
			</div>
			<div class="info-row">
				<span class="info-label">결제 금액</span> <span class="info-value">
					<fmt:formatNumber value="${order.price}" />원
				</span>
			</div>
			<div class="info-row">
				<span class="info-label">입금자명</span> <span class="info-value">${order.depositorName}</span>
			</div>
		</div>

		<div class="account-box">
			<div>
				<div style="font-size: 12px; color: #666; margin-bottom: 4px;">입금
					계좌</div>
				<div style="font-weight: bold; font-size: 15px;" id="accountInfo">
					${seller.userBankName} ${seller.userAccountNumber}</div>
				<div style="font-size: 13px; color: #666; margin-top: 2px;">
					예금주: ${seller.userAccountHolder}</div>
			</div>
			<button type="button" class="copy-btn" onclick="copyAccount()">복사</button>
		</div>

		<div class="info-card">
			<div style="font-size: 13px; color: #666; margin-bottom: 8px;">배송지</div>
			<div style="font-weight: 500; margin-bottom: 4px;">
				${order.receiverName} · ${order.receiverPhone}</div>
			<div style="font-size: 13px; color: #666;">(${order.zipCode})
				${order.address} ${order.addressDetail}</div>
			<c:if test="${not empty order.deliveryRequest}">
				<div style="font-size: 13px; color: #666; margin-top: 6px;">
					요청사항: <span style="color: #222;">${order.deliveryRequest}</span>
				</div>
			</c:if>
		</div>

		<c:if test="${param.notified == '1'}">
			<div class="notice-box"
				style="background: #dcfce7; color: #166534;">
				✓ 송금 완료 알림이 판매자에게 전달되었습니다.
			</div>
		</c:if>

		<div class="notice-box">
			<strong>안내</strong><br> · 입금자명이 다르면 거래 확인이 지연될 수 있어요.<br>
			· 송금을 마쳤다면 아래 <strong>송금 완료 알리기</strong> 버튼을 눌러주세요. 판매자가 확인 후 거래를 완료합니다.
		</div>

		<form action="${ctx}/order/${order.orderNo}/notify-deposit" method="post"
			style="margin: 0 0 10px;">
			<button type="submit" class="btn btn-dark" style="width: 100%;">송금 완료 알리기</button>
		</form>

		<div class="btn-group">
			<a href="${ctx}/home" class="btn btn-line">홈으로</a> <a
				href="${ctx}/accountList" class="btn btn-line">내 거래 내역</a>
		</div>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
		function copyAccount() {
			var text = document.getElementById('accountInfo').textContent
					.trim();
			var number = text.replace(/[^0-9-]/g, '');

			var temp = document.createElement('textarea');
			temp.value = number;
			document.body.appendChild(temp);
			temp.select();
			document.execCommand('copy');
			document.body.removeChild(temp);

			alert('계좌번호가 복사되었습니다.');
		}
	</script>
</body>
</html>