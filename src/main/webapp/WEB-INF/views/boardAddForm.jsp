<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의글 등록</title>
</head>
<body>
	<h3>문의 하기</h3>
	<hr>
	<form action="<c:url value='/board'/>" method="post">
		<input type="hidden" name="authorNo" value="${authorNo}">
		<div>
			제목 : <input type="text" name="title" required>
		</div>
		<div>
			작성자 : <input type="text" value="${authorNickname}" readonly>
		</div>
		<div>
			문의내용 :
			<textarea name="content" rows="7" cols="40" required></textarea>
		</div>
		<button type="submit">등록</button>
		<a href="/boardList">취소</a>
	</form>
</body>
</html>