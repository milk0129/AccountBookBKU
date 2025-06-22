<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="proJSP.UserDTO"%>
<%@ page import="proJSP.UserDAO"%>

<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("name");
    String birth = request.getParameter("birth");
    String userId = request.getParameter("userId");
    String resultMsg = "";
    if (name != null && birth != null && userId != null) {
        name = name.trim();
        birth = birth.trim();
        userId = userId.trim();

        if (!name.isEmpty() && !birth.isEmpty() && !userId.isEmpty()) {
            UserDTO dto = new UserDTO(userId, name, birth);
            UserDAO dao = new UserDAO();

            boolean exists = dao.isUserExists(userId);
            if (exists) {
                resultMsg = "이미 사용 중인 아이디입니다.";
            } else {
                int result = dao.insertUser(dto);
                if (result > 0) {
                    // 회원가입 성공 시 로그인 페이지로 이동
                    resultMsg = "회원가입 성공!";
                } else {
                    resultMsg = "회원가입 실패. 다시 시도해주세요.";
                }
            }
        } else {
            resultMsg = "모든 항목을 빠짐없이 입력해주세요.";
        }
    }
%>
<% if ("회원가입 성공!".equals(resultMsg)) { %>
<script>
    setTimeout(function () {
        window.top.location.href = './../mainJsp/index.jsp?category=login';
    }, 2000);
</script>
<% } %>
<link rel="stylesheet" href="../css/loginstyle.css">
<div id="userWrapper">
	<main>
		<header>
			<h2>회원가입</h2>
			<script src="../jas/theme.js"></script>
		</header>

		<section>
			<form method="post" action="index.jsp?category=signUp">
				<label for="name">이름</label> <input type="text" id="name"
					name="name" placeholder="이름" required
					value="<%= name != null ? name : "" %>"> <label for="birth">생년월일</label>
				<input type="date" id="birth" name="birth" required
					value="<%= birth != null ? birth : "" %>"> <label
					for="userId">아이디</label> <input type="text" id="userId"
					name="userId" placeholder="아이디" required
					value="<%= userId != null ? userId : "" %>">

				<button type="submit">회원가입</button>
			</form>

			<p id="resultMsg"
				style="<% out.print("color:" + ("회원가입 성공!".equals(resultMsg) ? "green" : "red")); %>;">
				<%= resultMsg %>
			</p>
		</section>


		<footer>
			<p>
				이미 회원이신가요? <a href="index.jsp?category=login">로그인</a>
			</p>
		</footer>
	</main>
</div>