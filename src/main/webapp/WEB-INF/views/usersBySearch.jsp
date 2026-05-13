<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [사용자 검색]</title>

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
}

.section {
	width: 100%;
	box-sizing: border-box;
	margin-bottom: 18px;
	padding: 20px;
	border: 1px solid #eee;
	border-radius: 10px;
	background: #fafafa;
}

label {
	font-weight: bold;
	display: inline-block;
	margin-bottom: 8px;
}

input {
	padding: 8px;
	margin: 4px 8px 8px 0;
	border: 1px solid #ddd;
	border-radius: 8px;
	width: 180px;
	box-sizing: border-box;
}

button {
	padding: 12px 25px;
	border: none;
	background: black;
	color: white;
	border-radius: 8px;
	cursor: pointer;
	font-size: 15px;
}

button:hover {
	background: black;
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
}

.pagination strong {
	background: black;
	color: white;
}
</style>

</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">

		<h3>사용자 검색</h3>

		<a class="top-link" href="<c:url value='/users/search/allUsers'/>">
			전체 사용자 목록 > </a>

		<form:form modelAttribute="searchDTO" method="GET"
			action="${pageContext.request.contextPath}/users/search/searchMode">

			<div class="section">

				<label>상세정보 검색</label>
				<form:hidden path="searchMode" value="info" />
				<br>
				<br>

				<form:input path="userId" placeholder="ID 검색" />
				<form:input path="userName" placeholder="이름 검색" />
				<form:input path="userAddress" placeholder="주소 검색" />
				<form:input path="userPhone" placeholder="전화번호 검색" />
				<form:input path="userRole" placeholder="권한 검색" />

				<br>
				<br>

				<button type="submit">조회</button>

			</div>

		</form:form>
		<hr>

		<p>
			<strong>총 ${count}건</strong>
		</p>

		<c:forEach var="user" items="${users}">
			<div class="user-card">
				유저 No: ${user.userNo}<br> 유저 ID: ${user.userId}<br> 유저 이름:
				${user.userName}<br> 유저 주소: ${user.userAddress}<br> 유저 전번:
				${user.userPhone}<br> 유저 권한: ${user.userRole}<br> 유저 생성일:
				${user.userCreatedTime}<br> <br> <a
					href="<c:url value='/users/search/${user.userNo}'/>"> 상세 정보 보기
					> </a>
			</div>
		</c:forEach>

		<c:if test="${totalPages > 0}">
			<div class="pagination">
				<c:forEach var="page" begin="1" end="${totalPages}">
					<c:url var="pageUrl" value="/users/search/searchMode">
						<c:param name="pageNumber" value="${page}" />
						<c:param name="limit" value="${limit}" />
						<c:param name="searchMode" value="${searchDTO.searchMode}" />
						<c:param name="userId" value="${searchDTO.userId}" />
						<c:param name="userName" value="${searchDTO.userName}" />
						<c:param name="userAddress" value="${searchDTO.userAddress}" />
						<c:param name="userPhone" value="${searchDTO.userPhone}" />
						<c:param name="userRole" value="${searchDTO.userRole}" />
						<c:param name="startTime" value="${searchDTO.startTime}" />
						<c:param name="endTime" value="${searchDTO.endTime}" />
						<c:param name="minBuyCount" value="${searchDTO.minBuyCount}" />
						<c:param name="maxBuyCount" value="${searchDTO.maxBuyCount}" />
						<c:param name="minSellCount" value="${searchDTO.minSellCount}" />
						<c:param name="maxSellCount" value="${searchDTO.maxSellCount}" />
					</c:url>

					<c:choose>
						<c:when test="${page == currentPage}">
							<strong>${page}</strong>
						</c:when>
						<c:otherwise>
							<a href="${pageUrl}">${page}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</c:if>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>