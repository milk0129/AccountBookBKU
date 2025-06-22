<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="commonPro.*"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>
<link rel="stylesheet" href="./../css/boardViewFrame.css">
<link rel="icon" href="../img/favicon.ico" type="image/x-icon">
</head>
<body>

	<%
    int vNo = 0, vHits = 0;
    String vWrite = "", vTitle = "", vRegTime = "", vContent = "", temp = "";

    Connection conn = DbSet.getConnection();
    Statement stmt = conn.createStatement();
    temp = request.getParameter("num");
    if (temp != null) {
        vNo = Integer.parseInt(temp);
    }

    String sql = "SELECT * FROM board WHERE num = " + vNo;
    ResultSet rs = stmt.executeQuery(sql);

    while (rs.next()) {
        vNo = rs.getInt("num");
        vWrite = rs.getString("writer");
        vTitle = rs.getString("title").replace(" ", "&nbsp;");
        vRegTime = rs.getString("regtime");
        vContent = rs.getString("content").replace(" ", "&nbsp;").replace("\n", "<br>");
        vHits = rs.getInt("hits") + 1;

        stmt.executeUpdate("UPDATE board SET hits = hits + 1 WHERE num = " + vNo);
    }

    rs.close();
    stmt.close();
    conn.close();
%>

	<h2>** 게시글 **</h2>

	<form>
		<div class="menu">
			<p>
				<span style="cursor: pointer;"
					onclick="location.href='boardUpdateFrame.jsp?num=<%=vNo%>'">[
					수정 ]</span> <span style="cursor: pointer;"
					onclick="location.href='boardDeleteFrame.jsp?num=<%=vNo%>'">[
					삭제 ]</span> <span style="cursor: pointer;"
					onclick="location.href='boardTitleListPaging.jsp'">[ 목록 ]</span>
			</p>
		</div>

		<table>
			<tr>
				<td class="label">작성자</td>
				<td><input type="text" value="<%=vWrite%>" class="input"
					readonly></td>
				<td class="label">날짜</td>
				<td><input type="text" value="<%=vRegTime%>" class="input"
					readonly></td>
			</tr>
			<tr>
				<td class="label">제목</td>
				<td colspan="3"><input type="text" value="<%=vTitle%>"
					class="input full" readonly></td>
			</tr>
			<tr>
				<td rowspan="2" class="label image-cell"><img
					src="../img/side.jpg" alt="Side Image"></td>
				<td colspan="3"><textarea readonly class="input full"><%=vContent%></textarea></td>
			</tr>
		</table>
	</form>

</body>
</html>
