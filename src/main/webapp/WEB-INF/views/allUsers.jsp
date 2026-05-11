<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [전체 사용자 목록]</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div style="max-width: 1100px; margin: 30px auto; padding: 20px;">

	<h3>전체 사용자 목록</h3>
	<a href="<c:url value='/users/search/searchMode'/>">관리자 페이지 [사용자 검색]</a>
	<br><br>
	<hr>

	<c:forEach var="user" items="${users}">
		사용자 No: ${user.userNo}<br>
		사용자 ID: ${user.userId}<br>
		사용자 이름: ${user.userName}<br>
		사용자 권한: ${user.userRole}<br>
		<a href="<c:url value='/users/search/${user.userNo}'/>">상세 정보</a>
		<hr>
	</c:forEach>

	<c:if test="${totalPages > 0}">
		<c:forEach var="page" begin="1" end="${totalPages}">
			<c:choose>
				<c:when test="${page == currentPage}">
					<strong>${page}</strong>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='/users/search/allUsers'>
						<c:param name='pageNumber' value='${page}'/>
						<c:param name='limit' value='${limit}'/>
					</c:url>">${page}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:if>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
