<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="./../css/historyCss.css">

<%
	String param = request.getParameter("category");
	String path;
	
	if (param == null) {
	    path = "./../historyJsp/historySel.jsp";
	} else {
		switch (param) {
		    case "sel":
		        path = "./../historyJsp/historySel.jsp";
		        break;
		    case "add":
		        path = "./../historyJsp/historyAdd.jsp";
		        break;
		    case "del":
		        path = "./../historyJsp/historyDelete.jsp";
		        break;
		    case "upd":
		        path = "./../historyJsp/historyUpdate.jsp";
		        break;
		    default:
		        path = "./../historyJsp/historySel.jsp";
		        break;
		}
	}

%>
<div id="historyMainWrapper">
	<main>
		<p>가계부</p>
		<div id="div_calendar">
			<jsp:include page="./../historyJsp/calendar.jsp"></jsp:include>

		</div>
		<div id="div_table">
			<jsp:include page="<%= path%>"></jsp:include>
		</div>
	</main>
</div>