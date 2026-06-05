<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boardDetail.css">
</head>

<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<div class="is-boardDetail-1">
			<a href="${ctx}/home">< 메인으로 </a>
			<%-- 신고 버튼 (본인 게시글 제외) --%>
			<c:if
				test="${not empty loginUser && loginUser.userNo != board.authorNo}">
				<button type="button" class="btn btn-danger"
					onclick="openReportModal('board', ${board.boardNo})">신고</button>
			</c:if>
		</div>
		<%-- 공지 관련 권한 변수 --%>
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
				<span class="is-boardDetail-2">공지</span>
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
					<form action="${ctx}/boardList/${board.boardNo}" method="post" class="is-boardDetail-3">
						<input type="hidden" name="_method" value="DELETE">
						<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
					</form>
				</c:if>
			</div>
		</c:if>

		<%-- 댓글 섹션 --%>
		<div class="comment-section" id="commentSection">
			<div class="comment-title">댓글</div>

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
							type="hidden" name="parentCommentNo" value="0"> <input
							type="text" name="content"
							placeholder="댓글을 입력하세요" required class="is-boardDetail-4">
						<div class="is-boardDetail-5">
							<label class="is-boardDetail-6">
								<input type="checkbox" name="isSecret" value="1"> 비밀댓글
							</label>
							<button type="submit" class="is-boardDetail-7">등록</button>
						</div>
					</form>
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
										<span class="is-boardDetail-8">↳</span>
									</c:if>
									<c:choose>
										<c:when test="${empty c.nickname}">익명</c:when>
										<c:otherwise>${c.nickname}</c:otherwise>
									</c:choose>
									<c:if test="${c.isSecret == 1}">
										<span class="is-boardDetail-9">🔒
											비밀댓글</span>
									</c:if>
								</div>
								<div>${c.createdTime}</div>
							</div>

							<c:choose>
								<c:when
									test="${c.isSecret == 1 && loginUser.userNo != c.authorNo && loginUser.userNo != board.authorNo && loginUser.userRole != 'ROLE_ADMIN'}">
									<div class="comment-content is-boardDetail-10">비밀 댓글입니다.</div>
								</c:when>
								<c:otherwise>
									<div class="comment-content">${c.content}</div>
								</c:otherwise>
							</c:choose>

							<c:if test="${c.authorNo == loginUser.userNo}">
								<div id="editForm_${c.commentNo}" class="comment-edit-form">
									<form
										action="${ctx}/comment/${c.commentNo}/edit#commentSection"
										method="post">
										<input type="hidden" name="boardNo" value="${board.boardNo}">
										<input type="hidden" name="returnTo" value="board"> <input
											type="text" name="content" value="${c.content}"
											required class="is-boardDetail-11">
										<div class="is-boardDetail-12">
											<button type="button" class="edit-btn is-boardDetail-13"
												onclick="toggleEditForm(${c.commentNo})">취소</button>
											<button type="submit" class="is-boardDetail-14">저장</button>
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

								<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
									<button type="button" class="reply-btn"
										onclick="toggleReplyForm(${c.commentNo})">답글</button>
								</c:if>
							</div>

							<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
								<div id="replyForm_${c.commentNo}" class="reply-form">
									<form action="${ctx}/comment/add#commentSection" method="post">
										<input type="hidden" name="boardNo" value="${board.boardNo}">
										<input type="hidden" name="targetType" value="BOARD">
										<input type="hidden" name="returnTo" value="board"> <input
											type="hidden" name="parentCommentNo" value="${c.commentNo}">
										<input type="text" name="content"
											placeholder="답글을 입력하세요" required class="is-boardDetail-15">
										<div class="is-boardDetail-16">
											<label class="is-boardDetail-17">
												<input type="checkbox" name="isSecret" value="1">
												비밀답글
											</label>
											<button type="submit" class="is-boardDetail-18">등록</button>
										</div>
									</form>
								</div>
							</c:if>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
	<%@ include file="/WEB-INF/views/reportModal.jsp"%>

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