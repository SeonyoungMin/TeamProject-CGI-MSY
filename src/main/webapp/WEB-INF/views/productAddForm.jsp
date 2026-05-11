<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="app-container" style="max-width:700px;">

	<h2 class="section-title">상품 등록</h2>

	<form class="card" action="${ctx}/product" method="post" enctype="multipart/form-data">

		<label class="form-label">판매자</label>
		<input type="text" class="form-input" value="${loginUser.userNickName}" readonly>

		<label class="form-label">상품명</label>
		<input type="text" class="form-input" name="productName" required>

		<label class="form-label">카테고리</label>
		<select class="form-input" name="category">
			<option value="의류">의류</option>
			<option value="잡화">잡화</option>
			<option value="가구">가구</option>
			<option value="전자기기">전자기기</option>
			<option value="도서">도서</option>
			<option value="기타">기타</option>
		</select>

		<label class="form-label">가격</label>
		<input type="number" class="form-input" name="price" required min="0">

		<label class="form-label">설명</label>
		<textarea class="form-input" name="description"></textarea>

		<label class="form-label">이미지</label>
		<input type="file" class="form-input" name="imgFiles" multiple>

		<div style="margin-top:20px; display:flex; gap:10px;">
			<button type="submit" class="btn btn-primary btn-block">등록</button>
			<a href="${ctx}/productList" class="btn btn-block">취소</a>
		</div>
	</form>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
