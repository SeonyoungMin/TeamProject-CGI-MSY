<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>받은 후기</title>
<style>
.review-item {
	padding: 18px 20px;
	border: 1px solid #eee;
	border-radius: 10px;
	background: #fff;
	margin-bottom: 12px;
}

.review-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 8px;
}

.review-product {
	font-weight: bold;
	color: #333;
}

.review-date {
	font-size: 12px;
	color: #999;
}

.review-content {
	font-size: 14px;
	color: #444;
	line-height: 1.6;
}

.review-author {
	font-size: 12px;
	color: #aaa;
	margin-top: 8px;
	text-align: right;
}

.review-pagination {
	text-align: center;
	margin-top: 28px;
	display: flex;
	justify-content: center;
	gap: 8px;
}

.review-pagination a {
	padding: 5px 12px;
	border: 1px solid #ddd;
	text-decoration: none;
	color: #333;
	border-radius: 4px;
	background: #fff;
}

.review-pagination .current {
	background: #121212;
	color: #fff;
	border-color: #121212;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #121212; padding-bottom: 10px;">
			<h2 class="section-title" style="margin: 0; border-bottom: none;">받은 후기
				<span style="font-size: 14px; color: #999; font-weight: normal;">(${totalMyReviews})</span>
			</h2>
			<a href="${ctx}/mypage" style="font-size: 14px; color: #666;">&lt; 마이페이지로</a>
		</div>

		<c:choose>
			<c:when test="${empty reviews}">
				<div class="card" style="text-align: center; color: #999; padding: 40px;">
					아직 받은 후기가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="r" items="${reviews}">
					<div class="review-item">
						<div class="review-header">
							<span class="review-product">${r.productName}</span>
							<span class="review-date">
								<fmt:formatDate value="${r.createdTime}" pattern="yyyy.MM.dd" />
							</span>
						</div>
						<div class="review-content">${r.content}</div>
						<div class="review-author">작성자: ${r.sellerNickname}</div>
					</div>
				</c:forEach>

				<c:if test="${totalPages > 1}">
					<div class="review-pagination">
						<c:forEach var="i" begin="1" end="${totalPages}">
							<a href="${ctx}/mypage/reviews?page=${i}"
								class="${i == currentPage ? 'current' : ''}">${i}</a>
						</c:forEach>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
