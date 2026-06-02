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

            <div style="padding: 16px; background: #fafafa; border-radius: 8px; border: 1px solid #eee; font-size: 14px; margin-bottom: 20px;">
                <strong>소명 내용:</strong>
                <p style="margin-top: 8px; line-height: 1.8;">${report.appealContent}</p>
                <span style="font-size: 12px; color: #888;">소명 상태: ${report.appealStatus}</span>
            </div>

            <div style="padding: 16px; background: #fafafa; border-radius: 8px; border: 1px solid #eee; font-size: 14px; margin-bottom: 20px;">
                <strong>증빙 자료:</strong>
                <c:choose>
                    <c:when test="${not empty appealImages}">
                        <ul style="margin-top: 8px; padding-left: 20px;">
                            <c:forEach var="img" items="${appealImages}" varStatus="st">
                                <li>
                                    <a href="${img.filePath}" target="_blank">증빙자료 ${st.index + 1} - ${img.fileName}</a>
                                    <br/>
                                    <img src="${img.filePath}" style="max-width: 300px; max-height: 200px; margin-top: 6px; border: 1px solid #ddd; border-radius: 4px;" />
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p style="margin-top: 8px; color: #888;">첨부된 증빙 자료가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <a href="${ctx}/admin/reports" class="btn">신고 목록</a>
                <c:if test="${report.appealStatus == '검토중'}">
                    <form action="${ctx}/admin/reports/${report.reportNo}/appeal/done" method="post" style="margin: 0;">
                        <input type="hidden" name="result" value="approve" />
                        <button type="submit" class="btn btn-primary"
                            onclick="return confirm('소명을 승인하시겠습니까? (점수가 차감됩니다)')">승인</button>
                    </form>
                    <form action="${ctx}/admin/reports/${report.reportNo}/appeal/done" method="post" style="margin: 0;">
                        <input type="hidden" name="result" value="reject" />
                        <button type="submit" class="btn btn-danger"
                            onclick="return confirm('소명을 거절하시겠습니까?')">거절</button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>