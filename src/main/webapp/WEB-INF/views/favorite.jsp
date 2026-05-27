<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
<style>
.favorite-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 14px;
}

.favorite-card {
	border: 1px solid #f0f0f0;
	border-radius: 10px;
	overflow: hidden;
	background: #fff;
	padding: 0;
	margin-bottom: 0;
	transition: 0.2s;
}

.favorite-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.favorite-card a {
	display: block;
	color: inherit;
	text-decoration: none;
}

.favorite-thumb {
	width: 100%;
	height: 140px;
	background: #f5f5f5;
	overflow: hidden;
}

.favorite-thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.favorite-info {
	padding: 10px 12px;
}

.favorite-name {
	font-size: 13px;
	font-weight: 600;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	color: #333;
}

.favorite-price {
	font-weight: bold;
	font-size: 14px;
	margin-top: 6px;
	color: #111;
}

.favorite-actions {
	padding: 0 12px 12px 12px;
}

.favorite-pagination {
	text-align: center;
	margin-top: 24px;
	display: flex;
	justify-content: center;
	gap: 8px;
}

.favorite-pagination a {
	padding: 5px 12px;
	border: 1px solid #ddd;
	text-decoration: none;
	color: #333;
	border-radius: 4px;
	background: #fff;
}

.favorite-pagination .current {
	background: #121212;
	color: #fff;
	border-color: #121212;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<h2 class="section-title">내 찜 목록
			<span style="font-size: 13px; color: #999; font-weight: normal;">(${totalFavorites})</span>
		</h2>

		<c:if test="${empty products}">
			<div class="card" style="text-align: center; color: #888; padding: 40px;">
				찜한 상품이 없습니다.<br><br>
				<a href="${ctx}/productList" class="btn btn-primary">상품 보러가기</a>
			</div>
		</c:if>

		<c:if test="${not empty products}">
			<div class="favorite-grid">
				<c:forEach var="p" items="${products}">
					<div class="favorite-card">
						<a href="${ctx}/product/${p.productNo}">
							<div class="favorite-thumb">
								<c:if test="${not empty p.imgPath}">
									<img src="${p.imgPath}">
								</c:if>
								<c:if test="${empty p.imgPath}">
									<div style="height: 100%; display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 12px;">이미지 없음</div>
								</c:if>
							</div>
							<div class="favorite-info">
								<div class="favorite-name">${p.productName}</div>
								<div class="favorite-price">
									<fmt:formatNumber value="${p.price}" pattern="#,###" />원
								</div>
							</div>
						</a>
						<div class="favorite-actions">
							<form action="${ctx}/favorite/remove" method="post" style="margin: 0;">
								<input type="hidden" name="productNo" value="${p.productNo}">
								<button type="submit" class="btn btn-danger btn-block"
									style="padding: 6px 0; font-size: 12px;"
									onclick="return confirm('찜 목록에서 삭제하시겠습니까?')">찜 취소</button>
							</form>
						</div>
					</div>
				</c:forEach>
			</div>

			<c:if test="${totalPages > 1}">
				<div class="favorite-pagination">
					<c:forEach var="i" begin="1" end="${totalPages}">
						<a href="${ctx}/favorite?page=${i}"
							class="${i == currentPage ? 'current' : ''}">${i}</a>
					</c:forEach>
				</div>
			</c:if>
		</c:if>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>