<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 완료</title>
<style>
.complete-container {
	width: 500px;
	margin: 100px auto;
	text-align: center;
	padding: 40px;
}

.icon {
	font-size: 50px;
	color: #4CAF50;
	margin-bottom: 20px;
}

.msg-main {
	font-size: 24px;
	font-weight: bold;
	color: #333;
	margin-bottom: 10px;
}

.msg-sub {
	color: #666;
	margin-bottom: 30px;
	line-height: 1.6;
}

.info-box {
	background: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	text-align: left;
	margin-bottom: 30px;
}

.info-item {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
	border-bottom: 1px dashed #ddd;
	padding-bottom: 5px;
}

.btn-home {
	display: inline-block;
	padding: 12px 30px;
	background: #4CAF50;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	font-weight: bold;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="complete-container">

		<div class="msg-main">판매 완료</div>
		<p>판매 완료된 게시글 입니다
		<div class="info-box">
			<div class="info-item">
				<span>거래 상품</span> <strong>${product.productName}</strong>
			</div>
			<div class="info-item">
				<span>거래 금액</span> <strong>${product.price}원</strong>
			</div>
			<div class="info-item">
				<span>상태</span> <span style="color: #e91e63; font-weight: bold;">판매완료</span>
			</div>
		</div>

		<a href="${ctx}/home"><button>돌아가기</button></a>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>