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
						<img src="${profileImage.filePath}"
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

				<c:if test="${not empty loginUser.verifiedArea}">
					<div
						style="padding: 15px; background-color: #f1f3f5; border-radius: 8px;; margin-top: 10px;">
						<div style="color: #888; font-size: 13px; margin-bottom: 5px;">동네
							인증 상태</div>
						<div style="font-weight: 600;">
							<i class="fa-solid fa-circle-check"></i> 인증 완료
							(${loginUser.verifiedArea})
						</div>
					</div>
				</c:if>

				<c:if test="${empty loginUser.verifiedArea}">
					<div
						style="padding: 15px; background-color: #fff5f5; border-radius: 8px; margin-top: 10px;">
						<div style="color: #888; font-size: 13px; margin-bottom: 5px;">동네
							인증 상태</div>
						<div style="font-weight: 600;">
							아직 동네인증을 하지 않은 유저입니다.
							<button type="button" class="btn btn-secondary"
								onclick="verifyLocation()">지금 인증하기</button>
						</div>
					</div>
				</c:if>
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


		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px; border-bottom: 2px solid #121212; padding-bottom: 10px; margin-bottom: 20px;">
			<h3 class="section-title" style="margin: 0; border-bottom: none;">내가
				등록한 상품</h3>
			<a href="${ctx}/product/mylist" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>

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


		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px; border-bottom: 2px solid #121212; padding-bottom: 10px; margin-bottom: 20px;">
			<h3 class="section-title" style="margin: 0; border-bottom: none;">
				구매 내역 <span
					style="font-size: 13px; color: #999; font-weight: normal;">(${totalBought})</span>
			</h3>
			<a href="${ctx}/mypage/bought" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>
		<div class="card">
			<c:choose>
				<c:when test="${not empty boughtList}">
					<div class="product-grid"
						style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px;">

						<c:forEach var="item" items="${boughtList}">
							<div class="product-item"
								style="border: 1px solid #eee; border-radius: 10px; overflow: hidden; cursor: pointer;"
								onclick="location.href='${ctx}/product/${item.productNo}'">

								<div class="product-img"
									style="height: 140px; background: #f4f4f4; display: flex; align-items: center; justify-content: center;">
									<c:choose>
										<c:when test="${not empty item.imgPath}">
											<img src="${item.imgPath}"
												style="width: 100%; height: 100%; object-fit: cover;"
												onerror="this.onerror=null;this.src='https://via.placeholder.com/150?text=No+Image';">
										</c:when>
										<c:otherwise>
											<span style="color: #ccc;">이미지 없음</span>
										</c:otherwise>
									</c:choose>
								</div>

								<div style="padding: 10px;">
									<div
										style="font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										${item.productName}</div>
									<div style="font-weight: bold;">
										<fmt:formatNumber value="${item.price}" pattern="#,###" />
										원
									</div>
									<div style="font-size: 12px; color: #999; margin-top: 5px;">
										거래 완료</div>
								</div>
							</div>
						</c:forEach>

					</div>
				</c:when>

				<c:otherwise>
					<div style="text-align: center; padding: 40px 0; color: #999;">
						구매한 내역이 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 받은 후기 -->
		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px; border-bottom: 2px solid #121212; padding-bottom: 10px; margin-bottom: 20px;">
			<h3 class="section-title" style="margin: 0; border-bottom: none;">
				받은 후기 <span
					style="font-size: 13px; color: #999; font-weight: normal;">(${totalMyReviews})</span>
			</h3>
			<a href="${ctx}/mypage/reviews" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>
		<c:choose>
			<c:when test="${empty myReviews}">
				<div class="card" style="text-align: center; color: #888;">아직
					받은 후기가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="r" items="${myReviews}">
					<div class="card" style="padding: 16px 20px; margin-bottom: 10px;">
						<div
							style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
							<span style="font-weight: bold; color: #333;">${r.productName}</span>
							<span style="font-size: 12px; color: #999;"> <fmt:formatDate
									value="${r.createdTime}" pattern="yyyy.MM.dd" />
							</span>
						</div>
						<div style="font-size: 14px; color: #444; line-height: 1.6;">${r.content}</div>
						<div
							style="font-size: 12px; color: #aaa; margin-top: 8px; text-align: right;">
							작성자: ${r.sellerNickname}</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<!-- 가계부 (최근 5건) -->
		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px; border-bottom: 2px solid #121212; padding-bottom: 10px; margin-bottom: 20px;">
			<h3 class="section-title" style="margin: 0; border-bottom: none;">가계부</h3>
			<a href="${ctx}/accountList" style="font-size: 14px; color: #666;">전체보기
				&gt;</a>
		</div>
		<c:choose>
			<c:when test="${empty accountList}">
				<div class="card" style="text-align: center; color: #888;">구매
					완료된 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div
					style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
					<c:forEach var="a" items="${accountList}">
						<div class="card">
							<div
								style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
								<div>
									<div style="font-weight: 600;">${a.productName}</div>
									<div style="font-size: 12px; color: #888; margin-top: 4px;">
										<fmt:formatDate value="${a.createdTime}" pattern="yyyy.MM.dd" />
									</div>
								</div>
								<div style="font-weight: bold;">
									<fmt:formatNumber value="${a.price}" />
									원
								</div>
							</div>
							<form class="memo-form" data-order-no="${a.orderNo}"
								onsubmit="return false;"
								style="display: flex; gap: 5px; margin: 0;">
								<input type="text" name="memo" value="${a.memo}"
									class="form-input memo-input" placeholder="메모를 입력하세요"
									style="flex: 1; margin: 0; font-size: 13px;">
								<button type="button" class="btn memo-save-btn"
									style="padding: 5px 14px; font-size: 13px;">저장</button>
							</form>
						</div>
					</c:forEach>
				</div>

			</c:otherwise>
		</c:choose>

	</div>
	<script>
		$(document)
				.on(
						'click',
						'.memo-save-btn',
						function() {
							var $btn = $(this);
							var $form = $btn.closest('.memo-form');
							var orderNo = $form.data('order-no');
							var memo = $form.find('input[name="memo"]').val();
							var originalText = $btn.text();
							var originalBg = $btn.css('background-color');
							var originalColor = $btn.css('color');

							$btn.prop('disabled', true).text('저장 중...');

							$
									.ajax({
										url : '${ctx}/account/' + orderNo
												+ '/memo',
										type : 'POST',
										data : {
											memo : memo
										},
										success : function(res) {
											if (res === 'success') {
												$btn
														.text('저장됨')
														.css(
																{
																	'background-color' : '#28a745',
																	'color' : '#fff'
																});
												setTimeout(
														function() {
															$btn
																	.prop(
																			'disabled',
																			false)
																	.text(
																			originalText)
																	.css(
																			{
																				'background-color' : originalBg,
																				'color' : originalColor
																			});
														}, 1200);
											} else if (res === 'unauthorized') {
												alert('로그인이 필요합니다.');
												location.href = '${ctx}/login';
											} else {
												alert('저장에 실패했습니다.');
												$btn.prop('disabled', false)
														.text(originalText);
											}
										},
										error : function() {
											alert('서버 통신 중 오류가 발생했습니다.');
											$btn.prop('disabled', false).text(
													originalText);
										}
									});
						});

		function deleteProduct(productNo) {
			if (confirm('상품을 삭제하시겠습니까?')) {
				$.ajax({
					url : '${ctx}/product/' + productNo + '/delete',
					type : 'POST',
					success : function(result) {
						alert('삭제되었습니다.');
						location.href = '${ctx}/mypage';
					},
					error : function() {
						alert('삭제 처리 중 오류가 발생했습니다.');
					}
				});
			}
		}

		function verifyLocation() {
			if (!navigator.geolocation) {
				alert("위치 서비스 미지원");
				return;
			}

			navigator.geolocation.getCurrentPosition(function(pos) {
				let lat = pos.coords.latitude;
				let lng = pos.coords.longitude;

				$.ajax({
					url : "${ctx}/users/reverse-geocode",
					type : "GET",
					data : {
						lat : lat,
						lng : lng
					},
					success : function(area) {
						$.ajax({
							url : "${ctx}/users/update-location-ajax",
							type : "POST",
							data : {
								userNo : "${user.userNo}",
								address : area,
								lat : lat,
								lng : lng
							},
							success : function(response) {
								if (response === "success") {
									alert("동네 인증 및 주소 업데이트가 완료되었습니다!");
									location.reload();
								} else {
									alert("DB 저장 중 오류가 발생했습니다.");
								}
							},
							error : function() {
								alert("서버 통신 실패");
							}
						});
					},
					error : function() {
						alert("위치 인증 실패");
					}
				});
			});
		}
	</script>



	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
