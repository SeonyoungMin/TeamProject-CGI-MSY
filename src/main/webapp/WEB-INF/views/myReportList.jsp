<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 신고 내역</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="app-container">
		<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
			<h2 class="section-title" style="margin: 0; border-bottom: none;">내 신고 내역 (${totalReports})</h2>
			<a href="${ctx}/mypage" class="btn" style="font-size: 13px;">마이페이지</a>
		</div>

		<div class="card">
			<table style="width: 100%; border-collapse: collapse; font-size: 14px;">
				<thead>
					<tr style="background: #f5f5f5;">
						<th style="padding: 10px; border-bottom: 2px solid #ddd; text-align: center;">신고번호</th>
						<th style="padding: 10px; border-bottom: 2px solid #ddd; text-align: center;">신고유형</th>
						<th style="padding: 10px; border-bottom: 2px solid #ddd; text-align: center;">신고사유</th>
						<th style="padding: 10px; border-bottom: 2px solid #ddd; text-align: center;">상태</th>
						<th style="padding: 10px; border-bottom: 2px solid #ddd; text-align: center;">소명상태</th>
						<th style="padding: 10px; border-bottom: 2px solid #ddd; text-align: center;">소명</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty reports}">
							<tr><td colspan="6" style="padding: 30px; text-align: center; color: #888;">신고 내역이 없습니다.</td></tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="r" items="${reports}">
								<tr style="border-bottom: 1px solid #eee;">
									<td style="padding: 10px; text-align: center;">${r.reportNo}</td>
									<td style="padding: 10px; text-align: center;">${r.targetType}</td>
									<td style="padding: 10px; text-align: center;">${r.reasonType}</td>
									<td style="padding: 10px; text-align: center;">${r.status}</td>
									<td style="padding: 10px; text-align: center;"><c:choose>
											<c:when test="${empty r.appealStatus || r.appealStatus == '미제출'}">
												<span style="color: #e74c3c;">미제출</span>
											</c:when>
											<c:when test="${r.appealStatus == '검토중'}">
												<span style="color: #f39c12;">검토중</span>
											</c:when>
											<c:otherwise>
												<span style="color: #27ae60;">${r.appealStatus}</span>
											</c:otherwise>
										</c:choose></td>
									<td style="padding: 10px; text-align: center;"><c:choose>
											<c:when test="${empty r.appealContent}">
												<a href="${ctx}/appeal/${r.reportNo}" class="btn btn-primary"
													style="font-size: 12px; padding: 4px 10px;">소명 작성</a>
											</c:when>
											<c:otherwise>
												<a href="${ctx}/appeal/${r.reportNo}" class="btn btn-line"
													style="font-size: 12px; padding: 4px 10px;">소명 확인</a>
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
			<div style="display: flex; justify-content: center; gap: 6px; margin-top: 20px;">
				<c:if test="${currentPage > 1}">
					<a href="${ctx}/mypage/reports?page=${currentPage - 1}" class="btn" style="padding: 6px 12px; font-size: 13px;">이전</a>
				</c:if>
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="${ctx}/mypage/reports?page=${i}" class="btn"
						style="padding: 6px 12px; font-size: 13px; ${i == currentPage ? 'background:#121212; color:#fff;' : ''}">${i}</a>
				</c:forEach>
				<c:if test="${currentPage < totalPages}">
					<a href="${ctx}/mypage/reports?page=${currentPage + 1}" class="btn" style="padding: 6px 12px; font-size: 13px;">다음</a>
				</c:if>
			</div>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
