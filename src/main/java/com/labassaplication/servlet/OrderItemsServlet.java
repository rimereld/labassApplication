package com.labass.servlet;

import com.labass.dao.OrderDAO;
import com.labass.model.OrderItem;
import com.labass.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * OrderItemsServlet — returns the items of one order as JSON.
 * Called by profile.jsp via AJAX when the user expands an order.
 *
 * Route: GET /orderItems?orderId=5
 */
@WebServlet("/orderItems")
public class OrderItemsServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json;charset=UTF-8");

        // Must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.setStatus(401);
            res.getWriter().write("[]");
            return;
        }

        String idParam = req.getParameter("orderId");
        if (idParam == null) { res.getWriter().write("[]"); return; }

        try {
            int orderId = Integer.parseInt(idParam);
            List<OrderItem> items = orderDAO.getOrderItemsById(orderId);

            // Build JSON manually (no external library needed)
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < items.size(); i++) {
                OrderItem item = items.get(i);
                String name     = item.getProduct() != null ? item.getProduct().getName()    : "";
                String brand    = item.getProduct() != null ? item.getProduct().getBrand()   : "";
                String imageUrl = item.getProduct() != null ? item.getProduct().getImageUrl(): "";

                json.append("{")
                    .append("\"id\":"        ).append(item.getId()       ).append(",")
                    .append("\"productId\":").append(item.getProductId()).append(",")
                    .append("\"name\":\""   ).append(esc(name)          ).append("\",")
                    .append("\"brand\":\""  ).append(esc(brand)         ).append("\",")
                    .append("\"imageUrl\":\"").append(esc(imageUrl)      ).append("\",")
                    .append("\"quantity\":").append(item.getQuantity()  ).append(",")
                    .append("\"unitPrice\":").append(item.getUnitPrice()).append("}")
                    ;
                if (i < items.size() - 1) json.append(",");
            }
            json.append("]");
            res.getWriter().write(json.toString());

        } catch (Exception e) {
            res.setStatus(500);
            res.getWriter().write("[]");
        }
    }

    // Escape special chars for JSON strings
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
