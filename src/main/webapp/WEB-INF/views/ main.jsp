<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<title>메인 페이지</title>
<link href="${pageContext.request.contextPath}/resources/css/style.css"
	rel="stylesheet">
</head>
<body>

	<!-- 헤더 가져오기 -->
	<%@ include file="header.jsp"%>

	<!-- 메인 컨텐츠 영역 (피그마 배너 + 상품 리스트) -->
	<div id="content" style="width: 1440px; margin: 0 auto;">

		<!-- 배너 영역 -->
		<div
			style="width: 1440px; height: 230px; background: #F6F6F6; position: relative;">
			<div
				style="text-align: center; padding-top: 60px; font-size: 48px; font-weight: 700;">쉽고
				안전한 중고거래</div>
		</div>

		<!-- 최근 상품 리스트 (반복문) -->
		<div style="padding: 40px 60px;">
			<h3>최근 등록 상품</h3>
			<c:forEach var="item" items="${recentItems}">
				<!-- 아까 만든 상품 카드 디자인 넣기 -->
			</c:forEach>
		</div>

	</div>

	<!-- 푸터 가져오기 -->
	<%@ include file="footer.jsp"%>

</body>
</html>