<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.labassaplication.model.User" %>
<%
    /* Guard: if not logged in, redirect to login */
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
    <title>Mon Compte | Labass</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400&display=swap" rel="stylesheet">
    <style>
        .profile-wrapper {
            max-width: 700px;
            margin: 80px auto;
            padding: 0 40px;
        }
        .profile-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            border-bottom: 1px solid #000;
            padding-bottom: 20px;
            margin-bottom: 40px;
        }
        .profile-header h1 {
            font-family: 'Cinzel', serif;
            font-size: 2rem;
        }
        .profile-header a.logout {
            font-size: 0.8rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #000;
            text-decoration: none;
            border-bottom: 1px solid #000;
        }
        .profile-logo {
            font-family: 'Cinzel', serif;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: #000;
            display: block;
            margin-bottom: 60px;
        }
        .profile-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px 40px;
        }
        .profile-field label {
            font-size: 0.75rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #999;
            display: block;
            margin-bottom: 6px;
        }
        .profile-field span {
            font-size: 1rem;
            color: #000;
        }
        .profile-field.full {
            grid-column: 1 / -1;
        }
        .edit-btn {
            margin-top: 50px;
            display: inline-block;
            padding: 16px 50px;
            background: #000;
            color: #fff;
            letter-spacing: 2px;
            font-size: 0.85rem;
            text-transform: uppercase;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }
        @media (max-width: 600px) {
            .profile-grid { grid-template-columns: 1fr; }
            .profile-wrapper { padding: 0 20px; }
        }
    </style>
</head>
<body>

<div class="profile-wrapper">

    <a href="${pageContext.request.contextPath}/index.jsp" class="profile-logo">LABASS.</a>

    <div class="profile-header">
        <h1>Mon Compte</h1>
        <a href="${pageContext.request.contextPath}/logout" class="logout">Se déconnecter</a>
    </div>

    <div class="profile-grid">

        <div class="profile-field">
            <label>Nom complet</label>
            <span><%= loggedUser.getFullName() != null ? loggedUser.getFullName() : "—" %></span>
        </div>

        <div class="profile-field">
            <label>Adresse email</label>
            <span><%= loggedUser.getEmail() != null ? loggedUser.getEmail() : "—" %></span>
        </div>

        <div class="profile-field">
            <label>Téléphone</label>
            <span><%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "—" %></span>
        </div>

        <div class="profile-field">
            <label>Ville</label>
            <span><%= loggedUser.getCity() != null ? loggedUser.getCity() : "—" %></span>
        </div>

        <div class="profile-field full">
            <label>Adresse</label>
            <span><%= loggedUser.getAddress() != null ? loggedUser.getAddress() : "—" %></span>
        </div>

        <div class="profile-field">
            <label>Pays</label>
            <span><%= loggedUser.getCountry() != null ? loggedUser.getCountry() : "—" %></span>
        </div>

    </div>

    <%-- Link to an edit-profile page (create later if needed) --%>
    <a href="${pageContext.request.contextPath}/edit-profile.jsp" class="edit-btn">Modifier le profil</a>

</div>

</body>
</html>
