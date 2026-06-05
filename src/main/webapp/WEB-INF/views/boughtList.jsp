<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boughtList.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<div class="is-boughtList-1">
			<h2 class="section-title is-boughtList-2">구매 내역
				<span class="is-boughtList-3">(${totalBought})</span>
			</h2>
			<a href="${ctx}/mypage" class="is-boughtList-4">&lt; 마이페이지로</a>
		</div>

		<c:choose>
			<c:when test="${empty boughtList}">
				<div class="card is-boughtList-5">
					구매한 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div class="bought-grid">
					<c:forEach var="item" items="${boughtList}">
						<div class="bought-card"
							onclick="location.href='${ctx}/product/${item.productNo}'">
							<div class="bought-thumb">
								<c:choose>
									<c:when test="${not empty item.imgPath}">
										<img src="${item.imgPath}"
											onerror="this.onerror=null;this.src='https://via.placeholder.com/150?text=No+Image';">
									</c:when>
									<c:otherwise>
										<span class="is-boughtList-6">이미지 없음</span>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="bought-info">
								<div class="bought-name">${item.productName}</div>
								<div class="bought-price">
									<fmt:formatNumber value="${item.price}" pattern="#,###" />원
								</div>
								<div class="bought-status">거래 완료</div>
							</div>
						</div>
					</c:forEach>
				</div>

				<c:if test="${totalPages > 1}">
					<div class="bought-pagination">
						<c:forEach var="i" begin="1" end="${totalPages}">
							<a href="${ctx}/mypage/bought?page=${i}"
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
