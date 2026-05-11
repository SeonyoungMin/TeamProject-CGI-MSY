<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의글 상세 조회</title>
</head>
<body>
	<h3>문의글 상세</h3>
	<hr>
	<div>
		<p>${board.boardNo}|${board.title}</p>
		<p>${board.authorNickname}|${board.createdTime}</p>
		<p>${board.content}</p>
	</div>
	<%-- <c:if test="${board.authorNo == sessionScope.loginMemberNo}"> --%>
		<a href="<c:url value='/boardList/${board.boardNo}/edit'/>">수정</a>
		<form action="<c:url value='/boardList/${board.boardNo}'/>" method="post">
			<input type="hidden" name="_method" value="DELETE">
			<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
		</form>
	<%-- </c:if> --%>


</body>
</html>