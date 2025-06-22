package commonPro;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbSet {

    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USER = "hr";
    private static final String PASSWORD = "hr";
    
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("DB 연결 성공");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }
}
