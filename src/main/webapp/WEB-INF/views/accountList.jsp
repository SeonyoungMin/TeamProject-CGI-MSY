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
				<div class="card" style="text-align: center; color: #888;">구매
					완료된 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="a" items="${list}">
					<div class="card"
						style="display: flex; justify-content: space-between; align-items: center; gap: 15px;">
						<div
							style="display: flex; align-items: center; gap: 8px; flex: 1;">
							<div style="font-weight: 600;">${a.productName}</div>
							<span style="color: #ddd;">|</span>
							<div style="font-weight: bold;">${a.price}원</div>
							<c:if test="${not empty a.memo}">
								<span style="color: #ddd;">|</span>
								<div style="font-size: 13px; color: #555;"
									class="memo-text-preview">${a.memo}</div>
							</c:if>
							<div style="font-size: 12px; color: #888; margin-left: auto;">${a.createdTime}</div>
						</div>

						<div class="memo-wrap" data-order-no="${a.orderNo}"
							style="display: flex; align-items: center; gap: 5px;">
							<c:choose>
								<c:when test="${not empty a.memo}">
									<button type="button" class="btn memo-edit-btn"
										style="padding: 5px 14px; font-size: 13px;">수정</button>
								</c:when>
								<c:otherwise>
									<input type="text" class="form-input memo-input"
										placeholder="메모를 입력하세요"
										style="margin: 0; font-size: 13px; min-width: 200px;">
									<button type="button" class="btn memo-save-btn"
										style="padding: 5px 14px; font-size: 13px;">저장</button>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<!-- 페이징 -->
		<c:if test="${not empty totalPage and totalPage > 0}">
			<div
				style="text-align: center; margin-top: 20px; display: flex; justify-content: center; gap: 8px;">
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
		// 수정 버튼 클릭 → input으로 전환
		$(document)
				.on(
						'click',
						'.memo-edit-btn',
						function() {
							var $wrap = $(this).closest('.memo-wrap');
							var currentMemo = $wrap.find('.memo-text').text();

							$wrap
									.html('<input type="text" class="form-input memo-input" value="' + currentMemo + '" ' +
        'style="margin: 0; font-size: 13px; min-width: 200px;">'
											+ '<button type="button" class="btn memo-save-btn" style="padding: 5px 14px; font-size: 13px;">저장</button>');
							$wrap.find('.memo-input').focus();
						});

		// 저장 버튼 클릭
		$(document)
				.on(
						'click',
						'.memo-save-btn',
						function() {
							var $btn = $(this);
							var $wrap = $btn.closest('.memo-wrap');
							var orderNo = $wrap.data('order-no');
							var memo = $wrap.find('.memo-input').val();

							$btn.prop('disabled', true).text('저장 중...');

							$
									.ajax({
										url : '${ctx}/account/' + orderNo
												+ '/memo',
										type : 'POST',
										data : {
											memo : memo
										},
										success: function(res) {
										    if (res === 'success') {
										        // 기존 코드 지우고 이걸로 교체
										        $wrap.html(
										            '<button type="button" class="btn memo-edit-btn" style="padding: 5px 14px; font-size: 13px;">수정</button>'
										        );
										        var $card = $wrap.closest('.card');
										        var $preview = $card.find('.memo-text-preview');
										        if ($preview.length) {
										            $preview.text(memo);
										        } else {
										            $card.find('[style*="font-weight: bold"]').first()
										                .after('<span style="color: #ddd;">|</span><div style="font-size: 13px; color: #555;" class="memo-text-preview">' + memo + '</div>');
										        }
										    },
										error : function() {
											alert('서버 통신 중 오류가 발생했습니다.');
											$btn.prop('disabled', false).text(
													'저장');
										}
									});
						});
		

	</script>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
