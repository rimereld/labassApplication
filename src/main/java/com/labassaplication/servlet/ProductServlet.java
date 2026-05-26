package com.labass.servlet;

import com.labass.dao.ProductDAO;
import com.labass.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * ProductServlet — loads one product for the detail page.
 *
 * Route:
 *   GET /product?id=1 → show product.jsp for product with ID 1
 */
@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            // No ID given → go to shop
            res.sendRedirect(req.getContextPath() + "/shop");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.findById(productId);

            if (product == null) {
                // Product not found
                req.setAttribute("error", "Produit introuvable.");
                req.getRequestDispatcher("/shop").forward(req, res);
            } else {
                req.setAttribute("product", product);
                req.getRequestDispatcher("/product").forward(req, res);
            }

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/shop");
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors du chargement du produit.");
            req.getRequestDispatcher("/product").forward(req, res);
        }
    }
}
