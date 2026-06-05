<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/accountList.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">
		<h2 class="section-title">가계부</h2>

		<c:choose>
			<c:when test="${empty list}">
				<div class="card is-accountList-1">구매
					완료된 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="a" items="${list}">
					<div class="card is-accountList-2">
						<div class="is-accountList-3">
							<div class="is-accountList-4">${a.productName}</div>
							<span class="is-accountList-5">|</span>
							<div class="is-accountList-6">${a.price}원</div>
							<c:if test="${not empty a.memo}">
								<span class="is-accountList-7">|</span>
								<div
									class="memo-text-preview is-accountList-8">${a.memo}</div>
							</c:if>
							<div class="is-accountList-9">${a.createdTime}</div>
						</div>

						<div class="memo-wrap is-accountList-10" data-order-no="${a.orderNo}">
							<c:choose>
								<c:when test="${not empty a.memo}">
									<button type="button" class="btn memo-edit-btn is-accountList-11">수정</button>
								</c:when>
								<c:otherwise>
									<input type="text" class="form-input memo-input is-accountList-12"
										placeholder="메모를 입력하세요">
									<button type="button" class="btn memo-save-btn is-accountList-13">저장</button>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<!-- 페이징 -->
		<c:if test="${not empty totalPage and totalPage > 0}">
			<div class="is-accountList-14">
				<c:forEach var="i" begin="1" end="${totalPage}">
					<c:choose>
						<c:when test="${i == currentPage}">
							<strong class="is-accountList-15">${i}</strong>
						</c:when>
						<c:otherwise>
							<a href="<c:url value='/accountList?pageNum=${i}'/>"
								class="is-accountList-21">${i}</a>
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
									.html('<input type="text" class="form-input memo-input is-accountList-16" value="' + currentMemo + '" ' +
        '>'
											+ '<button type="button" class="btn memo-save-btn is-accountList-17">저장</button>');
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
										            '<button type="button" class="btn memo-edit-btn is-accountList-18">수정</button>'
										        );
										        var $card = $wrap.closest('.card');
										        var $preview = $card.find('.memo-text-preview');
										        if ($preview.length) {
										            $preview.text(memo);
										        } else {
										            $card.find('[style*="font-weight: bold"]').first()
										                .after('<span class="is-accountList-19">|</span><div class="memo-text-preview is-accountList-20">' + memo + '</div>');
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