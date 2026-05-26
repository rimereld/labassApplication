package com.labassaplication.servlet;

import com.labassaplication.dao.UserDAO;
import com.labassaplication.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * EditProfileServlet — handles profile updates.
 *
 * Routes:
 *   GET  /edit-profile → show the edit form (forward to edit-profile.jsp)
 *   POST /edit-profile → save changes, update session, redirect back
 */
@WebServlet("/edit-profile")
public class EditProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ── GET: show edit form ──────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Guard: must be logged in
        User loggedUser = (User) req.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        req.getRequestDispatcher("/edit-profile.jsp").forward(req, res);
    }

    // ── POST: save changes ───────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Guard: must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User loggedUser = (User) session.getAttribute("loggedUser");

        // Read form values
        String phone          = req.getParameter("phone");
        String address        = req.getParameter("address");
        String city           = req.getParameter("city");
        String country        = req.getParameter("country");
        String newPassword    = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Password change validation
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "Les mots de passe ne correspondent pas.");
                req.getRequestDispatcher("/edit-profile.jsp").forward(req, res);
                return;
            }
            if (newPassword.length() < 6) {
                req.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères.");
                req.getRequestDispatcher("/edit-profile.jsp").forward(req, res);
                return;
            }
        }

        try {
            // Update user object with new values
            loggedUser.setPhone  (phone   != null ? phone.trim()   : null);
            loggedUser.setAddress(address != null ? address.trim() : null);
            loggedUser.setCity   (city    != null ? city.trim()    : null);
            loggedUser.setCountry(country != null ? country.trim() : null);

            // Update profile info in DB
            userDAO.update(loggedUser);

            // Update password separately if provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                userDAO.updatePassword(loggedUser.getId(), newPassword);
            }

            // Refresh the session with updated user data
            session.setAttribute("loggedUser", loggedUser);

            // Redirect back to edit page with success message
            res.sendRedirect(req.getContextPath() + "/edit-profile.jsp?updated=true");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
            req.getRequestDispatcher("/edit-profile.jsp").forward(req, res);
        }
    }
}
