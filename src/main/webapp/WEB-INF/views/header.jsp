<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- jQuery (찜/댓글 AJAX용) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Font Awesome 6 (아이콘) -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
/* ===== 공통 ===== */
* {
	box-sizing: border-box;
}

header {
	margin: 0;
	font-family: 'Malgun Gothic', sans-serif;
	background: #fafafa;
	color: #222;
}

a {
	text-decoration: none;
	color: inherit;
}

/* 가운데 정렬 컨테이너 */
.app-container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 0 20px;
}

/* 섹션 제목 */
.section-title {
	font-size: 22px;
	font-weight: bold;
	margin: 0 0 20px 0;
	padding-bottom: 10px;
	border-bottom: 2px solid #121212;
}

/* 카드 */
.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 20px;
}

/* input */
.form-input, input[type="text"].form-input, input[type="password"].form-input,
	input[type="number"].form-input, select.form-input, textarea.form-input
	{
	width: 100%;
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
	background: #fff;
	margin-bottom: 12px;
}

textarea.form-input {
	min-height: 120px;
	resize: vertical;
}

label.form-label {
	display: block;
	font-size: 13px;
	font-weight: bold;
	margin-bottom: 6px;
	color: #333;
}

/* 버튼 */
.btn {
	display: inline-block;
	padding: 10px 18px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #fff;
	color: #333;
	font-size: 14px;
	cursor: pointer;
	text-align: center;
}

.btn:hover {
	background: #f5f5f5;
}

.btn-primary {
	background: #121212;
	border-color: #121212;
	color: #fff;
}

.btn-primary:hover {
	background: #000;
}

.btn-line {
	background: #fff;
	border-color: #121212;
	color: #121212;
}

.btn-danger {
	background: #fff;
	border-color: #e74c3c;
	color: #e74c3c;
}

.btn-danger:hover {
	background: #fdecea;
}

.btn-block {
	width: 100%;
}

/* ===== Header ===== */
.top-bar {
	display: flex;
	justify-content: space-between;
	padding: 8px 50px;
	font-size: 12px;
	color: #888;
	background: #f9f9f9;
	border-bottom: 1px solid #eee;
}

.top-bar a {
	color: #888;
	margin-right: 15px;
}

.main-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 20px 50px;
	background: #fff;
	border-bottom: 1px solid #f5f5f5;
}

.logo {
	font-size: 28px;
	font-weight: bold;
	color: #000;
	flex: 1;
}

.search-container {
	flex: 2;
	display: flex;
	justify-content: center;
}

.search-bar {
	width: 80%;
	padding: 10px 16px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #f5f5f5;
	outline: none;
	font-size: 14px;
	white-space: nowrap;
}

.search-btn {
	padding: 10px 16px;
	background: #121212;
	color: #fff;
	border: 1px solid #121212;
	border-radius: 0 4px 4px 0;
	cursor: pointer;
	font-size: 14px;
	cursor: pointer;
	font-size: 14px;
	white-space: nowrap;
}

.header-right {
	flex: 2;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 12px;
	white-space: nowrap;
}

.nav-link {
	font-size: 14px;
	color: #333;
}

.nav-link:hover {
	text-decoration: underline;
}

.admin-link {
	color: #e74c3c;
	font-weight: bold;
}

/* ===== 알림 벨 래퍼 (드롭다운 기준점) ===== */
.noti-wrapper {
	position: relative;
	display: inline-block;
}

/* 벨 버튼 */
.noti-btn {
	position: relative;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 36px;
	height: 36px;
	border-radius: 50%;
	background: #f5f5f5;
	border: 1px solid #ddd;
	cursor: pointer;
	color: #444;
	font-size: 16px;
	text-decoration: none;
	transition: background 0.15s;
}

.noti-btn:hover, .noti-btn.active {
	background: #ebebeb;
}

/* 읽지 않은 알림 뱃지 */
.noti-badge {
	position: absolute;
	top: -4px;
	right: -4px;
	min-width: 16px;
	height: 16px;
	padding: 0 4px;
	background: #e74c3c;
	color: #fff;
	font-size: 10px;
	font-weight: bold;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	line-height: 1;
}

.noti-badge.hidden {
	display: none;
}

/* ===== 드롭다운 패널 ===== */
.noti-dropdown {
	display: none;
	position: absolute;
	top: calc(100% + 10px);
	right: 0;
	width: 340px;
	background: #fff;
	border: 1px solid #e0e0e0;
	border-radius: 10px;
	box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
	z-index: 9999;
	overflow: hidden;
}

.noti-dropdown.open {
	display: block;
}

/* 드롭다운 헤더 */
.noti-dropdown-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 14px 16px 10px;
	border-bottom: 1px solid #f0f0f0;
}

.noti-dropdown-header span {
	font-size: 15px;
	font-weight: bold;
	color: #111;
}

.noti-read-all-btn {
	font-size: 12px;
	color: #888;
	background: none;
	border: none;
	cursor: pointer;
	padding: 0;
}

