<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>

<body style="margin: 0; font-family: 'Noto Sans KR';">

	<div
		style="width: 1440px; height: 920px; position: relative; background: #F6F6F6; margin: auto;">

		<!-- 상단 -->
		<div
			style="width: 1440px; height: 64px; position: absolute; background: white;"></div>
		<div
			style="position: absolute; left: 90px; top: 14px; font-size: 30px; font-weight: 700;">
			team404</div>

		<!-- 카드 -->
		<div
			style="width: 1040px; height: 780px; position: absolute; left: 200px; top: 100px; background: white; border-radius: 8px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);">
		</div>

		<!-- 제목 -->
		<div
			style="position: absolute; left: 248px; top: 144px; font-size: 22px; font-weight: 700;">
			회원가입</div>

		<!-- 🔥 form (여기 핵심 수정) -->
		<form action="${pageContext.request.contextPath}/users" method="post">

			<!-- 아이디 -->
			<input type="text" name="userId" placeholder="영문+숫자 6~20자"
				style="position: absolute; left: 248px; top: 246px; width: 460px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 비밀번호 -->
			<input type="password" name="userPw" placeholder="8자 이상, 특수문자 포함"
				style="position: absolute; left: 732px; top: 246px; width: 460px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 이름 -->
			<input type="text" name="userName" placeholder="실명 입력"
				style="position: absolute; left: 732px; top: 328px; width: 460px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 닉네임 -->
			<input type="text" name="userNickName" placeholder="2~10자"
				style="position: absolute; left: 248px; top: 410px; width: 460px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 나이 -->
			<input type="number" name="userAge" placeholder="나이 입력"
				style="position: absolute; left: 732px; top: 410px; width: 460px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 연락처 -->
			<input type="text" name="userPhone" placeholder="010-0000-0000"
				style="position: absolute; left: 248px; top: 492px; width: 460px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 주소 -->
			<input type="text" name="userAddress" placeholder="주소 입력"
				style="position: absolute; left: 248px; top: 574px; width: 800px; height: 38px; border: 1px solid #E6E6E6; border-radius: 4px; padding-left: 10px;">

			<!-- 카테고리 -->
			<input type="hidden" name="categoryList" id="categoryList">

			<div onclick="toggleCategory(this,'전자기기')" class="cat"
				style="left: 248px; top: 674px;">전자기기</div>
			<div onclick="toggleCategory(this,'의류·패션')" class="cat"
				style="left: 368px; top: 674px;">의류·패션</div>
			<div onclick="toggleCategory(this,'가구')" class="cat"
				style="left: 488px; top: 674px;">가구</div>
			<div onclick="toggleCategory(this,'도서')" class="cat"
				style="left: 608px; top: 674px;">도서</div>
			<div onclick="toggleCategory(this,'스포츠')" class="cat"
				style="left: 728px; top: 674px;">스포츠</div>
			<div onclick="toggleCategory(this,'뷰티')" class="cat"
				style="left: 848px; top: 674px;">뷰티</div>
			<div onclick="toggleCategory(this,'취미·게임')" class="cat"
				style="left: 968px; top: 674px;">취미·게임</div>
			<div onclick="toggleCategory(this,'기타')" class="cat"
				style="left: 1088px; top: 674px;">기타</div>

			<!-- 버튼 -->
			<button type="submit"
				style="position: absolute; left: 248px; top: 746px; width: 944px; height: 46px; background: #121212; color: white; border: none; border-radius: 4px; font-weight: 700;">
				회원가입 완료</button>

		</form>

	</div>

	<style>
.cat {
	position: absolute;
	width: 112px;
	height: 32px;
	border: 1px solid #E6E6E6;
	border-radius: 4px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 11px;
	cursor: pointer;
	background: white;
}

.cat.active {
	background: #121212;
	color: white;
	border: 1px solid #121212;
}
</style>

	<script>
let selected = [];

function toggleCategory(el, cat){
    if(selected.includes(cat)){
        selected = selected.filter(c => c !== cat);
        el.classList.remove("active");
    } else {
        if(selected.length >= 5){
            alert("최대 5개까지 선택 가능");
            return;
        }
        selected.push(cat);
        el.classList.add("active");
    }
    document.getElementById("categoryList").value = selected;
}
</script>

</body>
</html>