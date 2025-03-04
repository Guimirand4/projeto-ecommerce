<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String url = "jdbc:sqlite:" + application.getRealPath("/WEB-INF/ecommerce.sqlite");
    Connection conecta = null;
    PreparedStatement st = null;
    ResultSet rs = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conecta = DriverManager.getConnection(url);
        String sql = "SELECT id, nome, email, grupo, status FROM usuarios";
        st = conecta.prepareStatement(sql);
        rs = st.executeQuery();

        while (rs.next()) {
            int id = rs.getInt("id");
            String nome = rs.getString("nome");
            String email = rs.getString("email");
            String grupo = rs.getString("grupo");
            String status = rs.getInt("status") == 1 ? "Ativo" : "Inativo";

            out.println("<tr>");
            out.println("<td>" + nome + "</td>");
            out.println("<td>" + email + "</td>");
            out.println("<td>" + grupo + "</td>");
            out.println("<td>" + status + "</td>");
            out.println("<td>");
            // Botão para editar
            out.println("<button onclick='editarUsuario(" + id + ", \"" + nome + "\", \"" + email + "\", \"" + grupo + "\")'>Editar</button>");
            
            // Botão para alterar o status (Ativar/Desativar)
            out.println("<button onclick='alterarStatus(" + id + ", " + (status.equals("Ativo") ? "0" : "1") + ")'>" + (status.equals("Ativo") ? "Desativar" : "Ativar") + "</button>");
            out.println("</td>");
            out.println("</tr>");
        }
    } catch (Exception e) {
        out.println("<p>Erro: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (st != null) try { st.close(); } catch (SQLException e) {}
        if (conecta != null) try { conecta.close(); } catch (SQLException e) {}
    }
%>
