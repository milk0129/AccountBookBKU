<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% 
	    request.setCharacterEncoding("UTF-8");
	    String param = request.getParameter("category");
	    String path;
	
	    if (param == null) {
	        path = "outline.jsp";
	    } else {
	        switch (param) {
	            case "home":
	                path = "outline.jsp";
	                break;
	            case "signUp":
	                path = "./../userJsp/signUp.jsp";
	                break;
	            case "login":
	                path = "./../userJsp/login.jsp";
	                break;
	            case "history":
	                path = "historyMain.jsp";
	                break;
	            case "find-id":
	                path = "./../userJsp/find-id.jsp";
	                break;
	            default:
	                path = "outline.jsp";
	                break;
	        }
	    }
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부</title>
<link rel="icon" href="../img/favicon.ico" type="image/x-icon">
<style>
body::-webkit-scrollbar {
	display: none;
}

html {
	overflow-y: scroll; /* 수직 스크롤 항상 공간 확보 */
}

/* 파이어폭스 */
body {
	scrollbar-width: none; /* 파이어폭스 전용 */
	-ms-overflow-style: none; /* IE 10+ */
}
</style>
</head>
<body>
	<jsp:include page="mainTop.jsp"></jsp:include>
	<jsp:include page="<%= path %>"></jsp:include>
	<jsp:include page="mainBottom.jsp"></jsp:include>
</body>
</html>