.noti-read-all-btn:hover {
	color: #333;
	text-decoration: underline;
}

/* 알림 아이템 */
.noti-drop-list {
	list-style: none;
	margin: 0;
	padding: 0;
	max-height: 380px;
	overflow-y: auto;
}

.noti-drop-item {
	display: flex;
	align-items: flex-start;
	gap: 10px;
	padding: 12px 16px;
	border-bottom: 1px solid #f5f5f5;
	cursor: pointer;
	transition: background 0.1s;
}

.noti-drop-item:hover {
	background: #f9f9f9;
}

.noti-drop-item:last-child {
	border-bottom: none;
}

/* 읽지 않은 항목 */
.noti-drop-item.unread {
	background: #fffbf0;
	border-left: 3px solid #f39c12;
}

.noti-drop-item.unread:hover {
	background: #fff8e6;
}

/* 아이콘 원 */
.noti-drop-icon {
	flex-shrink: 0;
	width: 34px;
	height: 34px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 14px;
	color: #fff;
}

.noti-drop-icon.favorite {
	background: #e74c3c;
}

.noti-drop-icon.comment {
	background: #3498db;
}

.noti-drop-icon.review {
	background: #9b59b6;
}

.noti-drop-icon.sold {
	background: #27ae60;
}

.noti-drop-icon.bought {
	background: #2980b9;
}

.noti-drop-icon.notice {
	background: #e67e22;
}

.noti-drop-icon.default {
	background: #aaa;
}

/* 텍스트 영역 */
.noti-drop-body {
	flex: 1;
	min-width: 0;
}

.noti-drop-msg {
	font-size: 13px;
	color: #222;
	line-height: 1.45;
	word-break: break-word;
}

.noti-drop-time {
	font-size: 11px;
	color: #bbb;
	margin-top: 3px;
}

/* 빈 상태 */
.noti-drop-empty {
	text-align: center;
	padding: 36px 20px;
	color: #bbb;
	font-size: 13px;
}

/* 드롭다운 하단 - 전체보기 */
.noti-dropdown-footer {
	padding: 10px 16px;
	border-top: 1px solid #f0f0f0;
	text-align: center;
}

.noti-dropdown-footer a {
	font-size: 13px;
	color: #555;
}

.noti-dropdown-footer a:hover {
	color: #111;
	text-decoration: underline;
}
</style>

<header>
	<div class="top-bar">
		<div>
			<a href="${ctx}/home">홈</a> <a href="${ctx}/productList">상품 목록</a>
		</div>
		<div>TEAM 404</div>
	</div>

	<div class="main-header">
		<a href="${ctx}/home" class="logo">team404</a>

		<form class="search-container" id="searchForm"
			action="${ctx}/product/search" method="get"
			onsubmit="return validateSearch()">
			<input type="text" name="keyword" id="searchInput" class="search-bar"
				placeholder="상품명 검색" value="${keyword}">
			<button type="submit" class="search-btn">검색</button>
		</form>


		<div class="header-right">
			<c:if test="${empty sessionScope.loginUser}">
				<a href="${ctx}/login" class="btn">로그인</a>
				<a href="${ctx}/signup" class="btn btn-primary">회원가입</a>
			</c:if>

			<c:if test="${not empty sessionScope.loginUser}">
				<span
					style="font-size: 14px; font-weight: bold; margin-right: 10px;">
					${sessionScope.loginUser.userNickName}님 </span>

				<div class="noti-wrapper">
					<button type="button" class="noti-btn" id="notiBtn" title="알림">
						<i class="fa-solid fa-bell"></i> <span class="noti-badge hidden"
							id="notiBadge"></span>
					</button>

					<div class="noti-dropdown" id="notiDropdown">
						<div class="noti-dropdown-header">
							<span>알림</span>
							<button type="button" class="noti-read-all-btn"
								id="notiReadAllBtn">전체 읽음</button>
						</div>
						<ul class="noti-drop-list" id="notiDropList">
							<li class="noti-drop-empty">불러오는 중...</li>
						</ul>
						<div class="noti-dropdown-footer">
							<a href="${ctx}/notification">전체 알림 보기</a>
						</div>
					</div>
				</div>

				<a href="${ctx}/favorite" class="nav-link">찜목록</a>
				<a href="${ctx}/mypage" class="nav-link">마이페이지</a>

				<c:if test="${sessionScope.loginUser.userRole == 'ROLE_ADMIN'}">
					<a href="${ctx}/users/search/allUsers" class="nav-link admin-link">계정관리</a>
				</c:if>

				<form action="${ctx}/logout" method="post"
					style="display: inline; margin: 0;">
					<button type="submit" class="btn">로그아웃</button>
				</form>
			</c:if>
		</div>
	</div>
</header>
<!-- 검색창에 검색어 없을 때 경고창 뜨게 함  -->
<script>
			function validateSearch() {
				var keyword = document.getElementById('searchInput').value
						.trim();
				if (keyword === '') {
					alert('검색어를 입력하세요.');
					return false; // ← form 제출 막기
				}
				return true; // ← 검색어 있으면 제출
			}
		</script>
