<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect to login if not logged in, else to dashboard
    if (session != null && session.getAttribute("user_id") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
