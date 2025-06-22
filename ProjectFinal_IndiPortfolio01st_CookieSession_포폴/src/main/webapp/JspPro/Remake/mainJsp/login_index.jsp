<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String param = request.getParameter("category");  // category=user
    String menu = request.getParameter("menu");      		
    String path;

    if ("user".equals(param) && "sel".equals(menu)) {
        path = "historyMain.jsp?category=sel";
        
    } else {
    	
        if ("user".equals(param)) {
            if (menu == null) {
                path = "historyMain.jsp?category=sel";
            } else {
            	path = "historyMain.jsp?category=" + menu;
            }
        } else if ("home".equals(param)) {
            path = "outline.jsp";
        } else {
            path = "historyMain.jsp?category=sel";
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
	overflow-y: scroll;
}

body {
	scrollbar-width: none;
	-ms-overflow-style: none;
}
</style>

</head>
<body>
	<jsp:include page="mainAfter.jsp" />
	<jsp:include page="<%= path %>" />
	<jsp:include page="mainBottom.jsp" />
</body>
</html>