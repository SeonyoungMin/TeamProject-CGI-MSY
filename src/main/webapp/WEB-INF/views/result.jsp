<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>결과</title>
</head>
<body>

	<h2>${msg}</h2>

	<p>${imgPath}</p>

	<img src="${imgPath}" width="300" />

	<br>
	<br>
	<a href="${pageContext.request.contextPath}/">다시 업로드</a>

</body>
