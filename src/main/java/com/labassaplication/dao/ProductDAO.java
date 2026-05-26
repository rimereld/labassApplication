package com.labassaplication.dao;

import com.labass.model.Product;
import com.labass.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductDAO — all database operations for the `products` table.
 *
 * What it does:
 *  - findAll()            → list all products (for Shop page)
 *  - findByCategory()     → filter by "dress" / "outfit"
 *  - findBySize()         → filter by S / M / L
 *  - findById()           → get one product (for Product detail page)
 *  - search()             → search by name keyword
 */
public class ProductDAO {

    // ── ALL PRODUCTS ─────────────────────────────────────────────────

    public List<Product> findAll() throws SQLException {
        return query("SELECT * FROM products ORDER BY id");
    }

    // ── FILTER BY CATEGORY ───────────────────────────────────────────

    public List<Product> findByCategory(String category) throws SQLException {
        String sql = "SELECT * FROM products WHERE category = ?";
        return queryWithParam(sql, category);
    }

    // ── FILTER BY SIZE ───────────────────────────────────────────────

    public List<Product> findBySize(String size) throws SQLException {
        String sql = "SELECT * FROM products WHERE size = ?";
        return queryWithParam(sql, size);
    }

    // ── FIND BY ID ───────────────────────────────────────────────────

    public Product findById(int id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapRow(rs);
            return null;
        }
    }

    // ── SEARCH BY NAME ───────────────────────────────────────────────

    public List<Product> search(String keyword) throws SQLException {
        String sql = "SELECT * FROM products WHERE LOWER(name) LIKE ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword.toLowerCase() + "%");
            ResultSet rs = ps.executeQuery();
            return mapList(rs);
        }
    }

    // ── SORT BY PRICE ────────────────────────────────────────────────

    public List<Product> findAllSortedByPrice(boolean ascending) throws SQLException {
        String dir = ascending ? "ASC" : "DESC";
        return query("SELECT * FROM products ORDER BY price " + dir);
    }

    // ── HELPERS ──────────────────────────────────────────────────────

    private List<Product> query(String sql) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return mapList(rs);
        }
    }

    private List<Product> queryWithParam(String sql, String param) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, param);
            ResultSet rs = ps.executeQuery();
            return mapList(rs);
        }
    }

    private List<Product> mapList(ResultSet rs) throws SQLException {
        List<Product> list = new ArrayList<>();
        while (rs.next()) list.add(mapRow(rs));
        return list;
    }

    /** Maps one database row → Product object */
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId         (rs.getInt   ("id"));
        p.setName       (rs.getString("name"));
        p.setBrand      (rs.getString("brand"));
        p.setCategory   (rs.getString("category"));
        p.setSize       (rs.getString("size"));
        p.setPrice      (rs.getDouble("price"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl   (rs.getString("image_url"));
        p.setStock      (rs.getInt   ("stock"));
        return p;
    }
}
