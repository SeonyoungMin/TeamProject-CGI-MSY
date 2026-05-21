<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저 정보 수정</title>
<style>
body {
	margin: 0;
	font-family: 'Arial', sans-serif;
	background: #f8f9fa;
	color: #333;
}

.container {
	width: 550px;
	margin: 40px auto;
	background: white;
	padding: 40px;
	border-radius: 12px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

h3 {
	text-align: center;
	margin-bottom: 30px;
	font-size: 24px;
	color: #222;
}

.form-group {
	margin-bottom: 18px;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 8px;
	font-size: 14px;
}

input {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 15px;
}

input:focus {
	border-color: #007bff;
	outline: none;
	box-shadow: 0 0 5px rgba(0, 123, 255, 0.2);
}

/* 동네 인증 박스 스타일 */
.auth-box {
	background: #fdfdfd;
	padding: 20px;
	border-radius: 10px;
	border: 1px solid #e9ecef;
	margin: 25px 0;
}

.auth-title {
	font-weight: bold;
	margin-bottom: 12px;
	display: block;
}

.btn {
	width: 100%;
	padding: 14px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-weight: bold;
	font-size: 16px;
	transition: 0.3s;
}

.btn-submit {
	background: #007bff;
	color: white;
	margin-top: 10px;
}

.btn-submit:hover {
	background: #0056b3;
}

.btn-auth {
	background: #28a745;
	color: white;
	width: 130px;
	padding: 10px;
	font-size: 14px;
	margin-top: 0;
}

.btn-auth:hover {
	background: #218838;
}

.top-link {
	display: block;
	text-align: right;
	margin-bottom: 15px;
	text-decoration: none;
	color: #666;
	font-size: 13px;
}

.info-text {
	font-size: 12px;
	color: #888;
	margin-top: 8px;
	line-height: 1.4;
}

.readonly-input {
	background: #f1f3f5;
	color: #495057;
	cursor: not-allowed;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<a class="top-link" href="${ctx}/mypage">← 마이페이지로 돌아가기</a>
		<h3>내 정보 수정</h3>

		<c:url value="/users/edit" var="editUserProcess" />
		<form:form modelAttribute="editUser" action="${editUserProcess}"
			method="POST" enctype="multipart/form-data">

			<form:hidden path="userNo" />

			<div class="form-group">
				<label>아이디</label>
				<form:input path="userId" placeholder="변경할 아이디를 입력하세요" />
			</div>

			<div class="form-group">
				<label>새 비밀번호</label>
				<form:password path="userPw" placeholder="변경할 경우에만 입력하세요" />
			</div>

			<div class="form-group">
				<label>이름</label>
				<form:input path="userName" placeholder="이름을 입력하세요" />
			</div>

			<div style="display: flex; gap: 15px;">
				<div class="form-group" style="flex: 1;">
					<label>나이</label>
					<form:input path="userAge" type="number" placeholder="나이" />
				</div>
				<div class="form-group" style="flex: 2;">
					<label>전화번호</label>
					<form:input path="userPhone" placeholder="010-0000-0000" />
				</div>
			</div>

			<div class="form-group">
				<label>닉네임</label>
				<form:input path="userNickName" placeholder="활동할 닉네임을 입력하세요" />
			</div>

			<hr style="border: 0; border-top: 1px solid #eee; margin: 25px 0;">

			<div class="form-group">
				<label>주소</label>
				<form:input path="userAddress" id="userAddress"
					placeholder="예 : 창원시" />
			</div>

			<div class="auth-box">
				<span class="auth-title"> 실시간 동네 인증 (직거래 필수)</span>
				<div style="display: flex; gap: 10px;">
					<form:input path="verifiedArea" id="verifiedArea" readonly="true"
						placeholder="동네 인증이 필요합니다" class="readonly-input"
						style="flex: 1; background: #fff;" />
					<button type="button" class="btn btn-auth"
						onclick="verifyLocation()">현위치 인증</button>
				</div>
				<p class="info-text">* 현재 계정의 위치 좌표가 업데이트되어야 직거래 거리 인증이 가능합니다.</p>
			</div>

			<form:hidden path="latitude" id="latitude" />
			<form:hidden path="longitude" id="longitude" />

			<button type="submit" class="btn btn-submit">수정 내용 저장하기</button>
		</form:form>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		function verifyLocation() {
			if (!navigator.geolocation) {
				alert("이 브라우저에서는 위치 서비스를 지원하지 않습니다.");
				return;
			}

			alert("GPS 신호를 수신 중입니다...");

			navigator.geolocation.getCurrentPosition(function(pos) {
				const lat = pos.coords.latitude;
				const lng = pos.coords.longitude;

				$("#latitude").val(lat);
				$("#longitude").val(lng);

				$.ajax({
					url : "${ctx}/users/reverse-geocode",
					type : "GET",
					data : {
						lat : lat,
						lng : lng
					},
					success : function(area) {
						$("#userAddress").val(area);
						$("#verifiedArea").val(area);
						alert("동네 인증에 성공하였습니다: " + area);
					},
					error : function() {
						alert("주소 변환에 실패했습니다.");
					}
				});
			}, function(error) {
				alert("위치 정보를 가져오는 데 실패했습니다.");
			}, {
				enableHighAccuracy : true,
				timeout : 7000
			});
		}
	</script>
</body>
</html>