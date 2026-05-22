<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
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

.app-container {
	max-width: 1300px;
	margin: 30px auto;
	padding: 0 20px;
}

.section-title {
	font-size: 22px;
	font-weight: bold;
	margin: 0 0 20px 0;
	padding-bottom: 10px;
	border-bottom: 2px solid #121212;
}

.card {
	background: #fff;
	border: 1px solid #eee;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 20px;
}

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

.btn {
	display: inline-block;
	padding: 8px 16px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #fff;
	color: #333;
	font-size: 13px;
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

/* ===== 헤더 공통 inner ===== */
.header-inner {
	max-width: 1300px;
	width: 100%;
	margin: 0 auto;
	padding: 0 20px;
}

/* ===== top-bar ===== */
.top-bar {
	background: #f9f9f9;
	border-bottom: 1px solid #eee;
	padding: 7px 0;
	font-size: 12px;
	color: #888;
}

.top-bar .header-inner {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.top-bar a {
	color: #888;
	margin-right: 14px;
}

/* ===== main-header ===== */
.main-header {
	background: #fff;
	border-bottom: 1px solid #f0f0f0;
	padding: 14px 0;
}

.main-header .header-inner {
	display: flex;
	align-items: center;
	gap: 20px;
}

/* 로고 고정 너비 */
.logo {
	flex: 0 0 110px;
	font-size: 22px;
	font-weight: bold;
	color: #000;
	white-space: nowrap;
}

/* 검색창 나머지 공간 */
.search-container {
	flex: 1;
	display: flex;
	justify-content: center;
	max-width: 500px;
	margin: 0 auto;
}

.search-bar {
	flex: 1;
	padding: 9px 14px;
	border: 1px solid #ddd;
	border-right: none;
	border-radius: 4px 0 0 4px;
	background: #f5f5f5;
	outline: none;
	font-size: 14px;
}

.search-btn {
	padding: 9px 14px;
	background: #121212;
	color: #fff;
	border: 1px solid #121212;
	border-radius: 0 4px 4px 0;
	cursor: pointer;
	font-size: 14px;
	white-space: nowrap;
}

/* 우측 메뉴: 내용에 따라 자동 너비 */
.header-right {
	flex: 0 0 auto;
	display: flex;
	align-items: center;
	gap: 10px;
	white-space: nowrap;
}

.user-nick {
	font-size: 13px;
	font-weight: bold;
}

.nav-link {
	font-size: 13px;
	color: #333;
}

.nav-link:hover {
	text-decoration: underline;
}

.admin-link {
	color: #e74c3c;
	font-weight: bold;
}

/* ===== 알림 벨 ===== */
.noti-wrapper {
	position: relative;
	display: inline-block;
}

.noti-btn {
	position: relative;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 32px;
	height: 32px;
	border-radius: 50%;
	background: #f5f5f5;
	border: 1px solid #ddd;
	cursor: pointer;
	color: #444;
	font-size: 14px;
	transition: background 0.15s;
}

.noti-btn:hover, .noti-btn.active {
	background: #e8e8e8;
}

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
}

.noti-badge.hidden {
	display: none;
}

/* ===== 드롭다운 ===== */
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

.noti-drop-item.unread {
	background: #fffbf0;
	border-left: 3px solid #f39c12;
}

.noti-drop-item.unread:hover {
	background: #fff8e6;
}

.noti-drop-icon {
	flex-shrink: 0;
	width: 32px;
	height: 32px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 13px;
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

.noti-drop-empty {
	text-align: center;
	padding: 36px 20px;
	color: #bbb;
	font-size: 13px;
}

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
		<div class="header-inner">
			<div>
				<a href="${ctx}/home">홈</a> | <a href="${ctx}/productList"> 상품
					목록</a>
			</div>

			<div>
				<a href="${ctx}/notice" class="notice-link"> 공지사항 |</a>TEAM 404
			</div>
		</div>
	</div>

	<div class="main-header">
		<div class="header-inner">
			<a href="${ctx}/home" class="logo">team404</a>

			<form class="search-container" id="searchForm"
				action="${ctx}/product/search" method="get"
				onsubmit="return validateSearch()">
				<input type="text" name="keyword" id="searchInput"
					class="search-bar" placeholder="상품명 검색" value="${keyword}">
				<button type="submit" class="search-btn">검색</button>
			</form>

			<div class="header-right">
				<c:choose>
					<c:when test="${empty sessionScope.loginUser}">
						<a href="${ctx}/login" class="btn">로그인</a>
						<a href="${ctx}/signup" class="btn btn-primary">회원가입</a>
					</c:when>
					<c:otherwise>
						<span class="user-nick">${sessionScope.loginUser.userNickName}님</span>

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
							<a href="${ctx}/users/search/allUsers"
								class="nav-link admin-link">계정관리</a>
						</c:if>

						<form action="${ctx}/logout" method="post" style="margin: 0;">
							<button type="submit" class="btn">로그아웃</button>
						</form>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</header>

<script>
	function validateSearch() {
		var keyword = document.getElementById('searchInput').value.trim();
		if (keyword === '') {
			alert('검색어를 입력하세요.');
			return false;
		}
		return true;
	}
</script>

<c:if test="${not empty sessionScope.loginUser}">
	<script>
		(function() {
			var ctx = '${ctx}';
			var btn = document.getElementById('notiBtn');
			var dropdown = document.getElementById('notiDropdown');
			var badge = document.getElementById('notiBadge');
			var list = document.getElementById('notiDropList');
			var readAllBtn = document.getElementById('notiReadAllBtn');

			var iconMap = {
				favorite : {
					cls : 'favorite',
					fa : 'fa-heart'
				},
				comment : {
					cls : 'comment',
					fa : 'fa-comment'
				},
				review : {
					cls : 'review',
					fa : 'fa-star'
				},
				sold : {
					cls : 'sold',
					fa : 'fa-circle-check'
				},
				bought : {
					cls : 'bought',
					fa : 'fa-bag-shopping'
				},
				notice : {
					cls : 'notice',
					fa : 'fa-bullhorn'
				}
			};

			function formatTime(dateStr) {
				var now = new Date();
				var past = new Date(dateStr);
				var diff = Math.floor((now - past) / 1000);
				if (diff < 60)
					return '방금 전';
				if (diff < 3600)
					return Math.floor(diff / 60) + '분 전';
				if (diff < 86400)
					return Math.floor(diff / 3600) + '시간 전';
				var m = past.getMonth() + 1, d = past.getDate();
				return (m < 10 ? '0' : '') + m + '.' + (d < 10 ? '0' : '') + d;
			}

			function renderList(notifications) {
				if (!notifications || notifications.length === 0) {
					list.innerHTML = '<li class="noti-drop-empty">새 알림이 없습니다.</li>';
					return;
				}
				var html = '';
				notifications
						.forEach(function(n) {
							var icon = iconMap[n.notiType] || {
								cls : 'default',
								fa : 'fa-bell'
							};
							var cls = n.read ? '' : 'unread';
							html += '<li class="noti-drop-item '
									+ cls
									+ '" onclick="notiClick('
									+ n.notificationNo
									+ ',\''
									+ (n.linkUrl || '')
									+ '\')">'
									+ '<div class="noti-drop-icon ' + icon.cls + '"><i class="fa-solid ' + icon.fa + '"></i></div>'
									+ '<div class="noti-drop-body">'
									+ '<div class="noti-drop-msg">' + n.message
									+ '</div>' + '<div class="noti-drop-time">'
									+ formatTime(n.createdTime) + '</div>'
									+ '</div></li>';
						});
				list.innerHTML = html;
			}

			function updateBadge(count) {
				if (count > 0) {
					badge.textContent = count > 99 ? '99+' : count;
					badge.classList.remove('hidden');
				} else {
					badge.classList.add('hidden');
				}
			}

			function fetchNotifications() {
				$.getJSON(ctx + '/notification/recent', function(data) {
					updateBadge(data.unreadCount || 0);
					renderList(data.notifications);
				});
			}

			function fetchBadgeOnly() {
				$.getJSON(ctx + '/notification/unread-count', function(data) {
					updateBadge(data.count || 0);
				});
			}

			btn.addEventListener('click', function(e) {
				e.stopPropagation();
				var isOpen = dropdown.classList.contains('open');
				dropdown.classList.toggle('open', !isOpen);
				btn.classList.toggle('active', !isOpen);
				if (!isOpen)
					fetchNotifications();
			});

			document.addEventListener('click', function(e) {
				if (!dropdown.contains(e.target) && e.target !== btn) {
					dropdown.classList.remove('open');
					btn.classList.remove('active');
				}
			});

			readAllBtn.addEventListener('click', function() {
				$.post(ctx + '/notification/read-all', function() {
					fetchNotifications();
				});
			});

			window.notiClick = function(notiNo, linkUrl) {
				$.post(ctx + '/notification/read', {
					no : notiNo
				}, function() {
					dropdown.classList.remove('open');
					btn.classList.remove('active');
					if (linkUrl && linkUrl.trim() !== '')
						window.location.href = linkUrl;
				});
			};

			fetchBadgeOnly();
			setInterval(fetchBadgeOnly, 30000);
		})();
	</script>
</c:if>
