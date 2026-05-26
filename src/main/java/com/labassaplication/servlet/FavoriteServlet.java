package com.labassaplication.servlet;

import com.labassaplication.dao.FavoriteDAO;
import com.labassaplication.model.Product;
import com.labassaplication.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * FavoriteServlet
 *
 * GET  /favorites              → show favorites page
 * POST /favorites?action=toggle&productId=X → add or remove favorite (AJAX)
 */
@WebServlet("/favorites")
public class FavoriteServlet extends HttpServlet {

    private final FavoriteDAO favoriteDAO = new FavoriteDAO();

    // ── GET: show favorites page ─────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) return;

        try {
            List<Product> favorites = favoriteDAO.getFavoritesByUser(user.getId());
            req.setAttribute("favorites", favorites);
            req.getRequestDispatcher("/favorites.jsp").forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Impossible de charger les favoris.");
            req.getRequestDispatcher("/favorites.jsp").forward(req, res);
        }
    }

    // ── POST: toggle favorite (called via AJAX from shop/product pages) ──
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getLoggedUser(req, res);
        if (user == null) {
            // Return 401 so JS can redirect to login
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int     productId = Integer.parseInt(req.getParameter("productId"));
            boolean isFav     = favoriteDAO.isFavorite(user.getId(), productId);

            if (isFav) {
                favoriteDAO.removeFavorite(user.getId(), productId);
            } else {
                favoriteDAO.addFavorite(user.getId(), productId);
            }

            // Return JSON: { "isFavorite": true/false, "count": N }
            int count = favoriteDAO.getFavoritesByUser(user.getId()).size();
            res.setContentType("application/json");
            res.getWriter().write(
                "{\"isFavorite\":" + !isFav + ",\"count\":" + count + "}"
            );

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

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
