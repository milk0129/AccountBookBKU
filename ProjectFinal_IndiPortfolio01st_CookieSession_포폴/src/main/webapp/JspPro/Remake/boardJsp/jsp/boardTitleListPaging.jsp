<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="commonPro.*"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자유게시판</title>
<link rel="stylesheet" href="./../css/boardTitleList.css">
<link rel="icon" href="../img/favicon.ico" type="image/x-icon">
</head>
<body>
	<div id="wrapper">
		<%
    request.setCharacterEncoding("UTF-8");

    String searchKeyword = request.getParameter("search");
    if (searchKeyword == null) searchKeyword = "";

    String searchField = request.getParameter("searchField");
    if (searchField == null || searchField.trim().equals("")) searchField = "title";

    String recPerPageParam = request.getParameter("recPerPage");
    int recPerPage = (recPerPageParam != null) ? Integer.parseInt(recPerPageParam) : 10;
    int pagePerBlock = 10;
    int totalRecord = 0;
    int nowPage = request.getParameter("nowPage") != null ? Integer.parseInt(request.getParameter("nowPage")) : 0;
    int nowBlock = request.getParameter("nowBlock") != null ? Integer.parseInt(request.getParameter("nowBlock")) : 0;

    Connection conn = DbSet.getConnection();

    // 1. 조건에 따라 WHERE절 설정
    String whereClause = "";
    if ("title_content".equals(searchField)) {
        whereClause = "(title LIKE ? OR content LIKE ?)";
    } else if ("title".equals(searchField)) {
        whereClause = "title LIKE ?";
    } else if ("content".equals(searchField)) {
        whereClause = "content LIKE ?";
    } else if ("writer".equals(searchField)) {
        whereClause = "writer LIKE ?";
    } else {
        whereClause = "title LIKE ?"; // fallback
    }

    // 2. 총 레코드 수 쿼리
    String countSql = "SELECT COUNT(*) FROM board WHERE " + whereClause;
    PreparedStatement countPstmt = conn.prepareStatement(countSql);

    if ("title_content".equals(searchField)) {
        countPstmt.setString(1, "%" + searchKeyword + "%");
        countPstmt.setString(2, "%" + searchKeyword + "%");
    } else {
        countPstmt.setString(1, "%" + searchKeyword + "%");
    }

    ResultSet countRs = countPstmt.executeQuery();
    if (countRs.next()) totalRecord = countRs.getInt(1);
    countRs.close();
    countPstmt.close();

    int totalPage = (int)Math.ceil((double)totalRecord / recPerPage);
    int totalBlock = (int)Math.ceil((double)totalPage / pagePerBlock);

    int recOfBeginPage = nowPage * recPerPage + 1;
    int recOfEndPage = recOfBeginPage + recPerPage - 1;

    // 3. 실제 게시글 리스트 조회
    String sql =
        "SELECT * FROM ("
        + " SELECT ROWNUM AS rnum, innerQ.* FROM ("
        + "   SELECT * FROM board WHERE " + whereClause + " ORDER BY num DESC"
        + " ) innerQ"
        + ") WHERE rnum BETWEEN ? AND ?";

    PreparedStatement pstmt = conn.prepareStatement(sql);
    int paramIdx = 1;
    if ("title_content".equals(searchField)) {
        pstmt.setString(paramIdx++, "%" + searchKeyword + "%");
        pstmt.setString(paramIdx++, "%" + searchKeyword + "%");
    } else {
        pstmt.setString(paramIdx++, "%" + searchKeyword + "%");
    }
    pstmt.setInt(paramIdx++, recOfBeginPage);
    pstmt.setInt(paramIdx++, recOfEndPage);

    ResultSet rs = pstmt.executeQuery();
%>


		<p id="boardTitle" style="cursor: pointer;">** 자유게시판 **</p>

		<script>
