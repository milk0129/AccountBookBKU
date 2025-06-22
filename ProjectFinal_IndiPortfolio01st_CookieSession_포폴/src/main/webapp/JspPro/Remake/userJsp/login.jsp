<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="proJSP.UserDAO"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("loginUserId");
    String resultMsg = "";

    if (userId != null) {
        userId = userId.trim();

        if (!userId.isEmpty()) {
            UserDAO dao = new UserDAO();
            boolean exists = dao.isUserExists(userId);

            if (exists) {
                String userName = dao.getUserName(userId);

                session.setAttribute("userId", userId);
                session.setAttribute("userName", userName);

                // 수정 포인트: iframe 안이 아니라 전체 창 이동
%>
<script>
                    window.top.location.href = '../mainJsp/login_index.jsp';
                </script>
<%
                return; 
            } else {
                resultMsg = "존재하지 않는 아이디입니다.";
            }
        } else {
            resultMsg = "아이디를 입력해주세요.";
        }
    }
%>

<link rel="stylesheet" href="../css/loginstyle.css">
<div id="userWrapper">
	<main>
		<header>
			<h2>로그인</h2>
			<script src="../jas/theme.js"></script>
		</header>

		<section>
			<form method="post" action="index.jsp?category=login">
				<input type="text" id="loginUserId" name="loginUserId"
					placeholder="아이디" required
					value="<%= userId != null ? userId : "" %>">
				<button type="submit">로그인</button>
			</form>
			<p id="resultMsg"><%= resultMsg %></p>
		</section>

		<footer>
			<p>
				아이디를 잊으셨나요? <a href="index.jsp?category=find-id">아이디 찾기</a>
			</p>
			<p>
				아직 회원이 아니신가요? <a href="index.jsp?category=signUp">회원가입</a>
			</p>
		</footer>
	</main>
</div>