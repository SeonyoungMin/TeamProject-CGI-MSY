<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="${ctx}/resources/css/common.css">

<header>
	<div class="top-bar">
		<div class="header-inner">
			<div class="top-bar-group">
				<a href="${ctx}/home">홈</a>
				<span class="top-bar-divider">|</span>
				<a href="${ctx}/productList">상품 목록</a>
			</div>
			<div class="top-bar-group">
				<a href="${ctx}/notice" class="notice-link">공지사항</a>
				<span class="top-bar-divider">|</span>
				<span>MOGU</span>
			</div>
		</div>
	</div>

	<div class="main-header">
		<div class="header-inner">
			<a href="${ctx}/home" class="logo">
			<div class="logo-main">MOGU</div>
			<div class="logo-sub">모든 구매가 이루어지는 곳. 모구!</div>
			</a>
			
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
								<i class="fa-solid fa-bell"></i>
								<span class="noti-badge hidden" id="notiBadge"></span>
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
							<div class="admin-dropdown-wrapper">
								<button id="adminDropdownBtn" class="admin-dropdown-btn nav-link admin-link">관리 ▾</button>
								<div id="adminDropdownMenu" class="admin-dropdown-menu">
									<a href="${ctx}/users/search/allUsers">계정관리</a>
									<a href="${ctx}/admin/reports">신고관리</a>
									<a href="${ctx}/admin/chat">상담관리</a>
								</div>
							</div>
						</c:if>

						<form action="${ctx}/logout" method="post" class="is-header-1">
							<button type="submit" class="btn">로그아웃</button>
						</form>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</header>

<%@ include file="/WEB-INF/views/chatBot.jsp"%>

<script>
	function validateSearch() {
		var keyword = document.getElementById('searchInput').value.trim();
		if (keyword === '') {
			alert('검색어를 입력하세요.');
			return false;
		}
		return true;
	}
	
    var adminBtn = document.getElementById('adminDropdownBtn');
    if (adminBtn) {
        adminBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var menu = document.getElementById('adminDropdownMenu');
            menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', function() {
            var menu = document.getElementById('adminDropdownMenu');
            if (menu) menu.style.display = 'none';
        });
    }
</script>


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
				favorite : { cls : 'favorite', fa : 'fa-heart' },
				comment : { cls : 'comment', fa : 'fa-comment' },
				review : { cls : 'review', fa : 'fa-star' },
				sold : { cls : 'sold', fa : 'fa-circle-check' },
				bought : { cls : 'bought', fa : 'fa-bag-shopping' },
				notice : { cls : 'notice', fa : 'fa-bullhorn' },
				waitlist : { cls : 'notice', fa : 'fa-bell' },
				transfer_request : { cls : 'bought', fa : 'fa-paper-plane' },
				transfer_approved : { cls : 'sold', fa : 'fa-circle-check' },
				trade_cancelled : { cls : 'favorite', fa : 'fa-ban' },
				trade_rejected : { cls : 'favorite', fa : 'fa-circle-xmark' },
				report : { cls : 'notice', fa : 'fa-flag' }
			};

			function formatTime(dateStr) {
				var now = new Date();
				var past = new Date(dateStr);
				past.setHours(past.getHours() + 9);
				var diff = Math.floor((now - past) / 1000);
				if (diff < 60) return '방금 전';
				if (diff < 3600) return Math.floor(diff / 60) + '분 전';
				if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
				var m = past.getMonth() + 1, d = past.getDate();
				return (m < 10 ? '0' : '') + m + '.' + (d < 10 ? '0' : '') + d;
			}

			function renderList(notifications) {
				if (!notifications || notifications.length === 0) {
					list.innerHTML = '<li class="noti-drop-empty">새 알림이 없습니다.</li>';
					return;
				}
				var html = '';
				notifications.forEach(function(n) {
					var icon = iconMap[n.notiType] || { cls : 'default', fa : 'fa-bell' };
					var cls = n.read ? '' : 'unread';
					html += '<li class="noti-drop-item ' + cls + '" onclick="notiClick(' + n.notificationNo + ',\'' + (n.linkUrl || '') + '\')">'
						+ '<div class="noti-drop-icon ' + icon.cls + '"><i class="fa-solid ' + icon.fa + '"></i></div>'
						+ '<div class="noti-drop-body">'
						+ '<div class="noti-drop-msg">' + n.message + '</div>'
						+ '<div class="noti-drop-time">' + formatTime(n.createdTime) + '</div>'
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
				if (!isOpen) fetchNotifications();
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
				$.post(ctx + '/notification/read', { no : notiNo }, function() {
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