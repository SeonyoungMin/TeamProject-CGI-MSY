<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
.report-modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 99999;
	justify-content: center;
	align-items: center;
}

.report-modal-overlay.open {
	display: flex;
}

.report-modal {
	background: #fff;
	border-radius: 10px;
	padding: 28px;
	width: 480px;
	max-width: 90%;
}

.report-modal h3 {
	margin: 0 0 20px;
	font-size: 18px;
}

.report-modal select, .report-modal textarea {
	width: 100%;
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
	margin-bottom: 12px;
	box-sizing: border-box;
}

.report-modal textarea {
	min-height: 100px;
	resize: vertical;
}

.report-modal-footer {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	margin-top: 8px;
}
</style>

<div class="report-modal-overlay" id="reportModalOverlay">
	<div class="report-modal">
		<h3>신고하기</h3>
		<form id="reportForm" action="${ctx}/report" method="post"
			enctype="multipart/form-data">
			<input type="hidden" id="reportTargetType" name="targetType">
			<input type="hidden" id="reportTargetNo" name="targetNo"> <label
				class="form-label">신고 사유</label> <select name="reasonType"
				id="reportReasonType" required>
				<option value="">선택하세요</option>
			</select> <label class="form-label">상세 내용 (선택)</label>
			<textarea name="reasonDetail" placeholder="추가 내용을 입력하세요"></textarea>

			<label class="form-label">첨부 이미지 (선택)</label> <input type="file"
				name="evidenceFile" accept="image/*" multiple
				style="font-size: 13px; margin-bottom: 12px;">
			<div id="reportErrorMsg"
				style="display: none; color: #e74c3c; font-size: 13px; margin-bottom: 10px;">
				이미 신고한 대상입니다.</div>
			<div class="report-modal-footer">
				<button type="button" class="btn" onclick="closeReportModal()">취소</button>
				<button type="submit" class="btn btn-danger">신고 접수</button>
			</div>
		</form>
	</div>
</div>

<script>
	var reasonOptions = {
		user : [ 'SCAM_ACCOUNT:사기계좌 사용', 'FRAUD:허위 정보', 'ETC:기타' ],
		product : [ 'FALSE_LISTING:허위매물', 'DUPLICATE:중복 게시', 'ETC:기타' ],
		board : [ 'ABUSE:욕설/비방', 'SPAM:스팸', 'RULE_VIOLATION:규정 위반', 'ETC:기타' ]
	};

	function openReportModal(targetType, targetNo) {
		document.getElementById('reportTargetType').value = targetType;
		document.getElementById('reportTargetNo').value = targetNo;

		var select = document.getElementById('reportReasonType');
		select.innerHTML = '<option value="">선택하세요</option>';
		reasonOptions[targetType].forEach(function(opt) {
			var parts = opt.split(':');
			select.innerHTML += '<option value="' + parts[0] + '">' + parts[1]
					+ '</option>';
		});

		document.getElementById('reportModalOverlay').classList.add('open');
	}

	function closeReportModal() {
		document.getElementById('reportModalOverlay').classList.remove('open');
	}

	document.getElementById('reportModalOverlay').addEventListener('click',
			function(e) {
				if (e.target === this)
					closeReportModal();
			});

	document.getElementById('reportForm').addEventListener('submit', function(e) {
	    e.preventDefault();
	    
	    var targetType = document.getElementById('reportTargetType').value;
	    var targetNo = document.getElementById('reportTargetNo').value;
	    
	    $.get('${ctx}/report/check-duplicate', { targetType: targetType, targetNo: targetNo }, function(result) {
	        if (result === 'duplicate') {
	            document.getElementById('reportErrorMsg').style.display = 'block';
	        } else {
	            document.getElementById('reportForm').submit();
	        }
	    });
	});
</script>