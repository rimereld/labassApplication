<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmed | LABASS</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .confirmation-page {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 70vh;
            text-align: center;
            padding: 60px;
        }
        .checkmark { font-size: 64px; margin-bottom: 20px; }
        .confirmation-page h2 { font-family: 'Cinzel'; font-size: 32px; margin-bottom: 15px; }
        .confirmation-page p  { color: #666; margin-bottom: 8px; }
        .order-number          { font-weight: bold; color: #896739; font-size: 18px; }
        .btn-home {
            margin-top: 30px;
            padding: 14px 40px;
            background: #000;
            color: #fff;
            border: none;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .btn-home:hover { background: #896739; }
    </style>
</head>
<body>

<header>
    <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration:none;color:inherit;">
        <h1>LABASS.</h1>
    </a>
</header>

<div class="confirmation-page">
    <div class="checkmark">✅</div>
    <h2>Order Confirmed!</h2>
    <p>Thank you for shopping with LABASS.</p>
    <p>Your order number is:</p>
    <p class="order-number">#${param.orderId}</p>
    <p style="margin-top:15px;">You will receive a confirmation soon.</p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">Continue Shopping</a>
</div>

</body>
</html>
