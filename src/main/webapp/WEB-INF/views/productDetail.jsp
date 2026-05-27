<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${product.productName}</title>
<style>
.detail-container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.detail-top {
	display: flex;
	gap: 30px;
	align-items: flex-start;
}

.detail-image {
	flex: 1;
}

.detail-info {
	flex: 1;
}

.main-image {
	width: 100%;
	height: 400px;
	background: #f3f3f3;
	border: 1px solid #eee;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
}

.main-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.thumb-list-wrap {
	position: relative;
	margin-top: 10px;
	display: flex;
	align-items: center;
	justify-content: space-betwwen;
}

.thumb-list {
	width: 382px;
	flex-shrink: 0;
	display: flex;
	gap: 8px;
	overflow: hidden;
	margin: 0 auto;
}

.thumb-list img {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border: 1px solid #ddd;
	border-radius: 4px;
	cursor: pointer;
	flex-shrink: 0;
	transition: 0.2s;
}

.thumb-list img:hover {
	opacity: 0.8;
	border-color: #121212;
}

.thumb-slide-btn {
	flex-shrink: 0;
	width: 28px;
	height: 70px;
	cursor: pointer;
	font-size: 20px;
	background: none;
	border: none;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 0;
	z-index: 1;
}

/* .thumb-slide-btn:hover {
	background: #e0e0e0;
} */
.product-status {
	display: inline-block;
	padding: 4px 10px;
	background: #121212;
	color: #fff;
	border-radius: 4px;
	font-size: 12px;
}

.product-title {
	font-size: 24px;
	font-weight: bold;
	margin: 10px 0;
}

.product-price {
	font-size: 28px;
	font-weight: bold;
	margin: 20px 0;
	align-items: center;
	display: flex;
	justify-content: space-between;
}

.product-meta {
	color: #666;
	font-size: 14px;
	line-height: 1.8;
	margin-bottom: 20px;
	width: 100%;
}

.seller-profile-box {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 15px 0;
	border-top: 1px solid #eee;
	border-bottom: 1px solid #eee;
	margin: 20px 0;
}

.seller-info-left {
	display: flex;
	align-items: center;
	gap: 12px;
}

.seller-name-link {
	text-decoration: none;
	color: #121212;
	font-weight: bold;
	font-size: 16px;
}

.seller-name-link:hover {
	text-decoration: underline;
}

.btn-order {
	display: inline-flex;
	align-items: center;
	padding: 10px 20px;
	background-color: #ff9800;
	color: white !important;
	text-decoration: none;
	border-radius: 5px;
	font-weight: bold;
	font-size: 14px;
	box-sizing: border-box;
}

.btn-order:hover {
	background-color: #e68a00;
}

.btn-waitlist {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	padding: 10px 20px;
	background-color: #fff;
	color: #ff9800;
	border: 1px solid #ff9800;
	border-radius: 5px;
	font-weight: bold;
	font-size: 14px;
	cursor: pointer;
	box-sizing: border-box;
}

.btn-waitlist:hover {
	background-color: #fff7eb;
}

.btn-waitlist.waiting {
	background-color: #ff9800;
	color: #fff;
}

.btn-waitlist.waiting:hover {
	background-color: #e68a00;
}

.waitlist-count {
	font-size: 12px;
	color: #888;
	margin-left: 6px;
}

.status-msg {
	color: #888;
	font-size: 14px;
}

#favBtn {
	padding: 10px 10px;
	border-radius: 5px;
	font-size: 14px;
	box-sizing: border-box;
	gap: 4px;
}

