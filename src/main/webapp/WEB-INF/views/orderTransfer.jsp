<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계좌이체 결제</title>
<style>
.order-container {
	max-width: 760px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.steps {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 20px;
	font-size: 13px;
	color: #999;
}

.step.active {
	color: #121212;
	font-weight: bold;
}

.step-num {
	width: 22px;
	height: 22px;
	border-radius: 50%;
	background: #f0f0f0;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	font-size: 11px;
	margin-right: 4px;
}

.step.active .step-num {
	background: #121212;
	color: #fff;
}

h2 {
	font-size: 22px;
	margin: 0 0 20px;
}

.section {
	margin-bottom: 24px;
}

.section-title {
	font-size: 15px;
	font-weight: bold;
	margin: 0 0 10px;
}

.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 16px 20px;
}

.product-summary {
	display: flex;
	gap: 14px;
	align-items: center;
}

.product-thumb {
	width: 64px;
	height: 64px;
	border-radius: 8px;
	background: #f3f3f3;
	overflow: hidden;
	flex-shrink: 0;
}

.product-thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.product-info-area {
	flex: 1;
	min-width: 0;
}

.product-name {
	font-weight: bold;
}

.product-price-summary {
	font-weight: bold;
	font-size: 16px;
	flex-shrink: 0;
}

.field-row {
	display: grid;
	grid-template-columns: 110px 1fr;
	gap: 12px;
	align-items: center;
	margin-bottom: 10px;
}

.field-row:last-child {
	margin-bottom: 0;
}

.field-label {
	font-size: 13px;
	color: #555;
}

.field-input {
	width: 100%;
	padding: 8px 10px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	box-sizing: border-box;
}

.account-box {
	background: #f8f9fa;
	border-radius: 12px;
	padding: 16px 20px;
	margin-bottom: 12px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 12px;
}

.copy-btn {
	padding: 6px 12px;
	background: #fff;
	border: 1px solid #ddd;
	border-radius: 6px;
	cursor: pointer;
	font-size: 13px;
}

.summary-row {
	display: flex;
	justify-content: space-between;
	padding: 6px 0;
	font-size: 14px;
}

.summary-total {
	display: flex;
	justify-content: space-between;
	padding-top: 10px;
	margin-top: 6px;
	border-top: 1px solid #eee;
	font-size: 16px;
	font-weight: bold;
}

.notice-box {
	background: #e6f1fb;
	border-radius: 12px;
	padding: 14px 18px;
	margin-bottom: 20px;
	color: #0c447c;
	font-size: 13px;
	line-height: 1.6;
}

.notice-box.warning {
	background: #fef3c7;
	color: #92400e;
}

.btn-group {
	display: flex;
	gap: 10px;
}

.btn-cancel, .btn-submit {
	padding: 14px;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}

.btn-cancel {
	flex: 1;
	background: #f0f0f0;
	color: #555;
}

.btn-submit {
	flex: 2;
	background: #121212;
	color: #fff;
}

