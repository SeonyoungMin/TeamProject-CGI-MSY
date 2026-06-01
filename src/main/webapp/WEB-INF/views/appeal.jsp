<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소명 작성</title>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp"%>

    <div class="app-container">
        <div class="card">
            <h2 class="section-title">소명 작성</h2>

            <div style="margin-bottom: 20px; padding: 16px; background: #fafafa; border-radius: 8px; border: 1px solid #eee; font-size: 14px; line-height: 1.8;">
                <div><strong>신고 번호:</strong> ${report.reportNo}</div>
                <div><strong>신고 유형:</strong> ${report.targetType}</div>
                <div><strong>신고 사유:</strong> ${report.reasonType}</div>
                <div><strong>신고 상태:</strong> ${report.status}</div>
            </div>

            <c:choose>
                <c:when test="${not empty report.appealContent}">
                    <div style="padding: 16px; background: #f0f8ff; border-radius: 8px; border: 1px solid #cce5ff; font-size: 14px;">
                        <strong>제출된 소명 내용:</strong>
                        <p style="margin-top: 8px;">${report.appealContent}</p>
                        <span style="font-size: 12px; color: #888;">상태: ${report.appealStatus}</span>
                    </div>
                </c:when>
                <c:otherwise>
                    <form action="${ctx}/appeal/${report.reportNo}" method="post">
                        <label class="form-label">소명 내용</label>
                        <textarea class="form-input" name="appealContent" 
                            placeholder="소명 내용을 입력해주세요." required></textarea>
                        <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 10px;">
                            <a href="${ctx}/mypage" class="btn">취소</a>
                            <button type="submit" class="btn btn-primary">소명 제출</button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>