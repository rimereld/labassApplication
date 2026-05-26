package com.labassaplication.dao;

import com.labass.model.User;
import com.labass.util.DBConnection;

import java.security.MessageDigest;
import java.sql.*;

/**
 * UserDAO — all database operations related to the `users` table.
 *
 * What it does:
 *  - register()  → INSERT a new user (hashes the password first)
 *  - login()     → check email + password, return the User or null
 *  - findById()  → get one user by their ID
 *  - update()    → update profile info
 */
public class UserDAO {

    // ── REGISTER ─────────────────────────────────────────────────────

    /**
     * Inserts a new user into the database.
     * Returns true if successful, false if email already exists.
     */
    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashPassword(user.getPassword())); // NEVER store plain text

            ps.executeUpdate();
            return true;

        } catch (SQLIntegrityConstraintViolationException e) {
            // Email already exists (UNIQUE constraint)
            return false;
        }
    }

    // ── LOGIN ─────────────────────────────────────────────────────────

    /**
     * Checks credentials. Returns the User object if correct, null if wrong.
     */
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashPassword(password));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);   // found → return User
            }
            return null;             // not found → wrong credentials
        }
    }

    // ── FIND BY ID ───────────────────────────────────────────────────

    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapRow(rs);
            return null;
        }
    }

    // ── UPDATE PROFILE ───────────────────────────────────────────────

    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET full_name=?, phone=?, address=?, city=?, country=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getCity());
            ps.setString(5, user.getCountry());
            ps.setInt   (6, user.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ── HELPERS ──────────────────────────────────────────────────────

    /** Maps one database row → User object */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId       (rs.getInt   ("id"));
        u.setFullName (rs.getString("full_name"));
        u.setEmail    (rs.getString("email"));
        u.setPhone    (rs.getString("phone"));
        u.setAddress  (rs.getString("address"));
        u.setCity     (rs.getString("city"));
        u.setCountry  (rs.getString("country"));
        return u;
    }

    /** SHA-256 password hashing */
    private String hashPassword(String plain) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(plain.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Hashing failed", e);
        }
    }
}
