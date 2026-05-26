<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.labassaplication.model.Product" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop - Labass</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Shop.css">
</head>
<body>

<%-- HEADER --%>
<header>
    <a href="${pageContext.request.contextPath}index.jsp" style="text-decoration:none;color:inherit;">
        <h1>LABASS.</h1>
    </a>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}index.jsp">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/jsp/shop.jsp">Shop</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/login.jspogin.jsp">Account</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/panier.jspnier.jsp"><i class="fa-solid fa-bag-shopping"></i></a></li>
        </ul>
    </nav>
</header>

<section id="page-header">
    <h2>#DIR LABASS M3A LABASS</h2>
    <p>La qualité rencontre l'élégance</p>
</section>

<section class="shop-layout">

    <%-- SIDEBAR WITH FILTERS --%>
    <aside id="sidebar">
        <h3>Filtres</h3>

        <%-- All filters submit as GET to /shop --%>
        <form method="get" action="${pageContext.request.contextPath}/WEB-INF/shop.jsp">

            <div class="filter-block">
                <input type="text" name="search" placeholder="Rechercher..."
                       value="${searchQuery != null ? searchQuery : ''}">
            </div>

            <div class="filter-block">
                <h4>Catégories</h4>
                <button type="submit" name="category" value="all"
                    class="${selectedCategory == null || 'all'.equals(selectedCategory) ? 'active' : ''}">Toutes</button>
                <button type="submit" name="category" value="dress"
                    class="${'dress'.equals(selectedCategory) ? 'active' : ''}">Robes</button>
                <button type="submit" name="category" value="outfit"
                    class="${'outfit'.equals(selectedCategory) ? 'active' : ''}">Ensembles</button>
            </div>

            <div class="filter-block">
                <h4>Tailles</h4>
                <button type="submit" name="size" value="all"
                    class="${selectedSize == null || 'all'.equals(selectedSize) ? 'active' : ''}">Toutes</button>
                <button type="submit" name="size" value="S"
                    class="${'S'.equals(selectedSize) ? 'active' : ''}">S</button>
                <button type="submit" name="size" value="M"
                    class="${'M'.equals(selectedSize) ? 'active' : ''}">M</button>
                <button type="submit" name="size" value="L"
                    class="${'L'.equals(selectedSize) ? 'active' : ''}">L</button>
            </div>

            <div class="filter-block">
                <h4>Trier par</h4>
                <button type="submit" name="sort" value="low">Prix ↑</button>
                <button type="submit" name="sort" value="high">Prix ↓</button>
            </div>

            <a href="${pageContext.request.contextPath}/WEB-INF/shop.jsp">
                <button type="button" id="clearFilters">Reset</button>
            </a>

        </form>
    </aside>

    <%-- PRODUCTS GRID --%>
    <div class="shop-content">
        <div class="shop-topbar">
            <p id="productCount">${productCount} produit(s)</p>
        </div>

        <div class="pro-container">

            <%-- Loop over products from ShopServlet --%>
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                if (products != null && !products.isEmpty()) {
                    for (Product p : products) {
            %>
            <div class="pro" data-name="<%=p.getName().toLowerCase()%>"
                 data-category="<%=p.getCategory()%>"
                 data-size="<%=p.getSize()%>"
                 data-price="<%=p.getPrice()%>">

                <a href="${pageContext.request.contextPath}/product?id=<%=p.getId()%>">
                    <img src="${pageContext.request.contextPath}/<%=p.getImageUrl()%>" alt="<%=p.getName()%>">
                </a>

                <div class="des">
                    <span><%=p.getBrand()%></span>
                    <h5><%=p.getName()%></h5>
                    <div class="star">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i>
                        <i class="fas fa-star"></i><i class="fas fa-star"></i>
                        <i class="far fa-star"></i>
                    </div>
                    <div class="price-cart">
                        <h4><%=(int)p.getPrice()%> DH</h4>
                        <%-- Add to cart form --%>
                        <form method="post" action="${pageContext.request.contextPath}/WEB-INF/panier.jspnier.jsp" style="display:inline;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%=p.getId()%>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="add-cart" title="Ajouter au panier">
                                <i class="fa-solid fa-cart-shopping"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <p style="grid-column:1/-1; text-align:center; color:#888; padding:40px;">
                Aucun produit trouvé.
            </p>
            <%
                }
            %>

        </div>
    </div>

</section>

<footer>
    <p>© 2026 Labass. Créé avec passion pour la mode.</p>
</footer>

</body>
</html>
