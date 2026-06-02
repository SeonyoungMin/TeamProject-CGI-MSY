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
	max-width: 1300px;
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
	table-layout: fixed;
}

.report-table th {
	background: #f5f5f5;
	padding: 12px;
	text-align: center;
	border-bottom: 2px solid #ddd;
	font-weight: bold;
	color: #333;
}

.report-table td {
	padding: 12px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
	text-align: center;
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
	padding: 40px 0;
	color: #bbb;
	font-size: 15px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="report-container">
		<h2 class="section-title">신고 관리</h2>

		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
			<div class="tab-bar" style="margin-bottom: 0;">
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
			<select onchange="location.href=this.value"
				style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; cursor: pointer;">
				<option value="${ctx}/admin/reports"
					${empty selectedStatus ? 'selected' : ''}>전체</option>
				<option value="${ctx}/admin/reports?status=대기"
					${'대기' eq selectedStatus ? 'selected' : ''}>대기</option>
				<option value="${ctx}/admin/reports?status=처리완료"
					${'처리완료' eq selectedStatus ? 'selected' : ''}>처리완료</option>
			</select>
		</div>

		<table class="report-table">
			<thead>
				<tr>
					<th>번호</th>
					<th>신고일</th>
					<th>신고 유형</th>
					<th>신고 대상</th>
					<th>피신고자</th>
					<th>신고 사유</th>
					<th>위험 점수</th>
					<th>누적 점수</th>
					<th>위험 등급</th>
					<th>소명</th>
					<th>상태</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty reports}">
						<tr>
							<td colspan="12" class="empty-msg">신고 내역이 없습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="r" items="${reports}">
							<tr>
								<td>${r.reportNo}</td>
								<td>${r.createdTime.toString().substring(0, 10)}</td>
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
								<td>${r.accusedNickname}</td>
								<td>
									<div>
										<c:choose>
											<c:when test="${r.reasonType == 'SCAM_ACCOUNT'}">사기계좌 사용</c:when>
											<c:when test="${r.reasonType == 'FRAUD'}">허위 정보</c:when>
											<c:when test="${r.reasonType == 'FALSE_LISTING'}">허위매물</c:when>
											<c:when test="${r.reasonType == 'DUPLICATE'}">중복 게시</c:when>
											<c:when test="${r.reasonType == 'ABUSE'}">욕설/비방</c:when>
											<c:when test="${r.reasonType == 'SPAM'}">스팸</c:when>
											<c:when test="${r.reasonType == 'RULE_VIOLATION'}">규정 위반</c:when>
											<c:when test="${r.reasonType == 'ETC'}">기타</c:when>
											<c:otherwise>${r.reasonType}</c:otherwise>
										</c:choose>
									</div> <c:if test="${not empty r.reasonDetail}">
										<div style="font-size: 12px; color: #888; margin-top: 3px;">${r.reasonDetail}</div>
									</c:if>
								</td>
								<%-- 위험 점수: 건별 ai_score --%>
								<td><c:choose>
										<c:when test="${r.aiScore >= 0.8}">
											<span class="ai-high">${r.aiScore}</span>
										</c:when>
										<c:when test="${r.aiScore >= 0.5}">
											<span class="ai-suspicious">${r.aiScore}</span>
										</c:when>
										<c:otherwise>
											<span class="ai-clean">${r.aiScore}</span>
										</c:otherwise>
									</c:choose></td>
								<%-- 누적 점수 --%>
								<td><c:set var="riskScore" value="${r.userRiskScore}" /> <fmt:formatNumber
										value="${riskScore}" pattern="0.0" var="formattedRisk" /> <c:choose>
										<c:when test="${riskScore >= 1.0}">
											<span class="ai-high"><fmt:formatNumber
													value="${riskScore}" pattern="0.0" /></span>
										</c:when>
										<c:when test="${riskScore >= 0.5}">
											<span class="ai-suspicious"><fmt:formatNumber
													value="${riskScore}" pattern="0.0" /></span>
										</c:when>
										<c:otherwise>
											<span class="ai-clean"><fmt:formatNumber
													value="${riskScore}" pattern="0.0" /></span>
										</c:otherwise>
									</c:choose></td>
								<%-- 위험 등급: 누적 점수 기준 --%>
								<td><c:choose>
										<c:when test="${r.userRiskScore >= 1.0}">
											<span class="ai-high">위험</span>
										</c:when>
										<c:when test="${r.userRiskScore >= 0.5}">
											<span class="ai-suspicious">주의</span>
										</c:when>
										<c:otherwise>
											<span class="ai-clean">안전</span>
										</c:otherwise>
									</c:choose></td>
								<td><c:choose>
										<c:when test="${empty r.appealContent}">
											<span style="color: #bbb; font-size: 12px;">미제출</span>
										</c:when>
										<c:otherwise>
											<a href="${ctx}/admin/reports/${r.reportNo}/appeal"
												style="font-size: 13px; color: #3498db;">소명 보기</a>
											<br>
											<span style="font-size: 11px; color: #888;">${r.appealStatus}</span>
										</c:otherwise>
									</c:choose></td>
								<td><span
									class="status-badge ${r.status == '대기' ? 'status-pending' : 'status-done'}">
										${r.status} </span></td>

								<td><c:choose>
										<c:when test="${r.status == '대기' and not empty r.appealContent and r.appealStatus == '검토중'}">
											<a href="${ctx}/admin/reports/${r.reportNo}/appeal"
												class="btn btn-primary" style="font-size: 12px; padding: 4px 10px;">소명 확인</a>
										</c:when>
										<c:otherwise>
											<form action="${ctx}/admin/reports/${r.reportNo}/process"
												method="post" style="margin: 0;">
												<c:if test="${not empty selectedType}">
													<input type="hidden" name="type" value="${selectedType}">
												</c:if>
												<c:choose>
													<c:when test="${r.status == '대기'}">
														<button type="submit" class="btn btn-primary"
															style="font-size: 12px; padding: 4px 10px;"
															onclick="return confirm('처리완료로 변경하시겠습니까?')">처리완료</button>
													</c:when>
													<c:otherwise>
														<input type="hidden" name="revert" value="true" />
														<button type="submit" class="btn"
															style="font-size: 12px; padding: 4px 10px;"
															onclick="return confirm('대기 상태로 되돌리시겠습니까?')">대기로 변경</button>
													</c:otherwise>
												</c:choose>
											</form>
										</c:otherwise>
									</c:choose></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<c:if test="${totalPages > 1}">
			<div style="display: flex; justify-content: center; gap: 6px; margin-top: 20px;">
				<c:if test="${currentPage > 1}">
					<a href="${ctx}/admin/reports?page=${currentPage - 1}${not empty selectedType ? '&type='.concat(selectedType) : ''}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}" class="btn" style="padding: 6px 12px; font-size: 13px;">이전</a>
				</c:if>
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="${ctx}/admin/reports?page=${i}${not empty selectedType ? '&type='.concat(selectedType) : ''}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}"
						class="btn" style="padding: 6px 12px; font-size: 13px; ${i == currentPage ? 'background:#121212; color:#fff;' : ''}">${i}</a>
				</c:forEach>
				<c:if test="${currentPage < totalPages}">
					<a href="${ctx}/admin/reports?page=${currentPage + 1}${not empty selectedType ? '&type='.concat(selectedType) : ''}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}" class="btn" style="padding: 6px 12px; font-size: 13px;">다음</a>
				</c:if>
			</div>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>