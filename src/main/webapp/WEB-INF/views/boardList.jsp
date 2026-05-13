<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="title" value="${empty boardTitle ? '문의 게시판' : boardTitle}" />
<c:set var="type" value="${empty boardType ? 'inquiry' : boardType}" />
<c:set var="listUrl" value="${empty listUrl ? '/boardList' : listUrl}" />
<c:set var="writeUrl"
	value="${type == 'notice' ? '/notice/addForm' : (type == 'free' ? '/freeBoard/addForm' : '/boardList/addForm')}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${title}</title>
</head>
<body>
	<h3>${title}</h3>
	<hr>

	<c:choose>
		<c:when test="${empty list}">
			<p>등록된 글이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="b" items="${list}">
				<div>
					${b.boardNo} | <a
						href="<c:url value='/boardList/${b.boardNo}'/>">${b.title}</a>
					| ${b.authorNickname} |
					<fmt:formatDate value="${b.createdTime}" pattern="yyyy-MM-dd HH:mm" />
				</div>
				<hr>
			</c:forEach>
		</c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${type == 'inquiry'}">
			<a href="<c:url value='${writeUrl}'/>">문의글 등록</a>
		</c:when>
		<c:when test="${canWrite}">
			<a href="<c:url value='${writeUrl}'/>">글쓰기</a>
		</c:when>
	</c:choose>

	<hr>
	<c:if test="${not empty list}">
		<c:forEach var="i" begin="1" end="${totalPages}">
			<c:choose>
				<c:when test="${i == currentPage}">
					<strong>${i}</strong>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='${listUrl}?pageNum=${i}'/>">${i}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:if>
</body>
</html>
