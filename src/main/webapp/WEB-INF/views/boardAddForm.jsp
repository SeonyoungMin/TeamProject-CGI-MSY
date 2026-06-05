<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="title" value="${empty boardTitle ? '문의 게시판' : boardTitle}" />
<c:set var="type" value="${empty boardType ? 'inquiry' : boardType}" />
<c:set var="cancel"
	value="${empty cancelUrl ? '/boardList' : cancelUrl}" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${title}등록</title>


<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boardAddForm.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<a class="cancel-btn" href="<c:url value='/board/all'/>"> ← 목록 </a>

		<h3>게시글 쓰기</h3>

		<form action="<c:url value='/board/type'/>" method="post">

			<div class="form-card">

				<input type="hidden" name="authorNo" value="${authorNo}">

				<c:choose>
					<c:when test="${typeChoice}">
						<div class="form-group">
							<label>게시판</label> <select name="boardType" id="boardTypeSelect"
								required>
								<c:if test="${isAdmin}">
									<option value="notice">공지사항</option>
								</c:if>
								<option value="inquiry" selected>문의</option>
								<option value="free">자유</option>
							</select>
						</div>
					</c:when>
					<c:otherwise>
						<input type="hidden" name="boardType" id="boardTypeSelect"
							value="${type}">
					</c:otherwise>
				</c:choose>

				<div class="form-group">
					<label>제목</label> <input type="text" name="title" required>
				</div>

				<div class="form-group">
					<label>작성자</label> <input type="text" value="${authorNickname}"
						readonly class="readonly-input">
				</div>

				<div class="form-group">
					<label>내용</label>
					<textarea name="content" rows="8" required></textarea>
				</div>


				<c:if test="${isAdmin}">
					<div class="form-group" id="pinnedGroup"
						style="${type == 'notice' ? '' : 'display:none;'}">
						<label> <input type="checkbox" name="pinned" value="true">
							상단 고정
						</label>
					</div>
				</c:if>

				<div class="btn-group">
					<button type="submit">등록</button>
					<a class="cancel-btn" href="<c:url value='${cancel}'/>">취소</a>
				</div>

			</div>

		</form>

	</div>

	<c:if test="${isAdmin && typeChoice}">
		<script>
			(function() {
				var sel = document.getElementById('boardTypeSelect');
				var grp = document.getElementById('pinnedGroup');
				if (!sel || !grp)
					return;
				function sync() {
					if (sel.value === 'notice') {
						grp.style.display = '';
					} else {
						grp.style.display = 'none';
						var cb = grp.querySelector('input[name="pinned"]');
						if (cb)
							cb.checked = false;
					}
				}
				sel.addEventListener('change', sync);
				sync();
			})();
		</script>
	</c:if>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>