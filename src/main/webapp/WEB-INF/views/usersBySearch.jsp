<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [사용자 검색]</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div style="max-width: 1100px; margin: 30px auto; padding: 20px;">

	<form:form modelAttribute="searchDTO" method="GET" action="${pageContext.request.contextPath}/users/search/searchMode">

		<h3>사용자 검색</h3>
		<a href="<c:url value='/users/search/allUsers'/>">관리자 페이지 [전체 사용자 목록]</a>
		<br><br>

		<label for="info">상세정보 검색</label>
		<form:radiobutton path="searchMode" id="info" value="info"/><br>
		ID 검색: <form:input path="userId"/><br>
		이름 검색: <form:input path="userName"/><br>
		주소 검색: <form:input path="userAddress"/><br>
		전번 검색: <form:input path="userPhone"/><br>
		권한 검색: <form:input path="userRole"/><br>
		<hr>
		<label for="condition">상세조건 검색</label>
		<form:radiobutton path="searchMode" id="condition" value="condition"/><br>
		사용자생성시작T: <form:input type="datetime-local" path="startTime"/>
		사용자생성종료T: <form:input type="datetime-local" path="endTime"/><br>
		최소 구매 횟수: <form:input type="number" path="minBuyCount"/>
		최대 구매 횟수: <form:input type="number" path="maxBuyCount"/><br>
		최소 판매 횟수: <form:input type="number" path="minSellCount"/>
		최대 판매 횟수: <form:input type="number" path="maxSellCount"/><br>

		<button>조회</button>
	</form:form>

	<hr>
	<p>총 ${count}건</p>

	<c:forEach var="user" items="${users}">
		유저 No: ${user.userNo}<br>
		유저 ID: ${user.userId}<br>
		유저 이름: ${user.userName}<br>
		유저 주소: ${user.userAddress}<br>
		유저 전번: ${user.userPhone}<br>
		유저 권한: ${user.userRole}<br>
		유저생성T: ${user.userCreatedTime}<br><br>
		<a href="<c:url value='/users/search/${user.userNo}'/>">상세 정보</a>
		<hr>
	</c:forEach>

	<c:if test="${totalPages > 0}">
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
	</c:if>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
