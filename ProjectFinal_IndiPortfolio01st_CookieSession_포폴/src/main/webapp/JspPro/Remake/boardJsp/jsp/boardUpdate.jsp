<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="commonPro.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    int num = Integer.parseInt(request.getParameter("num"));
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    Connection conn = null;
    PreparedStatement pstmt = null;
    int result = 0;

    try {
        conn = DbSet.getConnection();
        String sql = "UPDATE board SET title = ?, content = ? WHERE num = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setInt(3, num);
        result = pstmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DbClose.close(pstmt, conn);
    }

    if (result > 0) {
        response.sendRedirect("boardViewFrame.jsp?num=" + num);
    } else {
%>
<script>
            alert("게시글 수정 실패");
            location.href = "boardUpdateFrame.jsp";
        </script>
<%
    }
%>
