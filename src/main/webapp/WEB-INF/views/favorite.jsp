<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title>찜 목록</title>
</head>
<body>

	<h1>내 찜 목록</h1>

	<div id="favoriteList"></div>

	<script>
    const userNo = 1; // 테스트용 번호

    // 1. 찜 목록 가져오기
    fetch("${pageContext.request.contextPath}/favorite/my?userNo=" + userNo)
        .then(res => res.json())
        .then(data => {
            console.log("받은 데이터:", data); // [1, 2, 3] 형태인지 확인

            let html = "";
            const listDiv = document.getElementById("favoriteList");

            if (!data || data.length === 0) {
                html = "<p>찜한 상품이 없습니다.</p>";
            } else {
                // data 자체가 숫자 리스트이므로 boardNo를 바로 사용
                data.forEach(boardNo => {
                    html += `
                        <div style="border:1px solid #ccc; margin:10px; padding:10px;">
                            <p>게시글 번호: \${boardNo}</p>
                            <button type="button" onclick="removeWish(\${boardNo})">
                                찜 취소
                            </button>
                        </div>
                    `;
                });
            }
            listDiv.innerHTML = html;
        })
        .catch(err => console.error("목록 로딩 에러:", err));

    // 2. 찜 삭제
    function removeWish(boardNo) {
    if(!confirm("찜을 취소하시겠습니까?")) return;

    const url = `${pageContext.request.contextPath}/favorite/remove`;

 
    fetch(`\${url}?userNo=\${userNo}&boardNo=\${boardNo}`, {
        method: "POST" 
    })
    .then(res => {
        if (res.ok) {
            alert("찜 삭제 완료");
            location.reload();
        } else {
            console.error("상태 코드:", res.status);
            alert("실패 (코드: " + res.status + ") - 서버 로그를 확인하세요.");
        }
    })
    .catch(err => console.error("네트워크 에러:", err));
}
</script>

</body>
</html>