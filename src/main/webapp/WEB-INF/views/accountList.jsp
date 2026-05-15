<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">
		<h2 class="section-title">가계부</h2>

		<c:choose>
			<c:when test="${empty list}">
				<div class="card" style="text-align: center; color: #888;">구매 완료된 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="a" items="${list}">
					<div class="card"
						style="display: flex; justify-content: space-between; align-items: center; gap: 15px;">
						<div style="flex: 1;">
							<div style="font-weight: 600;">${a.productName}</div>
							<div style="font-size: 12px; color: #888; margin-top: 4px;">${a.createdTime}</div>
						</div>
						<div style="font-weight: bold; min-width: 80px; text-align: right;">${a.price}원</div>
						<form class="memo-form" data-order-no="${a.orderNo}"
							onsubmit="return false;"
							style="display: flex; gap: 5px; margin: 0;">
							<input type="text" name="memo" value="${a.memo}"
								class="form-input memo-input" placeholder="메모를 입력하세요"
								style="margin: 0; font-size: 13px; min-width: 200px;">
							<button type="button" class="btn memo-save-btn"
								style="padding: 5px 14px; font-size: 13px;">저장</button>
						</form>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<!-- 페이징 -->
		<c:if test="${not empty totalPage and totalPage > 0}">
			<div style="text-align: center; margin-top: 20px; display: flex; justify-content: center; gap: 8px;">
				<c:forEach var="i" begin="1" end="${totalPage}">
					<c:choose>
						<c:when test="${i == currentPage}">
							<strong
								style="padding: 5px 12px; background: #121212; color: #fff; border-radius: 4px;">${i}</strong>
						</c:when>
						<c:otherwise>
							<a href="<c:url value='/accountList?pageNum=${i}'/>"
								style="padding: 5px 12px; border: 1px solid #ddd; text-decoration: none; color: #333; border-radius: 4px;">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</c:if>
	</div>

	<script>
		// 가계부 메모 저장 — 페이지 이동 없이 jQuery AJAX 처리
		$(document).on('click', '.memo-save-btn', function() {
			var $btn = $(this);
			var $form = $btn.closest('.memo-form');
			var orderNo = $form.data('order-no');
			var memo = $form.find('input[name="memo"]').val();
			var originalText = $btn.text();
			var originalBg = $btn.css('background-color');
			var originalColor = $btn.css('color');

			$btn.prop('disabled', true).text('저장 중...');

			$.ajax({
				url : '${ctx}/account/' + orderNo + '/memo',
				type : 'POST',
				data : {
					memo : memo
				},
				success : function(res) {
					if (res === 'success') {
						$btn.text('저장됨').css({
							'background-color' : '#28a745',
							'color' : '#fff'
						});
						setTimeout(function() {
							$btn.prop('disabled', false).text(originalText)
								.css({
									'background-color' : originalBg,
									'color' : originalColor
								});
						}, 1200);
					} else if (res === 'unauthorized') {
						alert('로그인이 필요합니다.');
						location.href = '${ctx}/login';
					} else {
						alert('저장에 실패했습니다.');
						$btn.prop('disabled', false).text(originalText);
					}
				},
				error : function() {
					alert('서버 통신 중 오류가 발생했습니다.');
					$btn.prop('disabled', false).text(originalText);
				}
			});
		});
	</script>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
