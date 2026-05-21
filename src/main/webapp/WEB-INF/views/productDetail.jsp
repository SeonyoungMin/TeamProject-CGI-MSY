<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${product.productName}</title>
<style>
.detail-container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.detail-top {
	display: flex;
	gap: 30px;
	align-items: flex-start;
}

.detail-image {
	flex: 1;
}

.detail-info {
	flex: 1;
}

.main-image {
	width: 100%;
	height: 400px;
	background: #f3f3f3;
	border: 1px solid #eee;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
}

.main-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.thumb-list-wrap {
	position: relative;
	margin-top: 10px;
	display: flex;
	align-items: center;
	justify-content: space-betwwen;
}

.thumb-list {
	width: 382px;
	flex-shrink: 0;
	display: flex;
	gap: 8px;
	overflow: hidden;
	margin: 0 auto;
}

.thumb-list img {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border: 1px solid #ddd;
	border-radius: 4px;
	cursor: pointer;
	flex-shrink: 0;
	transition: 0.2s;
}

.thumb-list img:hover {
	opacity: 0.8;
	border-color: #121212;
}

.thumb-slide-btn {
	flex-shrink: 0;
	width: 28px;
	height: 70px;
	cursor: pointer;
	font-size: 20px;
	background: none;
	border: none;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 0;
	z-index: 1;
}

/* .thumb-slide-btn:hover {
	background: #e0e0e0;
} */
.product-status {
	display: inline-block;
	padding: 4px 10px;
	background: #121212;
	color: #fff;
	border-radius: 4px;
	font-size: 12px;
}

.product-title {
	font-size: 24px;
	font-weight: bold;
	margin: 10px 0;
}

.product-price {
	font-size: 28px;
	font-weight: bold;
	margin: 20px 0;
	align-items: center;
	display: flex;
	justify-content: space-between;
}

.product-meta {
	color: #666;
	font-size: 14px;
	line-height: 1.8;
	margin-bottom: 20px;
	width: 100%;
}

.seller-profile-box {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 15px 0;
	border-top: 1px solid #eee;
	border-bottom: 1px solid #eee;
	margin: 20px 0;
}

.seller-info-left {
	display: flex;
	align-items: center;
	gap: 12px;
}

.seller-name-link {
	text-decoration: none;
	color: #121212;
	font-weight: bold;
	font-size: 16px;
}

.seller-name-link:hover {
	text-decoration: underline;
}

.btn-order {
	display: inline-flex;
	align-items: center;
	padding: 10px 20px;
	background-color: #ff9800;
	color: white !important;
	text-decoration: none;
	border-radius: 5px;
	font-weight: bold;
	font-size: 14px;
	box-sizing: border-box;
}

.btn-order:hover {
	background-color: #e68a00;
}

#favBtn {
	padding: 10px 10px;
	border-radius: 5px;
	font-size: 14px;
	box-sizing: border-box;
	gap: 4px;
}

