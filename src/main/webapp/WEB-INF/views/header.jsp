<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
/* 상단 얇은 메뉴바 */
.top-bar {
	display: flex;
	justify-content: space-between;
	padding: 5px 50px;
	font-size: 12px;
	color: #888;
	background: #f9f9f9;
	border-bottom: 1px solid #eee;
}

.top-bar a {
	text-decoration: none;
	color: #888;
	margin-right: 15px;
}

/* 메인 헤더 */
.main-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 20px 50px;
	background: #fff;
}

.logo {
	font-size: 28px;
	font-weight: bold;
	color: #000;
	text-decoration: none;
	flex: 1;
}

/* 검색창 영역 */
.search-container {
	flex: 2;
	display: flex;
	justify-content: center;
}

.search-bar {
	width: 80%;
	padding: 10px 20px;
	border: 1px solid #ddd;
	border-radius: 5px;
	background: #f5f5f5;
	outline: none;
}

/* 오른쪽 메뉴 영역 */
.header-right {
	flex: 2;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 25px;
}

.nav-link {
	text-decoration: none;
	color: #333;
	font-size: 14px;
	font-weight: 500;
}

.btn-group {
	display: flex;
	gap: 10px;
	align-items: center;
}

.btn {
	padding: 8px 18px;
	border-radius: 4px;
	font-size: 14px;
	text-decoration: none;
	cursor: pointer;
}

.btn-login {
	border: 1px solid #ddd;
	color: #333;
}

.btn-join {
	background: #000;
	color: #fff;
	border: 1px solid #000;
}

.btn-write {
	border: 1px solid #333;
	color: #333;
	background: #fff;
	font-weight: bold;
}
</style>

<header>
	<!-- 상단 링크 (이미지 참고) -->
	<div class="top-bar">
		<div>
			<a href="${ctx}/board/notice">공지사항</a> <a href="${ctx}/board/qna">문의게시판</a>
		</div>
		<div>
			<span>EN | KR</span>
		</div>
	</div>

	<!-- 메인 네비게이션 -->
	<div class="main-header">
		<a href="${pageContext.request.contextPath}/home" class="logo">team404</a>

		<div class="search-container">
			<input type="text" class="search-bar" placeholder="상품명, 카테고리 검색">
		</div>

		<div class="header-right">
			<!-- 찜 목록 추가 -->
			<a href="${pageContext.request.contextPath}/favorite"
				class="nav-link">찜 목록</a> <a
				href="${pageContext.request.contextPath}/mypage" class="nav-link">마이페이지</a>

			<div class="btn-group">
				<c:choose>
					<c:when test="${empty sessionScope.loginUser}">
						<a href="${pageContext.request.contextPath}/login"
							class="btn btn-login">로그인</a>
						<a href="${pageContext.request.contextPath}/signup"
							class="btn btn-join">회원가입</a>
					</c:when>
					<c:otherwise>
						<span style="font-size: 14px;"><b>${sessionScope.loginUser.userNickName}</b>님</span>
						<a href="${pageContext.request.contextPath}/logout"
							class="btn btn-login">로그아웃</a>
					</c:otherwise>
				</c:choose>
				<a href="${pageContext.request.contextPath}/product/register"
					class="btn btn-write">글쓰기</a>
			</div>
		</div>
	</div>
</header>