<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계좌 정보 등록</title>
<style>
.container {
	max-width: 560px;
	margin: 40px auto;
	padding: 24px;
	font-family: 'Pretendard', sans-serif;
}

h2 {
	font-size: 22px;
	margin: 0 0 6px;
}

.lead {
	color: #666;
	margin-bottom: 22px;
	font-size: 14px;
}

.banner-success {
	background: #dcfce7;
	color: #166534;
	padding: 12px 14px;
	border-radius: 8px;
	margin-bottom: 18px;
	font-size: 14px;
}

.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 20px;
}

.field {
	margin-bottom: 14px;
}

.field label {
	display: block;
	font-size: 13px;
	color: #555;
	margin-bottom: 6px;
}

.field input, .field select {
	width: 100%;
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	font-family: inherit;
	box-sizing: border-box;
}

.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 18px;
}

.btn {
	flex: 1;
	padding: 14px;
	border: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
	text-decoration: none;
	text-align: center;
}

.btn-primary {
	background: #121212;
	color: #fff;
}

.btn-line {
	background: #f0f0f0;
	color: #333;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<h2>계좌 정보</h2>
		<p class="lead">계좌이체 거래를 받으려면 입금받을 계좌를 등록해주세요.</p>

		<c:if test="${param.saved == '1'}">
			<div class="banner-success">✓ 계좌 정보가 저장되었습니다.</div>
		</c:if>

		<form action="${ctx}/mypage/account" method="post" class="card">
			<div class="field">
				<label for="bankName">은행</label>
				<input type="text" id="bankName" name="bankName"
					value="${user.userBankName}" placeholder="예) 카카오뱅크 / 농협" required>
			</div>
			<div class="field">
				<label for="accountNumber">계좌번호</label>
				<input type="text" id="accountNumber" name="accountNumber"
					value="${user.userAccountNumber}" placeholder="숫자만 입력" required>
			</div>
			<div class="field">
				<label for="accountHolder">예금주</label>
				<input type="text" id="accountHolder" name="accountHolder"
					value="${user.userAccountHolder}" placeholder="실명" required>
			</div>

			<div class="btn-group">
				<a href="${ctx}/mypage" class="btn btn-line">취소</a>
				<button type="submit" class="btn btn-primary">저장</button>
			</div>
		</form>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>