<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>홈</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>
<c:if test="${not empty showReportAlert}">
    <script>
        alert("${showReportAlert}");
    </script>
    <% session.removeAttribute("reportAlert"); %>
</c:if>
<c:if test="${not empty pendingReportNo}">
    <script>
        var reportKey = "dismissedReport_${pendingReportNo}";
        if (!sessionStorage.getItem(reportKey)) {
            sessionStorage.setItem(reportKey, "true");
            if (confirm("신고가 접수되었습니다. 소명하시겠습니까?")) {
                location.href = "${ctx}/appeal/${pendingReportNo}";
            }
        }
    </script>
</c:if>

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
	<section class="hero">
		<c:choose>
			<c:when test="${not empty loginUser}">
				<div class="is-home-1">
					<i class="fa-solid fa-location-dot"></i>
					<c:choose>
						<c:when test="${not empty loginUser.verifiedArea}">
                        현재 인증된 동네: <strong>${loginUser.verifiedArea}</strong>
						</c:when>
						<c:otherwise>
							<strong class="is-home-2">아직 동네인증을 하지 않은 유저입니다.</strong>

							<a href="${pageContext.request.contextPath}/mypage" class="is-home-3">
								인증하기</a>
						</c:otherwise>
					</c:choose>
				</div>
				<h1>근처에서 상품찾기</h1>
				<a href="${ctx}/productList" class="is-home-4">
					상품 둘러보기 </a>
				<a href="${ctx}/product/new" class="is-home-5">
					글쓰기 </a>

			</c:when>
			<c:otherwise>
				<h1>
					우리 동네에서 찾는<br>쉽고빠른 직거래
				</h1>
			</c:otherwise>
		</c:choose>

	</section>

	<!-- 이달의 판매왕 / 소비왕 배너 -->
	<section class="king-banner">
		<div class="king-card">
			<h3>
				<i class="fa-solid fa-crown"></i> 이달의 판매왕
			</h3>
			<c:choose>
				<c:when test="${empty topSellers}">
					<div class="king-empty">이번 달 판매 기록이 없습니다.</div>
				</c:when>
				<c:otherwise>
					<ol class="king-list">
						<c:forEach var="r" items="${topSellers}" varStatus="s">
							<li><span><span class="king-rank">${s.index + 1}.</span>
									${r.nickname}</span> <span>${r.tradeCount}건</span></li>
						</c:forEach>
					</ol>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="king-card">
			<h3>
				<i class="fa-solid fa-sack-dollar"></i> 이달의 소비왕
			</h3>
			<c:choose>
				<c:when test="${empty topBuyers}">
					<div class="king-empty">이번 달 구매 기록이 없습니다.</div>
				</c:when>
				<c:otherwise>
					<ol class="king-list">
						<c:forEach var="r" items="${topBuyers}" varStatus="s">
							<li><span><span class="king-rank">${s.index + 1}.</span>
									${r.nickname}</span> <span>${r.tradeCount}건</span></li>
						</c:forEach>
					</ol>
				</c:otherwise>
			</c:choose>
		</div>
	</section>

	<div class="app-container home-layout">
		<div class="home-main">

			<!-- 인기상품 -->
			<div class="section-head">
				<h2>
					<i class="fa-solid fa-fire"></i> 인기상품
				</h2>
			</div>

			<c:if test="${empty popularList}">
				<div class="card is-home-6">인기상품이
					없습니다.</div>
			</c:if>

			<c:if test="${not empty popularList}">
				<div class="product-grid popular">
					<c:forEach var="p" items="${popularList}">
						<a href="${ctx}/product/${p.productNo}" class="card">
							<div class="thumb">
								<c:if test="${p.tradeStatus == '예약중'}">
									<div class="reserved-overlay">
										<span class="reserved-badge">예약중</span>
									</div>
								</c:if>
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
				<div class="card is-home-7">등록된
					상품이 없습니다.</div>
			</c:if>

			<c:if test="${not empty productList}">
				<div class="product-grid">
					<c:forEach var="p" items="${productList}">
						<a href="${ctx}/product/${p.productNo}" class="card">
							<div class="thumb">
								<c:if test="${p.tradeStatus == '예약중'}">
									<div class="reserved-overlay">
										<span class="reserved-badge">예약중</span>
									</div>
								</c:if>
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
				<a href="${ctx}/board/all" class="board-side-more">전체보기 &gt;</a>
			</div>

			<a href="${ctx}/board/write" class="board-side-write">게시글 쓰기</a>

			<c:if test="${empty recentBoards}">
				<div class="board-side-empty">등록된 게시글이 없습니다.</div>
			</c:if>

			<c:if test="${not empty recentBoards}">
				<ul class="board-side-list">
					<c:forEach var="b" items="${recentBoards}">
						<li><a href="${ctx}/boardList/${b.boardNo}"> <c:choose>
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