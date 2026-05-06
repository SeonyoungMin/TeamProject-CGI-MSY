<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<meta charset="UTF-8">

<style>
.detail-container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 20px;
	font-family: 'Pretendard', sans-serif;
}

.top-section {
	display: flex;
	gap: 50px;
	margin-bottom: 50px;
}

.image-area {
	flex: 1.2;
}

.info-area {
	flex: 1;
}

.main-img-box {
	width: 100%;
	aspect-ratio: 4/3;
	border-radius: 8px;
	overflow: hidden;
	background: #f4f4f4;
	border: 1px solid #eee;
}

.main-img-box img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.thumb-list {
	display: flex;
	gap: 10px;
	margin-top: 15px;
}

.thumb-item {
	width: 70px;
	height: 70px;
	border-radius: 4px;
	cursor: pointer;
	object-fit: cover;
	border: 1px solid #ddd;
}

.status-tag {
	display: inline-block;
	background: #2ecc71;
	color: white;
	padding: 2px 8px;
	border-radius: 4px;
	font-size: 12px;
	margin-bottom: 10px;
}

.product-title {
	font-size: 26px;
	font-weight: bold;
	margin-bottom: 5px;
}

.sub-info {
	font-size: 13px;
	color: #888;
	margin-bottom: 20px;
}

.price-text {
	font-size: 32px;
	font-weight: bold;
	padding: 20px 0;
	border-bottom: 1px solid #eee;
}

.meta-table {
	width: 100%;
	margin: 25px 0;
	font-size: 14px;
}

.meta-table th {
	text-align: left;
	color: #888;
	width: 80px;
	padding: 10px 0;
}

.desc-section {
	background: #f9f9f9;
	padding: 25px;
	border-radius: 12px;
	line-height: 1.6;
	min-height: 120px;
	margin-bottom: 30px;
}

.action-group {
	display: flex;
	gap: 10px;
}

.btn-buy {
	flex: 2;
	height: 55px;
	background: #121212;
	color: white;
	border: none;
	font-size: 18px;
	font-weight: bold;
	cursor: pointer;
	border-radius: 6px;
}

.btn-inquiry {
	flex: 1;
	background: white;
	border: 1px solid #ddd;
	height: 55px;
	border-radius: 6px;
	cursor: pointer;
}

.btn-fav {
	width: 120px;
	background: white;
	border: 1px solid #ddd;
	border-radius: 6px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 5px;
	cursor: pointer;
}

.btn-fav.active {
	color: #e74c3c;
	border-color: #e74c3c;
}

.comment-section {
	border-top: 1px solid #eee;
	padding-top: 40px;
	margin-top: 50px;
}

.comment-input-box {
	display: flex;
	gap: 10px;
	margin-bottom: 30px;
}

