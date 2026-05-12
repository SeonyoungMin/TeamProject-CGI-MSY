<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="app-container" style="max-width:600px;">

	<h2 class="section-title">회원가입</h2>

	<form class="card" action="${ctx}/users" method="post">

		<label class="form-label">아이디</label>
		<input type="text" class="form-input" name="userId"
			placeholder="6~20자" minlength="6" maxlength="20"
			pattern="[A-Za-z0-9]+" required>

		<label class="form-label">비밀번호</label>
		<input type="password" class="form-input" name="userPw"
			placeholder="4-8자  " minlength="8" required>

		<label class="form-label">닉네임</label>
		<input type="text" class="form-input" name="userNickName"
			placeholder="2~10자" minlength="2" maxlength="10" required>

		<label class="form-label">이름</label>
		<input type="text" class="form-input" name="userName"
			placeholder="실명 (예: 홍길동)" maxlength="20" required>

		<label class="form-label">나이</label>
		<input type="number" class="form-input" name="userAge"
			placeholder="숫자만 입력 (예: 25)" min="1" max="120">

		<label class="form-label">전화번호</label>
		<input type="text" class="form-input" name="userPhone"
			placeholder="010-1234-5678" pattern="\d{2,3}-\d{3,4}-\d{4}">

		<label class="form-label">주소</label>
		<input type="text" class="form-input" name="userAddress"
			placeholder="예: 창원시" maxlength="100">

		<button type="submit" class="btn btn-primary btn-block">회원가입 완료</button>

		<div style="margin-top:15px; text-align:center; font-size:13px;">
			이미 계정이 있으신가요? <a href="${ctx}/login" style="font-weight:bold;">로그인</a>
		</div>
	</form>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
