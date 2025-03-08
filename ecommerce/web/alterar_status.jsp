<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alterar Status</title>
</head>
<body>
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));

        String url = "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10766514";
        String user = "sql10766514";
        String password = "swipjfdGjA";

        Connection conecta = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            // Carrega o driver do MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
             conecta = DriverManager.getConnection(url, user, password);

            // Atualiza o status do usuário
            String sql = "UPDATE usuarios SET status = ? WHERE id = ?";
            st = conecta.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, id);

            int resultado = st.executeUpdate();
            if (resultado > 0) {
                out.println("<p>Status do usuário alterado com sucesso!</p>");
            } else {
                out.println("<p>Erro ao alterar status do usuário.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Erro: " + e.getMessage() + "</p>");
        } finally {
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (conecta != null) try { conecta.close(); } catch (SQLException e) {}
        }
    %>

    <br>
    <a href="listar.html">Voltar para a lista de usuários</a>
</body>
</html>