.btn-submit:disabled {
	background: #999;
	cursor: not-allowed;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="order-container">

		<div class="steps">
			<span class="step"><span class="step-num">1</span>거래방식 선택</span> <span>›</span>
			<span class="step active"><span class="step-num">2</span>정보 입력</span>
			<span>›</span> <span class="step"><span class="step-num">3</span>결제
				완료</span>
		</div>

		<h2>계좌이체 결제</h2>

		<div class="card section product-summary">
			<div class="product-thumb">
				<c:if test="${not empty product.imgPath}">
					<img src="${product.imgPath}">
				</c:if>
			</div>
			<div class="product-info-area">
				<div style="font-size: 12px; color: #888;">${product.category}</div>
				<div class="product-name">${product.productName}</div>
				<div style="font-size: 12px; color: #888; margin-top: 2px;">
					판매자 ${product.sellerNickname}</div>
			</div>
			<div class="product-price-summary">
				<fmt:formatNumber value="${product.price}" />
				원
			</div>
		</div>

		<c:choose>
			<c:when test="${empty seller.userAccountNumber}">
				<div class="notice-box warning">
					<strong>판매자가 아직 계좌 정보를 등록하지 않았습니다.</strong><br> 판매자에게 계좌 등록을
					요청하거나 직거래로 진행해주세요.
				</div>
				<div style="display: flex; gap: 8px; margin-top: 8px;">
					<form action="${ctx}/account/request" method="post"
						style="flex: 1; margin: 0;">
						<input type="hidden" name="productNo" value="${product.productNo}">
						<button type="submit" class="btn-submit" style="width: 100%;"
							onclick="return confirm('판매자에게 계좌 등록 요청을 보낼까요?');">계좌 등록 요청 보내기</button>
					</form>
					<button type="button" class="btn-cancel" style="flex: 1;"
						onclick="history.back()">돌아가기</button>
				</div>
			</c:when>
			<c:otherwise>

				<form action="${ctx}/order/transfer-submit" method="post"
					id="orderForm">
					<input type="hidden" name="productNo" value="${product.productNo}">

					<div class="section">
						<div class="section-title">받는 사람</div>
						<div class="card">
							<div class="field-row">
								<span class="field-label">이름</span> <input class="field-input"
									type="text" name="receiverName" value="${loginUser.userName}"
									required>
							</div>
							<div class="field-row">
								<span class="field-label">연락처</span> <input class="field-input"
									type="text" name="receiverPhone" value="${loginUser.userPhone}"
									placeholder="010-0000-0000" required>
							</div>
						</div>
					</div>

					<div class="section">
						<div class="section-title">배송지</div>
						<div class="card">
							<div class="field-row">
								<span class="field-label">우편번호</span>
								<div style="display: flex; gap: 8px;">
									<input class="field-input" type="text" id="zipCode"
										name="zipCode" style="width: 130px;" required readonly>
									<button type="button" class="copy-btn"
										onclick="searchAddress()">주소 검색</button>
								</div>
							</div>
							<div class="field-row">
								<span class="field-label">주소</span> <input class="field-input"
									type="text" id="address" name="address"
									value="${loginUser.userAddress}" required readonly>
							</div>
							<div class="field-row">
								<span class="field-label">상세주소 <span style="color:#999; font-weight:normal; font-size:12px;">(선택)</span></span>
								<input class="field-input" type="text" name="addressDetail"
									placeholder="동/호수 (선택)">
							</div>
							<div class="field-row">
								<span class="field-label">요청사항</span> <select
									class="field-input" name="deliveryRequest" id="deliveryRequestSel"
									onchange="toggleDeliveryEtc()">
									<option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
									<option value="배송 전 연락 바랍니다">배송 전 연락 바랍니다</option>
									<option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
									<option value="직접 받겠습니다">직접 받겠습니다</option>
									<option value="기타">기타 (직접 입력)</option>
								</select>
							</div>
							<div class="field-row" id="deliveryEtcRow" style="display:none;">
								<span class="field-label">기타 요청</span>
								<input class="field-input" type="text" id="deliveryRequestEtc"
									placeholder="요청사항을 직접 입력해 주세요" maxlength="100">
							</div>
						</div>
					</div>

					<div class="section">
						<div class="section-title">입금 정보</div>
						<div class="account-box">
							<div>
								<div style="font-size: 12px; color: #666; margin-bottom: 4px;">
									아래 계좌로 입금해주세요</div>
								<div style="font-weight: bold; font-size: 15px;"
									id="accountInfo">${seller.userBankName}
									${seller.userAccountNumber}</div>
								<div style="font-size: 13px; color: #666; margin-top: 2px;">
									예금주: ${seller.userAccountHolder}</div>
							</div>
							<button type="button" class="copy-btn" onclick="copyAccount()">복사</button>
						</div>
						<div class="card">
							<div class="field-row">
								<span class="field-label">입금자명</span> <input class="field-input"
									type="text" name="depositorName" placeholder="실제 입금하시는 분의 이름"
									required>
							</div>
						</div>
					</div>

					<div class="section">
						<div class="section-title">결제 요약</div>
						<div class="card">
							<div class="summary-row">
								<span style="color: #666;">상품 금액</span> <span><fmt:formatNumber
										value="${product.price}" />원</span>
							</div>
							<div class="summary-total">
								<span>총 결제 금액</span> <span><fmt:formatNumber
										value="${product.price}" />원</span>
							</div>
						</div>
					</div>

					<div class="notice-box">
						<strong>안전거래 안내</strong><br> 입금 전 판매자 신원과 계좌 정보를 한 번 더 확인하세요.
						입금 후에는 채팅으로 송금 확인을 요청해주세요.
					</div>

					<div class="section">
						<label style="display: block; padding: 6px 0; cursor: pointer;">
							<input type="checkbox" id="agree1"> 개인정보 제3자(판매자) 제공에
							동의합니다 (필수)
						</label> <label style="display: block; padding: 6px 0; cursor: pointer;">
							<input type="checkbox" id="agree2"> 환불 정책을 확인했으며 동의합니다
							(필수)
						</label>
					</div>

					<div class="btn-group">
						<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
						<button type="submit" class="btn-submit" id="submitBtn">
							<fmt:formatNumber value="${product.price}" />
							원 결제하기
						</button>
					</div>
				</form>

			</c:otherwise>
		</c:choose>

	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		function searchAddress() {
			new daum.Postcode({
				oncomplete : function(data) {
					document.getElementById('zipCode').value = data.zonecode;
					document.getElementById('address').value = data.address;
				}
			}).open();
		}

		function copyAccount() {
			var text = document.getElementById('accountInfo').textContent
					.trim();
			var number = text.replace(/[^0-9-]/g, '');

			var temp = document.createElement('textarea');
			temp.value = number;
			document.body.appendChild(temp);
			temp.select();
			document.execCommand('copy');
			document.body.removeChild(temp);

			alert('계좌번호가 복사되었습니다.');
		}

		function toggleDeliveryEtc() {
			var sel = document.getElementById('deliveryRequestSel');
			var row = document.getElementById('deliveryEtcRow');
			var etc = document.getElementById('deliveryRequestEtc');
			if (!sel || !row) return;
			if (sel.value === '기타') {
				row.style.display = '';
				if (etc) etc.focus();
			} else {
				row.style.display = 'none';
			}
		}

		var orderForm = document.getElementById('orderForm');
		if (orderForm) {
			orderForm.addEventListener('submit', function(e) {
				if (!document.getElementById('agree1').checked
						|| !document.getElementById('agree2').checked) {
					alert('필수 약관에 동의해주세요.');
					e.preventDefault();
					return;
				}
				// 요청사항 '기타' 선택 시 직접 입력값을 select value로 덮어쓰기
				var sel = document.getElementById('deliveryRequestSel');
				var etc = document.getElementById('deliveryRequestEtc');
				if (sel && sel.value === '기타') {
					var val = etc ? etc.value.trim() : '';
					if (!val) {
						alert('기타 요청사항을 입력해주세요.');
						e.preventDefault();
						if (etc) etc.focus();
						return;
					}
					var opt = document.createElement('option');
					opt.value = val;
					opt.selected = true;
					sel.appendChild(opt);
				}
			});
		}
	</script>
</body>
</html>