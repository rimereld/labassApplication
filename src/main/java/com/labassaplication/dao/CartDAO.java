package com.labassaplication.dao;

import com.labass.model.CartItem;
import com.labass.model.Product;
import com.labass.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CartDAO — all database operations for the `cart_items` table.
 *
 * What it does:
 *  - getCartByUser()    → get all items for a user (panier.jsp)
 *  - addItem()          → add a product to cart
 *  - updateQuantity()   → change quantity (+ / - buttons)
 *  - removeItem()       → remove one item (✕ button)
 *  - clearCart()        → empty cart after checkout
 *  - getCartTotal()     → sum of all items for this user
 */
public class CartDAO {

    // ── GET ALL ITEMS ────────────────────────────────────────────────

    /**
     * Returns all cart items for a user, with Product details joined in.
     * Used by panier.jsp to show the cart.
     */
    public List<CartItem> getCartByUser(int userId) throws SQLException {
        String sql = """
            SELECT ci.id, ci.user_id, ci.product_id, ci.quantity,
                   p.name, p.brand, p.price, p.image_url
            FROM cart_items ci
            JOIN products p ON ci.product_id = p.id
            WHERE ci.user_id = ?
            ORDER BY ci.id
        """;

        List<CartItem> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId       (rs.getInt   ("id"));
                item.setUserId   (rs.getInt   ("user_id"));
                item.setProductId(rs.getInt   ("product_id"));
                item.setQuantity (rs.getInt   ("quantity"));

                // Attach a lightweight Product so JSP can call item.getProduct().getName()
                Product p = new Product();
                p.setId      (rs.getInt   ("product_id"));
                p.setName    (rs.getString("name"));
                p.setBrand   (rs.getString("brand"));
                p.setPrice   (rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));
                item.setProduct(p);

                list.add(item);
            }
        }
        return list;
    }

    // ── ADD ITEM ─────────────────────────────────────────────────────

    /**
     * Adds a product to the user's cart.
     * If it's already there, just increases the quantity.
     */
    public void addItem(int userId, int productId, int quantity) throws SQLException {
        // Check if item already in cart
        String checkSql = "SELECT id, quantity FROM cart_items WHERE user_id=? AND product_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement check = con.prepareStatement(checkSql)) {

            check.setInt(1, userId);
            check.setInt(2, productId);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // Already in cart → update quantity
                int newQty = rs.getInt("quantity") + quantity;
                int cartItemId = rs.getInt("id");

                String updateSql = "UPDATE cart_items SET quantity=? WHERE id=?";
                try (PreparedStatement update = con.prepareStatement(updateSql)) {
                    update.setInt(1, newQty);
                    update.setInt(2, cartItemId);
                    update.executeUpdate();
                }
            } else {
                // Not in cart → insert new row
                String insertSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?,?,?)";
                try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                    insert.setInt(1, userId);
                    insert.setInt(2, productId);
                    insert.setInt(3, quantity);
                    insert.executeUpdate();
                }
            }
        }
    }

    // ── UPDATE QUANTITY ──────────────────────────────────────────────

    public void updateQuantity(int cartItemId, int quantity) throws SQLException {
        String sql = "UPDATE cart_items SET quantity=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            ps.executeUpdate();
        }
    }

    // ── REMOVE ITEM ──────────────────────────────────────────────────

    public void removeItem(int cartItemId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            ps.executeUpdate();
        }
    }

    // ── CLEAR CART (after checkout) ──────────────────────────────────

    public void clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    // ── CART TOTAL ───────────────────────────────────────────────────

    public double getCartTotal(int userId) throws SQLException {
        String sql = """
            SELECT SUM(ci.quantity * p.price) AS total
            FROM cart_items ci
            JOIN products p ON ci.product_id = p.id
            WHERE ci.user_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("total");
            return 0;
        }
    }
}
