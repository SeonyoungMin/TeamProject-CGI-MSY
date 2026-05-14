<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의글 상세 조회</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f8f9fa;
}

.container {
	max-width: 900px;
	margin: 40px auto;
	padding: 30px;
	background: white;
	border-radius: 12px;
}

h3, h4 {
	text-align: center;
	margin-bottom: 20px;
}

.card {
	padding: 25px;
	border: 1px solid #eee;
	border-radius: 12px;
	background: #fff;
	margin-bottom: 25px;
}

.meta {
	color: #777;
	font-size: 14px;
	margin-bottom: 15px;
}

.content {
	line-height: 1.7;
	color: #333;
	white-space: pre-wrap;
}

.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

button, .btn {
	padding: 10px 18px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	text-decoration: none;
	font-size: 14px;
	background: black;
	color: white;
}

button:hover, .btn:hover {
	background: #333;
}

.delete-btn {
	background: #eee;
	color: #333;
}

.delete-btn:hover {
	background: #ddd;
}

.comment-form {
	display: flex;
	gap: 10px;
	margin-bottom: 20px;
}

.comment-form input[type=text] {
	flex: 1;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.comment-card {
	padding: 18px;
	border: 1px solid #eee;
	border-radius: 10px;
	background: #fafafa;
	margin-bottom: 15px;
}

.comment-top {
	display: flex;
	justify-content: space-between;
	font-size: 13px;
	color: #777;
	margin-bottom: 10px;
}

.empty {
	text-align: center;
	color: #999;
	padding: 25px;
}
</style>

</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<a class="cancel-btn" href="<c:url value='/board/all'/>"> ← 목록 </a>
		<h3>게시글 상세</h3>

		<div class="card">

			<div class="meta">
				<c:choose>
					<c:when test="${board.boardType == 'notice'}">
						<b>[공지]</b>
					</c:when>
					<c:when test="${board.boardType == 'free'}">
						<b>[자유]</b>
					</c:when>
					<c:otherwise>
						<b>[문의]</b>
					</c:otherwise>
				</c:choose>

				${board.boardNo}
			</div>

			<h2>${board.title}</h2>

			<div class="meta">${board.authorNickname}|${board.createdTime}</div>

			<div class="content">${board.content}</div>

			<div class="btn-group">
				<a class="btn"
					href="<c:url value='/boardList/${board.boardNo}/edit'/>">수정</a>

				<form action="<c:url value='/boardList/${board.boardNo}'/>"
					method="post" style="display: inline;">
					<input type="hidden" name="_method" value="DELETE">
					<button type="submit" class="delete-btn"
						onclick="return confirm('삭제하시겠습니까?')">삭제</button>
				</form>
			</div>

		</div>


		<h4>댓글</h4>

		<c:choose>

			<c:when test="${empty loginUser}">
				<div class="empty">
					<a href="<c:url value='/login'/>">댓글을 작성하려면 로그인이 필요합니다.</a>
				</div>
			</c:when>

			<c:otherwise>

				<form class="comment-form" action="<c:url value='/comment/add'/>"
					method="post">

					<input type="hidden" name="boardNo" value="${board.boardNo}">
					<input type="hidden" name="returnTo" value="board"> <input
						type="text" name="content" placeholder="댓글을 입력하세요" required>

					<button type="submit">등록</button>
				</form>

				<c:choose>

					<c:when test="${empty comments}">
						<div class="empty">아직 댓글이 없습니다.</div>
					</c:when>

					<c:otherwise>

						<c:forEach var="c" items="${comments}">
							<div class="comment-card">

								<div class="comment-top">
									<div>
										<b> <c:choose>
												<c:when test="${empty c.nickname}">익명</c:when>
												<c:otherwise>${c.nickname}</c:otherwise>
											</c:choose>
										</b>
									</div>

									<div>${c.createdTime}</div>
								</div>

								<div>${c.content}</div>

								<c:if
									test="${c.authorNo == loginUser.userNo || loginUser.userRole == 'ROLE_ADMIN'}">

									<form action="<c:url value='/comment/${c.commentNo}/delete'/>"
										method="post" style="margin-top: 12px;">

										<input type="hidden" name="boardNo" value="${board.boardNo}">
										<input type="hidden" name="returnTo" value="board">

										<button type="submit" class="delete-btn"
											onclick="return confirm('삭제하시겠습니까?')">삭제</button>
									</form>

								</c:if>

							</div>
						</c:forEach>

					</c:otherwise>

				</c:choose>

			</c:otherwise>

		</c:choose>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>