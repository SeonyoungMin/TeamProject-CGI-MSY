<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
</head>
<body>
	<h3>수정 하기</h3>
	<hr>

	<form action="<c:url value='/boardList/${board.boardNo}'/>" method="post">
		<input type="hidden" name="_method" value="PUT">
		<div>
			제목 : <input type="text" name="title" value="${board.title}" required>
		</div>
		<div>
			작성자 : <input type="text" value="${board.authorNickname}" readonly>
		</div>
		<div>
			내용 :
			<textarea name="content" rows="7" cols="40" required>${board.content}</textarea>
		</div>

		<c:if test="${isAdmin}">
			<div>
				<label>
					<input type="checkbox" name="pinned" value="true"
						${board.pinned ? 'checked' : ''}>
					상단 고정 (핀)
				</label>
			</div>
		</c:if>

		<button type="submit">수정</button>
		<a href="<c:url value='/boardList/${board.boardNo}'/>">취소</a>
	</form>
</body>
</html>
