<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
</head>
<body>
	<h3>회원 가입</h3>
	<c:url value="/users" var="newUserProcess"/>
	<form:form modelAttribute="newUser" action="${newUserProcess}" enctype="multipart/form-data">
		ID: <form:input type="text" path="userId"/><br>
		PW: <form:input type="password" path="userPw"/><br>
		이름: <form:input type="text" path="userName"/><br>
		닉넴: <form:input type="text" path="userNickName"/><br>
		img: <form:input type="file" path="userImageFile"/><br>
		나이: <form:input type="number" path="userAge"/><br>
		<!-- select 구현 예정 -->
		주소: <form:input type="text" path="userAddress"/><br>
		전번: <form:input type="text" path="userPhone"/><br><br>
		<button>가입</button>
	</form:form>
</body>
</html>