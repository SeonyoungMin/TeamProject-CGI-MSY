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

	<a href="<c:url value='/boardList/${board.boardNo}/edit'/>">수정</a>
	<form action="<c:url value='/boardList/${board.boardNo}'/>"
		method="post">
		<input type="hidden" name="_method" value="DELETE">
		<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
	</form>


	<hr>
	<h4>댓글</h4>

	<c:choose>
		<c:when test="${empty loginUser}">
			<p>
				<a href="<c:url value='/login'/>">댓글을 작성하려면 로그인이 필요합니다.</a>
			</p>
		</c:when>
		<c:otherwise>
			<form action="<c:url value='/comment/add'/>" method="post">
				<input type="hidden" name="boardNo" value="${board.boardNo}">
				<input type="hidden" name="returnTo" value="board"> <input
					type="text" name="content" placeholder="댓글을 입력하세요" required>
				<button type="submit">등록</button>
			</form>

			<c:choose>
				<c:when test="${empty comments}">
					<p>아직 댓글이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="c" items="${comments}">
						<div>
							<b><c:choose>
									<c:when test="${empty c.nickname}">익명</c:when>
									<c:otherwise>${c.nickname}</c:otherwise>
								</c:choose></b> | ${c.createdTime}
							<div>${c.content}</div>
							<c:if
								test="${c.authorNo == loginUser.userNo || loginUser.userRole == 'ROLE_ADMIN'}">
								<form action="<c:url value='/comment/${c.commentNo}/delete'/>"
									method="post" style="display: inline;">
									<input type="hidden" name="boardNo" value="${board.boardNo}">
									<input type="hidden" name="returnTo" value="board">
									<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
								</form>
							</c:if>
						</div>
						<hr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>

</body>
</html>