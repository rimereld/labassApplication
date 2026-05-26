<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.labassaplication.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - Labass</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%
    Product product = (Product) request.getAttribute("product");
%>

<header>
    <a href="${pageContext.request.contextPath}index.jsp" style="text-decoration:none;color:inherit;">
        <h1>LABASS.</h1>
    </a>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}index.jsp">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/shop.jspshop.jsp">Shop</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/login.jspogin.jsp">Account</a></li>
            <li><a href="${pageContext.request.contextPath}/WEB-INF/panier.jspnier.jsp"><i class="fa-solid fa-bag-shopping"></i></a></li>
        </ul>
    </nav>
</header>

<% if (product != null) { %>

<section class="product-page">

    <%-- IMAGES --%>
    <div class="product-images">
        <img id="mainImg" src="${pageContext.request.contextPath}/<%=product.getImageUrl()%>" alt="<%=product.getName()%>">
        <div class="small-images">
            <img src="${pageContext.request.contextPath}/<%=product.getImageUrl()%>" onclick="document.getElementById('mainImg').src=this.src">
        </div>
    </div>

    <%-- PRODUCT INFO --%>
    <div class="product-info">
        <h2><%=product.getName()%></h2>
        <p class="price"><%=(int)product.getPrice()%> DH</p>
        <p style="color:#888; margin-bottom:10px;">Taille: <%=product.getSize()%> &nbsp;|&nbsp; Marque: <%=product.getBrand()%></p>

        <%-- SIZES (display only — you can extend later) --%>
        <div class="sizes">
            <span class="active"><%=product.getSize()%></span>
        </div>

        <%-- ADD TO CART FORM --%>
        <form method="post" action="${pageContext.request.contextPath}/WEB-INF/panier.jspnier.jsp">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="<%=product.getId()%>">
            <div style="margin-bottom:15px;">
                <label style="font-size:13px;color:#555;">Quantité</label><br>
                <input type="number" name="quantity" value="1" min="1" max="<%=product.getStock()%>">
            </div>
            <button type="submit" class="add-btn">Add to Cart</button>
        </form>

        <p class="desc"><%=product.getDescription()%></p>

        <% if (product.getStock() < 5) { %>
            <p style="color:#c0392b; margin-top:10px; font-size:13px;">
                ⚠ Plus que <%=product.getStock()%> en stock !
            </p>
        <% } %>
    </div>

</section>

<% } else { %>
    <p style="text-align:center; padding:60px;">Produit introuvable.</p>
<% } %>

</body>
</html>
