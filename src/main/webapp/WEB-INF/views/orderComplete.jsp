<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 완료</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orderComplete.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="complete-container">
		<h2 class="msg-main">거래가 완료된 상품입니다</h2>
		<div class="info-box">
			<div class="info-item">
				<span>상품명</span> <span>${product.productName}</span>
			</div>
			<div class="info-item">
				<span>거래 상태</span> <span class="is-orderComplete-1">판매완료</span>
			</div>
		</div>

		<c:choose>
			<c:when
				test="${loginUser.userNo == product.buyerNo and alreadyReviewed}">
				<p class="msg-sub">
					이 상품에는 이미 후기를 작성하셨습니다.<br>소중한 후기 감사합니다!
				</p>
				<div class="btn-group is-orderComplete-2">
					<a href="${ctx}/users/search/${product.sellerNo}#reviewList"
						class="btn-submit is-orderComplete-3">
						내 후기 보러가기 </a> <a href="${ctx}/home" class="btn-home is-orderComplete-4">홈으로
						가기</a>
				</div>
			</c:when>
			<c:when test="${loginUser.userNo == product.buyerNo}">
				<p class="msg-sub">
					방금 구매하신 상품입니다!<br>판매자에게 후기를 남기시겠습니까?
				</p>
				<div class="btn-group is-orderComplete-5">
					<a
						href="${ctx}/users/search/${product.sellerNo}?productNo=${product.productNo}"
						class="btn-submit is-orderComplete-6">
						판매자에게 후기 작성하러 가기 </a> <a href="${ctx}/home" class="btn-home is-orderComplete-7">나중에
						하기</a>
				</div>
			</c:when>
			<c:otherwise>
				<p class="msg-sub">이미 판매가 완료된 상품입니다.</p>
				<a href="${ctx}/home" class="btn-home">홈으로 가기</a>
			</c:otherwise>
		</c:choose>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>