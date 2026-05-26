package com.labass.servlet;

import com.labass.dao.CartDAO;
import com.labass.model.CartItem;
import com.labass.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * CartServlet — manages the shopping cart (panier).
 *
 * Routes:
 *   GET  /cart              → show the cart page (panier.jsp)
 *   POST /cart?action=add   → add a product to the cart
 *   POST /cart?action=update → change quantity
 *   POST /cart?action=remove → remove one item
 *   POST /cart?action=clear  → empty the whole cart
 *
 * The user must be logged in. If not, we redirect to /login.
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    // ── SHOW CART ────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) return; // redirected to login

        try {
            List<CartItem> items = cartDAO.getCartByUser(user.getId());
            double total = cartDAO.getCartTotal(user.getId());

            req.setAttribute("cartItems", items);
            req.setAttribute("cartTotal", total);
            req.setAttribute("itemCount", items.size());

        } catch (Exception e) {
            req.setAttribute("error", "Impossible de charger le panier.");
        }

        req.getRequestDispatcher("/jsp/panier.jsp").forward(req, res);
    }

    // ── CART ACTIONS ─────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) return;

        String action = req.getParameter("action");

        try {
            switch (action) {

                case "add": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int quantity  = Integer.parseInt(req.getParameter("quantity"));
                    cartDAO.addItem(user.getId(), productId, quantity);
                    break;
                }

                case "update": {
                    int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                    int quantity   = Integer.parseInt(req.getParameter("quantity"));
                    if (quantity < 1) quantity = 1; // safety check
                    cartDAO.updateQuantity(cartItemId, quantity);
                    break;
                }

                case "remove": {
                    int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                    cartDAO.removeItem(cartItemId);
                    break;
                }

                case "clear": {
                    cartDAO.clearCart(user.getId());
                    break;
                }
            }
        } catch (Exception e) {
            // log in production, ignore silently here
        }

        // After any action, reload the cart page
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    // ── HELPER: check login ──────────────────────────────────────────

    private User getLoggedUser(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return user;
    }
}
