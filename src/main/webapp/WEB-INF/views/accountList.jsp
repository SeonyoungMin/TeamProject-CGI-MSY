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
	<h3>가계부</h3>
	<hr>
	<c:choose>
		<c:when test="${empty list}">
			<p>구매 완료된 내역이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="a" items="${list}">
				<div>${a.productName}|${a.createdTime}| ${a.price}원</div>
				<form action="/account/${a.orderNo}" method="post">
					<input type="text" name="memo" value="${a.memo}"
						placeholder="메모를 입력하세요">
					<button type="submit">저장</button>
				</form>
				</div>
				<hr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
	
		<!-- 페이징 -->
	<c:if test="${not empty totalPage}">
		<c:forEach var="i" begin="1" end="${totalPage}">
			<c:choose>
				<c:when test="${i == currentPage}">
					<strong>${i}</strong>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='/accountList?pageNum=${i}'/>">${i}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:if>

</body>
</html>