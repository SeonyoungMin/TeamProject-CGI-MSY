<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<h2 class="section-title">마이페이지</h2>

		<div class="card">

			<!-- 프로필 사진 -->
			<div style="margin-bottom: 20px;">
				<c:choose>
					<c:when test="${not empty profileImage}">
						<img src="${ctx}${profileImage.filePath}"
							style="max-width: 200px; border: 1px solid #ddd;">
					</c:when>
					<c:otherwise>
						<div style="color: #999;">사진 없음</div>
					</c:otherwise>
				</c:choose>
			</div>

			<div
				style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
				<div>
					<b>회원번호</b><br>${user.userNo}</div>
				<div>
					<b>아이디</b><br>${user.userId}</div>
				<div>
					<b>이름</b><br>${user.userName}</div>
				<div>
					<b>닉네임</b><br>${user.userNickName}</div>
				<div>
					<b>연락처</b><br>${user.userPhone}</div>
				<div>
					<b>등급</b><br>${user.userRole}</div>
			</div>
			<div style="margin-top: 20px; display: flex; gap: 10px;">
				<a href="${ctx}/users/edit/${user.userNo}" class="btn btn-primary">내
					정보 수정</a>

				<c:url value="/users/delete/${user.userNo}" var="deleteUrl" />

				<form:form action="${deleteUrl}" method="DELETE"
					onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
					<button type="submit" class="btn btn-danger">회원 탈퇴</button>
				</form:form>
			</div>
		</div>


		<h3 class="section-title">내가 등록한 상품</h3>

		<c:if test="${empty myProducts}">
			<div class="card" style="text-align: center; color: #888;">등록한
				상품이 없습니다.</div>
		</c:if>

		<c:forEach var="p" items="${myProducts}">
			<div class="card"
				style="display: flex; justify-content: space-between; align-items: center;">
				<a href="${ctx}/product/${p.productNo}"
					style="flex: 1; display: flex; align-items: center; gap: 15px;">
					<span class="btn"
					style="padding: 2px 8px; font-size: 11px; background: ${p.tradeStatus == '완료' ? '#eee' : '#121212'}; color: ${p.tradeStatus == '완료' ? '#888' : '#fff'}; border: none;">
						${p.tradeStatus} </span>
					<div>
						<div style="font-weight: 600;">${p.productName}</div>
						<div style="font-size: 12px; color: #888;">
							<fmt:formatNumber value="${p.price}" />
							원
						</div>
					</div>
				</a>

				<div style="display: flex; gap: 5px;">
					<a href="${ctx}/product/${p.productNo}/edit" class="btn"
						style="padding: 5px 10px; font-size: 13px;">수정</a>

					<button type="button" class="btn btn-danger"
						onclick="deleteProduct('${p.productNo}')"
						style="padding: 5px 10px; font-size: 13px;">삭제</button>
				</div>
			</div>

		</c:forEach>

	</div>
	<script>
		function deleteProduct(productNo) {
			if (confirm('상품을 삭제하시겠습니까?')) {
				$.ajax({
					url : '${ctx}/product/' + productNo + '/delete',
					type : 'POST',
					success : function(result) {
						alert('삭제되었습니다.');
						// 삭제 완료 후 '홈'이 아닌 '상품 목록' 페이지로 강제 이동
						location.href = '${ctx}/mypage';
					},
					error : function() {
						alert('삭제 처리 중 오류가 발생했습니다.');
					}
				});
			}
		}
	</script>



	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
