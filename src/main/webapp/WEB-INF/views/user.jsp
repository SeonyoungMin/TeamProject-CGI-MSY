<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저 조회</title>
</head>
<body>
	<h3>유저 상세 정보</h3>

	<img src="${pageContext.request.contextPath}${user.userImagePath}"
		style="width: 30%">
	<br> 파일명: ${user.userImageName}
	<br> 유저 No: ${user.userNo}
	<br> 유저 ID: ${user.userId}
	<br> 유저 PW: ${user.userPw}
	<br> 유저 이름: ${user.userName}
	<br> 유저 닉넴: ${user.userNickName}
	<br> 유저 나이: ${user.userAge}
	<br> 유저 주소: ${user.userAddress}
	<br> 유저 전번: ${user.userPhone}
	<br> 유저 등급: ${user.userGrade}
	<br> 유저 권한: ${user.userRole}
	<br> 유저생성T: ${user.userCreatedTime}
	<br> 유저구매C: ${user.userBuyCount}
	<br> 유저판매C: ${user.userSellCount}
	<br>
	<br>
	<a href="/minimarket/users/edit/${user.userNo}">수정</a>

	<c:url value="/users/delete/${user.userNo}" var="deleteUserProcess" />
	<form:form action="${deleteUserProcess}" method="DELETE">
		<button>회원 탈퇴</button>
	</form:form>


	<a href="/minimarket/users/search">유저 목록</a>
	<br>
	<br>
</body>
</html>