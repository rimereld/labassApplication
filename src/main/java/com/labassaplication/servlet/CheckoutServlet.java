package com.labass.servlet;

import com.labass.dao.CartDAO;
import com.labass.dao.OrderDAO;
import com.labass.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * CheckoutServlet — handles the checkout page and order placement.
 *
 * Routes:
 *   GET  /checkout → show checkout form with order summary
 *   POST /checkout → place the order, clear cart, redirect to confirmation
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final CartDAO  cartDAO  = new CartDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    // ── SHOW CHECKOUT PAGE ───────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) return;

        try {
            List<CartItem> items = cartDAO.getCartByUser(user.getId());
            double total = cartDAO.getCartTotal(user.getId());

            req.setAttribute("cartItems", items);
            req.setAttribute("cartTotal", total);
            req.setAttribute("user", user); // pre-fill the form

        } catch (Exception e) {
            req.setAttribute("error", "Impossible de charger le panier.");
        }

        req.getRequestDispatcher("/jsp/checkout.jsp").forward(req, res);
    }

    // ── PLACE ORDER ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        User user = getLoggedUser(req, res);
        if (user == null) return;

        try {
            // 1. Get cart items to build order lines
            List<CartItem> cartItems = cartDAO.getCartByUser(user.getId());

            if (cartItems.isEmpty()) {
                res.sendRedirect(req.getContextPath() + "/jsp/panier.jsp");
                return;
            }

            // 2. Build the Order object from the form
            Order order = new Order();
            order.setUserId         (user.getId());
            order.setShippingName   (req.getParameter("fullName"));
            order.setShippingAddress(req.getParameter("address"));
            order.setShippingCity   (req.getParameter("city"));
            order.setShippingCountry(req.getParameter("country"));
            order.setPostalCode     (req.getParameter("postalCode"));
            order.setPhone          (req.getParameter("phone"));
            order.setPaymentMethod  (req.getParameter("paymentMethod"));

            // 3. Convert cart items → order items
            List<OrderItem> orderItems = new ArrayList<>();
            double total = 0;

            for (CartItem ci : cartItems) {
                OrderItem oi = new OrderItem(
                    ci.getProductId(),
                    ci.getQuantity(),
                    ci.getProduct().getPrice()
                );
                orderItems.add(oi);
                total += oi.getLineTotal();
            }

            order.setTotalAmount(total);
            order.setItems(orderItems);

            // 4. Save order to database
            int orderId = orderDAO.createOrder(order);

            // 5. Clear the cart
            cartDAO.clearCart(user.getId());

            // 6. Redirect to confirmation page
            res.sendRedirect(req.getContextPath() + "/confirmation?orderId=" + orderId);

        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la commande. Réessayez.");
            req.getRequestDispatcher("/jsp/checkout.jsp").forward(req, res);
        }
    }

    // ── HELPER ───────────────────────────────────────────────────────

    private User getLoggedUser(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("loggedUser");
    }
}
