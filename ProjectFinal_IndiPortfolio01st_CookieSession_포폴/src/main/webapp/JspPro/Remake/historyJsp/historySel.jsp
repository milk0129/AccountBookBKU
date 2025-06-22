<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="proJSP.ExpenseDTO"%>
<%@ page import="proJSP.ExpenseDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>

<script src="../jas/hisSel.js"></script>
<script>
function submitWithMonth() {
    // 현재 달력의 yearMonth 값을 가져와서 hidden 필드에 복사
    const monthFromCalendar = document.querySelector("#calendarFrm #yearMonth")?.value;

    // history 폼 내부 input에 반영
    if (monthFromCalendar) {
        document.querySelector("#myForm #yearMonth").value = monthFromCalendar;
        document.querySelector("#myForm #selectedMonth").value = monthFromCalendar;
    }

    // 최종적으로 form 전송
    document.getElementById("myForm").submit();
}
</script>

<div id="historyWrapper">

	<form id="myForm" method="get"
		action="<%= request.getContextPath() %>/JspPro/Remake/mainJsp/login_index.jsp">
		<p class="tableTitle">내역조회</p>

		<div class="linkMenu">
			<a href="./../mainJsp/login_index.jsp?category=user&menu=sel">조회하기</a>
			<a
				href="./../mainJsp/login_index.jsp?category=user&menu=add&selectedDate=<%=request.getParameter("selectedDate") != null ? request.getParameter("selectedDate") : ""%>">추가하기</a>
			<a href="./../mainJsp/login_index.jsp?category=user&menu=del">삭제하기</a>
		</div>

		<table class="selTable">
			<thead>
				<tr>
					<td colspan="4">
						<!-- hidden 필드 --> <input type="hidden" name="category"
						value="user"> <input type="hidden" name="menu" value="sel">
						<input type="hidden" name="yearMonth" id="yearMonth"> <input
						type="hidden" id="selectedMonth" name="selectedMonth"> <input
						type="hidden" id="selectedDate" name="selectedDate"> <select
						name="filter" onchange="submitWithMonth()">
							<option value="all"
								<%= "all".equals(request.getParameter("filter")) || request.getParameter("filter") == null ? "selected" : "" %>>전체내역</option>
							<option value="지출"
								<%= "지출".equals(request.getParameter("filter")) ? "selected" : "" %>>지출</option>
							<option value="수입"
								<%= "수입".equals(request.getParameter("filter")) ? "selected" : "" %>>수입</option>
							<option value="결산"
								<%= "결산".equals(request.getParameter("filter")) ? "selected" : "" %>>결산</option>
					</select>
					</td>
				</tr>
			</thead>
			<tbody>
				<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    String filter = request.getParameter("filter");
    String yearMonth = request.getParameter("yearMonth");
    
    String selectedDate = request.getParameter("selectedDate");

    if (userId != null) {
        ExpenseDAO dao = new ExpenseDAO();
        List<ExpenseDTO> list;
        String selectedMonth = request.getParameter("selectedMonth");

        if(selectedDate != null && !selectedDate.isEmpty()){ // 사용자가 날짜를 클릭했을 때
        	list = dao.getExpenseList(userId, selectedDate);
        	
        	String lastDate = "";

            for (ExpenseDTO dto : list) {
                String date = dto.getExpDate(); // yyyy-MM-dd

            	String item = dto.getExpItem();
                int money = dto.getExpMoney();
                String type = dto.getExpType();
                
                if (!date.equals(lastDate)) {
                    lastDate = date;
%>
				<tr>
					<th colspan="4" class="mDate"><%= date %><hr></th>
				</tr>
				<%
                }
%>
				<tr>
					<td class="mItem"><%= item %></td>
					<td class="mCategory">[<%= dto.getExpCategory() %>]
					</td>
					<td class="<%= type.equals("수입") ? "mIncome" : "mOutcome" %>">
						<%= type.equals("수입") ? "+" : "-" %><%= String.format("%,d", money) %>원
					</td>
					<td class="mUpdDel"><a
						href="login_index.jsp?category=user&menu=upd&expId=<%= dto.getExpId() %>">수정</a>
						<a
						href="./../historyJsp/historyDelete.jsp?expId=<%= dto.getExpId() %>"
						onclick="return confirm('정말 삭제할까요?')">삭제</a></td>
				</tr>
				<%
            }
        } else if ("결산".equals(filter) && selectedMonth != null && !selectedMonth.isEmpty()) {
            int income = dao.getTotalByMonthOnlyMonth(userId, "수입", selectedMonth); 
            int outcome = dao.getTotalByMonthOnlyMonth(userId, "지출", selectedMonth);
            int net = income - outcome;
%>
				<tr>
					<td colspan="4">
						<div class="settlementBox">
							<h3 class="settlementTitle"><%= selectedMonth %>월 결산
							</h3>
							<p class="settlementItem">
								총 수입:
								<%= String.format("%,d", income) %>원
							</p>
							<p class="settlementItem">
								총 지출:
								<%= String.format("%,d", outcome) %>원
							</p>
							<p class="settlementItem">
								합계:
								<%= String.format("%,d", net) %>원
							</p>
							<%
			Map<String, Integer> categoryMap = dao.getCategoryTotalByMonth(userId, selectedMonth);
			if (!categoryMap.isEmpty()) {
%>
							<p class="settlementSubTitle">
								<strong>카테고리별 지출</strong>
							</p>
							<ul class="settlementList">
								<%
			    for (Map.Entry<String, Integer> entry : categoryMap.entrySet()) {
%>
								<li class="settlementListItem"><%= entry.getKey() %>: <%= String.format("%,d", entry.getValue()) %>원</li>
								<%
			    }
%>
							</ul>
							<%
			 }
%>
						</div>
					</td>
				</tr>

				<%
        } else {
            if (filter == null || "all".equals(filter)) {
                list = dao.getExpenseList(userId);
            } else {
                list = dao.getExpenseListByType(userId, filter);
            }

            String lastDate = "";

            for (ExpenseDTO dto : list) {
                String date = dto.getExpDate(); // yyyy-MM-dd
                String item = dto.getExpItem();
                int money = dto.getExpMoney();
                String type = dto.getExpType();

                if (!date.equals(lastDate)) {
                    lastDate = date;
%>
				<tr>
					<th colspan="4" class="mDate"><%= date %><hr></th>
				</tr>
				<%
                }
%>
				<tr>
					<td class="mItem"><%= item %></td>
					<td class="mCategory">[<%= dto.getExpCategory() %>]
					</td>
					<td class="<%= type.equals("수입") ? "mIncome" : "mOutcome" %>">
						<%= type.equals("수입") ? "+" : "-" %><%= String.format("%,d", money) %>원
					</td>
					<td class="mUpdDel"><a
						href="login_index.jsp?category=user&menu=upd&expId=<%= dto.getExpId() %>">수정</a>
						<a
						href="./../historyJsp/historyDelete.jsp?expId=<%= dto.getExpId() %>"
						onclick="return confirm('정말 삭제할까요?')">삭제</a></td>
				</tr>
				<%
            } // end for
        } // end else
    } else {
%>
				<tr>
					<td colspan="4">로그인이 필요합니다.</td>
				</tr>
				<%
    }
    
%>
			</tbody>
		</table>
	</form>
</div>