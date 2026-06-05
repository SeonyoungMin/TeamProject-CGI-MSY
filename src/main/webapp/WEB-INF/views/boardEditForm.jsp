<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>


<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boardEditForm.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<h3>게시글 수정</h3>

		<form action="<c:url value='/boardList/${board.boardNo}'/>"
			method="post">

			<input type="hidden" name="_method" value="PUT">

			<div class="form-card">

				<div class="form-group">
					<label>게시판 구분</label> <select name="boardType" id="boardTypeSelect"
						required>

						<c:if test="${isAdmin}">
							<option value="notice"
								${board.boardType == 'notice' ? 'selected' : ''}>공지사항</option>
						</c:if>

						<option value="inquiry"
							${board.boardType == 'inquiry' ? 'selected' : ''}>문의</option>

						<option value="free"
							${board.boardType == 'free' ? 'selected' : ''}>자유</option>

					</select>
				</div>

				<div class="form-group">
					<label>제목</label> <input type="text" name="title"
						value="${board.title}" required>
				</div>

				<div class="form-group">
					<label>작성자</label> <input type="text"
						value="${board.authorNickname}" readonly class="readonly-input">
				</div>

				<div class="form-group">
					<label>내용</label>
					<textarea name="content" rows="8" required>${board.content}</textarea>
				</div>


				<c:if test="${isAdmin}">
					<div class="form-group" id="pinnedGroup"
						style="${board.boardType == 'notice' ? '' : 'display:none;'}">
						<label> <input type="checkbox" name="pinned" value="true"
							${board.pinned ? 'checked' : ''}> 상단 고정
						</label>
					</div>
				</c:if>

				<div class="btn-group">
					<button type="submit">수정 완료</button>

					<a class="cancel-btn"
						href="<c:url value='/boardList/${board.boardNo}'/>"> 취소 </a>
				</div>

			</div>

		</form>

	</div>

	<c:if test="${isAdmin}">
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