<%-- ★ 알림 드롭다운 스크립트 (로그인 상태일 때만) --%>
<c:if test="${not empty sessionScope.loginUser}">
	<script>
(function () {
	var ctx      = '${ctx}';
	var btn      = document.getElementById('notiBtn');
	var dropdown = document.getElementById('notiDropdown');
	var badge    = document.getElementById('notiBadge');
	var list     = document.getElementById('notiDropList');
	var readAllBtn = document.getElementById('notiReadAllBtn');

	// 아이콘 매핑
	var iconMap = {
		favorite : { cls: 'favorite', fa: 'fa-heart' },
		comment  : { cls: 'comment',  fa: 'fa-comment' },
		review   : { cls: 'review',   fa: 'fa-star' },
		sold     : { cls: 'sold',     fa: 'fa-circle-check' },
		bought   : { cls: 'bought',   fa: 'fa-bag-shopping' },
		notice   : { cls: 'notice',   fa: 'fa-bullhorn' }
	};

	// 시간 포맷 (방금/N분전/N시간전/날짜)
	function formatTime(dateStr) {
		var now  = new Date();
		var past = new Date(dateStr);
		var diff = Math.floor((now - past) / 1000); // 초
		if (diff < 60)  return '방금 전';
		if (diff < 3600) return Math.floor(diff / 60) + '분 전';
		if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
		var m = past.getMonth() + 1;
		var d = past.getDate();
		return (m < 10 ? '0' : '') + m + '.' + (d < 10 ? '0' : '') + d;
	}

	// 드롭다운 렌더링
	function renderList(notifications) {
		if (!notifications || notifications.length === 0) {
			list.innerHTML = '<li class="noti-drop-empty">새 알림이 없습니다.</li>';
			return;
		}
		var html = '';
		notifications.forEach(function (n) {
			var icon = iconMap[n.notiType] || { cls: 'default', fa: 'fa-bell' };
			var unreadCls = n.read ? '' : 'unread';
			html += '<li class="noti-drop-item ' + unreadCls + '" '
				  + 'onclick="notiClick(' + n.notificationNo + ', \'' + (n.linkUrl || '') + '\')">'
				  + '<div class="noti-drop-icon ' + icon.cls + '">'
				  + '<i class="fa-solid ' + icon.fa + '"></i></div>'
				  + '<div class="noti-drop-body">'
				  + '<div class="noti-drop-msg">' + n.message + '</div>'
				  + '<div class="noti-drop-time">' + formatTime(n.createdTime) + '</div>'
				  + '</div></li>';
		});
		list.innerHTML = html;
	}

	// 뱃지 갱신
	function updateBadge(count) {
		if (count > 0) {
			badge.textContent = count > 99 ? '99+' : count;
			badge.classList.remove('hidden');
		} else {
			badge.classList.add('hidden');
		}
	}

	// 알림 목록 AJAX 요청
	function fetchNotifications() {
		$.getJSON(ctx + '/notification/recent', function (data) {
			updateBadge(data.unreadCount || 0);
			renderList(data.notifications);
		});
	}

	// 뱃지만 갱신 (드롭다운 닫혀있을 때 폴링)
	function fetchBadgeOnly() {
		$.getJSON(ctx + '/notification/unread-count', function (data) {
			updateBadge(data.count || 0);
		});
	}

	// 벨 버튼 클릭 → 드롭다운 토글
	btn.addEventListener('click', function (e) {
		e.stopPropagation();
		var isOpen = dropdown.classList.contains('open');
		if (isOpen) {
			dropdown.classList.remove('open');
			btn.classList.remove('active');
		} else {
			dropdown.classList.add('open');
			btn.classList.add('active');
			fetchNotifications(); // 열릴 때 최신 목록 로드
		}
	});

	// 외부 클릭 시 드롭다운 닫기
	document.addEventListener('click', function (e) {
		if (!dropdown.contains(e.target) && e.target !== btn) {
			dropdown.classList.remove('open');
			btn.classList.remove('active');
		}
	});

	// 전체 읽음 버튼
	readAllBtn.addEventListener('click', function () {
		$.post(ctx + '/notification/read-all', function () {
			fetchNotifications();
		});
	});

	// 알림 클릭 → 읽음 처리 + 페이지 이동
	window.notiClick = function (notiNo, linkUrl) {
		$.post(ctx + '/notification/read', { no: notiNo }, function () {
			dropdown.classList.remove('open');
			btn.classList.remove('active');
			if (linkUrl && linkUrl.trim() !== '') {
				window.location.href = linkUrl;
			}
		});
	};

	// 페이지 로드 즉시 뱃지 갱신 + 30초마다 폴링
	fetchBadgeOnly();
	setInterval(fetchBadgeOnly, 30000);
})();
</script>
</c:if>