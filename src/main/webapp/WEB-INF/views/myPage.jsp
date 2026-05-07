<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<style>
.mypage-wrap {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 20px;
	font-family: Pretendard;
}

.profile-card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 30px;
	margin-bottom: 40px;
}

.card-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 2px solid #121212;
	padding-bottom: 15px;
	margin-bottom: 20px;
}

.grid-container {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.info-box {
	border-bottom: 1px solid #f5f5f5;
	padding: 10px 0;
}

.label {
	font-size: 13px;
	color: #888;
	display: block;
	margin-bottom: 4px;
}

.value {
	font-size: 16px;
	font-weight: 600;
}

.edit-link-btn {
	padding: 10px 20px;
	background: #121212;
	color: white;
	text-decoration: none;
	border-radius: 5px;
}

.product-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px;
	border-bottom: 1px solid #eee;
	cursor: pointer;
}

.price-tag {
	color: #ff5050;
	font-weight: bold;
}

.no-content {
	text-align: center;
	padding: 50px;
	color: #999;
}
</style>
</head>

<body>

	<c:import url="/WEB-INF/views/header.jsp" />

	<div class="mypage-wrap">

		<div class="card-header">
			<h2>마이페이지</h2>

			<a class="edit-link-btn"
				href="${pageContext.request.contextPath}/users/edit/${user.userNo}">
				내 정보 수정 </a>
		</div>

		<div class="profile-card">

			<div class="grid-container">

				<div class="info-box">
					<span class="label">회원번호</span> <span class="value">${user.userNo}</span>
				</div>

				<div class="info-box">
					<span class="label">아이디</span> <span class="value">${user.userId}</span>
				</div>

				<div class="info-box">
					<span class="label">이름</span> <span class="value">${user.userName}</span>
				</div>

				<div class="info-box">
					<span class="label">닉네임</span> <span class="value">${user.userNickName}</span>
				</div>

				<div class="info-box">
					<span class="label">연락처</span> <span class="value">${user.userPhone}</span>
				</div>

				<div class="info-box">
					<span class="label">등급</span> <span class="value">${user.userRole}</span>
				</div>

			</div>
		</div>

		<div class="product-section">

			<h3 style="border-bottom: 2px solid #121212; padding-bottom: 10px;">
				내가 등록한 상품</h3>

			<c:choose>

				<c:when test="${empty myProducts}">
					<div class="no-content">등록한 상품이 없습니다.</div>
				</c:when>

				<c:otherwise>

					<c:forEach var="p" items="${myProducts}">

						<div class="product-item"
							onclick="location.href='${pageContext.request.contextPath}/product/${p.productNo}'">

							<div>
								<div style="font-weight: 600;">${p.productName}</div>

								<div style="font-size: 12px; color: #999;">상품번호 :
									${p.productNo}</div>
							</div>

							<div class="price-tag">${p.price}원</div>

						</div>

					</c:forEach>

				</c:otherwise>

			</c:choose>

		</div>

	</div>

	<c:import url="/WEB-INF/views/footer.jsp" />

</body>
</html>