.comment-input {
	flex: 1;
	height: 50px;
	padding: 0 15px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

.btn-comment {
	width: 100px;
	background: #121212;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.comment-list-item {
	padding: 20px 0;
	border-bottom: 1px solid #f9f9f9;
}
</style>

<div class="page">
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="detail-container">
		<div class="top-section">
			<div class="image-area">
				<div class="main-img-box">
					<img id="mainDisplay"
						src="${pageContext.request.contextPath}${listByProductNo.imgPath}"
						onerror="this.src='https://via.placeholder.com/600x450'">
				</div>
				<div class="thumb-list">
					<c:forEach var="img" items="${listByProductNo.images}">
						<img src="${pageContext.request.contextPath}${img.filePath}"
							class="thumb-item"
							onclick="document.getElementById('mainDisplay').src=this.src">
					</c:forEach>
				</div>
			</div>

			<div class="info-area">
				<span class="status-tag">${listByProductNo.tradeStatus}</span>
				<h1 class="product-title">${listByProductNo.productName}</h1>
				<div class="sub-info">
					등록일:
					<fmt:formatDate value="${listByProductNo.createdTime}"
						pattern="yyyy.MM.dd" />
					· 조회 128
				</div>

				<div class="price-text">
					<fmt:formatNumber value="${listByProductNo.price}" />
					원
				</div>

				<table class="meta-table">
					<tr>
						<th>카테고리</th>
						<td>${listByProductNo.category}</td>
					</tr>
					<tr>
						<th>거래방식</th>
						<td>직거래 선호</td>
					</tr>
					<tr>
						<th>거래지역</th>
						<td>전국</td>
					</tr>
				</table>

				<div class="desc-section">
					<strong>상품 설명</strong><br> <br>
					${listByProductNo.description}
				</div>

				<div class="action-group">
					<button class="btn-buy">구매하기</button>
					<button class="btn-inquiry">판매자에게 문의</button>
					<button id="favBtn" class="btn-fav" onclick="toggleFavorite()">
						<span id="favHeart">♡</span> 찜하기
					</button>
				</div>
			</div>
		</div>

		<div class="comment-section">
			<h3>댓글</h3>
			<div class="comment-input-box">
				<input type="text" id="commentText" class="comment-input"
					placeholder="댓글을 입력해주세요.">
				<button class="btn-comment" onclick="addComment()">등록</button>
			</div>
			<div id="commentList"></div>
		</div>
		<%@ include file="/WEB-INF/views/footer.jsp"%>
	</div>

	<script>
    const productNo = "${listByProductNo.productNo}";
    const userNo = "${sessionScope.loginUser.userNo}"; 
    const ctx = "${pageContext.request.contextPath}";

    function checkLoginAndRedirect() {
        if (!userNo || userNo === "") {
            if (confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
            	// 현재 상세 페이지의 주소 ex) 660342를 가져옴
                var currentPath = "/product/" + productNo; 
                // 로그인 페이지로 갈 때 뒤에 주소를 붙여서 보냄
                location.href = ctx + "/login?redirect=" + currentPath;
            }
            return false;
        }
        return true;
    }

    function checkFavorite() {
        if(!userNo) return;
        fetch(ctx + "/favorite/my?userNo=" + userNo)
            .then(res => res.json())
            .then(list => {
                if(list.includes(parseInt(productNo))) {
                    document.getElementById('favBtn').classList.add('active');
                    document.getElementById('favHeart').innerText = '♥';
                }
            });
    }

    function toggleFavorite() {
        if(!checkLoginAndRedirect()) return;

        const btn = document.getElementById('favBtn');
        const isActive = btn.classList.contains('active');
        const url = isActive ? ctx + "/favorite/remove" : ctx + "/favorite/add";

        fetch(url, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: "userNo=" + userNo + "&boardNo=" + productNo
        }).then(() => {
            btn.classList.toggle('active');
            document.getElementById('favHeart').innerText = isActive ? '♡' : '♥';
        });
    }

    function loadComments() {
        fetch(ctx + "/comments?boardNo=" + productNo)
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById('commentList');
                list.innerHTML = data.map(c => 
                    '<div class="comment-list-item">' +
                        '<strong>' + (c.nickname || '익명') + '</strong> ' +
                        '<span style="font-size:12px; color:#999; margin-left:10px;">' + c.createdTime + '</span>' +
                        '<p style="margin-top:10px;">' + c.content + '</p>' +
                    '</div>'
                ).join('');
            });
    }

    function addComment() {
        if(!checkLoginAndRedirect()) return;

        const content = document.getElementById('commentText').value;
        if(!content) return;

        fetch(ctx + "/comments", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                
                boardNo: parseInt(productNo), 
                authorNo: parseInt(userNo),
                content: content
            })
        }).then(response => {
            if (response.ok) {
                document.getElementById('commentText').value = '';
                loadComments(); // 등록 후 목록 새로고침
            } else {
                alert("댓글 등록에 실패했습니다.");
            }
        });
    }

    window.onload = () => {
        checkFavorite();
        loadComments();
    };
</script>