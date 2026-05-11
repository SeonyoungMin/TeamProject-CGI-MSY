<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>홈</title>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<!-- 배너 -->

	<div class="card" style="text-align: center;">
		<a href="${ctx}/home">전체</a> <a
			href="${ctx}/home?category=의류">의류</a> | <a
			href="${ctx}/home?category=잡화">잡화</a> | <a
			href="${ctx}/home?category=가구">가구</a> | <a
			href="${ctx}/home?category=전자기기">전자기기</a> | <a
			href="${ctx}/home?category=도서">도서</a> | <a
			href="${ctx}/home?category=기타">기타</a>
	</div>

	<div
		style="text-align: center; padding: 40px 20px; background: #EDEBE7;">
		<h1 style="font-size: 28px; margin: 0 0 15px 0;">쉽고 안전한 중고거래</h1>
		<a href="${ctx}/productList" class="btn btn-primary">상품 둘러보기</a> <a
			href="${ctx}/product/new" class="btn">글쓰기</a>
	</div>

	<!-- 이달의 판매왕 / 소비왕 -->
	<div class="app-container" style="margin-top: 20px; margin-bottom: 0;">
		<div
			style="background: #fff; border: 1px solid #eee; border-radius: 6px; padding: 10px 16px; font-size: 13px; display: flex; align-items: center; gap: 14px; margin-bottom: 8px;">
			<strong style="color: #121212;">이달의 판매왕</strong>
			<c:choose>
				<c:when test="${empty topSellers}">
					<span style="color: #888;">아직 기록이 없습니다.</span>
				</c:when>
				<c:otherwise>
					<c:forEach var="r" items="${topSellers}" varStatus="loop">
						<span> <span style="color: #999;">${loop.index + 1}위</span>
							<strong>${r.nickname}</strong> <span style="color: #888;">(${r.tradeCount}건)</span>
						</span>
						<c:if test="${not loop.last}">
							<span style="color: #ddd;">|</span>
						</c:if>
					</c:forEach>
				</c:otherwise>
			</c:choose>
			<hr>
			<strong style="color: #121212;">이달의 소비왕</strong>
			<c:choose>
				<c:when test="${empty topBuyers}">
					<span style="color: #888;">아직 기록이 없습니다.</span>
				</c:when>
				<c:otherwise>
					<c:forEach var="r" items="${topBuyers}" varStatus="loop">
						<span> <span style="color: #999;">${loop.index + 1}위</span>
							<strong>${r.nickname}</strong> <span style="color: #888;">(${r.tradeCount}건)</span>
						</span>
						<c:if test="${not loop.last}">
							<span style="color: #ddd;">|</span>
						</c:if>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div class="app-container">



		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
			<h2 class="section-title" style="border-bottom: none; margin: 0;">최근
				등록 상품</h2>
			<a href="${ctx}/productList" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
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


		<div
			style="display: flex; justify-content: space-between; align-items: center; margin: 40px 0 20px;">
			<h2 class="section-title" style="border-bottom: none; margin: 0;">게시판</h2>
			<a href="${ctx}/boardList" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>

		<a href="${ctx}/boardList" class="btn">게시글 보기</a> <a
			href="${ctx}/boardList/addForm" class="btn btn-primary">게시글 쓰기</a>
	</div>
	</div>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
