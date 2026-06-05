<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소명 내용</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminAppeal.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp"%>
	<c:set var="ctx" value="${pageContext.request.contextPath}" />
	<div class="app-container">
        <div class="card">
            <h2 class="section-title">소명 내용</h2>

            <div class="is-adminAppeal-1">
                <div><strong>신고 번호:</strong> ${report.reportNo}</div>
                <div><strong>피신고자:</strong> ${report.accusedNickname}</div>
                <div><strong>신고 유형:</strong> ${report.targetType}</div>
                <div><strong>신고 사유:</strong> ${report.reasonType}</div>
                <div><strong>상태:</strong> ${report.status}</div>
                <div>소명상태: ${report.appealStatus}</div>
            </div>

            <div class="is-adminAppeal-2">
                <strong>소명 내용:</strong>
                <p class="is-adminAppeal-3">${report.appealContent}</p>
                <span class="is-adminAppeal-4">소명 상태: ${report.appealStatus}</span>
            </div>

            <div class="is-adminAppeal-5">
                <strong>증빙 자료:</strong>
                <c:choose>
                    <c:when test="${not empty appealImages}">
                        <ul class="is-adminAppeal-6">
                            <c:forEach var="img" items="${appealImages}" varStatus="st">
                                <li>
                                    <a href="${img.filePath}" target="_blank">증빙자료 ${st.index + 1} - ${img.fileName}</a>
                                    <br/>
                                    <img src="${img.filePath}" class="is-adminAppeal-7" />
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="is-adminAppeal-8">첨부된 증빙 자료가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="is-adminAppeal-9">
                <a href="${ctx}/admin/reports" class="btn">신고 목록</a>
                <c:if test="${report.appealStatus == '검토중'}">
                    <form action="${ctx}/admin/reports/${report.reportNo}/appeal/done" method="post" class="is-adminAppeal-10">
                        <input type="hidden" name="result" value="approve" />
                        <button type="submit" class="btn btn-primary"
                            onclick="return confirm('소명을 승인하시겠습니까? (점수가 차감됩니다)')">승인</button>
                    </form>
                    <form action="${ctx}/admin/reports/${report.reportNo}/appeal/done" method="post" class="is-adminAppeal-11">
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