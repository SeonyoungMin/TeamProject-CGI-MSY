<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인증 결과</title>
<style>
.container {
	max-width: 500px;
	margin: 80px auto;
	text-align: center;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 30px;
	background: #fff;
}

.success {
	color: #2ecc71;
	font-weight: bold;
	font-size: 1.2em;
}

.fail {
	color: #e74c3c;
	font-weight: bold;
	font-size: 1.2em;
}

.btn {
	padding: 12px 20px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	margin-top: 20px;
	font-size: 16px;
}

.btn-confirm {
	background: #000;
	color: #fff;
}

.btn-back {
	background: #ccc;
	color: #333;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<h2>동네 인증 결과</h2>

		<c:choose>

			<c:when test="${verified}">
				<p class="success">인증에 성공했습니다!</p>
				<p>
					판매자(<strong>${seller.userNickName}</strong>)님과 거래 가능한 거리입니다.
				</p>


				<form action="${pageContext.request.contextPath}/direct-complete"
					method="post">
					<input type="hidden" name="productNo" value="${product.productNo}">
					<button type="submit" class="btn btn-confirm">거래 완료하기</button>
				</form>
			</c:when>


			<c:otherwise>
				<p class="fail">인증에 실패했습니다.</p>
				<p>판매자와의 거리가 너무 멀어 직거래 인증이 불가능합니다.</p>
				<p>또는 동네가 인증되지 않은 사용자 입니다.</p>
				<a href="${pageContext.request.contextPath}/mypage"
					style="background-color: #121212; color: #ffffff; padding: 12px 24px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; display: inline-block; text-align: center; border: 1px solid #121212;">
					마이페이지로 가서 동네 인증하기</a>
				<button type="button" class="btn btn-back" onclick="history.back()">뒤로
					가기</button>
			</c:otherwise>
		</c:choose>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>