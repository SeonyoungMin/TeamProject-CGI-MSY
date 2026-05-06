<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<div class="mypage-container">
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="content"
		style="display: flex; max-width: 1200px; margin: 0 auto; padding: 20px;">

		<aside style="width: 200px;">
			<h3>${loginUser.userNickName}님</h3>

			<ul>
				<li>내 정보</li>
				<li>내 게시글</li>
			</ul>
		</aside>



		</main>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>
</div>

