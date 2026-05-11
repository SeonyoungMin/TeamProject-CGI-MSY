<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 게시판</title>
</head>
<body>
	<h3>문의 게시판</h3>

	<c:choose>
		<c:when test="${empty list}">
			<p>등록된 문의글이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="b" items="${list}">
				<div>
					${b.boardNo} |<a href="<c:url value='/boardList/${b.boardNo}'/>" />${b.title}</a>
					|${b.authorNickname} |${b.createdTime}
				</div>
				<hr>
			</c:forEach>
		</c:otherwise>
	</c:choose>

	<a href="<c:url value='/boardList/addForm'/>">문의글 등록</a>

	<hr>
	<c:if test="${not empty list}">
		<c:forEach var="i" begin="1" end="${totalPages}">
			<c:choose>
				<c:when test="${i == currentPage}">
					<strong>${i}</strong>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='/boardList?pageNum=${i}'/>">${i}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:if>
</body>
</html>