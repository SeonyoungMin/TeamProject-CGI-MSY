<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 신고 내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myReportList.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">
		<div class="is-myReportList-1">
			<h2 class="section-title is-myReportList-2">내 신고 내역 (${totalReports})</h2>
			<a href="${ctx}/mypage" class="btn is-myReportList-3">마이페이지</a>
		</div>

		<div class="card">
			<table class="is-myReportList-4">
				<thead>
					<tr class="is-myReportList-5">
						<th class="is-myReportList-6">신고번호</th>
						<th class="is-myReportList-7">신고유형</th>
						<th class="is-myReportList-8">신고사유</th>
						<th class="is-myReportList-9">상태</th>
						<th class="is-myReportList-10">소명상태</th>
						<th class="is-myReportList-11">소명</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty reports}">
							<tr><td colspan="6" class="is-myReportList-12">신고 내역이 없습니다.</td></tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="r" items="${reports}">
								<tr class="is-myReportList-13">
									<td class="is-myReportList-14">${r.reportNo}</td>
									<td class="is-myReportList-15">${r.targetType}</td>
									<td class="is-myReportList-16">${r.reasonType}</td>
									<td class="is-myReportList-17">${r.status}</td>
									<td class="is-myReportList-18"><c:choose>
											<c:when test="${empty r.appealStatus || r.appealStatus == '미제출'}">
												<span class="is-myReportList-19">미제출</span>
											</c:when>
											<c:when test="${r.appealStatus == '검토중'}">
												<span class="is-myReportList-20">검토중</span>
											</c:when>
											<c:otherwise>
												<span class="is-myReportList-21">${r.appealStatus}</span>
											</c:otherwise>
										</c:choose></td>
									<td class="is-myReportList-22"><c:choose>
											<c:when test="${empty r.appealContent}">
												<a href="${ctx}/appeal/${r.reportNo}" class="btn btn-primary is-myReportList-23">소명 작성</a>
											</c:when>
											<c:otherwise>
												<a href="${ctx}/appeal/${r.reportNo}" class="btn btn-line is-myReportList-24">소명 확인</a>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>

		<c:if test="${totalPages > 1}">
			<div class="is-myReportList-25">
				<c:if test="${currentPage > 1}">
					<a href="${ctx}/mypage/reports?page=${currentPage - 1}" class="btn is-myReportList-26">이전</a>
				</c:if>
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="${ctx}/mypage/reports?page=${i}" class="btn is-myReportList-27">${i}</a>
				</c:forEach>
				<c:if test="${currentPage < totalPages}">
					<a href="${ctx}/mypage/reports?page=${currentPage + 1}" class="btn is-myReportList-28">다음</a>
				</c:if>
			</div>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
