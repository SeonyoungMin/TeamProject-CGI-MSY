<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 후기 테스트</title>
</head>
<body>
	<h3>구매 후기</h3>
	<hr>

	<!-- 후기 등록 폼 -->
	<h4>후기 등록</h4>
	<form action="/minimarket/review" method="post">
		<input type="hidden" name="productNo" value="30001">
		<div>
			<textarea name="content" rows="5" cols="40" placeholder="후기를 입력하세요" required></textarea>
		</div>
		<button type="submit">등록</button>
	</form>
	<hr>

	<!-- 후기 목록 (마이페이지용) -->
	<h4>내가 쓴 후기 목록</h4>
	<c:choose>
		<c:when test="${empty reviewList}">
			<p>작성한 후기가 없습니다.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="r" items="${reviewList}">
				<div>
					<span>${r.productName}</span>
					&nbsp;|&nbsp;
					<span>${r.sellerNickname}</span>
					&nbsp;|&nbsp;
					<span><fmt:formatDate value="${r.createdTime}" pattern="yyyy-MM-dd"/></span>
					<br>
					<span>${r.content}</span>
					<br>

					<!-- 수정 폼 -->
					<form action="/minimarket/review/${r.boardNo}" method="post">
						<input type="hidden" name="_method" value="PUT">
						<textarea name="content" rows="3" cols="40">${r.content}</textarea>
						<button type="submit">수정</button>
					</form>

					<!-- 삭제 폼 -->
					<form action="/minimarket/review/${r.boardNo}" method="post" style="display:inline;">
						<input type="hidden" name="_method" value="DELETE">
						<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
					</form>
				</div>
				<hr>
			</c:forEach>
		</c:otherwise>
	</c:choose>

	<!-- 상품 상세 페이지용 후기 조회 -->
	<h4>상품 후기</h4>
	<c:choose>
		<c:when test="${empty review}">
			<p>등록된 후기가 없습니다.</p>
		</c:when>
		<c:otherwise>
			<div>
				<span>${review.sellerNickname}</span>
				&nbsp;|&nbsp;
				<span><fmt:formatDate value="${review.createdTime}" pattern="yyyy-MM-dd"/></span>
				<br>
				<span>${review.content}</span>
			</div>
		</c:otherwise>
	</c:choose>

</body>
</html>
