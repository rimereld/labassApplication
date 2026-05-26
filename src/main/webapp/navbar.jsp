<%-- ══════════════════════════════════════════════════════════════
     WEB-INF/includes/navbar.jsp
     Include in every page with:
       <%@ include file="/WEB-INF/includes/navbar.jsp" %>
     ══════════════════════════════════════════════════════════════ --%>
<%@ page import="com.labassaplication.model.User" %>
<%@ page import="com.labassaplication.dao.CartDAO" %>
<%@ page import="com.labassaplication.dao.FavoriteDAO" %>
<%
    User navUser   = (User) session.getAttribute("loggedUser");
    int  cartCount = 0;
    int  favCount  = 0;
    if (navUser != null) {
        try { cartCount = new CartDAO().getCartByUser(navUser.getId()).size(); } catch (Exception ignored) {}
        try { favCount  = new FavoriteDAO().getFavoritesByUser(navUser.getId()).size(); } catch (Exception ignored) {}
    }
%>
<style>
    .labass-navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 28px 60px;
        border-bottom: 1px solid #eee;
        background: #fff;
        position: sticky;
        top: 0;
        z-index: 100;
    }
    .labass-navbar .logo {
        font-family: 'Cinzel', serif;
        font-size: 1.5rem;
        font-weight: bold;
        text-decoration: none;
        color: #000;
        letter-spacing: 2px;
    }
    .labass-navbar nav {
        display: flex;
        align-items: center;
        gap: 28px;
    }
    .labass-navbar nav a {
        text-decoration: none;
        color: #000;
        font-size: 0.85rem;
        letter-spacing: 1px;
        text-transform: uppercase;
        position: relative;
    }
    .labass-navbar nav a:hover { opacity: 0.6; }
    .labass-navbar nav a i { font-size: 1.1rem; }

    /* Badge générique (panier + favoris) */
    .nav-icon-wrap {
        position: relative;
        display: inline-flex;
        align-items: center;
    }
    .nav-badge {
        position: absolute;
        top: -8px;
        right: -10px;
        background: #000;
        color: #fff;
        font-size: 0.58rem;
        font-weight: 700;
        min-width: 17px;
        height: 17px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 3px;
        line-height: 1;
    }
    .nav-badge[data-count="0"] { display: none; }

    @media (max-width: 768px) {
        .labass-navbar { padding: 20px 24px; }
        .labass-navbar nav { gap: 18px; }
    }
</style>

<header class="labass-navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">LABASS.</a>
    <nav>
        <a href="${pageContext.request.contextPath}/shop">Shop</a>

        <%-- Favoris --%>
        <a href="${pageContext.request.contextPath}/favorites" class="nav-icon-wrap" title="Favoris">
            <i class="fa-regular fa-heart"></i>
            <span class="nav-badge" id="favBadge" data-count="<%= favCount %>">
                <%= favCount > 0 ? favCount : "" %>
            </span>
        </a>

        <%-- Compte --%>
        <a href="${pageContext.request.contextPath}/<%= navUser != null ? "profile.jsp" : "login.jsp" %>"
           title="<%= navUser != null ? navUser.getFullName() : "Connexion" %>">
            <i class="fa-regular fa-user"></i>
        </a>

        <%-- Panier --%>
        <a href="${pageContext.request.contextPath}/cart" class="nav-icon-wrap" title="Panier">
            <i class="fa-solid fa-bag-shopping"></i>
            <span class="nav-badge" id="cartBadge" data-count="<%= cartCount %>">
                <%= cartCount > 0 ? cartCount : "" %>
            </span>
        </a>
    </nav>
</header>
