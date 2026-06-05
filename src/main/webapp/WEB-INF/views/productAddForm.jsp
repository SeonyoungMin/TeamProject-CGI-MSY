<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productAddForm.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container is-productAddForm-1">

		<h2 class="section-title">상품 등록</h2>

		<form class="card" action="${ctx}/product" method="post"
			enctype="multipart/form-data">

			<label class="form-label">판매자</label> <input type="text"
				class="form-input" value="${loginUser.userNickName}" readonly>

			<label class="form-label">상품명</label> <input type="text"
				class="form-input" name="productName" required> <label
				class="form-label">카테고리</label> <select class="form-input"
				name="category">
				<option value="의류">의류</option>
				<option value="잡화">잡화</option>
				<option value="가구">가구</option>
				<option value="전자기기">전자기기</option>
				<option value="도서">도서</option>
				<option value="기타">기타</option>
			</select> <label class="form-label">가격</label> <input type="number"
				class="form-input" name="price" required min="0"> <label
				class="form-label">설명</label>
			<textarea class="form-input" name="description"></textarea>
			<label class="form-label">상품 사진 (최소 1장 필수, 다양한 방향의 사진을 권장합니다)</label>
			<input type="file" class="form-input" name="imgFiles"
				id="productImages" multiple accept="image/*"
				onchange="previewAddImages(this)" required>

			<div id="image-preview-container" class="is-productAddForm-2"></div>

			<div class="is-productAddForm-3">
				<button type="submit" class="btn btn-primary btn-block">등록</button>
				<a href="${ctx}/productList" class="btn btn-block">취소</a>
			</div>
		</form>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
		function previewAddImages(input) {
			const container = document
					.getElementById('image-preview-container');
			container.innerHTML = '';
			const files = input.files;

			for (let i = 0; i < files.length; i++) {
				const file = files[i];
				const reader = new FileReader();
				reader.onload = function(e) {
					const img = document.createElement('img');
					img.src = e.target.result;
					img.style.width = '100px';
					img.style.height = '100px';
					img.style.objectFit = 'cover';
					img.style.borderRadius = '4px';
					img.style.border = '1px solid #ddd';
					container.appendChild(img);
				}
				reader.readAsDataURL(file);
			}
		}

		document.querySelector('form').addEventListener('submit', function(e) {
			const input = document.getElementById('productImages');
			if (!input.files || input.files.length === 0) {
				alert('최소 1장 이상의 상품 사진을 업로드하셔야 등록이 가능합니다.');
				e.preventDefault();
			}
		});
	</script>
</body>
</html>
