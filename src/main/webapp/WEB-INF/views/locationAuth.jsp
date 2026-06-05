<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동네 인증</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/locationAuth.css">
</head>

<%@ include file="/WEB-INF/views/header.jsp"%>

<body>

	<div class="container">

		<h2>동네 인증</h2>

		<p class="info">직거래를 위해 현재 위치를 인증합니다</p>

		<form id="authForm"
			action="${pageContext.request.contextPath}/location-auth/check"
			method="post">

			<input type="hidden" name="productNo" value="${productNo}"> <input
				type="hidden" id="lat" name="lat"> <input type="hidden"
				id="lng" name="lng">

			<button type="button" class="btn" onclick="getLocation()">
				현재 위치 인증하기</button>

		</form>

	</div>

	<script>
		function getLocation() {

			if (!navigator.geolocation) {
				alert("GPS를 지원하지 않는 브라우저입니다.");
				return;
			}

			navigator.geolocation.getCurrentPosition(function(pos) {

				document.getElementById("lat").value = pos.coords.latitude;
				document.getElementById("lng").value = pos.coords.longitude;

				document.getElementById("authForm").submit();

			}, function() {
				alert("위치 권한을 허용해야 인증이 가능합니다.");
			});
		}
	</script>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>