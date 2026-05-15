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

.view-badge {
	position: absolute;
	bottom: 8px;
	left: 8px;
	background: rgba(0, 0, 0, 0.55);
	color: #fff;
	font-size: 12px;
	padding: 2px 6px;
	border-radius: 10px;
}

.fav-btn {
	position: absolute;
	bottom: 8px;
	right: 8px;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: 3px 8px;
	background: rgba(255, 255, 255, 0.85);
	border-radius: 14px;
	cursor: pointer;
	user-select: none;
}

.fav-btn:hover {
	background: #fff;
}

.fav-btn .fav-icon {
	color: #ff4d4d;
	font-size: 10px;
}

.fav-btn .fav-count {
	font-size: 12px;
	font-weight: bold;
	color: #111;
}


</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<div class="top-bar">
			<h2>상품 목록</h2>
			<a href="${ctx}/product/new" class="write-btn" style="color: #fff;">글쓰기</a>
		</div>

		<c:if test="${empty list}">
			<p style="text-align: center; color: #888;">등록된 상품이 없습니다.</p>
		</c:if>

		<div class="product-grid">
			<c:forEach var="p" items="${list}">
				<a href="${ctx}/product/${p.productNo}" class="product-card">
					<div style="position: relative;">
						<c:choose>
							<c:when test="${not empty p.imgPath}">
								<img src="${p.imgPath}"
									style="width: 100%; height: 160px; object-fit: cover;">
							</c:when>

							<c:otherwise>
								<div class="no-img">이미지 없음</div>
							</c:otherwise>
						</c:choose>

						<span class="view-badge"> <i class="fa-solid fa-eye"></i>
							${p.viewCount}
						</span>
						<span class="fav-btn" data-product-no="${p.productNo}"
							onclick="toggleFavorite(event, this)"> <i
							class="fav-icon ${p.favoriteCount > 0 ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
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
							<a href="${ctx}/productList?pageNum=${i}"> ${i} </a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</c:if>

	</div>
	<script>
		// 찜 토글 (AJAX)
		function toggleFavorite(event, el) {
			event.preventDefault();
			event.stopPropagation();

			var productNo = el.getAttribute('data-product-no');
			var iconEl = el.querySelector('.fav-icon');
			var countEl = el.querySelector('.fav-count');

			var form = new URLSearchParams();
			form.append('productNo', productNo);

			fetch('${ctx}/favorite/toggle', {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: form.toString()
			}).then(function(res) {
				return res.text();
			}).then(function(result) {
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
			}).catch(function() {
				alert('처리 중 오류가 발생했습니다.');
			});
		}
	</script>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>