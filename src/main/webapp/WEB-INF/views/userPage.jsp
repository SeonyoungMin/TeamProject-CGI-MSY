<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${user.userNickName}님의프로필</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/userPage.css">
</head>

<%@ include file="/WEB-INF/views/reportModal.jsp"%>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">
		<c:if test="${not empty loginUser && loginUser.userNo != user.userNo}">
			<div class="is-userPage-1">
				<button type="button" class="btn btn-danger"
					onclick="openReportModal('user', ${user.userNo})">신고</button>
			</div>
		</c:if>

		<div class="profile-section">
			<div class="is-userPage-2">
				<c:choose>
					<c:when test="${not empty profileImage}">
						<img src="${profileImage.filePath}" class="is-userPage-3">
					</c:when>
					<c:otherwise>
						<div class="is-userPage-4">사진 없음</div>
					</c:otherwise>
				</c:choose>
			</div>
			<div>
				<h2 class="is-userPage-5">${user.userNickName}</h2>
				<div class="is-userPage-6">등급:
					${user.userRole}</div>

				<c:if test="${sessionScope.loginUser.userRole == 'ROLE_ADMIN'}">
					<div class="is-userPage-7">
						<a href="${ctx}/users/edit/${user.userNo}" class="btn">회원 정보
							수정</a>
						<form action="${ctx}/users/delete/${user.userNo}" method="post"
							onsubmit="return confirm('정말 이 회원을 삭제하시겠습니까?');" class="is-userPage-8">
							<input type="hidden" name="_method" value="DELETE">
							<button type="submit" class="btn btn-danger">회원 삭제</button>
						</form>
					</div>
				</c:if>
			</div>
		</div>

		<div id="productList" class="section-header">
			<span class="section-title">판매 상품 <span class="item-count">(${totalMyProducts})</span></span>
		</div>

		<c:choose>
			<c:when test="${empty myProducts}">
				<div class="is-userPage-9">
					등록된 상품이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<div class="product-grid">
					<c:forEach var="p" items="${myProducts}">
						<a href="${ctx}/product/${p.productNo}" class="product-card">
							<c:choose>
								<c:when test="${not empty p.imgPath}">
									<img src="${p.imgPath}">
								</c:when>
								<c:otherwise>
									<div class="is-userPage-10">이미지
										없음</div>
								</c:otherwise>
							</c:choose> <c:if test="${p.tradeStatus == '완료'}">
								<div class="sold-overlay">
									<span class="sold-badge">판매완료</span>
								</div>
							</c:if> <c:if test="${p.tradeStatus == '예약중'}">
								<div class="sold-overlay">
									<span class="sold-badge">예약중</span>
								</div>
							</c:if>

							<div class="product-info">
								<div class="product-name">${p.productName}</div>
								<div class="product-price">
									<fmt:formatNumber value="${p.price}" pattern="#,###" />
									원
								</div>
							</div>
						</a>
					</c:forEach>
				</div>

				<c:if test="${totalProductPages > 1}">
					<div class="pagination is-userPage-11">
						<c:forEach var="i" begin="1" end="${totalProductPages}">
							<a
								href="${ctx}/users/search/${user.userNo}?productPage=${i}&page=${currentPage}#productList" class="is-userPage-12">
								${i} </a>
						</c:forEach>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>

		<div class="review-container is-userPage-13">
			<div class="section-header is-userPage-14">
				<span class="section-title is-userPage-15"> 거래 후기 <span
					class="item-count is-userPage-16">(${reviews.size()})</span>
				</span>
			</div>
			<c:choose>
				<c:when test="${not hasBought || allReviewed}">
					<!-- 				<div class="is-userPage-17">
						이 판매자의 상품을 구매한 경우에만 후기를 작성할 수 있습니다.</div> -->
				</c:when>
				<c:when test="${alreadyReviewed}">
					<div class="card is-userPage-18">
						<h4 class="is-userPage-19">이미
							후기를 쓴 상품입니다.</h4>
						<p class="is-userPage-20">한
							상품에는 한 번만 후기를 작성할 수 있습니다.</p>
						<a href="#reviewList" class="is-userPage-21">
							내 후기 보러가기</a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="card is-userPage-22">
						<h4 class="is-userPage-23">이
							판매자에게 후기 남기기</h4>
						<form action="${ctx}/review/add" method="post">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}"> <input type="hidden"
								name="sellerNo" value="${user.userNo}">

							<c:if test="${not empty selectedProductNo}">
								<p class="is-userPage-24">[선택된 상품 번호:
									${selectedProductNo}]에 대한 후기를 작성 중입니다.</p>
							</c:if>
							<div class="is-userPage-25">
								<label class="is-userPage-26">상품
									번호</label> <input type="number" name="productNo"
									value="${not empty selectedProductNo ? selectedProductNo : (not empty myProducts ? myProducts[0].productNo : '')}"
									required class="is-userPage-27">
							</div>
							<div class="is-userPage-28">

								<textarea name="content" rows="4"
									placeholder="거래 후기를 입력하세요" required class="is-userPage-29">${prevContent}</textarea>
							</div>
							<div class="is-userPage-30">
								<button type="submit" class="btn btn-primary is-userPage-31">
									후기 등록</button>
							</div>
						</form>
					</div>
				</c:otherwise>
			</c:choose>

			<hr class="is-userPage-32">

			<div id="reviewList">
				<c:choose>
					<c:when test="${empty reviews}">
						<div class="is-userPage-33">작성된
							후기가 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="r" items="${reviews}">
							<div class="review-item is-userPage-34">
								<div class="is-userPage-35">
									<span class="is-userPage-36">${r.productName}</span>
									<span class="is-userPage-37"> <fmt:formatDate
											value="${r.createdTime}" pattern="yyyy.MM.dd" />
									</span>
								</div>
								<div class="is-userPage-38">${r.content}</div>
								<div class="is-userPage-39">
									<div class="is-userPage-40">작성자:
										${r.sellerNickname}</div>

									<c:if
										test="${not empty loginUser && r.authorNo == loginUser.userNo}">
										<div class="is-userPage-41">
											<%-- 수정 버튼: 후기 삭제 후 기존 내용 채운 폼 열기 --%>
											<form action="${ctx}/review/${r.boardNo}/edit" method="post" class="is-userPage-42">
												<input type="hidden" name="sellerNo" value="${user.userNo}">
												<input type="hidden" name="productNo" value="${r.productNo}">
												<input type="hidden" name="content" value="${r.content}">
												<button type="submit" class="btn is-userPage-43"
													onclick="return confirm('후기를 수정하시겠습니까?')">수정</button>
											</form>
											<form action="${ctx}/review/${r.boardNo}/delete"
												method="post" class="is-userPage-44">
												<input type="hidden" name="sellerNo" value="${user.userNo}">
												<input type="hidden" name="productNo" value="${r.productNo}">
												<input type="hidden" name="content" value="${r.content}">
												<button type="submit" class="btn btn-danger is-userPage-45"
													onclick="return confirm('후기를 삭제하시겠습니까?')">삭제</button>
											</form>
										</div>
									</c:if>
								</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="pagination is-userPage-46">
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="${ctx}/users/search/${user.userNo}?page=${i}#reviewList" class="is-userPage-47">
						${i} </a>
				</c:forEach>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
	<%@ include file="/WEB-INF/views/reportModal.jsp"%>
</body>
</html>