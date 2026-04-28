<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<title>게시글 상세</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>

	<h1>게시글 상세</h1>

	<!-- 게시글 정보 (예시) -->
	<div>
		<h3>제목: ${board.title}</h3>
		<p>내용: ${board.content}</p>
	</div>

	<hr>

	<h2>댓글</h2>

	<!-- 댓글 입력 -->
	<input type="text" id="content" placeholder="댓글 입력">
	<button type="button" onclick="insertComment()">등록</button>

	<hr>

	<!-- 댓글 리스트 -->
	<div id="commentList"></div>

	<script>
		let boardNo = "${boardNo}";
		let contextPath = "${pageContext.request.contextPath}";

		$(document).ready(function() {
			loadComments();
		});

		// 댓글 목록
		function loadComments() {

			$
					.ajax({
						url : contextPath + "/comment/list/" + boardNo,
						type : "GET",
						success : function(data) {

							let html = "";

							for (let i = 0; i < data.length; i++) {
								let c = data[i];

								html += "<div style='margin-bottom:8px;'>";
								html += "💬 " + c.content + " / 작성자: "
										+ c.nickname;
								html += ' <button type="button" onclick="deleteComment('
										+ c.commentNo + ')">삭제</button>';
								html += "</div>";
							}

							$("#commentList").html(html);
						}
					});
		}

	</script>

</body>
</html>