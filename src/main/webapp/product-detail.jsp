<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.labassaplication.model.Product" %>
<%
    Product p = (Product) request.getAttribute("product");
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/shop");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= p.getName() %> | Labass</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #fff; color: #000; }

        /* ── NAVBAR ── */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 60px;
            border-bottom: 1px solid #eee;
        }
        .navbar .logo {
            font-family: 'Cinzel', serif;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: #000;
        }
        .navbar nav a {
            margin-left: 30px;
            text-decoration: none;
            color: #000;
            font-size: 0.85rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .navbar nav a:hover { border-bottom: 1px solid #000; }

        /* ── BREADCRUMB ── */
        .breadcrumb {
            padding: 16px 60px;
            font-size: 0.78rem;
            color: #999;
            letter-spacing: 1px;
        }
        .breadcrumb a { color: #999; text-decoration: none; }
        .breadcrumb a:hover { color: #000; }
        .breadcrumb span { margin: 0 8px; }

        /* ── PRODUCT LAYOUT ── */
        .product-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            padding: 40px 60px 100px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* ── IMAGE ── */
        .product-gallery {
            aspect-ratio: 3/4;
            background: #f4f4f4;
            overflow: hidden;
        }
        .product-gallery img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .product-gallery .no-img {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ccc;
            font-size: 0.8rem;
            letter-spacing: 3px;
            text-transform: uppercase;
        }

        /* ── INFO ── */
        .product-details { padding-top: 20px; }

        .product-category {
            font-size: 0.72rem;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #999;
            margin-bottom: 12px;
        }

        .product-name {
            font-family: 'Cinzel', serif;
            font-size: 2rem;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .product-price {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 30px;
        }

        .product-description {
            font-size: 0.9rem;
            line-height: 1.8;
            color: #555;
            margin-bottom: 40px;
            border-top: 1px solid #eee;
            padding-top: 24px;
        }

        /* ── QUANTITY ── */
        .qty-label {
            font-size: 0.72rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #999;
            margin-bottom: 10px;
        }
        .qty-control {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            width: fit-content;
            margin-bottom: 24px;
        }
        .qty-control button {
            width: 44px;
            height: 44px;
            border: none;
            background: #fff;
            font-size: 1.1rem;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
        }
        .qty-control button:hover { background: #f4f4f4; }
        .qty-control input {
            width: 50px;
            height: 44px;
            border: none;
            border-left: 1px solid #ddd;
            border-right: 1px solid #ddd;
            text-align: center;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            outline: none;
        }

        /* ── ACTIONS ── */
        .product-actions { display: flex; gap: 12px; }

        .btn-add-cart {
            flex: 1;
            padding: 18px;
            background: #000;
            color: #fff;
            border: none;
            cursor: pointer;
            font-size: 0.85rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            font-family: 'Inter', sans-serif;
        }
        .btn-add-cart:hover { background: #222; }
        .btn-add-cart:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .btn-fav {
            width: 56px;
            border: 1px solid #ddd;
            background: #fff;
            cursor: pointer;
            font-size: 1.1rem;
            color: #000;
        }
        .btn-fav:hover { background: #f4f4f4; }
        .btn-fav.active { color: #c0392b; border-color: #c0392b; }

        .stock-info {
            font-size: 0.78rem;
            color: #27ae60;
            letter-spacing: 1px;
            margin-top: 16px;
        }
        .stock-info.low { color: #e67e22; }
        .stock-info.out { color: #c0392b; }

        /* ── TOAST ── */
        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #000;
            color: #fff;
            padding: 14px 24px;
            font-size: 0.85rem;
            letter-spacing: 1px;
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.3s;
            pointer-events: none;
            z-index: 999;
        }
        .toast.show { opacity: 1; transform: translateY(0); }

        /* ── RESPONSIVE ── */
        @media (max-width: 768px) {
            .product-layout { grid-template-columns: 1fr; gap: 30px; padding: 20px; }
            .breadcrumb, .navbar { padding-left: 20px; padding-right: 20px; }
        }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<header class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">LABASS.</a>
    <nav>
        <a href="${pageContext.request.contextPath}/shop">Shop</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">Compte</a>
        <a href="${pageContext.request.contextPath}/cart"><i class="fa-solid fa-bag-shopping"></i></a>
    </nav>
</header>

<%-- BREADCRUMB --%>
<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/shop">Shop</a>
    <span>›</span>
    <a href="${pageContext.request.contextPath}/shop?category=<%= java.net.URLEncoder.encode(p.getCategory(), "UTF-8") %>">
        <%= p.getCategory() %>
    </a>
    <span>›</span>
    <%= p.getName() %>
</div>

<%-- PRODUCT LAYOUT --%>
<div class="product-layout">

    <%-- IMAGE --%>
    <div class="product-gallery">
        <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
            <img src="${pageContext.request.contextPath}/<%= p.getImageUrl() %>"
                 alt="<%= p.getName() %>">
        <% } else { %>
            <div class="no-img">No image</div>
        <% } %>
    </div>

    <%-- DETAILS --%>
    <div class="product-details">
        <div class="product-category"><%= p.getCategory() %></div>
        <h1 class="product-name"><%= p.getName() %></h1>
        <div class="product-price"><%= p.getPrice() %> MAD</div>

        <p class="product-description">
            <%= p.getDescription() != null ? p.getDescription() : "" %>
        </p>

        <% if (p.getStock() > 0) { %>

        <%-- QUANTITY --%>
        <div class="qty-label">Quantité</div>
        <div class="qty-control">
            <button type="button" onclick="changeQty(-1)">−</button>
            <input type="number" id="qty" value="1" min="1" max="<%= p.getStock() %>" readonly>
            <button type="button" onclick="changeQty(1)">+</button>
        </div>

        <%-- ADD TO CART --%>
        <div class="product-actions">
            <form id="cartForm" method="post" action="${pageContext.request.contextPath}/cart">
                <input type="hidden" name="action"    value="add">
                <input type="hidden" name="productId" value="<%= p.getId() %>">
                <input type="hidden" name="quantity"  id="qtyInput" value="1">
                <button type="submit" class="btn-add-cart" onclick="submitCart(event)">
                    <i class="fa-solid fa-bag-shopping"></i> &nbsp;Ajouter au panier
                </button>
            </form>

            <button class="btn-fav" id="favBtn" onclick="toggleFav()" title="Favori">
                <i class="fa-regular fa-heart"></i>
            </button>
        </div>

        <%-- STOCK INFO --%>
        <% if (p.getStock() <= 5) { %>
        <p class="stock-info low">Plus que <%= p.getStock() %> en stock !</p>
        <% } else { %>
        <p class="stock-info">En stock (<%= p.getStock() %> disponibles)</p>
        <% } %>

        <% } else { %>
        <div class="product-actions">
            <button class="btn-add-cart" disabled>Épuisé</button>
        </div>
        <p class="stock-info out">Ce produit est épuisé.</p>
        <% } %>

    </div>
</div>

<%-- TOAST --%>
<div class="toast" id="toast"></div>

<script>
    function changeQty(delta) {
        const input = document.getElementById('qty');
        const max   = parseInt(input.max);
        let   val   = parseInt(input.value) + delta;
        if (val < 1)   val = 1;
        if (val > max) val = max;
        input.value = val;
        document.getElementById('qtyInput').value = val;
    }

    function submitCart(e) {
        e.preventDefault();
        const form = document.getElementById('cartForm');
        const data = new URLSearchParams(new FormData(form));
        fetch(form.action, { method: 'POST', body: data })
            .then(() => showToast('<%= p.getName() %> ajouté au panier'))
            .catch(() => showToast('Erreur, réessayez'));
    }

    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2500);
    }

    function toggleFav() {
        const btn  = document.getElementById('favBtn');
        const icon = btn.querySelector('i');
        const isFav = icon.classList.contains('fa-solid');
        icon.classList.toggle('fa-solid',  !isFav);
        icon.classList.toggle('fa-regular', isFav);
        btn.classList.toggle('active', !isFav);
    }
</script>

</body>
</html>
