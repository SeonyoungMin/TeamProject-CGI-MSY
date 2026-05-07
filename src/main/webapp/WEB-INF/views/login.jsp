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

<div class="app-container" style="max-width:480px;">

	<h2 class="section-title">로그인</h2>

	<form class="card" action="${ctx}/login" method="post">
		<input type="hidden" name="redirect" value="${redirect}">

		<label class="form-label">아이디</label>
		<input type="text" class="form-input" name="userId" required>

		<label class="form-label">비밀번호</label>
		<input type="password" class="form-input" name="userPw" required>

		<button type="submit" class="btn btn-primary btn-block">로그인</button>

		<div style="margin-top:15px; text-align:center; font-size:13px;">
			계정이 없으신가요? <a href="${ctx}/signup" style="font-weight:bold;">회원가입</a>
		</div>
	</form>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
