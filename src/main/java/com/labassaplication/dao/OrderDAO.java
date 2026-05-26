package com.labassaplication.dao;

import com.labass.model.Order;
import com.labass.model.OrderItem;
import com.labass.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderDAO — all database operations for `orders` and `order_items` tables.
 *
 * What it does:
 *  - createOrder()       → save a new order + its items (checkout)
 *  - getOrdersByUser()   → get order history for a user (profile page)
 *  - getOrderById()      → get full details of one order
 */
public class OrderDAO {

    // ── CREATE ORDER ─────────────────────────────────────────────────

    /**
     * Saves the order header AND all its items in one transaction.
     * Returns the new order's ID, or -1 if it failed.
     */
    public int createOrder(Order order) throws SQLException {
        String orderSql = """
            INSERT INTO orders
              (user_id, total_amount, shipping_name, shipping_address,
               shipping_city, shipping_country, postal_code, phone, payment_method, status)
            VALUES (?,?,?,?,?,?,?,?,?,'pending')
        """;

        String itemSql = """
            INSERT INTO order_items (order_id, product_id, quantity, unit_price)
            VALUES (?,?,?,?)
        """;

        Connection con = DBConnection.getConnection();
        con.setAutoCommit(false); // start transaction

        try {
            // 1. Insert the order header
            int orderId;
            try (PreparedStatement ps = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt   (1, order.getUserId());
                ps.setDouble(2, order.getTotalAmount());
                ps.setString(3, order.getShippingName());
                ps.setString(4, order.getShippingAddress());
                ps.setString(5, order.getShippingCity());
                ps.setString(6, order.getShippingCountry());
                ps.setString(7, order.getPostalCode());
                ps.setString(8, order.getPhone());
                ps.setString(9, order.getPaymentMethod());
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                keys.next();
                orderId = keys.getInt(1);
            }

            // 2. Insert each order item
            try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                for (OrderItem item : order.getItems()) {
                    ps.setInt   (1, orderId);
                    ps.setInt   (2, item.getProductId());
                    ps.setInt   (3, item.getQuantity());
                    ps.setDouble(4, item.getUnitPrice());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit(); // all good → commit
            return orderId;

        } catch (SQLException e) {
            con.rollback(); // something failed → undo everything
            throw e;
        } finally {
            con.setAutoCommit(true);
            con.close();
        }
    }

    // ── ORDER HISTORY ────────────────────────────────────────────────

    public List<Order> getOrdersByUser(int userId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC";
        List<Order> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── GET ONE ORDER ────────────────────────────────────────────────

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        }
    }

    // ── HELPERS ──────────────────────────────────────────────────────

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId             (rs.getInt   ("id"));
        o.setUserId         (rs.getInt   ("user_id"));
        o.setTotalAmount    (rs.getDouble("total_amount"));
        o.setShippingName   (rs.getString("shipping_name"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setShippingCity   (rs.getString("shipping_city"));
        o.setShippingCountry(rs.getString("shipping_country"));
        o.setPostalCode     (rs.getString("postal_code"));
        o.setPhone          (rs.getString("phone"));
        o.setPaymentMethod  (rs.getString("payment_method"));
        o.setStatus         (rs.getString("status"));
        return o;
    }
}
