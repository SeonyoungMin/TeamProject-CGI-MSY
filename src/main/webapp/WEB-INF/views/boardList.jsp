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
<style>
.board-wrap {
	max-width: 900px;
	margin: 30px auto;
	padding: 0 20px;
}

.board-tabs {
	display: flex;
	gap: 4px;
	margin-bottom: 16px;
	border-bottom: 1px solid #eee;
}

.board-tabs a {
	padding: 10px 18px;
	font-size: 14px;
	color: #777;
	text-decoration: none;
	border-bottom: 2px solid transparent;
}

.board-tabs a.active {
	color: #121212;
	font-weight: bold;
	border-bottom-color: #121212;
}

.board-tabs a:hover {
	color: #121212;
}

.board-item {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 12px 4px;
	border-bottom: 1px solid #f0f0f0;
	font-size: 14px;
}
 
.board-item .title {
	flex: 1;
	color: #222;
	text-decoration: none;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.board-item .title:hover {
	text-decoration: underline;
}

.board-item .meta {
	color: #888;
	font-size: 13px;
	white-space: nowrap;
}

.tag {
	display: inline-block;
	font-size: 11px;
	padding: 2px 6px;
	margin-right: 4px;
	border-radius: 2px;
	font-weight: 600;
}

.tag-notice {
	background: #fdecec;
	color: #c0392b;
}

.tag-inquiry {
	background: #eef3fb;
	color: #2c6ab1;
}

.tag-free {
	background: #f1f5ee;
	color: #5a7a3a;
}

.pin {
	color: #c0392b;
	margin-right: 4px;
}

.pagination {
	margin-top: 20px;
	text-align: center;
}

.pagination a, .pagination strong {
	display: inline-block;
	padding: 6px 12px;
	margin: 0 2px;
	border: 1px solid #ddd;
	border-radius: 4px;
	text-decoration: none;
	color: #555;
}

.pagination strong {
	background: #121212;
	color: #fff;
	border-color: #121212;
}

.write-btn-wrap {
	text-align: right;
	margin: 16px 0;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="board-wrap">
		<h2>${title}</h2>

		<!-- 카테고리 탭 -->
		<nav class="board-tabs">
			<a href="${ctx}/board/all" class="${type == 'all' ? 'active' : ''}">전체</a>
			<a href="${ctx}/notice" class="${type == 'notice' ? 'active' : ''}">공지</a>
			<a href="${ctx}/boardList"
				class="${type == 'inquiry' ? 'active' : ''}">문의</a> <a
				href="${ctx}/freeBoard" class="${type == 'free' ? 'active' : ''}">자유</a>
		</nav>

		<c:choose>
			<c:when test="${empty list}">
				<p style="color: #888; text-align: center; padding: 40px 0;">등록된
					글이 없습니다.</p>
			</c:when>
			<c:otherwise>
				<c:forEach var="b" items="${list}">
					<div class="board-item">
						<a href="${ctx}/boardList/${b.boardNo}" class="title"> <c:if
								test="${b.pinned}">
								<i class="pin fa-solid fa-thumbtack"></i>
							</c:if> <c:if test="${type == 'all'}">
								<c:choose>
									<c:when test="${b.boardType == 'notice'}">
										<span class="tag tag-notice">공지</span>
									</c:when>
									<c:when test="${b.boardType == 'free'}">
										<span class="tag tag-free">자유</span>
									</c:when>
									<c:otherwise>
										<span class="tag tag-inquiry">문의</span>
									</c:otherwise>
								</c:choose>
							</c:if> ${b.title}
						</a> <span class="meta">${b.authorNickname}</span> <span class="meta">
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
