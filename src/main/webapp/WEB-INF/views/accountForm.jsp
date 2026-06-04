<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계좌 정보 등록</title>
<style>
.container {
	max-width: 560px;
	margin: 40px auto;
	padding: 24px;
	font-family: 'Pretendard', sans-serif;
}

h2 {
	font-size: 22px;
	margin: 0 0 6px;
}

.lead {
	color: #666;
	margin-bottom: 22px;
	font-size: 14px;
}

.banner-success {
	background: #dcfce7;
	color: #166534;
	padding: 12px 14px;
	border-radius: 8px;
	margin-bottom: 18px;
	font-size: 14px;
}

.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 20px;
}

.field {
	margin-bottom: 14px;
}

.field label {
	display: block;
	font-size: 13px;
	color: #555;
	margin-bottom: 6px;
}

.field input, .field select {
	width: 100%;
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	font-family: inherit;
	box-sizing: border-box;
}

.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 18px;
}

.btn {
	flex: 1;
	padding: 14px;
	border: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
	text-decoration: none;
	text-align: center;
}

.btn-primary {
	background: #121212;
	color: #fff;
}

.btn-line {
	background: #f0f0f0;
	color: #333;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="container">
		<h2>계좌 정보</h2>
		<p class="lead">계좌이체 거래를 받으려면 입금받을 계좌를 등록해주세요.</p>

		<c:if test="${param.saved == '1'}">
			<div class="banner-success">✓ 계좌 정보가 저장되었습니다.</div>
		</c:if>

		<form action="${ctx}/mypage/account" method="post" class="card">
			<div class="field">
				<label for="bankName">은행</label> <input type="text" id="bankName"
					name="bankName" value="${user.userBankName}"
					placeholder="예) 카카오뱅크 / 농협" required>
			</div>
			<div class="field">
				<label for="accountNumber">계좌번호</label> <input type="text"
					id="accountNumber" name="accountNumber"
					value="${user.userAccountNumber}" placeholder="숫자만 입력" required>
			</div>
			<div class="field">
				<label for="birthDate">생년월일 앞 6자리</label> <input type="text"
					id="birthDate" name="birthDate" placeholder="예) 990101"
					maxlength="6" required>
			</div>
			<div class="field">
				<label for="accountHolder">예금주</label> <input type="text"
					id="accountHolder" name="accountHolder"
					value="${user.userAccountHolder}" placeholder="실명" required>

				<hr>
				<button type="button" onclick="verifyAccount()">계좌 인증하기</button>
			</div>

			<div class="btn-group">
				<a href="${ctx}/mypage" class="btn btn-line">취소</a>
				<button type="submit" id="saveBtn" class="btn btn-primary" disabled
					style="opacity: 0.4; cursor: not-allowed;">저장</button>
			</div>
		</form>

		<script>
		function verifyAccount() {
		    var bankName = document.getElementById("bankName").value.trim();
		    var accountNo = document.getElementById("accountNumber").value.trim();
		    var birthDate = document.getElementById("birthDate").value.trim();

		    if (!bankName || !accountNo || !birthDate) {
		        alert("모든 항목을 입력해주세요.");
		        return;
		    }

		    var bankCodeMap = {
		    	    "국민": "004", "kb국민": "004",
		    	    "신한": "088",
		    	    "우리": "020",
		    	    "하나": "081",
		    	    "농협": "011",
		    	    "카카오뱅크": "090", "카카오": "090",
		    	    "토스뱅크": "092", "토스": "092",
		    	    "기업": "003",
		    	    "sc제일": "023",
		    	    "케이뱅크": "089",
		    	    "부산": "032",
		    	    "대구": "031",
		    	    "경남": "039"
		    	};

		    var bankCode = bankCodeMap[bankName.toLowerCase()] || bankCodeMap[bankName];
		    if (!bankCode) {
		        alert("지원하지 않는 은행입니다.\n예) 카카오뱅크, 국민, 신한, 우리, 하나, 농협");
		        return;
		    }

		    fetch("${ctx}/mypage/account/verify", {
		        method: "POST",
		        headers: { "Content-Type": "application/x-www-form-urlencoded" },
		        body: "bankCode=" + bankCode
		        + "&accountNo=" + encodeURIComponent(accountNo)
		        + "&birthDate=" + birthDate
		    })
		    .then(res => res.text())
		    .then(result => {
		        if (result !== "fail" && result !== "error") {
		            document.getElementById("accountHolder").value = result;
		            document.getElementById("saveBtn").disabled = false;
		            document.getElementById("saveBtn").style.opacity = "1";
		            document.getElementById("saveBtn").style.cursor = "pointer";
		            alert("인증 성공!\n예금주명: " + result);
		        } else {
		            alert("인증 실패\n은행명, 계좌번호를 다시 확인해주세요.");
		        }
		    })
		    .catch(() => {
		        alert("인증 중 오류가 발생했습니다.");
		    });
		}
</script>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>