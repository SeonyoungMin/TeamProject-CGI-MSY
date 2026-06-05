<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myPage.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">

		<h2 class="section-title">마이페이지</h2>

		<c:if test="${not empty sessionScope.restrictMsg}">
			<script>alert("${sessionScope.restrictMsg}");</script>
			<% session.removeAttribute("restrictMsg"); %>
		</c:if>

		<c:if test="${user.riskScore > 0}">
			<div class="card is-myPage-1">
				<strong>누적 신고 점수:</strong> <fmt:formatNumber value="${user.riskScore}" pattern="0.0"/>점
				<span class="is-myPage-2">
					(3점: 7일 제한 / 5점: 30일 제한 / 8점: 전체 제한 / 10점: 자동 탈퇴)
				</span>
			</div>
		</c:if>

		<div class="card">

			<!-- 프로필 사진 -->
			<div class="is-myPage-3">
				<c:choose>
					<c:when test="${not empty profileImage}">
						<img src="${profileImage.filePath}" class="is-myPage-4">
					</c:when>
					<c:otherwise>
						<div class="is-myPage-5">사진 없음</div>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="is-myPage-6">
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
					<div class="is-myPage-7">
						<div class="is-myPage-8">동네
							인증 상태</div>
						<div class="is-myPage-9">
							<i class="fa-solid fa-circle-check"></i> 인증 완료
							(${loginUser.verifiedArea})
						</div>
					</div>
				</c:if>

				<c:if test="${empty loginUser.verifiedArea}">
					<div class="is-myPage-10">
						<div class="is-myPage-11">동네
							인증 상태</div>
						<div class="is-myPage-12">
							아직 동네인증을 하지 않은 유저입니다.
							<button type="button" class="btn btn-secondary"
								onclick="verifyLocation()">지금 인증하기</button>
						</div>
					</div>
				</c:if>
			</div>
			<div class="is-myPage-13">
				<a href="${ctx}/users/edit/${user.userNo}" class="btn btn-primary">내
					정보 수정</a> <a href="${ctx}/mypage/account" class="btn btn-primary">계좌
					정보 ${empty user.userAccountNumber ? '등록' : '수정'}</a> <a
					href="${ctx}/order/pending" class="btn btn-primary">거래 관리</a>

				<c:if test="${not empty transferRequests}">
					<div class="is-myPage-14">
						<h3 class="section-title">계좌 거래 요청</h3>

						<c:forEach var="r" items="${transferRequests}">
							<div class="card is-myPage-15">

								<div>
									<div class="is-myPage-16">${r.productName}</div>
									<div class="is-myPage-17">요청자 :
										${r.buyerNickname}</div>
								</div>

								<form action="${ctx}/order/transfer/approve" method="post" class="is-myPage-18">
									<input type="hidden" name="orderNo" value="${r.orderNo}">
									<button class="btn btn-primary">승인</button>
								</form>
							</div>
						</c:forEach>
					</div>
				</c:if>

				<c:url value="/users/delete/${user.userNo}" var="deleteUrl" />

				<form:form action="${deleteUrl}" method="DELETE"
					onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
					<button type="submit" class="btn btn-danger">회원 탈퇴</button>
				</form:form>
			</div>
		</div>

		<!-- 내 직거래 (예약중) 미니 섹션 -->
		<c:if test="${not empty myReservedDirects}">
			<div class="is-myPage-19">
				<div class="is-myPage-20">
					<h3 class="is-myPage-21">
						내 직거래 <span class="is-myPage-22">
							${fn:length(myReservedDirects)}건 예약중 </span>
					</h3>
					<a href="${ctx}/order/pending" class="is-myPage-23">거래 관리 &gt;</a>
				</div>
				<div class="is-myPage-24">
					<c:forEach var="d" items="${myReservedDirects}">
						<c:set var="role"
							value="${d.buyerNo == user.userNo ? '구매' : '판매'}" />
						<c:set var="link"
							value="${d.buyerNo == user.userNo ? ctx.concat('/order/direct/reserved/').concat(d.orderNo) : ctx.concat('/order/pending')}" />
						<a href="${link}" class="is-myPage-25">
							<span class="is-myPage-26">
								${role} </span>
							<div class="is-myPage-27">
								<div class="is-myPage-28">
									${d.productName}</div>
								<div class="is-myPage-29">
									<c:if test="${not empty d.meetingTime}">
										<fmt:formatDate value="${d.meetingTime}" pattern="MM/dd HH:mm" />
									</c:if>
									<c:if test="${not empty d.meetingPlace}">
										· ${d.meetingPlace}
									</c:if>
								</div>
							</div> <span class="is-myPage-30">›</span>
						</a>
					</c:forEach>
				</div>
			</div>
		</c:if>


		<div class="is-myPage-31">
			<h3 class="section-title is-myPage-32">내가
				등록한 상품</h3>
			<a href="${ctx}/product/mylist" class="is-myPage-33">전체보기
				&gt;</a>
		</div>

		<c:if test="${empty myProducts}">
			<div class="card is-myPage-34">등록한
				상품이 없습니다.</div>
		</c:if>

		<c:forEach var="p" items="${myProducts}">
			<div class="card is-myPage-35">
				<a href="${ctx}/product/${p.productNo}" class="is-myPage-36">
					<span class="btn is-myPage-37 ${p.tradeStatus == '완료' ? 'is-myPage-37-done' : ''}">
						${p.tradeStatus} </span>
					<div>
						<div class="is-myPage-38">${p.productName}</div>
						<div class="is-myPage-39">
							<fmt:formatNumber value="${p.price}" />
							원
						</div>
					</div>
				</a>

				<div class="is-myPage-40">
					<a href="${ctx}/product/${p.productNo}/edit" class="btn is-myPage-41">수정</a>

					<button type="button" class="btn btn-danger is-myPage-42"
						onclick="deleteProduct('${p.productNo}')">삭제</button>
				</div>
			</div>

		</c:forEach>


		<div class="is-myPage-43">
			<h3 class="section-title is-myPage-44">
				구매 내역 <span class="is-myPage-45">(${totalBought})</span>
			</h3>
			<a href="${ctx}/mypage/bought" class="is-myPage-46">전체보기
				&gt;</a>
		</div>
		<div class="card">
			<c:choose>
				<c:when test="${not empty boughtList}">
					<div class="product-grid is-myPage-47">

						<c:forEach var="item" items="${boughtList}">
							<div class="product-item is-myPage-48"
								onclick="location.href='${ctx}/product/${item.productNo}'">

								<div class="product-img is-myPage-49">
									<c:choose>
										<c:when test="${not empty item.imgPath}">
											<img src="${item.imgPath}"
												onerror="this.onerror=null;this.src='https://via.placeholder.com/150?text=No+Image';" class="is-myPage-50">
										</c:when>
										<c:otherwise>
											<span class="is-myPage-51">이미지 없음</span>
										</c:otherwise>
									</c:choose>
								</div>

								<div class="is-myPage-52">
									<div class="is-myPage-53">
										${item.productName}</div>
									<div class="is-myPage-54">
										<fmt:formatNumber value="${item.price}" pattern="#,###" />
										원
									</div>
									<div class="is-myPage-55">
										거래 완료</div>
								</div>
							</div>
						</c:forEach>

					</div>
				</c:when>

				<c:otherwise>
					<div class="is-myPage-56">
						구매한 내역이 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 받은 후기 -->
		<div class="is-myPage-57">
			<h3 class="section-title is-myPage-58">
				받은 후기 <span class="is-myPage-59">(${totalMyReviews})</span>
			</h3>
			<a href="${ctx}/mypage/reviews" class="is-myPage-60">전체보기
				&gt;</a>
		</div>
		<c:choose>
			<c:when test="${empty myReviews}">
				<div class="card is-myPage-61">아직
					받은 후기가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="r" items="${myReviews}">
					<div class="card is-myPage-62">
						<div class="is-myPage-63">
							<span class="is-myPage-64">${r.productName}</span>
							<span class="is-myPage-65"> <fmt:formatDate
									value="${r.createdTime}" pattern="yyyy.MM.dd" />
							</span>
						</div>
						<div class="is-myPage-66">${r.content}</div>
						<div class="is-myPage-67">
							작성자: ${r.sellerNickname}</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<!-- 가계부 (최근 5건) -->
		<div class="is-myPage-68">
			<h3 class="section-title is-myPage-69">가계부</h3>
			<a href="${ctx}/accountList" class="is-myPage-70">전체보기
				&gt;</a>
		</div>
		<c:choose>
			<c:when test="${empty accountList}">
				<div class="card is-myPage-71">구매
					완료된 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div class="is-myPage-72">
					<c:forEach var="a" items="${accountList}">
						<div class="card">
							<div class="is-myPage-73">
								<div>
									<div class="is-myPage-74">${a.productName}</div>
									<div class="is-myPage-75">
										<fmt:formatDate value="${a.createdTime}" pattern="yyyy.MM.dd" />
									</div>
								</div>
								<div class="is-myPage-76">
									<fmt:formatNumber value="${a.price}" />
									원
								</div>
							</div>
							<c:if test="${not empty a.memo}">
								<div class="is-myPage-77">${a.memo}</div>
							</c:if>
							<c:if test="${empty a.memo}">
								<div class="is-myPage-78">메모
									없음</div>
							</c:if>
						</div>
					</c:forEach>
				</div>

			</c:otherwise>
		</c:choose>
		<%-- 신고 내역 섹션 (최근 5건) --%>
		<div class="is-myPage-79">
			<h3 class="section-title is-myPage-80">
				내 신고 내역 <span class="is-myPage-81">(${fn:length(myReports)})</span>
			</h3>
			<a href="${ctx}/mypage/reports" class="is-myPage-82">전체보기 &gt;</a>
		</div>
		<c:choose>
			<c:when test="${empty myReports}">
				<div class="card is-myPage-83">신고 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div class="card">
					<table class="is-myPage-84">
						<thead>
							<tr class="is-myPage-85">
								<th class="is-myPage-86">신고번호</th>
								<th class="is-myPage-87">신고유형</th>
								<th class="is-myPage-88">신고사유</th>
								<th class="is-myPage-89">상태</th>
								<th class="is-myPage-90">소명상태</th>
								<th class="is-myPage-91">소명</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="r" items="${myReports}" end="4">
								<tr class="is-myPage-92">
									<td class="is-myPage-93">${r.reportNo}</td>
									<td class="is-myPage-94">${r.targetType}</td>
									<td class="is-myPage-95">${r.reasonType}</td>
									<td class="is-myPage-96">${r.status}</td>
									<td class="is-myPage-97"><c:choose>
											<c:when test="${empty r.appealStatus || r.appealStatus == '미제출'}">
												<span class="is-myPage-98">미제출</span>
											</c:when>
											<c:when test="${r.appealStatus == '검토중'}">
												<span class="is-myPage-99">검토중</span>
											</c:when>
											<c:otherwise>
												<span class="is-myPage-100">${r.appealStatus}</span>
											</c:otherwise>
										</c:choose></td>
									<td class="is-myPage-101"><c:choose>
											<c:when test="${empty r.appealContent}">
												<a href="${ctx}/appeal/${r.reportNo}" class="btn btn-primary is-myPage-102">소명 작성</a>
											</c:when>
											<c:otherwise>
												<a href="${ctx}/appeal/${r.reportNo}" class="btn btn-line is-myPage-103">소명 확인</a>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</c:otherwise>
		</c:choose>

	</div>
	<script>
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