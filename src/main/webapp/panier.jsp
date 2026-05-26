<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.labassaplication.model.CartItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart | LABASS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/panier.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header class="header">
    <a href="${pageContext.request.contextPath}index.jsp" style="text-decoration:none;color:inherit;">
        <h1>LABASS.</h1>
    </a>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}index.jsp">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/shop.jspshop.jsp">Shop</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/login.jspogin.jsp">Account</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/panier.jsp"><i class="fa-solid fa-bag-shopping"></i></a></li>
        </ul>
    </nav>
</header>

<main class="cart-page">
    <h2 class="page-title">Shopping Cart</h2>

    <%
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        Double cartTotal = (Double) request.getAttribute("cartTotal");
        boolean isEmpty = (cartItems == null || cartItems.isEmpty());
    %>

    <%-- EMPTY STATE --%>
    <% if (isEmpty) { %>
    <section class="empty-state">
        <h3>Your cart is empty</h3>
        <p>Discover our latest collection and start adding your favorites.</p>
        <a href="${pageContext.request.contextPath}/WEB-INF/shop.jspshop.jsp">
            <button class="btn-primary">Continue Shopping</button>
        </a>
    </section>
    <% } else { %>

    <section class="cart-layout">

        <%-- LEFT: CART ITEMS --%>
        <div class="cart-items">
            <% for (CartItem item : cartItems) { %>
            <div class="cart-item">
                <img src="${pageContext.request.contextPath}/<%=item.getProduct().getImageUrl()%>"
                     alt="<%=item.getProduct().getName()%>">

                <div class="item-info">
                    <h3><%=item.getProduct().getName()%></h3>
                    <p class="price"><%=(int)item.getProduct().getPrice()%> DH</p>

                    <%-- QUANTITY UPDATE FORM --%>
                    <form method="post" action="${pageContext.request.contextPath}/cart" class="qty">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cartItemId" value="<%=item.getId()%>">
                        <button type="submit" name="quantity" value="<%=item.getQuantity()-1%>" class="minus">-</button>
                        <input type="number" value="<%=item.getQuantity()%>" min="1" readonly>
                        <button type="submit" name="quantity" value="<%=item.getQuantity()+1%>" class="plus">+</button>
                    </form>
                </div>

                <%-- REMOVE BUTTON --%>
                <form method="post" action="${pageContext.request.contextPath}/WEB-INF/panier.jsp">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="cartItemId" value="<%=item.getId()%>">
                    <button type="submit" class="remove">✕</button>
                </form>
            </div>
            <% } %>
        </div>

        <%-- RIGHT: ORDER SUMMARY --%>
        <aside class="summary">
            <h3>Order Summary</h3>

            <% for (CartItem item : cartItems) { %>
            <div class="row">
                <span><%=item.getProduct().getName()%> x<%=item.getQuantity()%></span>
                <span><%=(int)item.getLineTotal()%> DH</span>
            </div>
            <% } %>

            <div class="row">
                <span>Shipping</span>
                <span>Free</span>
            </div>

            <div class="total">
                <span>Total</span>
                <span><%=cartTotal != null ? (int)(double)cartTotal : 0%> DH</span>
            </div>

            <a href="${pageContext.request.contextPath}/WEB-INF/checkout.jspkout.jsp">
                <button class="checkout">Checkout</button>
            </a>
        </aside>

    </section>
    <% } %>

</main>

</body>
</html>
