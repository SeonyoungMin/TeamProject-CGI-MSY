<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="title" value="${empty boardTitle ? '문의 게시판' : boardTitle}" />
<c:set var="type" value="${empty boardType ? 'inquiry' : boardType}" />
<c:set var="cancel" value="${empty cancelUrl ? '/boardList' : cancelUrl}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${title} 등록</title>
</head>
<body>
	<h3>${title} 글쓰기</h3>
	<hr>
	<form action="<c:url value='/board/type'/>" method="post">
		<input type="hidden" name="authorNo" value="${authorNo}">

		<c:choose>
			<c:when test="${typeChoice}">
				<div>
					게시판 :
					<select name="boardType" required>
						<c:if test="${isAdmin}">
							<option value="notice">공지사항</option>
						</c:if>
						<option value="inquiry" selected>문의</option>
						<option value="free">자유</option>
					</select>
				</div>
			</c:when>
			<c:otherwise>
				<input type="hidden" name="boardType" value="${type}">
			</c:otherwise>
		</c:choose>

		<div>
			제목 : <input type="text" name="title" required>
		</div>
		<div>
			작성자 : <input type="text" value="${authorNickname}" readonly>
		</div>
		<div>
			내용 :
			<textarea name="content" rows="7" cols="40" required></textarea>
		</div>

		<c:if test="${isAdmin}">
			<div>
				<label>
					<input type="checkbox" name="pinned" value="true"> 상단 고정 (핀)
				</label>
			</div>
		</c:if>

		<button type="submit">등록</button>
		<a href="<c:url value='${cancel}'/>">취소</a>
	</form>
</body>
</html>
