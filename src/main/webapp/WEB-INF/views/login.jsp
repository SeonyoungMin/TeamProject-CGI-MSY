<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container" style="max-width: 480px;">

		<h2 class="section-title">로그인</h2>

		<form class="card" action="${ctx}/login" method="post">
			<input type="hidden" name="redirect" value="${redirect}"> <label
				class="form-label">아이디</label> <input type="text" class="form-input"
				name="userId" required> <label class="form-label">비밀번호</label>
			<input type="password" class="form-input" name="userPw" required>

			<button type="submit" class="btn btn-primary btn-block">로그인</button>

			<div style="margin-top: 15px; text-align: center; font-size: 13px;">
				계정이 없으신가요? <a href="${ctx}/signup" style="font-weight: bold;">회원가입</a>
			</div>
		</form>
		
		<hr>
		<!-- 구글 로그인 -->
		<a href="/minimarket/oauth2/authorization/google"
			style="display: block; padding: 10px; background: #4285f4; color: #fff; text-align: center; border-radius: 4px; margin-top: 10px;">
			Google로 로그인 </a>

		<!-- 카카오 로그인 -->
		<a href="https://kauth.kakao.com/oauth/authorize?client_id=a933e91e3b0fedfcea1130e48a0c9ad9&redirect_uri=http://localhost:8080/minimarket/login/kakao/callback&response_type=code"
			style="display: block; padding: 10px; background: #FEE500; color: #000; text-align: center; border-radius: 4px; margin-top: 10px; font-weight: bold;">
			카카오로 로그인 </a>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>


	<script>
		const urlParams = new URLSearchParams(window.location.search);

		if (urlParams.has('error')) {
			alert("아이디 또는 비밀번호가 일치하지 않습니다.");
		}
	</script>
</body>
</html>
