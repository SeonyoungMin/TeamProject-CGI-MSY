<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소명 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/appeal.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp"%>

    <div class="app-container">
        <div class="card">
            <h2 class="section-title">소명 작성</h2>

            <div class="is-appeal-1">
                <div><strong>신고 번호:</strong> ${report.reportNo}</div>
                <div><strong>신고 유형:</strong> ${report.targetType}</div>
                <div><strong>신고 사유:</strong> ${report.reasonType}</div>
                <div><strong>신고 상태:</strong> ${report.status}</div>
            </div>

            <c:choose>
                <c:when test="${not empty report.appealContent}">
                    <div class="is-appeal-2">
                        <strong>제출된 소명 내용:</strong>
                        <p id="appealText" class="is-appeal-3">${report.appealContent}</p>
                        <span class="is-appeal-4">상태: ${report.appealStatus}</span>
                    </div>
                    <c:if test="${not empty appealImages}">
                        <div class="is-appeal-5">
                            <strong>첨부된 증빙 자료:</strong>
                            <ul class="is-appeal-6">
                                <c:forEach var="img" items="${appealImages}" varStatus="st">
                                    <li>
                                        <a href="${img.filePath}" target="_blank">증빙자료 ${st.index + 1} - ${img.fileName}</a>
                                        <br/><img src="${img.filePath}" class="is-appeal-7" />
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <c:if test="${report.appealStatus == '검토중'}">
                        <div id="editArea" class="is-appeal-8">
                            <form action="${ctx}/appeal/${report.reportNo}" method="post" enctype="multipart/form-data">
                                <label class="form-label">소명 내용 수정</label>
                                <textarea class="form-input" name="appealContent" required>${report.appealContent}</textarea>

                                <label class="form-label is-appeal-9">증빙 자료 추가</label>
                                <input type="file" name="appealFiles" multiple accept="image/*" class="is-appeal-10" />
                                <p class="is-appeal-11">새로 선택한 이미지가 추가됩니다.</p>

                                <div class="is-appeal-12">
                                    <button type="button" class="btn" onclick="document.getElementById('editArea').style.display='none'">취소</button>
                                    <button type="submit" class="btn btn-primary">수정 제출</button>
                                </div>
                            </form>
                        </div>
                        <div class="is-appeal-13">
                            <a href="${ctx}/mypage" class="btn">돌아가기</a>
                            <button type="button" class="btn btn-primary" onclick="document.getElementById('editArea').style.display='block'">수정하기</button>
                        </div>
                    </c:if>
                    <c:if test="${report.appealStatus != '검토중'}">
                        <div class="is-appeal-14">
                            <a href="${ctx}/mypage" class="btn">돌아가기</a>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <form action="${ctx}/appeal/${report.reportNo}" method="post" enctype="multipart/form-data">
                        <label class="form-label">소명 내용</label>
                        <textarea class="form-input" name="appealContent"
                            placeholder="소명 내용을 입력해주세요." required></textarea>

                        <label class="form-label is-appeal-15">증빙 자료 (사진 업로드)</label>
                        <input type="file" name="appealFiles" multiple accept="image/*" class="is-appeal-16" />
                        <p class="is-appeal-17">여러 장의 이미지를 선택할 수 있습니다. (jpg, png 등)</p>

                        <div class="is-appeal-18">
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