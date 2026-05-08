<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<style>
body {
	margin: 0;
	font-family: 'Noto Sans KR';
}

/* 전체 배경 */
.page {
	width: 100%;
	min-height: 100vh;
	background: #F6F6F6;
}

/* 상단 */
.header {
	height: 64px;
	background: white;
	display: flex;
	align-items: center;
	padding-left: 90px;
}

.logo {
	font-size: 30px;
	font-weight: 700;
}

/* 가운데 정렬 */
.container {
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: calc(100vh - 64px);
}

/* 카드 */
.card {
	width: 100%;
	max-width: 1040px;
	background: white;
	border-radius: 8px;
	padding: 40px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
}

.card h2 {
	margin-bottom: 20px;
}

/* grid */
.grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

/* input */
input {
	height: 40px;
	border: 1px solid #E6E6E6;
	border-radius: 4px;
	padding: 0 10px;
	font-size: 14px;
}

/* full width */
.full {
	width: 100%;
	margin-top: 20px;
}

/* 카테고리 */
.category-wrap {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	margin-top: 20px;
}

.cat {
	width: 100px;
	height: 32px;
	border: 1px solid #E6E6E6;
	border-radius: 4px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 12px;
	cursor: pointer;
	background: white;
}

.cat.active {
	background: #121212;
	color: white;
	border: 1px solid #121212;
}

/* 버튼 */
.submit-btn {
	width: 100%;
	height: 46px;
	margin-top: 30px;
	background: #121212;
	color: white;
	border: none;
	border-radius: 4px;
	font-weight: 700;
	cursor: pointer;
}
</style>
</head>

<body>

	<div class="page">

		<!-- 상단 -->
		<div class="header">
			<div class="logo">
				<a href="home" style="text-decoration: none; color: black;">
					team404 </a>
			</div>
		</div>

		<!-- 중앙 -->
		<div class="container">
			<div class="card">

				<h2>회원가입</h2>

				<form action="${pageContext.request.contextPath}/users"
					method="post">

					<!-- 2열 정렬 -->
					<div class="grid">
						<input type="text" name="userId" placeholder="아이디 (영문+숫자 6~20자)">
						<input type="password" name="userPw"
							placeholder="비밀번호 (8자 이상, 특수문자 포함)"> <input type="text"
							name="userNickName" placeholder="닉네임 (2~10자)"> <input
							type="text" name="userName" placeholder="이름"> <input
							type="number" name="userAge" placeholder="나이"> <input
							type="text" name="userPhone" placeholder="전화번호">
					</div>

					<!-- 주소 -->
					<input class="full" type="text" name="userAddress" placeholder="주소">

					<!-- 카테고리 -->
					<div class="category-wrap">
						<div onclick="toggleCategory(this,'전자기기')" class="cat">전자기기</div>
						<div onclick="toggleCategory(this,'의류·패션')" class="cat">의류·패션</div>
						<div onclick="toggleCategory(this,'가구')" class="cat">가구</div>
						<div onclick="toggleCategory(this,'도서')" class="cat">도서</div>
						<div onclick="toggleCategory(this,'스포츠')" class="cat">스포츠</div>
						<div onclick="toggleCategory(this,'뷰티')" class="cat">뷰티</div>
						<div onclick="toggleCategory(this,'취미·게임')" class="cat">취미·게임</div>
						<div onclick="toggleCategory(this,'기타')" class="cat">기타</div>
					</div>

					<input type="hidden" name="categoryList" id="categoryList">

					<!-- 버튼 -->
					<button type="submit" class="submit-btn">회원가입 완료</button>

				</form>

			</div>
		</div>

	</div>

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