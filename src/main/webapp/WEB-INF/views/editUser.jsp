<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저 정보 수정</title>
</head>
<body>
	<h3>유저 정보 수정</h3>
	<a href="/minimarket/users/search">유저 목록</a><br><br>
	<c:url value="/users/edit" var="editUserProcess"/>
	<form:form modelAttribute="editUser" action="${editUserProcess}" method="PUT" enctype="multipart/form-data">
	<form:hidden path="userNo"/>
		NO: <form:input path="userNo" readonly="true"/><br>
		ID: <form:input type="text" path="userId"/><br>
		PW: <form:password path="userPw"/><br>
		이름: <form:input type="text" path="userName"/><br>
		닉넴: <form:input type="text" path="userNickName"/><br>
		img: <form:input type="file" path="userImageFile"/><br>
		나이: <form:input type="number" path="userAge"/><br>
		<!-- select 구현 예정 -->
		주소: <form:input type="text" path="userAddress"/><br>
		전번: <form:input type="text" path="userPhone"/><br><br>
		<button>회원정보 수정</button>
	</form:form>
</body>
</html>