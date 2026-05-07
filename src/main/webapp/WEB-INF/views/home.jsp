<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>

<style>
.category-nav {
	background: #fff;
	border-bottom: 1px solid #eee;
	padding: 15px 0;
	text-align: center;
}

.category-nav a {
	margin: 0 15px;
	font-size: 14px;
	font-weight: 500;
	color: #333;
	text-decoration: none;
}

.main-container {
	max-width: 1200px;
	margin: 30px auto;
	display: flex;
	gap: 30px;
}

.left-content {
	flex: 3;
}

.right-content {
	flex: 1;
}

.sidebar-box {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 20px;
}

.sidebar-box h4 {
	margin-top: 0;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
}

.sidebar-item {
	font-size: 13px;
	padding: 10px 0;
	border-bottom: 1px solid #f9f9f9;
}

.product-list {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
}

.card {
	border: 1px solid #eee;
	border-radius: 8px;
	overflow: hidden;
	cursor: pointer;
	background: #fff;
	transition: transform 0.2s;
}

.card:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.thumb {
	width: 100%;
	height: 180px;
	background: #f0f0f0;
}

.card-info {
	padding: 12px;
}

.title {
	font-size: 15px;
	font-weight: 500;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.price {
	font-weight: bold;
	margin-top: 8px;
	font-size: 16px;
	color: #121212;
}

.location {
	font-size: 12px;
	color: #888;
	margin-top: 5px;
}

.page-btn {
	margin: 3px;
	padding: 6px 12px;
	cursor: pointer;
	border-radius: 4px;
	border: 1px solid #ccc;
	background: white;
	text-decoration: none;
	color: black;
}

.current-page {
	background: #121212;
	color: white;
	border: 2px solid #121212;
}
</style>
</head>

<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="category-nav">
		<a href="${pageContext.request.contextPath}/productList">전체</a> <a
			href="${pageContext.request.contextPath}/product/category?category=전자기기">전자기기</a>
		<a
			href="${pageContext.request.contextPath}/product/category?category=의류">의류</a>
		<a
			href="${pageContext.request.contextPath}/product/category?category=가구">가구</a>
		<a
			href="${pageContext.request.contextPath}/product/category?category=도서">도서</a>
	</div>

	<div class="content">

		<div class="banner"
			style="text-align: center; padding: 50px 20px; background: #EDEBE7;">

			<h1 style="font-size: 32px; margin-bottom: 10px;">쉽고 안전한 중고거래</h1>

			<div style="margin-top: 20px;">

				<button
					onclick="location.href='${pageContext.request.contextPath}/productList'"
					style="width: 160px; height: 45px; background: #121212; color: white; border: none; cursor: pointer;">

					상품 둘러보기</button>

				<button
					onclick="location.href='${pageContext.request.contextPath}/product/new'"
					style="width: 160px; height: 45px; margin-left: 10px; background: white; border: 1px solid #ddd; cursor: pointer;">

					글쓰기</button>

			</div>
		</div>

		<div class="main-container">

			<div class="left-content">

				<section>

					<div
						style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">

						<h3 style="margin: 0;">최근 등록 상품</h3>

					</div>

					<div class="product-list">

						<c:choose>

							<c:when test="${empty productList}">

								<div style="grid-column: span 3; text-align: center;">등록된
									상품이 없습니다.</div>

							</c:when>

							<c:otherwise>

								<c:forEach var="p" items="${productList}">

									<div class="card"
										onclick="location.href='${pageContext.request.contextPath}/product/${p.productNo}'">

										<div class="thumb">

											<c:choose>

												<c:when test="${not empty p.imgPath}">

													<img src="${pageContext.request.contextPath}${p.imgPath}"
														style="width: 100%; height: 100%; object-fit: cover;">

												</c:when>

												<c:otherwise>

													<div
														style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: #aaa;">

														이미지 없음</div>

												</c:otherwise>

											</c:choose>

										</div>

										<div class="card-info">

											<div class="title">${p.productName}</div>

											<div class="location">${p.sellerNickname}</div>

											<div class="price">${p.price}원</div>

										</div>

									</div>

								</c:forEach>

							</c:otherwise>

						</c:choose>

					</div>

					<div style="text-align: center; margin-top: 40px;">

						<c:forEach begin="1" end="${totalPages}" var="i">

							<a
								href="${pageContext.request.contextPath}/productList?pageNum=${i}"
								class="page-btn ${i == currentPage ? 'current-page' : ''}">

								${i} </a>

						</c:forEach>

					</div>

				</section>

			</div>

			<aside class="right-content">

				<div class="sidebar-box">
					<h4>문의게시글</h4>
					<div class="sidebar-item">어떻게 결제 하나요?</div>
				</div>

				<div class="sidebar-box">
					<h4>공지사항</h4>
					<div class="sidebar-item">시스템 점검 안내</div>
				</div>

			</aside>

		</div>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>