<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/favorite.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<h2 class="section-title">내 찜 목록
			<span class="is-favorite-1">(${totalFavorites})</span>
		</h2>

		<c:if test="${empty products}">
			<div class="card is-favorite-2">
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
									<div class="is-favorite-3">이미지 없음</div>
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
							<form action="${ctx}/favorite/remove" method="post" class="is-favorite-4">
								<input type="hidden" name="productNo" value="${p.productNo}">
								<button type="submit" class="btn btn-danger btn-block is-favorite-5"
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