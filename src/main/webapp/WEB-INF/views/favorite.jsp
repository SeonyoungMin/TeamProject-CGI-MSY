<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<title>찜 목록 - team404</title>
<style>
body {
	margin: 0;
	font-family: 'Pretendard', sans-serif;
	background-color: #fff;
}

.container {
	width: 1000px;
	margin: 50px auto;
	min-height: 600px;
}

/* 타이틀 섹션 */
.page-title {
	font-size: 26px;
	font-weight: bold;
	margin-bottom: 30px;
	padding-bottom: 15px;
	border-bottom: 2px solid #000;
}

/* 찜 목록 그리드 레이아웃 */
#favoriteList {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
	gap: 25px;
}

/* 상품 카드 스타일 */
.fav-card {
	border: 1px solid #eee;
	border-radius: 8px;
	overflow: hidden;
	position: relative;
	transition: transform 0.2s, box-shadow 0.2s;
}

.fav-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
}

/* 이미지 영역 (이미지가 없을 경우 대비) */
.card-img {
	width: 100%;
	height: 200px;
	background: #f5f5f5;
	object-fit: cover;
}

.card-info {
	padding: 15px;
}

.card-no {
	font-size: 12px;
	color: #999;
	margin-bottom: 5px;
}

.card-title {
	font-size: 16px;
	font-weight: 600;
	color: #333;
	margin-bottom: 10px;
	display: block;
	text-decoration: none;
}

/* 찜 취소 버튼 (이미지 위나 버튼 형태로 배치) */
.remove-btn {
	width: 100%;
	padding: 10px;
	background: #fff;
	border: 1px solid #ddd;
	color: #666;
	font-size: 13px;
	cursor: pointer;
	border-radius: 4px;
	transition: 0.2s;
}

.remove-btn:hover {
	background: #fefefe;
	border-color: #e74c3c;
	color: #e74c3c;
}

/* 빈 목록 메시지 */
.empty-msg {
	text-align: center;
	padding: 100px 0;
	color: #888;
}

.empty-msg h3 {
	font-size: 20px;
	color: #333;
}
</style>
</head>
<body>
	<div class="page">
		<jsp:include page="/WEB-INF/views/header.jsp" />

		<div class="container">
			<h1 class="page-title">내 찜 목록</h1>
			<div id="favoriteList">
				<!-- 자바스크립트 데이터가 여기에 렌더링됩니다 -->
			</div>
		</div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>

	<script>
    // 세션에 저장된 유저 번호를 사용하는 것이 가장 정확
    const userNo = "${sessionScope.loginUser.userNo}";

    //  찜 목록 로드 — 상품 상세까지 받아와서 카드 렌더링
    function loadWishlist() {
        const listDiv = document.getElementById("favoriteList");

        // 비로그인 가드
        if (!userNo || userNo === "") {
            listDiv.innerHTML = `
                <div class="empty-msg" style="grid-column: 1/-1;">
                    <h3>로그인이 필요합니다.</h3>
                    <a href="${ctx}/login" style="color:#000; font-weight:bold;">로그인하러 가기</a>
                </div>`;
            return;
        }

        fetch("${ctx}/favorite/my/products?userNo=" + userNo)
            .then(res => {
                if (!res.ok) {
                    throw new Error("HTTP " + res.status + " " + res.statusText);
                }
                return res.json();
            })
            .then(data => {
                let html = "";

                if (!data || data.length === 0) {
                    html = `
                        <div class="empty-msg" style="grid-column: 1/-1;">
                            <h3>찜한 상품이 아직 없네요.</h3>
                            <p>마음에 드는 상품을 찾아 찜해보세요!</p>
                            <br>
                            <a href="${ctx}/" style="color:#000; font-weight:bold;">상품 보러가기</a>
                        </div>
                    `;
                } else {
                    data.forEach(p => {
                        // 썸네일: imgPath 가 있으면 그대로, 없으면 images[0], 둘 다 없으면 placeholder
                        let imgUrl = "${ctx}/resources/img/no-image.png";
                        if (p.imgPath) {
                            imgUrl = "${ctx}" + p.imgPath;
                        } else if (p.images && p.images.length > 0) {
                            imgUrl = "${ctx}" + p.images[0].filePath;
                        }
                        const priceStr = (p.price != null) ? p.price.toLocaleString() + "원" : "";

                        html += `
                            <div class="fav-card">
                                <a href="${ctx}/product/\${p.productNo}">
                                    <img src="\${imgUrl}" class="card-img" alt="\${p.productName}"
                                         onerror="this.src='${ctx}/resources/img/no-image.png'">
                                </a>
                                <div class="card-info">
                                    <div class="card-no">No. \${p.productNo}</div>
                                    <a href="${ctx}/product/\${p.productNo}" class="card-title">
                                        \${p.productName}
                                    </a>
                                    <div style="font-weight:bold; margin-bottom:10px;">\${priceStr}</div>
                                    <button type="button" class="remove-btn" onclick="removeWish(\${p.productNo})">
                                        찜 취소
                                    </button>
                                </div>
                            </div>
                        `;
                    });
                }
                listDiv.innerHTML = html;
            })
            .catch(err => {
                console.error("목록 로딩 에러:", err);
                listDiv.innerHTML = `
                    <div class="empty-msg" style="grid-column: 1/-1;">
                        <h3>찜 목록을 불러오지 못했습니다.</h3>
                        <p style="color:#888; font-size:13px;">` + err.message + `</p>
                        <p style="color:#888; font-size:13px;">F12 → Network 탭에서 /favorite/my/products 응답을 확인해주세요.</p>
                    </div>`;
            });
    }

    // 초기 실행
    loadWishlist();

    // 찜 삭제 로직
    function removeWish(boardNo) {
        if(!confirm("찜 목록에서 삭제하시겠습니까?")) return;

        const url = `${ctx}/favorite/remove`;

        fetch(`\${url}?userNo=\${userNo}&boardNo=\${boardNo}`, {
            method: "POST" 
        })
        .then(res => {
            if (res.ok) {
                alert("찜 목록에서 삭제되었습니다.");
                loadWishlist(); // 전체 페이지 리로드 대신 목록만 새로 고침
            } else {
                alert("삭제에 실패했습니다. 다시 시도해주세요.");
            }
        })
        .catch(err => console.error("네트워크 에러:", err));
    }
    </script>
</body>
</html>