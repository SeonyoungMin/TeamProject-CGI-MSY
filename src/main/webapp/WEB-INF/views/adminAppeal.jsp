<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소명 내용</title>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp"%>

    <div class="app-container">
        <div class="card">
            <h2 class="section-title">소명 내용</h2>

            <div style="margin-bottom: 20px; padding: 16px; background: #fafafa; border-radius: 8px; border: 1px solid #eee; font-size: 14px; line-height: 1.8;">
                <div><strong>신고 번호:</strong> ${report.reportNo}</div>
                <div><strong>피신고자:</strong> ${report.accusedNickname}</div>
                <div><strong>신고 유형:</strong> ${report.targetType}</div>
                <div><strong>신고 사유:</strong> ${report.reasonType}</div>
                <div><strong>상태:</strong> ${report.status}</div>
            </div>

            <div style="padding: 16px; background: #f0f8ff; border-radius: 8px; border: 1px solid #cce5ff; font-size: 14px; margin-bottom: 20px;">
                <strong>소명 내용:</strong>
                <p style="margin-top: 8px; line-height: 1.8;">${report.appealContent}</p>
                <span style="font-size: 12px; color: #888;">소명 상태: ${report.appealStatus}</span>
            </div>

            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <a href="${ctx}/admin/reports" class="btn">← 신고 목록</a>
                <c:if test="${report.appealStatus == '검토중'}">
                    <form action="${ctx}/admin/reports/${report.reportNo}/appeal/done" method="post" style="margin: 0;">
                        <button type="submit" class="btn btn-primary"
                            onclick="return confirm('소명 처리를 완료하시겠습니까?')">처리완료</button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>