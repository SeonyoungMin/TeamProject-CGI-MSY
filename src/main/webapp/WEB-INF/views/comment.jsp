<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title>댓글 관리</title>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	padding: 20px;
	line-height: 1.6;
}

.comment-item {
	border-bottom: 1px solid #eee;
	padding: 15px;
	margin-bottom: 10px;
	background: #f9f9f9;
	border-radius: 5px;
}

.author {
	font-weight: bold;
	color: #007bff;
}

.date {
	font-size: 0.8em;
	color: #999;
	margin-left: 10px;
}

.content {
	margin: 10px 0;
	white-space: pre-wrap;
}

.btn-group button {
	background: none;
	border: 1px solid #ccc;
	padding: 3px 8px;
	font-size: 12px;
	cursor: pointer;
	border-radius: 3px;
}

.btn-delete {
	color: #dc3545;
}
</style>
</head>
<body>

	<h2>댓글 목록</h2>
	<div id="commentList">
		<!-- 데이터가 로드될 영역 -->
	</div>

	<script>
        // 초기 설정 
        // /comments로 고정
        const boardNo = 1; 
        const contextPath = "${pageContext.request.contextPath}";
        const apiUrl = `\${contextPath}/comments`; 

        // 댓글 목록 
        function loadComments() {
            // 컨트롤러의 @GetMapping list() 메서드 호출
            fetch(`\${apiUrl}?boardNo=\${boardNo}`)
                .then(res => {
                    if(!res.ok) throw new Error("네트워크 응답 에러");
                    return res.json();
                })
                .then(data => {
                    const listDiv = document.getElementById("commentList");
                    let html = "";

                    if (data.length === 0) {
                        listDiv.innerHTML = "<p>작성된 댓글이 없습니다.</p>";
                        return;
                    }

                    data.forEach(comment => {
                        html += `
                            <div class="comment-item">
                                <div>
                                    <span class="author">\${comment.nickname}</span>
                                    <span class="date">\${comment.createdTime}</span>
                                </div>
                                <div class="content" id="text-\${comment.commentNo}">\${comment.content}</div>
                                <div class="btn-group">
                                    <button onclick="editComment(\${comment.commentNo})">수정</button>
                                    <button class="btn-delete" onclick="deleteComment(\${comment.commentNo})">삭제</button>
                                </div>
                            </div>
                        `;
                    });
                    listDiv.innerHTML = html;
                })
                .catch(err => {
                    console.error("데이터 로드 실패:", err);
                    document.getElementById("commentList").innerHTML = "댓글을 불러오는 중 오류가 발생했습니다.";
                });
        }

        // 댓글 수정 
        function editComment(commentNo) {
            const currentContent = document.getElementById(`text-\${commentNo}`).innerText;
            const newContent = prompt("수정할 내용을 입력하세요:", currentContent);
            
            if (!newContent || newContent === currentContent) return;

            // 컨트롤러 @RequestBody Comment 객체 구조와 일치 (content 필드)
            const updateData = { content: newContent };

            fetch(`\${apiUrl}/\${commentNo}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(updateData)
            })
            .then(res => {
                if (res.ok) {
                    alert("수정 완료!");
                    loadComments();
                } else {
                    alert("수정에 실패했습니다.");
                }
            });
        }

        // 댓글 삭제 
        function deleteComment(commentNo) {
            if (!confirm("정말 삭제하시겠습니까?")) return;

            fetch(`\${apiUrl}/\${commentNo}`, {
                method: "DELETE"
            })
            .then(res => {
                if (res.ok) {
                    alert("삭제되었습니다.");
                    loadComments();
                } else {
                    alert("삭제에 실패했습니다.");
                }
            });
        }

        // 페이지 시작 시 실행
        loadComments();
    </script>

</body>
</html>