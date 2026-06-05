<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productEditForm.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container is-productEditForm-1">

		<h2 class="section-title">상품 수정</h2>

		<!-- 상품 정보 수정 form -->
		<form class="card" id="editForm"
			action="${ctx}/product/${product.productNo}/edit" method="post"
			enctype="multipart/form-data">

			<label class="form-label">상품명</label> <input type="text"
				class="form-input" name="productName" value="${product.productName}"
				required> <label class="form-label">판매자 번호</label> <input
				type="text" class="form-input" name="sellerNo"
				value="${product.sellerNo}" required> <label
				class="form-label">카테고리</label> <select class="form-input"
				name="category">
				<option value="의류" ${product.category == '의류' ? 'selected' : ''}>의류</option>
				<option value="잡화" ${product.category == '잡화' ? 'selected' : ''}>잡화</option>
				<option value="가구" ${product.category == '가구' ? 'selected' : ''}>가구</option>
				<option value="전자기기" ${product.category == '전자기기' ? 'selected' : ''}>전자기기</option>
				<option value="도서" ${product.category == '도서' ? 'selected' : ''}>도서</option>
				<option value="기타" ${product.category == '기타' ? 'selected' : ''}>기타</option>
			</select> <label class="form-label">상품 상태</label> <select class="form-input"
				name="tradeStatus" required>
				<option value="판매중"
					${product.tradeStatus == '판매중' ? 'selected' : ''}>판매중</option>
				<option value="예약중"
					${product.tradeStatus == '예약중' ? 'selected' : ''}>예약중</option>
				<option value="완료" ${product.tradeStatus == '완료' ? 'selected' : ''}>판매완료</option>
			</select> <label class="form-label">가격</label> <input type="number"
				class="form-input" name="price" value="${product.price}" required
				min="0"> <label class="form-label">상품번호</label> <input
				type="number" class="form-input" name="productNo"
				value="${product.productNo}" required min="0"> <label
				class="form-label">설명</label>
			<textarea class="form-input" name="description">${product.description}</textarea>

		</form>

		<!-- 이미지 영역 (등록된 이미지 + 이미지 추가 합침) -->
		<div class="card">

			<!-- 등록된 이미지 목록 -->
			<c:if test="${not empty product.images}">
				<h3 class="section-title">등록된 이미지</h3>
				<div class="is-productEditForm-2">
					<c:forEach var="img" items="${product.images}">
						<div class="is-productEditForm-3">
							<img src="	${img.filePath}" class="is-productEditForm-4">
							<div class="is-productEditForm-5">

								<c:if test="${img.thumbnail}">
									<span class="is-productEditForm-6">★
										대표 이미지</span>
									<button type="button" class="btn is-productEditForm-7"
										onclick="alert('대표 이미지는 삭제할 수 없습니다.')">삭제</button>
								</c:if>

								<c:if test="${not img.thumbnail}">
									<form action="${ctx}/product/${product.productNo}/thumbnail"
										method="post" class="is-productEditForm-8">
										<input type="hidden" name="imageNo" value="${img.imageNo}">
										<button type="submit" class="btn is-productEditForm-9">대표로 지정</button>
									</form>
									<form id="deleteSection"
										action="${ctx}/images/delete#deleteSection" method="post" class="is-productEditForm-10">
										<input type="hidden" name="imageNo" value="${img.imageNo}">
										<input type="hidden" name="entityType" value="product">
										<input type="hidden" name="entityId"
											value="${product.productNo}">
										<button type="submit" class="btn btn-danger is-productEditForm-11"
											onclick="return confirm('이미지를 삭제하시겠습니까?')">삭제</button>
									</form>
								</c:if>

							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>

			<!-- 이미지 추가 form -->
			<hr class="is-productEditForm-12">
			<div id="imgSection"></div>
			<form
				action="${ctx}/product/${product.productNo}/addImage#imgSection"
				method="post" enctype="multipart/form-data">

				<div class="is-productEditForm-13">
					<label class="is-productEditForm-14">이미지 추가</label>
					<button type="submit" class="btn btn-primary">사진 추가</button>
				</div>

				<input type="file" class="form-input" name="imgFiles" multiple
					onchange="previewImages(this)">
				<div id="preview-container" class="is-productEditForm-15"></div>
			</form>

		</div>

		<!-- 수정 완료 / 취소 버튼 (맨 아래) -->
		<div class="is-productEditForm-16">
			<button type="button" class="btn btn-primary btn-block"
				onclick="document.getElementById('editForm').submit()">수정
				완료</button>
			<a href="${ctx}/product/${product.productNo}" class="btn btn-block">취소</a>
		</div>

	</div>

	<script>
		function previewImages(input) {
			const container = document.getElementById('preview-container');
			container.innerHTML = '';

			const files = input.files;
			for (let i = 0; i < files.length; i++) {
				const file = files[i];
				const reader = new FileReader();

				reader.onload = function(e) {
					const img = document.createElement('img');
					img.src = e.target.result;
					img.style.width = '120px';
					img.style.height = '120px';
					img.style.objectFit = 'cover';
					img.style.borderRadius = '4px';
					img.style.border = '1px solid #ddd';
					container.appendChild(img);
				}
				reader.readAsDataURL(file);
			}
		}
	</script>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>