<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>

<body style="margin: 0; font-family: 'Noto Sans KR';">

	<div
		style="width: 1440px; height: 800px; position: relative; background: #F6F6F6; margin: auto;">

		<!-- 상단 -->
		<div
			style="width: 1440px; height: 64px; position: absolute; top: 0; left: 0; background: white;"></div>
		<div
			style="width: 1440px; height: 1px; position: absolute; top: 64px; background: #E6E6E6;"></div>

		<div
			style="position: absolute; left: 655px; top: 14px; font-size: 30px; font-weight: 700;">
			team404</div>

		<!-- 홈으로 -->
		<a href="/"
			style="position: absolute; right: 40px; top: 26px; font-size: 12px; color: #878787; text-decoration: none;">
			홈으로 </a>

		<!-- 카드 -->
		<div
			style="width: 600px; height: 480px; position: absolute; left: 420px; top: 120px; background: white; border-radius: 8px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);">
		</div>

		<!-- 제목 -->
		<div
			style="position: absolute; left: 468px; top: 168px; font-size: 22px; font-weight: 700;">
			로그인</div>

		<div
			style="position: absolute; left: 468px; top: 200px; font-size: 13px; color: #878787;">
			환영합니다</div>

		<!-- form -->
		<form action="/login" method="post">

			<!-- 아이디 -->
			<input type="text" name="userId" placeholder="아이디를 입력하세요"
				style="position: absolute; left: 468px; top: 258px; width: 504px; height: 40px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 14px;">

			<!-- 비밀번호 -->
			<input type="password" name="password" placeholder="비밀번호를 입력하세요"
				style="position: absolute; left: 468px; top: 336px; width: 504px; height: 40px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 14px;">

			<!-- 로그인 버튼 -->
			<button type="submit"
				style="position: absolute; left: 468px; top: 396px; width: 504px; height: 46px; background: #121212; color: white; border: none; border-radius: 4px; font-weight: 700;">
				로그인</button>

		</form>

		<!-- 구분선 -->
		<div
			style="width: 504px; height: 1px; position: absolute; left: 468px; top: 460px; background: #E6E6E6;"></div>

		<!-- 하단 -->
		<div
			style="position: absolute; left: 468px; top: 478px; font-size: 12px; color: #878787;">
			계정이 없으신가요?</div>

		<a href="/signup"
			style="position: absolute; left: 638px; top: 478px; font-size: 12px; font-weight: 700; text-decoration: underline; color: #121212;">
			회원가입 </a>

		<div
			style="position: absolute; left: 908px; top: 478px; font-size: 11px; color: #878787;">
			비밀번호 찾기</div>

	</div>

</body>
</html>