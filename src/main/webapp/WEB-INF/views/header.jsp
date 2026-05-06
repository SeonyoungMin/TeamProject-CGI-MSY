<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
.header {
	background: white;
	border-bottom: 1px solid #E6E6E6;
}

.header-inner {
	max-width: 1200px;
	margin: auto;
	height: 64px;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.logo {
	font-size: 24px;
	font-weight: 700;
}

.top-menu a {
	margin-left: 15px;
	font-size: 13px;
	text-decoration: none;
	color: #333;
}
</style>

<div class="header">
	<div class="header-inner">

		<div class="logo">
			<a href="home" style="text-decoration: none; color: black;">
				team404 </a>
		</div>

		<div class="top-menu">

			<c:choose>
				<c:when test="${not empty loginUser}">
                    ${loginUser.userNickName}님
                    <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
					<a href="${pageContext.request.contextPath}/mypage">마이페이지</a>
				</c:when>

				<c:otherwise>
					<a href="${pageContext.request.contextPath}/login">로그인</a>
					<a href="${pageContext.request.contextPath}/signup">회원가입</a>
				</c:otherwise>
			</c:choose>

		</div>

	</div>
</div>