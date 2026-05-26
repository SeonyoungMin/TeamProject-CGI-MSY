<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f6f7f9;
}

.container {
	max-width: 900px;
	margin: 40px auto;
	background: #fff;
	padding: 30px;
	border-radius: 12px;
}

/* 게시글 */
.post-title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 10px;
}

.post-meta {
	color: #888;
	font-size: 13px;
	margin-bottom: 20px;
	display: flex;
	justify-content: space-between;
}

.post-content {
	line-height: 1.7;
	white-space: pre-wrap;
	padding: 20px 0;
	border-top: 1px solid #eee;
	border-bottom: 1px solid #eee;
}

/* 댓글 */
.comment-section {
	margin-top: 40px;
}

.comment-title {
	font-size: 18px;
	font-weight: bold;
	margin-bottom: 15px;
}

.comment-form {
	display: flex;
	gap: 10px;
	margin-bottom: 20px;
}

.comment-form input {
	flex: 1;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.comment-form button {
	padding: 10px 16px;
	border: none;
	background: #000;
	color: #fff;
	border-radius: 8px;
	cursor: pointer;
}

.comment-item {
	padding: 12px 0;
	border-bottom: 1px solid #eee;
}

.comment-top {
	display: flex;
	justify-content: space-between;
	font-size: 12px;
	color: #777;
	margin-bottom: 5px;
}

.comment-author {
	font-weight: bold;
	color: #333;
}

.comment-content {
	font-size: 14px;
	color: #222;
}

.comment-actions {
	margin-top: 6px;
	font-size: 12px;
	display: flex;
	gap: 10px;
	align-items: center;
}

.comment-actions form {
	margin: 0;
}

.comment-actions button {
	background: none;
	border: none;
	color: red;
	cursor: pointer;
	font-size: 12px;
	padding: 0;
}

.comment-actions a {
	color: #333;
	text-decoration: none;
	font-size: 12px;
}

.comment-actions a:hover {
	text-decoration: underline;
}

.empty {
	color: #999;
	padding: 20px 0;
	text-align: center;
}
</style>
</head>

<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<!-- 뒤로가기 / 홈 -->

		<a href="${ctx}/home">< 메인으로 </a> <br> <br>

		<!-- 게시글 -->
		<c:set var="isAdmin"
			value="${loginUser != null && loginUser.userRole == 'ROLE_ADMIN'}" />
		<c:set var="isAuthor"
			value="${loginUser != null && loginUser.userNo == board.authorNo}" />
		<c:set var="isNotice" value="${board.boardType == 'notice'}" />

		<c:set var="canEdit" value="${isNotice ? isAdmin : isAuthor}" />
		<c:set var="canDelete"
			value="${isNotice ? isAdmin : (isAuthor || isAdmin)}" />

		<div class="post-title">

			<c:if test="${isNotice && board.pinned}">
				<i class="fa-solid fa-thumbtack"
					style="color: #c0392b; margin-right: 6px;"></i>
			</c:if>
			<c:if test="${isNotice}">
				<span
					style="background: #fdecec; color: #c0392b; font-size: 12px; padding: 2px 6px; border-radius: 3px; margin-right: 6px; font-weight: 600; vertical-align: middle;">공지</span>
			</c:if>
			${board.title}
		</div>

		<div class="post-meta">
			<div>${board.authorNickname}</div>
			<div>${board.createdTime}</div>
		</div>

		<div class="post-content">${board.content}</div>

		<c:if test="${canEdit || canDelete}">
			<div class="comment-actions">
				<c:if test="${canEdit}">
					<a href="${ctx}/boardList/${board.boardNo}/edit" class="btn">수정</a>
				</c:if>
				<c:if test="${canDelete}">
					<form action="${ctx}/boardList/${board.boardNo}" method="post"
						style="display: inline;">
						<input type="hidden" name="_method" value="DELETE">
						<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
					</form>
				</c:if>
			</div>
		</c:if>
		<!-- 댓글 -->
		<div class="comment-section">

			<div class="comment-title">댓글</div>

			<c:choose>

				<c:when test="${empty loginUser}">
					<div class="empty">
						<a href="${ctx}/login">로그인 후 댓글을 작성할 수 있습니다.</a>
					</div>
				</c:when>

				<c:otherwise>

					<!-- 댓글 입력 -->
					<form class="comment-form" action="${ctx}/comment/add"
						method="post">
						<input type="hidden" name="boardNo" value="${board.boardNo}">
						<input type="hidden" name="targetType" value="BOARD"> <input
							type="hidden" name="returnTo" value="board"> <input
							type="text" name="content" placeholder="댓글을 입력하세요" required>

						<button type="submit">등록</button>
					</form>

					<!-- 댓글 리스트 -->
					<c:choose>

						<c:when test="${empty comments}">
							<div class="empty">첫 댓글을 작성해보세요.</div>
						</c:when>

						<c:otherwise>

							<c:forEach var="c" items="${comments}">

								<div class="comment-item">

									<div class="comment-top">
										<div class="comment-author">
											<c:choose>
												<c:when test="${empty c.nickname}">익명</c:when>
												<c:otherwise>${c.nickname}</c:otherwise>
											</c:choose>
										</div>

										<div>${c.createdTime}</div>
									</div>

									<div class="comment-content">${c.content}</div>

									<c:if
										test="${loginUser != null 
    && (loginUser.userNo == c.authorNo 
        || loginUser.userRole == 'ROLE_ADMIN')}">

										<div class="comment-actions">

											<!-- 작성자만 수정 -->
											<c:if test="${loginUser.userNo == c.authorNo}">
												<a href="${ctx}/comment/${c.commentNo}/edit?returnTo=board">수정</a>
											</c:if>

											<!-- 작성자 or 관리자 삭제 -->
											<form action="${ctx}/comment/${c.commentNo}/delete"
												method="post">
												<input type="hidden" name="boardNo" value="${board.boardNo}">
												<input type="hidden" name="targetType" value="BOARD">
												<input type="hidden" name="returnTo" value="board">

												<button type="submit" onclick="return confirm('삭제하시겠습니까?')">
													삭제</button>
											</form>

										</div>
									</c:if>
								</div>

							</c:forEach>

						</c:otherwise>

					</c:choose>

				</c:otherwise>

			</c:choose>

		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>