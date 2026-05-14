<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f8f9fa;
}

.container {
	max-width: 1400px;
	margin: 40px auto;
	padding: 30px;
	background: white;
	border-radius: 12px;
}

.top-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
}

.write-btn {
	padding: 10px 20px;
	background: black;
	color: white;
	text-decoration: none;
	border-radius: 8px;
}

.product-grid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 20px;
}

.product-card {
	border: 1px solid #eee;
	border-radius: 10px;
	overflow: hidden;
	background: white;
	text-decoration: none;
	color: black;
	transition: .2s;
}

.product-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, .08);
}

.product-card img {
	width: 100%;
	height: 160px;
	object-fit: cover;
}

.no-img {
	height: 160px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #f3f3f3;
	color: #aaa;
}

.info {
	padding: 14px;
}

.name {
	font-weight: bold;
	margin-bottom: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.meta {
	color: #777;
	font-size: 13px;
	margin-bottom: 6px;
}

.price {
	font-weight: bold;
}

.pagination {
	text-align: center;
	margin-top: 30px;
}

.pagination a, .pagination strong {
	display: inline-block;
	padding: 8px 14px;
	margin: 0 4px;
	border: 1px solid #ddd;
	border-radius: 8px;
	text-decoration: none;
	color: #444;
}

.pagination strong {
	background: black;
	color: white;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<div class="top-bar">
			<h2>상품 목록</h2>
			<a href="${ctx}/product/new" class="write-btn">글쓰기</a>
		</div>

		<c:if test="${empty list}">
			<p style="text-align: center; color: #888;">등록된 상품이 없습니다.</p>
		</c:if>

		<div class="product-grid">
			<c:forEach var="p" items="${list}">
				<a href="${ctx}/product/${p.productNo}" class="product-card"> <c:choose>
						<c:when test="${not empty p.imgPath}">
							<img src="${p.imgPath}">
						</c:when>
						<c:otherwise>
							<div class="no-img">이미지 없음</div>
						</c:otherwise>
					</c:choose>

					<div class="info">
						<div class="name">${p.productName}</div>

						<div class="meta">${p.category} · ${p.sellerNickname}</div>

						<div class="meta">조회수 ${p.viewCount}</div>

						<div class="price">
							<fmt:formatNumber value="${p.price}" />
							원
						</div>
					</div>
				</a>
			</c:forEach>
		</div>

		<c:if test="${totalPages > 0}">
			<div class="pagination">
				<c:forEach var="i" begin="1" end="${totalPages}">
					<c:choose>
						<c:when test="${i == currentPage}">
							<strong>${i}</strong>
						</c:when>
						<c:otherwise>
							<a href="${ctx}/productList?pageNum=${i}"> ${i} </a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</c:if>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>