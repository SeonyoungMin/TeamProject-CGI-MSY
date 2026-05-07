<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="app-container" style="max-width:700px;">

	<h2 class="section-title">상품 수정</h2>

	<form class="card" action="${ctx}/product/${product.productNo}/edit" method="post" enctype="multipart/form-data">

		<label class="form-label">상품명</label>
		<input type="text" class="form-input" name="productName" value="${product.productName}" required>

		<label class="form-label">카테고리</label>
		<select class="form-input" name="category">
			<option value="의류" ${product.category == '의류' ? 'selected' : ''}>의류</option>
			<option value="잡화" ${product.category == '잡화' ? 'selected' : ''}>잡화</option>
			<option value="가구" ${product.category == '가구' ? 'selected' : ''}>가구</option>
			<option value="전자기기" ${product.category == '전자기기' ? 'selected' : ''}>전자기기</option>
			<option value="도서" ${product.category == '도서' ? 'selected' : ''}>도서</option>
			<option value="기타" ${product.category == '기타' ? 'selected' : ''}>기타</option>
		</select>

		<label class="form-label">가격</label>
		<input type="number" class="form-input" name="price" value="${product.price}" required min="0">

		<label class="form-label">설명</label>
		<textarea class="form-input" name="description">${product.description}</textarea>

		<label class="form-label">현재 대표 이미지</label>
		<c:if test="${not empty product.imgPath}">
			<img src="${ctx}${product.imgPath}" style="width:120px; height:120px; object-fit:cover; border:1px solid #ddd; border-radius:4px;">
		</c:if>
		<c:if test="${empty product.imgPath}">
			<div style="color:#999;">등록된 이미지 없음</div>
		</c:if>

		<label class="form-label" style="margin-top:15px;">이미지 추가</label>
		<input type="file" class="form-input" name="imgFiles" multiple>

		<div style="margin-top:20px; display:flex; gap:10px;">
			<button type="submit" class="btn btn-primary btn-block">수정 완료</button>
			<a href="${ctx}/product/${product.productNo}" class="btn btn-block">취소</a>
		</div>
	</form>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
