<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>

<style>
body {
	margin: 0;
	font-family: 'Noto Sans KR';
}

/* 전체 배경 */
.page {
	width: 100%;
	min-height: 100vh;
	background: #F6F6F6;
}

/* 상단 */
.header {
	height: 64px;
	background: white;
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	border-bottom: 1px solid #E6E6E6;
}

.logo {
	font-size: 30px;
	font-weight: 700;
}

.home-link {
	position: absolute;
	right: 40px;
	font-size: 12px;
	color: #878787;
	text-decoration: none;
}

/* 중앙 정렬 핵심 ⭐ */
.container {
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: calc(100vh - 64px);
}

/* 카드 */
.card {
	width: 100%;
	max-width: 600px;
	background: white;
	border-radius: 8px;
	padding: 40px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
}

/* 제목 */
.card h2 {
	margin-bottom: 5px;
}

.sub-text {
	font-size: 13px;
	color: #878787;
	margin-bottom: 20px;
}

/* input */
input {
	width: 100%;
	height: 40px;
	border: 1px solid #E6E6E6;
	border-radius: 4px;
	padding: 0 14px;
	margin-bottom: 16px;
}

/* 버튼 */
.login-btn {
	width: 100%;
	height: 46px;
	background: #121212;
	color: white;
	border: none;
	border-radius: 4px;
	font-weight: 700;
	cursor: pointer;
}

/* 구분선 */
.divider {
	height: 1px;
	background: #E6E6E6;
	margin: 20px 0;
}

/* 하단 */
.bottom {
	display: flex;
	justify-content: space-between;
	font-size: 12px;
	color: #878787;
}

.signup {
	font-weight: 700;
	text-decoration: underline;
	color: #121212;
	margin-left: 5px;
}
</style>
</head>

<body>

	<div class="page">

		<!-- 상단 -->
		<div class="header">
			<div class="logo">team404</div>
			<a href="/" class="home-link">홈으로</a>
		</div>

		<!-- 중앙 -->
		<div class="container">
			<div class="card">

				<h2>로그인</h2>
				<div class="sub-text">환영합니다</div>

				<form action="/login" method="post">

					<input type="text" name="userId" placeholder="아이디를 입력하세요">
					<input type="password" name="password" placeholder="비밀번호를 입력하세요">

					<button type="submit" class="login-btn">로그인</button>

				</form>

				<div class="divider"></div>

				<div class="bottom">
					<div>
						계정이 없으신가요? <a href="/signup" class="signup">회원가입</a>
					</div>

				</div>

			</div>
		</div>

	</div>

</body>
</html>