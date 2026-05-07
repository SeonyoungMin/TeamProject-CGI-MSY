<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- jQuery (찜/댓글 AJAX용) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
/* ===== 공통 ===== */
* { box-sizing: border-box; }
body {
	margin: 0;
	font-family: 'Malgun Gothic', sans-serif;
	background: #fafafa;
	color: #222;
}

a { text-decoration: none; color: inherit; }

/* 가운데 정렬 컨테이너 */
.app-container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 0 20px;
}

/* 섹션 제목 */
.section-title {
	font-size: 22px;
	font-weight: bold;
	margin: 0 0 20px 0;
	padding-bottom: 10px;
	border-bottom: 2px solid #121212;
}

/* 카드 */
.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 20px;
}

/* input */
.form-input,
input[type="text"].form-input,
input[type="password"].form-input,
input[type="number"].form-input,
select.form-input,
textarea.form-input {
	width: 100%;
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
	background: #fff;
	margin-bottom: 12px;
}

textarea.form-input { min-height: 120px; resize: vertical; }

label.form-label {
	display: block;
	font-size: 13px;
	font-weight: bold;
	margin-bottom: 6px;
	color: #333;
}

/* 버튼 */
.btn {
	display: inline-block;
	padding: 10px 18px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #fff;
	color: #333;
	font-size: 14px;
	cursor: pointer;
	text-align: center;
}
.btn:hover { background: #f5f5f5; }

.btn-primary {
	background: #121212;
	border-color: #121212;
	color: #fff;
}
.btn-primary:hover { background: #000; }

.btn-line {
	background: #fff;
	border-color: #121212;
	color: #121212;
}

.btn-danger {
	background: #fff;
	border-color: #e74c3c;
	color: #e74c3c;
}
.btn-danger:hover { background: #fdecea; }

.btn-block { width: 100%; }

/* ===== Header ===== */
.top-bar {
	display: flex;
	justify-content: space-between;
	padding: 8px 50px;
	font-size: 12px;
	color: #888;
	background: #f9f9f9;
	border-bottom: 1px solid #eee;
}
.top-bar a { color: #888; margin-right: 15px; }

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
	flex: 1;
}

.search-container { flex: 2; display: flex; justify-content: center; }
.search-bar {
	width: 80%;
	padding: 10px 16px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #f5f5f5;
	outline: none;
}

.header-right {
	flex: 2;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 16px;
}

.nav-link { font-size: 14px; color: #333; }
.nav-link:hover { text-decoration: underline; }
.admin-link { color: #e74c3c; font-weight: bold; }
</style>

<header>
	<div class="top-bar">
		<div>
			<a href="${ctx}/home">홈</a>
			<a href="${ctx}/productList">상품 목록</a>
		</div>
		<div>TEAM 404</div>
	</div>

	<div class="main-header">
		<a href="${ctx}/home" class="logo">team404</a>

		<form class="search-container" action="${ctx}/product/search" method="get">
			<input type="text" name="keyword" class="search-bar" placeholder="상품명 검색" value="${keyword}">
		</form>

		<div class="header-right">
			<c:if test="${empty sessionScope.loginUser}">
				<a href="${ctx}/login" class="btn">로그인</a>
				<a href="${ctx}/signup" class="btn btn-primary">회원가입</a>
			</c:if>

			<c:if test="${not empty sessionScope.loginUser}">
				<a href="${ctx}/favorite" class="nav-link">찜 목록</a>
				<a href="${ctx}/mypage" class="nav-link">마이페이지</a>
				<c:if test="${sessionScope.loginUser.userRole == 'ROLE_ADMIN'}">
					<a href="${ctx}/users/search/allUsers" class="nav-link admin-link">계정관리</a>
				</c:if>
				<span style="font-size:14px;"><b>${sessionScope.loginUser.userNickName}</b>님</span>
				<a href="${ctx}/logout" class="btn">로그아웃</a>
				<a href="${ctx}/product/new" class="btn btn-primary">글쓰기</a>
			</c:if>
		</div>
	</div>
</header>
