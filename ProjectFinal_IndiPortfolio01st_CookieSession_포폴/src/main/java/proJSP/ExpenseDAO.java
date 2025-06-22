package proJSP;

import commonPro.DbSet;
import commonPro.DbClose;
import proJSP.ExpenseDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class ExpenseDAO {

    // 수입/지출 내역 추가
	public int insertExpense(ExpenseDTO dto) {
	    int result = 0;
	    String sql = "INSERT INTO EXPENSES (EXP_ID, USER_ID, EXP_DATE, EXP_ITEM, EXP_MONEY, EXP_TYPE, EXP_CATEGORY, EXP_MEMO) " +
	                 "VALUES ((SELECT NVL(MAX(EXP_ID), 0) + 1 FROM EXPENSES), ?, ?, ?, ?, ?, ?, ?)";

	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = DbSet.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        // ✅ null/공백 방지 및 trim 처리
	        String userId = dto.getUserId();
	        String expDate = dto.getExpDate();
	        String expItem = dto.getExpItem() != null ? dto.getExpItem().trim() : "";
	        int expMoney = dto.getExpMoney();
	        String expType = dto.getExpType() != null ? dto.getExpType().trim() : "";
	        String expCategory = dto.getExpCategory() != null ? dto.getExpCategory().trim() : "";
	        String expMemo = dto.getExpMemo() != null ? dto.getExpMemo().trim() : "";

	        // 필수값 유효성 검사 (선택)
	        if (userId == null || expDate == null || expItem.isEmpty() || expType.isEmpty() || expCategory.isEmpty()) {
	            System.out.println("⚠ 필수값 누락으로 저장 중단");
	            return 0;
	        }

	        pstmt.setString(1, userId);
	        pstmt.setDate(2, java.sql.Date.valueOf(expDate));
	        pstmt.setString(3, expItem);
	        pstmt.setInt(4, expMoney);
	        pstmt.setString(5, expType);
	        pstmt.setString(6, expCategory);
	        pstmt.setString(7, expMemo);

	        result = pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        DbClose.close(pstmt, conn);
	    }

	    return result;
	}

    // 특정 유저의 전체 수입/지출 내역 가져오기
    public List<ExpenseDTO> getExpenseList(String userId) {
        List<ExpenseDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM EXPENSES WHERE USER_ID = ? ORDER BY EXP_DATE DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ExpenseDTO dto = new ExpenseDTO(
                    rs.getInt("EXP_ID"),
                    rs.getString("USER_ID"),
                    rs.getDate("EXP_DATE").toString(),
                    rs.getString("EXP_ITEM"),
                    rs.getInt("EXP_MONEY"),
                    rs.getString("EXP_TYPE"),
                    rs.getString("EXP_CATEGORY"),
                    rs.getString("EXP_MEMO")
                );
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return list;
    }
    
 // 특정 유저의 특정 날짜 수입/지출 가져오기
    public List<ExpenseDTO> getExpenseList(String userId, String selectedDate) {
        List<ExpenseDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM EXPENSES WHERE USER_ID = ? AND EXP_DATE = ? ORDER BY EXP_DATE DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, selectedDate);
            rs = pstmt.executeQuery();
                        
            while (rs.next()) {
                ExpenseDTO dto = new ExpenseDTO(
                    rs.getInt("EXP_ID"),
                    rs.getString("USER_ID"),
                    rs.getDate("EXP_DATE").toString(),
                    rs.getString("EXP_ITEM"),
                    rs.getInt("EXP_MONEY"),
                    rs.getString("EXP_TYPE"),
                    rs.getString("EXP_CATEGORY"),
                    rs.getString("EXP_MEMO")
                );
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }
        
        return list;
    }

    // 지출 ID로 삭제
    public int deleteExpense(int expId) {
        int result = 0;
        String sql = "DELETE FROM EXPENSES WHERE EXP_ID = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, expId);

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(pstmt, conn);
        }

        return result;
    }

    // 지출 수정 (expId로 찾고 덮어쓰기)
    public int updateExpense(ExpenseDTO dto) {
        int result = 0;
        String sql = "UPDATE EXPENSES SET EXP_DATE = ?, EXP_ITEM = ?, EXP_MONEY = ?, " +
                     "EXP_TYPE = ?, EXP_CATEGORY = ?, EXP_MEMO = ? WHERE EXP_ID = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setDate(1, Date.valueOf(dto.getExpDate()));
            pstmt.setString(2, dto.getExpItem());
            pstmt.setInt(3, dto.getExpMoney());
            pstmt.setString(4, dto.getExpType());
            pstmt.setString(5, dto.getExpCategory());
            pstmt.setString(6, dto.getExpMemo());
            pstmt.setInt(7, dto.getExpId());

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(pstmt, conn);
        }

        return result;
    }

    // 총 지출 또는 수입 금액 구하기
    public int getTotalByType(String userId, String type) {
        int total = 0;
        String sql = "SELECT SUM(EXP_MONEY) AS TOTAL FROM EXPENSES WHERE USER_ID = ? AND EXP_TYPE = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, type); // "수입" or "지출"

            rs = pstmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt("TOTAL");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return total;
    }
    
 // 특정 유저의 수입/지출 내역 필터링 조회
    public List<ExpenseDTO> getExpenseListByType(String userId, String type) {
        List<ExpenseDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM EXPENSES WHERE USER_ID = ? AND EXP_TYPE = ? ORDER BY EXP_DATE DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, type); // "수입" or "지출"
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ExpenseDTO dto = new ExpenseDTO(
                    rs.getInt("EXP_ID"),
                    rs.getString("USER_ID"),
                    rs.getDate("EXP_DATE").toString(),
                    rs.getString("EXP_ITEM"),
                    rs.getInt("EXP_MONEY"),
                    rs.getString("EXP_TYPE"),
                    rs.getString("EXP_CATEGORY"),
                    rs.getString("EXP_MEMO")
                );
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return list;
    }
 // 사용자 추가 카테고리 삽입 메서드
    public int insertUserCategory(String userId, String categoryName) {
        int result = 0;

        if (categoryName == null || categoryName.trim().isEmpty()) {
            System.out.println("⚠ [insertUserCategory] categoryName is null or empty, insert skipped.");
            return 0;
        }

        String sql = "INSERT INTO USER_CATEGORIES (CATEGORY_ID, USER_ID, CATEGORY_NAME) " +
                     "VALUES ((SELECT NVL(MAX(CATEGORY_ID), 0) + 1 FROM USER_CATEGORIES), ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, categoryName.trim()); // ✅ trim 적용
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(pstmt, conn);
        }

        return result;
    }

    // 사용자별 카테고리 가져오기
    public List<ExpenseDTO> getExpensesByCategory(String userId, String category) {
        List<ExpenseDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM EXPENSES WHERE USER_ID = ? AND EXP_CATEGORY = ? ORDER BY EXP_DATE DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, category);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ExpenseDTO dto = new ExpenseDTO(
                    rs.getInt("EXP_ID"),
                    rs.getString("USER_ID"),
                    rs.getDate("EXP_DATE").toString(),
                    rs.getString("EXP_ITEM"),
                    rs.getInt("EXP_MONEY"),
                    rs.getString("EXP_TYPE"),
                    rs.getString("EXP_CATEGORY"),
                    rs.getString("EXP_MEMO")
                );
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return list;
    }
 // 사용자별 카테고리 목록 반환 (USER_CATEGORIES 테이블에서)
    public List<String> getCategoryList(String userId) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT CATEGORY_NAME FROM USER_CATEGORIES WHERE USER_ID = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                categories.add(rs.getString("CATEGORY_NAME"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return categories;
    }
 // 기존 JSP에서 사용하던 이름을 위한 호환 메서드
    public List<String> getUserCategories(String userId) {
        return getCategoryList(userId);
    }
 // 사용자 정의 카테고리 삭제 메서드
    public int deleteUserCategory(String userId, String categoryName) {
        int result = 0;
        String sql = "DELETE FROM USER_CATEGORIES WHERE USER_ID = ? AND CATEGORY_NAME = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, categoryName);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(pstmt, conn);
        }

        return result;
    }
 // 특정 월의 수입/지출 총합 계산
    public int getTotalByMonthOnlyMonth(String userId, String type, String month) {
        int total = 0;
        String sql = "SELECT NVL(SUM(EXP_MONEY), 0) FROM EXPENSES WHERE USER_ID = ? AND EXP_TYPE = ? AND TO_CHAR(EXP_DATE, 'MM') = ?";
        try (Connection conn = DbSet.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, type);
            pstmt.setString(3, month);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    
    public Map<String, Integer> getCategoryTotalByMonth(String userId, String month) {
        Map<String, Integer> categoryTotals = new LinkedHashMap<>();
        String sql = "SELECT EXP_CATEGORY, SUM(EXP_MONEY) " +
                     "FROM EXPENSES " +
                     "WHERE USER_ID = ? AND EXP_TYPE = '지출' AND TO_CHAR(EXP_DATE, 'MM') = ? " +
                     "GROUP BY EXP_CATEGORY ORDER BY EXP_CATEGORY";

        try (Connection conn = DbSet.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, month);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String category = rs.getString(1);
                int amount = rs.getInt(2);
                categoryTotals.put(category, amount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categoryTotals;
    }

} //class 