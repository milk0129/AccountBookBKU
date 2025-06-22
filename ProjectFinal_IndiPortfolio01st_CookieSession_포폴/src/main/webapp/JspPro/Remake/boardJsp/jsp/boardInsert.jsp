<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="commonPro.*"%>

<%
request.setCharacterEncoding("UTF-8");

String writer = request.getParameter("writer");
String title = request.getParameter("title");
String content = request.getParameter("content");

if (writer == null || title == null || content == null ||
    writer.trim().isEmpty() || title.trim().isEmpty() || content.trim().isEmpty()) {
    out.println("<script>alert('모든 입력값을 채워주세요.'); history.back();</script>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    conn = DbSet.getConnection();

    String sql = "INSERT INTO board (num, writer, title, content, regtime, hits) " +
                 "VALUES ((SELECT NVL(MAX(num), 0) + 1 FROM board), ?, ?, ?, SYSDATE, 0)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, writer);
    pstmt.setString(2, title);
    pstmt.setString(3, content);

    int result = pstmt.executeUpdate();

    if (result > 0) {
        response.sendRedirect("boardTitleListPaging.jsp");
    } else {
        out.println("<script>alert('게시글 등록 실패'); history.back();</script>");
    }

} catch (Exception e) {
    out.println("<script>alert('DB 오류: " + e.getMessage() + "'); history.back();</script>");
    e.printStackTrace();
} finally {
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>
