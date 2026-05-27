<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 관리</title>
<style>
.report-container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.tab-bar {
	display: flex;
	gap: 8px;
	margin-bottom: 20px;
	border-bottom: 2px solid #eee;
	padding-bottom: 10px;
}

.tab-btn {
	padding: 8px 18px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #fff;
	color: #555;
	font-size: 14px;
	cursor: pointer;
	text-decoration: none;
}

.tab-btn.active {
	background: #121212;
	color: #fff;
	border-color: #121212;
}

.report-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 14px;
}

.report-table th {
	background: #f5f5f5;
	padding: 12px;
	text-align: left;
	border-bottom: 2px solid #ddd;
	font-weight: bold;
	color: #333;
}

.report-table td {
	padding: 12px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
}

.report-table tr:hover td {
	background: #fafafa;
}

.status-badge {
	display: inline-block;
	padding: 3px 10px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: bold;
}

.status-pending {
	background: #fff3cd;
	color: #856404;
}

.status-done {
	background: #d4edda;
	color: #155724;
}

.ai-high {
	color: #e74c3c;
	font-weight: bold;
}

.ai-suspicious {
	color: #e67e22;
	font-weight: bold;
}

.ai-clean {
	color: #27ae60;
}

.empty-msg {
	text-align: center;
	padding: 60px 0;
	color: #bbb;
	font-size: 15px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="report-container">
		<h2 class="section-title">신고 관리</h2>

		<%-- 탭 --%>
		<div class="tab-bar">
			<a href="${ctx}/admin/reports"
				class="tab-btn ${empty selectedType ? 'active' : ''}">전체</a> <a
				href="${ctx}/admin/reports?type=user"
				class="tab-btn ${'user' eq selectedType ? 'active' : ''}">유저 신고</a>
			<a href="${ctx}/admin/reports?type=product"
				class="tab-btn ${'product' eq selectedType ? 'active' : ''}">상품
				신고</a> <a href="${ctx}/admin/reports?type=board"
				class="tab-btn ${'board' eq selectedType ? 'active' : ''}">게시글
				신고</a>
		</div>

		<c:choose>
			<c:when test="${empty reports}">
				<div class="empty-msg">신고 내역이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<table class="report-table">
					<thead>
						<tr>
							<th>번호</th>
							<th>신고 유형</th>
							<th>신고 대상</th>
							<th>신고자</th>
							<th>신고 사유</th>
							<th>AI 점수</th>
							<th>AI 결과</th>
							<th>상태</th>
							<th>신고일</th>
							<th>처리</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="r" items="${reports}">
							<tr>
								<td>${r.reportNo}</td>
								<td><c:choose>
										<c:when test="${r.targetType == 'user'}">유저</c:when>
										<c:when test="${r.targetType == 'product'}">상품</c:when>
										<c:when test="${r.targetType == 'board'}">게시글</c:when>
										<c:otherwise>${r.targetType}</c:otherwise>
									</c:choose></td>
								<td><c:choose>
										<c:when test="${r.targetType == 'user'}">
											<a href="${ctx}/users/search/${r.targetNo}">${r.targetName}</a>
										</c:when>
										<c:when test="${r.targetType == 'product'}">
											<a href="${ctx}/product/${r.targetNo}">${r.targetName}</a>
										</c:when>
										<c:when test="${r.targetType == 'board'}">
											<a href="${ctx}/boardList/${r.targetNo}">${r.targetName}</a>
										</c:when>
										<c:otherwise>${r.targetName}</c:otherwise>
									</c:choose></td>
								<td>${r.reporterNickname}</td>
								<td>
									<div>${r.reasonType}</div> <c:if
										test="${not empty r.reasonDetail}">
										<div style="font-size: 12px; color: #888; margin-top: 3px;">${r.reasonDetail}</div>
									</c:if>
								</td>
								<td><c:choose>
										<c:when test="${r.aiScore >= 0.8}">
											<span class="ai-high"><fmt:formatNumber
													value="${r.aiScore}" pattern="0.0" /></span>
										</c:when>
										<c:when test="${r.aiScore >= 0.5}">
											<span class="ai-suspicious"><fmt:formatNumber
													value="${r.aiScore}" pattern="0.0" /></span>
										</c:when>
										<c:otherwise>
											<span class="ai-clean"><fmt:formatNumber
													value="${r.aiScore}" pattern="0.0" /></span>
										</c:otherwise>
									</c:choose></td>
								<td><c:choose>
										<c:when test="${r.aiResult == 'HIGH_RISK'}">
											<span class="ai-high">HIGH_RISK</span>
										</c:when>
										<c:when test="${r.aiResult == 'SUSPICIOUS'}">
											<span class="ai-suspicious">SUSPICIOUS</span>
										</c:when>
										<c:when test="${r.aiResult == 'CLEAN'}">
											<span class="ai-clean">CLEAN</span>
										</c:when>
										<c:otherwise>${r.aiResult}</c:otherwise>
									</c:choose></td>
								<td><span
									class="status-badge ${r.status == '대기' ? 'status-pending' : 'status-done'}">
										${r.status} </span></td>
								<td><fmt:formatDate value="${r.createdTime}"
										pattern="yyyy.MM.dd" /></td>
								<td><c:if test="${r.status == '대기'}">
										<form action="${ctx}/admin/reports/${r.reportNo}/process"
											method="post" style="margin: 0;">
											<c:if test="${not empty selectedType}">
												<input type="hidden" name="type" value="${selectedType}">
											</c:if>
											<button type="submit" class="btn btn-primary"
												style="font-size: 12px; padding: 4px 10px;"
												onclick="return confirm('처리완료로 변경하시겠습니까?')">처리완료</button>
										</form>
									</c:if></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:otherwise>
		</c:choose>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
