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

	<div class="app-container" style="max-width: 700px;">

		<h2 class="section-title">상품 수정</h2>

		<form class="card" action="${ctx}/product/${product.productNo}/edit"
			method="post" enctype="multipart/form-data">

			<label class="form-label">상품명</label> <input type="text"
				class="form-input" name="productName" value="${product.productName}"
				required> <label class="form-label">판매자 번호</label> <input
				type="text" class="form-input" name="sellerNo"ㄴ
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
				type="number" class="form-input" name=productNo
				value="${product.productNo}" required min="0"> <label
				class="form-label">설명</label>
			<textarea class="form-input" name="description">${product.description}</textarea>



			<label class="form-label">이미지 추가</label> <input type="file"
				class="form-input" name="imgFiles" multiple
				onchange="previewImages(this)">
			<div id="preview-container"
				style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px;"></div>

			<script>
				function previewImages(input) {
					const container = document
							.getElementById('preview-container');
					container.innerHTML = ''; // 기존 미리보기 초기화

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
							img.style.border = '1px solid #ddd';
							img.style.borderRadius = '4px';
							container.appendChild(img);
						}

						reader.readAsDataURL(file);
					}
				}
			</script>

			<div style="margin-top: 20px; display: flex; gap: 10px;">
				<button type="submit" class="btn btn-primary btn-block">수정
					완료</button>
				<a href="${ctx}/product/${product.productNo}" class="btn btn-block">취소</a>
			</div>

		</form>

		<!-- 등록된 이미지 목록 + 대표 지정 (수정 폼 밖에 두는 게 안전 — 별도 form) -->
		<c:if test="${not empty product.images}">
			<h3 class="section-title">등록된 이미지</h3>
			<div class="card" style="display: flex; gap: 15px; flex-wrap: wrap;">
				<c:forEach var="img" items="${product.images}">
					<div style="text-align: center;">
						<img src="${ctx}${img.filePath}"
							style="width: 120px; height: 120px; object-fit: cover; border: 1px solid #ddd; border-radius: 4px;">
						<div style="margin-top: 6px;">
							<c:if test="${img.thumbnail}">
								<span
									style="font-size: 12px; color: #121212; font-weight: bold;">★
									대표 이미지</span>
								<button type="button" onclick="alert('대표 이미지는 삭제할 수 없습니다.')">
									삭제</button>
							</c:if>
							<c:if test="${not img.thumbnail}">
								<form action="${ctx}/product/${product.productNo}/thumbnail"
									method="post" style="margin: 0;">
									<input type="hidden" name="imageNo" value="${img.imageNo}">
									<button type="submit" class="btn"
										style="font-size: 12px; padding: 4px 10px;">대표로 지정</button>
								</form>
								<form action="${ctx}/images/delete" method="post"
									style="margin: 0;">
									<input type="hidden" name="imageNo" value="${img.imageNo}">
									<input type="hidden" name="entityType" value="product">
									<input type="hidden" name="entityId"
										value="${product.productNo}">
									<button type="submit"
										onclick="return confirm('이미지를 삭제하시겠습니까?')">삭제</button>
								</form>
							</c:if>

						</div>
					</div>
				</c:forEach>
			</div>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
