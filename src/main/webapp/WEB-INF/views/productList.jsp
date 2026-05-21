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
	font-family: 'Malgun Gothic', sans-serif;
	background: #f8f9fa;
}

.container {
	max-width: 1300px;
	margin: 40px auto;
	padding: 0 20px;
}

.top-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
}

.write-btn {
	padding: 10px 20px;
	background: #121212;
	color: #fff !important;
	text-decoration: none;
	border-radius: 8px;
	font-size: 14px;
}

/* 상품 그리드 */
.product-grid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 15px;
}

.product-card {
	display: block;
	text-decoration: none;
	color: inherit;
	border: 1px solid #eee;
	border-radius: 8px;
	overflow: hidden;
	position: relative;
	background: #fff;
	transition: .2s;
}

.product-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, .08);
}

/* 썸네일 */
.img-wrap {
	height: 180px;
	background: #f0f0f0;
	position: relative;
	overflow: hidden;
}

.img-wrap img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.no-img {
	width: 100%;
	height: 100%;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #aaa;
	background: #f0f0f0;
	font-size: 13px;
}

/* 조회수 뱃지 */
.view-badge {
	position: absolute;
	bottom: 8px;
	left: 8px;
	background: rgba(0, 0, 0, 0.55);
	color: #fff;
	font-size: 11px;
	padding: 2px 6px;
	border-radius: 10px;
}

/* 찜 버튼 */
.fav-btn {
	position: absolute;
	bottom: 8px;
	right: 8px;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: 3px 8px;
	background: rgba(255, 255, 255, 0.88);
	border-radius: 14px;
	cursor: pointer;
	user-select: none;
}

.fav-btn:hover {
	background: #fff;
}

.fav-icon {
	color: #ff4d4d;
	font-size: 13px;
}

.fav-count {
	font-size: 12px;
	font-weight: bold;
	color: #111;
}

/* 텍스트 */
.info {
	padding: 10px 12px 12px;
}

.name {
	font-size: 14px;
	font-weight: 600;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	margin-bottom: 4px;
}

.meta {
	font-size: 12px;
	color: #888;
	margin-bottom: 4px;
}

.price {
	font-weight: bold;
	font-size: 15px;
}

/* 페이지네이션 */
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
	background: #121212;
	color: #fff;
	border-color: #121212;
}

.sold-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.45);
    display: flex;
    align-items: center;
    justify-content: center;
}

.sold-badge {
    background: #fff;
    color: #333;
    font-size: 12px;
    font-weight: bold;
    padding: 4px 10px;
    border-radius: 20px;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<div class="top-bar">
			<h2 style="margin: 0;">상품 목록</h2>
			<a href="${ctx}/product/new" class="write-btn">글쓰기</a>
		</div>

		<c:if test="${empty list}">
			<p style="text-align: center; color: #888; padding: 60px 0;">등록된
				상품이 없습니다.</p>
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
						<!-- 판매완료 -->
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
						<div class="meta">${p.category}· ${p.sellerNickname}</div>
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

			$.ajax({
				url: '${ctx}/favorite/toggle',
				type: 'POST',
				data: { productNo: productNo },
				success: function(result) {
					if (result === 'login') {
						alert('로그인이 필요합니다.');
						location.href = '${ctx}/login';
						return;
					}
					var count = parseInt(countEl.textContent, 10) || 0;
					if (result === 'added') count += 1;
					else if (result === 'removed') count = Math.max(0, count - 1);

					countEl.textContent = count;
					iconEl.classList.remove('fa-solid', 'fa-regular');
					iconEl.classList.add(count > 0 ? 'fa-solid' : 'fa-regular');
				},
				error: function() {
					alert('처리 중 오류가 발생했습니다.');
				}
			});
		}
	</script>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>