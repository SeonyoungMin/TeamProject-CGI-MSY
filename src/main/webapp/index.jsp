<%@ page contentType="text/html;charset=UTF-8"%>
<%-- 컨텍스트 루트 진입 시 곧바로 홈으로 이동 --%>
<% response.sendRedirect(request.getContextPath() + "/home"); %>

