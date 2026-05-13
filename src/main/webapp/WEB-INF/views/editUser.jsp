<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저 정보 수정</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f8f9fa;
}

.container {
	width: 500px;
	margin: 50px auto;
	background: white;
	padding: 35px;
	border-radius: 12px;
}

h3 {
	text-align: center;
	margin-bottom: 25px;
}

.top-link {
	display: block;
	text-align: right;
	margin-bottom: 20px;
	text-decoration: none;
	color: #007bff;
}

.form-group {
	margin-bottom: 15px;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 6px;
}

input {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-sizing: border-box;
}

button {
	width: 100%;
	padding: 12px;
	border: none;
	background: #007bff;
	color: white;
	font-size: 16px;
	border-radius: 8px;
	cursor: pointer;
}

button:hover {
	background: #0056b3;
}
</style>

</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<h3>유저 정보 수정</h3>

		<a class="top-link" href="/minimarket/users/search">유저 목록</a>

		<c:url value="/users/edit" var="editUserProcess" />

		<form:form modelAttribute="editUser" action="${editUserProcess}"
			method="PUT" enctype="multipart/form-data">

			<form:hidden path="userNo" />

			<div class="form-group">
				<label>회원번호</label>
				<form:input path="userNo" readonly="true" />
			</div>

			<div class="form-group">
				<label>회원 ID</label>
				<form:input path="userId" />
			</div>

			<div class="form-group">
				<label>비밀번호</label>
				<form:password path="userPw" />
			</div>

			<div class="form-group">
				<label>이름</label>
				<form:input path="userName" />
			</div>

			<div class="form-group">
				<label>닉네임</label>
				<form:input path="userNickName" />
			</div>

			<div class="form-group">
				<label>프로필 이미지</label>
				<form:input type="file" path="userImageFile" />
			</div>

			<div class="form-group">
				<label>나이</label>
				<form:input type="number" path="userAge" />
			</div>

			<div class="form-group">
				<label>주소</label>
				<form:input path="userAddress" />
			</div>

			<div class="form-group">
				<label>전화번호</label>
				<form:input path="userPhone" />
			</div>

			<button type="submit">회원정보 수정</button>

		</form:form>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

</body>
</html>