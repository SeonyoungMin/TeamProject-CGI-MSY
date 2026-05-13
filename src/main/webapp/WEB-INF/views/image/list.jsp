<%@ page contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<html>
<head>
<title>Image List</title>
</head>
<body>

	<h2>이미지 목록</h2>


	<a href="${pageContext.request.contextPath}/images/uploadForm">업로드로
		이동</a>

	<hr>

	<c:forEach var="img" items="${images}">

		<div
			style="margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px;">

			<img src="${img.filePath}" width="200" />

			<p>파일명: ${img.fileName}</p>


			<p>썸네일 여부: ${img.thumbnail ? '대표 이미지' : '일반'}</p>

			<c:choose>

				<c:when test="${img.thumbnail}">
					<a
						href="${pageContext.request.contextPath}/images/thumbnail/cancel?entityType=${entityType}&entityId=${entityId}">
						대표 해제 </a>
				</c:when>
				<c:otherwise>
					<a
						href="${pageContext.request.contextPath}/images/thumbnail?imageNo=${img.imageNo}&entityType=${entityType}&entityId=${entityId}">
						대표 설정 </a>
				</c:otherwise>
			</c:choose>


			<form action="${pageContext.request.contextPath}/images/delete"
				method="post" style="display: inline;"
				onsubmit="return confirm('정말 삭제하시겠습니까?');">
				<input type="hidden" name="imageNo" value="${img.imageNo}">
				<input type="hidden" name="entityType" value="${entityType}">
				<input type="hidden" name="entityId" value="${entityId}">
				<button type="submit">삭제</button>
			</form>

		</div>

	</c:forEach>

</body>
</html>