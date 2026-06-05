<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [사용자 검색]</title>


<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/usersBySearch.css">
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