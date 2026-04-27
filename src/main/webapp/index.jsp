<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>업로드 테스트</title>
</head>
<body>

	<h2>이미지 업로드</h2>

	<form action="${pageContext.request.contextPath}/uploadImage"
		method="post" enctype="multipart/form-data">

		<select name="type">
			<option value="user">user</option>
			<option value="product">product</option>
			<option value="board">board</option>
		</select> <br>
		<br> <input type="file" name="file" /> <br>
		<br>
		<button type="submit">업로드</button>

	</form>

	<p>${msg}</p>

</body>
</html>