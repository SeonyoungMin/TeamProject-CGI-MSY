<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 내역</title>
<style>
.bought-grid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 14px;
}

.bought-card {
	border: 1px solid #eee;
	border-radius: 10px;
	overflow: hidden;
	cursor: pointer;
	background: #fff;
	transition: 0.2s;
}

.bought-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.bought-thumb {
	height: 140px;
	background: #f4f4f4;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
}

.bought-thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.bought-info {
	padding: 10px 12px;
}

.bought-name {
	font-weight: bold;
	font-size: 13px;
	margin-bottom: 5px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.bought-price {
	color: #ff8a3d;
	font-weight: bold;
	font-size: 14px;
}

.bought-status {
	font-size: 12px;
	color: #999;
	margin-top: 5px;
}

.bought-pagination {
	text-align: center;
	margin-top: 28px;
	display: flex;
	justify-content: center;
	gap: 8px;
}

.bought-pagination a {
	padding: 5px 12px;
	border: 1px solid #ddd;
	text-decoration: none;
	color: #333;
	border-radius: 4px;
	background: #fff;
}

.bought-pagination .current {
	background: #121212;
	color: #fff;
	border-color: #121212;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #121212; padding-bottom: 10px;">
			<h2 class="section-title" style="margin: 0; border-bottom: none;">구매 내역
				<span style="font-size: 14px; color: #999; font-weight: normal;">(${totalBought})</span>
			</h2>
			<a href="${ctx}/mypage" style="font-size: 14px; color: #666;">&lt; 마이페이지로</a>
		</div>

		<c:choose>
			<c:when test="${empty boughtList}">
				<div class="card" style="text-align: center; color: #999; padding: 40px;">
					구매한 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div class="bought-grid">
					<c:forEach var="item" items="${boughtList}">
						<div class="bought-card"
							onclick="location.href='${ctx}/product/${item.productNo}'">
							<div class="bought-thumb">
								<c:choose>
									<c:when test="${not empty item.imgPath}">
										<img src="${item.imgPath}"
											onerror="this.onerror=null;this.src='https://via.placeholder.com/150?text=No+Image';">
									</c:when>
									<c:otherwise>
										<span style="color: #ccc;">이미지 없음</span>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="bought-info">
								<div class="bought-name">${item.productName}</div>
								<div class="bought-price">
									<fmt:formatNumber value="${item.price}" pattern="#,###" />원
								</div>
								<div class="bought-status">거래 완료</div>
							</div>
						</div>
					</c:forEach>
				</div>

				<c:if test="${totalPages > 1}">
					<div class="bought-pagination">
						<c:forEach var="i" begin="1" end="${totalPages}">
							<a href="${ctx}/mypage/bought?page=${i}"
								class="${i == currentPage ? 'current' : ''}">${i}</a>
						</c:forEach>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
