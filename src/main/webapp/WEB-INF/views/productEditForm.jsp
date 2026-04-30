<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
</head>
<body>
	<h1>상품 수정</h1>
	<hr>

	<form action="<c:url value='/product/${update.productNo}'/>" method="post" enctype="multipart/form-data">
		<input type="hidden" name="_method" value="PUT">

		<div>상품명 : <input type="text" name="name" value="${update.productName}" required></div>
		<div>
			카테고리 :
			<select name="category">
				<option value="전자기기" <c:if test="${update.category == '전자기기'}">selected</c:if>>전자기기</option>
				<option value="의류" <c:if test="${update.category == '의류'}">selected</c:if>>의류</option>
				<option value="가구" <c:if test="${update.category == '가구'}">selected</c:if>>가구</option>
				<option value="도서" <c:if test="${update.category == '도서'}">selected</c:if>>도서</option>
				<option value="기타" <c:if test="${update.category == '기타'}">selected</c:if>>기타</option>
			</select>
		</div>
		<div>가격 : <input type="number" name="price" value="${update.price}" required></div>
		<div>설명 : <textarea name="description" rows="5" cols="30">${update.description}</textarea></div>
		<div>
			현재 이미지 :
			<c:choose>
				<c:when test="${not empty update.imgName}">
					<img src="<c:url value='/upload/productImg/${update.imgName}'/>" width="100" height="100">
				</c:when>
				<c:otherwise>없음</c:otherwise>
			</c:choose>
		</div>
		<div>새 이미지 : <input type="file" name="imgFiles" multiple></div>
		<br>

		<button type="submit">수정 완료</button>
		<a href="<c:url value='/product/${update.productNo}'/>">취소</a>

	</form>

</body>
</html>