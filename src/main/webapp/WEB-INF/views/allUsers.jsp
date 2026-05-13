<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [전체 사용자 목록]</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f8f9fa;
}

.container {
	max-width: 1100px;
	margin: 40px auto;
	padding: 30px;
	background: white;
	border-radius: 12px;
}

h3 {
	text-align: center;
	margin-bottom: 20px;
}

.top-link {
	display: block;
	text-align: right;
	margin-bottom: 25px;
	text-decoration: none;
	color: gray;
	font-weight: bold;
}

.user-card {
	width: 100%;
	box-sizing: border-box;
	padding: 18px;
	margin-bottom: 20px;
	border: 1px solid #eee;
	border-radius: 10px;
	background: #fff;
}

.user-card a {
	color: gray;
	text-decoration: none;
	font-weight: bold;
}

.user-card a:hover, .top-link:hover {
	color: black;
}

.pagination {
	text-align: center;
	margin-top: 25px;
}

.pagination a, .pagination strong {
	margin: 0 6px;
	padding: 8px 14px;
	border-radius: 8px;
	text-decoration: none;
	border: 1px solid #ddd;
	color: black;
}

.pagination a:hover {
	background: #f1f1f1;
}

.pagination strong {
	background: black;
	color: white;
	border-color: black;
}
</style>

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