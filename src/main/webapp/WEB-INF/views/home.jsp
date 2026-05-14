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
/* ===== 카테고리 메뉴 ===== */
.category-bar {
	display: flex;
	justify-content: center;
	gap: 4px;
	padding: 14px 20px;
	border-bottom: 1px solid #eee;
	background: #fff;
}

.category-bar a {
	padding: 6px 14px;
	font-size: 14px;
	color: #555;
	border-radius: 16px;
}

.category-bar a:hover {
	background: #f5f5f5;
	color: #111;
}

/* ===== 메인 배너 ===== */
.hero {
	text-align: center;
	padding: 80px 20px;
	background: #EDEBE7;
}

.hero h1 {
	font-size: 44px;
	margin: 0 0 24px;
	letter-spacing: -1px;
}

.hero .btn {
	font-size: 16px;
	padding: 12px 24px;
}

/* ===== 섹션 제목 ===== */
.section-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 24px 0 14px;
}

.section-head h2 {
	font-size: 20px;
	margin: 0;
}

.more-link {
	font-size: 14px;
	color: #666;
}

.section-divider {
	border: 0;
	border-top: 1px solid #ddd;
	margin: 30px 0 0;
}

/* ===== 상품 그리드 ===== */
.product-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
}

.product-grid.popular {
	grid-template-columns: repeat(3, 1fr);
	gap: 10px;
	max-width: 720px;
	margin: 0 auto;
}

.card {
	display: block;
	text-decoration: none;
	color: inherit;
	border: 1px solid #eee;
	padding: 10px;
	border-radius: 8px;
	position: relative;
}

.thumb {
	height: 180px;
	background: #f0f0f0;
	border-radius: 4px;
	overflow: hidden;
	position: relative;
}

.thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.product-grid.popular .thumb {
	height: 130px;
}

.product-name {
	font-size: 15px;
	font-weight: 600;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	margin-top: 6px;
}

.product-seller {
	font-size: 12px;
	color: #888;
	margin-top: 2px;
}

.product-price {
	font-weight: bold;
	margin-top: 4px;
}

.product-grid.popular .product-name {
	font-size: 13px;
}

.product-grid.popular .product-seller {
	font-size: 11px;
}

.product-grid.popular .product-price {
	font-size: 13px;
}

.product-date {
	font-size: 11px;
	color: #999;
	margin-top: 6px;
}

/* ===== 썸네일 위 배지 (조회수, 찜) ===== */
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

/* ===== 본문 + 사이드 레이아웃 ===== */
.home-layout {
	display: flex;
	gap: 24px;
	align-items: stretch;
}

.home-main {
	flex: 1;
	min-width: 0;
}

/* ===== 사이드 게시판 ===== */
.board-side {
	flex: 0 0 220px;
	display: flex;
	flex-direction: column;
	padding: 12px 14px;
	border: 1px solid #f0f0f0;
	background: #fff;
	font-size: 12px;
}

.board-side-header {
	display: flex;
	justify-content: space-between;
	align-items: baseline;
	margin-bottom: 8px;
	padding-bottom: 6px;
	border-bottom: 1px solid #f5f5f5;
}

.board-side-header h3 {
	margin: 0;
	font-size: 14px;
}

.board-side-more {
	font-size: 11px;
	color: #888;
}

.board-side-write {
	display: block;
	text-align: center;
	padding: 6px;
	font-size: 12px;
	border: 1px solid #ececec;
	color: #555;
	margin-bottom: 10px;
}

.board-side-write:hover {
	background: #fafafa;
}

.board-side-list {
	list-style: none;
	margin: 0;
	padding: 0;
	flex: 1;
}

.board-side-list li {
	padding: 6px 0;
	border-bottom: 1px solid #f5f5f5;
}

.board-side-list li:last-child {
	border-bottom: none;
}

.board-side-list li a {
	display: block;
	color: #222;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.board-side-list li a:hover {
	text-decoration: underline;
}

.board-side-meta {
	color: #999;
	font-size: 10px;
	margin-top: 2px;
}

.board-side-empty {
	padding: 10px 0;
	text-align: center;
	color: #888;
}

/* ===== 게시글 타입 태그, 핀 ===== */
.tag {
	display: inline-block;
	font-size: 10px;
	padding: 1px 5px;
	margin-right: 4px;
	border-radius: 2px;
	font-weight: 600;
	vertical-align: middle;
}

.tag-notice {
	background: #fdecec;
	color: #c0392b;
}

.tag-inquiry {
	background: #eef3fb;
	color: #2c6ab1;
}

.tag-free {
	background: #f1f5ee;
	color: #5a7a3a;
}

.pin {
	font-size: 11px;
	margin-right: 4px;
	color: #c0392b;
}

