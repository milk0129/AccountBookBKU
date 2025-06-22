<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
LocalDate curDate = LocalDate.now();
LocalTime curTime = LocalTime.now();

String curDateTime = LocalDate.now() + " " + LocalTime.now().toString().substring(0, 8);

out.print("<h1 style='color:Green'>");
out.print("LocalDate.now() : " + curDate.toString() + "<br>");
out.print("LocalTime.now() : " + curTime.toString() + "<br>");
out.print(curDateTime + "<br>");
out.print("<h1>");
%>
</body>
</html>
