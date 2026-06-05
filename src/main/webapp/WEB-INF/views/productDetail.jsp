<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${product.productName}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productDetail.css">
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="detail-container">
		<div class="card">
			<div class="detail-top">
				<div class="detail-image">
					<div class="main-image">
						<c:if test="${not empty product.imgPath}">
							<img id="mainImage" src="${product.imgPath}">
						</c:if>
						<c:if test="${empty product.imgPath}">
							<span class="is-productDetail-1">이미지 없음</span>
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

				<div class="detail-info">
					<div class="report-line">
						<div class="product-status">${product.tradeStatus == '판매중' ? '판매중' : product.tradeStatus == '예약중' ? '예약중' : '판매완료'}</div>
						<c:if test="${not empty reserverNickname}">
							<span class="is-productDetail-2">예약자: ${reserverNickname}</span>
						</c:if>
						<c:if
							test="${not empty loginUser && loginUser.userNo != product.sellerNo}">
							<button type="button" class="btn btn-danger"
								onclick="openReportModal('product', ${product.productNo})">신고</button>
						</c:if>
					</div>
					<div class="product-title">${product.productName}</div>
					<div class="product-price">
						<fmt:formatNumber value="${product.price}" />
						원
					</div>

					<div class="seller-profile-box">
						<div class="seller-info-left">
							<div class="is-productDetail-3">
								<a href="${ctx}/users/search/${product.sellerNo}"
									class="seller-name-link"> ${product.sellerNickname} </a> <span class="is-productDetail-4">판매자 프로필 보기</span>

								<c:choose>
									<c:when test="${not empty seller.verifiedArea}">
										<span class="is-productDetail-5">${seller.verifiedArea}</span>
									</c:when>
									<c:otherwise>
										<span class="is-productDetail-6">동네
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
									<span class="is-productDetail-7">본인 상품은
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

								<%-- 본인이 입금 대기 중 -> 입금 안내로 --%>
								<c:when
									test="${not empty myOrder && myOrder.orderStatus == '입금대기'}">
									<a href="${ctx}/order/waiting/${myOrder.orderNo}"
										class="btn-order">입금 안내 보기</a>
								</c:when>

								<%-- 본인이 거래 요청 보낸 상태 -> 승인 대기 안내 --%>
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

								<%-- 그 외 --%>
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
							<div class="is-productDetail-8">
								<a class="btn btn-line"
									href="${ctx}/product/${product.productNo}/edit">수정</a>
								<form action="${ctx}/product/${product.productNo}/delete"
									method="post" class="is-productDetail-9">
									<button type="submit" class="btn btn-danger"
										onclick="return confirm('삭제하시겠습니까?')">삭제</button>
								</form>
							</div>
						</c:if>
					</div>
				</div>
			</div>
			<div class="card is-productDetail-10">

				<div class="is-productDetail-11">
					<h3 class="section-title is-productDetail-12">
						AI 품질 검증 및 시세 비교</h3>
					<button type="button" class="btn btn-primary is-productDetail-13" id="btnAiAnalyze"
						onclick="startAiAnalysis()">
						AI 품질 비교·분석 시작</button>
				</div>

				<div id="aiLoading" class="is-productDetail-14">
					<div class="spinner"></div>
					<p class="is-productDetail-15">AI가
						실시간으로 이미지 상태, 본문 신뢰도, 시장 시세를 분석 중입니다...</p>
				</div>

				<div id="aiResultArea" class="is-productDetail-16">
					<table class="is-productDetail-17">
						<tr class="is-productDetail-18">
							<th class="is-productDetail-19">외관 상태 등급</th>
							<th class="is-productDetail-20">리스크 탐지</th>
							<th class="is-productDetail-21">재판매 가치</th>
						</tr>
						<tr class="is-productDetail-22">
							<td class="is-productDetail-23"><span
								id="resGrade" class="is-productDetail-24">-</span>
							</td>
							<td class="is-productDetail-25">
								<span id="resRisk" class="is-productDetail-26">-</span>
							</td>
							<td class="is-productDetail-27">
								<span id="resValue">-</span>
							</td>
						</tr>
					</table>

					<div class="is-productDetail-28">

						<div class="is-productDetail-29">
							<strong class="is-productDetail-30">이미지 분석</strong>
							<div class="is-productDetail-31">
								상태 설명 : <span id="resImgCondition">-</span><br> 훼손/스크래치 : <span
									id="resImgDamage">-</span><br> 외관 등급 : <span
									id="resImgGrade" class="is-productDetail-32">-</span>
							</div>
						</div>

						<div class="is-productDetail-33">
							<strong class="is-productDetail-34">텍스트 분석</strong>
							<div class="is-productDetail-35">
								과장 여부 : <span id="resTxtExag">-</span><br> 신뢰도 : <span
									id="resTxtTrust" class="is-productDetail-36">-</span><br>
								도용 가능성 : <span id="resTxtPlag">-</span>
							</div>
						</div>

						<div class="is-productDetail-37">
							<strong class="is-productDetail-38">시세 비교 (네이버 쇼핑 기반)</strong>
							<div id="resSimList" class="is-productDetail-39">-</div>
						</div>
					</div>

					<div class="is-productDetail-40">
						<strong> AI 분석 총평 :</strong> <span id="resComment">-</span>
					</div>
				</div>
			</div>
			<div class="card is-productDetail-41" id="commentSection">
				<h3 class="section-title">댓글</h3>

				<%-- 댓글 목록 --%>
				<div id="commentList">
					<c:choose>
						<c:when test="${empty comments}">
							<div class="is-productDetail-42">아직 댓글이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="c" items="${comments}">
								<div class="comment-item is-productDetail-43">

									<c:if test="${c.parentCommentNo > 0}">
										<span class="is-productDetail-44">↳</span>
									</c:if>

									<span class="comment-author is-productDetail-45"> ${empty c.nickname ? '익명' : c.nickname}
									</span>
									<c:if test="${c.isSecret == 1}">
										<span class="is-productDetail-46">🔒
											비밀댓글</span>
									</c:if>
									<span class="comment-date is-productDetail-47">${c.createdTime}</span>

									<c:choose>
										<c:when
											test="${c.isSecret == 1 && loginUser.userNo != c.authorNo && loginUser.userNo != product.sellerNo && loginUser.userRole != 'ROLE_ADMIN'}">
											<div class="comment-content is-productDetail-48">비밀
												댓글입니다.</div>
										</c:when>
										<c:otherwise>
											<div class="comment-content is-productDetail-49">${c.content}</div>
										</c:otherwise>
									</c:choose>
									<c:if test="${c.authorNo == loginUser.userNo}">
										<div id="editForm_${c.commentNo}" class="comment-edit-form">
											<form action="${ctx}/comment/${c.commentNo}/edit"
												method="post">
												<input type="hidden" name="boardNo"
													value="${product.productNo}">
												<div class="is-productDetail-50">
													<textarea name="content" class="form-input is-productDetail-51"
														required>${c.content}</textarea>
													<button type="submit" class="btn btn-primary is-productDetail-52">저장</button>
													<button type="button" class="btn is-productDetail-53"
														onclick="toggleEditForm(${c.commentNo})">취소</button>
												</div>
											</form>
										</div>
									</c:if>

									<div class="is-productDetail-54">
										<c:if
											test="${c.authorNo == loginUser.userNo || loginUser.userRole == 'ROLE_ADMIN'}">
											<c:if test="${c.authorNo == loginUser.userNo}">
												<button type="button"
													onclick="toggleEditForm(${c.commentNo})" class="is-productDetail-55">수정</button>
											</c:if>
											<form
												action="${ctx}/comment/${c.commentNo}/delete#commentSection"
												method="post" class="is-productDetail-56">
												<input type="hidden" name="boardNo"
													value="${product.productNo}">
												<button type="submit"
													onclick="return confirm('삭제하시겠습니까?')" class="is-productDetail-57">삭제</button>
											</form>
										</c:if>

										<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
											<button type="button"
												onclick="toggleReplyForm(${c.commentNo})" class="is-productDetail-58">답글</button>
										</c:if>
									</div>

									<c:if test="${not empty loginUser && c.parentCommentNo == 0}">
										<div id="replyForm_${c.commentNo}" class="is-productDetail-59">
											<form action="${ctx}/comment/add#commentSection"
												method="post">
												<input type="hidden" name="boardNo"
													value="${product.productNo}"> <input type="hidden"
													name="targetType" value="PRODUCT"> <input
													type="hidden" name="parentCommentNo" value="${c.commentNo}">
												<textarea name="content" class="form-input is-productDetail-60"
													placeholder="답글을 입력하세요" required></textarea>

												<div class="is-productDetail-61">
													<label class="is-productDetail-62">
														<input type="checkbox" name="isSecret" value="1">비밀답글
													</label>
													<button type="submit" class="btn btn-primary is-productDetail-63">등록</button>
												</div>
											</form>
										</div>
									</c:if>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<c:choose>
					<c:when test="${empty loginUser}">
						<div class="is-productDetail-64">
							<a href="${ctx}/login">댓글을 작성하려면 로그인이 필요합니다.</a>
						</div>
					</c:when>
					<c:otherwise>
						<form action="${ctx}/comment/add#commentSection" method="post" class="is-productDetail-65">
							<input type="hidden" name="boardNo" value="${product.productNo}">
							<input type="hidden" name="targetType" value="PRODUCT"> <input
								type="hidden" name="parentCommentNo" value="0">
							<textarea class="form-input is-productDetail-66" name="content"
								placeholder="댓글을 입력하세요" required></textarea>
							<div class="is-productDetail-67">
								<label class="is-productDetail-68">
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
	<%@ include file="/WEB-INF/views/reportModal.jsp"%>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    var ctx = "${ctx}";
    var productNo = parseInt("${product.productNo}") || 0;

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
                $("#favIcon").removeClass("fa-regular").addClass("fa-solid");
                countEl.textContent = count + 1;
            } else if (result === "removed") {
                $("#favIcon").removeClass("fa-solid").addClass("fa-regular");
                countEl.textContent = Math.max(0, count - 1);
            }
        });
    }

    function slideThumb(dir) {
        var list = document.getElementById('thumbList');
        list.scrollBy({ left : dir * 80, behavior : 'smooth' });
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
        if (formEl.style.display === 'block') {
            formEl.style.display = 'none';
        } else {
            formEl.style.display = 'block';
            formEl.querySelector('textarea').focus();
        }
    }

    function toggleWaitlist() {
        var btn = document.getElementById('waitlistBtn');
        if (!btn) return;
        var url = btn.classList.contains('waiting') ? ctx + '/waitlist/remove' : ctx + '/waitlist/add';

        $.post(url, { productNo : productNo }, function(result) {
            if (result === 'login') { alert('로그인이 필요합니다.'); location.href = ctx + '/login'; return; }
            if (result === 'self') { alert('본인 상품에는 대기 신청할 수 없습니다.'); return; }
            if (result === 'notreserved') { alert('예약중 상품에만 대기 신청할 수 있습니다.'); location.reload(); return; }
            if (result === 'notfound') { alert('상품을 찾을 수 없습니다.'); return; }

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

    function startAiAnalysis() {
        var pNo = parseInt("${product.productNo}") || 0;
        var pDesc = String(`${product.description}`).trim();
        if (!pDesc || pDesc === "undefined") {
            pDesc = "등록된 상세 설명이 없습니다.";
        }

        $("#btnAiAnalyze").prop("disabled", true).text("분석 진행 중...");
        $("#aiResultArea").hide();
        $("#aiLoading").html(
            '<div class="spinner"></div>' +
            '<p class="is-productDetail-69">AI가 실시간으로 이미지 상태, 본문 신뢰도, 시장 시세를 분석 중입니다...</p>'
        ).fadeIn(300);

        $.ajax({
            url : ctx + "/product/ai/analyze",
            type : "POST",
            data : { productNo : pNo, description : pDesc },
            dataType : "text",
            success : function(data) {
                try {
                    var startIndex = data.indexOf("{");
                    var endIndex = data.lastIndexOf("}");
                    if (startIndex === -1 || endIndex === -1) {
                        throw new Error("올바른 JSON 형식을 찾을 수 없습니다.");
                    }
                    var response = JSON.parse(data.substring(startIndex, endIndex + 1));

                    if (response.error) {
                        alert(response.error);
                        $("#aiLoading").hide();
                        $("#btnAiAnalyze").prop("disabled", false).text("AI 품질 비교·분석 시작");
                        return;
                    }

                    var img = response.imageAnalysis || {};
                    var txt = response.textAnalysis || {};
                    var con = response.conclusion || {};
                    var simList = con.similarProductInfo || [];
                    if (!Array.isArray(simList)) simList = [];

                    var won = function(v) {
                        var n = String(v == null ? "" : v).replace(/[^0-9]/g, "");
                        return (n && n !== "0") ? Number(n).toLocaleString() : "-";
                    };

                    $("#resGrade").text(con.grade || "-");
                    $("#resRisk").text(con.risk || "-");
                    $("#resValue").text(con.resaleGrade || "-");
                    $("#resComment").text(con.comment || "-");
                    $("#resImgCondition").text(img.condition || "-");
                    $("#resImgDamage").text(img.damage || "-");
                    $("#resImgGrade").text(img.grade || "-");
                    $("#resTxtExag").text(txt.exaggeration || "-");
                    $("#resTxtTrust").text(txt.trustScore ? (txt.trustScore + "점") : "-");
                    $("#resTxtPlag").text(txt.plagiarismRisk || "-");

                    $("#resSimList").empty();
                    if (simList.length === 0) {
                        $("#resSimList").text("유사 상품을 찾지 못했습니다.");
                    } else {
                        simList.forEach(function(p) {
                            var row = $('<div class="is-productDetail-70"></div>');
                            var a = $('<a target="_blank" rel="noopener" class="is-productDetail-71"></a>')
                                .attr("href", p.link || "#").text(p.name || "상품");
                            var price = $('<span class="is-productDetail-72"></span>').text(won(p.price));
                            row.append(a).append("<br>").append(price).append(" 원");
                            $("#resSimList").append(row);
                        });
                    }

                    $("#aiLoading").hide();
                    $("#aiResultArea").fadeIn(500);
                    $("#btnAiAnalyze").prop("disabled", false).html('<i class="fa-solid fa-arrows-rotate"></i> AI 품질 재분석하기');

                } catch (jsonError) {
                    $("#aiLoading").html('<p class="is-productDetail-73">AI 데이터를 화면에 표시하는 중 오류가 발생했습니다.</p>');
                    $("#btnAiAnalyze").prop("disabled", false).text("AI 품질 비교·분석 시작");
                }
            },
            error : function(xhr, status, error) {
                $("#aiLoading").html('<p class="is-productDetail-74">서버 응답 에러가 발생했습니다. (Status: ' + xhr.status + ')</p>');
                $("#btnAiAnalyze").prop("disabled", false).text("AI 품질 비교·분석 시작");
            }
        });
    }
</script>
</body>
</html>