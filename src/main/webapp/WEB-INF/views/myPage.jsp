<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="app-container">

	<h2 class="section-title">마이페이지</h2>

	<!-- 내 정보 -->
	<div class="card">
		<div style="display:grid; grid-template-columns:1fr 1fr; gap:15px;">
			<div><b>회원번호</b><br>${user.userNo}</div>
			<div><b>아이디</b><br>${user.userId}</div>
			<div><b>이름</b><br>${user.userName}</div>
			<div><b>닉네임</b><br>${user.userNickName}</div>
			<div><b>연락처</b><br>${user.userPhone}</div>
			<div><b>등급</b><br>${user.userRole}</div>
		</div>
		<div style="margin-top:20px;">
			<a href="${ctx}/users/edit/${user.userNo}" class="btn btn-primary">내 정보 수정</a>
		</div>
	</div>

	<!-- 내가 등록한 상품 -->
	<h3 class="section-title">내가 등록한 상품</h3>

	<c:if test="${empty myProducts}">
		<div class="card" style="text-align:center; color:#888;">등록한 상품이 없습니다.</div>
	</c:if>

	<c:forEach var="p" items="${myProducts}">
		<a href="${ctx}/product/${p.productNo}" class="card" style="display:flex; justify-content:space-between; align-items:center;">
			<div>
				<div style="font-weight:600;">${p.productName}</div>
				<div style="font-size:12px; color:#888;">상품번호 : ${p.productNo}</div>
			</div>
			<div style="font-weight:bold; color:#e74c3c;">
				<fmt:formatNumber value="${p.price}"/>원
			</div>
		</a>
	</c:forEach>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