document.getElementById("boardTitle").onclick = function () {
    var url = window.location.href;
    var base = url.split('?')[0];
    window.location.href = base + "?nowPage=0&nowBlock=0&recPerPage=<%=recPerPage%>";
};
</script>

		<!-- 게시글 수 선택 -->
		<div class="pageNumSel">
			<form method="get" action="boardTitleListPaging.jsp"
				id="recPerPageForm" style="display: inline;">
				<input type="hidden" name="search" value="<%=searchKeyword%>">
				<input type="hidden" name="nowPage" value="0"> <input
					type="hidden" name="nowBlock" value="0">

				<!-- <label for="recPerPage" class="labe_rec">표시 개수:</label>  -->
				<select name="recPerPage" id="recPerPage"
					onchange="document.getElementById('recPerPageForm').submit()">
					<option value="10" <%= recPerPage == 10 ? "selected" : "" %>>10개</option>
					<option value="30" <%= recPerPage == 30 ? "selected" : "" %>>30개</option>
					<option value="50" <%= recPerPage == 50 ? "selected" : "" %>>50개</option>
					<option value="100" <%= recPerPage == 100 ? "selected" : "" %>>100개</option>
				</select>
			</form>
			<%
	    String userId = (String) session.getAttribute("userId");
	%>
			<a
				href="<%= request.getContextPath() %>/JspPro/Remake/mainJsp/login_index.jsp?userId=<%=userId %>">[가계부]</a>
			<a href="boardInsertFrame.jsp" style="margin-left: 10px;">[게시글
				작성]</a>

		</div>


		<form>
			<table>
				<thead>
					<tr>
					</tr>
					<tr class="list">
						<td>번호</td>
						<td width="300px">제목</td>
						<td>글쓴이</td>
						<td>등록일</td>
						<td>조회</td>
					</tr>
				</thead>
				<tbody id="boardBody">
					<%
            while (rs.next()) {
                int vNo = rs.getInt("num");
                String vWrite = rs.getString("writer");
                String vTitle = rs.getString("title");
                String vRegTime = rs.getString("regtime");
                String vHits = rs.getString("hits");
        %>
					<tr class="context"
						onclick="location.href='boardViewFrame.jsp?num=<%=vNo%>'">
						<td><%= vNo %></td>
						<td><%= vTitle %></td>
						<td><%= vWrite %></td>
						<td><%= vRegTime %></td>
						<td><%= vHits %></td>
					</tr>
					<%
            }
            rs.close(); pstmt.close(); conn.close();
        %>
				</tbody>
			</table>
		</form>

		<!-- 페이지네이션 -->
		<div class="center">
			<div class="pagination">
				<% if (nowBlock > 0) { %>
				<a
					href="boardTitleListPaging.jsp?nowBlock=<%=nowBlock - 1%>&nowPage=<%=(nowBlock - 1) * pagePerBlock%>&recPerPage=<%=recPerPage%>&search=<%=searchKeyword%>&searchField=<%=searchField%>">&laquo;</a>
				<% } %>

				<% for (int idx1 = nowBlock * pagePerBlock; idx1 < (nowBlock + 1) * pagePerBlock && idx1 < totalPage; idx1++) { %>
				<a
					href="boardTitleListPaging.jsp?nowBlock=<%=nowBlock%>&nowPage=<%=idx1%>&recPerPage=<%=recPerPage%>&search=<%=searchKeyword%>&searchField=<%=searchField%>"
					class="page <%= (nowPage == idx1) ? "active" : "" %>"><%= idx1 + 1 %></a>
				<% } %>

				<% if (nowBlock + 1 < totalBlock) { %>
				<a
					href="boardTitleListPaging.jsp?nowBlock=<%=nowBlock + 1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>&recPerPage=<%=recPerPage%>&search=<%=searchKeyword%>&searchField=<%=searchField%>">&raquo;</a>
				<% } %>
			</div>
		</div>

		<!-- 검색창 -->
		<form method="get" action="boardTitleListPaging.jsp"
			style="text-align: center; margin-top: 20px;">
			<!-- 검색 조건 드롭다운 -->
			<select class="searchField" name="searchField">
				<option value="title_content"
					<%= "title_content".equals(searchField) ? "selected" : "" %>>제목+내용</option>
				<option value="title"
					<%= "title".equals(searchField) ? "selected" : "" %>>제목</option>
				<option value="content"
					<%= "content".equals(searchField) ? "selected" : "" %>>내용</option>
				<option value="writer"
					<%= "writer".equals(searchField) ? "selected" : "" %>>글쓴이</option>
			</select> <input type="hidden" name="recPerPage" value="<%= recPerPage %>">
			<input type="text" id="searchInput" name="search"
				placeholder="검색어 입력" value="<%= searchKeyword %>"> <input
				type="submit" id="searchButton" value="검색">
		</form>

	</div>
</body>
</html>
