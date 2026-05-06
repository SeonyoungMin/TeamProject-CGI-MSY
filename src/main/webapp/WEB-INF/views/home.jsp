<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta charset="UTF-8">

<style>
.category-nav {
	background: #fff;
	border-bottom: 1px solid #eee;
	padding: 15px 0;
	text-align: center;
}

.category-nav a {
	margin: 0 15px;
	font-size: 14px;
	font-weight: 500;
	color: #333;
	text-decoration: none;
}

.main-container {
	max-width: 1200px;
	margin: 30px auto;
	display: flex;
	gap: 30px;
}

.left-content {
	flex: 3;
}

.right-content {
	flex: 1;
}

.sidebar-box {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 20px;
}

.sidebar-box h4 {
	margin-top: 0;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
}

.sidebar-item {
	font-size: 13px;
	padding: 10px 0;
	border-bottom: 1px solid #f9f9f9;
}

.product-list {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
}

.card {
	border: 1px solid #eee;
	border-radius: 8px;
	overflow: hidden;
	cursor: pointer;
	background: #fff;
	transition: transform 0.2s;
}

.card:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.thumb {
	width: 100%;
	height: 180px;
	background: #f0f0f0;
}

.card-info {
	padding: 12px;
}

.title {
	font-size: 15px;
	font-weight: 500;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.price {
	font-weight: bold;
	margin-top: 8px;
	font-size: 16px;
	color: #121212;
}

.location {
	font-size: 12px;
	color: #888;
	margin-top: 5px;
}

.page-btn {
	margin: 3px;
	padding: 6px 12px;
	cursor: pointer;
	border-radius: 4px;
}
</style>

<div class="page">
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="category-nav">
		<a href="#">전체</a> <a href="#">전자기기</a> <a href="#">의류</a> <a href="#">가구</a>
		<a href="#">도서</a>
	</div>

	<div class="content">
		<div class="banner"
			style="text-align: center; padding: 50px 20px; background: #EDEBE7;">
			<h1 style="font-size: 32px; margin-bottom: 10px;">쉽고 안전한 중고거래</h1>
			<div style="margin-top: 20px;">
				<button
					style="width: 160px; height: 45px; background: #121212; color: white; border: none; cursor: pointer;">상품
					둘러보기</button>
				<button
					style="width: 160px; height: 45px; margin-left: 10px; background: white; border: 1px solid #ddd; cursor: pointer;">글쓰기</button>
			</div>
		</div>

		<div class="main-container">
			<div class="left-content">
				<section>
					<div
						style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
						<h3 style="margin: 0;">최근 등록 상품</h3>
						<a href="${pageContext.request.contextPath}/productList"
							style="font-size: 13px; color: #888; text-decoration: none;">전체보기
							></a>
					</div>
					<div id="productList" class="product-list"></div>
					<div id="pagination" style="text-align: center; margin-top: 40px;"></div>
				</section>
			</div>
			<aside class="right-content">
				<div class="sidebar-box">
					<h4>문의게시글</h4>
					<div class="sidebar-item">어떻게 결제 하나요?</div>
				</div>
				<div class="sidebar-box">
					<h4>공지사항</h4>
					<div class="sidebar-item">시스템 점검 안내</div>
				</div>
			</aside>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</div>

<script>
// JSP 변수를 자바스크립트 변수로 먼저 할당
var ctx = "${pageContext.request.contextPath}"; 

function loadProducts(page) {
    var pageNum = page || 1;
    // 백틱 대신 문자열 연결(+)을 사용하여 JSP 파싱 에러 방지
    var url = ctx + "/productList?pageNum=" + pageNum + "&dataOnly=true"; 
    
    fetch(url)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var list = document.getElementById("productList");
            list.innerHTML = ""; 

            if (data.list && data.list.length > 0) {
                data.list.forEach(function(p) {
                    var imageSrc = p.imgPath ? ctx + p.imgPath : 'https://via.placeholder.com/150';
                    var priceStr = p.price ? p.price.toLocaleString() : '0';
                    var nickname = p.sellerNickname || '지역 정보 없음';
                    
                  
                    var html = '<div class="card" onclick="location.href=\'' + ctx + '/product/' + p.productNo + '\'">' +
                                    '<div class="thumb">' +
                                        '<img src="' + imageSrc + '" style="width:100%; height:100%; object-fit:cover;">' +
                                    '</div>' +
                                    '<div class="card-info">' +
                                        '<div class="title">' + p.productName + '</div>' +
                                        '<div class="location">' + nickname + '</div>' +
                                        '<div class="price">' + priceStr + '원</div>' +
                                    '</div>' +
                                '</div>';
                    list.innerHTML += html;
                });
            } else {
                list.innerHTML = "<p style='grid-column: span 3; text-align:center;'>등록된 상품이 없습니다.</p>";
            }
            renderPagination(data.totalPages, data.currentPage);
        })
        .catch(function(err) { console.error("로드 실패:", err); });
}

function renderPagination(total, current) {
    var pageEl = document.getElementById("pagination");
    pageEl.innerHTML = ""; 

    for (var i = 1; i <= total; i++) {
        var isCurrent = (i === current);
        var borderStyle = isCurrent ? '2px solid #121212' : '1px solid #ccc';
        var bgColor = isCurrent ? '#121212' : 'white';
        var textColor = isCurrent ? 'white' : 'black';
        
        var btn = '<button class="page-btn" onclick="loadProducts(' + i + ')" ' +
                  'style="border:' + borderStyle + '; background:' + bgColor + '; color:' + textColor + ';">' + i + '</button>';
        pageEl.innerHTML += btn;
    }
}

window.onload = function() {
    loadProducts(1);
};
</script>