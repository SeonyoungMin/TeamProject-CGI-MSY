<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title>댓글 수정</title>
</head>
<body>
	<h2>댓글 수정하기</h2>
	<form id="updateForm">
		<input type="hidden" id="commentNo" value="${comment.commentNo}">
		<textarea id="content" rows="5" cols="50">${comment.content}</textarea>
		<br>
		<button type="button" onclick="submitUpdate()">수정 완료</button>
		<button type="button" onclick="history.back()">취소</button>
	</form>

	<script>
        function submitUpdate() {
            const commentNo = document.getElementById("commentNo").value;
            const content = document.getElementById("content").value;

       
            fetch(`${pageContext.request.contextPath}/comments/\${commentNo}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ content: content })
            })
            .then(res => {
                if(res.ok) {
                    alert("수정되었습니다.");
                    location.href = `${pageContext.request.contextPath}/comments?boardNo=${comment.boardNo}`;
                }
            });
        }
    </script>
</body>
</html>