<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="./../css/mainMenu.css">
<div id="mainWrapper">
	<header>
		<nav>
			<img src="../img/logo.jpg">
			<ul>
				<li class="li_menu"><a href="index.jsp?category=home">홈</a></li>
				<li class="li_menu"><a href="index.jsp?category=login">로그인</a></li>
				<li class="li_menu"><a href="index.jsp?category=signUp">
						회원가입</a></li>
				<!-- 버튼 예시: 메뉴 우측 등 원하는 위치 -->
				<li class="li_menu">
					<button class="theme-toggle" onclick="toggleTheme()">🌓 테마</button>
				</li>

			</ul>
		</nav>
	</header>

	<div class="li_outline"></div>
</div>