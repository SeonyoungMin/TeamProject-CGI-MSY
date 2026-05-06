<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div id="header-container"
	style="width: 1440px; height: 144px; position: relative; background: white;">
	<!-- 보조 메뉴 -->
	<div
		style="width: 1440px; height: 34px; background: #F6F6F6; position: absolute;"></div>
	<div
		style="left: 60px; top: 10px; position: absolute; color: #878787; font-size: 11px;">공지사항</div>

	<!-- 로그인 정보 (세션 활용) -->
	<div
		style="left: 1340px; top: 10px; position: absolute; color: #878787; font-size: 11px;">
		<c:choose>
			<c:when test="${empty sessionScope.user}">
				<span class="pointer" onclick="location.href='/minimarket/login'">로그인</span> | 
            <span class="pointer"
					onclick="location.href='/minimarket/users/new'">회원가입</span>
			</c:when>
			<c:otherwise>
				<span class="pointer" onclick="location.href='/minimarket/logout'">로그아웃</span>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- 메인 로고 및 검색 -->
	<div class="pointer" onclick="location.href='/minimarket/'"
		style="left: 94px; top: 49px; position: absolute; color: #121212; font-size: 26px; font-weight: 700;">team404</div>

	<div
		style="width: 540px; height: 32px; left: 440px; top: 51px; position: absolute; background: #F6F6F6; border: 1px #E6E6E6 solid; border-radius: 4px;">
		<input type="text" placeholder="상품명, 카테고리 검색"
			style="width: 100%; height: 100%; border: none; background: transparent; padding-left: 15px;">
	</div>
</div>
<hr style="margin: 0; border: 0; height: 1px; background: #E6E6E6;">