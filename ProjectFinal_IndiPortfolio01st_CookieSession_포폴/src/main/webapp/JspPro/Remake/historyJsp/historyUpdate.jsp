<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="proJSP.ExpenseDAO"%>
<%@ page import="proJSP.ExpenseDTO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<script src="./../jas/hisUpd.js"></script>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("userId");
    String expIdStr = request.getParameter("expId");
    ExpenseDTO expense = null;
    String resultMsg = "";

    List<String> userCategories = new ArrayList<>();
    ExpenseDAO dao = new ExpenseDAO();  // 한 DAO 객체로 재사용
    if (userId != null) {
        userCategories = dao.getUserCategories(userId);
    }

    if (expIdStr != null) {
        try {
            int expId = Integer.parseInt(expIdStr.trim());
            List<ExpenseDTO> list = dao.getExpenseList(userId);

            for (ExpenseDTO dto : list) {
                if (dto.getExpId() == expId) {
                    expense = dto;
                    break;
                }
            }

            if (expense == null) {
                resultMsg = "해당 내역을 찾을 수 없습니다.";
            }
        } catch (Exception e) {
            resultMsg = "잘못된 접근입니다.";
        }
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        try {
            int expId = Integer.parseInt(request.getParameter("expId"));
            String expDate = request.getParameter("mdate");
            String expItem = request.getParameter("mItem");
            int expMoney = Integer.parseInt(request.getParameter("mMoney"));
            String expType = request.getParameter("expType");
            String expCategory = request.getParameter("mCategory");
            String customCategory = request.getParameter("customCategory");
            String expMemo = request.getParameter("mMemo");

            // 직접입력 처리: expCategory 값 덮어쓰기
            if ("기타".equals(expCategory) && customCategory != null && !customCategory.trim().isEmpty()) {
                expCategory = customCategory.trim();
            }

            // USER_CATEGORIES에 해당 카테고리가 없다면 추가
            if (!userCategories.contains(expCategory)) {
                dao.insertUserCategory(userId, expCategory);
                userCategories = dao.getUserCategories(userId); // 갱신
            }

            // 수정 DTO 설정
            ExpenseDTO dto = new ExpenseDTO();
            dto.setExpId(expId);
            dto.setUserId(userId);  // 누락 방지
            dto.setExpDate(expDate);
            dto.setExpItem(expItem);
            dto.setExpMoney(expMoney);
            dto.setExpType(expType);
            dto.setExpCategory(expCategory);
            dto.setExpMemo(expMemo);

            int result = dao.updateExpense(dto);

            if (result > 0) {
                resultMsg = "수정 성공!";
                response.sendRedirect("./../mainJsp/login_index.jsp");
                return;
            } else {
                resultMsg = "수정 실패!";
            }

            // 다시 조회해서 expense 객체 갱신
            List<ExpenseDTO> list = dao.getExpenseList(userId);
            for (ExpenseDTO updatedDto : list) {
                if (updatedDto.getExpId() == expId) {
                    expense = updatedDto;
                    break;
                }
            }
        } catch (Exception e) {
            resultMsg = "입력 오류입니다.";
        }
    }
%>

<div id="historyWrapper">
	<div class="linkMenu">
		<a href="./../mainJsp/login_index.jsp?category=user&menu=sel">조회하기</a>
		<a href="./../mainJsp/login_index.jsp?category=user&menu=add">추가하기</a>
		<a href="./../mainJsp/login_index.jsp?category=user&menu=del">삭제하기</a>
	</div>


	<form method="post"
		action="./../historyJsp/historyUpdate.jsp?expId=<%= expense != null ? expense.getExpId() : "" %>"
		onsubmit="return validateForm();">
		<p class="tableTitle">내역수정</p>
		<table class="updTable">
			<thead>
				<tr>
					<td><label for="expType">분류</label></td>
					<td><input type="radio" id="income" name="expType" value="수입"
						<%= expense != null && "수입".equals(expense.getExpType()) ? "checked" : "" %>>
						수입 <input type="radio" id="outcome" name="expType" value="지출"
						<%= expense != null && "지출".equals(expense.getExpType()) ? "checked" : "" %>>
						지출</td>
				</tr>
				<tr>
					<td><label for="mdate">날짜</label></td>
					<td><input type="date" id="mdate" name="mdate"
						value="<%= expense != null ? expense.getExpDate() : "" %>"></td>
				</tr>
				<tr>
					<td><label for="mMoney">금액</label></td>
					<td><input type="text" id="mMoney" name="mMoney"
						value="<%= expense != null ? expense.getExpMoney() : "" %>"></td>
				</tr>
				<tr>
					<td><label for="mCategory">카테고리</label></td>
					<td><select id="mCategory" name="mCategory"
						onchange="toggleCustomCategory()">
							<!-- 기본 카테고리 -->
							<option value="식비"
								<%= ("식비".equals(expense.getExpCategory()) ? "selected" : "") %>>식비</option>
							<option value="교통비"
								<%= ("교통비".equals(expense.getExpCategory()) ? "selected" : "") %>>교통비</option>
							<option value="통신비"
								<%= ("통신비".equals(expense.getExpCategory()) ? "selected" : "") %>>통신비</option>
							<option value="문화생활"
								<%= ("문화생활".equals(expense.getExpCategory()) ? "selected" : "") %>>문화생활</option>

							<!-- 사용자 카테고리 출력 (null 방지) -->
							<%  for (String cat : userCategories) {
					        if (cat != null && !cat.isEmpty()
					            && !cat.equals("식비") && !cat.equals("교통비") && !cat.equals("통신비") && !cat.equals("문화생활")) { %>
							<option value="<%= cat %>"
								<%= (cat.equals(expense.getExpCategory()) ? "selected" : "") %>><%= cat %></option>
							<%      }
					    } %>

							<!-- 기타 선택 항목 -->
							<option value="기타"
								<%= ("기타".equals(expense.getExpCategory()) ? "selected" : "") %>>기타
								(직접입력)</option>
					</select> <!-- 기타 직접 입력 필드 --> <input type="text" id="customCategory"
						name="customCategory" placeholder="직접 입력" style="display: none">
					</td>
				</tr>
				<tr>
					<td><label for="mItem">항목</label></td>
					<td><input type="text" id="mItem" name="mItem"
						value="<%= expense != null ? expense.getExpItem() : "" %>"></td>
				</tr>
				<tr>
					<td><label for="mMemo">메모</label></td>
					<td><input type="text" id="mMemo" name="mMemo"
						value="<%= (expense != null && expense.getExpMemo() != null) ? expense.getExpMemo() : "" %>"></td>
				</tr>
			</thead>
			<tr>
				<td colspan="2">
					<button type="submit" class="saveButton">수정하기</button> <input
					type="button" value="🗑" class="trashButton" onclick="mReset()">
				</td>
			</tr>
		</table>
	</form>

	<p id="resultMsg"><%= resultMsg %></p>
</div>