.fav-area {
	margin-top: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.fav-count-wrap {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	font-size: 14px;
	color: #888;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="detail-container">
		<!-- app-container 대신 더 넓은 detail-container 사용 -->
		<div class="card">
			<div class="detail-top">
				<!-- 이미지 섹션 -->
				<div class="detail-image">
					<div class="main-image">
						<c:if test="${not empty product.imgPath}">
							<img id="mainImage" src="${product.imgPath}">
						</c:if>
						<c:if test="${empty product.imgPath}">
							<span style="color: #999;">이미지 없음</span>
						</c:if>
					</div>
					<c:if test="${not empty product.images}">
						<div class="thumb-list-wrap">
							<button type="button" class="thumb-slide-btn"
								onclick="slideThumb(-1)">&#8249;</button>
							<div class="thumb-list" id="thumbList">
								<c:forEach var="img" items="${product.images}">
									<img src="${img.filePath}" onmouseover="changeImage(this.src)">
								</c:forEach>
							</div>
							<button type="button" class="thumb-slide-btn"
								onclick="slideThumb(1)">&#8250;</button>
						</div>
					</c:if>
				</div>

				<!-- 상품 정보 섹션 -->
				<div class="detail-info">
					<div class="product-status">${product.tradeStatus == '판매중' ? '판매중' : product.tradeStatus == '예약중' ? '예약중' : '판매완료'}
					</div>
					<div class="product-title">${product.productName}</div>
					<div class="product-price">
						<fmt:formatNumber value="${product.price}" />
						원
					</div>

					<div class="seller-profile-box">
						<div class="seller-info-left">
							<div style="display: flex; flex-direction: column;">
								<a href="${ctx}/users/search/${product.sellerNo}"
									class="seller-name-link"> ${product.sellerNickname} </a> <span
									style="font-size: 12px; color: #888;">판매자 프로필 보기</span>

								<c:choose>
									<c:when test="${not empty seller.verifiedArea}">
										<span style="font-size: 13px; color: #555; margin-top: 2px;">${seller.verifiedArea}</span>
									</c:when>
									<c:otherwise>
										<span style="font-size: 13px; color: #ccc; margin-top: 2px;">동네
											미인증</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>

					<div class="product-meta">
						카테고리 : ${product.category}<br> 등록일 :
						<fmt:formatDate value="${product.createdTime}"
							pattern="yyyy.MM.dd" />
						<br> 상품번호 : ${product.productNo}

						<div class="fav-area">
							<c:if test="${product.sellerNo != loginUser.userNo}">
								<a href="${ctx}/order/select?productNo=${product.productNo}"
									class="btn-order">구매하기</a>
							</c:if>
							<c:if test="${product.sellerNo == loginUser.userNo}">
								<span style="color: #e74c3c; font-size: 14px;"> 본인 상품은
									구매할 수 없습니다.</span>
							</c:if>
							<c:if test="${not empty loginUser}">
								<button id="favBtn" type="button" class="btn btn-line"
									onclick="toggleFavorite()">
									<i id="favIcon"
										class="${favorite ? 'fa-solid' : 'fa-regular'} fa-heart"
										style="color: #ff4d4d;"></i> <span id="favCount">${favoriteCount}</span>
								</button>
							</c:if>
						</div>

						<c:if
							test="${not empty loginUser && (loginUser.userNo == product.sellerNo || loginUser.userRole == 'ROLE_ADMIN')}">
							<div style="margin-top: 10px; display: flex; gap: 10px;">
								<a class="btn btn-line"
									href="${ctx}/product/${product.productNo}/edit">수정</a>
								<form action="${ctx}/product/${product.productNo}/delete"
									method="post" style="margin: 0; display: contents;">
									<button type="submit" class="btn btn-danger"
										onclick="return confirm('삭제하시겠습니까?')">삭제</button>
								</form>
							</div>
						</c:if>
					</div>
				</div>
			</div>

			<!-- 댓글 섹션 -->
			<div class="card" style="margin-top: 40px;">
				<h3 class="section-title">댓글</h3>
				<c:choose>
					<c:when test="${empty loginUser}">
						<div style="color: #888;">
							<a href="${ctx}/login">댓글을 작성하려면 로그인이 필요합니다.</a>
						</div>
					</c:when>
					<c:otherwise>
						<form action="${ctx}/comment/add" method="post"
							style="margin-bottom: 20px;">
							<input type="hidden" name="boardNo" value="${product.productNo}">
							<input type="hidden" name="targetType" value="PRODUCT">
							<textarea class="form-input" name="content"
								style="width: 100%; height: 80px; margin-bottom: 10px;"
								placeholder="댓글을 입력하세요" required></textarea>
							<button type="submit" class="btn btn-primary">댓글 등록</button>
						</form>

						<div id="commentList">
							<c:choose>
								<c:when test="${empty comments}">
									<div style="color: #999; padding: 10px 0;">아직 댓글이 없습니다.</div>
								</c:when>
								<c:otherwise>
									<c:forEach var="c" items="${comments}">
										<div class="comment-item"
											style="border-bottom: 1px solid #eee; padding: 10px 0;">
											<span class="comment-author">${empty c.nickname ? '익명' : c.nickname}</span>
											<span class="comment-date"
												style="font-size: 12px; color: #999; margin-left: 10px;">${c.createdTime}</span>
											<div class="comment-content" style="margin: 5px 0;">${c.content}</div>

											<c:if
												test="${c.authorNo == loginUser.userNo || loginUser.userRole == 'ROLE_ADMIN'}">
												<div style="display: flex; gap: 5px;">
													<c:if test="${c.authorNo == loginUser.userNo}">
														<a href="${ctx}/comment/${c.commentNo}/edit"
															style="font-size: 12px;">수정</a>
													</c:if>
													<form action="${ctx}/comment/${c.commentNo}/delete"
														method="post" style="margin: 0;">
														<input type="hidden" name="boardNo"
															value="${product.productNo}">
														<button type="submit"
															style="font-size: 12px; background: none; border: none; color: red; cursor: pointer;"
															onclick="return confirm('삭제하시겠습니까?')">삭제</button>
													</form>
												</div>
											</c:if>
										</div>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		var ctx = "${ctx}";
		var productNo = ${product.productNo};

		function changeImage(src) {
			document.getElementById("mainImage").src = src;
		}

		function toggleFavorite() {
			$.post(ctx + "/favorite/toggle", {
				productNo : productNo
			}, function(result) {
				var countEl = document.getElementById('favCount');
				var count = parseInt(countEl.textContent) || 0;

				if (result === "added") {
					$("#favIcon").removeClass("fa-regular")
							.addClass("fa-solid");
					countEl.textContent = count + 1;
				} else if (result === "removed") {
					$("#favIcon").removeClass("fa-solid")
							.addClass("fa-regular");
					countEl.textContent = Math.max(0, count - 1);
				}
			});
		}

		function slideThumb(dir) {
			var list = document.getElementById('thumbList');
			list.scrollBy({
				left : dir * 80,
				behavior : 'smooth'
			});
		}
	</script>
</body>
</html>