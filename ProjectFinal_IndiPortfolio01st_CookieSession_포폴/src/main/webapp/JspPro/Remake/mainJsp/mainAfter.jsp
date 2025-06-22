<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link rel="stylesheet" href="./../css/mainMenu.css">

<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        userName = "회원"; // 세션 없으면 기본
    }
    String loginUser = (String) session.getAttribute("userId");
    if (loginUser == null) {
        response.sendRedirect("login_index.jsp");
        return;
    }
%>
<div id="mainWrapper">
	<script src="../jas/theme.js"></script>
	<header>
		<nav>
			<img src="../img/logo.jpg">
			<ul>
				<li class="li_menu"><a href="login_index.jsp?category=home">홈</a></li>
				<!-- <li class="li_menu"><a href="../boardJsp/jsp/boardTitleListPaging.jsp">게시판</a></li> -->
				<li class="li_menu"><a href="login_index.jsp?category=user"><%= userName %>
						님</a></li>
				<li class="logout"><a
					href="<%= request.getContextPath() %>/JspPro/Remake/userJsp/logout.jsp"
					class="logout-button">로그아웃</a></li>
				<!-- 버튼 예시: 메뉴 우측 등 원하는 위치 -->
				<li class="li_menu">
					<button onclick="toggleTheme()" class="theme-toggle">🌓 테마</button>
				</li>
			</ul>
		</nav>
	</header>
	<div class="li_outline"></div>
</div>