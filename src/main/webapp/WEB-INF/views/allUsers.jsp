<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [전체 사용자 목록]</title>


<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/allUsers.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<h3>전체 사용자 목록</h3>

		<a class="top-link" href="<c:url value='/users/search/searchMode'/>">
			사용자 검색 > </a>

		<c:forEach var="user" items="${users}">
			<div class="user-card">
				사용자 No: ${user.userNo}<br> 사용자 ID: ${user.userId}<br> 사용자
				이름: ${user.userName}<br> 사용자 권한: ${user.userRole}<br>
				<br> <a href="<c:url value='/users/search/${user.userNo}'/>">
					상세 정보 보기 > </a>
			</div>
		</c:forEach>

		<c:if test="${totalPages > 0}">
			<div class="pagination">
				<c:forEach var="page" begin="1" end="${totalPages}">
					<c:choose>

						<c:when test="${page == currentPage}">
							<strong>${page}</strong>
						</c:when>

						<c:otherwise>
							<a
								href="<c:url value='/users/search/allUsers'>
							<c:param name='pageNumber' value='${page}'/>
							<c:param name='limit' value='${limit}'/>
						</c:url>">
								${page} </a>
						</c:otherwise>

					</c:choose>
				</c:forEach>
			</div>
		</c:if>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>