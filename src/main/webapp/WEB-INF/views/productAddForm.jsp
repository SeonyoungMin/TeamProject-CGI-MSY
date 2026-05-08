<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>상품 등록</h1>
	<hr>

	<form action="<c:url value='/product'/>" method="post" enctype="multipart/form-data">

		<div>판매자 번호 : <input type="text" value="${sellerNo}" readonly></div>
		<div>판매자 닉네임 : <input type="text" value="${sellerNickName}" readonly></div>
		<div>상품명 : <input type="text" name="productName" required></div>
		<div>
			카테고리 :
			<select name="category">
				<option value="의류">의류</option>
				<option value="잡화">잡화</option>
				<option value="가구">가구</option>
				<option value="전자기기">전자기기</option>
				<option value="도서">도서</option>
				<option value="기타">기타</option>
			</select>
		</div>
		<div>가격 : <input type="number" name="price" required></div>
		<div>설명 : <textarea name="description" rows="5" cols="30"></textarea></div>
		<div>이미지 : <input type="file" name="imgFiles" multiple></div>
		<br>

		<button type="submit">등록</button>
		<a href="<c:url value='/productList'/>">취소</a>

	</form>
</body>
</html>