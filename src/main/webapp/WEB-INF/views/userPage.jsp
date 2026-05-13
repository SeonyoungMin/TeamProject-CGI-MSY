<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${user.userNickName}님의프로필</title>
<style>
/* 기본 레이아웃 */
.app-container {
	max-width: 700px;
	margin: 0 auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

/* 프로필 섹션 (지역/온도 제외) */
.profile-section {
	padding: 40px 0;
	display: flex;
	align-items: center;
	gap: 20px;
	border-bottom: 1px solid #eee;
}

.profile-img {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	background: #eee;
	object-fit: cover;
	border: 1px solid #eee;
}

/* 섹션 공통 헤더 */
.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 30px 0 20px;
}

.section-title {
	font-size: 18px;
	font-weight: bold;
	color: #121212;
}

.item-count {
	font-size: 13px;
	color: #999;
	font-weight: normal;
}

/* 상품 그리드 */
.product-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20px;
}

.product-card {
	text-decoration: none;
	color: inherit;
	border: 1px solid #f0f0f0;
	border-radius: 12px;
	overflow: hidden;
	transition: 0.2s;
	background: #fff;
}

.product-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.product-card img {
	width: 100%;
	height: 180px;
	object-fit: cover;
	background: #fafafa;
}

.product-info {
	padding: 15px;
}

.product-name {
	font-size: 15px;
	margin-bottom: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	color: #333;
}

.product-price {
	font-weight: bold;
	font-size: 16px;
	color: #111;
}

/* 후기 리스트 */
.review-container {
	margin-top: 50px;
	border-top: 1px solid #eee;
	padding-top: 30px;
}

.review-item {
	padding: 20px;
	border-radius: 10px;
	background: #f9f9f9;
	margin-bottom: 15px;
	border: 1px solid #f0f0f0;
}

.review-top {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
	font-size: 13px;
	color: #777;
}

.review-product-name {
	font-weight: bold;
	color: #444;
}

.review-content {
	font-size: 14px;
	color: #333;
	line-height: 1.6;
}

.review-buyer {
	margin-top: 12px;
	font-size: 12px;
	color: #999;
	display: flex;
	align-items: center;
	gap: 5px;
}

