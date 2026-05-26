package com.labass.servlet;

import com.labass.dao.UserDAO;
import com.labass.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * LoginServlet — handles both login and registration.
 *
 * Routes:
 *   POST /login    → login with email + password
 *   POST /register → create a new account
 *   GET  /logout   → destroy session, redirect to home
 *
 * After login: stores the User in the session so all other pages
 * can check if the user is logged in with:
 *   User user = (User) session.getAttribute("loggedUser");
 */
@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ── GET: show login page or logout ───────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            // Destroy session and go home
            req.getSession().invalidate();
            res.sendRedirect(req.getContextPath() + "/index.jsp");

        } else {
            // Show the login page
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
        }
    }

    // ── POST: process login or register ──────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(req, res);
        } else if ("/register".equals(path)) {
            handleRegister(req, res);
        }
    }

    // ── LOGIN LOGIC ──────────────────────────────────────────────────

    private void handleLogin(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = userDAO.login(email, password);

            if (user != null) {
                // ✅ Correct credentials → save user in session
                HttpSession session = req.getSession();
                session.setAttribute("loggedUser", user);
                res.sendRedirect(req.getContextPath() + "/index.jsp");

            } else {
                // ❌ Wrong credentials → send back with error message
                req.setAttribute("error", "Email ou mot de passe incorrect.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Erreur serveur. Réessayez.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
        }
    }

    // ── REGISTER LOGIC ───────────────────────────────────────────────

    private void handleRegister(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User newUser = new User(fullName, email, password);
            boolean success = userDAO.register(newUser);

            if (success) {
                // ✅ Registered → redirect to login with success message
                res.sendRedirect(req.getContextPath() + "/login?registered=true");

            } else {
                // ❌ Email already exists
                req.setAttribute("error", "Cet email est déjà utilisé.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de l'inscription.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
        }
    }
}
