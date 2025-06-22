<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="commonPro.*"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글 수정</title>
<link rel="stylesheet" href="./../css/boardViewFrame.css">
<link rel="icon" href="../img/favicon.ico" type="image/x-icon">
</head>
<body>
	<%
    int num = Integer.parseInt(request.getParameter("num"));

    Connection conn = DbSet.getConnection();
    PreparedStatement pstmt = conn.prepareStatement("SELECT writer, title, content FROM board WHERE num = ?");
    pstmt.setInt(1, num);
    ResultSet rs = pstmt.executeQuery();

    String writer = "", title = "", content = "";
    if (rs.next()) {
        writer = rs.getString("writer");
        title = rs.getString("title");
        content = rs.getString("content");
    }
    rs.close();
    pstmt.close();
    conn.close();
%>

	<h2>** 게시글 수정 **</h2>
	<form action="boardUpdate.jsp" method="post">
		<input type="hidden" name="num" value="<%= num %>">

		<div class="menu">
			<p>
				<span style="cursor: pointer;"
					onclick="location.href='boardTitleListPaging.jsp'">[ 목록 ]</span>
			</p>
		</div>

		<table>
			<tr>
				<td class="label">작성자</td>
				<td colspan="2"><input type="text" name="writer" class="input"
					value="<%= writer %>" readonly></td>
			</tr>
			<tr>
				<td class="label">제목</td>
				<td colspan="3"><input type="text" name="title" class="input"
					value="<%= title %>" required></td>
			</tr>
			<tr>
				<td rowspan="2" class="label image-cell"><img
					src="../img/side.jpg" alt="Side Image"></td>
				<td colspan="3"><textarea name="content" class="input full"
						required><%= content %></textarea></td>
			</tr>
		</table>
		<div class="form-actions">
			<input type="submit" value="수정 완료"> <input type="reset"
				value="다시쓰기">
		</div>
	</form>

</body>
</html>
