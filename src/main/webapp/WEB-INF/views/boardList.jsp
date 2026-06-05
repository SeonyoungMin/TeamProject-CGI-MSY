<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="title" value="${empty boardTitle ? '게시판' : boardTitle}" />
<c:set var="type" value="${empty boardType ? 'all' : boardType}" />
<c:set var="listUrl" value="${empty listUrl ? '/board/all' : listUrl}" />
<c:set var="writeUrl"
	value="${type == 'notice' ? '/notice/addForm' : (type == 'free' ? '/freeBoard/addForm' : (type == 'inquiry' ? '/boardList/addForm' : '/board/write'))}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${title}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boardList.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="board-wrap">
		<h2>${title}</h2>

		<!-- 카테고리 탭 -->
		<nav class="board-tabs">
			<c:choose>

				<c:when test="${type == 'notice'}">
					<a href="${ctx}/notice" class="active">공지사항</a>
				</c:when>

				<c:otherwise>
					<a href="${ctx}/boardList"
						class="${type == 'inquiry' ? 'active' : ''}">문의</a>
					<a href="${ctx}/freeBoard"
						class="${type == 'free' ? 'active' : ''}">자유</a>
				</c:otherwise>
			</c:choose>
		</nav>

		<c:choose>
			<c:when test="${empty list}">
				<p class="is-boardList-1">등록된
					글이 없습니다.</p>
			</c:when>
			<c:otherwise>
				<c:forEach var="b" items="${list}">
					<div class="board-item">
						<a href="${ctx}/boardList/${b.boardNo}" class="title"> <c:if
								test="${b.pinned && b.boardType == 'notice'}">
								<i class="pin fa-solid fa-thumbtack"
									style="color: #c0392b; margin-right: 4px;"></i>
							</c:if> <c:choose>
								<c:when test="${b.boardType == 'notice'}">
									<span class="tag tag-notice">공지</span>
								</c:when>
								<c:when test="${b.boardType == 'free'}">
									<span class="tag tag-free">자유</span>
								</c:when>
								<c:otherwise>
									<span class="tag tag-inquiry">문의</span>
								</c:otherwise>
							</c:choose> ${b.title}
						</a><span class="meta">${b.authorNickname}</span> <span class="meta">
							<fmt:formatDate value="${b.createdTime}" pattern="MM.dd" />
						</span>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>

		<div class="write-btn-wrap">
			<c:choose>
				<c:when test="${type == 'inquiry' || type == 'all' || canWrite}">
					<a href="${ctx}${writeUrl}" class="btn btn-primary">글쓰기</a>
				</c:when>
			</c:choose>
		</div>

		<c:if test="${totalPages > 0}">
			<div class="pagination">
				<c:forEach var="i" begin="1" end="${totalPages}">
					<c:choose>
						<c:when test="${i == currentPage}">
							<strong>${i}</strong>
						</c:when>
						<c:otherwise>
							<a href="${ctx}${listUrl}?pageNum=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>