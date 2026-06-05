<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입금 대기 중</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orderWaiting.css">
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
				<div class="is-orderWaiting-1">입금
					계좌</div>
				<div id="accountInfo" class="is-orderWaiting-2">
					${seller.userBankName} ${seller.userAccountNumber}</div>
				<div class="is-orderWaiting-3">
					예금주: ${seller.userAccountHolder}</div>
			</div>
			<button type="button" class="copy-btn" onclick="copyAccount()">복사</button>
		</div>

		<div class="info-card">
			<div class="is-orderWaiting-4">배송지</div>
			<div class="is-orderWaiting-5">
				${order.receiverName} · ${order.receiverPhone}</div>
			<div class="is-orderWaiting-6">(${order.zipCode})
				${order.address} ${order.addressDetail}</div>
			<c:if test="${not empty order.deliveryRequest}">
				<div class="is-orderWaiting-7">
					요청사항: <span class="is-orderWaiting-8">${order.deliveryRequest}</span>
				</div>
			</c:if>
		</div>

		<c:if test="${param.notified == '1'}">
			<div class="notice-box is-orderWaiting-9">
				✓ 송금 완료 알림이 판매자에게 전달되었습니다.
			</div>
		</c:if>

		<div class="notice-box">
			<strong>안내</strong><br> · 입금자명이 다르면 거래 확인이 지연될 수 있어요.<br>
			· 송금을 마쳤다면 아래 <strong>송금 완료 알리기</strong> 버튼을 눌러주세요. 판매자가 확인 후 거래를 완료합니다.
		</div>

		<form action="${ctx}/order/${order.orderNo}/notify-deposit" method="post" class="is-orderWaiting-10">
			<button type="submit" class="btn btn-dark is-orderWaiting-11">송금 완료 알리기</button>
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