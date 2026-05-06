<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지 [유저 관리]</title>
</head>
<body>

	<form:form modelAttribute="searchDTO" method="GET" action="/minimarket/users/search">
	<a href="/minimarket/users/search">유저 목록</a><br><br>
	
	<h3>유저 정보 검색</h3>
		<label for="info">상세정보 검색</label>
		<form:radiobutton path="searchMode" id="info" value="info"/><br>
		ID 검색: <form:input path="userId"/><br>
		이름 검색: <form:input path="userName"/><br>
		주소 검색: <form:input path="userAddress"/><br>
		전번 검색: <form:input path="userPhone"/><br>
		권한 검색: <form:input path="userRole"/><br>
		
	<h3>조건 검색</h3>
		<label for="condition">조건별 조회</label>
		<form:radiobutton path="searchMode" id="condition" value="condition"/><br>
		유저생성시작T: <form:input type="datetime-local" path="startTime"/>
		유저생성종료T: <form:input type="datetime-local" path="endTime"/><br>
		최소 구매 횟수: <form:input type="number" path="minBuyCount"/>
		최대 구매 횟수: <form:input type="number" path="maxBuyCount"/><br>
		최소 판매 횟수: <form:input type="number" path="minSellCount"/>
		최대 판매 횟수: <form:input type="number" path="maxSellCount"/><br>
		
		<button>조회</button>
	</form:form>

	<hr>
	<hr>
	
	<c:forEach var="user" items="${users}">
	유저 No: ${user.userNo}<br>
	유저 ID:	${user.userId}<br>
	유저 이름:	${user.userName}<br>
	유저 주소:	${user.userAddress}<br>
	유저 전번:	${user.userPhone}<br>
	유저 권한:	${user.userRole}<br>
	유저생성T:	${user.userCreatedTime}<br><br>
	<a href="/minimarket/users/search/${user.userNo}">상세 정보</a>
	<hr>
	</c:forEach>
	
</body>
</html>