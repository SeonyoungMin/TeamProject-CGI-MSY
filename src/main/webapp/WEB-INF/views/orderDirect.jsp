<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직거래 약속</title>
<style>
.order-container {
	max-width: 720px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

h2 {
	font-size: 22px;
	margin: 0 0 20px;
}

.section {
	margin-bottom: 24px;
}

.section-title {
	font-size: 15px;
	font-weight: bold;
	margin: 0 0 10px;
}

.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 16px 20px;
}

.product-summary {
	display: flex;
	gap: 14px;
	align-items: center;
}

.product-name {
	font-weight: bold;
}

.product-price {
	color: #ff8a3d;
	font-weight: bold;
	margin-top: 4px;
}

.field-row {
	display: flex;
	align-items: center;
	padding: 10px 0;
	border-bottom: 1px solid #f3f3f3;
}

.field-row:last-child {
	border-bottom: none;
}

.field-label {
	width: 110px;
	color: #555;
	font-size: 14px;
}

.field-input, .field-textarea {
	flex: 1;
	padding: 8px 10px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	font-family: inherit;
}

.field-textarea {
	resize: vertical;
	min-height: 80px;
}

.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

.btn {
	flex: 1;
	padding: 14px;
	border: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
}

.btn-primary {
	background: #121212;
	color: #fff;
}

.btn-cancel {
	background: #f0f0f0;
	color: #333;
}

.guide {
	color: #888;
	font-size: 13px;
	margin-top: 6px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="order-container">
		<h2>직거래 약속 정하기</h2>

		<div class="section">
			<div class="section-title">상품 정보</div>
			<div class="card product-summary">
				<div>
					<div class="product-name">${product.productName}</div>
					<div class="product-price">${product.price}원</div>
				</div>
			</div>
		</div>

		<form action="${ctx}/order/direct/submit" method="post">
			<input type="hidden" name="productNo" value="${product.productNo}">

			<div class="section">
				<div class="section-title">거래 약속</div>
				<div class="card">
					<div class="field-row">
						<span class="field-label">만남 장소</span>
						<input class="field-input" type="text" name="meetingPlace"
							placeholder="예) ○○역 1번 출구" required>
					</div>
					<div class="field-row">
						<span class="field-label">만남 시간</span>
						<input class="field-input" type="datetime-local" name="meetingTime" required>
					</div>
					<div class="field-row">
						<span class="field-label">메시지</span>
						<textarea class="field-textarea" name="buyerMessage"
							placeholder="판매자에게 전할 메시지를 입력해 주세요"></textarea>
					</div>
				</div>
				<div class="guide">입력한 약속이 판매자에게 전달되고, 만남 후 판매자가 거래완료를 눌러야 확정됩니다.</div>
			</div>

			<div class="btn-group">
				<button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
				<button type="submit" class="btn btn-primary">약속 잡고 예약하기</button>
			</div>
		</form>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
