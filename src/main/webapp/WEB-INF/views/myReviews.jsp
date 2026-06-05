<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>받은 후기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myReviews.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<div class="is-myReviews-1">
			<h2 class="section-title is-myReviews-2">받은 후기
				<span class="is-myReviews-3">(${totalMyReviews})</span>
			</h2>
			<a href="${ctx}/mypage" class="is-myReviews-4">&lt; 마이페이지로</a>
		</div>

		<c:choose>
			<c:when test="${empty reviews}">
				<div class="card is-myReviews-5">
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