<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title>댓글</title>
</head>
<body>

	<h1>댓글 페이지</h1>

	<div id="commentList"></div>

	<script>
fetch("/minimarket/comment/list/1")
    .then(res => res.json())
    .then(data => {
        console.log(data);
    });
</script>

</body>
</html>