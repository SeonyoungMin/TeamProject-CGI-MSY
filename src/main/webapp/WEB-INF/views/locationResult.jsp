<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인증 결과</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/locationResult.css">
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
				<p class="is-locationResult-1">이어서 거래 약속(장소·시간·메시지)을 잡아주세요.</p>

				<a href="${pageContext.request.contextPath}/order/direct/form?productNo=${product.productNo}"
					class="btn btn-confirm is-locationResult-2">약속 잡기 진행</a>
			</c:when>


			<c:otherwise>
				<p class="fail">인증에 실패했습니다.</p>
				<p>판매자와의 거리가 너무 멀어 직거래 인증이 불가능합니다.</p>
				<p>또는 동네가 인증되지 않은 사용자 입니다.</p>
				<a href="${pageContext.request.contextPath}/mypage" class="is-locationResult-3">
					마이페이지로 가서 동네 인증하기</a>
				<button type="button" class="btn btn-back" onclick="history.back()">뒤로
					가기</button>
			</c:otherwise>
		</c:choose>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>