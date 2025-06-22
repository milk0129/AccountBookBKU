<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="proJSP.UserDAO"%>

<link rel="stylesheet" href="../css/loginstyle.css">

<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("findName");
    String birth = request.getParameter("findBirth");
    String resultMsg = "";

    if (name != null && birth != null) {
        name = name.trim();
        birth = birth.trim();

        if (!name.isEmpty() && !birth.isEmpty()) {
            UserDAO dao = new UserDAO();
            String foundId = dao.findUserId(name, birth);

            if (foundId != null) {
                resultMsg = "찾은 아이디: " + foundId;
            } else {
                resultMsg = "일치하는 회원 정보를 찾을 수 없습니다.";
            }
        } else {
            resultMsg = "이름과 생년월일을 모두 입력해주세요.";
        }
    }
%>
<div id="userWrapper">
	<main>
		<header>
			<h2>아이디 찾기</h2>
			<script src="../jas/theme.js"></script>
		</header>

		<section class="container">
			<form method="post" action="index.jsp?category=find-id">
				<label for="findName">이름</label> <input type="text" id="findName"
					name="findName" placeholder="이름" required
					value="<%= name != null ? name : "" %>"> <label
					for="findBirth">생년월일</label> <input type="date" id="findBirth"
					name="findBirth" required value="<%= birth != null ? birth : "" %>">

				<button type="submit">아이디 찾기</button>
			</form>
			<p id="resultMsg"><%= resultMsg %></p>
		</section>

		<footer>
			<p>
				<a href="index.jsp?category=login">로그인하기</a>
			</p>
		</footer>
	</main>
</div>