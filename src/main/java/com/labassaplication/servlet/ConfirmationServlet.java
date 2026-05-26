package com.labass.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * ConfirmationServlet — serves the order confirmation page.
 *
 * Route:
 *   GET /confirmation?orderId=5 → shows confirmation.jsp
 */
@WebServlet("/confirmation")
public class ConfirmationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // orderId is already in the query string — JSP reads it with ${param.orderId}
        req.getRequestDispatcher("/jsp/confirmation.jsp").forward(req, res);
    }
}
