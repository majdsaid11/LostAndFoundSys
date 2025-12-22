package lostfound;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:derby://Your DB  Url"; //url for your DB
    private static final String USER = "DB_USERNAME"; // your DB username
    private static final String PASSWORD = "DB_PASSWORD"; // your DB password

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

