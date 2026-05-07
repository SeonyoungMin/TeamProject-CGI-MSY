<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정 - team404</title>
<style>
body {
	font-family: 'Pretendard', sans-serif;
	padding: 40px;
	line-height: 1.6;
}

.update-container {
	width: 700px;
	margin: 0 auto;
	border: 1px solid #eee;
	padding: 30px;
	border-radius: 10px;
}

h1 {
	border-bottom: 2px solid #000;
	padding-bottom: 15px;
	font-size: 24px;
}

.form-group {
	margin-bottom: 20px;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 8px;
	font-size: 14px;
}

.form-control {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

/* 이미지 영역 스타일 */
.image-section {
	background: #f9f9f9;
	padding: 20px;
	border-radius: 8px;
	margin: 20px 0;
}

.current-img-box {
	margin-bottom: 15px;
}

/* 미리보기 그리드 */
.preview-container {
	display: flex;
	gap: 10px;
	margin-top: 15px;
	flex-wrap: wrap;
}

.preview-box {
	position: relative;
	width: 120px;
	height: 120px;
	border: 2px solid #eee;
	border-radius: 6px;
	overflow: hidden;
	cursor: pointer;
	background: #fff;
}

.preview-box.active {
	border-color: #000;
	box-shadow: 0 0 8px rgba(0, 0, 0, 0.2);
}

.preview-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.thumb-label {
	position: absolute;
	top: 5px;
	left: 5px;
	background: #000;
	color: #fff;
	font-size: 10px;
	padding: 2px 6px;
	border-radius: 3px;
	display: none;
}

.preview-box.active .thumb-label {
	display: block;
}

.btn-area {
	margin-top: 30px;
	display: flex;
	gap: 10px;
}

button {
	padding: 12px 25px;
	border-radius: 4px;
	border: none;
	cursor: pointer;
	font-weight: bold;
}

.btn-submit {
	background: #000;
	color: #fff;
}

.btn-cancel {
	background: #eee;
	color: #333;
	text-decoration: none;
	display: inline-block;
	padding: 12px 25px;
	text-align: center;
}
</style>
</head>
<body>
	<jsp:include page="header.jsp" />

	<div class="update-container">
		<h1>상품 정보 수정</h1>

		<form action="${ctx}/product/${update.productNo}" method="post"
			enctype="multipart/form-data">
			<input type="hidden" name="_method" value="PUT">
			<!-- 썸네일 인덱스 저장 (기본값 0) -->
			<input type="hidden" id="thumbnailIdx" name="thumbnailIdx" value="0">

			<div class="form-group">
				<label>상품명</label> <input type="text" name="name"
					class="form-control" value="${update.productName}" required>
			</div>

			<div class="form-group">
				<label>카테고리</label> <select name="category" class="form-control">
					<option value="전자기기"
						<c:if test="${update.category == '전자기기'}">selected</c:if>>전자기기</option>
					<option value="의류"
						<c:if test="${update.category == '의류'}">selected</c:if>>의류</option>
					<option value="가구"
						<c:if test="${update.category == '가구'}">selected</c:if>>가구</option>
					<option value="도서"
						<c:if test="${update.category == '도서'}">selected</c:if>>도서</option>
					<option value="기타"
						<c:if test="${update.category == '기타'}">selected</c:if>>기타</option>
				</select>
			</div>

			<div class="form-group">
				<label>가격 (원)</label> <input type="number" name="price"
					class="form-control" value="${update.price}" required>
			</div>

			<div class="form-group">
				<label>상품 설명</label>
				<textarea name="description" class="form-control" rows="8">${update.description}</textarea>
			</div>

			<div class="image-section">
				<div class="current-img-box">
					<label>현재 대표 이미지</label>
					<c:choose>
						<c:when test="${not empty update.imgPath}">
							<img src="${ctx}${update.imgPath}" width="120" height="120"
								style="object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">
						</c:when>
						<c:otherwise>
							<span style="color: #999;">등록된 이미지가 없습니다.</span>
						</c:otherwise>
					</c:choose>
				</div>

				<div class="form-group">
					<label>새 이미지 업로드 (최대 5장)</label> <input type="file" name="imgFiles"
						id="fileInput" class="form-control" multiple
						onchange="previewImages(this)">
					<p style="font-size: 12px; color: #666; margin-top: 5px;">* 사진을
						클릭하여 **대표 이미지**를 변경할 수 있습니다.</p>

					<div id="imagePreviewContainer" class="preview-container">
						<!-- 새 이미지 미리보기가 여기에 생성됩니다 -->
					</div>
				</div>
			</div>

			<div class="btn-area">
				<button type="submit" class="btn-submit">수정 완료</button>
				<a href="${ctx}/product/${update.productNo}" class="btn-cancel">취소</a>
			</div>
		</form>
	</div>

	<script>
        // 이미지 미리보기 및 썸네일 선택 로직
        function previewImages(input) {
            const container = document.getElementById('imagePreviewContainer');
            container.innerHTML = ""; // 기존 미리보기 초기화
            document.getElementById('thumbnailIdx').value = 0; // 인덱스 초기화
            
            if (input.files) {
                Array.from(input.files).forEach((file, index) => {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const div = document.createElement('div');
                        div.className = 'preview-box' + (index === 0 ? ' active' : '');
                        div.onclick = function() { selectThumbnail(index, this); };
                        
                        div.innerHTML = `
                            <img src="\${e.target.result}" class="preview-img">
                            <span class="thumb-label">대표</span>
                        `;
                        container.appendChild(div);
                    }
                    reader.readAsDataURL(file);
                });
            }
        }

        // 클릭 시 대표 이미지(인덱스) 변경
        function selectThumbnail(index, element) {
            document.querySelectorAll('.preview-box').forEach(box => box.classList.remove('active'));
            element.classList.add('active');
            document.getElementById('thumbnailIdx').value = index;
            console.log("선택된 대표 이미지 인덱스: " + index);
        }
    </script>
</body>
</html>