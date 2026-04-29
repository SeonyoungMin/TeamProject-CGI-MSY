<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title>찜 목록</title>
</head>
<body>

	<h1>내 찜 목록</h1>

	<div id="favoriteList"></div>

	<script>
    const userNo = 1; // 나중에 세션으로 바꾸면 됨

    // 찜 목록 가져오기
    fetch("/minimarket/favorite/my?userNo=" + userNo)
        .then(res => res.json())
        .then(data => {
            console.log(data);

            let html = "";

            if (data.length === 0) {
                html = "<p>찜한 상품이 없습니다.</p>";
            } else {
                data.forEach(boardNo => {
                    html += `
                        <div style="border:1px solid #ccc; margin:10px; padding:10px;">
                            <p>게시글 번호: ${boardNo}</p>

                            <button onclick="removeWish(${boardNo})">
                                찜 취소
                            </button>
                        </div>
                    `;
                });
            }

            document.getElementById("favoriteList").innerHTML = html;
        });

    // 찜 삭제
    function removeWish(boardNo) {
        fetch("/minimarket/favorite?userNo=" + userNo + "&boardNo=" + boardNo, {
            method: "DELETE"
        })
        .then(() => {
            alert("찜 삭제 완료");
            location.reload();
        });
    }
</script>

</body>
</html>