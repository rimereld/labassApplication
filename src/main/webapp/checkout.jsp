<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.labassaplication.model.CartItem, com.labassaplication.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | LABASS</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">
</head>
<body>

<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    User user = (User) request.getAttribute("user");
%>

<header class="header">
    <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration:none;color:inherit;">
        <h1>LABASS.</h1>
    </a>
</header>

<main class="checkout-page">
    <div class="checkout-layout">

        <%-- LEFT: CHECKOUT FORM → POST to CheckoutServlet --%>
        <section class="checkout-form">
            <h2>Checkout</h2>

            <% if (request.getAttribute("error") != null) { %>
                <p style="color:red;">${error}</p>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/WEB-INF/checkout.jsp">

                <h3>Contact Information</h3>
                <input type="email" name="email" placeholder="Email address"
                       value="<%=user != null ? user.getEmail() : ""%>" required>

                <h3>Shipping Address</h3>
                <input type="text" name="fullName" placeholder="Full name"
                       value="<%=user != null ? user.getFullName() : ""%>" required>
                <input type="text" name="address" placeholder="Address" required>
                <input type="text" name="city" placeholder="City" required>
                <input type="text" name="address2" placeholder="Address line 2 (optional)">

                <div class="row">
                    <input type="text" name="postalCode" placeholder="Postal code">
                    <input type="text" name="country" placeholder="Country">
                </div>
                <input type="tel" name="phone" placeholder="Phone number"
                       value="<%=user != null && user.getPhone() != null ? user.getPhone() : ""%>">

                <h3>Payment Method</h3>
                <div class="payment-methods">
                    <label>
                        <input type="radio" name="paymentMethod" value="card" checked> Card
                    </label>
                    <label>
                        <input type="radio" name="paymentMethod" value="paypal"> PayPal
                    </label>
                    <label>
                        <input type="radio" name="paymentMethod" value="gpay"> Google Pay
                    </label>
                </div>

                <button type="submit" class="place-order">Place Order</button>
            </form>
        </section>

        <%-- RIGHT: ORDER SUMMARY (from cart) --%>
        <aside class="order-summary">
            <h3>Your Order</h3>

            <% if (cartItems != null) {
                for (CartItem item : cartItems) { %>
            <div class="summary-item">
                <span><%=item.getProduct().getName()%> x<%=item.getQuantity()%></span>
                <span><%=(int)item.getLineTotal()%> DH</span>
            </div>
            <% } } %>

            <div class="summary-row">
                <span>Subtotal</span>
                <span><%=cartTotal != null ? (int)(double)cartTotal : 0%> DH</span>
            </div>
            <div class="summary-row">
                <span>Shipping</span>
                <span>Free</span>
            </div>
            <div class="summary-total">
                <span>Total</span>
                <span><%=cartTotal != null ? (int)(double)cartTotal : 0%> DH</span>
            </div>
        </aside>

    </div>
</main>

</body>
</html>
