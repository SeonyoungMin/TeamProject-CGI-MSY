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
.detail-top { display:flex; gap:30px; align-items:flex-start; }
.detail-image { flex:1; }
.detail-info { flex:1; }
.main-image {
	width:100%; height:400px;
	background:#f3f3f3; border:1px solid #eee; border-radius:8px;
	display:flex; align-items:center; justify-content:center;
	overflow:hidden;
}
.main-image img { width:100%; height:100%; object-fit:cover; }
.thumb-list { display:flex; gap:8px; margin-top:10px; flex-wrap:wrap; }
.thumb-list img {
	width:70px; height:70px; object-fit:cover;
	border:1px solid #ddd; border-radius:4px; cursor:pointer;
}
.product-status {
	display:inline-block; padding:4px 10px;
	background:#121212; color:#fff;
	border-radius:4px; font-size:12px;
}
.product-title { font-size:24px; font-weight:bold; margin:10px 0; }
.product-price { font-size:28px; font-weight:bold; margin:20px 0; }
.product-meta { color:#666; font-size:14px; line-height:1.8; margin-bottom:20px; }
.desc-box {
	background:#f7f7f7; border-radius:6px;
	padding:15px; min-height:120px; white-space:pre-wrap;
}

/* 댓글 */
.comment-item {
	border-bottom:1px solid #eee;
	padding:12px 0;
}
.comment-author { font-weight:bold; }
.comment-date { font-size:12px; color:#999; margin-left:8px; }
.comment-content { margin:6px 0; white-space:pre-wrap; }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="app-container">

	<!-- 상품 영역 -->
	<div class="card">
		<div class="detail-top">

			<div class="detail-image">
				<div class="main-image">
					<c:if test="${not empty product.imgPath}">
						<img id="mainImage" src="${ctx}${product.imgPath}">
					</c:if>
					<c:if test="${empty product.imgPath}">
						<span style="color:#999;">이미지 없음</span>
					</c:if>
				</div>
				<c:if test="${not empty product.images}">
					<div class="thumb-list">
						<c:forEach var="img" items="${product.images}">
							<img src="${ctx}${img.filePath}" onclick="changeImage(this.src)">
						</c:forEach>
					</div>
				</c:if>
			</div>

			<div class="detail-info">
				<div class="product-status">
					${product.tradeStatus == 'SALE' ? '판매중' : product.tradeStatus == 'RESERVED' ? '예약중' : '판매완료'}
				</div>
				<div class="product-title">${product.productName}</div>
				<div class="product-price">
					<fmt:formatNumber value="${product.price}" />원
				</div>
				<div class="product-meta">
					판매자 : ${product.sellerNickname}<br>
					카테고리 : ${product.category}<br>
					등록일 : <fmt:formatDate value="${product.createdTime}" pattern="yyyy.MM.dd"/>
				</div>
				<div class="desc-box">${product.description}</div>

				<!-- 찜하기 / 수정 / 삭제 버튼 -->
				<div style="margin-top:20px; display:flex; gap:10px;">
					<c:if test="${not empty loginUser}">
						<button id="favBtn" type="button" class="btn btn-line" onclick="toggleFavorite()">
							${favorite ? '♥ 찜 취소' : '♡ 찜하기'}
						</button>
					</c:if>

					<c:if test="${not empty loginUser && loginUser.userNo == product.sellerNo}">
						<a class="btn btn-line" href="${ctx}/product/${product.productNo}/edit">수정</a>
						<form action="${ctx}/product/${product.productNo}/delete" method="post" style="margin:0;">
							<button type="submit" class="btn btn-danger" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
						</form>
					</c:if>
				</div>
			</div>

		</div>
	</div>

	<!-- 댓글 영역 -->
	<div class="card">
		<h3 class="section-title">댓글</h3>

		<c:if test="${empty loginUser}">
			<div style="color:#888;">댓글을 작성하려면 <a href="${ctx}/login">로그인</a>이 필요합니다.</div>
		</c:if>

		<c:if test="${not empty loginUser}">
			<form id="commentForm" style="margin-bottom:20px;">
				<input type="hidden" name="boardNo" value="${product.productNo}">
				<textarea class="form-input" name="content" placeholder="댓글을 입력하세요" required></textarea>
				<button type="submit" class="btn btn-primary">댓글 등록</button>
			</form>
		</c:if>

		<div id="commentList">
			<!-- jQuery $.get 으로 채워짐 -->
		</div>
	</div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>

<script>
	var ctx = "${ctx}";
	var productNo = ${product.productNo};
	var loginUserNo = ${empty loginUser ? 0 : loginUser.userNo};

	function changeImage(src) {
		document.getElementById("mainImage").src = src;
	}

	// ==== 댓글 ====
	function loadComments() {
		$.get(ctx + "/comment/list", { boardNo: productNo }, function(data) {
			var html = "";
			if (data.length === 0) {
				html = "<div style='color:#888;'>아직 댓글이 없습니다.</div>";
			} else {
				for (var i = 0; i < data.length; i++) {
					var c = data[i];
					html += "<div class='comment-item'>";
					html += "<span class='comment-author'>" + c.nickname + "</span>";
					html += "<span class='comment-date'>" + (c.createdTime || "") + "</span>";
					html += "<div class='comment-content'>" + $('<div>').text(c.content).html() + "</div>";
					if (loginUserNo !== 0 && c.authorNo === loginUserNo) {
						html += "<a class='btn' style='padding:4px 10px; font-size:12px;' href='" + ctx + "/comment/" + c.commentNo + "/edit'>수정</a> ";
						html += "<form action='" + ctx + "/comment/" + c.commentNo + "/delete' method='post' style='display:inline;'>";
						html += "<input type='hidden' name='boardNo' value='" + productNo + "'>";
						html += "<button type='submit' class='btn btn-danger' style='padding:4px 10px; font-size:12px;' onclick=\"return confirm('삭제하시겠습니까?')\">삭제</button>";
						html += "</form>";
					}
					html += "</div>";
				}
			}
			$("#commentList").html(html);
		});
	}

	$("#commentForm").on("submit", function(e) {
		e.preventDefault();
		var content = $(this).find("[name=content]").val();
		$.post(ctx + "/comment/add", { boardNo: productNo, content: content }, function() {
			$("#commentForm [name=content]").val("");
			loadComments();
		});
	});

	// ==== 찜하기 ====
	function toggleFavorite() {
		$.post(ctx + "/favorite/toggle", { boardNo: productNo }, function(result) {
			if (result === "added") {
				$("#favBtn").text("♥ 찜 취소");
			} else if (result === "removed") {
				$("#favBtn").text("♡ 찜하기");
			} else {
				alert("로그인이 필요합니다.");
			}
		});
	}

	// 초기 댓글 목록 로드
	$(function() { loadComments(); });
</script>

</body>
</html>
