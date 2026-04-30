<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세 조회</title>
</head>
<body>
	<h1>상품 상세</h1>
	<hr>

	<c:choose>
		<c:when test="${not empty listByProductNo.imgName}">
			<img
				src="<c:url value='/upload/productImg/${listByProductNo.imgName}'/>"
				width="200" height="200">
		</c:when>
		<c:otherwise>
			<p>이미지 없음</p>
		</c:otherwise>
	</c:choose>
	<br>

	<div>상품번호 : ${listByProductNo.productNo}</div>
	<div>상품명 : ${listByProductNo.productName}</div>
	<div>카테고리 : ${listByProductNo.category}</div>
	<div>가격 : ${listByProductNo.price}원</div>
	<div>설명 : ${listByProductNo.description}</div>
	<div>거래 상태 :
		<c:choose>
			<c:when test="${listByProductNo.tradeStatus == '판매중'}">판매중</c:when>
			<c:when test="${listByProductNo.tradeStatus == '예약중'}">예약중</c:when>
			<c:when test="${listByProductNo.tradeStatus == '판매완료'}">판매완료</c:when>
		</c:choose>
	</div>
	<div>판매자 : ${listByProductNo.sellerNickname}</div>
	<div>등록일 : ${listByProductNo.createdTime}</div>
	<br>

	<form
		action="<c:url value='/product/${listByProductNo.productNo}/status'/>"
		method="post">
		<select name="status">
			<option value="판매중">판매중</option>
			<option value="예약중">예약중</option>
			<option value="판매완료">판매완료</option>
		</select>
		<button type="submit">상태 변경</button>
	</form>
	<br>

	<a href="<c:url value='/product/${listByProductNo.productNo}/edit'/>">수정</a>
	&nbsp;

	<form action="<c:url value='/product/${listByProductNo.productNo}'/>"
		method="post" style="display: inline;">
		<input type="hidden" name="_method" value="DELETE">
		<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
	</form>
	<br>
	<br>

	<a href="<c:url value='/productList'/>">목록으로</a>

</body>
</html>