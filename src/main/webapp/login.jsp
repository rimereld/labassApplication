<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account | Labass</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400&display=swap" rel="stylesheet">
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-visual">
        <video autoplay muted loop playsinline>
            <source src="${pageContext.request.contextPath}/clothing/log-video.mp4" type="video/mp4">
        </video>
    </div>

    <div class="auth-panel">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">LABASS.</a>

        <%-- Show error message if login failed --%>
        <% if (request.getAttribute("error") != null) { %>
            <p style="color:red; margin-bottom:15px;">${error}</p>
        <% } %>

        <%-- Show success message after registration --%>
        <% if ("true".equals(request.getParameter("registered"))) { %>
            <p style="color:green; margin-bottom:15px;">Compte créé ! Connectez-vous.</p>
        <% } %>

        <%-- LOGIN FORM → POST to /login servlet --%>
        <form id="login-form" action="${pageContext.request.contextPath}/WEB-INF/login.jsp" method="post">
            <h2>Connexion</h2>
            <p>Bienvenue chez Labass. Connectez-vous pour continuer.</p>
            <input type="email" name="email" placeholder="Adresse mail" required>
            <input type="password" name="password" placeholder="Mot de passe" required>
            <button type="submit" action="${pageContext.request.contextPath}/login.jsp">SE CONNECTER</button>
            <p class="toggle-text">Pas de compte ? <span onclick="toggleForms()">S'inscrire</span></p>
        </form>

        <%-- REGISTER FORM → POST to /register servlet --%>
        <form id="signup-form" action="${pageContext.request.contextPath}/register" method="post" style="display:none;">
            <h2>Créer un compte</h2>
            <p>Rejoignez la famille Labass.</p>
            <input type="text" name="fullName" placeholder="Nom complet" required>
            <input type="email" name="email" placeholder="Adresse email" required>
            <input type="password" name="password" placeholder="Mot de passe" required>
            <button type="submit">S'INSCRIRE</button>
            <p class="toggle-text">Déjà membre ? <span onclick="toggleForms()">Se connecter</span></p>
        </form>
    </div>
</div>

<script>
    function toggleForms() {
        const loginForm  = document.getElementById('login-form');
        const signupForm = document.getElementById('signup-form');
        loginForm.style.display  = (loginForm.style.display  === 'none') ? 'block' : 'none';
        signupForm.style.display = (signupForm.style.display === 'none') ? 'block' : 'none';
    }
</script>

</body>
</html>
