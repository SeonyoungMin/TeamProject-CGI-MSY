<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 요청</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/tradeRequest.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<div class="product-name">${product.productName}</div>

		<p class="desc">
			판매자 <b>${product.sellerNickname}</b> 님에게<br> 계좌이체 거래 요청을 보냅니다. <br>
			<br> 판매자가 승인하면 계좌정보가 공개됩니다.
		</p>

		<form action="${ctx}/order/transfer/request" method="post">

			<input type="hidden" name="productNo" value="${product.productNo}">

			<button class="btn btn-submit" type="submit">거래 요청 보내기</button>

			<button class="btn btn-cancel" type="button" onclick="history.back()">

				취소</button>

		</form>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>