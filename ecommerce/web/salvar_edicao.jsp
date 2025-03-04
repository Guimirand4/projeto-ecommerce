<%@page import="java.sql.*, org.mindrot.jbcrypt.BCrypt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salvar Edição</title>
</head>
<body>
    <%
        String id = request.getParameter("id");
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String grupo = request.getParameter("grupo");
        String status = request.getParameter("status");

        // Conexão com o banco de dados
        String url = "jdbc:sqlite:" + application.getRealPath("/WEB-INF/ecommerce.sqlite");
        Connection conecta = null;
        PreparedStatement st = null;

        try {
            // Conectar ao banco de dados
            Class.forName("org.sqlite.JDBC");
            conecta = DriverManager.getConnection(url);

            // SQL para atualizar os dados do usuário (não altera senha nem CPF)
            String sql = "UPDATE usuarios SET nome = ?, email = ?, grupo = ?, status = ? WHERE id = ?";
            st = conecta.prepareStatement(sql);
            st.setString(1, nome);
            st.setString(2, email);
            st.setString(3, grupo);
            st.setString(4, status);
            st.setInt(5, Integer.parseInt(id));

            // Executar a atualização
            int resultado = st.executeUpdate();

            if (resultado > 0) {
                out.println("<p>Dados do usuário atualizados com sucesso!</p>");
            } else {
                out.println("<p>Erro ao atualizar dados do usuário.</p>");
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
