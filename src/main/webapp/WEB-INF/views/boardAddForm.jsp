<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="title" value="${empty boardTitle ? '문의 게시판' : boardTitle}" />
<c:set var="type" value="${empty boardType ? 'inquiry' : boardType}" />
<c:set var="cancel"
	value="${empty cancelUrl ? '/boardList' : cancelUrl}" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${title}등록</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f8f9fa;
}

.container {
	max-width: 800px;
	margin: 40px auto;
	padding: 30px;
	background: white;
	border-radius: 12px;
}

h3 {
	text-align: center;
	margin-bottom: 25px;
}

.form-card {
	padding: 25px;
	border: 1px solid #eee;
	border-radius: 10px;
	background: #fafafa;
}

.form-group {
	margin-bottom: 20px;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 8px;
}

input[type=text], select, textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 14px;
}

textarea {
	resize: none;
}

.readonly-input {
	background: #f5f5f5;
}

.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 25px;
}

button, .cancel-btn {
	padding: 12px 20px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	text-decoration: none;
	font-size: 14px;
}

button {
	background: black;
	color: white;
}

button:hover {
	background: #333;
}

.cancel-btn {
	background: #eee;
	color: #333;
}

.cancel-btn:hover {
	background: #ddd;
}
</style>

</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<a class="cancel-btn" href="<c:url value='/board/all'/>"> ← 목록 </a>

		<h3>게시글 쓰기</h3>

		<form action="<c:url value='/board/type'/>" method="post">

			<div class="form-card">

				<input type="hidden" name="authorNo" value="${authorNo}">

				<c:choose>
					<c:when test="${typeChoice}">
						<div class="form-group">
							<label>게시판</label> <select name="boardType" required>
								<c:if test="${isAdmin}">
									<option value="notice">공지사항</option>
								</c:if>
								<option value="inquiry" selected>문의</option>
								<option value="free">자유</option>
							</select>
						</div>
					</c:when>
					<c:otherwise>
						<input type="hidden" name="boardType" value="${type}">
					</c:otherwise>
				</c:choose>

				<div class="form-group">
					<label>제목</label> <input type="text" name="title" required>
				</div>

				<div class="form-group">
					<label>작성자</label> <input type="text" value="${authorNickname}"
						readonly class="readonly-input">
				</div>

				<div class="form-group">
					<label>내용</label>
					<textarea name="content" rows="8" required></textarea>
				</div>

				<c:if test="${isAdmin}">
					<div class="form-group">
						<label> <input type="checkbox" name="pinned" value="true">
							상단 고정
						</label>
					</div>
				</c:if>

				<div class="btn-group">
					<button type="submit">등록</button>
					<a class="cancel-btn" href="<c:url value='${cancel}'/>">취소</a>
				</div>

			</div>

		</form>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>