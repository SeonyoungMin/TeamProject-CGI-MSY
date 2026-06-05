<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직거래 약속</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orderDirect.css">
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