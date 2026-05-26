<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.labassaplication.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le profil | Labass</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: #fff;
            color: #000;
        }

        .page-wrapper {
            max-width: 700px;
            margin: 80px auto;
            padding: 0 40px;
        }

        .logo {
            font-family: 'Cinzel', serif;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: #000;
            display: block;
            margin-bottom: 60px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            border-bottom: 1px solid #000;
            padding-bottom: 20px;
            margin-bottom: 40px;
        }

        .page-header h1 {
            font-family: 'Cinzel', serif;
            font-size: 2rem;
        }

        .page-header a {
            font-size: 0.8rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #000;
            text-decoration: none;
            border-bottom: 1px solid #000;
        }

        .msg {
            padding: 12px 0;
            margin-bottom: 24px;
            font-size: 0.9rem;
        }
        .msg-error   { color: #c0392b; border-bottom: 1px solid #c0392b; }
        .msg-success { color: #27ae60; border-bottom: 1px solid #27ae60; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 40px;
        }

        .form-field {
            margin-bottom: 30px;
        }

        .form-field.full {
            grid-column: 1 / -1;
        }

        .form-field label {
            font-size: 0.75rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #999;
            display: block;
            margin-bottom: 8px;
        }

        .form-field input {
            width: 100%;
            padding: 12px 0;
            border: none;
            border-bottom: 1px solid #ddd;
            outline: none;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            background: transparent;
            transition: border-color 0.2s;
        }

        .form-field input:focus {
            border-bottom-color: #000;
        }

        .divider {
            grid-column: 1 / -1;
            border: none;
            border-top: 1px solid #eee;
            margin: 10px 0 30px;
        }

        .section-label {
            grid-column: 1 / -1;
            font-size: 0.75rem;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #999;
            margin-bottom: 10px;
        }

        .actions {
            grid-column: 1 / -1;
            display: flex;
            gap: 20px;
            align-items: center;
            margin-top: 20px;
        }

        .btn-save {
            padding: 16px 50px;
            background: #000;
            color: #fff;
            border: none;
            cursor: pointer;
            letter-spacing: 2px;
            font-size: 0.85rem;
            text-transform: uppercase;
            font-family: 'Inter', sans-serif;
        }

        .btn-save:hover {
            background: #222;
        }

        .btn-cancel {
            font-size: 0.85rem;
            letter-spacing: 1px;
            color: #999;
            text-decoration: none;
            border-bottom: 1px solid #ccc;
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .page-wrapper { padding: 0 20px; }
            .form-field.full { grid-column: 1; }
            .actions { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>

<div class="page-wrapper">

    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">LABASS.</a>

    <div class="page-header">
        <h1>Modifier le profil</h1>
        <a href="${pageContext.request.contextPath}/profile.jsp">← Retour</a>
    </div>

    <%-- Messages --%>
    <% if (request.getAttribute("error") != null) { %>
        <p class="msg msg-error">${error}</p>
    <% } %>
    <% if ("true".equals(request.getParameter("updated"))) { %>
        <p class="msg msg-success">Profil mis à jour avec succès.</p>
    <% } %>

    <%-- PROFILE EDIT FORM --%>
    <form action="${pageContext.request.contextPath}/edit-profile" method="post">
        <div class="form-grid">

            <%-- Contact info --%>
            <div class="form-field full">
                <label>Téléphone</label>
                <input type="tel" name="phone" placeholder="+212 6XX XXX XXX"
                       value="<%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "" %>">
            </div>

            <div class="form-field full">
                <label>Adresse</label>
                <input type="text" name="address" placeholder="Rue, numéro..."
                       value="<%= loggedUser.getAddress() != null ? loggedUser.getAddress() : "" %>">
            </div>

            <div class="form-field">
                <label>Ville</label>
                <input type="text" name="city" placeholder="Casablanca"
                       value="<%= loggedUser.getCity() != null ? loggedUser.getCity() : "" %>">
            </div>

            <div class="form-field">
                <label>Pays</label>
                <input type="text" name="country" placeholder="Maroc"
                       value="<%= loggedUser.getCountry() != null ? loggedUser.getCountry() : "" %>">
            </div>

            <%-- Password section --%>
            <hr class="divider">
            <p class="section-label">Changer le mot de passe</p>

            <div class="form-field">
                <label>Nouveau mot de passe</label>
                <input type="password" name="newPassword" placeholder="Laisser vide pour ne pas changer">
            </div>

            <div class="form-field">
                <label>Confirmer le mot de passe</label>
                <input type="password" name="confirmPassword" placeholder="Répéter le nouveau mot de passe">
            </div>

            <%-- Actions --%>
            <div class="actions">
                <button type="submit" class="btn-save">ENREGISTRER</button>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="btn-cancel">Annuler</a>
            </div>

        </div>
    </form>

</div>

</body>
</html>
