package com.labassaplication.dao;

import com.labassaplication.model.Product;
import com.labassaplication.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FavoriteDAO — all DB operations for the `favorites` table.
 *
 *  getFavoritesByUser()  → list all favourite products for a user
 *  addFavorite()         → add a product to favourites
 *  removeFavorite()      → remove a product from favourites
 *  isFavorite()          → check if a product is already a favourite
 */
public class FavoriteDAO {

    // ── GET ALL ──────────────────────────────────────────────────────
    public List<Product> getFavoritesByUser(int userId) throws SQLException {
        String sql = """
            SELECT p.*
            FROM favorites f
            JOIN products p ON f.product_id = p.id
            WHERE f.user_id = ?
            ORDER BY f.created_at DESC
        """;

        List<Product> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapProduct(rs));
        }
        return list;
    }

    // ── ADD ──────────────────────────────────────────────────────────
    public void addFavorite(int userId, int productId) throws SQLException {
        if (isFavorite(userId, productId)) return; // already there
        String sql = "INSERT INTO favorites (user_id, product_id) VALUES (?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    // ── REMOVE ───────────────────────────────────────────────────────
    public void removeFavorite(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM favorites WHERE user_id=? AND product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    // ── IS FAVORITE ──────────────────────────────────────────────────
    public boolean isFavorite(int userId, int productId) throws SQLException {
        String sql = "SELECT 1 FROM favorites WHERE user_id=? AND product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeQuery().next();
        }
    }

    // ── HELPER ───────────────────────────────────────────────────────
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId         (rs.getInt        ("id"));
        p.setName       (rs.getString     ("name"));
        p.setDescription(rs.getString     ("description"));
        p.setPrice      (rs.getBigDecimal ("price"));
        p.setImageUrl   (rs.getString     ("image_url"));
        p.setCategory   (rs.getString     ("category"));
        p.setStock      (rs.getInt        ("stock"));
        return p;
    }
}
