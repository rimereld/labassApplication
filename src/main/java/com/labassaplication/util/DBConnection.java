package com.labass.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — gives us one place to manage database connections.
 * All DAOs call DBConnection.getConnection() to talk to MySQL.
 */
public class DBConnection {

    // ── Change these to match your MySQL setup ──────────────────────
    private static final String URL      = "jdbc:mysql://localhost:3306/labass_db?useSSL=false&serverTimezone=UTC";
    private static final String USER     = "root";
    private static final String PASSWORD = "yourpassword";
    // ────────────────────────────────────────────────────────────────

    static {
        try {
            // Load the MySQL JDBC driver once when the class is first used
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    /**
     * Returns a fresh Connection to labass_db.
     * Always close() the connection in a finally block after using it.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
