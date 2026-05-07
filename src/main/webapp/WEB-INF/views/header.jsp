<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
/* 상단 얇은 메뉴바 */
.top-bar {
	display: flex;
	justify-content: space-between;
	padding: 8px 50px;
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
	border-bottom: 1px solid #f5f5f5;
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
	transition: 0.2s;
}

.search-bar:focus {
	background: #fff;
	border-color: #000;
}

/* 오른쪽 메뉴 영역 */
.header-right {
	flex: 2;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 20px;
}

.nav-link {
	text-decoration: none;
	color: #333;
	font-size: 14px;
	font-weight: 500;
}

.nav-link:hover {
	color: #000;
	text-decoration: underline;
}

/* 관리자 전용 링크 스타일 */
.admin-link {
	color: #e74c3c !important; /* 관리자 강조 색상 */
	font-weight: bold !important;
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
	transition: 0.2s;
}

.btn-login {
	border: 1px solid #ddd;
	color: #333;
}

.btn-login:hover {
	background: #f5f5f5;
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

.btn-write:hover {
	background: #333;
	color: #fff;
}
</style>

<header>
	<!-- 상단 링크 -->
	<div class="top-bar">
		<div>
			<a href="${ctx}/board/notice">공지사항</a> <a href="${ctx}/board/qna">문의게시판</a>
		</div>
		<div>
			<span>EN | <b>KR</b></span>
		</div>
	</div>

	<!-- 메인 네비게이션 -->
	<div class="main-header">

		<a href="${ctx}/home" class="logo">team404</a>

		<div class="search-container">
			<input type="text" class="search-bar" placeholder="상품명, 카테고리 검색">
		</div>

		<div class="header-right">
			<c:if test="${not empty sessionScope.loginUser}">
				<!-- 일반 유저 메뉴 -->
				<a href="${ctx}/favorite" class="nav-link">찜 목록</a>
				<a href="${ctx}/mypage" class="nav-link">마이페이지</a>


				<c:if test="${sessionScope.loginUser.userRole == 'ROLE_ADMIN'}">
					<a href="${ctx}/users/search/allUsers" class="nav-link admin-link">계정
						관리</a>
				</c:if>
			</c:if>

			<div class="btn-group">
				<c:choose>
					<c:when test="${empty sessionScope.loginUser}">
						<a href="${ctx}/login" class="btn btn-login">로그인</a>
						<a href="${ctx}/signup" class="btn btn-join">회원가입</a>
					</c:when>
					<c:otherwise>
						<span style="font-size: 14px; margin-right: 5px;"> <b>${sessionScope.loginUser.userNickName}</b>님
						</span>
						<a href="${ctx}/logout" class="btn btn-login">로그아웃</a>
						<a href="${ctx}/register" class="btn btn-write">글쓰기</a>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</header>