<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>

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

		<h3>게시글 수정</h3>

		<form action="<c:url value='/boardList/${board.boardNo}'/>"
			method="post">

			<input type="hidden" name="_method" value="PUT">

			<div class="form-card">

				<div class="form-group">
					<label>게시판 구분</label> <select name="boardType" required>

						<c:if test="${isAdmin}">
							<option value="notice"
								${board.boardType == 'notice' ? 'selected' : ''}>공지사항</option>
						</c:if>

						<option value="inquiry"
							${board.boardType == 'inquiry' ? 'selected' : ''}>문의</option>

						<option value="free"
							${board.boardType == 'free' ? 'selected' : ''}>자유</option>

					</select>
				</div>

				<div class="form-group">
					<label>제목</label> <input type="text" name="title"
						value="${board.title}" required>
				</div>

				<div class="form-group">
					<label>작성자</label> <input type="text"
						value="${board.authorNickname}" readonly class="readonly-input">
				</div>

				<div class="form-group">
					<label>내용</label>
					<textarea name="content" rows="8" required>${board.content}</textarea>
				</div>

				<c:if test="${isAdmin}">
					<div class="form-group">
						<label> <input type="checkbox" name="pinned" value="true"
							${board.pinned ? 'checked' : ''}> 상단 고정
						</label>
					</div>
				</c:if>

				<div class="btn-group">
					<button type="submit">수정 완료</button>

					<a class="cancel-btn"
						href="<c:url value='/boardList/${board.boardNo}'/>"> 취소 </a>
				</div>

			</div>

		</form>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>