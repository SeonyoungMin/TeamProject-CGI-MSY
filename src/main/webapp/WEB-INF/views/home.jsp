<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>홈</title>
<style>
.product-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
}

.card {
	display: block;
	text-decoration: none;
	color: inherit;
	border: 1px solid #eee;
	padding: 10px;
	border-radius: 8px;
}

.info-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 8px;
	font-size: 13px;
}

.heart-box {
	color: #ff4d4d;
	font-weight: bold;
}

.date-box {
	color: #999;
	font-size: 11px;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="card"
		style="text-align: center; border: none; border-bottom: 1px solid #eee; border-radius: 0;">
		<a href="${ctx}/productList">전체</a> | <a
			href="${ctx}/product/category?category=의류">의류</a> | <a
			href="${ctx}/product/category?category=잡화">잡화</a> | <a
			href="${ctx}/product/category?category=가구">가구</a> | <a
			href="${ctx}/product/category?category=전자기기">전자기기</a> | <a
			href="${ctx}/product/category?category=도서">도서</a> | <a
			href="${ctx}/product/category?category=기타">기타</a>
	</div>

	<div
		style="text-align: center; padding: 40px 20px; background: #EDEBE7;">
		<h1 style="font-size: 28px; margin: 0 0 15px 0;">쉽고 안전한 중고거래</h1>
		<a href="${ctx}/productList" class="btn btn-primary">상품 둘러보기</a> <a
			href="${ctx}/product/new" class="btn">글쓰기</a>
	</div>

	<div class="app-container">
		<div
			style="display: flex; justify-content: space-between; align-items: center; margin: 30px 0 20px;">
			<h2 style="font-size: 20px; margin: 0;">최근 등록 상품</h2>
			<a href="${ctx}/productList" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>

		<c:if test="${empty productList}">
			<div class="card" style="text-align: center; color: #888;">등록된
				상품이 없습니다.</div>
		</c:if>

		<c:if test="${not empty productList}">
			<div class="product-grid">
				<c:forEach var="p" items="${productList}">
					<a href="${ctx}/product/${p.productNo}" class="card"
						style="display: block; position: relative;">
						<div
							style="height: 180px; background: #f0f0f0; border-radius: 4px; overflow: hidden; position: relative;">
							<c:if test="${not empty p.imgPath}">
								<img src="${ctx}${p.imgPath}"
									style="width: 100%; height: 100%; object-fit: cover;">
							</c:if>

							<div
								style="position: absolute; bottom: 10px; right: 10px; display: flex; align-items: center; gap: 4px;">
								<span style="color: #ff4d4d; font-size: 16px;"> <c:choose>
										<c:when test="${p.favoriteCount > 0}">♥</c:when>
										<c:otherwise>♡</c:otherwise>
									</c:choose>
								</span> <span style="color: #111; font-size: 13px; font-weight: bold;">${p.favoriteCount}</span>
							</div>
						</div>
						<div
							style="font-size: 15px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
							${p.productName}</div>

						<div class="info-row">
							<span class="date-box"> <fmt:formatDate
									value="${p.createdTime}" pattern="MM.dd" />
							</span>
						</div>

						<div style="font-size: 12px; color: #888; margin-top: 4px;">${p.sellerNickname}</div>
						<div style="font-weight: bold; margin-top: 6px;">
							<fmt:formatNumber value="${p.price}" />
							원
						</div>
					</a>
				</c:forEach>
			</div>
		</c:if>

		<div
			style="display: flex; justify-content: space-between; align-items: center; margin: 50px 0 20px;">
			<h2 style="font-size: 20px; margin: 0;">나문희게시판</h2>
			<a href="${ctx}/boardList" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>

		<div style="margin-bottom: 40px;">
			<a href="${ctx}/boardList" class="btn">문의 게시글 보기</a> <a
				href="${ctx}/boardList/addForm" class="btn btn-primary">문의 게시글
				쓰기</a>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>