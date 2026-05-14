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
	color: white;
	text-decoration: none;
	border-radius: 8px;
}

/* 홈이랑 동일 카드 배열 */
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
	padding: 10px;
	border-radius: 8px;
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
	border-radius: 4px;
	overflow: hidden;
	position: relative;
}

.product-card img, .no-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #aaa;
	background: #f0f0f0;
}

/* 하단 조회수 + 찜 */
.bottom-badges {
	position: absolute;
	left: 8px;
	right: 8px;
	bottom: 8px;
	display: flex;
	justify-content: space-between;
}

.badge {
	background: rgba(255, 255, 255, .88);
	padding: 4px 8px;
	border-radius: 14px;
	font-size: 12px;
	display: flex;
	align-items: center;
	gap: 4px;
}

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
	font-size: 15px;
}

.fav-btn .fav-count {
	font-size: 12px;
	font-weight: bold;
	color: #111;
}
/* 텍스트 */
.info {
	padding-top: 8px;
}

.name {
	font-size: 15px;
	font-weight: 600;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	margin-top: 4px;
}

.meta {
	font-size: 12px;
	color: #888;
	margin-top: 2px;
}

.price {
	font-weight: bold;
	margin-top: 4px;
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

						<div class="bottom-badges">

							<div class="view-badge">
								<i class="fa-solid fa-eye"></i> ${p.viewCount}
							</div>

							<div class="fav-btn" data-product-no="${p.productNo}"
								onclick="toggleFavorite(event,this)">
								<i
									class="fav-icon ${p.isFavorite > 0 ? 'fa-solid':'fa-regular'} fa-heart"></i>
								<span class="fav-count">${p.favoriteCount}</span>
							</div>

						</div>
					</div>

					<div class="info">
						<div class="name">${p.productName}</div>
						<div class="meta">${p.category}</div>

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
		function toggleFavorite(event, el) {
			event.preventDefault();
			event.stopPropagation();

			var $el = $(el);
			var productNo = $el.attr('data-product-no');
			var $allRelatedBtns = $('.fav-btn[data-product-no="' + productNo
					+ '"]');

			$.ajax({
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

					var $firstCount = $allRelatedBtns.first()
							.find('.fav-count');
					var count = parseInt($firstCount.text()) || 0;

					if (result === 'added') {
						count++;
						$allRelatedBtns.find('.fav-icon').removeClass(
								'fa-regular').addClass('fa-solid');
					} else if (result === 'removed') {
						count = Math.max(0, count - 1);
						$allRelatedBtns.find('.fav-icon').removeClass(
								'fa-solid').addClass('fa-regular');
					}

					$allRelatedBtns.find('.fav-count').text(count);
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