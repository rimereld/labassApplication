<%@ page import="com.labassaplication.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
%>

<%-- In your navbar, replace your static account link with this: --%>
<% if (loggedUser != null) { %>
    <%-- User is logged in → go to profile --%>
    <a href="${pageContext.request.contextPath}/profile.jsp">Mon compte</a>
<% } else { %>
    <%-- Not logged in → go to login page --%>
    <a href="${pageContext.request.contextPath}/login.jsp">Connexion</a>
<% } %>
