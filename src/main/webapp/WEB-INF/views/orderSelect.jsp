<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 방식 선택</title>
<style>
.container {
	width: 500px;
	margin: 50px auto;
	text-align: center;
	padding: 30px;
	border-radius: 10px;
}

.product-info {
	background: #f9f9f9;
	padding: 15px;
	margin-bottom: 20px;
	border-radius: 5px;
}

.btn-group {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.btn {
	padding: 15px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
	font-weight: bold;
}

.btn-direct {
	background-color: #4CAF50;
	color: white;
}

.btn-transfer {
	background-color: #2196F3;
	color: white;
}

.btn-cancel {
	background-color: #9e9e9e;
	color: white;
	margin-top: 10px;
}
</style>
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

<<<<<<< HEAD
		<form action="${pageContext.request.contextPath}/order/complete"
			method="post">
			<input type="hidden" name="productNo" value="${product.productNo}">
			<button type="submit">직거래</button>
			<br> <br>
			<button type="submit">계좌이체(배송)</button>
=======
		<form action="${pageContext.request.contextPath}/order/route"
			method="post">
			<input type="hidden" name="productNo" value="${product.productNo}">

			<button type="submit" name="type" value="DIRECT"
				class="btn btn-direct">직거래</button>

			<button type="submit" name="type" value="TRANSFER"
				class="btn btn-transfer">계좌이체(배송)</button>
>>>>>>> main
		</form>
		<br>

		<button type="button" class="btn btn-cancel" onclick="history.back()">취소하고
			돌아가기</button>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>