.fav-area {
	margin-top: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.fav-count-wrap {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	font-size: 14px;
	color: #888;
}

.comment-edit-form {
	display: none;
	margin-top: 8px;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="detail-container">
		<!-- app-container 대신 더 넓은 detail-container 사용 -->
		<div class="card">
			<div class="detail-top">
				<!-- 이미지 섹션 -->
				<div class="detail-image">
					<div class="main-image">
						<c:if test="${not empty product.imgPath}">
							<img id="mainImage" src="${product.imgPath}">
						</c:if>
						<c:if test="${empty product.imgPath}">
							<span style="color: #999;">이미지 없음</span>
						</c:if>
					</div>
					<c:if test="${not empty product.images}">
						<div class="thumb-list-wrap">
							<button type="button" class="thumb-slide-btn"
								onclick="slideThumb(-1)">&#8249;</button>
							<div class="thumb-list" id="thumbList">
								<c:forEach var="img" items="${product.images}">
									<img src="${img.filePath}" onmouseover="changeImage(this.src)">
								</c:forEach>
							</div>
							<button type="button" class="thumb-slide-btn"
								onclick="slideThumb(1)">&#8250;</button>
						</div>
					</c:if>
				</div>

				<!-- 상품 정보 섹션 -->
				<div class="detail-info">
					<div class="product-status">${product.tradeStatus == '판매중' ? '판매중' : product.tradeStatus == '예약중' ? '예약중' : '판매완료'}
					</div>
					<div class="product-title">${product.productName}</div>
					<div class="product-price">
						<fmt:formatNumber value="${product.price}" />
						원
					</div>

					<div class="seller-profile-box">
						<div class="seller-info-left">
							<div style="display: flex; flex-direction: column;">
								<a href="${ctx}/users/search/${product.sellerNo}"
									class="seller-name-link"> ${product.sellerNickname} </a> <span
									style="font-size: 12px; color: #888;">판매자 프로필 보기</span>

								<c:choose>
									<c:when test="${not empty seller.verifiedArea}">
										<span style="font-size: 13px; color: #555; margin-top: 2px;">${seller.verifiedArea}</span>
									</c:when>
									<c:otherwise>
										<span style="font-size: 13px; color: #ccc; margin-top: 2px;">동네
											미인증</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>

					<div class="product-meta">
						카테고리 : ${product.category}<br> 등록일 :
						<fmt:formatDate value="${product.createdTime}"
							pattern="yyyy.MM.dd" />
						<br> 상품번호 : ${product.productNo}

						<div class="fav-area">
							<c:choose>
								<%-- 본인 상품 --%>
								<c:when
									test="${not empty loginUser && product.sellerNo == loginUser.userNo}">
									<span style="color: #e74c3c; font-size: 14px;">본인 상품은
										구매할 수 없습니다.</span>
								</c:when>

								<%-- 판매중: 구매하기 --%>
								<c:when test="${product.tradeStatus == '판매중'}">
									<a href="${ctx}/order/select?productNo=${product.productNo}"
										class="btn-order">구매하기</a>
								</c:when>

								<%-- 본인이 승인받은 거래 → 결제 진행 (예약중 분기보다 먼저!) --%>
								<c:when
									test="${not empty myOrder && myOrder.orderStatus == '승인완료'}">
									<a
										href="${ctx}/order/transfer/form?productNo=${product.productNo}"
										class="btn-order">결제 진행</a>
								</c:when>

								<%-- 본인이 입금 대기 중 → 입금 안내로 --%>
								<c:when
									test="${not empty myOrder && myOrder.orderStatus == '입금대기'}">
									<a href="${ctx}/order/waiting/${myOrder.orderNo}"
										class="btn-order">입금 안내 보기</a>
								</c:when>

								<%-- 본인이 거래 요청 보낸 상태 → 승인 대기 안내 --%>
								<c:when
									test="${not empty myOrder && myOrder.orderStatus == '요청'}">
									<span class="status-msg">판매자 승인 대기 중입니다.</span>
								</c:when>

								<%-- 예약중: 대기 신청/취소 (다른 사용자에게만) --%>
								<c:when test="${product.tradeStatus == '예약중'}">
									<c:choose>
										<c:when test="${alreadyWaitlisted}">
											<button type="button" id="waitlistBtn"
												class="btn-waitlist waiting" onclick="toggleWaitlist()">
												<i class="fa-solid fa-bell"></i> 대기 신청됨
											</button>
										</c:when>
										<c:otherwise>
											<button type="button" id="waitlistBtn" class="btn-waitlist"
												onclick="toggleWaitlist()">
												<i class="fa-regular fa-bell"></i> 예약 대기 신청
											</button>
										</c:otherwise>
									</c:choose>
									<span class="waitlist-count" id="waitlistCountLabel"> 대기
										<span id="waitlistCount">${waitlistCount}</span>명
									</span>
								</c:when>

								<%-- 그 외 (예: '취소' 등) --%>
								<c:otherwise>
									<span class="status-msg">현재 구매할 수 없는 상품입니다.</span>
								</c:otherwise>
							</c:choose>

							<c:if
								test="${not empty loginUser && product.sellerNo != loginUser.userNo}">
								<button id="favBtn" type="button" class="btn btn-line"
									onclick="toggleFavorite()">
									<i id="favIcon"
										class="${favorite ? 'fa-solid' : 'fa-regular'} fa-heart"
										style="color: #ff4d4d;"></i> <span id="favCount">${favoriteCount}</span>
								</button>
							</c:if>
						</div>

						<c:if
							test="${not empty loginUser && (loginUser.userNo == product.sellerNo || loginUser.userRole == 'ROLE_ADMIN')}">
							<div style="margin-top: 10px; display: flex; gap: 10px;">
								<a class="btn btn-line"
									href="${ctx}/product/${product.productNo}/edit">수정</a>
								<form action="${ctx}/product/${product.productNo}/delete"
									method="post" style="margin: 0; display: contents;">
									<button type="submit" class="btn btn-danger"
										onclick="return confirm('삭제하시겠습니까?')">삭제</button>
								</form>
							</div>
						</c:if>
					</div>
				</div>
			</div>

			<!-- 댓글 섹션 -->
			<div class="card" id="commentSection" style="margin-top: 40px;">
				<h3 class="section-title">댓글</h3>

				<%-- 댓글 목록 --%>
				<div id="commentList">
					<c:choose>
						<c:when test="${empty comments}">
							<div style="color: #999; padding: 10px 0;">아직 댓글이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="c" items="${comments}">
								<%-- 대댓글이면 들여쓰기 --%>
								<div class="comment-item"
									style="border-bottom: 1px solid #eee; padding: 10px 0;
									${c.parentCommentNo > 0 ? 'margin-left: 30px; background: #fafafa; padding-left: 12px; border-left: 3px solid #eee;' : ''}">

									<%-- 대댓글 표시 아이콘 --%>
									<c:if test="${c.parentCommentNo > 0}">
										<span style="color: #aaa; font-size: 13px; margin-right: 4px;">↳</span>
									</c:if>

									<span class="comment-author"
										style="font-weight: bold; font-size: 14px;"> ${empty c.nickname ? '익명' : c.nickname}
									</span>
									<c:if test="${c.isSecret == 1}">
										<span style="font-size: 11px; color: #888; margin-left: 4px;">🔒
											비밀댓글</span>
									</c:if>
									<span class="comment-date"
										style="font-size: 12px; color: #999; margin-left: 8px;">${c.createdTime}</span>

									<%-- 비밀댓글: 본인/판매자/관리자만 내용 표시 --%>
									<c:choose>
										<c:when
											test="${c.isSecret == 1 && loginUser.userNo != c.authorNo && loginUser.userNo != product.sellerNo && loginUser.userRole != 'ROLE_ADMIN'}">
											<div class="comment-content"
												style="margin: 5px 0; color: #aaa; font-style: italic;">비밀
												댓글입니다.</div>
										</c:when>
										<c:otherwise>
											<div class="comment-content" style="margin: 5px 0;">${c.content}</div>
										</c:otherwise>
									</c:choose>
									<c:if test="${c.authorNo == loginUser.userNo}">
										<div id="editForm_${c.commentNo}" class="comment-edit-form">
											<form action="${ctx}/comment/${c.commentNo}/edit"
												method="post">
												<input type="hidden" name="boardNo"
													value="${product.productNo}">
												<div
													style="display: flex; gap: 6px; align-items: flex-start;">
													<textarea name="content" class="form-input"
														style="flex: 1; height: 60px; margin: 0; font-size: 13px;"
														required>${c.content}</textarea>
													<button type="submit" class="btn btn-primary"
														style="padding: 6px 12px; font-size: 13px; white-space: nowrap;">저장</button>
													<button type="button" class="btn"
														style="padding: 6px 12px; font-size: 13px; white-space: nowrap;"
														onclick="toggleEditForm(${c.commentNo})">취소</button>
												</div>
											</form>
										</div>
									</c:if>

									<%-- 수정/삭제/답글 버튼 --%>
									<div style="display: flex; gap: 8px; margin-top: 4px;">
										<%-- 수정/삭제: 본인 또는 관리자 --%>
										<c:if
											test="${c.authorNo == loginUser.userNo || loginUser.userRole == 'ROLE_ADMIN'}">
											<c:if test="${c.authorNo == loginUser.userNo}">
												<button type="button"
													style="font-size: 12px; background: none; border: none; color: #888; cursor: pointer; padding: 0;"
													onclick="toggleEditForm(${c.commentNo})">수정</button>
											</c:if>
											<form action="${ctx}/comment/${c.commentNo}/delete#commentSection"
												method="post" style="margin: 0;">
												<input type="hidden" name="boardNo"
													value="${product.productNo}">
												<button type="submit"
													style="font-size: 12px; background: none; border: none; color: #e74c3c; cursor: pointer; padding: 0;"
													onclick="return confirm('삭제하시겠습니까?')">삭제</button>
											</form>
										</c:if>

										<%-- 답글 버튼: 로그인한 경우, 원댓글에만 표시 --%>
										<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
											<button type="button"
												style="font-size: 12px; background: none; border: none; color: #3498db; cursor: pointer; padding: 0;"
												onclick="toggleReplyForm(${c.commentNo})">답글</button>
										</c:if>
									</div>

									<%-- 대댓글 입력 폼 (답글 버튼 클릭 시 표시) --%>
									<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
										<div id="replyForm_${c.commentNo}"
											style="display: none; margin-top: 10px;">
											<form action="${ctx}/comment/add#commentSection" method="post">
												<input type="hidden" name="boardNo"
													value="${product.productNo}"> <input type="hidden"
													name="targetType" value="PRODUCT"> <input
													type="hidden" name="parentCommentNo" value="${c.commentNo}">
												<textarea name="content" class="form-input"
													style="flex: 1; height: 60px; margin: 0; font-size: 13px;"
													placeholder="답글을 입력하세요" required></textarea>

												<div
													style="display: flex; gap: 6px; align-items: flex-start; justify-content: space-between;">
													<label
														style="font-size: 12px; color: #555; cursor: pointer; white-space: nowrap;">
														<input type="checkbox" name="isSecret" value="1">비밀답글
													</label>
													<button type="submit" class="btn btn-primary"
														style="padding: 6px 12px; font-size: 13px; white-space: nowrap;">등록</button>
												</div>
											</form>
										</div>
									</c:if>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<%-- 댓글 등록 폼 --%>
				<c:choose>
					<c:when test="${empty loginUser}">
						<div style="color: #888; margin-top: 16px;">
							<a href="${ctx}/login">댓글을 작성하려면 로그인이 필요합니다.</a>
						</div>
					</c:when>
					<c:otherwise>
						<form action="${ctx}/comment/add#commentSection" method="post"
							style="margin-top: 20px;">
							<input type="hidden" name="boardNo" value="${product.productNo}">
							<input type="hidden" name="targetType" value="PRODUCT"> <input
								type="hidden" name="parentCommentNo" value="0">
							<textarea class="form-input" name="content"
								style="width: 100%; height: 80px; margin-bottom: 8px;"
								placeholder="댓글을 입력하세요" required></textarea>
							<div
								style="display: flex; justify-content: space-between; align-items: center;">
								<label style="font-size: 13px; color: #555; cursor: pointer;">
									<input type="checkbox" name="isSecret" value="1"> 비밀댓글
								</label>
								<button type="submit" class="btn btn-primary">댓글 등록</button>
							</div>
						</form>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		var ctx = "${ctx}";
		var productNo = $
		{
			product.productNo
		};

		function changeImage(src) {
			document.getElementById("mainImage").src = src;
		}

		function toggleFavorite() {
			$.post(ctx + "/favorite/toggle", {
				productNo : productNo
			}, function(result) {
				var countEl = document.getElementById('favCount');
				var count = parseInt(countEl.textContent) || 0;

				if (result === "added") {
					$("#favIcon").removeClass("fa-regular")
							.addClass("fa-solid");
					countEl.textContent = count + 1;
				} else if (result === "removed") {
					$("#favIcon").removeClass("fa-solid")
							.addClass("fa-regular");
					countEl.textContent = Math.max(0, count - 1);
				}
			});
		}

		function slideThumb(dir) {
			var list = document.getElementById('thumbList');
			list.scrollBy({
				left : dir * 80,
				behavior : 'smooth'
			});
		}

		function toggleReplyForm(commentNo) {
		    var formEl = document.getElementById('replyForm_' + commentNo);
		    if (formEl.style.display === 'none') {
		        formEl.style.display = 'block';
		        formEl.querySelector('textarea').focus();
		    } else {
		        formEl.style.display = 'none';
		    }
		}

		function toggleEditForm(commentNo) {
		    var formEl = document.getElementById('editForm_' + commentNo);
		    formEl.style.display = formEl.style.display === 'none' ? 'block' : 'none';
		}

		function toggleWaitlist() {
		    var btn = document.getElementById('waitlistBtn');
		    if (!btn) return;
		    var waiting = btn.classList.contains('waiting');
		    var url = waiting ? ctx + '/waitlist/remove' : ctx + '/waitlist/add';

		    $.post(url, { productNo : productNo }, function(result) {
		        if (result === 'login') {
		            alert('로그인이 필요합니다.');
		            location.href = ctx + '/login';
		            return;
		        }
		        if (result === 'self') {
		            alert('본인 상품에는 대기 신청할 수 없습니다.');
		            return;
		        }
		        if (result === 'notreserved') {
		            alert('예약중 상품에만 대기 신청할 수 있습니다.');
		            location.reload();
		            return;
		        }
		        if (result === 'notfound') {
		            alert('상품을 찾을 수 없습니다.');
		            return;
		        }

		        var countEl = document.getElementById('waitlistCount');
		        var count = parseInt(countEl.textContent) || 0;

		        if (result === 'added') {
		            btn.classList.add('waiting');
		            btn.innerHTML = '<i class="fa-solid fa-bell"></i> 대기 신청됨';
		            countEl.textContent = count + 1;
		        } else if (result === 'removed') {
		            btn.classList.remove('waiting');
		            btn.innerHTML = '<i class="fa-regular fa-bell"></i> 예약 대기 신청';
		            countEl.textContent = Math.max(0, count - 1);
		        }
		    }).fail(function() {
		        alert('처리 중 오류가 발생했습니다.');
		    });
		}
	</script>
</body>
</html>