package proJSP;

import commonPro.DbSet;
import commonPro.DbClose;
import proJSP.UserDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // 회원가입
    public int insertUser(UserDTO dto) {
        int result = 0;
        String sql = "INSERT INTO MY_USERS (USER_ID, USER_NAME, USER_BIRTH) VALUES (?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, dto.getUserId());
            pstmt.setString(2, dto.getUserName());
            pstmt.setDate(3, java.sql.Date.valueOf(dto.getUserBirth())); // "yyyy-MM-dd"

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(pstmt, conn);
        }

        return result;
    }

    // 아이디 찾기
    public String findUserId(String userName, String userBirth) {
        String foundId = null;
        String sql = "SELECT USER_ID FROM MY_USERS WHERE USER_NAME = ? AND USER_BIRTH = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, userName);
            pstmt.setDate(2, java.sql.Date.valueOf(userBirth)); // yyyy-MM-dd

            rs = pstmt.executeQuery();

            if (rs.next()) {
                foundId = rs.getString("USER_ID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return foundId;
    }

    // 아이디 존재 여부 확인 (중복 체크 or 로그인 체크)
    public boolean isUserExists(String userId) {
        boolean exists = false;
        String sql = "SELECT 1 FROM MY_USERS WHERE USER_ID = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);

            rs = pstmt.executeQuery();
            exists = rs.next(); // 한 줄이라도 있으면 존재
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }

        return exists;
    }
    
    // 아이디로 이름 조회
    public String getUserName(String userId) {
        String userName = null;
        String sql = "SELECT USER_NAME FROM MY_USERS WHERE USER_ID = ?";
    
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
    
        try {
            conn = DbSet.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
    
            if (rs.next()) {
                userName = rs.getString("USER_NAME");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbClose.close(rs, pstmt, conn);
        }
    
        return userName;
    }
}