.buyer-circle {
	width: 20px;
	height: 20px;
	border-radius: 50%;
	background: #ddd;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">
		<div class="profile-section">
			<div style="margin-bottom: 20px;">
				<c:choose>
					<c:when test="${not empty profileImage}">
						<img src="${profileImage.filePath}"
							style="max-width: 200px; border: 1px solid #ddd;">
					</c:when>
					<c:otherwise>
						<div style="color: #999;">사진 없음</div>
					</c:otherwise>
				</c:choose>
			</div>
			<div>
				<h2 style="margin: 0; font-size: 22px; color: #121212;">${user.userNickName}</h2>
				<div style="margin-top: 5px; color: #666; font-size: 14px;">등급:
					${user.userRole}</div>

				<c:if test="${sessionScope.loginUser.userRole == 'ROLE_ADMIN'}">
					<div style="margin-top: 12px; display: flex; gap: 8px;">
						<a href="${ctx}/users/edit/${user.userNo}" class="btn">회원 정보 수정</a>
						<form action="${ctx}/users/delete/${user.userNo}" method="post"
							style="display: inline; margin: 0;"
							onsubmit="return confirm('정말 이 회원을 삭제하시겠습니까?');">
							<input type="hidden" name="_method" value="DELETE">
							<button type="submit" class="btn btn-danger">회원 삭제</button>
						</form>
					</div>
				</c:if>
			</div>
		</div>

		<div class="section-header">
			<span class="section-title">판매 상품 <span class="item-count">(${myProducts.size()})</span></span>
		</div>

		<c:choose>
			<c:when test="${empty myProducts}">
				<div
					style="padding: 60px 0; text-align: center; color: #bbb; border: 1px dashed #eee; border-radius: 10px;">
					등록된 상품이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div class="product-grid">
					<c:forEach var="p" items="${myProducts}">
						<a href="${ctx}/product/${p.productNo}" class="product-card">
							<c:choose>
								<c:when test="${not empty p.imgPath}">
									<img src="${p.imgPath}">
								</c:when>
								<c:otherwise>
									<div
										style="width: 100%; height: 180px; background: #f5f5f5; display: flex; align-items: center; justify-content: center; color: #ccc;">이미지
										없음</div>
								</c:otherwise>
							</c:choose>
							<div class="product-info">
								<div class="product-name">${p.productName}</div>
								<div class="product-price">
									<fmt:formatNumber value="${p.price}" pattern="#,###" />
									원
								</div>
							</div>
						</a>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>

		<div class="review-container"
			style="margin-top: 50px; border-top: 1px solid #eee; padding-top: 30px;">

			<div class="section-header" style="margin-bottom: 20px;">
				<span class="section-title"
					style="font-size: 18px; font-weight: bold;"> 거래 후기 <span
					class="item-count" style="font-size: 13px; color: #999;">(${reviews.size()})</span>
				</span>
			</div>

			<div class="card"
				style="padding: 20px; background: #f9f9f9; border-radius: 8px; border: 1px solid #eee; margin-bottom: 30px;">
				<h4 style="margin-top: 0; margin-bottom: 15px; font-size: 16px;">이
					판매자에게 후기 남기기</h4>
				<form action="${ctx}/review/add" method="post">
					<input type="hidden" name="sellerNo" value="${user.userNo}">
					<div style="margin-bottom: 15px;">
						<label
							style="font-size: 13px; color: #666; display: block; margin-bottom: 5px;">상품
							번호</label> <input type="number" name="productNo"
							value="${not empty myProducts ? myProducts[0].productNo : ''}"
							style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
							required>
					</div>
					<div style="margin-bottom: 10px;">
						<textarea name="content" rows="4"
							style="width: 100%; border: 1px solid #ddd; border-radius: 4px; padding: 12px; box-sizing: border-box; resize: none;"
							placeholder="거래 후기를 입력하세요" required></textarea>
					</div>
					<div style="text-align: right;">
						<button type="submit" class="btn btn-primary"
							style="background: #121212; color: #fff; border: none; padding: 10px 25px; border-radius: 4px; cursor: pointer;">
							후기 등록</button>
					</div>
				</form>
			</div>

			<hr style="margin: 40px 0; border: 0; border-top: 1px solid #eee;">

			<div id="reviewList">
				<c:choose>
					<c:when test="${empty reviews}">
						<div style="text-align: center; padding: 50px 0; color: #bbb;">작성된
							후기가 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="r" items="${reviews}">
							<div class="review-item"
								style="margin-bottom: 15px; padding: 20px; background: #fff; border: 1px solid #eee; border-radius: 8px;">
								<div
									style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
									<span style="font-weight: bold; color: #333;">${r.productName}</span>
									<span style="font-size: 12px; color: #999;"> <fmt:formatDate
											value="${r.createdTime}" pattern="yyyy.MM.dd" />
									</span>
								</div>
								<div style="font-size: 14px; color: #444; line-height: 1.6;">${r.content}</div>
								<div
									style="font-size: 12px; color: #aaa; margin-top: 8px; text-align: right;">
									작성자: ${r.sellerNickname}</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="pagination"
				style="text-align: center; margin-top: 20px; display: flex; justify-content: center; gap: 8px;">
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="${ctx}/users/search/${user.userNo}?page=${i}"
						style="padding: 5px 12px; border: 1px solid #ddd; text-decoration: none; color: #333; border-radius: 4px; 
                  ${i == currentPage ? 'background-color: #121212; color: #fff; border-color: #121212;' : 'background-color: #fff;'}">
						${i} </a>
				</c:forEach>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>