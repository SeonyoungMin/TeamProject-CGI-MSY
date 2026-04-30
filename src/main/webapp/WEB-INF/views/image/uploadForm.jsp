<%@ page contentType="text/html; charset=UTF-8"%>

<html>
<head>
<title>Image Upload</title>
</head>
<body>

	<h2>이미지 업로드 테스트</h2>

	<form action="${pageContext.request.contextPath}/image/upload"
		method="post" enctype="multipart/form-data">

		entityType: <select name="entityType">
			<option value="board">board</option>
			<option value="product">product</option>
			<option value="profile">profile</option>
		</select> <br> <br> entityId: <input type="number" name="entityId"
			value="1"> <br> <br> files: <input type="file"
			name="files" multiple> <br> <br>

		<button type="submit">업로드</button>

	</form>

</body>
</html>