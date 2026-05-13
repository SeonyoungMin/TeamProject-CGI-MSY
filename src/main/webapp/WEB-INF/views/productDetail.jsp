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

.thumb-list {
	display: flex;
	gap: 8px;
	margin-top: 10px;
	flex-wrap: wrap;
}

.thumb-list img {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border: 1px solid #ddd;
	border-radius: 4px;
	cursor: pointer;
}

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
}

.product-meta {
	color: #666;
	font-size: 14px;
	line-height: 1.8;
	margin-bottom: 20px;
}

/* 판매자 섹션 스타일 추가 */
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

.seller-img {
	width: 45px;
	height: 45px;
	border-radius: 50%;
	background: #f0f0f0;
	overflow: hidden;
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

.desc-box {
	background: #f7f7f7;
	border-radius: 6px;
	padding: 15px;
	min-height: 120px;
	white-space: pre-wrap;
}

/* 댓글 */
.comment-item {
	border-bottom: 1px solid #eee;
	padding: 12px 0;
}

.comment-author {
	font-weight: bold;
}

.comment-date {
	font-size: 12px;
	color: #999;
	margin-left: 8px;
}

.comment-content {
	margin: 6px 0;
	white-space: pre-wrap;
}

.btn-order {
	display: inline-block;
	padding: 10px 20px;
	background-color: #ff9800;
	color: white !important;
	text-decoration: none;
	border-radius: 5px;
	font-weight: bold;
	margin-right: 10px;
}

.btn-order:hover {
	background-color: #e68a00;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<div class="card">
			<div class="detail-top">

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
						<div class="thumb-list">
							<c:forEach var="img" items="${product.images}">
								<img src="${img.filePath}" onclick="changeImage(this.src)">
							</c:forEach>
						</div>
					</c:if>
				</div>

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
							</div>
						</div>
					</div>

					<div class="product-meta">
						카테고리 : ${product.category}<br> 등록일 :
						<fmt:formatDate value="${product.createdTime}"
							pattern="yyyy.MM.dd" />
						<br>
						<div class="product-meta">상품번호 : ${product.productNo}</div>


						<div style="margin-top: 20px; display: flex; gap: 10px;">
							<a
								href="${pageContext.request.contextPath}/order/select?productNo=${product.productNo}"
								class="btn-order">구매하기</a>

							<c:if test="${not empty loginUser}">
								<button id="favBtn" type="button" class="btn btn-line"
									onclick="toggleFavorite()">${favorite ? '♥ 찜 취소' : '♡ 찜하기'}
								</button>
							</c:if>
						</div>

						<c:if
							test="${not empty loginUser && (loginUser.userNo == product.sellerNo || loginUser.userRole == 'ROLE_ADMIN')}">
							<div style="margin-top: 10px; display: flex; gap: 10px;">
								<a class="btn btn-line"
									href="${ctx}/product/${product.productNo}/edit">수정</a>
								<form action="${ctx}/product/${product.productNo}/delete"
									method="post" style="margin: 0;">
									<button type="submit" class="btn btn-danger"
										onclick="return confirm('삭제하시겠습니까?')">삭제</button>
								</form>
							</div>
						</c:if>
					</div>

				</div>
			</div>

			<div class="card">
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
							<textarea class="form-input" name="content"
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
										<div class="comment-item">
											<span class="comment-author"> <c:choose>
													<c:when test="${empty c.nickname}">익명</c:when>
													<c:otherwise>${c.nickname}</c:otherwise>
												</c:choose>
											</span> <span class="comment-date">${c.createdTime}</span>
											<div class="comment-content">${c.content}</div>

											<c:if
												test="${c.authorNo == loginUser.userNo || loginUser.userRole == 'ROLE_ADMIN'}">
												<div style="display: flex; gap: 5px; margin-top: 6px;">
													<c:if test="${c.authorNo == loginUser.userNo}">
														<a href="${ctx}/comment/${c.commentNo}/edit" class="btn"
															style="padding: 3px 10px; font-size: 12px;">수정</a>
													</c:if>
													<form action="${ctx}/comment/${c.commentNo}/delete"
														method="post" style="margin: 0;">
														<input type="hidden" name="boardNo"
															value="${product.productNo}">
														<button type="submit" class="btn btn-danger"
															style="padding: 3px 10px; font-size: 12px;"
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

		<%@ include file="/WEB-INF/views/footer.jsp"%>

		<script>
	var ctx = "${ctx}";
	var productNo = ${product.productNo};
	var loginUserNo = ${empty loginUser ? 0 : loginUser.userNo};

	function changeImage(src) {
		document.getElementById("mainImage").src = src;
	}

	// ==== 찜하기 ====
	function toggleFavorite() {
		$.post(ctx + "/favorite/toggle", { productNo: productNo }, function(result) {
			if (result === "added") {
				$("#favBtn").text("♥ 찜 취소");
			} else if (result === "removed") {
				$("#favBtn").text("♡ 찜하기");
			} else {
				alert("로그인이 필요합니다.");
			}
		});
	}
</script>
</body>
</html>