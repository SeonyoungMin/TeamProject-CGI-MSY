<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계좌 정보 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/accountForm.css">
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