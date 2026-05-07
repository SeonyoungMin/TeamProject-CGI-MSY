<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>team404 - 홈</title>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<!-- 배너 -->

	<div class="card" style="text-align: center;">
		<a href="${ctx}/productList">전체</a> <a
			href="${ctx}/product/category?category=의류">의류</a> | <a
			href="${ctx}/product/category?category=잡화">잡화</a> | <a
			href="${ctx}/product/category?category=가구">가구</a> | <a
			href="${ctx}/product/category?category=전자기기">전자기기</a> | <a
			href="${ctx}/product/category?category=도서">도서</a> | <a
			href="${ctx}/product/category?category=기타">기타</a>
	</div>

	<div
		style="text-align: center; padding: 40px 20px; background: #EDEBE7;">
		<h1 style="font-size: 28px; margin: 0 0 15px 0;">쉽고 안전한 중고거래</h1>
		<a href="${ctx}/productList" class="btn btn-primary">상품 둘러보기</a> <a
			href="${ctx}/product/new" class="btn">글쓰기</a>
	</div>

	<div class="app-container">



		<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
			<h2 class="section-title" style="border-bottom:none; margin:0;">최근 등록 상품</h2>
			<a href="${ctx}/productList" style="font-size:14px; color:#666;">전체보기 &gt;</a>
		</div>

		<c:if test="${empty productList}">
			<div class="card" style="text-align: center; color: #888;">등록된
				상품이 없습니다.</div>
		</c:if>

		<c:if test="${not empty productList}">
			<div
				style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
				<c:forEach var="p" items="${productList}">
					<a href="${ctx}/product/${p.productNo}" class="card"
						style="display: block;">
						<div
							style="height: 180px; background: #f0f0f0; margin-bottom: 10px;">
							<c:if test="${not empty p.imgPath}">
								<img src="${ctx}${p.imgPath}"
									style="width: 100%; height: 100%; object-fit: cover;">
							</c:if>
							<c:if test="${empty p.imgPath}">
								<div
									style="height: 100%; display: flex; align-items: center; justify-content: center; color: #aaa;">이미지
									없음</div>
							</c:if>
						</div>
						<div style="font-size: 15px; font-weight: 600;">${p.productName}</div>
						<div style="font-size: 12px; color: #888; margin-top: 4px;">${p.sellerNickname}</div>
						<div style="font-weight: bold; margin-top: 6px;">
							<fmt:formatNumber value="${p.price}" />
							원
						</div>
					</a>
				</c:forEach>
			</div>
		</c:if>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
