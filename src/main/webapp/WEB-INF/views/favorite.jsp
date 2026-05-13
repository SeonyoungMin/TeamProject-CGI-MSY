<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="app-container">

	<h2 class="section-title">내 찜 목록</h2>

	<c:if test="${empty products}">
		<div class="card" style="text-align:center; color:#888; padding:40px;">
			찜한 상품이 없습니다.<br><br>
			<a href="${ctx}/productList" class="btn btn-primary">상품 보러가기</a>
		</div>
	</c:if>

	<c:if test="${not empty products}">
		<div style="display:grid; grid-template-columns:repeat(3,1fr); gap:15px;">
			<c:forEach var="p" items="${products}">
				<div class="card">
					<a href="${ctx}/product/${p.productNo}">
						<div style="height:180px; background:#f0f0f0; margin-bottom:10px;">
							<c:if test="${not empty p.imgPath}">
								<img src="${p.imgPath}" style="width:100%; height:100%; object-fit:cover;">
							</c:if>
							<c:if test="${empty p.imgPath}">
								<div style="height:100%; display:flex; align-items:center; justify-content:center; color:#aaa;">이미지 없음</div>
							</c:if>
						</div>
						<div style="font-size:15px; font-weight:600;">${p.productName}</div>
						<div style="font-weight:bold; margin-top:6px;">
							<fmt:formatNumber value="${p.price}"/>원
						</div>
					</a>
					<form action="${ctx}/favorite/remove" method="post" style="margin-top:10px;">
						<input type="hidden" name="productNo" value="${p.productNo}">
						<button type="submit" class="btn btn-danger btn-block"
							onclick="return confirm('찜 목록에서 삭제하시겠습니까?')">찜 취소</button>
					</form>
				</div>
			</c:forEach>
		</div>
	</c:if>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
