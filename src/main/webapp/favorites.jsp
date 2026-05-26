<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.labassaplication.model.Product, java.util.List" %>
<%@ page import="com.labassaplication.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Product> favorites = (List<Product>) request.getAttribute("favorites");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Favoris | Labass</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #fff; color: #000; }

        /* reuse navbar styles */
        .labass-navbar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 28px 60px; border-bottom: 1px solid #eee;
            background: #fff; position: sticky; top: 0; z-index: 100;
        }
        .labass-navbar .logo {
            font-family: 'Cinzel', serif; font-size: 1.5rem; font-weight: bold;
            text-decoration: none; color: #000; letter-spacing: 2px;
        }
        .labass-navbar nav { display: flex; align-items: center; gap: 28px; }
        .labass-navbar nav a { text-decoration: none; color: #000; font-size: 0.85rem;
            letter-spacing: 1px; text-transform: uppercase; position: relative; }
        .labass-navbar nav a:hover { opacity: 0.6; }
        .labass-navbar nav a i { font-size: 1.1rem; }
        .nav-icon-wrap { position: relative; display: inline-flex; align-items: center; }
        .nav-badge {
            position: absolute; top: -8px; right: -10px;
            background: #000; color: #fff; font-size: 0.58rem; font-weight: 700;
            min-width: 17px; height: 17px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
        }
        .nav-badge[data-count="0"] { display: none; }

        /* page */
        .page-header {
            padding: 50px 60px 30px;
            border-bottom: 1px solid #eee;
        }
        .page-header h1 { font-family: 'Cinzel', serif; font-size: 2.2rem; margin-bottom: 6px; }
        .page-header p  { color: #999; font-size: 0.9rem; }

        .fav-body { padding: 40px 60px 80px; }

        /* grid */
        .fav-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 40px 30px;
        }

        /* card */
        .fav-card { position: relative; }
        .fav-card:hover .card-actions { opacity: 1; transform: translateY(0); }
        .fav-card:hover .fav-img img  { transform: scale(1.04); }

        .fav-img {
            width: 100%; aspect-ratio: 3/4; overflow: hidden;
            background: #f4f4f4; position: relative; cursor: pointer;
        }
        .fav-img img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s; }
        .fav-img .no-img {
            width: 100%; height: 100%; display: flex; align-items: center;
            justify-content: center; color: #ccc; font-size: 0.75rem;
            letter-spacing: 2px; text-transform: uppercase;
        }

        .card-actions {
            position: absolute; bottom: 0; left: 0; right: 0;
            display: flex; opacity: 0; transform: translateY(8px);
            transition: all 0.25s ease;
        }
        .btn-cart {
            flex: 1; padding: 14px; background: #000; color: #fff;
            border: none; cursor: pointer; font-size: 0.78rem;
            letter-spacing: 2px; text-transform: uppercase;
            font-family: 'Inter', sans-serif;
        }
        .btn-cart:hover { background: #222; }
        .btn-cart:disabled { background: #999; cursor: not-allowed; }

        .btn-unfav {
            width: 50px; background: #fff; border: none; cursor: pointer;
            font-size: 1rem; color: #c0392b; border-left: 1px solid #eee;
        }
        .btn-unfav:hover { background: #fdecea; }

        .fav-info { display: flex; justify-content: space-between; align-items: flex-start; padding: 14px 0 0; }
        .fav-name {
            font-size: 0.9rem; font-weight: 600; cursor: pointer;
            text-decoration: none; color: #000;
        }
        .fav-name:hover { text-decoration: underline; }
        .fav-cat  { font-size: 0.75rem; color: #999; text-transform: uppercase; letter-spacing: 1px; margin-top: 4px; }
        .fav-price { font-size: 0.95rem; font-weight: 600; white-space: nowrap; }

        /* empty */
        .empty {
            text-align: center; padding: 100px 0; color: #999;
        }
        .empty h2 { font-family: 'Cinzel', serif; font-size: 1.8rem; color: #000; margin-bottom: 12px; }
        .empty p  { margin-bottom: 30px; }
        .empty a  {
            padding: 14px 40px; background: #000; color: #fff;
            text-decoration: none; font-size: 0.82rem; letter-spacing: 2px; text-transform: uppercase;
        }

        /* toast */
        .toast {
            position: fixed; bottom: 30px; right: 30px;
            background: #000; color: #fff; padding: 14px 24px;
            font-size: 0.85rem; letter-spacing: 1px; opacity: 0;
            transform: translateY(10px); transition: all 0.3s;
            pointer-events: none; z-index: 999;
        }
        .toast.show { opacity: 1; transform: translateY(0); }

        @media (max-width: 900px) { .fav-grid { grid-template-columns: repeat(2,1fr); } .fav-body,.page-header,.labass-navbar { padding-left:30px;padding-right:30px; } }
        @media (max-width: 560px) { .fav-grid { grid-template-columns: 1fr; } .labass-navbar,.fav-body,.page-header { padding-left:20px;padding-right:20px; } }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="page-header">
    <h1>Mes Favoris</h1>
    <p><%= favorites != null ? favorites.size() : 0 %> article<%= (favorites != null && favorites.size() > 1) ? "s" : "" %> sauvegardé<%= (favorites != null && favorites.size() > 1) ? "s" : "" %></p>
</div>

<div class="fav-body">

    <% if (favorites == null || favorites.isEmpty()) { %>
    <div class="empty">
        <h2>Aucun favori</h2>
        <p>Explorez la boutique et cliquez sur ♡ pour sauvegarder vos coups de cœur.</p>
        <a href="${pageContext.request.contextPath}/shop">Découvrir la boutique</a>
    </div>

    <% } else { %>
    <div class="fav-grid">
        <% for (Product p : favorites) { %>
        <div class="fav-card" id="fav-<%= p.getId() %>">

            <div class="fav-img"
                 onclick="window.location='${pageContext.request.contextPath}/product?id=<%= p.getId() %>'">
                <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= p.getImageUrl() %>"
                         alt="<%= p.getName() %>">
                <% } else { %>
                    <div class="no-img">No image</div>
                <% } %>

                <div class="card-actions">
                    <% if (p.getStock() > 0) { %>
                    <form class="cart-form" method="post"
                          action="${pageContext.request.contextPath}/cart"
                          data-name="<%= p.getName() %>">
                        <input type="hidden" name="action"    value="add">
                        <input type="hidden" name="productId" value="<%= p.getId() %>">
                        <input type="hidden" name="quantity"  value="1">
                        <button type="submit" class="btn-cart">
                            <i class="fa-solid fa-bag-shopping"></i> Ajouter
                        </button>
                    </form>
                    <% } else { %>
                    <button class="btn-cart" disabled>Épuisé</button>
                    <% } %>

                    <button class="btn-unfav"
                            onclick="removeFav(<%= p.getId() %>, this)"
                            title="Retirer des favoris">
                        <i class="fa-solid fa-heart"></i>
                    </button>
                </div>
            </div>

            <div class="fav-info">
                <div>
                    <a class="fav-name"
                       href="${pageContext.request.contextPath}/product?id=<%= p.getId() %>">
                        <%= p.getName() %>
                    </a>
                    <div class="fav-cat"><%= p.getCategory() %></div>
                </div>
                <div class="fav-price"><%= p.getPrice() %> MAD</div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<div class="toast" id="toast"></div>

<script>
    // Add to cart via AJAX
    document.querySelectorAll('.cart-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            fetch(this.action, { method: 'POST', body: new URLSearchParams(new FormData(this)) })
                .then(() => {
                    showToast(this.dataset.name + ' ajouté au panier');
                    updateCartBadge(1);
                })
                .catch(() => showToast('Erreur, réessayez'));
        });
    });

    // Remove from favorites via AJAX
    function removeFav(productId, btn) {
        fetch('${pageContext.request.contextPath}/favorites', {
            method: 'POST',
            body: new URLSearchParams({ productId: productId })
        })
        .then(res => res.json())
        .then(data => {
            // Slide out the card
            const card = document.getElementById('fav-' + productId);
            card.style.transition = 'opacity 0.3s, transform 0.3s';
            card.style.opacity    = '0';
            card.style.transform  = 'scale(0.95)';
            setTimeout(() => card.remove(), 300);
            // Update fav badge
            const badge = document.getElementById('favBadge');
            if (badge) {
                const newCount = data.count;
                badge.textContent   = newCount > 0 ? newCount : '';
                badge.dataset.count = newCount;
            }
            showToast('Retiré des favoris');
        })
        .catch(() => showToast('Erreur, réessayez'));
    }

    function updateCartBadge(delta) {
        const badge = document.getElementById('cartBadge');
        if (!badge) return;
        let count = parseInt(badge.textContent || '0') + delta;
        if (count < 0) count = 0;
        badge.textContent   = count > 0 ? count : '';
        badge.dataset.count = count;
    }

    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2500);
    }
</script>

</body>
</html>
