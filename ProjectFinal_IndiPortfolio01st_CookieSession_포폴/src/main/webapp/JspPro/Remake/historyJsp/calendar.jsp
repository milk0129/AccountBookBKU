<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="commonPro.DbSet"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<link rel="stylesheet" type="text/css" href="./../css/calendar.css">
<script src="./../historyJsp/_jQueryLib/jquery-3.7.1.js"></script>

<%
    String userId = (String) session.getAttribute("userId");
    String sql = "SELECT exp_date as expDate, exp_money as expMoney, exp_type as expType FROM expenses WHERE user_id=?";
    Connection conn = DbSet.getConnection();
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, userId);
    ResultSet rs = pstmt.executeQuery();

    List<String> DbAry = new ArrayList<>();
    while (rs.next()) {
        String expDate = rs.getString("expDate");
        String expMoney = rs.getString("expMoney");
        String expType = rs.getString("expType");
        String Year = "", Month = "", Day = "";
        if (expDate != null && expDate.length() >= 10) {
            Year = expDate.substring(0, 4);
            Month = expDate.substring(5, 7);
            Day = expDate.substring(8, 10);
        }
        DbAry.add(Year + Month + Day + expType + expMoney);
    }
%>

<script>
    document.addEventListener('DOMContentLoaded', mInit);

    let curYear, curMonth, curDate;
    let dbAry = "<%= String.join(",", DbAry) %>";
    let SelectedDate = "<%= request.getParameter("selectedDate") %>";
    let ParamYearMonth = "<%= request.getParameter("yearMonth") %>";

    function mInit() {
        let date = new Date();
        curYear = date.getFullYear();
        curMonth = date.getMonth() + 1;
        curDate = date.getDate();

        // 1. URL에 yearMonth 있으면 초기 월로 반영
        if (ParamYearMonth !== null && ParamYearMonth !== "") {
            curMonth = parseInt(ParamYearMonth);
        }

        // 2. selectedDate 있으면 그걸 우선시
        if (SelectedDate && SelectedDate !== "null") {
            const parsedDate = SelectedDate.split('-');
            if (parsedDate.length === 3) {
                curYear = parseInt(parsedDate[0]);
                curMonth = parseInt(parsedDate[1]);
                curDate = parseInt(parsedDate[2]);
            }
        }

        makeCalendar();
    }

    function cngMonth(self) {
        if (self.id === "pre") curMonth -= 1;
        else if (self.id === "nex") curMonth += 1;

        if (curMonth === 13) {
            curYear += 1;
            curMonth = 1;
        } else if (curMonth === 0) {
            curYear -= 1;
            curMonth = 12;
        }

        // ✅ 여기서 formattedMonth를 직접 선언
        const formattedMonth = curMonth < 10 ? "0" + curMonth : "" + curMonth;

        // ✅ 두 필드 모두 갱신
        document.calendarFrm.yearMonth.value = formattedMonth;
        document.calendarFrm.selectedMonth.value = formattedMonth;

        document.calendarFrm.submit();
    }

    function makeCalendar() {
        const formattedMonth = curMonth < 10 ? '0' + curMonth : curMonth;
        document.getElementById("yearMonth").value = formattedMonth;

        let userInputYear = curYear;
        let userInputMonth = curMonth;
        let cntDay;

        if (userInputMonth === 2) {
            cntDay = (userInputYear % 4 === 0 && userInputYear % 100 !== 0) || (userInputYear % 400 === 0) ? 29 : 28;
        } else {
            cntDay = [1, 3, 5, 7, 8, 10, 12].includes(userInputMonth) ? 31 : 30;
        }

        let weekDay = ["일", "월", "화", "수", "목", "금", "토"];
        let el_table = document.createElement('table');
        let el_thead = document.createElement('thead');
        let el_tr = document.createElement('tr');

        weekDay.forEach(day => {
            let td = document.createElement('td');
            td.innerHTML = day;
            td.className = "week";
            el_tr.append(td);
        });
        el_thead.append(el_tr);
        el_table.append(el_thead);

        let stDay = new Date(userInputYear, userInputMonth - 1, 1).getDay();
        let el_tbody = document.createElement("tbody");
        let tmp_el_tr;
        let splDbAry = dbAry.split(',');

        for (let i = 0; i < (cntDay + stDay); i++) {
            if (i % 7 === 0) {
                tmp_el_tr = document.createElement("tr");
                el_tbody.append(tmp_el_tr);
            }

            let td = document.createElement("td");
            td.className = "day";
            tmp_el_tr.append(td);

            if (i >= stDay) {
                let dayNum = i - stDay + 1;
                td.innerHTML = dayNum;
                td.onclick = () => clickDate(td, stDay);

                let hisAddDiv = document.createElement("div");
                let hisDecDiv = document.createElement("div");
                let preAddMoney = 0, preDecMoney = 0;

                splDbAry.forEach(entry => {
                    if (entry.trim().length < 10) return;
                    let dbYear = parseInt(entry.slice(0, 4));
                    let dbMonth = parseInt(entry.slice(4, 6));
                    let dbDay = parseInt(entry.slice(6, 8));
                    let dbType = entry.slice(8, 10);
                    let dbMoney = entry.slice(10);

                    if (dbYear === curYear && dbMonth === curMonth && dbDay === dayNum) {
                        if (dbType === "수입") preAddMoney += parseInt(dbMoney);
                        else if (dbType === "지출") preDecMoney += parseInt(dbMoney);
                    }
                });

                if (preDecMoney !== 0) {
                    hisDecDiv.innerHTML = "-" + preDecMoney;
                    hisDecDiv.className = "hisDec";
                    td.appendChild(hisDecDiv);
                }

                if (preAddMoney !== 0) {
                    hisAddDiv.innerHTML = "+" + preAddMoney;
                    hisAddDiv.className = "hisAdd";
                    td.appendChild(hisAddDiv);
                }
            }
        }

        el_table.append(el_tbody);
        const el_div = document.querySelector("#table_calendar");
        if (el_div.firstChild) el_div.firstChild.remove();
        el_div.appendChild(el_table);
    }

    function clickDate(self, stDay) {
        curDate = self.innerHTML;
        let onlyDate = parseInt(curDate);
        let splDbAry = dbAry.split(',');

        let padMonth = curMonth < 10 ? "0" + curMonth : curMonth;
        let padDay = onlyDate < 10 ? "0" + onlyDate : onlyDate;
        const selectedDateValue = curYear + '-' + padMonth + '-' + padDay;
        document.getElementById("selectedDateInput").value = selectedDateValue;

        let hasData = splDbAry.some(entry => {
            if (entry.length < 10) return false;
            let y = parseInt(entry.slice(0, 4));
            let m = parseInt(entry.slice(4, 6));
            let d = parseInt(entry.slice(6, 8));
            return y === curYear && m === parseInt(padMonth) && d === parseInt(padDay);
        });

        if (!hasData) {
            const addURL = '<%= request.getContextPath() %>/JspPro/Remake/mainJsp/login_index.jsp?category=user&menu=add&selectedDate=' + selectedDateValue;
            window.location.href = addURL;
        } else {
            document.getElementById("calendarFrm").submit();
        }
    }
</script>

<div id="calendarWrapper">
	<form id="calendarFrm" name="calendarFrm" method="get"
		action="<%= request.getContextPath() %>/JspPro/Remake/mainJsp/login_index.jsp">
		<input type="hidden" name="category" value="user"> <input
			type="hidden" name="menu" value="sel"> <input type="hidden"
			name="filter"
			value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
		<input type="hidden" name="selectedDate" id="selectedDateInput">
		<input type="hidden" name="selectedMonth" id="selectedMonth">

		<input type="button" value="◀" id='pre' onclick="cngMonth(this)">
		<input type="text" name="yearMonth" id="yearMonth" readonly> <input
			type="button" value="▶" id='nex' onclick="cngMonth(this)">
	</form>

	<div id="table_calendar"></div>
</div>
