<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계좌이체 결제</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orderTransfer.css">
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
				<div class="is-orderTransfer-1">${product.category}</div>
				<div class="product-name">${product.productName}</div>
				<div class="is-orderTransfer-2">
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
				<div class="is-orderTransfer-3">
					<form action="${ctx}/account/request" method="post" class="is-orderTransfer-4">
						<input type="hidden" name="productNo" value="${product.productNo}">
						<button type="submit" class="btn-submit is-orderTransfer-5"
							onclick="return confirm('판매자에게 계좌 등록 요청을 보낼까요?');">계좌 등록
							요청 보내기</button>
					</form>
					<button type="button" class="btn-cancel is-orderTransfer-6"
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
								<div class="is-orderTransfer-7">
									<input class="field-input is-orderTransfer-8" type="text" id="zipCode"
										name="zipCode" required readonly>
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
								<span class="field-label">상세주소 <span class="is-orderTransfer-9">(선택)</span></span>
								<input class="field-input" type="text" name="addressDetail"
									placeholder="동/호수 (선택)">
							</div>
							<div class="field-row">
								<span class="field-label">요청사항</span> <select
									class="field-input" name="deliveryRequest"
									id="deliveryRequestSel" onchange="toggleDeliveryEtc()">
									<option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
									<option value="배송 전 연락 바랍니다">배송 전 연락 바랍니다</option>
									<option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
									<option value="직접 받겠습니다">직접 받겠습니다</option>
									<option value="기타">기타 (직접 입력)</option>
								</select>
							</div>
							<div class="field-row is-orderTransfer-10" id="deliveryEtcRow">
								<span class="field-label">기타 요청</span> <input
									class="field-input" type="text" id="deliveryRequestEtc"
									placeholder="요청사항을 직접 입력해 주세요" maxlength="100">
							</div>
						</div>
					</div>

					<div class="section">
						<div class="section-title">입금 정보</div>
						<div class="account-box">
							<div>
								<div class="is-orderTransfer-11">
									아래 계좌로 입금해주세요</div>
								<div
									id="accountInfo" class="is-orderTransfer-12">${seller.userBankName}
									${seller.userAccountNumber}</div>
								<div class="is-orderTransfer-13">
									예금주: ${seller.userAccountHolder}</div>
							</div>
							<div class="is-orderTransfer-14">
								<button type="button" class="copy-btn" onclick="copyAccount()">계좌
									복사</button>

								<a
									href="https://www.police.go.kr/www/security/cyber/cyber04.jsp"
									target="_blank" class="copy-btn is-orderTransfer-15"> 사기계좌 조회
								</a>
								<button type="button" class="copy-btn"
									onclick="openVerifyModal()">실명 인증</button>
							</div>
							<div class="card">
								<div class="field-row">
									<span class="field-label">입금자명</span> <input
										class="field-input" type="text" name="depositorName"
										placeholder="실제 입금하시는 분의 이름" required>
								</div>
							</div>
						</div>

						<div class="section">
							<div class="section-title">결제 요약</div>
							<div class="card">
								<div class="summary-row">
									<span class="is-orderTransfer-16">상품 금액</span> <span><fmt:formatNumber
											value="${product.price}" />원</span>
								</div>
								<div class="summary-total">
									<span>총 결제 금액</span> <span><fmt:formatNumber
											value="${product.price}" />원</span>
								</div>
							</div>
						</div>

						<div class="notice-box">
							<strong>안전거래 안내</strong><br> 입금 전 판매자 신원과 계좌 정보를 한 번 더
							확인하세요.
						</div>

						<div class="section">

							<label class="is-orderTransfer-17">
								<input type="checkbox" id="agree1"> 판매자 계좌가 <b>사기계좌
									여부 조회 완료</b>된 계좌인지 직접 확인했으며, 입금 판단에 대한 책임은 구매자 본인에게 있음을 확인합니다. (필수)
							</label> <label class="is-orderTransfer-18">
								<input type="checkbox" id="agree2"> 사기계좌로 확인될 경우 다른 피해
								예방을 위해 <b>경찰청 또는 사이버범죄 신고센터에 신고</b>외에 자사 사이트에서도 사용자 신고를 적극적으로 하는
								데 동의합니다. (필수)
							</label>

						</div>

						<div class="btn-group">
							<button type="button" class="btn-cancel" onclick="history.back()">뒤로
								가기</button>
							<button type="submit" class="btn-submit" id="submitBtn">
								<fmt:formatNumber value="${product.price}" />
								원 결제하기
							</button>
						</div>
				</form>
				<div class="is-orderTransfer-19">
					<form id="cancelForm" action="${ctx}/order/transfer/cancel"
						method="post">

						<input type="hidden" name="orderNo" value="${o.orderNo}">

						<button type="button" onclick="confirmCancel()" class="is-orderTransfer-20">
							거래 취소하기</button>
					</form>
				</div>

			</c:otherwise>
		</c:choose>

	</div>
	<div id="verifyModal"
		style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999;">
		<div
			style="background: #fff; border-radius: 12px; padding: 30px; max-width: 400px; margin: 100px auto;">
			<h3 style="margin: 0 0 20px;">계좌 실명 인증</h3>
			<div style="margin-bottom: 12px;">
				<label style="font-size: 13px; color: #666;">은행명</label> <input
					type="text" id="modal-bankName" placeholder="예) 카카오뱅크, 국민"
					style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; margin-top: 4px; box-sizing: border-box;">
			</div>
			<div style="margin-bottom: 12px;">
				<label style="font-size: 13px; color: #666;">계좌번호</label> <input
					type="text" id="modal-accountNo" placeholder="- 없이 숫자만"
					style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; margin-top: 4px; box-sizing: border-box;">
			</div>
			<div style="margin-bottom: 20px;">
				<label style="font-size: 13px; color: #666;">예금주 생년월일 앞 6자리</label>
				<input type="text" id="modal-birthDate" placeholder="예) 990101"
					maxlength="6"
					style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; margin-top: 4px; box-sizing: border-box;">
			</div>
			<div style="display: flex; gap: 8px;">
				<button type="button" onclick="closeVerifyModal()"
					style="flex: 1; padding: 12px; background: #fff; border: 1px solid #ddd; border-radius: 8px; cursor: pointer;">취소</button>
				<button type="button" onclick="doVerify()"
					style="flex: 1; padding: 12px; background: #4f46e5; color: #fff; border: none; border-radius: 8px; font-weight: bold; cursor: pointer;">인증하기</button>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	var bankCodeMap = {
		    "국민": "004", "kb국민": "004",
		    "신한": "088", "우리": "020",
		    "하나": "081", "농협": "011",
		    "카카오뱅크": "090", "카카오": "090",
		    "토스뱅크": "092", "토스": "092",
		    "기업": "003", "sc제일": "023",
		    "케이뱅크": "089", "부산": "032",
		    "대구": "031", "경남": "039"
		};

		function openVerifyModal() {
		    document.getElementById("verifyModal").style.display = "block";
		}

		function closeVerifyModal() {
		    document.getElementById("verifyModal").style.display = "none";
		}

		function doVerify() {
		    var bankName = document.getElementById("modal-bankName").value.trim();
		    var accountNo = document.getElementById("modal-accountNo").value.trim();
		    var birthDate = document.getElementById("modal-birthDate").value.trim();

		    if (!bankName || !accountNo || !birthDate) {
		        alert("모든 항목을 입력해주세요.");
		        return;
		    }

		    var bankCode = bankCodeMap[bankName.toLowerCase()] || bankCodeMap[bankName];
		    if (!bankCode) {
		        alert("지원하지 않는 은행입니다.\n예) 카카오뱅크, 국민, 신한, 우리, 하나, 농협");
		        return;
		    }

		    fetch("${ctx}/mypage/account/verify", {
		        method: "POST",
		        headers: { "Content-Type": "application/x-www-form-urlencoded" },
		        body: "bankCode=" + bankCode
		            + "&accountNo=" + encodeURIComponent(accountNo)
		            + "&birthDate=" + birthDate
		    })
		    .then(res => res.text())
		    .then(result => {
		        if (result !== "fail" && result !== "error") {
		            alert("인증 성공!\n예금주명: " + result);
		            closeVerifyModal();
		        } else {
		            alert("인증 실패\n계좌 정보를 다시 확인해주세요.");
		        }
		    })
		    .catch(() => {
		        alert("인증 중 오류가 발생했습니다.");
		    });
		}
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
			if (!sel || !row)
				return;
			if (sel.value === '기타') {
				row.style.display = '';
				if (etc)
					etc.focus();
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
						if (etc)
							etc.focus();
						return;
					}
					var opt = document.createElement('option');
					opt.value = val;
					opt.selected = true;
					sel.appendChild(opt);
				}
			});
		}

		function confirmCancel() {
			var orderNo = document.querySelector('input[name="orderNo"]').value;
			if (!orderNo || orderNo === "") {
				alert("주문 번호를 찾을 수 없습니다.");
				return;
			}
			if (confirm('거래를 취소하시겠습니까?')) {
				document.getElementById('cancelForm').submit();
			}
		}
	</script>
</body>
</html>