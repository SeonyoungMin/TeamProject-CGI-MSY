<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>가계부</h3>
	<hr>

	<!-- 상단 요약 -->
	<div>
		<span>판매 수익 : +${totalSell}원</span> &nbsp; | &nbsp; <span>구매 수익
			: -${totalBuy}원</span> &nbsp; | &nbsp; <span> 순수익 : ${netProfit}원</span>
	</div>
	<hr>

	<!-- 목록 -->
	<c:choose>
		<c:when test="${empty list}">
			<p>거래 완료된 내역이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="a" items="${list}">
				<div>
					<span> <c:choose>
							<c:when test="${a.type == 'SELL'}">판매</c:when>
							<c:otherwise>구매</c:otherwise>
						</c:choose>
					</span> &nbsp;|&nbsp; <span>${a.productName}</span> &nbsp;|&nbsp; <span>${a.partnerNickname}</span>
					&nbsp;|&nbsp; <span>${a.price}원</span> &nbsp;|&nbsp; <span>${a.createdTime}</span>
					<br>

					<c:choose>
						<%-- 메모 없으면 입력창 바로 보여주기 --%>
						<c:when test="${empty a.memo}">
							<form action="/minimarket/account/${a.orderNo}" method="post">
								<input type="text" name="memo" placeholder="메모를 입력하세요" required>
								<button type="submit">저장</button>
							</form>
						</c:when>
						<%-- 메모 있으면 텍스트 + 수정버튼만 보여주기 --%>
						<c:otherwise>
							<span id="memo-text-${a.orderNo}">${a.memo}</span>
							<button onclick="showEdit('${a.orderNo}')">수정</button>
							<form id="memo-form-${a.orderNo}"
								action="/minimarket/account/${a.orderNo}" method="post"
								style="display: none;">
								<input type="text" name="memo" value="${a.memo}">
								<button type="submit">저장</button>
							</form>
						</c:otherwise>
					</c:choose>
				</div>
				<hr>
			</c:forEach>
		</c:otherwise>
	</c:choose>

	<!-- 페이징 -->
	<c:if test="${not empty totalPage}">
		<c:forEach var="i" begin="1" end="${totalPage}">
			<c:choose>
				<c:when test="${i == currentPage}">
					<strong>${i}</strong>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='/accountList?pageNum=${i}'/>">${i}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:if>

	<script>
		function showEdit(orderNo) {
			document.getElementById('memo-text-' + orderNo).style.display = 'none';
			document.getElementById('memo-form-' + orderNo).style.display = 'block';
		}
	</script>

</body>
</html>