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
                    <div style="padding: 16px; background: #fafafa; border-radius: 8px; border: 1px solid #eee; font-size: 14px;">
                        <strong>제출된 소명 내용:</strong>
                        <p id="appealText" style="margin-top: 8px;">${report.appealContent}</p>
                        <span style="font-size: 12px; color: #888;">상태: ${report.appealStatus}</span>
                    </div>
                    <c:if test="${not empty appealImages}">
                        <div style="padding: 16px; background: #fafafa; border-radius: 8px; border: 1px solid #eee; font-size: 14px; margin-top: 12px;">
                            <strong>첨부된 증빙 자료:</strong>
                            <ul style="margin-top: 8px; padding-left: 20px;">
                                <c:forEach var="img" items="${appealImages}" varStatus="st">
                                    <li>
                                        <a href="${img.filePath}" target="_blank">증빙자료 ${st.index + 1} - ${img.fileName}</a>
                                        <br/><img src="${img.filePath}" style="max-width: 300px; max-height: 200px; margin-top: 6px; border: 1px solid #ddd; border-radius: 4px;" />
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <c:if test="${report.appealStatus == '검토중'}">
                        <div id="editArea" style="display: none; margin-top: 16px;">
                            <form action="${ctx}/appeal/${report.reportNo}" method="post" enctype="multipart/form-data">
                                <label class="form-label">소명 내용 수정</label>
                                <textarea class="form-input" name="appealContent" required>${report.appealContent}</textarea>

                                <label class="form-label" style="margin-top: 16px;">증빙 자료 추가</label>
                                <input type="file" name="appealFiles" multiple accept="image/*"
                                    style="display: block; margin-top: 6px; padding: 8px; border: 1px solid #ddd; border-radius: 6px; width: 100%; font-size: 14px;" />
                                <p style="font-size: 12px; color: #888; margin-top: 4px;">새로 선택한 이미지가 추가됩니다.</p>

                                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 10px;">
                                    <button type="button" class="btn" onclick="document.getElementById('editArea').style.display='none'">취소</button>
                                    <button type="submit" class="btn btn-primary">수정 제출</button>
                                </div>
                            </form>
                        </div>
                        <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 12px;">
                            <a href="${ctx}/mypage" class="btn">돌아가기</a>
                            <button type="button" class="btn btn-primary" onclick="document.getElementById('editArea').style.display='block'">수정하기</button>
                        </div>
                    </c:if>
                    <c:if test="${report.appealStatus != '검토중'}">
                        <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 12px;">
                            <a href="${ctx}/mypage" class="btn">돌아가기</a>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <form action="${ctx}/appeal/${report.reportNo}" method="post" enctype="multipart/form-data">
                        <label class="form-label">소명 내용</label>
                        <textarea class="form-input" name="appealContent"
                            placeholder="소명 내용을 입력해주세요." required></textarea>

                        <label class="form-label" style="margin-top: 16px;">증빙 자료 (사진 업로드)</label>
                        <input type="file" name="appealFiles" multiple accept="image/*"
                            style="display: block; margin-top: 6px; padding: 8px; border: 1px solid #ddd; border-radius: 6px; width: 100%; font-size: 14px;" />
                        <p style="font-size: 12px; color: #888; margin-top: 4px;">여러 장의 이미지를 선택할 수 있습니다. (jpg, png 등)</p>

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