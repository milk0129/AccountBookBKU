<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="proJSP.ExpenseDAO"%>
<%@ page import="proJSP.ExpenseDTO"%>
<%@ page import="java.util.*"%>

<script src="../jas/hisDel.js"></script>
<%
  request.setCharacterEncoding("UTF-8");
  String userId = (String) session.getAttribute("userId");
  String mode = request.getParameter("mode"); // "전체내역" 또는 "카테고리"
  if (mode == null) mode = "전체내역";

  ExpenseDAO dao = new ExpenseDAO();
  String resultMsg = "";

  // 항목 삭제 처리
  String[] expIds = request.getParameterValues("expId");
  if (expIds != null) {
    int success = 0;
    for (String idStr : expIds) {
      try {
        success += dao.deleteExpense(Integer.parseInt(idStr));
      } catch (Exception e) {}
    }
    if (success > 0) {
    	response.sendRedirect("./../mainJsp/login_index.jsp");

      return;
    } else {
      resultMsg = "내역 삭제 실패.";
    }
  }

  // 카테고리 삭제 처리
  String[] delCategories = request.getParameterValues("categoryName");
  if (delCategories != null) {
    for (String cat : delCategories) {
      dao.deleteUserCategory(userId, cat);
    }
    response.sendRedirect("./../mainJsp/login_index.jsp");
    return;
  }
%>
<div id="historyWrapper">

	<!-- 내역삭제 모드 -->
	<% if ("전체내역".equals(mode)) { 
		       List<ExpenseDTO> list = dao.getExpenseList(userId);
		  %>

	<p class="delTableTitle">내역삭제</p>

	<div class="linkMenu">
		<!-- 
		      <form method="get" action="./../mainJsp/login_index.jsp">
		  <input type="hidden" name="category" value="user">
		  <input type="hidden" name="menu" value="del">
		  		    <select name="mode" onchange="this.form.submit()" class="delSelect">
				      <option value="전체내역" <%= "전체내역".equals(mode) ? "selected" : "" %>>전체 내역</option>
				      <option value="카테고리" <%= "카테고리".equals(mode) ? "selected" : "" %>>카테고리</option>
				   </select>
		   </form> -->
		<a href="./../mainJsp/login_index.jsp?category=user&menu=sel">조회하기</a>
		<a href="./../mainJsp/login_index.jsp?category=user&menu=add">추가하기</a>
		<a href="./../mainJsp/login_index.jsp?category=user&menu=del">삭제하기</a>
	</div>
	<form method="post" action="./../historyJsp/historyDelete.jsp"
		onsubmit="return confirm('정말로 삭제할까요?');">
		<input type="hidden" name="mode" value="전체내역">
		<table class="delTable">
			<thead>
				<tr>
					<th>선택</th>
					<th>날짜</th>
					<th>항목</th>
					<th>금액</th>
				</tr>
			</thead>
			<tbody>
				<% for (ExpenseDTO dto : list) { %>
				<tr>
					<td><input type="checkbox" name="expId"
						value="<%= dto.getExpId() %>"></td>
					<td class="mDate"><%= dto.getExpDate() %></td>
					<td class="mItem"><%= dto.getExpItem() %></td>
					<td
						class="<%= dto.getExpType().equals("수입") ? "mIncome" : "mOutcome" %>">
						<%= dto.getExpType().equals("수입") ? "+" : "-" %><%= String.format("%,d", dto.getExpMoney()) %>원
					</td>
				</tr>
				<% } %>
			</tbody>
		</table>
		<table>
			<tr>
				<td></td>
			</tr>
			<tr>
				<td>
					<div class="buttonWrapper">
						<input type="button" value="전체선택" class="saveButton"
							onclick="selectAll()"> <input type="submit" value="삭제하기"
							class="saveButton"> <input type="button" value="🗑"
							class="trashButton" onclick="deselectAll()">
					</div>
				</td>
			</tr>
		</table>
	</form>



	<% } else if ("카테고리".equals(mode)) { 
		       List<String> userCats = dao.getCategoryList(userId); %>

	<!-- 카테고리 삭제 모드 -->

	<p class="delTableTitle">카테고리 삭제</p>
	<div class="linkMenu">
		<!-- 
		      <form method="get" action="./../mainJsp/login_index.jsp">
		  <input type="hidden" name="category" value="user">
		  <input type="hidden" name="menu" value="del">
		  		    <select name="mode" onchange="this.form.submit()" class="delSelect">
		      <option value="전체내역" <%= "전체내역".equals(mode) ? "selected" : "" %>>전체 내역</option>
		      <option value="카테고리" <%= "카테고리".equals(mode) ? "selected" : "" %>>카테고리</option>
		   </select>
		   </form> -->
		<a href="./../mainJsp/login_index.jsp?category=user&menu=sel">조회하기</a>
		<a href="./../mainJsp/login_index.jsp?category=user&menu=add">추가하기</a>
		<a href="./../mainJsp/login_index.jsp?category=user&menu=del">삭제하기</a>
	</div>
	<form method="post" action="./../historyJsp/historyDelete.jsp"
		onsubmit="return confirm('선택한 카테고리를 삭제할까요?');">
		<input type="hidden" name="category" value="user"> <input
			type="hidden" name="menu" value="del"> <input type="hidden"
			name="mode" value="카테고리">
		<table class="delTable">
			<thead>
				<tr>
					<th>선택</th>
					<th>카테고리명</th>
				</tr>
			</thead>
			<tbody>
				<% for (String cat : userCats) { if (cat != null) { %>
				<tr>
					<td><input type="checkbox" name="categoryName"
						value="<%= cat %>"></td>
					<td><%= cat %></td>
				</tr>
				<% } } %>
			</tbody>
		</table>

		<table>
			<tr>
				<td></td>
			</tr>
			<tr>
				<td>
					<div class="buttonWrapper">
						<input type="button" value="전체선택" class="saveButton"
							onclick="selectAllCategory()"> <input type="submit"
							value="삭제하기" class="saveButton"> <input type="button"
							value="🗑" class="trashButton" onclick="deselectAllCategory()">
					</div>
				</td>
			</tr>
		</table>
	</form>
	<p id="resultMsg"><%= resultMsg %></p>
</div>
<!--  내역 -->
<% } %>





