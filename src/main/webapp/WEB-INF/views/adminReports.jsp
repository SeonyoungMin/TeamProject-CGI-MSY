<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminReports.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="report-container">
		<h2 class="section-title">신고 관리</h2>

		<div class="is-adminReports-1">
			<div class="tab-bar is-adminReports-2">
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
			<select onchange="location.href=this.value" class="is-adminReports-3">
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
										<div class="is-adminReports-4">${r.reasonDetail}</div>
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
											<span class="is-adminReports-5">미제출</span>
										</c:when>
										<c:otherwise>
											<a href="${ctx}/admin/reports/${r.reportNo}/appeal" class="is-adminReports-6">소명 보기</a>
											<c:if test="${r.appealStatus == '검토중'}">
												<br><span class="is-adminReports-7">검토중</span>
											</c:if>
										</c:otherwise>
									</c:choose></td>
								<td><span
									class="status-badge ${r.status == '대기' ? 'status-pending' : 'status-done'}">
										${r.status} </span></td>

								<td><c:choose>
										<c:when test="${r.status == '대기' and not empty r.appealContent and r.appealStatus == '검토중'}">
											<a href="${ctx}/admin/reports/${r.reportNo}/appeal"
												class="btn btn-primary is-adminReports-8">소명 확인</a>
										</c:when>
										<c:otherwise>
											<form action="${ctx}/admin/reports/${r.reportNo}/process"
												method="post" class="is-adminReports-9">
												<c:if test="${not empty selectedType}">
													<input type="hidden" name="type" value="${selectedType}">
												</c:if>
												<c:choose>
													<c:when test="${r.status == '대기'}">
														<button type="submit" class="btn btn-primary is-adminReports-10"
															onclick="return confirm('처리완료로 변경하시겠습니까?')">처리완료</button>
													</c:when>
													<c:otherwise>
														<input type="hidden" name="revert" value="true" />
														<button type="submit" class="btn is-adminReports-11"
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
			<div class="is-adminReports-12">
				<c:if test="${currentPage > 1}">
					<a href="${ctx}/admin/reports?page=${currentPage - 1}${not empty selectedType ? '&type='.concat(selectedType) : ''}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}" class="btn is-adminReports-13">이전</a>
				</c:if>
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="${ctx}/admin/reports?page=${i}${not empty selectedType ? '&type='.concat(selectedType) : ''}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}"
						class="btn is-adminReports-14 ${i == currentPage ? 'page-active' : ''}">${i}</a>
				</c:forEach>
				<c:if test="${currentPage < totalPages}">
					<a href="${ctx}/admin/reports?page=${currentPage + 1}${not empty selectedType ? '&type='.concat(selectedType) : ''}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}" class="btn is-adminReports-15">다음</a>
				</c:if>
			</div>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>