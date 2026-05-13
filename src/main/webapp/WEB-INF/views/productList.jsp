<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<h1>상품 목록</h1>
	<hr>

	<a href="<c:url value='/product/new'/>">상품 등록></a>
	<br>
	<br>

	<form action="<c:url value='/product/search'/>" method="get">
		<input type="text" name="keyword" placeholder="검색어 입력"
			value="${keyword}">
		<button type="submit">검색</button>
	</form>
	<a href="<c:url value='/product/mylist'/>">내 판매목록</a>
	<br>

	<a href="<c:url value='/product/category?category=의류'/>">의류</a> |
	<a href="<c:url value='/product/category?category=잡화'/>">잡화</a> |
	<a href="<c:url value='/product/category?category=가구'/>">가구</a> |
	<a href="<c:url value='/product/category?category=전자기기'/>">전자기기</a> |
	<a href="<c:url value='/product/category?category=도서'/>">도서</a> |
	<a href="<c:url value='/productList'/>">전체</a>
	<br>
	<br>

	<c:if test="${empty list}">
		<p>등록된 상품이 없습니다.</p>
	</c:if>

	<c:forEach var="p" items="${list}">
		<div style="position: relative; padding-bottom: 20px;">
			<c:if test="${not empty p.imgPath}">
				<img src="<c:url value='${p.imgPath}'/>" width="50" height="50"
					alt="${p.imgName}">
			</c:if>
			<a href="<c:url value='/product/${p.productNo}'/>">${p.productName}</a>
			| ${p.category} | ${p.price}원 | ${p.tradeStatus == '완료' ? '판매완료' : p.tradeStatus}
			| ${p.sellerNickname} <span
				style="position: absolute; bottom: 0; right: 0; font-size: 12px; color: #888;">
				👁 ${p.viewCount} </span>
		</div>
		<hr>
	</c:forEach>

	<c:if test="${not empty totalPages}">
		<c:forEach var="i" begin="1" end="${totalPages}">
			<a href="<c:url value='/productList?pageNum=${i}'/>"
				style="${i == currentPage ? 'font-weight:bold' : ''}">${i}</a>
		</c:forEach>
	</c:if>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
