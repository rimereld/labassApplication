package com.labass.servlet;

import com.labass.dao.ProductDAO;
import com.labass.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * ShopServlet — loads products for the Shop page.
 *
 * Routes:
 *   GET /shop              → show all products
 *   GET /shop?category=dress → filter by category
 *   GET /shop?size=M         → filter by size
 *   GET /shop?search=robe    → search by name
 *   GET /shop?sort=low       → sort by price ascending
 *   GET /shop?sort=high      → sort by price descending
 */
@WebServlet("/shop")
public class ShopServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String category = req.getParameter("category");
        String size     = req.getParameter("size");
        String search   = req.getParameter("search");
        String sort     = req.getParameter("sort");

        List<Product> products;

        try {
            // Decide which DAO method to call based on filters
            if (search != null && !search.isBlank()) {
                products = productDAO.search(search.trim());

            } else if (category != null && !category.equals("all") && !category.isBlank()) {
                products = productDAO.findByCategory(category);

            } else if (size != null && !size.equals("all") && !size.isBlank()) {
                products = productDAO.findBySize(size);

            } else if ("low".equals(sort)) {
                products = productDAO.findAllSortedByPrice(true);

            } else if ("high".equals(sort)) {
                products = productDAO.findAllSortedByPrice(false);

            } else {
                products = productDAO.findAll();
            }

        } catch (Exception e) {
            products = List.of(); // empty list on error
            req.setAttribute("error", "Impossible de charger les produits.");
        }

        // Pass products to the JSP
        req.setAttribute("products", products);
        req.setAttribute("productCount", products.size());

        // Keep filter values so the JSP can pre-select them
        req.setAttribute("selectedCategory", category);
        req.setAttribute("selectedSize", size);
        req.setAttribute("selectedSort", sort);
        req.setAttribute("searchQuery", search);

        req.getRequestDispatcher("/jsp/shop.jsp").forward(req, res);
    }
}
