<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기 - team404</title>
<style>
.register-container {
	width: 800px;
	margin: 60px auto;
	font-family: 'Pretendard', sans-serif;
}

.register-title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 30px;
	border-bottom: 2px solid #000;
	padding-bottom: 15px;
}

.form-group {
	margin-bottom: 25px;
}

.form-label {
	display: block;
	font-size: 14px;
	font-weight: 600;
	margin-bottom: 8px;
	color: #333;
}

.form-control {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
	box-sizing: border-box;
	outline: none;
	transition: border 0.2s;
}

.form-control:focus {
	border: 1px solid #000;
}

textarea.form-control {
	height: 300px;
	resize: none;
}

.file-upload {
	border: 2px dashed #ddd;
	padding: 40px;
	text-align: center;
	border-radius: 8px;
	cursor: pointer;
	color: #888;
	transition: 0.3s;
}

.file-upload:hover {
	background: #f9f9f9;
	border-color: #aaa;
}

.btn-area {
	display: flex;
	justify-content: center;
	gap: 15px;
	margin-top: 40px;
}

.btn {
	padding: 15px 40px;
	border-radius: 4px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
	text-decoration: none;
	border: none;
}

.btn-cancel {
	background: #f5f5f5;
	color: #666;
}

.btn-submit {
	background: #000;
	color: #fff;
}

/* 상품 전용 필드 (선택 시 보이기) */
.product-only {
	display: none;
	background: #fcfcfc;
	padding: 20px;
	border-radius: 8px;
	border: 1px solid #eee;
	margin-top: 10px;
}
</style>
</head>
<body>
	<jsp:include page="header.jsp" />

	<div class="register-container">
		<h2 class="register-title">새 글 쓰기</h2>

		<form action="${pageContext.request.contextPath}/product"
			method="post" enctype="multipart/form-data">

			<!-- 게시글 타입 선택 -->
			<div class="form-group">
				<label class="form-label">카테고리</label> <select name="boardType"
					class="form-control" id="typeSelect"
					onchange="toggleProductFields()">
					<option value="FREE">자유게시판</option>
					<option value="QNA">문의게시판</option>
					<option value="NOTICE">공지사항</option>
					<option value="PRODUCT" selected>중고거래 상품</option>
				</select>
			</div>

			<!-- 제목 -->
			<div class="form-group">
				<label class="form-label">제목</label> <input type="text" name="productNsame"
					class="form-control" placeholder="제목을 입력하세요" required>
			</div>

			<!-- 상품 전용 필드 (가격/카테고리) -->
			<div id="productFields" class="product-only" style="display: block;">
				<div style="display: flex; gap: 20px;">
					<div style="flex: 1;">
						<label class="form-label">가격</label> <input type="number"
							name="price" class="form-control" placeholder="숫자만 입력">
					</div>
					<div style="flex: 1;">
						<label class="form-label">거래 카테고리</label> <select name="category"
							class="form-control">
							<option value="의류">의류</option>
							<option value="가전">가전</option>
							<option value="잡화">잡화</option>
							<option value="디지털">디지털</option>
						</select>
					</div>
				</div>
			</div>

			<!-- 내용 -->
			<div class="form-group" style="margin-top: 25px;">
				<label class="form-label">상세 내용</label>
				<textarea name="description" class="form-control"
					placeholder="내용을 상세히 적어주세요."></textarea>
			</div>

			<!-- 이미지 업로드 -->
			<div class="form-group">
				<label class="form-label">사진 첨부</label>
				<div class="file-upload"
					onclick="document.getElementById('fileInput').click()">
					이미지를 클릭하거나 드래그하여 등록하세요 (최대 5장) <input type="file" id="fileInput"
						name="imgFiles" multiple style="display: none;"
						onchange="updateFileName(this)">
					<div id="fileNameDisplay"
						style="margin-top: 10px; font-size: 12px; color: #333;"></div>
				</div>
			</div>

			<div class="btn-area">
				<a href="javascript:history.back()" class="btn btn-cancel">취소</a>
				<button type="submit" class="btn btn-submit">등록하기</button>
			</div>
		</form>
	</div>

	<script>
		// 게시글 타입에 따라 상품 필드 숨기기/보여주기
		function toggleProductFields() {
			const type = document.getElementById('typeSelect').value;
			const productFields = document.getElementById('productFields');
			productFields.style.display = (type === 'PRODUCT') ? 'block'
					: 'none';
		}

		// 파일 선택 시 이름 표시
		function updateFileName(input) {
			const display = document.getElementById('fileNameDisplay');
			if (input.files.length > 0) {
				display.innerText = input.files.length + "개의 파일이 선택되었습니다.";
			}
		}
	</script>
</body>
</html>