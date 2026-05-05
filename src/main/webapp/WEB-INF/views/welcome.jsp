<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h1>minimarket</h1>
	<hr>

	<a href="<c:url value='/productList'/>">상품 목록 보기</a>
	<br><br>
	<a href="<c:url value='/product/new'/>">상품 등록하기</a>

</body>
</html>