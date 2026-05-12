<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<div class="page">
	<%@ include file="/WEB-INF/views/header.jsp"%>


	<h3>이달의 판매왕</h3>
	<c:choose>
		<c:when test="${salesKing != null}">
			<p>닉네임: ${salesKing.nickname}</p>
			<p>
				총 금액:
				<fmt:formatNumber value="${salesKing.totalAmount}" />
				원
			</p>
		</c:when>
		<c:otherwise>
			<p>이번 달 판매 기록이 없습니다.</p>
		</c:otherwise>
	</c:choose>

	<h3>이달의 소비왕</h3>
	<c:choose>
		<c:when test="${spendingKing != null}">
			<p>닉네임: ${spendingKing.nickname}</p>
			<p>
				총 금액:
				<fmt:formatNumber value="${spendingKing.totalAmount}" />
				원
			</p>
		</c:when>
		<c:otherwise>
			<p>이번 달 구매 기록이 없습니다.</p>
		</c:otherwise>
	</c:choose>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</div>
