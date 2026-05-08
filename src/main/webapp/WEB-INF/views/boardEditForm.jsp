<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의글 수정</title>
</head>
<body>
	<h3>수정 하기</h3>
	<hr>

	<form action="<c:url value='/boardList/${board.boardNo}'/>" method="post">
	<input type="hidden" name="_method" value="PUT">
		<div>
			제목 : <input type="text" name="title" value="${board.title}" required>${board.title}
		</div>
		<div>
			작성자 : <input type="text" value="${board.authorNickname}" readonly>
		</div>
		<div>
			문의내용 :
			<textarea name="content" rows="7" cols="40" required>${board.content}</textarea>
		</div>
		<button type="submit">수정</button>
		<a href="<c:url value='/boardList/${board.boardNo}'/>">취소</a>
	</form>
</body>
</html>