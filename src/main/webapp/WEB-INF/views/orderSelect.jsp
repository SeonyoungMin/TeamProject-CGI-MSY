<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 방식 선택</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orderSelect.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<h2>거래 방식을 선택해 주세요</h2>

		<div class="product-info">
			<p>
				<strong>상품명:</strong> ${product.productName}
			</p>

			<p>
				<strong>결제 금액:</strong> ${product.price}원
			</p>
		</div>
		<form action="${pageContext.request.contextPath}/order/route"
			method="post">
			<input type="hidden" name="productNo" value="${product.productNo}">

			<button type="submit" name="type" value="DIRECT"
				class="btn btn-direct">직거래</button>

			<button type="submit" name="type" value="TRANSFER"
				class="btn btn-transfer">계좌이체(배송)</button>
		</form>
		<br>

		<button type="button" class="btn btn-cancel" onclick="history.back()">취소하고
			돌아가기</button>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>