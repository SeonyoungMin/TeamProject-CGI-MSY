<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 수정</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<c:set var="cancelUrl"
	value="${returnTo == 'board' ? ctx.concat('/boardList/').concat(comment.boardNo) : ctx.concat('/product/').concat(comment.boardNo)}" />

<div class="app-container" style="max-width:600px;">
	<h2 class="section-title">댓글 수정</h2>

	<form class="card" action="${ctx}/comment/${comment.commentNo}/edit" method="post">
		<input type="hidden" name="boardNo" value="${comment.boardNo}">
		<input type="hidden" name="returnTo" value="${returnTo}">

		<label class="form-label">내용</label>
		<textarea class="form-input" name="content" required>${comment.content}</textarea>

		<div style="display:flex; gap:10px;">
			<button type="submit" class="btn btn-primary btn-block">수정 완료</button>
			<a href="${cancelUrl}" class="btn btn-block">취소</a>
		</div>
	</form>
</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
