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
	align-items: center;
}

.comment-form input[type="text"] {
	flex: 1;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.comment-form button[type="submit"] {
	padding: 10px 16px;
	border: none;
	background: #000;
	color: #fff;
	border-radius: 8px;
	cursor: pointer;
	white-space: nowrap;
}

.comment-item {
	padding: 12px 0;
	border-bottom: 1px solid #eee;
}

.reply-item {
	margin-left: 30px;
	padding-left: 12px;
	border-left: 3px solid #eee;
	background: #fafafa;
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

.reply-btn {
	background: none;
	border: none;
	color: #3498db;
	cursor: pointer;
	font-size: 12px;
	padding: 0;
}

.edit-btn {
	background: none;
	border: none;
	color: #888;
	cursor: pointer;
	font-size: 12px;
	padding: 0;
}

.reply-form, .comment-edit-form {
	display: none;
	margin-top: 10px;
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
<<<<<<< HEAD
		<div class="post-title">${board.title}</div>
=======
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

>>>>>>> branch 'main' of https://github.com/SeonyoungMin/TeamProject-JAC-CGI-MSY.git
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
		<div class="comment-section" id="commentSection">
			<div class="comment-title">댓글</div>
			<%-- 댓글 입력 폼 --%>
			<c:choose>
				<c:when test="${empty loginUser}">
					<div class="empty">
						<a href="${ctx}/login">로그인 후 댓글을 작성할 수 있습니다.</a>
					</div>
				</c:when>
				<c:otherwise>
					<form action="${ctx}/comment/add#commentSection" method="post">
						<input type="hidden" name="boardNo" value="${board.boardNo}">
						<input type="hidden" name="targetType" value="BOARD"> <input
							type="hidden" name="returnTo" value="board"> <input
<<<<<<< HEAD
							type="hidden" name="parentCommentNo" value="0"> <input
							type="text" name="content"
							style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; margin-bottom: 8px;"
							placeholder="댓글을 입력하세요" required>
						<div
							style="display: flex; justify-content: space-between; align-items: center;">
							<label style="font-size: 13px; color: #555; cursor: pointer;">
								<input type="checkbox" name="isSecret" value="1"> 비밀댓글
							</label>
							<button type="submit"
								style="padding: 10px 16px; border: none; background: #000; color: #fff; border-radius: 8px; cursor: pointer;">등록</button>
						</div>
=======
							type="text" name="content" placeholder="댓글을 입력하세요" required>

						<button type="submit">등록</button>
>>>>>>> branch 'main' of https://github.com/SeonyoungMin/TeamProject-JAC-CGI-MSY.git
					</form>
<<<<<<< HEAD
=======

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

>>>>>>> branch 'main' of https://github.com/SeonyoungMin/TeamProject-JAC-CGI-MSY.git
				</c:otherwise>
			</c:choose>
			<%-- 댓글 목록 --%>
			<c:choose>
				<c:when test="${empty comments}">
					<div class="empty">첫 댓글을 작성해보세요.</div>
				</c:when>
				<c:otherwise>
					<c:forEach var="c" items="${comments}">
						<div
							class="comment-item ${c.parentCommentNo > 0 ? 'reply-item' : ''}">

							<div class="comment-top">
								<div class="comment-author">
									<c:if test="${c.parentCommentNo > 0}">
										<span style="color: #aaa; margin-right: 4px;">↳</span>
									</c:if>
									<c:choose>
										<c:when test="${empty c.nickname}">익명</c:when>
										<c:otherwise>${c.nickname}</c:otherwise>
									</c:choose>
									<c:if test="${c.isSecret == 1}">
										<span style="font-size: 11px; color: #888; margin-left: 4px;">🔒
											비밀댓글</span>
									</c:if>
								</div>
								<div>${c.createdTime}</div>
							</div>

							<%-- 비밀댓글: 본인/게시글 작성자/관리자만 표시 --%>
							<c:choose>
								<c:when
									test="${c.isSecret == 1 && loginUser.userNo != c.authorNo && loginUser.userNo != board.authorNo && loginUser.userRole != 'ROLE_ADMIN'}">
									<div class="comment-content"
										style="color: #aaa; font-style: italic;">비밀 댓글입니다.</div>
								</c:when>
								<c:otherwise>
									<div class="comment-content">${c.content}</div>
								</c:otherwise>
							</c:choose>

							<%-- 수정 폼 --%>
							<c:if test="${c.authorNo == loginUser.userNo}">
								<div id="editForm_${c.commentNo}" class="comment-edit-form">
									<form
										action="${ctx}/comment/${c.commentNo}/edit#commentSection"
										method="post">
										<input type="hidden" name="boardNo" value="${board.boardNo}">
										<input type="hidden" name="returnTo" value="board"> <input
											type="text" name="content" value="${c.content}"
											style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-size: 13px;"
											required>
										<div
											style="display: flex; justify-content: flex-end; gap: 6px; margin-top: 6px;">
											<button type="button" class="edit-btn"
												style="padding: 8px 12px; background: #eee; color: #333; border-radius: 8px; font-size: 13px;"
												onclick="toggleEditForm(${c.commentNo})">취소</button>
											<button type="submit"
												style="padding: 8px 12px; background: #000; color: #fff; border: none; border-radius: 8px; cursor: pointer; font-size: 13px;">저장</button>
										</div>
									</form>
								</div>
							</c:if>

							<div class="comment-actions">
								<c:if
									test="${loginUser != null && (loginUser.userNo == c.authorNo || loginUser.userRole == 'ROLE_ADMIN')}">
									<c:if test="${loginUser.userNo == c.authorNo}">
										<button type="button" class="edit-btn"
											onclick="toggleEditForm(${c.commentNo})">수정</button>
									</c:if>
									<form
										action="${ctx}/comment/${c.commentNo}/delete#commentSection"
										method="post">
										<input type="hidden" name="boardNo" value="${board.boardNo}">
										<input type="hidden" name="returnTo" value="board">
										<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
									</form>
								</c:if>

								<%-- 답글 버튼: 원댓글에만 표시 --%>
								<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
									<button type="button" class="reply-btn"
										onclick="toggleReplyForm(${c.commentNo})">답글</button>
								</c:if>
							</div>

							<%-- 대댓글 입력 폼 --%>
							<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
								<div id="replyForm_${c.commentNo}" class="reply-form">
									<form action="${ctx}/comment/add#commentSection" method="post">
										<input type="hidden" name="boardNo" value="${board.boardNo}">
										<input type="hidden" name="targetType" value="BOARD">
										<input type="hidden" name="returnTo" value="board"> <input
											type="hidden" name="parentCommentNo" value="${c.commentNo}">
										<input type="text" name="content"
											style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-size: 13px;"
											placeholder="답글을 입력하세요" required>
										<div
											style="display: flex; justify-content: space-between; align-items: center; margin-top: 6px;">
											<label style="font-size: 12px; color: #555; cursor: pointer;">
												<input type="checkbox" name="isSecret" value="1">
												비밀답글
											</label>
											<button type="submit"
												style="padding: 8px 12px; background: #000; color: #fff; border: none; border-radius: 8px; cursor: pointer; font-size: 13px;">등록</button>
										</div>
									</form>
								</div>
							</c:if>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>

<<<<<<< HEAD

=======
>>>>>>> branch 'main' of https://github.com/SeonyoungMin/TeamProject-JAC-CGI-MSY.git
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
		function toggleReplyForm(commentNo) {
			var formEl = document.getElementById('replyForm_' + commentNo);
			formEl.style.display = formEl.style.display === 'none' ? 'block' : 'none';
			if (formEl.style.display === 'block') {
				formEl.querySelector('input[name="content"]').focus();
			}
		}

		function toggleEditForm(commentNo) {
			var formEl = document.getElementById('editForm_' + commentNo);
			formEl.style.display = formEl.style.display === 'none' ? 'block' : 'none';
			if (formEl.style.display === 'block') {
				formEl.querySelector('input[name="content"]').focus();
			}
		}
	</script>
</body>
</html>
