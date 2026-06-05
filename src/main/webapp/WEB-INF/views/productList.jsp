<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/productList.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<div class="top-bar">
			<h2 class="is-productList-1">상품 목록</h2>
			<a href="${ctx}/product/new" class="write-btn">글쓰기</a>
		</div>

		<c:if test="${empty list}">
			<p class="is-productList-2">등록된 상품이 없습니다.</p>
		</c:if>

		<div class="product-grid">
			<c:forEach var="p" items="${list}">
				<a href="${ctx}/product/${p.productNo}" class="product-card">
					<div class="img-wrap">

						<c:choose>
							<c:when test="${not empty p.imgPath}">
								<img src="${p.imgPath}">
							</c:when>
							<c:otherwise>
								<div class="no-img">이미지 없음</div>
							</c:otherwise>
						</c:choose>
						<c:if test="${p.tradeStatus == '예약중'}">
							<div class="reserved-overlay">
								<span class="reserved-badge">예약중</span>
							</div>
						</c:if>
						<c:if test="${p.tradeStatus == '완료'}">
							<div class="sold-overlay">
								<span class="sold-badge">판매완료</span>
							</div>
						</c:if>


						<span class="view-badge"> <i class="fa-solid fa-eye"></i>
							${p.viewCount}
						</span> <span class="fav-btn" data-product-no="${p.productNo}"
							onclick="toggleFavorite(event, this)"> <i
							class="fav-icon ${p.isFavorite > 0 ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
							<span class="fav-count">${p.favoriteCount}</span>
						</span>
					</div>

					<div class="info">
						<div class="name">${p.productName}</div>
						<div class="meta">${p.category}·${p.sellerNickname}</div>
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
							<a href="${ctx}/productList?pageNum=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</c:if>

	</div>

	<script>
		// 찜 토글 (jQuery AJAX)
		function toggleFavorite(event, el) {
			event.preventDefault();
			event.stopPropagation();

			var productNo = el.getAttribute('data-product-no');
			var iconEl = el.querySelector('.fav-icon');
			var countEl = el.querySelector('.fav-count');

			$
					.ajax({
						url : '${ctx}/favorite/toggle',
						type : 'POST',
						data : {
							productNo : productNo
						},
						success : function(result) {
							if (result === 'login') {
								alert('로그인이 필요합니다.');
								location.href = '${ctx}/login';
								return;
							}
							var count = parseInt(countEl.textContent, 10) || 0;
							if (result === 'added')
								count += 1;
							else if (result === 'removed')
								count = Math.max(0, count - 1);

							countEl.textContent = count;
							iconEl.classList.remove('fa-solid', 'fa-regular');
							iconEl.classList.add(count > 0 ? 'fa-solid'
									: 'fa-regular');
						},
						error : function() {
							alert('처리 중 오류가 발생했습니다.');
						}
					});
		}
	</script>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>