/* ===== 반응형 ===== */
@media ( max-width : 900px) {
	.home-layout {
		flex-direction: column;
	}
	.board-side {
		flex: none;
		max-width: 480px;
		margin: 20px auto;
	}
	.hero h1 {
		font-size: 32px;
	}
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<!-- 카테고리 메뉴 -->
	<nav class="category-bar">
		<a href="${ctx}/home">전체</a> <a href="${ctx}/home?category=의류">의류</a>
		<a href="${ctx}/home?category=잡화">잡화</a> <a
			href="${ctx}/home?category=가구">가구</a> <a
			href="${ctx}/home?category=전자기기">전자기기</a> <a
			href="${ctx}/home?category=도서">도서</a> <a
			href="${ctx}/home?category=기타">기타</a>
	</nav>

	<!-- 메인 배너 -->
	<div class="hero">
		<h1>쉽고 안전한 중고거래</h1>
		<a href="${ctx}/productList" class="btn btn-primary">상품 둘러보기</a> <a
			href="${ctx}/product/new" class="btn">글쓰기</a>
	</div>

	<div class="app-container home-layout">
		<div class="home-main">

			<!-- 인기상품 -->
			<div class="section-head">
				<h2>
					<i class="fa-solid fa-fire"></i> 인기상품
				</h2>
			</div>

			<c:if test="${empty popularList}">
				<div class="card" style="text-align: center; color: #888;">인기상품이
					없습니다.</div>
			</c:if>

			<c:if test="${not empty popularList}">
				<div class="product-grid popular">
					<c:forEach var="p" items="${popularList}">
						<a href="${ctx}/product/${p.productNo}" class="card">
							<div class="thumb">
								<c:if test="${not empty p.imgPath}">
									<img src="${p.imgPath}">
								</c:if>
								<span class="view-badge"><i class="fa-solid fa-eye"></i>
									${p.viewCount}</span> <span class="fav-btn"
									data-product-no="${p.productNo}"
									onclick="toggleFavorite(event, this)"> <i
									class="fav-icon ${p.isFavorite > 0 ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
									<span class="fav-count">${p.favoriteCount}</span>
								</span>
							</div>
							<div class="product-name">${p.productName}</div>
							<div class="product-seller">${p.sellerNickname}</div>
							<div class="product-price">
								<fmt:formatNumber value="${p.price}" />
								원
							</div>
						</a>
					</c:forEach>
				</div>
			</c:if>

			<hr class="section-divider">

			<!-- 최근 등록 상품 -->
			<div class="section-head">
				<h2>최근 등록 상품</h2>
				<a href="${ctx}/productList" class="more-link">전체보기 &gt;</a>
			</div>

			<c:if test="${empty productList}">
				<div class="card" style="text-align: center; color: #888;">등록된
					상품이 없습니다.</div>
			</c:if>

			<c:if test="${not empty productList}">
				<div class="product-grid">
					<c:forEach var="p" items="${productList}">
						<a href="${ctx}/product/${p.productNo}" class="card">
							<div class="thumb">
								<c:if test="${not empty p.imgPath}">
									<img src="${p.imgPath}">
								</c:if>
								<span class="view-badge"><i class="fa-solid fa-eye"></i>
									${p.viewCount}</span> <span class="fav-btn"
									data-product-no="${p.productNo}"
									onclick="toggleFavorite(event, this)"> <i
									class="fav-icon ${p.isFavorite > 0 ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
									<span class="fav-count">${p.favoriteCount}</span>
								</span>
							</div>
							<div class="product-name">${p.productName}</div>
							<div class="product-date">
								<fmt:formatDate value="${p.createdTime}" pattern="MM.dd" />
							</div>
							<div class="product-seller">${p.sellerNickname}</div>
							<div class="product-price">
								<fmt:formatNumber value="${p.price}" />
								원
							</div>
						</a>
					</c:forEach>
				</div>
			</c:if>

		</div>

		<!-- 사이드 게시판 -->
		<aside class="board-side">
			<div class="board-side-header">
				<h3>게시글</h3>
				<a href="${ctx}/board/all" class="board-side-more">더보기 &gt;</a>
			</div>

			<a href="${ctx}/board/write" class="board-side-write">게시글 쓰기</a>

			<c:if test="${empty recentBoards}">
				<div class="board-side-empty">등록된 게시글이 없습니다.</div>
			</c:if>

			<c:if test="${not empty recentBoards}">
				<ul class="board-side-list">
					<c:forEach var="b" items="${recentBoards}">
						<li><a href="${ctx}/boardList/${b.boardNo}"> <c:if
									test="${b.pinned}">
									<i class="pin fa-solid fa-thumbtack"></i>
								</c:if> <c:choose>
									<c:when test="${b.boardType == 'notice'}">
										<span class="tag tag-notice">공지</span>
									</c:when>
									<c:when test="${b.boardType == 'free'}">
										<span class="tag tag-free">자유</span>
									</c:when>
									<c:otherwise>
										<span class="tag tag-inquiry">문의</span>
									</c:otherwise>
								</c:choose> <span class="board-side-title">${b.title}</span>
						</a>
							<div class="board-side-meta">
								${b.authorNickname} ·
								<fmt:formatDate value="${b.createdTime}" pattern="MM.dd" />
							</div></li>
					</c:forEach>
				</ul>
			</c:if>
		</aside>
	</div>

	<script>
		// 찜 토글 (AJAX)
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